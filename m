Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7754C10A12
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 02:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725418496; cv=none; b=XVZ/ym0SShAvEk+4k3i7OzX1d1cgw56HH0i5ioaa/6RIIFClYfT1bpG5Q6L+yfQCkN0xkTacNfnAQlfVE+KvT8dyMqrByGEFeUuns6BpVlQLgRtaoyFRij+3cOK7pWDU2MzOmzDsoKkOwXC9XaqPWJ8xucLqq9844Y/BrJjdtW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725418496; c=relaxed/simple;
	bh=10tKP/Ew+JE0rXWlrRArZ1fWSafcrFIW167gUd9GvxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wr5GjuCGYIwnARIcBFmqjOOCCjbxg+nJCN5GAxzhSd7uQZP0C0D9W0P/j6lMv1/R2chRZ5P2G5TGyrpsSDFdZ4xKCg3brN6gFBUEHUlxSbSLapFFuyMteKhJkdXpoZhzKK4bkiBy27Nrc0eboWnauceOdIZlOz0J42LSa80Rg/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=U41nPKQM; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="U41nPKQM"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-dff1ccdc17bso386144276.0
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2024 19:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1725418493; x=1726023293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WHkbR4F2KG7KE35MeFc2dGBFXC7fHu657vQC2yTIXes=;
        b=U41nPKQMLiENnJG08kgLl566F9gxhjXYyaZTCijzBP/5bbLM0ajlDSncwWVYQt17++
         JBYYICjS6KvJenI8dNrYD3XuvSZIKhAXBOxbn8ZeuV4NIlP1xPmyXFUW0yZoSFsstz7L
         GoLcrPGIFMDCBCStY05zspep3UY7pAsehntF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725418493; x=1726023293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WHkbR4F2KG7KE35MeFc2dGBFXC7fHu657vQC2yTIXes=;
        b=YiNltsywqRzeX/ValT3MqkODQZDnF5k5yShuIEP59bizd/wNGN6YbsGzIqisw83mSb
         LH7vWAJF+Cj3OjneWYYybfbjGOyr1iXzQUqjbV3sfYrhLXXu8KQVs3oe4hFatK12wk7M
         JdAS4wm8xqAjmMmR9ziWtieSzg76jiHFxfogWZMpt3HmmilPSUcqSTr+dM6NczFhueCH
         VsI9aIY5ClnCeeJ92v6y+pF1HcanXQKCrOAUopTXgcXiRy8wVfPQ9z5OkoKeLsv2Ml1R
         UJZGCb1S0fylnFlb1ORGUDYeE5pPVzWmRUhGTpah+1vjPbYTewzpFiNqTErLXtQfk983
         JzQg==
X-Forwarded-Encrypted: i=1; AJvYcCVoLbgB65AfBTp/9iBXjgqbmj32j76S6NU1rxBpfD3OOVcMB8Zua7yOFkExX7swD8dyDRIwKRHNIeor0Tk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyD4XnWGPYef4qYfztwQ9UmHYcJhAnC+yZifZvxBBVPETLWWkdF
	FyfUR9MmENWvITMXUUJRkvGlD0Fe6HwI/s2WWdSUOwxQb3cg7YsIbiHZXP+vTwSbwsERRwBAObU
	tHP3HYmFcJWs+HgG1NihhxgtHItx/ED+HNXF83g==
X-Google-Smtp-Source: AGHT+IHhD/qEj1bD3oRvE4C/VPOM91r/GuxcYz0Zj7a1ww1GKw7i2sq36p3RX4Zg8uVrao551HyIedwIGTjNnRO4548=
X-Received: by 2002:a05:6902:1b0c:b0:e11:6671:4054 with SMTP id
 3f1490d57ef6-e1d0e7669a6mr1014104276.3.1725418493461; Tue, 03 Sep 2024
 19:54:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <ZrcHGxcYnsejQ7H_@gondor.apana.org.au> <20240903172509.GA1754429-robh@kernel.org>
 <ZteU3EvBxSCTeiBY@gondor.apana.org.au>
In-Reply-To: <ZteU3EvBxSCTeiBY@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 4 Sep 2024 08:24:42 +0530
Message-ID: <CALxtO0=PTBk3Va-LcRfTKUb4JCSDB0ac6DBcGin+cwit_LDCDg@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Herbert,
  I am pushing the DT bindings and all the DT changes that Rob has
asked in driver.
  We had a crash with the changes in counter mode, we were root causing tha=
t.
  The dealy was because of that.
  I am pushing the incremental patch. Please review it if the driver
it not reverted yet.

Warm regards,
Pavitrakumar


