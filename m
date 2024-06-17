Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529831891C1
	for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 17:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718646065; cv=none; b=STc3vYLDdAT22HcOsZk8wl5L4oAaKmmYWqRu5VewO4XTyqeY3+R2VTb7owh3KssPCYtnvx+Bg64sz7lg0p6F6N9R2iDzuQjkd8almQkMeftAO2KMOrxHdWhnNOQHvzlO6SjgztPi8wZjsNDYwX37nTBNj2fgkEx9/HYiWpFIP7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718646065; c=relaxed/simple;
	bh=BJmjf1LIJNYCuuytinW9Y7On5XMCJcBh1ACpNVOQGkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TfKCjhijaPf54JOiNiVYON3yf+VtbNyy5s2LNK7hkDiG9Us32gFjwQTHbvhP/6pmYzmIgzArMCUh5sex89wG3K1moFWP+3mwDNNdjwgzkbrWKXrUikER+hb1hs+qXHg05Iwd/+aiZ+LBbG4fAzaB7ZzokOop1r052TN8sc6mNW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Suxbqy0a; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Suxbqy0a"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-52c84a21b8cso4248595e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 17 Jun 2024 10:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718646061; x=1719250861; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kq55y/PD/L2nMZHKqMLWBSD0lhW7pm3VII5rKQRtysY=;
        b=Suxbqy0a6gJYIar7V+oGzroQQazJF3njkhRUGggw0GgXW/PCmBWfXHvkkXJEhPBXS2
         Qgh/+IqrXB54HHfeMiZgoPL7Hk3ehlueEhqQ0aDqu84fliDh9wxKwzRUTh2nsqeTi0VD
         /2xWrQM/YU3Rn6TN7V/a8IlfZEH1G9KILj192xb+uDuo4B6ac2LAqKlf+SDIqUgnTGz/
         bf63fTdYv9nfQYBK12Yil/u+UUVIKlXvP7JdI26Cp8JUGG1fVaw/qg16zPiGTAjF91Gt
         aujh8QuJkPbjkLtTVoJkwFUndW0ip+G/sQB9jgN0oFNLVRugD+WEWOmhYFtgrKC9oiwM
         GhhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718646061; x=1719250861;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kq55y/PD/L2nMZHKqMLWBSD0lhW7pm3VII5rKQRtysY=;
        b=K0l4cgLa/0c2Vlir6lC7XU7XXmv3o2tf2ebfcZ0blppuc6IQIU7y14KrsF3H/O6JOa
         cGAZnojJn6Io2QP/+R4CmAN2uKLPXrwVcYdfJOypvXLeQRJY3lYn44xzXxovEpVBM3YQ
         906ZbRY8Iz2MfQgk6aPcxmZjuP8q6PBJrKWwRnD4HS9F9pX3FJ7Id9r4U2xZf6NIWed9
         XtsxUC5QYfiRMGyC/OwqLg5rKhjlkGvAGFYT6M2BPs4E5ZhwRfzWlcAAFgeXCTvZ8Fyu
         2DCKxgxONKwNlXl2VYei7vwS0RlK4OgiH+fwBCSb1asA+uTVfXvpJFjSZFmU2Z/lzBNj
         RIRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHVRHWSzbvU1tF/ng9C6CgQz9uWJ6rQs7h3ywixyah/EP5Ic4XKm9ZeDkBuUM+D4IHChmNzQm2FGlkR5tRja6OUwnHuIcpm2fm0Rjp
X-Gm-Message-State: AOJu0YxecHBdmBnlls5jrj7FvIivE9AUhp37yDOSYw1WXTmV5F3rW9ON
	vhbXYj3Dw59RVPScOh8CwCnxpaUlRvziKUNVdXHNEdz/XsNro04HFyVv1zp9Fao=
X-Google-Smtp-Source: AGHT+IG18Zlf67kY/yuR4GVWFWSjflpDP80nHZFVDBocWaJkmiI0R8aIiaA+Q2WHlGH6FufaNEOBCw==
X-Received: by 2002:a05:6512:402a:b0:52c:b196:ea37 with SMTP id 2adb3069b0e04-52cc4767572mr130908e87.0.1718646060728;
        Mon, 17 Jun 2024 10:41:00 -0700 (PDT)
Received: from ?IPV6:2a00:f41:cb2:a9df:20fa:cfbe:9ea6:1fe8? ([2a00:f41:cb2:a9df:20fa:cfbe:9ea6:1fe8])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52cc477f19bsm28297e87.224.2024.06.17.10.40.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jun 2024 10:41:00 -0700 (PDT)
Message-ID: <00090117-d765-4f52-abe0-f8bddc980c75@linaro.org>
Date: Mon, 17 Jun 2024 19:40:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/15] arm64: dts: qcom: sm8650: add hwkm support to
 ufs ice
To: neil.armstrong@linaro.org, Gaurav Kashyap <quic_gaurkash@quicinc.com>,
 linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
 andersson@kernel.org, ebiggers@google.com, srinivas.kandagatla@linaro.org,
 krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
 kernel@quicinc.com, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, quic_omprsing@quicinc.com,
 quic_nguyenb@quicinc.com, bartosz.golaszewski@linaro.org,
 ulf.hansson@linaro.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
 mani@kernel.org, davem@davemloft.net, herbert@gondor.apana.org.au,
 psodagud@quicinc.com, quic_apurupa@quicinc.com, sonalg@quicinc.com
References: <20240617005825.1443206-1-quic_gaurkash@quicinc.com>
 <20240617005825.1443206-15-quic_gaurkash@quicinc.com>
 <109b1e46-f46f-4636-87d5-66266e04ccff@linaro.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@linaro.org>
In-Reply-To: <109b1e46-f46f-4636-87d5-66266e04ccff@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/17/24 10:28, neil.armstrong@linaro.org wrote:
> Hi,
> 
> On 17/06/2024 02:51, Gaurav Kashyap wrote:
>> The Inline Crypto Engine (ICE) for UFS/EMMC supports the
>> Hardware Key Manager (HWKM) to securely manage storage
>> keys. Enable using this hardware on sm8650.
>>
>> This requires two changes:
>> 1. Register size increase: HWKM is an additional piece of hardware
>>     sitting alongside ICE, and extends the old ICE's register space.
>> 2. Explicitly tell the ICE driver to use HWKM with ICE so that
>>     wrapped keys are used in sm8650.
>>
>> Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
>> Tested-by: Neil Armstrong <neil.armstrong@linaro.org>
>> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
>> ---
>>   arch/arm64/boot/dts/qcom/sm8650.dtsi | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
>> index bb0b3c48ee4b..a34c4b7ccbac 100644
>> --- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
>> @@ -2593,9 +2593,11 @@ &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>,
>>           ice: crypto@1d88000 {
>>               compatible = "qcom,sm8650-inline-crypto-engine",
>>                        "qcom,inline-crypto-engine";
>> -            reg = <0 0x01d88000 0 0x8000>;
>> +            reg = <0 0x01d88000 0 0x10000>;
>>               clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
>> +
>> +            qcom,ice-use-hwkm;
>>           };
>>           tcsr_mutex: hwlock@1f40000 {
> 
> Please split this (and next) in two patches:
> - one extending the register size + Fixes tag so it can backported to stable kernels

Would also be helpful to know which chipsets require this, so we can
fix it up. FWIW:

rg qcom,ufshc arch/arm64/boot/dts/qcom -l | wc -l

returns 17

Konrad
