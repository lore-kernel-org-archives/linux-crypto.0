Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DDC187548
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 07:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718608603; cv=none; b=PTPE2dvLAd/eQyIT+Dl9fJs7M5kngHNSRWRS/qsvMCA59FEcUuVqsK03lGf3x72H10B2RQ33TivV9AChlPyInTdrJTp+kgqIywKuDPPjFPkk7GrDITpozzfVceAtTCNcVUbrrzcIwY5r8pamfl4kF4Cx6YLDKrykDdmSJZXwxXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718608603; c=relaxed/simple;
	bh=4Q75hx3NMPqP3RiCyaXM5QYUoSGlpvRDl5P1+SzDraQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mzwrcb7+2H3r/+ay4JoB1ecPSbyCeWlsVI26UusFLb8ydsfBL1V0dad6UFNwCeLS8OvXPCEAZyyyTBem8y0jCgkgKXA4f5/rncO5wzai1b4pfXzScarlESM508ddUNwe7I9p3Q8HsWshl3dXB6BGkW32URZfIF7LV03mkI056zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NxOt3/XG; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NxOt3/XG"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-57cbc2a2496so3930901a12.0
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 00:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718608600; x=1719213400; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BJmInpMHTh6cMrM70EXCRVJ39PnOorFE9MKZ/AMhJck=;
        b=NxOt3/XG6WBRX+DA+plrVMb5MVZJK+uo7ibrs0j5nxdkmGf3hqFIRoKfweTJKIw1mb
         6WWGgYLpydn/hDDd+rctEsgEawc9RMdFp/m3bxAPiqB+QAnE01TeQtadUjVrLhLDwKKJ
         FNXSXNzy2mlJl96j3wO5nRUN0nbVIj8nsuJ2UYYM9dwKKOMjDztYy2AybxJ15GBUJ7HH
         lww/M43RmQHUu56y/E4MpD/9Pw8xEdJhQgA3kr+d5xKjbgIvLmh6SyuJibU6jGQZiLJ8
         SZQr0B+vgfFczEIZsW8n9sxwHsWRaGp0Fp8+TKNQUm+UF62geZblr1psbArmF36M2aFh
         IIqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718608600; x=1719213400;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BJmInpMHTh6cMrM70EXCRVJ39PnOorFE9MKZ/AMhJck=;
        b=tZnIfvmfpr8+9pi58Ip4GCxW+1/BoxPSDWwvAn6rn6VJRLp6e7KSfSck7CLGs+GlPd
         mIRmZU1yeUvn5mGFAu3EX+Fn5cqbhBe6sBYE/1nNc13yEzOpYHpxFMGF+4KsmiAHuI7i
         AXvCBNUySvzWI1h6JT3HpBxBxCRr1ZB3HkvFB3a7I5sRwWcnIrqjg6P2p8H4j3FVrkTx
         oRcM54E4lolhAAYkA0/vnnGxvER588r6U3WYQw+iQc8RmjjI8TdlkgMOmEpBrLxTraj4
         dM9789ThrVFsxjpc9tw4Y/ktIOZdBwcgEP1ekU2zenIQOhphBS8lX6huCWD4oCLlU8eO
         bFbA==
X-Forwarded-Encrypted: i=1; AJvYcCVOyHH7IAVkq667XCDNtoy0gw+3YiveiDc+JRYGTag1pztBgUvZowY3X6euqv0GUJB8egazyRzGKUA/Y7Fxayx1Phitu2haPVzGO4sG
X-Gm-Message-State: AOJu0YxEusMYUKmQAHR3JCpZK7seSS30rU9dd8U5iO/uym7pOx84eNH3
	LFxsutF+HeTtxQ/cX0YHGT8i4WePLVSqyDukaKyJb2zn20lKdPwvYAQW2waOoXI=
X-Google-Smtp-Source: AGHT+IEuUTXEuZiPLoNBmSWB0lfe3ZIMV2zPASGP2oO5PxwGNRkbJ6ubW5FJQYuqb/Q5/A0xCWJpDg==
X-Received: by 2002:aa7:c419:0:b0:57c:cba1:444e with SMTP id 4fb4d7f45d1cf-57ccba144dbmr4819619a12.13.1718608599984;
        Mon, 17 Jun 2024 00:16:39 -0700 (PDT)
