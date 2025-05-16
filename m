Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B09219E93;
	Fri, 16 May 2025 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747417017; cv=none; b=frQDAQsCPVZqLgfnaY/RX4u3KOtVxrJKQm7AkBevrkru/xubXxBjT46GZCcqJ2Qw047lDaEDOhAM7O7zEJDFO+hMtYbWaeeGTwLd2qukXh1jXgOgVuNmEUqcQk0Dm2bORLarRhz6T0nbT15eKo916q58Grp/cnnmC77xPv7PmIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747417017; c=relaxed/simple;
	bh=11KTuzLPta8PuFq5HMGHeyAAbypq6bhKZBp2eFuQvHk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lcCyt+yBCnOzas7If3woOvwDWSwzeMchJqNL7Go+pb+SuPfMjDpx2Wy5V7U9xc3PNG932W50pS1PppEtUFSx2qqf/A45jpup3qf1EHG4oBXQZROnxPy5BNr+ohHyae7KV0gB7CUnUwZu5PXSPJJcKrn1n8/ZXy4iWzhbsnL8pto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fC2Jws7P; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fC2Jws7P"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so18108855e9.1;
        Fri, 16 May 2025 10:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747417014; x=1748021814; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f6QQjxjPgk5p/ILY4E/8DWRz+jrN/FDqH9hiUDq8BOE=;
        b=fC2Jws7PLCN6GV6k6RM26Aaz4z4jOi8MS3w18U9WnI5eUzGGRdXrw4tuSKZDpF9vV3
         DG5/nTza0xkpIZ4in5PvW7nRxWdKiG9Up8qp1Ym5bfP4C2x8ollMKSecwRzmOwgc1pfD
         8fpeWN3/0SAOXD+4Qv5Zgp5J+qbzsSoi1ZipfrX7vmzVgxaWLapDdxx93Lmk516kM6tp
         qfFejrZwZr8VOKMEZxv5W9UHzOP4RNeGfWydf2EbIDVdmfg5aTII0CSUlngrxFk1UDzi
         Iz7t9S6uv85CWAcgsoOYb+sTtFcrT3/nD7DHXLvMY5LZDV8/oOZLQwBCxHJUKFfDHuYm
         DFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747417014; x=1748021814;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f6QQjxjPgk5p/ILY4E/8DWRz+jrN/FDqH9hiUDq8BOE=;
        b=gj9E1fpDj7VS46/Ol0yW5nIp4z/bKROVG3KAucFxWPbi1LmfpEl8BZJBLiDPjslABu
         4BMR6XiFzdNICxRN8U8FOLTyLmcq533j7Ibm33CC7idzYlhSYdAPufJvblfSq6Q2fVTN
         4ewohR7mPlemzw7WS6+ntNfI1HxCljOrOTDBaSTm+QZgWfcxxNxBLobUlr0U7rAMI19R
         UtEBOeodWbkmtrzA44wDLQ1I5TyZliSFs7T9mzyJQrDLAjqZCfscsTAHxwb7nqp9VLxW
         DRF5KxATznmSDtg481OmB2rB0PLhcztMAgOJNVSC1CnTTC+B9k6FzGy3fhcsvrYkjQLk
         AXkg==
X-Forwarded-Encrypted: i=1; AJvYcCVKOVX28nSesBW/QPN9rpIJ2UW2jZo+cDKem7U5KZaRQ2IrhSGHyFbSWgz5GC6GEGqsv5U2KwDGij83VYwt@vger.kernel.org, AJvYcCWNM/bD328ZThegupuM4pqDOUtrFVVfLRkd3+CPHbxpJ0943b5MtcdAD5nEHcJqWKeLWU03+iVfkY7OUD4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2beXKT4pcmaZerc/d1bZud7tICECcN+s7N/sZxL4uLkUZ0LM8
	czoY0Spqih7uhpwbtqmZqgFJM7+3/rmOx6WN0bnVWDpRHnhn+q9OBlN0
X-Gm-Gg: ASbGncsaEc1tJHylr3/fZZzZvTfROc5Q+l0Elnb5ICpmTEC/5IxPWMzKZOXlUrIRXBW
	9W/baGTSdt+ab8eN7+cd251HvJ8fkfrgEDqiTxixHmCPFgOoMDxgYEiBK4mfno6g1IFhluV4Wgd
	gYcBtL+kllO/YshrQk3ZsdL8Yqh8Iw+g0VeYt9p0X3p/tztxmz4ZwJB1JjYGjD3n+zVGwlo1jk5
	jhTs89jorB0xpEBMIKPt81YL2R5/11Sc74lBJ90ZnDi4ePjhSTTvdy2uaFsAAWvxN++qIonkI+U
	LzrXv+JmRbPls2d0FZ5JAaxPbt4xBakmnYZHeY04GbBvzujPQYn5aCbjWEXl9eXey2VT/ZsacMi
	dGsh8GO5IcU2fZfcK8IY=
X-Google-Smtp-Source: AGHT+IFnqfp6SFZgUJPa88LnSIu45A0pT+iLF/neMjMZKyLAyAHtZGTZaRKNnyn+H6ZF2Onk3+NMNA==
X-Received: by 2002:a05:600c:297:b0:435:edb0:5d27 with SMTP id 5b1f17b1804b1-442f84d5776mr61793195e9.9.1747417013347;
        Fri, 16 May 2025 10:36:53 -0700 (PDT)
