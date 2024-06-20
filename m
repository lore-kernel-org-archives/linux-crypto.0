Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E3839FD7;
	Thu, 20 Jun 2024 09:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718875655; cv=none; b=iq/uA32K5XQBdava3es3c8XLRHR1Eemn9CJttxuVtXeiN/qeVrMVH7mIjc25+yxfprPdsU14lNziGaZn7R2wFnPiipXT4wFZMPZ6oV1Sm7f0tqOzRWM1K2iaRSxTuZ6O5CUuZ/eGJ3uBj7ccyOAkbl15vYDgS+cSicQdybblCLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718875655; c=relaxed/simple;
	bh=hvfhnE/muE98gjio2LyB472pR3X4Ufwfd+z4XtSVIgU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RWF+8sVFany0jmllKb4PEboGLgD4D/1iI1V9iAosQfNtdO1XPT2XIUL2Vmob6zhZnuhhdKoTEyyl4WXBRH9LKjKDgrCckwRF6DDDOD08k7WJznWb2L9bQTZi39EzrH1C1Yf7OoeV3EHa0vuGvGOgd+SdqF8yHwwd8hos+OFiOe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VG3sM/5k; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VG3sM/5k"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5c1a6685cd5so279357eaf.1;
        Thu, 20 Jun 2024 02:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718875652; x=1719480452; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nm/VoVgKpuIt9wlpzE70lBkyxmtr1Al/puqNbp58SbQ=;
        b=VG3sM/5k/V0ELXLW4MGQ/tA9hhxXAnr1z9//KbE8V3MDee24LrzopeB8jhDE1vFxeJ
         L7GoD23nSF14aI17+o71c58TobjZXFDTbMNV1ckVcHvGsMotte5sblpxVIWYzR4rvvoA
         ptp4VGbQ0W7epHzlL5jdCwXWHkGlqZF0+G85rKs/gEPUW19AX2tLgcCPGNczm6Hb8vEd
         gE920VrJOVj3j4/GQT/jPCIrexQ28AkBCC5GP5TD0uqfDqD3D6OWoInWbI5jIsNZqoZQ
         W11zADrCCuSm3kx+16R4ox+hx3JR4Ajc7N5ePFBXQjYPvOeEp8heiqhWZckcDZDuC8ob
         cXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718875652; x=1719480452;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nm/VoVgKpuIt9wlpzE70lBkyxmtr1Al/puqNbp58SbQ=;
        b=NBbVzlp20amiyoxDQXEsW3p3Sby3ZH04cg+ckGWGedGsxoqlmwPf4H7ujrtXMNK7vh
         1Fn5alSNbsqHx5QgguGT5XeS7uJrgxrLIA9Mhd8igt39pCPrWmorH3ae8ZoiM+TgWN5Y
         ZPnkfNjrnte6BPdEENeIb0lhBOQbwNZfHpe8Css4Fe5aR9fy06zJs0ra8DZbrFW+JIrX
         krfptvmKCs3MFu8W7GOHawoo1JZBu/CTazrBZoYxJzT27SrKL1v69Z63g9GUc9jm1hr/
         06gyAjMeI4rMbUK38NPx9MQtQ5C6lkcuVrS/AciBJq9SuIqb7jAvXVydnQMQOqsm0sBj
         fCgw==
X-Forwarded-Encrypted: i=1; AJvYcCWzqDVJSXijsRMZ3w1s6zGFSaTm1NxNFa1ZrOshoMtf4Zzi89hDW6q+cDe2pqxJ+XWhcQa+tO4ZYaLuxN9MIQi6+4maDl5JWLJPU+SrMl9Ex3Y3GK8DrhbsLOUtWzRgnic8R1gdl4bLxhp55G5VM/rkM5U2hNZVtQAWMr0kLt1eTF+O+7RexhTcOEjJ6KPgnKawoa/acpeJUS1vVEWI+0c+Ds4+4cb5lvUW
X-Gm-Message-State: AOJu0YzZ9yUyOWzVIh0aS709IA5RZv/WGxEW8u4kIeM/Jsrb9k2CvMfG
	n99dwiugY8ptSGpaF5/bPx3fzti3M4zR0geM5NBY8x2Ej2Czaa5vksyw8q8a8Y8GffqbvsqCxX4
	ospwoZUxbm9x1o3tg5tTpv75nhPI=
X-Google-Smtp-Source: AGHT+IE6JPnR/0edcyF0AErTnEcB/SkvCIQ4Q7vWXQTFelcVP3vGKG4q1ks+vXYWLHHO4nWzVrEeJAZGfC1wLGlRDr0=
X-Received: by 2002:a4a:db76:0:b0:5c1:b95a:eccc with SMTP id
 006d021491bc7-5c1b95aeda9mr3040540eaf.2.1718875652572; Thu, 20 Jun 2024
 02:27:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618204523.9563-1-semen.protsenko@linaro.org> <20240618204523.9563-5-semen.protsenko@linaro.org>
In-Reply-To: <20240618204523.9563-5-semen.protsenko@linaro.org>
From: Anand Moon <linux.amoon@gmail.com>
Date: Thu, 20 Jun 2024 14:57:17 +0530
Message-ID: <CANAwSgS_EjzPpxvz22TjD9dm3cF8Pd1zVXBqCm6bcci-oDL+Hw@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] hwrng: exynos: Implement bus clock control
To: Sam Protsenko <semen.protsenko@linaro.org>
Cc: =?UTF-8?Q?=C5=81ukasz_Stelmach?= <l.stelmach@samsung.com>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Alim Akhtar <alim.akhtar@samsung.com>, linux-samsung-soc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Sam,

On Wed, 19 Jun 2024 at 02:15, Sam Protsenko <semen.protsenko@linaro.org> wrote:
>
> Some SoCs like Exynos850 might require the SSS bus clock (PCLK) to be
> enabled in order to access TRNG registers. Add and handle the optional
> PCLK clock accordingly to make it possible.
>
> Signed-off-by: Sam Protsenko <semen.protsenko@linaro.org>
> ---
> Changes in v2:
>   - Used devm_clk_get_optional_enabled() to avoid calling
>     clk_prepare_enable() for PCLK
>

Reviewed-by: Anand Moon <linux.amoon@gmail.com>

Thanks

-Anand
