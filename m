Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745E63242D6
	for <linux-crypto@vger.kernel.org>; Mon, 15 Dec 2025 05:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765775896; cv=none; b=mnwaGVCvl7D8FXL9JcdEzfRs731r49TzTLrvVFjT0CNvvA4dd742w12CCiE1sF7OAzQuMCTEbC8h+5UAAxSt0OVJnAA59x078kZcEynFdi8Ua444ActwBwkNEhiPImGudPzf2fOtccncNNHQWhkJCM9aamBuWqkNhdW9v77Wsus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765775896; c=relaxed/simple;
	bh=EyhhTu6tEajuduNp4/0le6GxWfnSGbcGf0p5nThcZrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=csO9wjdUMKP0xAVbU5N/n8b+BTcu6UeKgWT3R3iAhESBbg0DZX0eSQoRCM97UfJyPR3ctU6lD7i2GCN2+0XboIP5pRagRaTqEadXnhOr9wwoVW+Eh3bNaWGZY3nFk3qyoCRpD11fPIddcjj8zGysQGiyy7v7zvsulYNu9zAYgWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cwfl1z6v; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cwfl1z6v"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a09757004cso17034705ad.3
        for <linux-crypto@vger.kernel.org>; Sun, 14 Dec 2025 21:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765775894; x=1766380694; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bYGV5sGRh2yeK6uvxRn1wHQ6jEWyDVrINv6+U1Id/8A=;
        b=cwfl1z6vO+qUVJ/kEpR+Lr4aURVQNuPWddaQ+x3kC1SqBY8LBgPG4p2wcQC2IYlFgK
         lBqoCFwgRGdrOhhnviFX2J6A3YDDQAfEXr5b6bAekBTp5VzNle6WThA9PCFpEDFPrg0T
         NptK1k4/5IOPxUqF9SgOojtd2CUSc7NbqsJ5Fo/VL0A5pe6u9uaC7OpDoULsTvscXQsw
         7mIRuAGaY7aKV2luDl/9CCLUc57JZL96fvQaivg68pUM2Rpa7cI2MqdfDpwJybGtrLhf
         mG5XNJ7gspEA9ayj33xQre90gP4uppO+8L0JjzhMzcXt0Lelj5SF1drE06fzzq5BQ4oH
         g/Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765775894; x=1766380694;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bYGV5sGRh2yeK6uvxRn1wHQ6jEWyDVrINv6+U1Id/8A=;
        b=kz9I05OKBVQ9Qgp10y5Lqy0n302xIWcO2/zyGerFQ1Q4ACT4ueIzWre1OIEbbq5N76
         NHESztXaahbkutoN355bT28LA/VGMF1rPQkJlLhmm1i2CTC4I907RBAQF3IfkvBkLVKx
         h5gsiCJAKBswO4PI0RVERDKhEAHOjgGbuNHz5LXYdWIVm5U2mJxqhBX8SDtOPrE/Umtb
         OuH5CKFIkEzI+AgaF1yR3Q0TRUGI12J67jh303UuT/6ydM4yMgmjjOxPnwUImZabqale
         ksV9TNHltc7WUxoag8rl68QFCv4Zel/2kXkw7Y2Sml+3R441BzjPRhPf5e6McbBvQ+AT
         pcVw==
X-Forwarded-Encrypted: i=1; AJvYcCVJuIli+dqerIB2Ik8KDez0VtQhYvaFbZ7drBmOBjde+Zxroh8/ZnXlJur5K0b7/y+Gsedk8JW11VUCzYs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhExZDj/sPtzVFGBcCgDrp0vNzgDLipCBEZ3Zb3K8q5HYjfVx8
	cQ3G0VV4arGUqe3eO1W+v7rKBFvUNehXAUCn30oeBpDVKSmTt5e7wH3rlmt49ciLq0E=
X-Gm-Gg: AY/fxX4cmLkzq287ySPcJs+ZEAKcRZogB+R/w2j/QDenljjciFY1LRoaU90vo1jqDOf
	66v+K3BpkJHgClAMnCFAIe2raOwqTS5JyxCixrlZxmAF02yuvSn6O+WhDb0eYv95c45lgZHg0pw
	hKjiiT0XThnjPRxurPgcwzbBr2eyW/SeVhpjrhHvEmLMp86HMOy7P4N24Zjxpq72IdtnuErlAj+
	sSlZuXvSvX35qDdtG7axO1ZuHGFQ3unOJ2kvX3qq0EK2UDzV0yAGwyx2aafFPfZ3waOc+TEDLqu
	k8pUNz3065Z51uAFoDWH73kJdZ0XtrHryqEr1RP18kDM7p3oYNr5QN3fE1pGRXCiUeYfpiOVvYC
	ns7/+kTvCpC8GhS7sM74JK4jdTLbKTIXf1vWjj4zupP9QywHOt3RQ1iL7+vz4faKEbL0GNoptTF
	ldHK28G2GrGL8=
X-Google-Smtp-Source: AGHT+IH71LGyS6r6X/23fUIRTMHB9hMJFZwpz7dGoHIihSQCvhU76eKfPDxzle5KT+xNtC/kg/DPCg==
X-Received: by 2002:a17:903:1b66:b0:298:2e7a:3c47 with SMTP id d9443c01a7336-29f23caa438mr105521885ad.42.1765775894222;
        Sun, 14 Dec 2025 21:18:14 -0800 (PST)
Received: from localhost ([122.172.80.63])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29eea016ef4sm122285845ad.56.2025.12.14.21.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 21:18:13 -0800 (PST)
Date: Mon, 15 Dec 2025 10:48:11 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Luca Weiss <luca.weiss@fairphone.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, ~postmarketos/upstreaming@lists.sr.ht, 
	phone-devel@vger.kernel.org, linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 1/9] dt-bindings: cpufreq: qcom-hw: document Milos
 CPUFREQ Hardware
Message-ID: <qogyami7g3wdvfodttrjqzvmrufw4qaqvzp3jsq6lt6wqshu5y@kofhldddiznw>
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-1-b05fddd8b45c@fairphone.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210-sm7635-fp6-initial-v4-1-b05fddd8b45c@fairphone.com>

On 10-12-25, 10:43, Luca Weiss wrote:
> Document the CPUFREQ Hardware on the Milos SoC.
> 
> Acked-by: Rob Herring (Arm) <robh@kernel.org>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
> index 2d42fc3d8ef8..22eeaef14f55 100644
> --- a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
> +++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
> @@ -35,6 +35,7 @@ properties:
>        - description: v2 of CPUFREQ HW (EPSS)
>          items:
>            - enum:
> +              - qcom,milos-cpufreq-epss
>                - qcom,qcs8300-cpufreq-epss
>                - qcom,qdu1000-cpufreq-epss
>                - qcom,sa8255p-cpufreq-epss
> @@ -169,6 +170,7 @@ allOf:
>          compatible:
>            contains:
>              enum:
> +              - qcom,milos-cpufreq-epss
>                - qcom,qcs8300-cpufreq-epss
>                - qcom,sc7280-cpufreq-epss
>                - qcom,sm8250-cpufreq-epss

Applied. Thanks.

-- 
viresh
