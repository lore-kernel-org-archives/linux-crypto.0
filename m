Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868E647772
	for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 09:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718876414; cv=none; b=NAoWHtNES2//LsejCC3989nPZWzZ0ueJg/1QmarA4GVJ6bzfk4r7HW9oR/lA1jetup8XJ0Oq1BK4mjZJCGVedb0whJeBX6mrJiIQO9lEDB5KFaKEEXtF9CVAOgIP1Cu4X2gZJeJZ4rv2TqVqW+5uUhY0o6WP2yGD/BOHJcLcddw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718876414; c=relaxed/simple;
	bh=81wRV5d6xLLaTy+w9cdcb8V1rfPwieNaDBg9qMdYkF4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ixMyRQO2yGNMAoF/mU2Dr6dxV6XiYtjPdjwWdIEvl9hly9NorMGSKcf/QnzYtJj/atIXhuP8/WbeFbY6T6+ZDCeO8SXNUT7XOV1uJPlGEX6DnHNDehB0bXIw9G5E1DwiTll2ZFkdPsE2Blca+mQGMDRHB5HC/TjKMDcE2qdJJqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=AhEMlcA7; arc=none smtp.client-ip=209.85.128.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="AhEMlcA7"
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-62cddff7f20so6058817b3.3
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jun 2024 02:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1718876411; x=1719481211; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9yvuvGzPb9yvNbyHdNFTjY4T9XesC6/RY/Iro+MqrA=;
        b=AhEMlcA7RSDOrqOtnMDjawj0j1a5q+2y/KY/H4Jap58lnfdeUIVjyFWMSD5e+IKkW1
         ZdVN6+Fjy+Q4RngsXidd1CIiQJ0rJKw02wcuUFavOYrv+//JdqVwlKy9albaEiyzWgMR
         iOo5aA08h5s5gyhgTFr1lD3zTrw7Rx1nr7u5I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718876411; x=1719481211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o9yvuvGzPb9yvNbyHdNFTjY4T9XesC6/RY/Iro+MqrA=;
        b=DqwjCJFIS75d2QceHmz4VJBIxd5MvUgB+161LIdpl081uZoA6lTXdFiBb+F0pyPyX4
         Cjpffj4NnJeHv59+rm3zoqc9hB5y7f3bVwyLqmtx6eHAvuLUMur7qYaQAWivCoTWRl/M
         fZWo+YCfqKG4tYLjqK4BKI3tg2HzXqQAzKAVOWVvFF+r8y7wfrAGEZyd2RoJNc8Vv1fe
         vkQe0WGnLHCI/rhdALdn1EeVowKUcEdUFe7vLGhQY02MxKRFH0n69/L7ePYFtmSjPCE/
         E3YO5DLshFClbEQdTDRIIw9IjWdnpc3HWV0sSf0ARzSNFbirZnc6yJ4bQe7myq2ov5IH
         hxsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcUF6hHa9R9S/DgmorqmBWD1d97EgCaP3sTjyQAxCg8tlY2svb+ksWge/5c1j9lOIoe21BBneT7qX9JWotseRsJ6L1FKB0Xlc/NjMG
X-Gm-Message-State: AOJu0YxFVSFEQFEWzSlVkvrVAK/C6hLFflBnkaV+UIRGCDvHAZ88lSb8
	Ch4OUISQmxPzIquNvQ8dzQVpg0+sN2c3Oq370tz/j1N6PmmTOHURvEthvTKWY+pGQ5nsxCAJsxN
	tu9vQ/2Ih0XRBCIX0wQlYwIxcMqkB1MYoac+gEQ==
X-Google-Smtp-Source: AGHT+IFg5vx0iXsjT2/b4vzVj4MC0xeG5mj4wB+TYWsSr75j0JHsIf3pYKquOUI5pDqlsIdFdfg9H7gay8KVCkI5gQI=
X-Received: by 2002:a05:690c:806:b0:632:6914:9b0a with SMTP id
 00721157ae682-63a903a4156mr50335257b3.44.1718876411404; Thu, 20 Jun 2024
 02:40:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240618042750.485720-1-pavitrakumarm@vayavyalabs.com>
 <20240618042750.485720-2-pavitrakumarm@vayavyalabs.com> <704905a5-fcbb-4263-b6f2-c85d65ceef00@quicinc.com>
In-Reply-To: <704905a5-fcbb-4263-b6f2-c85d65ceef00@quicinc.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 20 Jun 2024 15:10:00 +0530
Message-ID: <CALxtO0=uTP6vUHG92fqFUGZ2ygGJr+eRv3cVXeWGYxZcLdgpnQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/7] Add SPAcc Skcipher support
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks Jeff,
   Acked, I will add it to v5.

Warm Regards,
PK


On Wed, Jun 19, 2024 at 11:48=E2=80=AFPM Jeff Johnson <quic_jjohnson@quicin=
c.com> wrote:
>
> On 6/17/24 21:27, Pavitrakumar M wrote:
> > Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > ---
> >   drivers/crypto/dwc-spacc/spacc_core.c      | 1241 +++++++++++++++++++=
+
> >   drivers/crypto/dwc-spacc/spacc_core.h      |  826 +++++++++++++
> >   drivers/crypto/dwc-spacc/spacc_device.c    |  339 ++++++
> >   drivers/crypto/dwc-spacc/spacc_device.h    |  236 ++++
> >   drivers/crypto/dwc-spacc/spacc_hal.c       |  367 ++++++
> >   drivers/crypto/dwc-spacc/spacc_hal.h       |  113 ++
> >   drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 +++++
> >   drivers/crypto/dwc-spacc/spacc_manager.c   |  650 ++++++++++
> >   drivers/crypto/dwc-spacc/spacc_skcipher.c  |  715 +++++++++++
> >   9 files changed, 4803 insertions(+)
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> >   create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> >
> ...
>
> > +module_platform_driver(spacc_driver);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Synopsys, Inc.");
>
> Missing MODULE_DESCRIPTION()
> This will cause a warning with make W=3D1
>
>
