--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 1000 -- ms between visualization steps for demonstration purpose

-- Create a viewer
local viewer = View.create()

-- Load a network from resources
local net = Object.load('resources/cereal_net.json') -- This will be a MachineLearning.DeepNeuralNetwork.Model instance
print(MachineLearning.DeepNeuralNetwork.Model.toString(net))

-- Create a inference engine instance
local dnn = MachineLearning.DeepNeuralNetwork.create()

-- Create a text decoration for the presentation in the viewer
local textDeco = View.TextDecoration.create()
textDeco:setSize(8):setPosition(3, 8):setColor(0, 255, 0)
--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

--- Load the images in the resources/images folder and return an array
---@return Image[]
local function loadImages()
  local flakeImage = Image.load('resources/images/corn_flakes.png')
  local puffImage = Image.load('resources/images/oat_squares.png')
  local branImage = Image.load('resources/images/bran_flakes.png')
  return {flakeImage, puffImage, branImage}
end

--- Show the image in the viewer and also display the predicted label and the confidence of the prediction
---@param image Image
---@param label string
---@param confidence float
local function showResultInViewer(image, label, confidence)
  viewer:clear()
  viewer:addImage(image)
  viewer:addText(
    string.format('Class: %s,\nConfidence: %0.1f%%', label, confidence * 100),
    textDeco
  )
  viewer:present()
end

local function main()
  dnn:setModel(net) -- Load the network into the engine
  local image_list = loadImages() -- Load the images to give to the network
  for img_nr, image in ipairs(image_list) do
    dnn:setInputImage(image) -- Load the image for the network
    local result = dnn:predict() -- Run the network on the image

    -- Parse the result as a classification output
    local predicted_class_idx, pred_confidence, pred_label = result:getAsClassification()

    -- Print the result to the console
    print(
      string.format(
        'Image %i was classified as %i: %s with %.01f %% confidence',
        img_nr, predicted_class_idx, pred_label, pred_confidence * 100
      )
    )

    -- Send the result to the viewer
    showResultInViewer(image, pred_label, pred_confidence)
    Script.sleep(DELAY)
  end
  print('App finished.')
end
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope--------------------------------------------------
