Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C23283FE5
	for <linux-crypto@vger.kernel.org>; Fri,  3 Apr 2026 04:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775189418; cv=pass; b=ByUpHavpeV1LW5b7A7dCM6EJX1/IdiO4zkwLk+zgyKQxwJDxEP+vAH93u/jiLGfUAuCjTdnl1inZjBtyJ1f3Y5UErjzXNkBG8gISiXxQwYMxinVMXpP81J9lwiVEhGIROgEHpImDjEODIYEIszGCRJw2WmYRlYCdS78/Crb8DDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775189418; c=relaxed/simple;
	bh=8ppiMXufLA/kFWXI+XW0edobmt25DPORQ9//T8zMYiQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YBQdGvi0nSbdRAoIq0cgwFKV1EQcIObwaiDeGKBw1SyLfRcwAe/7RIkxITz5BnDuMBTyh95iCLZzw5XTYTq3OfPXI8UdOqZyIFdCPVlAlzZ1L8e5l4YU7U3zfx0a2ywfTFYQvvdZYAthm4YjIaS693jG/MoCisKTjW/2XQnMOo4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hWQQ+elv; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hWQQ+elv"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66bb4d4fcb4so2784529a12.2
        for <linux-crypto@vger.kernel.org>; Thu, 02 Apr 2026 21:10:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775189415; cv=none;
        d=google.com; s=arc-20240605;
        b=DmGVsWRFJf8gCswKpURxrEZd1VRK1nyKDyFcplcg8e03fxQLwWz2tDX7l0ByhkCV3i
         1Oyl69TOdsQKCq9ycp65vo4soinH0KO814dEzHJURhgS2jg7/Q5KSsglEJi8/QcpwUXY
         QLonI59mif4CvwQPyjFGOSgeUmkW58jaTjiRH1OZrWf0CTWc0LnkJ8n83FmuUFcC4SVU
         b0+H+HVST0ui0ND5Pt9TM0xNL3AtRYtOa3A1Az+u3ejY9ZdonqsyjbI9znIsJgv5LGyD
         8xxbaHH3k6DBg6vhxlpSIXO/6muHDjoDVh9up2NkyAAP1P/k6XAvqlQfyxAEbxIU4nkj
         KcqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MQSjk0t+ENDTZIZmtMaYlDzt00D+esO1IY7w8JmAigY=;
        fh=fR6FVEe5PxZ2uus14TBkFIXEmveYbg6d1JleTWkPtqA=;
        b=J3FklCjTWDnkTeqvvBpcwblDJF5eH5r1kng8wdEbFuMebcThCTLS1JVnkpAdzGZkSR
         35s2USG3kCf2z05E3PbXJ4gehvqm/cHAmH+6DeOYj/xHkBMJeHOcgxqRftH54WpVJ8dX
         9q3fNL4jEveV4HfwfGvjeYoHeeL1thVo9myW619J58XuQPg2gmq2SeIJIjtBTywkylgO
         YJQopEYLgja2P9PUncktfrL5ZAYVj10FOdTy4UXg4BVBvCo3JlIexSheLANBiBvg3iUy
         /y9WVQVtN1l4NBFGkT/N4pUJD3gSqc2xjvK2zMd9R6s/x8YHneSYSNP18ttotz33EswL
         n2ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775189415; x=1775794215; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQSjk0t+ENDTZIZmtMaYlDzt00D+esO1IY7w8JmAigY=;
        b=hWQQ+elvv/uont9fh6Iyj+yI2QduYtFYYwHAfLua2QXsKNpA/v9TROWY1KCBNOWSoQ
         mZDdBrMzr7fjArIxZ0bBeplZg9YfRPFHBtpUctkypx1oV8YwcNLIKRjJlAnuTbS9krld
         U+SPBFAdsGqu75Ne20XAOU5QO6gBdfE2okqMFjTPnfRn1nKmYhk7/2ds4+GC3nmbSjBn
         OcyZDZrIZfXKC3KgRQJsPgOhnks3oqhT22DKwpk1rn07oUi1704PDbqp3G+H1frQb2+3
         GUiT65FUigXxaZdt/Zkfy0xRvCCo+AJtB2TQodBraYxzBZZGUsNyO5dDW4hl5zSAs/Fn
         Qpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775189415; x=1775794215;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MQSjk0t+ENDTZIZmtMaYlDzt00D+esO1IY7w8JmAigY=;
        b=B9v6RBCsY01u6VEzr+Fq2oySvMQElaeAs+z02Inbdt/js/WG1YAET24nypp1fdKAW+
         KEa6/y232CgM9NhHaKlMNOm31c3aEKC5S0n6ZZ7WpQ+fkWAg/zvv4AKXf7tNj6scJETz
         SOT73BiAIfBEZ/sTswU/JC3oB+4s928VxJky9tE8a2/3kcNZRxIOOzn/Cg7AbRDRlHPk
         G7bXxLOYaYhVV1mz2epJxXt8St0jdcJrK9aVMzCFBb0vkylmiwDctgsyzx9lFp4H9ZUK
         YJf23JRxIc3HleBG52jga0WuWWnF72KRYmRhI7q4TYSfZmgIf4DHM4TD24k/cRKy3N58
         Ccig==
