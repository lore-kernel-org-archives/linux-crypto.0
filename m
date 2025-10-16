Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A70AD31B82B
	for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2025 11:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760615417; cv=none; b=Aevlfx3voKlbaiJM62Kde0jYTExElaRrSdh68DW8KKtXHbQ6k58RiJVoFdvhjWEe4hcqRzvxtqjTIOuwy7hFE+FurHjhvhk3U9O6pDN7UOJuUiOCo/+ElqJbI3eFNdawBvTlQTL3SnOVjsebDLv05P07MDuyhJCnhGk2M/95KAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760615417; c=relaxed/simple;
	bh=GuJID3UoruyLBRVwIrs7taaDoRRPIa9f3p+Si6XvKaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L6AL8Q/22Hs89PUDbvlJbDUB8YtAP5jJHYbJ9J5zKN+qC/WSS1OBWLT4DdIcmM09kqfVBJlk0cgC1h/L7nmvJTrTxhzukLgzEUW24kFul9uI/zox+EAETjJdFgZBYb8u1690vSldzUSld9utTVut31S7YL+BPfl70JJkBkjnNqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=a5OPXaIx; arc=none smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="a5OPXaIx"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63e11347fd9so326143d50.1
        for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2025 04:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1760615414; x=1761220214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zYh4ySUaCOCwSo/O5pikLjWDaZXOIgrvmzNlKPUYoi8=;
        b=a5OPXaIxzrOO7d80pSXAoPvjcxVz2fCzFtwkfM52qX6sCZ30k1LvcuzGBO0/iVrONx
         LL+RQJENT7AHuka6cAtTIotbX6WzDBNgLMC+K1oCtgzuqHYuxYsDJCZ0LahEJuBnDKnY
         OWhfmexqv4vwZecz721l7p/T4Di0mz04qoVhU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760615414; x=1761220214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zYh4ySUaCOCwSo/O5pikLjWDaZXOIgrvmzNlKPUYoi8=;
        b=IPrb4AZPs0VTBip/XkyXgz8auB4iPPhzZ9MB/7fVdH5lxHYyBNZ/K/iA9bJG09978I
         Ggc/UPeNmpFHig/EdeFiIwt1nnBsKJZchhQNGiqh5rTo3H9jALHvJm5Z5L9/HwEhZ6uj
         I4Ap6/Da3RBm/tGYqL134hmdgOKUUDXoeiS8DJbMrqe8WiK2sbdEoe+YH1pk4wix4dfZ
         NQJJJXZujEVMuHvNh2onLvZgHf/JFkBcnFCFSZv2Isf0a7ktYTIofKqQ1cIC2WhMXOev
         PucmFLPQhdLtSerXDBLkk6Ynn65uQwY5F8Ft6sjFnpUSl3/dm7X0WQ+n02LIt9u4n4KG
         Q3nA==
X-Gm-Message-State: AOJu0YwnTICm1osK2aZ1bJONRKG3+wa9GiWF+mPZ1pXqIcD5QbSXyIql
	CFRgcqr2J6mCDoDBzOzLFs25lQ42f+8DevAQxmXL+OBWWARK96Vj2omSRiV5UzmH6FNkyipRabt
	xMbrDOnss8PFjQMzNL93PK+EnDLn8eCUxdm8/s5Yrmg==
X-Gm-Gg: ASbGncsflrnBCVkf5oigrU3alJ11mhp1rcRhKfp1P+tmGSinGe4zrJT0YsHUQ1fPWFC
	Mnbk/d26t9M4UNJ5PvYqEltmifhpZyQoxEOAXnL9YIe2HtTXFmNwoA7kTPHewSJKmbkSoL6lweL
	Gl3l9msXJIIafnIL0LuCWZfjld1OC1RqlnPcN876rsR1UYS93TDHE7NUAPOFsp1jlygU4ojV/cD
	uJ1m50z4UKo86QJ9MvSnABBdNiZ7/QyHVipF1sDRaiQlzkiGPYcnceLFtMGUuMgvmEJt8i5p6yP
	t+Syi2Ivt767tFO/NQ==
X-Google-Smtp-Source: AGHT+IHk8WvYBHVQIElfRd5ZTF/MhPXigm+Y8VrlGkZNJUEGYoFd1ZIMeQdOamok+jXKaV+afNb4LMWmjZLM3NgawjQ=
X-Received: by 2002:a05:690e:2150:b0:63c:e0bb:2e97 with SMTP id
 956f58d0204a3-63ce0bb399amr17034086d50.10.1760615414337; Thu, 16 Oct 2025
 04:50:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251007065020.495008-1-pavitrakumarm@vayavyalabs.com> <66ade5d8-22d8-46d6-92c0-338271ac2e99@ti.com>
In-Reply-To: <66ade5d8-22d8-46d6-92c0-338271ac2e99@ti.com>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 16 Oct 2025 17:20:02 +0530
X-Gm-Features: AS18NWC-llpQDyvIoZgme4Gs6zEaOaYq19NDT9f8ElmGhoWxebQNGzUo356J0OI
Message-ID: <CALxtO0mYorK9tNb9uKcw8UF=gfGtNJT-oA-qagbNYN8Z9798sw@mail.gmail.com>
Subject: Re: [PATCH v7 0/4] Add SPAcc Crypto Driver
To: T Pratham <t-pratham@ti.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org, 
	krzk+dt@kernel.org, conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Pratham,
  Thanks for those inputs. I will fix that.

