Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B8E35F8DD
	for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 14:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770991736; cv=none; b=qlXpmckK+mItX7xmIbk0rK07zeYExCZQzy7apDjtyolRGwgR4D29UZrIJ6QEuKgLfDLcD1T3OZOijrd99/Bg7aDYqRVpOCm4dJUIemDjFE94xLQVTPaOJP2GvkccA340aAPymc5cAO6Vmgm2JpFpgYLXprzS5mDFRYLwgE6nwaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770991736; c=relaxed/simple;
	bh=kSxpGwm9UDimkXPadlMLx9J4LPHuy90pfvo/9O4YcSg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=O3b0h7XpLLfUpttmbpDKCKZmLo9yTIZRsmzIzGfvnHbR09hrwRV8xSTeOZGqpACqfyEKg6wgxaPC4qw2kD+WmtjynPGil8CkpEeZ2JLNycymNkSw4Rimr+Lbbuf8u7Kcgytyq9BmZ36JWIwRN0rAeemqSds+ArNdJItwWUMUPZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=cn7gYATX; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="cn7gYATX"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-b8fb6ad3243so74841966b.1
        for <linux-crypto@vger.kernel.org>; Fri, 13 Feb 2026 06:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1770991734; x=1771596534; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MDWCaCmjcMdTeU70IpQ6l5t9XJKDcXByz0w6wvm7lMw=;
        b=cn7gYATXW2pTKK268nnPC96kyjE6vk5jUTQgnqIFRP5kqqObCjRljl4R95gTd96L6M
         DPnWW4erxOVa2X7ux+83MCOsBwa9Cj9NnNVtUhwZQ7DwTV31Cd/5+/N3NIN7i9zduFrp
         Qf+aU2Nql3i9pxJVZtggqel1lfwaTkPMcTA1LUiiQ+X83z8V7BIVnB8ZYbCA1OmZAQPt
         HWDslNDDUC8StTtd2ISTAIHcqNokBLZ+F7yqQE+wk062LMISnYQT+jTokXXdQfnWTmgS
         sV5womhihB1B0+Zk7Ydflgt+9DeFMPXE/E1vIOoOnKNnaZzFS55Utd6Zvf58SfeUbk6O
         PffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770991734; x=1771596534;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MDWCaCmjcMdTeU70IpQ6l5t9XJKDcXByz0w6wvm7lMw=;
        b=n8cQh3s+NahqwPOS8+uaFNjx/Q9JVsSuqrfOI9OJSE13QBqDFD4N15TAV61H4XvtWH
         Vf2VX6VRGxFbfLUhG/THUoPUAtE72FZUwATdt0KKx8ELpxIIm7SU3OtSblrKEVEeAGuK
         W2LNCBa3j5I6W1IzGcn003+7FAkQTIQLox7hwfBPQZoHRP3G8ZPa6Qaf8DivG/f4ieZE
         atS45xeP6sKaNU71wtQUuA9cgFm2bNBUTLNwOEEtZu1Qx8QfKVMQvpOaHYcD9SseVMPj
         Q4nl/7zFpJGKkyMf9eVOUvgcSYFECkJWFZZByAfGf4votBSkB+HYI3RsnorlE18It8v4
         kZjw==
X-Forwarded-Encrypted: i=1; AJvYcCXMK/1VA/dJT0JprGZ6QIyE1GPteZQoJxhcKPbsXXVdHgynNhmc4OPF6UP23Kark7c92xxldLY/c0YvuT4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzN1Y7K9q2iitSkQ32WhsDN0o3srC1eUrxKSJQHmjMu1XXHqlQ5
	atBwuYymrEtMppZTvp5yD9S7MyObPA2nvb5bowBnBQTfwr70/X3BJ3iuFkXJkGmgy4s=
X-Gm-Gg: AZuq6aIrd5/LPGrHjRcS2kJBtD14sxVqyY6wlqr3j+i8w3NPzv1wAiOlYGU0pCFLL5p
	ML6HcUjYnmN8BOpOIPBjDXrowN14fih4GdmMaPbMH2Imtobu1fNokFJ0HQ5OUzWEmt1cE/ooxxU
	nMtqpnFuHGWXXEHXFRkDT9e/eFPAau82QYkNTNCo62gCcXjt2yd6Mxkg0Q9cAfohNYLhL/XQi8n
	ZomTSmckvSWoRpvmqBizqZoslE22DYfzMUwQVQ5RRJ1TfCbp6R6ZbmGpf78Zjtwvjw4tzk8rE8C
	jDffVtLcx1t3gC0gZk/ZZw93Nxa1GA2uGwta6S/LjeBFdRpSVNw10EX1ZKsMADnyWeMbOl9YLZL
	NljHeFCWPLyfBB59/5JLKyckC3fYVMMGGrx8RfV0/bcANb/8Z84oNC8NZ82CteU5RQydtCZXMFE
	nGf35gcVzQod5d0l6OJxu00U9IQFwksz1Q/ltnIdFInM/qLxx0nfGlIMmGTOBQ5f/ahUND
X-Received: by 2002:a17:907:961a:b0:b6d:67b0:ca0b with SMTP id a640c23a62f3a-b8fb46764admr98204666b.61.1770991733815;
        Fri, 13 Feb 2026 06:08:53 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8f6e9cd6d4sm263856066b.23.2026.02.13.06.08.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 06:08:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 13 Feb 2026 15:08:51 +0100
Message-Id: <DGDW69W84LJ1.2GHM2WU31VANR@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-arm-msm@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-phy@lists.infradead.org>, "Krzysztof
 Kozlowski" <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v2 2/6] scsi: ufs: qcom,sc7180-ufshc: dt-bindings:
 Document the Milos UFS Controller
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Luca Weiss" <luca.weiss@fairphone.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "Herbert Xu" <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>,
 "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley"
 <conor+dt@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Alim
 Akhtar" <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>,
 "Bart Van Assche" <bvanassche@acm.org>, "Vinod Koul" <vkoul@kernel.org>,
 "Neil Armstrong" <neil.armstrong@linaro.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-2-d3ce4f61f030@fairphone.com>
In-Reply-To: <20260112-milos-ufs-v2-2-d3ce4f61f030@fairphone.com>

Hi Martin,

On Mon Jan 12, 2026 at 2:53 PM CET, Luca Weiss wrote:
> Document the UFS Controller on the Milos SoC.
>
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>

I've added you to this email now since you seem to pick up most patches
for these files. Could you take this one please to unblock Milos UFS
dts?

And maybe you could add yourself to MAINTAINERS so b4 picks up your
email for patches to these files?

Regards
Luca

> ---
>  Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml=
 b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> index d94ef4e6b85a..c85f126e52a0 100644
> --- a/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> +++ b/Documentation/devicetree/bindings/ufs/qcom,sc7180-ufshc.yaml
> @@ -15,6 +15,7 @@ select:
>      compatible:
>        contains:
>          enum:
> +          - qcom,milos-ufshc
>            - qcom,msm8998-ufshc
>            - qcom,qcs8300-ufshc
>            - qcom,sa8775p-ufshc
> @@ -33,6 +34,7 @@ properties:
>    compatible:
>      items:
>        - enum:
> +          - qcom,milos-ufshc
>            - qcom,msm8998-ufshc
>            - qcom,qcs8300-ufshc
>            - qcom,sa8775p-ufshc

