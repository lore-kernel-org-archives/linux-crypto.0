Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915535;
	b=nqKh8cVAdh7GMRij7dLCpcnrlqN++HM4P6NZXSnoVebXiTulSQrM+ZA87jPYXssOhlDY
	 a2T2F+VkZkum7xCwbHY7aX/xL3OEtq8hbtrNhHmccmhtebgXOKvuoamjZCwF8TIzJiECZ
	 duFpME82K2CvQh9n32VfAhcurNcCcaoOXzw486dWvldgasuLmOIrQdoQ0D8TYaUqbIjKP
	 825H5qDhClE6mz0M/XG5cro/LdVDrqDZ5FJbAKYfIlvks58UZFrbhYILzHASM+RSuCXb2
	 qlHMfGuK8s+5fKYjM+hatvW6r6igNACv6E2EwYN9p1Bz6goQpZe8aSBsn6zHRj5j1ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915535;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=f5e+r6C+Y+boKKU1c+tSb6Bf3yIjeJVK+Xx6iJaNfGA=;
	b=XXD5aUMVTry/UmCQYycwwH0CRGHDIpSPENHoKQURpjKjmE6CNvPdirYxpjwEijBO0/+A
	 /Ig7h6APY71m3oIB0R9fIWNTBPcSDLujGTy0jvYEqQEwGrV+AElff4SABDfSxw9hx5FvL
	 BSpFwGGp/uNdE7RoHfbPGsvLZ5dHz5AdyKXS5Tzbm1Dz+NoWrb8n/fU8p8dUSJhN5Yn1R
	 5EN+6bJ43IH6i9HdhN86qmCpxy6KEjHRZs2GeTC9ZNvKGcU9vIaBWG6mkXH6esJDilNDH
	 Q7TFqt/gHPTnILxYrGCXyq2WPQJSvzlKtTbDBrpCq1Ml8VvShxRwRT77meTE+zNU/Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=andrewgigena.dev;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.174
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9A8606A32F
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 21:52:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B9A8606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=andrewgigena.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3ab01c46697so23080991fa.1
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 13:52:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793915534; x=1794520334;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f5e+r6C+Y+boKKU1c+tSb6Bf3yIjeJVK+Xx6iJaNfGA=;
        b=fnOQ30TwROOuza7TjBVmlEALJFNPU3VIb3deesylY7vQczt6+2PM6gv2IeT8XdHd8o
         PN5Mpwooh5Wud5s512CQCggMTZMltd9p7yw7RpB69iGfF3HhMahFcf6of6lGkUX1rLXp
         B4BHoWaky8MOw7LVZ+ahVmjz/R3+jLPxlzVO16HJJ7FCp/21HPA6VloPYtZcf5BAX79r
         DCNbSgDSbCjmGdjZ7pVzUVEiqEARG07oHy2AQHdixZ+MRS+63RZgQfCbQqsX7W1QHJwk
         CC/GUIb0qlsYNlcmbg1t8BdK4U1s1aOpEBMBnkxMtogPuI5BWjnwCQhRsEcm+3tWl4z6
         KPWg==
X-Forwarded-Encrypted: i=1; AKwUvBwiPe+L/wVJD4EPgm9VE671WHndqCaQtu1mOAZ78+iKEEk6uyC/YewkqGRXeepKpWXhiQmFXPyWdu6tuIY=@vger.kernel.org
X-Gm-Message-State: APuU4Z+33Nlj2PfwRgWd6dbYuHD4UpJeBwx011wJP2KmsXV6r/0I5nCW
	AF0hDtJweaSbD9QA60tlgPVQ/svqrMH8SwudR+exW3tY0+ZrC4Bh8rzhB8S9nkRi1fzhcQ==