X-Gm-Message-State: AOJu0YzrPz5PFyBZlQrHdfZaysnVdH0Oe8ddkYVrnS1Tt62Xue6s9fHy
	Lpr7vDJh2xzLg0rJ8RHLnD3IrIRZTCykM03aJLpTAosY3BlpytjbHzlwk/De5XK26xIid3dMiqs
	Bvo3tEJPe/Mrpf46UH1bCCCVJRybXmLKxb3I49fQ=
X-Gm-Gg: AeBDiespMM2d8w6rPnuLiUWLGgw+Fif4HJc7GtPagOHoPpcb3zLHtkFYHQun0xw6uIe
	nSjSgFncTbU+Q3DSym85AjMoWLU9G7Od4ORR09jyAO4Iv4jK2cOTHHEipvLtXrcsSbHUaudaxdG
	kfMEmRJMpSBTI7rIegzGi6BoZAAhkswdfpLlwPfkZry4VHkv9TrR0xslJQS9yMsYbgrPnyC8Ej9
	3hnxLpzeq0SGuPWh7U+73sErJOXS/ysvTa+6aNZ4Ezd35PPs1/ectFgS/BfasPExPXsGcadXYJQ
	Yr/Cl8iu
X-Received: by 2002:a05:6402:538d:b0:66e:1971:e43b with SMTP id
 4fb4d7f45d1cf-66e3e8b71b8mr666558a12.0.1775189414724; Thu, 02 Apr 2026
 21:10:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
In-Reply-To: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
From: Tony He <huangya90@gmail.com>
Date: Fri, 3 Apr 2026 12:10:03 +0800
X-Gm-Features: AQROBzC4X2v1r_d4TJ320nBj-a6NY6jBHZE8x221VtpUZqvaP2bJhZ7gsQyG-AU
Message-ID: <CAAUX2SVmu+_Avs=6ipdJY9iciig4w6DzGNGaH_ZQf+LNqR=KVA@mail.gmail.com>
Subject: Re: [PATCH v11 0/4] crypto: spacc - Add SPAcc Crypto Driver
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, herbert@gondor.apana.org.au, robh@kernel.org, 
	conor+dt@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	navami.telsang@vayavyalabs.com, bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I have a question regarding the capabilities of the Synopsys
SPAcc (Security Protocol Accelerator) in this driver series.

From the documentation, SPAcc appears to be more than a generic
crypto engine and is described as supporting protocol-level
acceleration (e.g., IPsec, TLS). I would like to clarify the
exact scope of its offload capabilities, specifically for IPsec
ESP processing.

Is SPAcc capable of handling full ESP packet processing (i.e.,
beyond basic encryption/decryption and authentication)?
For example:

Can it parse ESP packets and perform decapsulation
(removing ESP headers/trailers and returning the inner
payload)?

Does it handle sequence number processing and/or
anti-replay checks?

Or is it limited to crypto operations where the
driver/software stack (e.g., Linux XFRM) must handle all
protocol-level processing such as SA lookup, replay
protection, and packet decapsulation?

In other words, should SPAcc be treated as:

a protocol-aware data-path accelerator for ESP
(with partial packet processing), or

a pure crypto offload engine where all IPsec
semantics remain in software?

Clarifying this would help understand how the driver is
expected to integrate with the Linux IPsec/XFRM framework.

Thanks.

Tony

On Wed, Mar 18, 2026 at 3:22=E2=80=AFPM Pavitrakumar Managutte
<pavitrakumarm@vayavyalabs.com> wrote:
>
> Add the driver for SPAcc(Security Protocol Accelerator), which is a
> crypto acceleration IP from Synopsys. The SPAcc supports multiple ciphers=
,
> hashes and AEAD algorithms with various modes. The driver currently suppo=
rts
> below
>
> hash:
> - cmac(aes)
> - xcbc(aes)
> - cmac(sm4)
> - xcbc(sm4)
> - hmac(md5)
> - md5
> - hmac(sha1)
> - sha1
> - sha224
> - sha256
> - sha384
> - sha512
> - hmac(sha224)
> - hmac(sha256)
> - hmac(sha384)
> - hmac(sha512)
> - sha3-224
> - sha3-256
> - sha3-384
> - sha3-512
> - hmac(sm3)
> - sm3
> - michael_mic
>
> changelog:
>   v1->v2 changes:
>     - Added local_bh_disable() and local_bh_enable() for the below calls.
>       a. for ciphers skcipher_request_complete()
>       b. for aead aead_request_complete()
>       c. for hash ahash_request_complete()
>     - dt-bindings updates
>       a. removed snps,vspacc-priority and made it into config option
>       b. renamed snps,spacc-wdtimer to snps,spacc-internal-counter
>       c. Added description to all properties
>     - Updated corresponding dt-binding changes to code
>
>   v2->v3 changes:
>     - cra_init and cra_exit replaced with init_tfm and exit_tfm for hashe=
s.
>     - removed mutex_lock/unlock for spacc_skcipher_fallback call
>     - dt-bindings updates
>      a. updated SOC related information
>      b. renamed compatible string as per SOC
>    - Updated corresponding dt-binding changes to code
>
>   v3->v4 changes:
>    - removed snps,vspacc-id from the dt-bindings
>    - removed mutex_lock from ciphers
>    - replaced magic numbers with macros
>    - removed sw_fb variable from struct mode_tab and associated code from=
 the
