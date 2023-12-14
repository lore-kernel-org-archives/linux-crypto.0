Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Nx8A5Cj4"
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF9B123
	for <linux-crypto@vger.kernel.org>; Wed, 13 Dec 2023 23:23:02 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-3360ae1b937so3991584f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Dec 2023 23:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702538581; x=1703143381; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QgvQhhxVq/mUdmmBeJBOxvDW1o7cO+i18dm4xGgW5TI=;
        b=Nx8A5Cj4Nqp48p99bnhDFgonIKAvZnsJ9C7HNEzNk2mdBC5q7NzhK+yNR1EhURDkpC
         /aaZBC4h2dYKwA2ArS5F65SjSVfUaafmLMKk4Z2eTi3nEx1VfoHgrmyRwn2m4FglCHdH
         M7lOkmZkeuDPO4BT019wfBXiODiGHX0V3AtLBDneaFjOqr4n48tca9KOM5sSUZK3MMlJ
         E1kuLB4OoPBiGkq00DiMQsTv5r15PdPxFxH+lnIVJK63kn0ixLXlkHks3Wqq6L89DVrz
         CSujYxH9xXlBW2so/4YVUUvuD+4X9mCGegTHCecwTt9NwvNV5Ce5lWvz6XZYHLL6jvOQ
         XNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702538581; x=1703143381;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QgvQhhxVq/mUdmmBeJBOxvDW1o7cO+i18dm4xGgW5TI=;
        b=avx5BNoEKf6agO4UiqGcW+9gRNngDbtJ+IN9MnvnQiEfgFe62V9XYkLSFFvkwxT6oQ
         M6oEGGEj5zRXs0FoZFuZXM8jgWDPeYKxXcf8y5dcxiQoA+rKO2WP8tRjSNTvReaMNLmm
         niH5dtOHNd18CY39h1lsmWwHWrIIqLMYjQobJ7xmv18wNae+o0kj1OIAO1i4rLxX2E/b
         7UDt5oSd/2LFLy6eNYw+NpkRztWohEa+l8fRdlnDPxvFrgNw3CRFgsAWqMTO01r6CDkz
         IYeI0TknjhVtP9+bqDDJyh4wgv8JTkI1lLrk3A5Ww+tVa2PuajnBpX4VJ4VgrJFueRj+
         Bulw==
X-Gm-Message-State: AOJu0YzkV5D7HMdjTvu4oxC8NCLQYjYH3Uz1M+Vmi4AGXwKR0BQjKs1l
	zrnfxIemd2RhKEr/MIvPE9L+mA==
X-Google-Smtp-Source: AGHT+IGSp4qFL5vXSo3hXTm7XdpZrqVe73+sMA7C+igGEQ4ys0GpJsk6QOTo670+HQ82YYGdr5v0fg==
X-Received: by 2002:adf:e485:0:b0:336:38cd:9aff with SMTP id i5-20020adfe485000000b0033638cd9affmr1207889wrm.104.1702538581276;
        Wed, 13 Dec 2023 23:23:01 -0800 (PST)
Received: from [192.168.1.20] ([178.197.218.27])
        by smtp.gmail.com with ESMTPSA id m1-20020adfa3c1000000b003364ad1c20esm74776wrb.0.2023.12.13.23.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 23:23:00 -0800 (PST)
Message-ID: <5bc96a31-8869-483c-9427-1f4a90263874@linaro.org>
Date: Thu, 14 Dec 2023 08:22:59 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] arm64: dts: qcom: sc7280: add QCrypto nodes
Content-Language: en-US
To: Om Prakash Singh <quic_omprsing@quicinc.com>
Cc: neil.armstrong@linaro.org, konrad.dybcio@linaro.org, agross@kernel.org,
 andersson@kernel.org, conor+dt@kernel.org, davem@davemloft.net,
 devicetree@vger.kernel.org, herbert@gondor.apana.org.au,
 krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 marijn.suijten@somainline.org, robh+dt@kernel.org, vkoul@kernel.org
References: <20231212133247.1366698-1-quic_omprsing@quicinc.com>
 <20231212133247.1366698-3-quic_omprsing@quicinc.com>
 <c848f874-3748-4d59-8e78-9ae044fb760a@linaro.org>
 <6b79c66d-7591-443b-92e5-beeff6c93ae4@quicinc.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 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
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <6b79c66d-7591-443b-92e5-beeff6c93ae4@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/12/2023 06:41, Om Prakash Singh wrote:
> 
> 
> On 12/12/2023 8:32 PM, Krzysztof Kozlowski wrote:
>> On 12/12/2023 14:32, Om Prakash Singh wrote:
>>> Add the QCE and Crypto BAM DMA nodes.
>>>
>>> Signed-off-by: Om Prakash Singh <quic_omprsing@quicinc.com>
>>> ---
>>>
>>> Changes in V2:
>>>    - Update DT node sequence as per register ascending order
>>
>> Hm, I don't see it...
>>
>>>    - Fix DT node properties as per convention
>>>
>>>   arch/arm64/boot/dts/qcom/sc7280.dtsi | 22 ++++++++++++++++++++++
>>>   1 file changed, 22 insertions(+)
>>>
>>> diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
>>> index 66f1eb83cca7..7b705df21f4e 100644
>>> --- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
>>> +++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
>>> @@ -2272,6 +2272,28 @@ ipa: ipa@1e40000 {
>>>   			status = "disabled";
>>>   		};
>>>   
>>> +		cryptobam: dma-controller@1dc4000 {
>>
>> It still looks like not correctly ordered by unit address against other
>> nodes in the file.
>>
> 
> Hi Krzysztof,
> Probably I am missing something basic here. I am trying to put entries 
> addresses that are sorted wrt their current adjacent.
> 
> And it looks fine to me.
> 
> 1c0e000 (current exist)
> 1dc4000 (newly added)
> 1dfa000	(newly added)
> 1e40000	(current exist)

Then why the diff shows:
@@ -2272,6 +2272,28 @@ ipa: ipa@1e40000 {
above your changes?

Best regards,
Krzysztof

