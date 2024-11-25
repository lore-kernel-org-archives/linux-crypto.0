Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B8B1CB31D
	for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732574127; cv=none; b=sH62Jq7SfRDomYvFKGeL1es5N0k0ynCyqeI/9Q//T5/nD96+Cfxh1yhrR3vWdBkUfcQyVjydMQrGlhgQYJLB27FnK8F+zSCuDR1lah7uDk/DrkrxrVPemGPU3wQWaRUaM7HjX9O/WwoWWXbpIN1FoWlw4ZAKe0zyjA9Lx06Kexo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732574127; c=relaxed/simple;
	bh=JUkdG3WwcK0sH53fkuhlZtdKYI9+pTrmnN1dDYT+QqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T4lpYommBY9Yxc7ovoO1qB+jRMsiYVTSg5bmiX8vr9sEX/jLnh4uBQexxjSwhhvS6i7mUj4APp12q5C0HdQj+95BvDw+I3AEl24b6VdlGVkUnlPaE9E2Gn8MAE9zfyDeOAZIZoFo9IvKKRTaArl9Y/DbmnQwe02LiLJwxnWSDBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aVaqb8D6; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aVaqb8D6"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ff550d37a6so55028201fa.0
        for <linux-crypto@vger.kernel.org>; Mon, 25 Nov 2024 14:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732574124; x=1733178924; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mK6iFRY7R3ULg/N72ZgFYW9FiXYFDV4de5/GQKQ+Iyk=;
        b=aVaqb8D6prIgG5MEdXWkfzc43qtRdoHDa6Ls6W37MpePuEWCo+myZ+XL11wIC78VgL
         vfaUtC/VuoNuJCbgmhMNW0Lf48LHnMQauOKEW0lKFfZ/+AePFGdJ7Suy9B2YtLkoKXTb
         qvonPL1gR0oeVh5GKgEoZ8/cThyTBdmWwsMNq9KaAgmHPfPXaYNin3Dc2/TyA5xX1TMw
         AY81k/QmFZlYmnulCkrppDbWRby7kaCo5nAjV/57YD7c1RE59z2qVa+O9Z4vZZKo8Gaw
         oBTV2SwpN951ndLFGBpqW7QqtfZpOc2kklU8uTTSSMcylORZYAny+1EAiyPY7txCTW1h
         OmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732574124; x=1733178924;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mK6iFRY7R3ULg/N72ZgFYW9FiXYFDV4de5/GQKQ+Iyk=;
        b=qYow0ctFZHl0HpF8m7Nrnx22FPSRDhjxXUtjiFIZIa5ZIy2bZS4TajSt6Eke/VEtZr
         5RsOxaraxNr0ZlHpgQF2MYlr7ybhi2DLIpyv8aVCxClONAKlvTbJJrlDJG88DnTq2sjJ
         i0JXhmHXqb9EOpUJCU9qRxMPUj3px8MAerIRk40Ve5Mlc25WOwetJsPFFQnHjWiguHMd
         QZGAbJmH22CxTXfzs2C0rfsnv9M+/67wVMbpZeoUSMMELavw+TWoUHExASgecTRY/Zqm
         1PwsFecJVDB7z7Kuq69suaG0YWLz2wkDarDhq9H/jjRRTqpCK2kypm/nRi/O1/c8LWvq
         p3Ww==
X-Forwarded-Encrypted: i=1; AJvYcCUprR5Z1lXOEnfxugSkhVH9j/nKO5g9pJUxLvZ+bb/JzmIjJ41xvz5zLlTfhOMPIwcvH+6NMNPjaz+p3yM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxrVMWXaLnBIAPZ4WIayPsjoo1p1X2CpCvi5F03ECaP+u2/9WyS
	ooz6oyOBa65uSYvGz7ngzFQW3HiAbQYXgLL0aSNaakvH1T7PMhshCVFfurhr7AY=
