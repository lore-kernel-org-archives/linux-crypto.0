Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A25A384CCC
	for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 17:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779124512; cv=none; b=QBXZ7Lj/guH694t3JGdUkRX68uMZ5ZvlNmR7b9/ZunmcQMMzr5a+tO16OmDAFoFI2bz2RNmchXc9UJIfZQOds4GoVPhZ6nUQrjTd+doHF6D6GMoM8a44doOjz70x2T+CPVcsRhC/k+1B1uKtNcNID88+iSc0ZyS1mDXZ9XxntIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779124512; c=relaxed/simple;
	bh=sOJxMZchOv0WgrC6+6PbayYyvo16Eg4LJgmrDhVE/y0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+J3IsfVygzvH3jUYtRi7LMACFYtmbuZwUrXBVnXOwa6K36t04dZm4YT8Js/EsGTSANsXzQEvL1Pb3loqXAHrQ2PsstzNEV6rT2BRpGabLbpQhr7ACFf4P4u4eMr0udOVxaRv5wkg6zPNjktzdUcvYK5mgcHJYoh9jzzrcwjEC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mm9hTExn; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mm9hTExn"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8bc3ef10cc4so38458426d6.1
        for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 10:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1779124508; x=1779729308; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QbJKB2lw5vG8p4X0Zp1dtcwqkjeJLsy09spRbfmWxU=;
        b=mm9hTExnfF+2r2s8jzDBgvHvJeJ1IFWPnnxSJgd6WQUrWB6gDJtVudsOTuUhclRP9x
         RBbySeBJUJvSqMk6OV709roynaEKyXi0tdxs7PCaUbebNmJ0KaZTJXYbMxbvnutH90ZS
         6AAaS3dFcShKdCmUMak5M8uz1bQD6n9H37ZbE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779124508; x=1779729308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0QbJKB2lw5vG8p4X0Zp1dtcwqkjeJLsy09spRbfmWxU=;
        b=L6KqlUQT2AyFtv7oB9J7yd77OQOWs3fOgaf4gmMjJkEr5KJ6f8bY7UH7qbMH7MJWZx
         m4qeKq1lcUKgvxlRzSaHuoejuSCE6D7rpWu/YVd24s9gOYbCBDZeZWMlcvSrroA3S/nj
         UcepI2MfdUUMrALyfUJSBj3i5zR1/qMGf7Jd76kqmsPQBi5rRjm4mMWXDM6WpbhrwrCP
         CBDdGiBnCjN9rWffOLLn5DMPfWr8X+0iOhRzXc96pCLRvwNlOPu93pGBEppm1ttUbKKl
         V2TKLTOWtq6wlY4afLYEDG3mnLsERxjcgCfDOzwS2K+XxQqJx/kDQ4IAanKmlf4T7RMz
         3E3w==
X-Forwarded-Encrypted: i=1; AFNElJ+VXTdxHDqk2ZuEXw0QCRGq/PC91P3cQD09r4WTZZCxAsJKGTc9LmMUvABEajJ1lKArweJaOY6JDV4JJXk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOYx6j6JeDS8gfJrB/whcpLBs3qpZT3oypirnMMLgDD5fOi9Kx
	xeE88Iy/JBdAIbjnB45wVG+nTXOng6NpLYmsZrY5RDPrkVNobDhd0XsRiJCKkNGeB7QPgz4gC0M
	eCTE=
X-Gm-Gg: Acq92OHZMd2O2SBporg7YJ184IEf74aFwHsYCUNbN5Ezh7tVyVkT/e3Yta75KB9XPHI
	I1lh3OilF6yirtqA0M3gI5rbomu39ScA6sP1JoSM6nK5aIawQ0Vaj/3WUahmE8ZT5nUVnLipQER
	VH5b2eW1p4AVTEOg8MhX9dAs9qeGrToa44QMsxVS6qu3hWAjKLBAmzLKodVlaacyzFLw7QwG+3K
	NqwHbzwRBUqfkjjftTwdrMDuF0XVA8QvTQRK3j3QahrwMbCbqgh7OsYAGlfFf2sivKHAausmPfR
	0kNdJZqR3c7YSsCCDPGlTG9x4zcF0cDv9M5y1Pev9UpmzKw/2nRCApjfDE1tFuUpY1EBldV8sgU
	BCCVOAKC0/2jCIv4RufcmqsGv82YUQ6Gxdoo+e5YBEXSF/+O60y/+sRs9TjtgdATj2ulCtYysFL
	6Ulv01ZMGXrUd02FUs5i0o1rB+MbldKdbmrk3dWUWdb6h1KL8I6aqjfAu3jRB5its2aFIeClG7
