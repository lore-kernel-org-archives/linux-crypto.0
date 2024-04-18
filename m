Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930178C1F
	for <linux-crypto@vger.kernel.org>; Thu, 18 Apr 2024 03:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713412473; cv=none; b=CiB0llNhfj/lORQDhIHGirNWVI8JTWFNVz2/huwPaQTk524zqyFLss5TbACP7uiHkXXTfhsnvourjz5rPpufWMtgwks0mAWFUARizWnco4r1D5QEDafYoWpO9mehwl0Krrbzt31S8dBU9KQ4I3/behf6DfU2618qAurd3EALboA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713412473; c=relaxed/simple;
	bh=2NhPX9i/i/s+cOUFWCKLliTyBSWmffMhIWeQK/bDEa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IUQP0fagJ5lttq0i+DKsjZ2BX6sIaVUv2dx8s9szgF7a3E8g/wnAQcFIMh3NI0V/iDSW6N9IxDRyVAeBWbJO+FcSiU6ENevthekPAFetDI6roem3RMiaqGMndBC0Yokd0ttlTjiT10v1hDA/+x+gPDr41FKquGJ1foh95SOLqvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=gnhdrjXp; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="gnhdrjXp"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-dcd9e34430cso501772276.1
        for <linux-crypto@vger.kernel.org>; Wed, 17 Apr 2024 20:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1713412470; x=1714017270; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v2X0vSBCLmEzhta0Y8RHul4SfhXoi+XiLXfFuxgLhBU=;
        b=gnhdrjXpn9lKZHtn59chAwRAA4SYMKF1epwxJWLEy0H9Q2za8Z5szdvWG0NlOAU54w
         1xlzKnnhBfrtCvxcfatpJiG8cQixyuJzA+m63EArZ47ft3hlPwoHbF/iPbJcUzZk3Yc3
         NdIrdrsopGx9j+tmy76iULUiYC9tN5YUrBrCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713412470; x=1714017270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v2X0vSBCLmEzhta0Y8RHul4SfhXoi+XiLXfFuxgLhBU=;
        b=Q/V6tyEFnuBKM3nc34n+4HQ8rSomY/RA/t2hwShiywFDsAZn7K8hlFgDk9HhcZWUBS
         vUHuh1YAwqIB3VmqkXPfr+kbrl/R7HRdzNl6B+cWkS40mwaJL96H1zulRCZTyVDFV66g
         f3qysTwOOt+Yk17yVxykFUvf1eQV7xgkJky01yzBb3CJFBgUPS02W+YhpBkG+g92xU0C
         H8uvjc5C60ZVvIMbh4NY9TJIBsGNN4dApTOukjTG+lWFIaGUqB02copqOio30f3XIZBX
         fFYP7OrzJzZr4WEr7t2E/6Iv6UraXv7QbUVE/lhbY5FzxOyv+gYYNMbwcFgJ+YeXbfAr
         irqg==
X-Forwarded-Encrypted: i=1; AJvYcCU8554FvBoaXceeq0yS9uRJwW3TdyWW3mRZ0IbPVdNK0FCObOGsMItIDMs0WcqrV4SPOEcmkG91cWTzZ+wRSBNAwz6zh0xzbJjFBc7B
X-Gm-Message-State: AOJu0YxJA/1+hu7ajh1mxhH8OCtSOjTgFzXg0v0ZzgjzTfkoJgrCpjc9
	RCoLfeDeRnz5W8OdEFXmeXI/PSV9ScRLhYBRRiD0pjnQBB24VkWGltCLLXAF1QjZd6aQ+d3qzdx
	Vo4hqXQbARbUN+HuJ1ZkzBZdXO5mco2a3CDH2tA==
X-Google-Smtp-Source: AGHT+IHOsvDfREa2VSvRmXexsYZ7j+PG/Ma9UH5KoIdHwas/8fNi4TF3bAh7M1fJChBZHaiiLXYsH3J3saut+/m5fxU=
X-Received: by 2002:a05:690c:e19:b0:61b:6b6:5cb2 with SMTP id
 cp25-20020a05690c0e1900b0061b06b65cb2mr1359188ywb.43.1713412470290; Wed, 17
 Apr 2024 20:54:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412035342.1233930-1-pavitrakumarm@vayavyalabs.com>
 <20240412035342.1233930-2-pavitrakumarm@vayavyalabs.com> <51a5305d-04d2-4c6b-8ea3-0edc6e10c188@linux.microsoft.com>
In-Reply-To: <51a5305d-04d2-4c6b-8ea3-0edc6e10c188@linux.microsoft.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 18 Apr 2024 09:24:19 +0530
Message-ID: <CALxtO0=UT=KDY+WzZcdVj6nwPfcsmQVTCpmRGx65_SZvh91eqQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] Add SPAcc driver to Linux kernel
To: Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com, shwetar <shwetar@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Easwar,
   The driver has legacy code which was taking time in splitting, so
pushed the v2
patch without splitting. I am splitting AEAD, Hash and Cipher module code, =
which
would be easier to review instead of a single 9k loc patch.

I do appreciate your valuable time and feedback on the patches.

Warm regards,
PK

On Wed, Apr 17, 2024 at 11:08=E2=80=AFPM Easwar Hariharan
<eahariha@linux.microsoft.com> wrote:
>
> On 4/11/2024 8:53 PM, Pavitrakumar M wrote:
> > Signed-off-by: shwetar <shwetar@vayavyalabs.com>
> > Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> > Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> > ---
> >  drivers/crypto/dwc-spacc/spacc_aead.c      | 1317 +++++++++
> >  drivers/crypto/dwc-spacc/spacc_ahash.c     | 1171 ++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.c      | 2910 ++++++++++++++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.h      |  839 ++++++
> >  drivers/crypto/dwc-spacc/spacc_device.c    |  324 +++
> >  drivers/crypto/dwc-spacc/spacc_device.h    |  236 ++
> >  drivers/crypto/dwc-spacc/spacc_hal.c       |  365 +++
> >  drivers/crypto/dwc-spacc/spacc_hal.h       |  113 +
> >  drivers/crypto/dwc-spacc/spacc_interrupt.c |  204 ++
> >  drivers/crypto/dwc-spacc/spacc_manager.c   |  670 +++++
> >  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  720 +++++
> >  11 files changed, 8869 insertions(+)
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_aead.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> >
>
>
> Sorry, cannot feasibly review ~9000 lines between my other responsibiliti=
es. As mentioned in v1,
> make it easier on the folks who're giving their time by splitting up the =
series.
>
> Thanks,
> Easwar
>