X-Gm-Gg: ASbGncu0yM5uWPmH62mgz2L+XMCBtDK8IOaaXKz96wgEdF87r1YELzqKlF8sKCHkVn/
	5S36CxWrGpzz2AIUM2v60nBIRbPUN2HDIZTzvTQ5q/VjsvOterb8MTnOoKYv5lQLGa1TxtEk02P
	ReinMteWEn33H8/7F5d56PjiJ6IJaonMSkg1AuhxzyEOsRCcdtotF8eOU2Jfbgph3bz0HStHDtL
	OyjoF5YIdyw9l+eLdoVhFBHqAruHXXvbPtE7Y5M+Lr7afeiQmGwAisMy1S/X8+ofnuprsXyUCVu
	ddbZsZ0iAJN1dUTLs7USTBOtlupIKQ==
X-Google-Smtp-Source: AGHT+IFp5gx7OJlQrJ9dEw/b8xMYu3nZ67KYGmj3q6WZjvpLkJCPY9W/kriDd8ENfUXUXNo2Yfcwvg==
X-Received: by 2002:a05:651c:553:b0:2ff:991a:fb96 with SMTP id 38308e7fff4ca-2ffa716d0b6mr68581421fa.12.1732574123695;
        Mon, 25 Nov 2024 14:35:23 -0800 (PST)
Received: from eriador.lumag.spb.ru (2001-14ba-a0c3-3a00--b8c.rev.dnainternet.fi. [2001:14ba:a0c3:3a00::b8c])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ffa53760cbsm16580381fa.82.2024.11.25.14.35.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2024 14:35:22 -0800 (PST)
Date: Tue, 26 Nov 2024 00:35:20 +0200
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To: Yuvaraj Ranganathan <quic_yrangana@quicinc.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Vinod Koul <vkoul@kernel.org>, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH V4 2/2] arm64: dts: qcom: qcs8300: add TRNG node
Message-ID: <2vc6tg77qpi5vz7tmmlwgnlxjg62l6vsipjivygiapl4dhqupv@vrpbk3kcdrd3>
References: <20241122074346.4084606-1-quic_yrangana@quicinc.com>
 <20241122074346.4084606-3-quic_yrangana@quicinc.com>
 <40c49e6d-dbbd-49cf-b59b-10e10b24da22@kernel.org>
 <0bdaa2ef-3979-4963-be75-0a5a89728f44@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bdaa2ef-3979-4963-be75-0a5a89728f44@quicinc.com>

On Sun, Nov 24, 2024 at 09:17:40AM +0530, Yuvaraj Ranganathan wrote:
> Hi Krzysztof,
> 
> I sincerely apologize for the inconvenience. I added the "Reviewed-by"
> tag without fully understanding its implications. I will remove the tag
> in the next patch series.

First of all, please don't top-post. Put your text under the phrases
that you are responding to, not at the top of the message. Otherwise the
logic is a bit broken.

Second, may I ask, what made you add that tag at all? I went on and
checked. Krzysztof didn't repond at all to v3 and didn't respond to v2
of this patch. So why?

Third, if you are unsure about what you are doing and as you seem to be
using b4 tool, please just use `b4 trailers -u`. It has its own
drawbacks so in some cases one should be careful, but at least it
doesn't invent tags on its own.

> 
> Thanks,
> Yuvaraj.
> 
> On 11/22/2024 8:30 PM, Krzysztof Kozlowski wrote:
> > On 22/11/2024 08:43, Yuvaraj Ranganathan wrote:
> >> The qcs8300 SoC has a True Random Number Generator, add the node with
> >> the correct compatible set.
> >>
> >> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> >> Reviewed-by: Krzysztof Kozlowski <krzk+dt@kernel.org>
> > 
> > NAK, stop adding fake tags. It is impossible to receive above tag from
> > me written that way.
> > 
> > Best regards,
> > Krzysztof
> 

-- 
With best wishes
Dmitry
