Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CB2483BC7
	for <linux-crypto@vger.kernel.org>; Wed,  7 Oct 2026 09:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791364910; cv=pass; b=Sde/Fnj/Hr7TB7cVZO3eY/mN/f2vxnWPjuSF/mogQdsuL7BNY0A67ltVL02lfdKVpICYavlL6jTpRa1ggtEdFXXpbE9LH9lkKX34/mjp5FrntA+f19RaL/nCwSR/VkFTQEwfIfH20N3B4XQgfx5zKbuTIO+++lGBKW/id2H5tcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791364910; c=relaxed/simple;
	bh=+k9UjzC2O//U1KQcGAaw8iE8fRJvciVjr4wxuLZeucg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=c/VAlDlyL4IKxOTF21kMy+xJLmKlVaFcF5qxWJ7OThFByRObTFqS0yaf51aUm7sJbKtVcOK+W/R+75xaiVL8oRVhDZ1jrIcYvr6LsKl4zMAOUuiooQUa/HsK40jb5jPIQRIiaM68hjZyVeVj5IV8mgu9cmCIPSeZhWYXC4XB3+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=cVQDy5nr; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="cVQDy5nr"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-9144e8021d3so65959976d6.3
        for <linux-crypto@vger.kernel.org>; Wed, 07 Oct 2026 02:21:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791364872; cv=none;
        d=google.com; s=arc-20260327;
        b=Y73VLUmQ49Y1ZzyMqek/oo93dlMxApykBfIam0KFK+UZy3ad9k2tdkwYJPmDTzePIj
         bjGJtJ02+Y1WrmKos7UlEC8aoFaxJ+A566rVia4VGQBCZUIs6YIRQaNDDM86I3l51nxe
         TPjv33D4EK16wPMfQDgmpk6ZEpAxNBCeiQPdzLGazSg3Qfj/tJNOywB6GNLEltw5GoNY
         2a1eu3o0OURNVdc1lWpXneRBwgFWoRt5n5c6egubX1kMkyKkypjqaO6Vr3c+2/wCb1N6
         +i4xJjr7XhY/e0pKpFwdlApMyks2pUx++v0ZSxvRN+KueK5Io4ZdD2Jo4GPbgfla3jv9
         kFtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=erfvau5Co9WQ5coq8jL94xN3/1GcKEMpNZ+LvGz4dUo=;
        fh=5YDwCeWpXEpm9H883uxM27GTy7a/SOMvOfrLtWk7kBk=;
        b=cyz3v2zXIsnuHrcGfwC4TToVMfDd/tcWfEjGSrAIg9q5cx8SNIOqXSDn273qAQvpv4
         DL0uwdfoy1OaRY19iol4eURxTeUcTR35R5hFW56brP8FUshnN5jlbu6KEGDeeW3o60Li
         y+WBBn8aH1dLU/rHvYuOcm5B+/NRiCHNwIVwutITlXJLBY565r8LOFPIarhN1Pk6eAjk
         LqwQp5I403TOaLBgVoiaaprDIF4vsPbx8evQOkJpNSlSXKe+TJ8iU8IBVIIVlmB3FUci
         u/ulo6YZGQ3Q/tcJhkOwo5Ur33N7u2K4jFSY9N7ZpetW00YoDkRbW+wfvBJt1xMJx8jp
         lJeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1791364872; x=1791969672; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=erfvau5Co9WQ5coq8jL94xN3/1GcKEMpNZ+LvGz4dUo=;
        b=cVQDy5nr37jU2ByjckJcm6dvN343iQHKA7r4qx+iYZpPOpBSjDx5ZOJi1tKW2AFIUI
         bNiXW16hOdAKK6bBUJV6HL58qq2ImcP0m6/nrbgbLx8kNFoaJxc/6Kd94jPLr7Qi9hVu
         juTKzIsZOZAHbUgb8Dz5o08GmaDzM0wWMgbNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791364872; x=1791969672;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=erfvau5Co9WQ5coq8jL94xN3/1GcKEMpNZ+LvGz4dUo=;
        b=RcvU/eo5tM86/ko0N4iPCR5eqcMHscynpoHJ7Drc6+c9oyKDqIVcoefM4dMfEZ3jS7
         FvuQ4xryqcxLeMu/UEhvu19ynrxRFYrfCj0Wl/OVIjPusYXi+S7mvGaq7zsYTfD76Yw6
         2ToShrecuNlwj++REChYk7jmlOQl1BAm8cAxK0VALWxfoZvVuN51zL6TGlLZl89Wwhda
         b2VFGX1C6myDUjzDvv2RHvzDVao1+Wt3aklNZepwVOWPAsq2WsS0XTeubUmVtkFmPob1
         R9LogKHMY9pwy8fTHsCBiRN1c+BaHq7LtCGhkpxB/anYz1VRfKjDcKUDBjUF/SKMd0Bg
         Wa5g==
