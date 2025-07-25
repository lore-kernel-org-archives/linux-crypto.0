Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65195237713
	for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 14:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753452889; cv=none; b=MwYwKwtCZQQfNenbuWKhwt7Od++mx3I5LQdd7vYdhSbbWCUh1BkvmEATtMq5WASJ37fxn2uwBzb4wwONk6DAs/FPRh8qrHkDYeeEXoL9kl11/qSnLia8xIhQ9F/rW9mrdNy32UleF3ESFkqjeGzbd2zUBQyXmK4OnP0aEot8srA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753452889; c=relaxed/simple;
	bh=rNyAWlp56eBFvy36oX5YiZlPyIt11W/cxbD2Iyf2S4s=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=PZn+Z7AWO/DIbI9Q0X44j2ETZjgCKiap+JTXwb2G4OXe5379y1XrB+wm4egpohxLjZNtMe3N+9yFyO7/aZgFZNmuG7YQTufof1n3ijp2+2hVlRk+kYVwe4HR8evH+3VYDpngRBNurAiizBOC8S7KcUUIiWEDe9wff74i6LSHZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=3GNcyl+V; arc=none smtp.client-ip=209.85.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="3GNcyl+V"
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-60702d77c60so3955704a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Jul 2025 07:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1753452886; x=1754057686; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iSkJyTrv6R3uiwv3q2J4zn3hDj1JQ7Rtyl+OeDRudNc=;
        b=3GNcyl+VN56MLlLZZiFVdso3FYTMvxLqn0YicT4yjc3jDsdFduc6k8L2aJz+z7EMyB
         MwmZZxlrU27kgawqJRkZm2zoQP2golw0YdBQEdxJg3OpVk1uIXLgbBiO2YEe9ssCeyfq
         NEE3TiphHbKz1lK+XfH2G1qBUvZKPPaJv/znEj++VkWiLz9kiBcbgwmdKXKc/juZaz6n
         UkHw63EKc8v0nhrOsyDsAZvXu1g8aeI0CtC6L22yQcvO5DjQdju5F0hof5CO4JJFhDKR
         1va/awzeHy9uwa5YGsdaj0I5nvvekY+MC7BvqIZtc30xXJ7j4vpvZDgX2T5xHDb0Qfib
         /0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753452886; x=1754057686;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iSkJyTrv6R3uiwv3q2J4zn3hDj1JQ7Rtyl+OeDRudNc=;
        b=d3qBfMwtL8E5H63L300YL9bjusf0/zg1MBfaMbpBIACg49ZGGegfdYIjOEJDDU6uUS
         +rbZhNYwJTBFPnvRDjOy39Y0I1eZtYoHpAX8zXcUtB58toqgiriqKZJ+7GBhlMgHrFWt
         mAsa5k0Dow9yB7Y5pYegJ7N3AklC4O5dWBNpY4ViNHBDOHGA/UL99wFBK7kZkN9RT57m
         b4BmYxE7PAkR5z5xl9CaerLDJ+GkuHrvWTbPMd8vUri8vvm9wWeejuiLMaYxTuOZkFZ4
         Rok7YSeip0Zx/iMKuVsRpWehKNiBjrQ8Fj1KnhTGFKLFFNrx3yRF4Yyv7CXysljBmPxm
         yuHQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl5t6ue2D/pQvX+ePKEA8QBEwiDgaPwsNoRUnJe+MeNLL5h/wzBEeDIAPavFszo6SowGCMeJSdV28P3TY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbfJspO3JjElgjgVxD32cNOdXw2CYhkWi/O4Di7hVbOp+H2qgj
	bObYTMm1Olh4ugJwxDRknkayYeWvapS0H8cAvbv1qzOxu+kSyhQJX1Kf+HhlVpzfaTw=