Received: from [192.168.0.18] ([78.10.207.147])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57cb72e9943sm6030495a12.51.2024.06.17.00.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 00:16:39 -0700 (PDT)
Message-ID: <a9d8606d-fb4a-4394-bab6-3304e1f8b9e5@linaro.org>
Date: Mon, 17 Jun 2024 09:16:37 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 13/15] dt-bindings: crypto: ice: document the hwkm
 property
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>,
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 andersson@kernel.org, ebiggers@google.com, neil.armstrong@linaro.org,
 srinivas.kandagatla@linaro.org, krzysztof.kozlowski+dt@linaro.org,
 conor+dt@kernel.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
 kernel@quicinc.com, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, quic_omprsing@quicinc.com,
 quic_nguyenb@quicinc.com, bartosz.golaszewski@linaro.org,
 konrad.dybcio@linaro.org, ulf.hansson@linaro.org, jejb@linux.ibm.com,
 martin.petersen@oracle.com, mani@kernel.org, davem@davemloft.net,
 herbert@gondor.apana.org.au, psodagud@quicinc.com, quic_apurupa@quicinc.com,
 sonalg@quicinc.com
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-14-quic_gaurkash@quicinc.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Language: en-US
Autocrypt: addr=krzysztof.kozlowski@linaro.org; keydata=
 xsFNBFVDQq4BEAC6KeLOfFsAvFMBsrCrJ2bCalhPv5+KQF2PS2+iwZI8BpRZoV+Bd5kWvN79
 cFgcqTTuNHjAvxtUG8pQgGTHAObYs6xeYJtjUH0ZX6ndJ33FJYf5V3yXqqjcZ30FgHzJCFUu
 JMp7PSyMPzpUXfU12yfcRYVEMQrmplNZssmYhiTeVicuOOypWugZKVLGNm0IweVCaZ/DJDIH
 gNbpvVwjcKYrx85m9cBVEBUGaQP6AT7qlVCkrf50v8bofSIyVa2xmubbAwwFA1oxoOusjPIE
 J3iadrwpFvsZjF5uHAKS+7wHLoW9hVzOnLbX6ajk5Hf8Pb1m+VH/E8bPBNNYKkfTtypTDUCj
 NYcd27tjnXfG+SDs/EXNUAIRefCyvaRG7oRYF3Ec+2RgQDRnmmjCjoQNbFrJvJkFHlPeHaeS
 BosGY+XWKydnmsfY7SSnjAzLUGAFhLd/XDVpb1Een2XucPpKvt9ORF+48gy12FA5GduRLhQU
 vK4tU7ojoem/G23PcowM1CwPurC8sAVsQb9KmwTGh7rVz3ks3w/zfGBy3+WmLg++C2Wct6nM
 Pd8/6CBVjEWqD06/RjI2AnjIq5fSEH/BIfXXfC68nMp9BZoy3So4ZsbOlBmtAPvMYX6U8VwD
 TNeBxJu5Ex0Izf1NV9CzC3nNaFUYOY8KfN01X5SExAoVTr09ewARAQABzTRLcnp5c3p0b2Yg
 S296bG93c2tpIDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+wsGUBBMBCgA+FiEE
 m9B+DgxR+NWWd7dUG5NDfTtBYpsFAmI+BxMCGwMFCRRfreEFCwkIBwIGFQoJCAsCBBYCAwEC
 HgECF4AACgkQG5NDfTtBYptgbhAAjAGunRoOTduBeC7V6GGOQMYIT5n3OuDSzG1oZyM4kyvO
 XeodvvYv49/ng473E8ZFhXfrre+c1olbr1A8pnz9vKVQs9JGVa6wwr/6ddH7/yvcaCQnHRPK
 mnXyP2BViBlyDWQ71UC3N12YCoHE2cVmfrn4JeyK/gHCvcW3hUW4i5rMd5M5WZAeiJj3rvYh
 v8WMKDJOtZFXxwaYGbvFJNDdvdTHc2x2fGaWwmXMJn2xs1ZyFAeHQvrp49mS6PBQZzcx0XL5
 cU9ZjhzOZDn6Apv45/C/lUJvPc3lo/pr5cmlOvPq1AsP6/xRXsEFX/SdvdxJ8w9KtGaxdJuf
 rpzLQ8Ht+H0lY2On1duYhmro8WglOypHy+TusYrDEry2qDNlc/bApQKtd9uqyDZ+rx8bGxyY
 qBP6bvsQx5YACI4p8R0J43tSqWwJTP/R5oPRQW2O1Ye1DEcdeyzZfifrQz58aoZrVQq+innR
 aDwu8qDB5UgmMQ7cjDSeAQABdghq7pqrA4P8lkA7qTG+aw8Z21OoAyZdUNm8NWJoQy8m4nUP
 gmeeQPRc0vjp5JkYPgTqwf08cluqO6vQuYL2YmwVBIbO7cE7LNGkPDA3RYMu+zPY9UUi/ln5
 dcKuEStFZ5eqVyqVoZ9eu3RTCGIXAHe1NcfcMT9HT0DPp3+ieTxFx6RjY3kYTGLOwU0EVUNc
 NAEQAM2StBhJERQvgPcbCzjokShn0cRA4q2SvCOvOXD+0KapXMRFE+/PZeDyfv4dEKuCqeh0
 hihSHlaxTzg3TcqUu54w2xYskG8Fq5tg3gm4kh1Gvh1LijIXX99ABA8eHxOGmLPRIBkXHqJY
 oHtCvPc6sYKNM9xbp6I4yF56xVLmHGJ61KaWKf5KKWYgA9kfHufbja7qR0c6H79LIsiYqf92
 H1HNq1WlQpu/fh4/XAAaV1axHFt/dY/2kU05tLMj8GjeQDz1fHas7augL4argt4e+jum3Nwt
 yupodQBxncKAUbzwKcDrPqUFmfRbJ7ARw8491xQHZDsP82JRj4cOJX32sBg8nO2N5OsFJOcd
 5IE9v6qfllkZDAh1Rb1h6DFYq9dcdPAHl4zOj9EHq99/CpyccOh7SrtWDNFFknCmLpowhct9
 5ZnlavBrDbOV0W47gO33WkXMFI4il4y1+Bv89979rVYn8aBohEgET41SpyQz7fMkcaZU+ok/
 +HYjC/qfDxT7tjKXqBQEscVODaFicsUkjheOD4BfWEcVUqa+XdUEciwG/SgNyxBZepj41oVq
 FPSVE+Ni2tNrW/e16b8mgXNngHSnbsr6pAIXZH3qFW+4TKPMGZ2rZ6zITrMip+12jgw4mGjy
 5y06JZvA02rZT2k9aa7i9dUUFggaanI09jNGbRA/ABEBAAHCwXwEGAEKACYCGwwWIQSb0H4O
 DFH41ZZ3t1Qbk0N9O0FimwUCYDzvagUJFF+UtgAKCRAbk0N9O0Fim9JzD/0auoGtUu4mgnna
 oEEpQEOjgT7l9TVuO3Qa/SeH+E0m55y5Fjpp6ZToc481za3xAcxK/BtIX5Wn1mQ6+szfrJQ6
 59y2io437BeuWIRjQniSxHz1kgtFECiV30yHRgOoQlzUea7FgsnuWdstgfWi6LxstswEzxLZ
 Sj1EqpXYZE4uLjh6dW292sO+j4LEqPYr53hyV4I2LPmptPE9Rb9yCTAbSUlzgjiyyjuXhcwM
 qf3lzsm02y7Ooq+ERVKiJzlvLd9tSe4jRx6Z6LMXhB21fa5DGs/tHAcUF35hSJrvMJzPT/+u
 /oVmYDFZkbLlqs2XpWaVCo2jv8+iHxZZ9FL7F6AHFzqEFdqGnJQqmEApiRqH6b4jRBOgJ+cY
 qc+rJggwMQcJL9F+oDm3wX47nr6jIsEB5ZftdybIzpMZ5V9v45lUwmdnMrSzZVgC4jRGXzsU
 EViBQt2CopXtHtYfPAO5nAkIvKSNp3jmGxZw4aTc5xoAZBLo0OV+Ezo71pg3AYvq0a3/oGRG
 KQ06ztUMRrj8eVtpImjsWCd0bDWRaaR4vqhCHvAG9iWXZu4qh3ipie2Y0oSJygcZT7H3UZxq
 fyYKiqEmRuqsvv6dcbblD8ZLkz1EVZL6djImH5zc5x8qpVxlA0A0i23v5QvN00m6G9NFF0Le
 D2GYIS41Kv4Isx2dEFh+/Q==
In-Reply-To: <20240617005825.1443206-14-quic_gaurkash@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 17/06/2024 02:51, Gaurav Kashyap wrote:
> +  qcom,ice-use-hwkm:
> +    type: boolean
> +    description:
> +      Use the supported Hardware Key Manager (HWKM) in Qualcomm ICE
> +      to support wrapped keys. Having this entry helps scenarios where
> +      the ICE hardware supports HWKM, but the Trustzone firmware does
> +      not have the full capability to use this HWKM and support wrapped
> +      keys. Not having this entry enabled would make ICE function in
> +      non-HWKM mode supporting standard keys.

No changelog, previous comments and discussion ignored.

NAK

Best regards,
Krzysztof