>      hashes
>    - polling code is replaced by wait_event_interruptible
>
>   v4->v5 changes:
>    - Updated to register with the crypto-engine
>    - Used semaphore to manage SPAcc device hardware context pool
>    - This patchset supports Hashes only
>    - Dropping the support for Ciphers and AEADs in this patchset
>    - Added Reviewed-by tag on the Device tree patch since it was reviewed=
 on
>      v4 patch by Krzysztof Kozlowski and Rob Herring (Arm)
>
>   v5->v6 changes:
>    - Removed CRYPTO_DEV_SPACC_CIPHER and CRYPTO_DEV_SPACC_AEAD Kconfig op=
tions,
>      since the cipher and aead support is not part of this patchset
>    - Dropped spacc_skcipher.o and spacc_aead.o from Makefile to fix build=
 errors
>      reported by kernel test robot
>    - Added Reported-by and Closes tags as suggested
>
>   v6->v7 changes:
>    - Fixed build error reported by Kernel test robot
>    - Added Reported-by and Closes tags as suggested
>
>   v7->v8 changes:
>    - Fixed misleading comment: Clarified that only HMAC key pre-processin=
g
>      is done in software, while the actual HMAC operation is performed by
>      hardware
>    - Simplified do_shash() function signature by removing unused paramete=
rs
>    - Updated all do_shash() call sites to use new simplified signature
>    - Fixed commit message formatting by adding "crypto: spacc - <subject>=
" to
>      all patches
>    - used __free() for scope based resource management
>
>   v8->v9 changes:
>    - Updated the software fallback implementation to use HASH_FBREQ_ON_ST=
ACK
>    - Corrected dynamic allocation of statesize and reqsize in init_tfm
>    - Fixed synchronization issues in the digest request
>
>   v9->v10 changes:
>    - Fixed unused variable warning
>
>   v10->v11 changes:
>    - Removed the redundant crypto_alloc_ahash in the init_tfm function
>    - Removed the redundant crypto_free_ahash in exit_tfm function
>    - Removed the redundant crypto_ahash_setkey call in setkey function
>
> Pavitrakumar Managutte (4):
>   dt-bindings: crypto: Document support for SPAcc
>   crypto: spacc - Add SPAcc ahash support
>   Add SPAcc AUTODETECT Support
>   crypto: spacc - Add SPAcc Kconfig and Makefile
>
>  .../bindings/crypto/snps,dwc-spacc.yaml       |   50 +
>  drivers/crypto/Kconfig                        |    1 +
>  drivers/crypto/Makefile                       |    1 +
>  drivers/crypto/dwc-spacc/Kconfig              |   88 +
>  drivers/crypto/dwc-spacc/Makefile             |    8 +
>  drivers/crypto/dwc-spacc/spacc_ahash.c        |  886 ++++++
>  drivers/crypto/dwc-spacc/spacc_core.c         | 2413 +++++++++++++++++
>  drivers/crypto/dwc-spacc/spacc_core.h         |  827 ++++++
>  drivers/crypto/dwc-spacc/spacc_device.c       |  276 ++
>  drivers/crypto/dwc-spacc/spacc_device.h       |  236 ++
>  drivers/crypto/dwc-spacc/spacc_hal.c          |  374 +++
>  drivers/crypto/dwc-spacc/spacc_hal.h          |  114 +
>  drivers/crypto/dwc-spacc/spacc_interrupt.c    |  328 +++
>  drivers/crypto/dwc-spacc/spacc_manager.c      |  610 +++++
>  14 files changed, 6212 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/snps,dwc-spa=
cc.yaml
>  create mode 100644 drivers/crypto/dwc-spacc/Kconfig
>  create mode 100644 drivers/crypto/dwc-spacc/Makefile
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_ahash.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_core.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_device.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_hal.h
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_interrupt.c
>  create mode 100644 drivers/crypto/dwc-spacc/spacc_manager.c
>
>
> base-commit: c708d3fad4217f23421b8496e231b0c5cee617a0
> --
> 2.25.1
>
>