X-Gm-Gg: ASbGncsT37jKy5EGaUJJt76FOs+IrmDmeJwCKQ2iL4P836RqjE34SREI0/tPSNj9TQs
	8ZhAKJk5NE+JaDDsdnpGg5gLyoGuK2jgeAU4iAcMo2V1naHsFzac1j3lM1UYnl74NHGH6Zbz91N
	z0W1ugShoBOumqT74IOABeymMdbqvTl8F0dAXqMz6wHw8eh/Ye9dJSoFGo6siJpw5n9j8gYKiQT
	ZiJ5Ucyep9U7XXMT6tMIGMPRoM7sINkIUKgLIMnFrpmMpC5Ymnpsbx0MvEMEIVUqg+JSeEOYvnE
	P/y2+Yd34HTkmNNOhcHOna9q+Rww96XaKlVtb99mznk2WVEn9R2D43TwZCeL5JjNQHbl/vjVxB9
	hu8wZo1mzoyRafj6E6ADpbMJpIvNk7ll/9UwyA+/TLn52Xj5hHKadTjK/Dc7onzlgyJI=
X-Google-Smtp-Source: AGHT+IGz463msOz8qJcurxvgKtRb5VKMVkS2t8llkd59+2lECxEEVtdl6gBW3cfbqM7OYO38KYCWFg==
X-Received: by 2002:a05:6402:3595:b0:604:e440:1d0b with SMTP id 4fb4d7f45d1cf-614f1a88810mr1744941a12.4.1753452885513;
        Fri, 25 Jul 2025 07:14:45 -0700 (PDT)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-614d907a40csm1635236a12.15.2025.07.25.07.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 07:14:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Jul 2025 16:14:44 +0200
Message-Id: <DBL766O111UP.1IBG5Q30DCEQS@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>, <dmaengine@vger.kernel.org>,
 <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH 06/14] dt-bindings: mailbox: qcom-ipcc: document the
 SM7635 Inter-Processor Communication Controller
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Luca Weiss" <luca.weiss@fairphone.com>, "Will Deacon"
 <will@kernel.org>, "Robin Murphy" <robin.murphy@arm.com>, "Joerg Roedel"
 <joro@8bytes.org>, "Rob Herring" <robh@kernel.org>, "Krzysztof Kozlowski"
 <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, "Viresh Kumar" <viresh.kumar@linaro.org>,
 "Manivannan Sadhasivam" <mani@kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Vinod Koul" <vkoul@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>, "Robert Marko"
 <robimarko@gmail.com>, "Das Srinagesh" <quic_gurus@quicinc.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, "Jassi Brar" <jassisinghbrar@gmail.com>,
 "Amit Kucheria" <amitk@kernel.org>, "Thara Gopinath"
 <thara.gopinath@gmail.com>, "Daniel Lezcano" <daniel.lezcano@linaro.org>,
 "Zhang Rui" <rui.zhang@intel.com>, "Lukasz Luba" <lukasz.luba@arm.com>,
 "Ulf Hansson" <ulf.hansson@linaro.org>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250625-sm7635-fp6-initial-v1-0-d9cd322eac1b@fairphone.com>
 <20250625-sm7635-fp6-initial-v1-6-d9cd322eac1b@fairphone.com>
In-Reply-To: <20250625-sm7635-fp6-initial-v1-6-d9cd322eac1b@fairphone.com>

Hi Jassi,

On Wed Jun 25, 2025 at 11:23 AM CEST, Luca Weiss wrote:
> Document the Inter-Processor Communication Controller on the SM7635 Platf=
orm.
>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>

I see you picked up this patch[0], but "qcom,sm7635-ipcc" should be
dropped. Only "qcom,milos-ipcc" from v2 should land.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/com=
mit/?id=3D872798f61d8bfea857e54aa17baa7b0d3ee24b65

Regards
Luca

> ---
>  Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml b/D=
ocumentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
> index f69c0ec5d19d3dd726a42d86f8a77433267fdf28..6e86ec36a82254ebd73c3067d=
e495795c36c6bee 100644
> --- a/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
> +++ b/Documentation/devicetree/bindings/mailbox/qcom-ipcc.yaml
> @@ -34,6 +34,7 @@ properties:
>            - qcom,sdx75-ipcc
>            - qcom,sm6350-ipcc
>            - qcom,sm6375-ipcc
> +          - qcom,sm7635-ipcc
>            - qcom,sm8250-ipcc
>            - qcom,sm8350-ipcc
>            - qcom,sm8450-ipcc