X-Forwarded-Encrypted: i=1; AKwUvBy6pv729s9cLSf7pJrjhFmvG9O/w4YZXb6eg4TMTku1cdcDnFPrqf9fA1jjE1e085M8LVvvf6hIQFLBogc=@vger.kernel.org
X-Gm-Message-State: AFuF++nRTeycnZszATAaaibbjcZEphKGZ7fVaWsuwSUW6Rhpnz6pV5QC
	kKtgaCweLsosL6ND4mhITXMQrg9xtnqDA3BCYQFdWGaGhDvatroncct7KOlaIya7OHbXH/f5zzB
	3gqIFF8gcj1CAsfCL3ZwEntq2vWm5XgUDepQnvcs2PQ==
X-Gm-Gg: AYBFou3+xSuzA7pzlgvV/8ttGWsMCwuTq6qZvD/quUKk21M3jaWD+t6PCDEGNnJ3utb
	kjH3y6VfKJrRydsOZu/Lit2Z0Zrv7TWdtNVVDSLaHhS2P/nuL0j9Z/1XpmxonRBUNrZ3PwxpGpC
	YZ2fagJbKnnRS4TFqBASzOMjdDXamImtVBi9s/t1tBxY7Yx8/EjPi0JRXaxXg01AU47xZMxou9G
	XToKdLTvCONX5TmroXFAHV4aNGjf/MG78I2850JahLE8/FTFOukXcjlNxNnIncgWVi6gId2ahRQ
	lZ2LVkE8iL8wrF3xhFNQJsDNQ54Q7BUF2l9ddmHADzS3AZa1hA2b+aDeAbA17/YduSfFyK/QKNM
	Qn6TdUfSYBIcpbNgfvk8FKDzp4/wMVy7qVrzV1mBZeZ9Lobc9kRTE8djkdklNRqLh0PEBnKmMlw
	6qLZyvWQhLabDl7DG3lYZgVhdbHqFeMAc=
X-Received: by 2002:a05:6214:3289:b0:917:8705:2bc3 with SMTP id
 6a1803df08f44-91997871f9fmr32805956d6.40.1791364872130; Wed, 07 Oct 2026
 02:21:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 7 Oct 2026 14:51:00 +0530
X-Gm-Features: AclHuK8iRMocWH8mTLDUqPQ0NrCFrmtN9QbK7yWYe43Q_vvfrsvh09AJ8cny19Q
Message-ID: <CALxtO0nT-a44-HkocT5C69=sqPurEg4G-S=1BbFPWRVVjuV1eQ@mail.gmail.com>
Subject: CMAC fallback failures from SPAcc driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	"Derwig, Ruud" <ruud.derwig@gf.com>, Ross Bannerman <Ross.Bannerman@synopsys.com>, 
	Nazim Khan <nazim.khan@vayavyalabs.com>, 
	Navami R Telsang <navami.telsang@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,
   While bringing up the SPAcc async ahash hardware driver against
7.3-rc1, cmac(aes) and xcbc(aes) fail their self-tests during TFM
allocation.

I did some digging and it looks like this is due to the missing
export_core/import_core functions in the cmac software
implementations. I see that all other hash algos have
export_core/import_core functions except cmacs. Is it intentional?

For cmac(aes)/xcbc(aes) it fails. In crypto/ahash.c,
crypto_ahash_init_tfm() allocates the fallback with:

    fb = crypto_alloc_ahash(name, CRYPTO_ALG_REQ_VIRT,
                       CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT |
                       CRYPTO_AHASH_ALG_NO_EXPORT_CORE);

i.e. it requires a fallback that is synchronous, virtual-address
capable, and has NO_EXPORT_CORE clear.

On our tree no cmac(aes)/xcbc(aes) provider satisfies that: with both
CONFIG_CRYPTO_CMAC/XCBC=y and CONFIG_CRYPTO_LIB_AES_CBC_MACS=y,
neither the classic crypto/cmac.c template nor the new AES-CMAC
library shash implements export_core/import_core, so both report
NO_EXPORT_CORE. The allocation finds no fallback candidate and returns
-EINVAL:

  alg: hash: failed to allocate transform for spacc-cmac(aes): -22

BTW for SPAcc incremental(init/update/final) path, we always use the
software fallbacks since SPAcc hardware cannot export or import the
intermediate MAC state. Herbert suggested this.

Warm regards,
PK
