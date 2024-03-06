Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989DC64A
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 06:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709707107; cv=none; b=RReOE9c/LsKtCIfV3NOYaPcpeaApBQFtyOEOoCE4TXLS927PvfbAIaiF0DktHO8mohnYLAXqlUKq+jY9Mbeezf6I+5O3xOUO8JAVinDcK5bNeRDk5y8H3NjS8WZuzyGX/G5jY/ZGW63Un4l8obhc6AE8fRKAabYgVHV64Hri+sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709707107; c=relaxed/simple;
	bh=HH7K1WNDhoQ3MkjVo6gzMQIl8o8J+y/dZsh8puYvlP4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qCr3FIaKoVRytE3/+j5phwaMgKGiA29A0p1rfxB4mBRNVOf0KSHKTJp7/v0oLitw8orRr7L/5pjU6QzaOMv29AsQC2e9GACmRs5gRl2K24nwjvHA6PsYL8i0bekEBwy+QoVosjooYW/kMr63J8LgTVqvO5eLfAmgHgveAOZE3y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=elP1/ZQi; arc=none smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="elP1/ZQi"
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-60978479651so61036987b3.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2024 22:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1709707103; x=1710311903; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BlArYInbOhxmoEQTWfhuwhSM1jpwA5slcmPKBD9VMKs=;
        b=elP1/ZQi5+z2Nb3BBNIQHtiXcQSJ+TzrAk9+d8D3llYglOVan7a0oDRd8X/iarT8BC
         lCXARAB+JmJmIWaGrbYxR3+HtGlDAPMYDsyZwQnSCHj3UrOfwErg9WhYYCrq3FR4OMif
         VfUpoA+9Otb935WxU0juyeXxHxcX0cKp8+Y7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709707103; x=1710311903;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BlArYInbOhxmoEQTWfhuwhSM1jpwA5slcmPKBD9VMKs=;
        b=rSoUo7Y4HinF0p2P9VldjCvE4u+EEWKCa7xGRINbXknPYG3VTF7jAGO816dE30FRHC
         smYsLezV2R61CrqWevOI9bBtZE8vfEzHn9XgJiQbqb1dS0YmzHhQ3bmaBxbjaxu0BRHW
         ZHPRPuICxocppoOIWBlNhk5FDcmOkAVY818coRSS52nwYnOed0MVMUOXtE67vBIRDsWK
         TIMaComkbzTnO++LCU3+y/XPzZYxAEVkfNeo0eO9z3JZbVMVUOFods6Pd9G6t/4Hi6Qp
         Gu9E03v/kHqMMV/PQn1rVHKYuKBYMAEah28r7ojQIIjY6YFwgsCLH5W6q2643DXq3bED
         XVMw==
X-Forwarded-Encrypted: i=1; AJvYcCWy1vYEzqlww3y/idpbt2oI19wxnaCM9Mz2+ox+g3cmqq2AVQDXMwtPUOvvXlB3Rd6+qmOX6rWKT5hrLktzV2UdMqR0D7RFurEyYVGJ
X-Gm-Message-State: AOJu0YxZmzMSSKZC05eR9TtdvBRNK/ryiauhmzDCCZ6VhEXyGnva9W9l
	Df2uYfRsBl2xdNjoq+p2ml1SnYFU+76O9NuaewCuQpD4FCewYhVbhV17jCca1VZf7psX3A4DhpB
	gHD4g06RLccisd66G5HiEY/L+npEuXSYQwrM2IA==
X-Google-Smtp-Source: AGHT+IFRM/SgwR9t/jTsYEeuP8kb9njZuVC7RcCiQN7uao115wbnSi6yqV5ekzZKHSz+jX4SM/JuxZofnsc5PslPrIY=
X-Received: by 2002:a25:4f02:0:b0:dcd:72f7:15b8 with SMTP id
 d2-20020a254f02000000b00dcd72f715b8mr10654389ybb.11.1709707103576; Tue, 05
 Mar 2024 22:38:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com>
 <20240305112831.3380896-3-pavitrakumarm@vayavyalabs.com> <820315ee-eb76-4444-bdad-b1e353cfce48@linux.microsoft.com>
In-Reply-To: <820315ee-eb76-4444-bdad-b1e353cfce48@linux.microsoft.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 6 Mar 2024 12:08:12 +0530
Message-ID: <CALxtO0mRevWe8n1Cbc3uO4As4cQBVNJmsdPjusn0ip+p7Wun+w@mail.gmail.com>
Subject: Re: [PATCH 2/4] Add SPACC Kconfig and Makefile
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	shwetar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Easwar,
   The default will be a module, my bad. I will rectify this in the v1 patc=
h,
   which I am already working on.

- PK

On Wed, Mar 6, 2024 at 11:12=E2=80=AFAM Easwar Hariharan
<eahariha@linux.microsoft.com> wrote:
>
> On 3/5/2024 3:28 AM, Pavitrakumar M wrote:
> > Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > ---
> >  drivers/crypto/dwc-spacc/Kconfig  | 95 +++++++++++++++++++++++++++++++
> >  drivers/crypto/dwc-spacc/Makefile | 16 ++++++
> >  2 files changed, 111 insertions(+)
> >  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
> >  create mode 100644 drivers/crypto/dwc-spacc/Makefile
> >
> > diff --git a/drivers/crypto/dwc-spacc/Kconfig b/drivers/crypto/dwc-spac=
c/Kconfig
> > new file mode 100644
> > index 000000000000..6f40358f7932
> > --- /dev/null
> > +++ b/drivers/crypto/dwc-spacc/Kconfig
> > @@ -0,0 +1,95 @@
> > +# SPDX-License-Identifier: GPL-2.0-only
> > +
> > +config CRYPTO_DEV_SPACC
> > +     tristate "Support for dw_spacc Security protocol accelerators"
> > +     depends on HAS_DMA
> > +     default y
>
> <snip>
>
> Why is the default y rather than n or m? I would prefer it to be a module=
, but I just want
> to understand why it was chosen to be default compiled in.
>
> Thanks,
> Easwar
>