Warm regards,
PK


On Fri, Oct 10, 2025 at 12:28=E2=80=AFPM T Pratham <t-pratham@ti.com> wrote=
:
>
> Hi
> On 07/10/25 12:20, Pavitrakumar Managutte wrote:
> > Add the driver for SPAcc(Security Protocol Accelerator), which is a
> > crypto acceleration IP from Synopsys. The SPAcc supports multiple ciphe=
rs,
> > hashes and AEAD algorithms with various modes. The driver currently sup=
ports
> > below
> >
> > hash:
> > - cmac(aes)
> > - xcbc(aes)
> > - cmac(sm4)
> > - xcbc(sm4)
> > - hmac(md5)
> > - md5
> > - hmac(sha1)
> > - sha1
> > - sha224
> > - sha256
> > - sha384
> > - sha512
> > - hmac(sha224)
> > - hmac(sha256)
> > - hmac(sha384)
> > - hmac(sha512)
> > - sha3-224
> > - sha3-256
> > - sha3-384
> > - sha3-512
> > - hmac(sm3)
> > - sm3
> > - michael_mic
> >
> > Pavitrakumar Managutte (4):
> >   dt-bindings: crypto: Document support for SPAcc
> >   Add SPAcc ahash support
> >   Add SPAcc AUTODETECT Support
> >   Add SPAcc Kconfig and Makefile
>
> Use appropriate subject prefixes in commits. For crypto drivers, it is "c=
rypto: <org/chip/soc> - <your commit header>". You can find the correct pre=
fixes with `git log --oneline -- DIRECTORY_OR_FILE` on the directory your p=
atch is touching.
>
> >
> > changelog:
> >   v1->v2 changes:
> >     - Added local_bh_disable() and local_bh_enable() for the below call=
s.
> >       a. for ciphers skcipher_request_complete()
> >       b. for aead aead_request_complete()
> >       c. for hash ahash_request_complete()
> >     - dt-bindings updates
> >       a. removed snps,vspacc-priority and made it into config option
> >       b. renamed snps,spacc-wdtimer to snps,spacc-internal-counter
> >       c. Added description to all properties
> >     - Updated corresponding dt-binding changes to code
> >
> >   v2->v3 changes:
> >     - cra_init and cra_exit replaced with init_tfm and exit_tfm for has=
hes.
> >     - removed mutex_lock/unlock for spacc_skcipher_fallback call
> >     - dt-bindings updates
> >      a. updated SOC related information
> >      b. renamed compatible string as per SOC
> >    - Updated corresponding dt-binding changes to code
> >
> >   v3->v4 changes:
> >    - removed snps,vspacc-id from the dt-bindings
> >    - removed mutex_lock from ciphers
> >    - replaced magic numbers with macros
> >    - removed sw_fb variable from struct mode_tab and associated code fr=
om the
> >      hashes
> >    - polling code is replaced by wait_event_interruptible
> >
> >   v4->v5 changes:
> >    - Updated to register with the crypto-engine
> >    - Used semaphore to manage SPAcc device hardware context pool
> >    - This patchset supports Hashes only
> >    - Dropping the support for Ciphers and AEADs in this patchset
> >    - Added Reviewed-by tag on the Device tree patch since it was review=
ed on
> >      v4 patch by Krzysztof Kozlowski and Rob Herring (Arm)
> >
> >   v5->v6 changes:
> >    - Removed CRYPTO_DEV_SPACC_CIPHER and CRYPTO_DEV_SPACC_AEAD Kconfig =
options,
> >      since the cipher and aead support is not part of this patchset
> >    - Dropped spacc_skcipher.o and spacc_aead.o from Makefile to fix bui=
ld errors
> >      reported by kernel test robot
> >    - Added Reported-by and Closes tags as suggested
> >
> >   v6->v7 changes:
> >    - Fixed build error reported by Kernel test robot
> >    - Added Reported-by and Closes tags as suggested
> >
> >  .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
> >  drivers/crypto/Kconfig                        |    1 +
> >  drivers/crypto/Makefile                       |    1 +
> >  drivers/crypto/dwc-spacc/Kconfig              |   80 +
> >  drivers/crypto/dwc-spacc/Makefile             |    8 +
> >  drivers/crypto/dwc-spacc/spacc_ahash.c        |  980 +++++++
> >  drivers/crypto/dwc-spacc/spacc_core.c         | 2394 +++++++++++++++++
> >  drivers/crypto/dwc-spacc/spacc_core.h         |  830 ++++++
> >  drivers/crypto/dwc-spacc/spacc_device.c       |  283 ++
> >  drivers/crypto/dwc-spacc/spacc_device.h       |  233 ++
> >  drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
> >  drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
> >  drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
> >  drivers/crypto/dwc-spacc/spacc_manager.c      |  613 +++++
> >  14 files changed, 6289 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-s=
pacc.yaml
> >  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
> >  create mode 100644 drivers/crypto/dwc-spacc/Makefile
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
> >  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
> >
> >
> > base-commit: c0d36727bf39bb16ef0a67ed608e279535ebf0da
>
>
> --
> Regards
> T Pratham <t-pratham@ti.com>