X-Received: by 2002:a05:6214:ac2:b0:89c:4b7a:6a6c with SMTP id 6a1803df08f44-8ca0f6d5599mr271828446d6.46.1779124508035;
        Mon, 18 May 2026 10:15:08 -0700 (PDT)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com. [209.85.219.46])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ca360979c2sm61909096d6.18.2026.05.18.10.15.06
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2026 10:15:07 -0700 (PDT)
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8b821f39a12so29323506d6.2
        for <linux-crypto@vger.kernel.org>; Mon, 18 May 2026 10:15:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+esG7uu50GUIv0grdtIit+uwPUufQVq/QgOnaRTA4nchk/UFVb58Uq6MWRG1ONFlw/tFVeJEi3/JQ5nbE=@vger.kernel.org
X-Received: by 2002:a0c:ea46:0:b0:8be:1620:a95a with SMTP id
 6a1803df08f44-8ca0f67c3d3mr193127066d6.27.1779124505831; Mon, 18 May 2026
 10:15:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1778822464.git.harrison.vanderbyl@gmail.com> <9e749a3a483e4a3c684eac3ee6a4b241c94a0362.1778822464.git.harrison.vanderbyl@gmail.com>
In-Reply-To: <9e749a3a483e4a3c684eac3ee6a4b241c94a0362.1778822464.git.harrison.vanderbyl@gmail.com>
From: Doug Anderson <dianders@chromium.org>
Date: Mon, 18 May 2026 10:14:54 -0700
X-Gmail-Original-Message-ID: <CAD=FV=W-T3gnhsPY1TPaShBcj6MtXhPntAm=ecZ8pK9aKg=LFg@mail.gmail.com>
X-Gm-Features: AVHnY4IADEBlAYng-Vk8ynfnLq-alsFZFnj4hN5gU5NdDYItYKJ7p8Mb41QcTng
Message-ID: <CAD=FV=W-T3gnhsPY1TPaShBcj6MtXhPntAm=ecZ8pK9aKg=LFg@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] drm/panel-edp: Add panel for Surface Pro 12in
To: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
Cc: andersson@kernel.org, konradybcio@kernel.org, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net, 
	neil.armstrong@linaro.org, maarten.lankhorst@linux.intel.com, 
	mripard@kernel.org, tzimmermann@suse.de, airlied@gmail.com, simona@ffwll.ch, 
	jikos@kernel.org, bentiss@kernel.org, luzmaximilian@gmail.com, 
	hansg@kernel.org, ilpo.jarvinen@linux.intel.com, 
	Jessica Zhang <jesszhan0024@gmail.com>, linux-arm-msm@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 14, 2026 at 10:43=E2=80=AFPM Harrison Vanderbyl
<harrison.vanderbyl@gmail.com> wrote:
>
> Add an entry for the BOE NE120DRM-N28 panel,
> used in the Microsoft Surface Pro 12-inch.
>
> The values chosen were tested to be working fine
> for wake from sleep and hibernation.
>
> Panel edid:
>
> 00 ff ff ff ff ff ff 00 09 e5 c9 0c a0 06 00 07
> 0a 22 01 04 a5 19 11 78 07 9f 15 a6 55 4c 9b 25
> 0e 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
> 01 01 01 01 01 01 62 53 94 a0 80 b8 2e 50 18 10
> 3a 00 fe a9 00 00 00 1a 13 7d 94 a0 80 b8 2e 50
> 18 10 3a 00 fe a9 00 00 00 1a 00 00 00 fd 00 18
> 5a 5b 88 20 01 0a 20 20 20 20 20 20 00 00 00 fc
> 00 4e 45 31 32 30 44 52 4d 2d 4e 32 38 0a 00 0a
>
> Signed-off-by: Harrison Vanderbyl <harrison.vanderbyl@gmail.com>
> ---
>  drivers/gpu/drm/panel/panel-edp.c | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Douglas Anderson <dianders@chromium.org>

Pushed to drm-misc-next:

[5/7] drm/panel-edp: Add panel for Surface Pro 12in
      commit: 02f48ffdf96c83ca3e6600fe5dec872b34b68775