X-Gm-Gg: AYBFou0/G8wRpDxQMTzH1BlcSnbsKW6LSTAfk5km3EAsB6c/Wwn0sGBDg/h2wuJYwKq
	z7iQrNYwB0spDXZA/3rCfyfb0walYRXhVMNpPhCNEZbTp36S6a71LrRCgFlkcGQKEy9R6C2fwc/
	c+VLqV3WK41NQKRWmITyVXSSD/2a7YZyuMu+E90bPm/Xpmj6jlkKcpxlTiANEgY5dD9I4pHHqeD
	aeVVDSlwcfnQhHT0GvgGPHkV7AB1NUNnRoD4QbFExOkHyJ6jwAUA9D2Q08XWw5DhaI/XTegL9bK
	A+hId1YEiB4GaEUN5vp9bN1x02CJJTdbpgfNYFjbViQMCtCYLWmpMcgwoosKAhRVFtX/NFoQCKE
	ymK+K45DQRbzbi1NpxBw8Lf+3HocUDI0xU/ZEVE7o+y8VcxYl4OB4HFA7uQ7qjKN+UMscllfVuH
	P2FZEWXCXqWHG/MkvQZzwtTVyqTQIxxehoPUaG6eBeV2A37lKxVnI5O+heh+e97Ocr7Hf4i2587
	IXK8RA1SEvzgYQ1ls9Fn9Yxlmji+mGTKrJAhI3sXMP5rm8BkXmWbudzdPv7NDBuJaB5UF2NU109
	e5ZdElXaVUAB3kLIQp3LkmRKP46vavYXzk6tm0Fc/dvQUsqa1tyuhn4C/AViqm6uc/RFGi7ZbvQ
	giKLElTcRCb/fCBfy
X-Received: by 2002:a05:651c:e09:b0:3ac:f037:9dff with SMTP id 38308e7fff4ca-3acf3d3924emr1221481fa.26.1793915533646;
        Thu, 05 Nov 2026 13:52:13 -0800 (PST)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3acdc6ea213sm12453581fa.34.2026.11.05.13.52.12
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 13:52:12 -0800 (PST)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-3aca0bf7fd0so20166371fa.0
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 13:52:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzm1GEClJQPrypksWrtorQoFrUQK4+cNYIPORLJWBnRwoZ/MHaljVBwX0rbRZgIsYmRyyw9MtFTPLKpwvI=@vger.kernel.org
X-Received: by 2002:a05:651c:a14c:b0:3ac:ddd9:7820 with SMTP id
 38308e7fff4ca-3acf3b201eemr1185331fa.15.1793915531874; Thu, 05 Nov 2026
 13:52:11 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev> <dxb7s2d25ixowmfifhvetctpckj7h4y5puiai7orhkimgj7uxu@ekhwvpm536mk>
In-Reply-To: <dxb7s2d25ixowmfifhvetctpckj7h4y5puiai7orhkimgj7uxu@ekhwvpm536mk>
From: Andrew Gigena <mail@andrewgigena.dev>
Date: Thu, 5 Nov 2026 18:51:44 -0300
X-Gmail-Original-Message-ID: <CANn8UmeS0Fvdkamzu0Cgbv25+WdjHsXvCLMpsL98QSo-Gd731g@mail.gmail.com>
X-Gm-Features: AclHuK9TNVNMsMH-gS3LyhmcwXP0L8JEpTnOqnWuyNklory8rcuhuvvX8_jSoFw
Message-ID: <CANn8UmeS0Fvdkamzu0Cgbv25+WdjHsXvCLMpsL98QSo-Gd731g@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8150: Use standalone ICE node
 for UFS
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Andrew Gigena <mail@andrewgigena.dev>, Abel Vesa <abelvesa@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Manivannan Sadhasivam <mani@kernel.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>, 
	Stanley Jhu <stanleyjhu@google.com>, Bjorn Andersson <andersson@kernel.org>, 
	Andy Gross <agross@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I understand, I'll keep that in mind for future patches. Should I
release patch v3 removing the "Tested-By" now, or wait for other
reviews?

El jue, 5 nov 2026 a la(s) 5:56=E2=80=AFa.m., Abel Vesa
(abel.vesa@oss.qualcomm.com) escribi=C3=B3:
>
> On 26-11-04 18:38:13, Andrew Gigena wrote:
> > Convert SM8150 UFS to use a standalone ICE node.
> >
> > Move the ICE register region and clock from the UFS controller node
> > into a dedicated ICE node. Reference the new node from the UFS
> > controller using the qcom,ice property.
> >
> > This brings the SM8150 device tree in line with the standalone ICE
> > representation used on newer Qualcomm platforms.
> >
> > Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> > Tested-by: Andrew Gigena <mail@andrewgigena.dev>
>
> Tested-by tag should come from someone else, other than the author.
>
> Authors are expected to test their patches by default.
>
