Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCAC36B15
	for <linux-crypto@vger.kernel.org>; Tue,  9 Jan 2024 11:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="jRE56T1L"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-55719cdc0e1so3185938a12.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Jan 2024 03:27:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1704799675; x=1705404475; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKel/uL1tajPej7Kr+Y3gD2pm0Q/5wlP7q9l4+pRLR8=;
        b=jRE56T1LeQJAkA6mhHCrJJdZN4io3r5Q1w3lsA3Q5ln52EOtCaCvigxk9b1bKXV0Uc
         l02SqWOBEwm2aDRxLaY9990nhiSA5bCCcG82N5iXrasCHFLvI//xbMgDEnSApTFTwaIz
         MSl0tgwuDXnJQAxEyB5RBX4efzT5xCnxG+Eq5WBttWGmroJWSwIZBIRj7t2TRe0e0ToY
         Qpf93VqfghWjBWrSvIfCg6iHEtX9UAjbvMz4htxGj8R9rgG+Sj0OWoQT1E2nnwbujJxN
         hFnH3jAgeYx3+0Tlt26MUmgT40Lr3b2vukLkIF832pMOPF7wvUB2JSeGSCXx++3SEnj/
         0xgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704799675; x=1705404475;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oKel/uL1tajPej7Kr+Y3gD2pm0Q/5wlP7q9l4+pRLR8=;
        b=PbHhTyLY/6EA068aYFeB5KhXkO96Z2ux9tTrKEhMRjV3UVs8egbVmJG/u2f19dWoNb
         jBYZ394xcAhD+7MCaNz0xVlEnOFYrGXdPvjEz9jCvQQCGMtmZpHfM3g4P0AtdI9njOBJ
         JlaQGZPRthemwyMZdtmsqIjw3eCB0jvVMnOMlwH4rkZhNwEaOx4qEVWvVwo63Dyn8MJr
         rc9ZsqJY4cGyVI6IrjemdH/yN3kb79w/lP9Rgh4e3sLmy8HWUr6wmtiVzmAXQQX588gY
         2nWJOJSi2CLV0KFRQCBgx465AI9p5yz1F7TyOwue1nNPP09cKWWPWDlwEtqJwYqaPZ3p
         9hkA==
X-Gm-Message-State: AOJu0YxLDP1/ja7RasJv9QJQXUoOpHHb/9rOFIGfntjIEGvhukPio4Jg
	v/ZYvnDRaGlcJFO+nIndmmG5FYVZM9LVGA==
X-Google-Smtp-Source: AGHT+IFLDOEYrnaFAb1pvyYayLgZLIaQwOsuzV7aIZuufvzjoaHL+sD2wiqnSgjHvZSMG2kvOL3hGg==
X-Received: by 2002:a50:bb2f:0:b0:557:188b:eccb with SMTP id y44-20020a50bb2f000000b00557188beccbmr2752722ede.84.1704799675115;
        Tue, 09 Jan 2024 03:27:55 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id b6-20020a0564021f0600b0055678085e27sm847587edb.20.2024.01.09.03.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jan 2024 03:27:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 09 Jan 2024 12:27:54 +0100
Message-Id: <CYA51QMVFQZF.3NEPC3R2QY2VM@fairphone.com>
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Konrad Dybcio" <konrad.dybcio@linaro.org>, "Andy Gross"
 <agross@kernel.org>, "Bjorn Andersson" <andersson@kernel.org>, "Thara
 Gopinath" <thara.gopinath@gmail.com>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Rob Herring" <robh+dt@kernel.org>, "Krzysztof Kozlowski"
 <krzysztof.kozlowski+dt@linaro.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Bhupesh Sharma" <bhupesh.sharma@linaro.org>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] Add Crypto Engine support for SM6350
X-Mailer: aerc 0.15.2
References: <20240105-sm6350-qce-v1-0-416e5c7319ac@fairphone.com>
 <c3e82c7a-fc03-44c6-bf83-97dffaf22dba@linaro.org>
In-Reply-To: <c3e82c7a-fc03-44c6-bf83-97dffaf22dba@linaro.org>

On Mon Jan 8, 2024 at 1:40 PM CET, Konrad Dybcio wrote:
> On 5.01.2024 17:15, Luca Weiss wrote:
> > Add the compatible and nodes for the QCE found on SM6350 SoC.
> >=20
> > Not completely sure how to fully test it but "kcapi-speed --all" shows
> > no issues. Let me know if I can/should test this more.
>
> I think I used `cryptsetup benchmark` with and without the ICE enabled
> a couple years back. IIRC the CPU should be faaar faster but also chug
> power while at it.

Are you sure you mean QCE here (which this patch is about) and not ICE?

I'm not aware of them working together somehow but I wouldn't be
surprised if there's something since I don't know much of this area at
all.

Regards
Luca

>
> Konrad

