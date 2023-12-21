from vllm import LLM, SamplingParams
model='davidkim205/komt-mistral-7b-v1'
llm = LLM(model=model, tensor_parallel_size=1)


def gen(x):
    text = f"### instruction: {x}\n\n### Response: "
    stop_tokens = ["USER:", "USER", "ASSISTANT:", "ASSISTANT"]
    sampling_params = SamplingParams(temperature=0.5, top_p=1, max_tokens=2048, stop=stop_tokens)
    completions = llm.generate([text], sampling_params)
    for output in completions:
        generated_text = output.outputs[0].text
        print(f"Prompt: {output.prompt!r}, Generated text: {generated_text!r}")
        # breakpoint()
while True:
    text = input('>')
    gen(text)