On Wed, Sep 4, 2024 at 4:29=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Tue, Sep 03, 2024 at 12:25:09PM -0500, Rob Herring wrote:
> > On Sat, Aug 10, 2024 at 02:22:19PM +0800, Herbert Xu wrote:
> > > On Mon, Jul 29, 2024 at 09:43:44AM +0530, Pavitrakumar M wrote:
> > > > Add the driver for SPAcc(Security Protocol Accelerator), which is a
> > > > crypto acceleration IP from Synopsys. The SPAcc supports many ciphe=
r,
> > > > hash, aead algorithms and various modes.The driver currently suppor=
ts
> > > > below,
> > > >
> > > > aead:
> > > > - ccm(sm4)
> > > > - ccm(aes)
> > > > - gcm(sm4)
> > > > - gcm(aes)
> > > > - rfc7539(chacha20,poly1305)
> > > >
> > > > cipher:
> > > > - cbc(sm4)
> > > > - ecb(sm4)
> > > > - ctr(sm4)
> > > > - xts(sm4)
> > > > - cts(cbc(sm4))
> > > > - cbc(aes)
> > > > - ecb(aes)
> > > > - xts(aes)
> > > > - cts(cbc(aes))
> > > > - ctr(aes)
> > > > - chacha20
> > > > - ecb(des)
> > > > - cbc(des)
> > > > - ecb(des3_ede)
> > > > - cbc(des3_ede)
> > > >
> > > > hash:
> > > > - cmac(aes)
> > > > - xcbc(aes)
> > > > - cmac(sm4)
> > > > - xcbc(sm4)
> > > > - hmac(md5)
> > > > - md5
> > > > - hmac(sha1)
> > > > - sha1
> > > > - sha224
> > > > - sha256
> > > > - sha384
> > > > - sha512
> > > > - hmac(sha224)
> > > > - hmac(sha256)
> > > > - hmac(sha384)
> > > > - hmac(sha512)
> > > > - sha3-224
> > > > - sha3-256
> > > > - sha3-384
> > > > - sha3-512
> > > > - hmac(sm3)
> > > > - sm3
> > > > - michael_mic
> > > >
> > > > Pavitrakumar M (6):
> > > >   Add SPAcc Skcipher support
> > > >   Enable SPAcc AUTODETECT
> > > >   Add SPAcc ahash support
> > > >   Add SPAcc aead support
> > > >   Add SPAcc Kconfig and Makefile
> > > >   Enable Driver compilation in crypto Kconfig and Makefile
> > > >
> > > >  drivers/crypto/Kconfig                     |    1 +
> > > >  drivers/crypto/Makefile                    |    1 +
> > > >  drivers/crypto/dwc-spacc/Kconfig           |   95 +
> > > >  drivers/crypto/dwc-spacc/Makefile          |   16 +
> > > >  drivers/crypto/dwc-spacc/spacc_aead.c      | 1260 ++++++++++
> > > >  drivers/crypto/dwc-spacc/spacc_ahash.c     |  914 +++++++
> > > >  drivers/crypto/dwc-spacc/spacc_core.c      | 2512 ++++++++++++++++=
++++
> > > >  drivers/crypto/dwc-spacc/spacc_core.h      |  826 +++++++
> > > >  drivers/crypto/dwc-spacc/spacc_device.c    |  340 +++
> > > >  drivers/crypto/dwc-spacc/spacc_device.h    |  231 ++
> > > >  drivers/crypto/dwc-spacc/spacc_hal.c       |  367 +++
> > > >  drivers/crypto/dwc-spacc/spacc_hal.h       |  114 +
> > > >  drivers/crypto/dwc-spacc/spacc_interrupt.c |  316 +++
> > > >  drivers/crypto/dwc-spacc/spacc_manager.c   |  650 +++++
> > > >  drivers/crypto/dwc-spacc/spacc_skcipher.c  |  712 ++++++
> > > >  15 files changed, 8355 insertions(+)
> > > >  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
> > > >  create mode 100644 drivers/crypto/dwc-spacc/Makefile
> > > >  create mode 100755 drivers/crypto/dwc-spacc/spacc_aead.c
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> > > >  create mode 100644 drivers/crypto/dwc-spacc/spacc_skcipher.c
> > > >
> > > >
> > > > base-commit: 95c0f5c3b8bb7acdc5c4f04bc6a7d3f40d319e9e
> > > > --
> > > > 2.25.1
> > >
> > > All applied.  Thanks.
> >
> > Please drop it. Amongst other problems I pointed out in patch, there's
> > no binding for this nor will one be accepted as-is. The author has had =
2
> > weeks to address it.
>
> OK I will revert this.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
