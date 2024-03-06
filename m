Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6335314273
	for <linux-crypto@vger.kernel.org>; Wed,  6 Mar 2024 03:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709696804; cv=none; b=DfUjPYvEP2NqRzXvku2hkP9Cjrx30CRG3TD1AUSoQ/2GTqAtv77pimm1NjaKoyicVZT6wiZOYy1DVIseTtzGDndYmFpj1jeOve4hRj0FJ+fakgN8wEDKMrM1qfYv9+iBPRG0dQXZJghAXPadPtFQ9NzWV1c2dHhduSIzwZLP6OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709696804; c=relaxed/simple;
	bh=2c78cK1XQnmsmG8+7n8w2V7n1cMXuquRqGreCLUPgjk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HGfnPJi+oZZZFe3gT9QKZTD6CW39kII4VhpIfwoexzFp/5pnRbaD+KzM4kixchVr6nvCbDTEDNVryOBMFCV32YUw1gcwj79pUcsFHtdWPH3iz9dJezpT3+KDT/t6Om8Z21VQROSBJyTwwDsByV8cZjU/NzBEvOGo6Tfgv6L21/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=agwg0mcA; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="agwg0mcA"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-60983233a0dso5500157b3.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Mar 2024 19:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1709696802; x=1710301602; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ouY2hpmeW2k/P5GfJGCZNfQwVVpUUR+xpZsAYl3McfM=;
        b=agwg0mcAvPYaoFsEv5oaWm/xAh5RoZ5wi4BfYhk/CmIFJdEuN+2J7F8Kh1qkCdLlzW
         i0jl2PiuvXdHIaX0UiJJTMd+S7hd66lOSKhL1axn79pSUfValIJsNolYaJtCB+sLqNj4
         vcxJPg51wfd+ByWN+9tTARaI8ITGmYJCZyg3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709696802; x=1710301602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ouY2hpmeW2k/P5GfJGCZNfQwVVpUUR+xpZsAYl3McfM=;
        b=ggEF42DT9c1bKc/1ccvRW9t7kdJioxv+ti0nDPxvDw41YlMYZcBKxwdtC/Ds9ruO6v
         JYVBFbysLZDw20XqZhJkb4pZniHLf4BBy8EoEHmNcdmMEAd/oRcEPzZ4425eweI+qcbW
         3+bfYjTtelACRMilbQlT8ajjQh5pPSGm/3o3w3KCRHDxf492X+z9pjaSDIOD585NAWb2
         GA9oA3Fm9CDjXbUdUybcz9/bJCs+2kr6iw0AbSnFxaJjZ2U4Mj7iX4TeB9kfzFkZhbpU
         VYc1hFk9ySask3ljPdXdpnAq0x9BOAT7U/6Uz0ARl39FyyA0l4/u4XcmRBr30jLH0kJ2
         OsCA==
X-Forwarded-Encrypted: i=1; AJvYcCVmAqs+wxa4o0Sn3E9Q6Mh8w0LADQYU1du5jUxtbLp66/YbVDGe1hnnShd6h22BYWwvI/vnRusanjLV8XEB4neQxA8NLdFQqBJ+OfpA
X-Gm-Message-State: AOJu0YynjHE3fAQeG3yb6aDMGERs9uapPj8ARs+8TX+jxGS5VYybdl+P
	ce6iRhrsoz5TyFUcv6ttwqRnjUW+ihBj3dl2unzqR702dqfkmNm4VfJW58Ay6RWl19uWoQE0mjX
	86iOWHwE85R1td9W4dW2LQ09QBklKxLhl+I4CRA==
X-Google-Smtp-Source: AGHT+IF4OR562RLSvhFbbL1fZZC9wIqI0yqHTgnE1V2E0Abmnulx7GG75/aiJTdCzrVIdEZlvt/zsJdLY3B0N1vfBgA=
X-Received: by 2002:a0d:f504:0:b0:608:d1b3:30ac with SMTP id
 e4-20020a0df504000000b00608d1b330acmr15675551ywf.30.1709696802436; Tue, 05
 Mar 2024 19:46:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240305112831.3380896-1-pavitrakumarm@vayavyalabs.com> <20240305211318.GA1202@sol.localdomain>
In-Reply-To: <20240305211318.GA1202@sol.localdomain>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Wed, 6 Mar 2024 09:16:31 +0530
Message-ID: <CALxtO0kp+vDstePYkq3AYSD-h6LRt1HvRm4HdW-OtTQm5ipqkw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add spacc crypto driver support
To: Eric Biggers <ebiggers@kernel.org>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,
  Yes we have tested this with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy

  Also is it fine if those additional algos stay inside that disabled
CONFIG. SPAcc hardware
  does support those algos.

- PK


On Wed, Mar 6, 2024 at 2:43=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Tue, Mar 05, 2024 at 04:58:27PM +0530, Pavitrakumar M wrote:
> > Add the driver for SPAcc(Security Protocol Accelerator), which is a
> > crypto acceleration IP from Synopsys. The SPAcc supports many cipher,
> > hash, aead algorithms and various modes.The driver currently supports
> > below,
>
> Has this been tested with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy?
>
> > aead:
> > - ccm(sm4)
> > - ccm(aes)
> > - gcm(sm4)
> > - gcm(aes)
> > - rfc8998(gcm(sm4))
> > - rfc7539(chacha20,poly1305)
> >
> > cipher:
> > - cbc(sm4)
> > - ecb(sm4)
> > - ofb(sm4)
> > - cfb(sm4)
> > - ctr(sm4)
> > - cbc(aes)
> > - ecb(aes)
> > - ctr(aes)
> > - xts(aes)
> > - cts(cbc(aes))
> > - cbc(des)
> > - ecb(des)
> > - cbc(des3_ede)
> > - ecb(des3_ede)
> > - chacha20
> > - xts(sm4)
> > - cts(cbc(sm4))
> > - ecb(kasumi)
> > - f8(kasumi)
> > - snow3g_uea2
> > - cs1(cbc(aes))
> > - cs2(cbc(aes))
> > - cs1(cbc(sm4))
> > - cs2(cbc(sm4))
> > - f8(sm4)
> >
> > hash:
> > - michael_mic
> > - sm3
> > - hmac(sm3)
> > - sha3-512
> > - sha3-384
> > - sha3-256
> > - sha3-224
> > - hmac(sha512)
> > - hmac(sha384)
> > - hmac(sha256)
> > - hmac(sha224)
> > - sha512
> > - sha384
> > - sha256
> > - sha224
> > - sha1
> > - hmac(sha1)
> > - md5
> > - hmac(md5)
> > - cmac(sm4)
> > - xcbc(aes)
> > - cmac(aes)
> > - xcbc(sm4)
> > - sha512-224
> > - hmac(sha512-224)
> > - sha512-256
> > - hmac(sha512-256)
> > - mac(kasumi_f9)
> > - mac(snow3g)
> > - mac(zuc)
> > - sslmac(sha1)
> > - shake128
> > - shake256
> > - cshake128
> > - cshake256
> > - kcmac128
> > - kcmac256
> > - kcmacxof128
> > - kcmacxof256
> > - sslmac(md5)
>
> Algorithms that don't have a generic implementation shouldn't be included=
.
>
> - Eric