Received: from ?IPv6:2a02:168:6806:0:4563:288:ad48:133a? ([2a02:168:6806:0:4563:288:ad48:133a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f33804d9sm113362765e9.12.2025.05.16.10.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 10:36:52 -0700 (PDT)
Message-ID: <c01e9b258e024e745ef8711bb94e0d5f6d7d4f96.camel@gmail.com>
Subject: Re: [PATCH] crypto: marvell/cesa - Avoid empty transfer descriptor
From: Klaus Kudielka <klaus.kudielka@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, regressions@lists.linux.dev,
 	linux-kernel@vger.kernel.org, Linux Crypto Mailing List	
 <linux-crypto@vger.kernel.org>, Boris Brezillon <bbrezillon@kernel.org>, 
 EBALARD Arnaud <Arnaud.Ebalard@ssi.gouv.fr>, Romain Perier
 <romain.perier@gmail.com>
Date: Fri, 16 May 2025 19:36:52 +0200
In-Reply-To: <aCa7J3I8DyRs7pP_@gondor.apana.org.au>
References: <aB8W4iuvjvAZSJoc@gondor.apana.org.au>
	 <41680c5d41ed568e8c65451843e3ff212fd340c4.camel@gmail.com>
	 <aB8t1ZTVBexqGlcm@gondor.apana.org.au>
	 <dcb0b04e479d6f3cfed87795d100ea09e4fbcf53.camel@gmail.com>
	 <aCAX8rj2ie4QMnTo@gondor.apana.org.au>
	 <28184fb96e2de8a0af32816f5ff1b3d776b57217.camel@gmail.com>
	 <aCMOyWVte4tw85_F@gondor.apana.org.au>
	 <8e9b45bdafe6ac3f12bcbb5fce5bc9949566344f.camel@gmail.com>
	 <aCQm0aHYnI6ciyPz@gondor.apana.org.au>
	 <20dde00750d803a9a364ded99dab1e3e22daec77.camel@gmail.com>
	 <aCa7J3I8DyRs7pP_@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.1-1 
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-05-16 at 12:12 +0800, Herbert Xu wrote:
>=20
> Something doesn't look right.=C2=A0 There are zero ahash lines in your
> dmesg.=C2=A0 IOW all the output was from skcipher tests alone.
>=20
> That could explain why ahash appears to be working.
>=20
> What does /proc/crypto show after boot-up? Do the cesa ahash
> algorithms show up as tested in there?
>=20
> Cheers,

Plain cryptodev tree, marvell-cesa as module.
Directly after boot, only the builtin crc32c-generic shows up.
After loading the module, the marvell-cesa ahash show up with "selftest : p=
assed".
But whether they REALLY were tested, I can't say.

# cat /proc/crypto=20
name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 4

# modprobe marvell-cesa
# cat /proc/crypto=20
name         : hmac(sha256)
driver       : mv-hmac-sha256
module       : marvell_cesa
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 32

name         : hmac(sha1)
driver       : mv-hmac-sha1
module       : marvell_cesa
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 20

name         : hmac(md5)
driver       : mv-hmac-md5
module       : marvell_cesa
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 16

name         : sha256
driver       : mv-sha256
module       : marvell_cesa
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 32

name         : sha1
driver       : mv-sha1
module       : marvell_cesa
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 20

name         : md5
driver       : mv-md5
module       : marvell_cesa
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 16

name         : cbc(aes)
driver       : mv-cbc-aes
module       : marvell_cesa
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
chunksize    : 16
walksize     : 16
statesize    : 0

name         : ecb(aes)
driver       : mv-ecb-aes
module       : marvell_cesa
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
chunksize    : 16
walksize     : 16
statesize    : 0

name         : cbc(des3_ede)
driver       : mv-cbc-des3-ede
module       : marvell_cesa
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 8
chunksize    : 8
walksize     : 8
statesize    : 0

name         : ecb(des3_ede)
driver       : mv-ecb-des3-ede
module       : marvell_cesa
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 0
chunksize    : 8
walksize     : 8
statesize    : 0

name         : cbc(des)
driver       : mv-cbc-des
module       : marvell_cesa
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
chunksize    : 8
walksize     : 8
statesize    : 0

name         : ecb(des)
driver       : mv-ecb-des
module       : marvell_cesa
priority     : 300
refcnt       : 1
selftest     : passed
internal     : no
type         : skcipher
async        : yes
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 0
chunksize    : 8
walksize     : 8
statesize    : 0

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 4

# dmesg | tail
[    4.883366] mv88e6085 f1072004.mdio-mii:10 lan2: configuring for phy/gmi=
i link mode
[    4.884517] br0: port 3(lan4) entered blocking state
[    4.884527] br0: port 3(lan4) entered forwarding state
[   88.867746] marvell-cesa f1090000.crypto: CESA device successfully regis=
tered
[   89.034292] alg: skcipher: skipping comparison tests for mv-cbc-des beca=
use cbc(des-generic) is unavailable
[   89.045265] alg: skcipher: skipping comparison tests for mv-cbc-des3-ede=
 because cbc(des3_ede-generic) is unavailable
[   89.052456] alg: skcipher: skipping comparison tests for mv-cbc-aes beca=
use cbc(aes-generic) is unavailable
[   89.099763] alg: skcipher: skipping comparison tests for mv-ecb-aes beca=
use ecb(aes-generic) is unavailable
[   89.099819] alg: skcipher: skipping comparison tests for mv-ecb-des3-ede=
 because ecb(des3_ede-generic) is unavailable
[   89.099908] alg: skcipher: skipping comparison tests for mv-ecb-des beca=
use ecb(des-generic) is unavailable

