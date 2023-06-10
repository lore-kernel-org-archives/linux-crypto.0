Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24D76C7EE43
	for <linux-crypto@archiver.kernel.org>; Sat, 10 Jun 2023 07:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjFJHbB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 10 Jun 2023 03:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjFJHa7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2023 03:30:59 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EE630F1
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2023 00:30:58 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-65055aa4ed7so2195733b3a.3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2023 00:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686382258; x=1688974258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FX4rjkfq6Q4OU3Lfg2YEkXwFWTXChazg+BeFxMOVHBA=;
        b=i8Qrtg41ZCDik1m/uLvxQhciH0ccN+Pp2cH2AOR2Ys3nhv4Tq0z8egXAD2a6M8tSO6
         9Ka4v/EWI1Q5It6xPwwXQeLNAIPsOLWIbwjpbUlL+9qEX0IHvlSic6XMmI49jr9DcMXV
         b51bmgHn/nCKBMjuQXilsX5e4HnKSgjfi6+d6W5PGDZC8JPJuGg9cVBlrIMuxKHaEdnB
         hjWZ9cmO5V9jQsvvvp0MRX6VmWcvwazqRkvS/tvai5VMNqgP9ZwTfag/BoqCF7N/gECi
         KlDS2YciX9ggKhwYJaUHNcqXXVnq1RBh69uJRxY4cHv+R/MZ3iD2MLLFE3KO3l9CQGER
         NBnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686382258; x=1688974258;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FX4rjkfq6Q4OU3Lfg2YEkXwFWTXChazg+BeFxMOVHBA=;
        b=hyuGQ1ckhwfIGwqNAoamUNbzMHIavnOLsgD8JlCMrBliEgXwJsuU9pcA0Y6ofsuCDY
         3d/Tg9UuBmg6Tgu9ngZXOPPczDTw3VlM/uT22a7NercJR8DmzZqHY5vUgrXWo2YlsCsd
         zMmekAQ3F7e9TtYfnrx+8fq6luy+wO2oZBOgjCc5JEFEyxy/hNfhdDX+kwrCDSlJMp6u
         a4nFotDlkmRtLQYt7VqWswdPOeq7wyJjx8k3CI1XjcE+zjQHwHjqndk1Hi0YV7Hc11hI
         lnZ2bUg23ErDaqHQi+lV+R/wM6ZRxg2xfuLR7Qm0q6dxX3Cw7yv/ic/HsgxCycs7F3AW
         jXrQ==
X-Gm-Message-State: AC+VfDyj8cjn5vlmezE7kp1GgERIFD8/qol6V9UY28HrRe0mZxFIDv5l
        p/veH1Qw460afzCVRrOgtPBy5xQh3i8=
X-Google-Smtp-Source: ACHHUZ75/l2b+p1hM+6uVlpsaoTFuFUiRB/qC5MfnjQXKTPf5+QUcBeEus4A/h1IxnNPCts8mPdUMA==
X-Received: by 2002:a17:90a:6941:b0:258:8c8f:9f81 with SMTP id j1-20020a17090a694100b002588c8f9f81mr3059350pjm.45.1686382257891;
        Sat, 10 Jun 2023 00:30:57 -0700 (PDT)
Received: from debian.me (subs09a-223-255-225-69.three.co.id. [223.255.225.69])
        by smtp.gmail.com with ESMTPSA id x21-20020a17090300d500b001a221d14179sm4338335plc.302.2023.06.10.00.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jun 2023 00:30:57 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id AFDB7106AB1; Sat, 10 Jun 2023 14:30:54 +0700 (WIB)
Date:   Sat, 10 Jun 2023 14:30:54 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Richard Fontana <rfontana@redhat.com>
Subject: Re: [PATCH 2/3] crypto: arm - add some missing SPDX headers
Message-ID: <ZIQmrj7lh7cCfC_C@debian.me>
References: <20230606173127.4050254-1-ardb@kernel.org>
 <20230606173127.4050254-3-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="E9c3Q5DD031znnQp"
Content-Disposition: inline
In-Reply-To: <20230606173127.4050254-3-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--E9c3Q5DD031znnQp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[also Cc'ing Richard]

On Tue, Jun 06, 2023 at 07:31:26PM +0200, Ard Biesheuvel wrote:
> Add some missing SPDX headers, and drop the associated boilerplate
> license text to/from the ARM implementations of ChaCha, CRC-32 and
> CRC-T10DIF.
>=20
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm/crypto/chacha-neon-core.S  | 10 +----
>  arch/arm/crypto/crc32-ce-core.S     | 30 ++-------------
>  arch/arm/crypto/crct10dif-ce-core.S | 40 +-------------------
>  3 files changed, 5 insertions(+), 75 deletions(-)
>=20
> diff --git a/arch/arm/crypto/chacha-neon-core.S b/arch/arm/crypto/chacha-=
neon-core.S
> index 13d12f672656bb8d..46d708118ef948ec 100644
> --- a/arch/arm/crypto/chacha-neon-core.S
> +++ b/arch/arm/crypto/chacha-neon-core.S
> @@ -1,21 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * ChaCha/XChaCha NEON helper functions
>   *
>   * Copyright (C) 2016 Linaro, Ltd. <ard.biesheuvel@linaro.org>
>   *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
>   * Based on:
>   * ChaCha20 256-bit cipher algorithm, RFC7539, x64 SSE3 functions
>   *
>   * Copyright (C) 2015 Martin Willi
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
>   */

I think above makes sense, since I had to pick the most restrictive one
to satisfy both license option (GPL-2.0+ or GPL-2.0-only).

> =20
>   /*
> diff --git a/arch/arm/crypto/crc32-ce-core.S b/arch/arm/crypto/crc32-ce-c=
ore.S
> index 3f13a76b9066e0f6..228a1f298f24d3d0 100644
> --- a/arch/arm/crypto/crc32-ce-core.S
> +++ b/arch/arm/crypto/crc32-ce-core.S
> @@ -1,37 +1,13 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
>  /*
>   * Accelerated CRC32(C) using ARM CRC, NEON and Crypto Extensions instru=
ctions
>   *
>   * Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - */
> -
> -/* GPL HEADER START
> - *
> - * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 only,
> - * as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful, but
> - * WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> - * General Public License version 2 for more details (a copy is included
> - * in the LICENSE file that accompanied this code).
> - *
> - * You should have received a copy of the GNU General Public License
> - * version 2 along with this program; If not, see http://www.gnu.org/lic=
enses
> - *
> - * Please  visit http://www.xyratex.com/contact if you need additional
> - * information or have any questions.
> - *
> - * GPL HEADER END
>   */

Removing second boilerplate for which the text says it musn't be removed?

> =20
>  /*
> + * Derived from the x86 SSE version:
> + *
>   * Copyright 2012 Xyratex Technology Limited
>   *
>   * Using hardware provided PCLMULQDQ instruction to accelerate the CRC32
> diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10=
dif-ce-core.S
> index 46c02c518a300ab0..5d24448fae1ccacb 100644
> --- a/arch/arm/crypto/crct10dif-ce-core.S
> +++ b/arch/arm/crypto/crct10dif-ce-core.S
> @@ -1,13 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0-only OR BSD-3-Clause */
>  //
>  // Accelerated CRC-T10DIF using ARM NEON and Crypto Extensions instructi=
ons
>  //
>  // Copyright (C) 2016 Linaro Ltd <ard.biesheuvel@linaro.org>
>  // Copyright (C) 2019 Google LLC <ebiggers@google.com>
>  //
> -// This program is free software; you can redistribute it and/or modify
> -// it under the terms of the GNU General Public License version 2 as
> -// published by the Free Software Foundation.
> -//
> =20
>  // Derived from the x86 version:
>  //
> @@ -21,41 +18,6 @@
>  //     James Guilford <james.guilford@intel.com>
>  //     Tim Chen <tim.c.chen@linux.intel.com>
>  //
> -// This software is available to you under a choice of one of two
> -// licenses.  You may choose to be licensed under the terms of the GNU
> -// General Public License (GPL) Version 2, available from the file
> -// COPYING in the main directory of this source tree, or the
> -// OpenIB.org BSD license below:
> -//
> -// Redistribution and use in source and binary forms, with or without
> -// modification, are permitted provided that the following conditions are
> -// met:
> -//
> -// * Redistributions of source code must retain the above copyright
> -//   notice, this list of conditions and the following disclaimer.
> -//
> -// * Redistributions in binary form must reproduce the above copyright
> -//   notice, this list of conditions and the following disclaimer in the
> -//   documentation and/or other materials provided with the
> -//   distribution.
> -//
> -// * Neither the name of the Intel Corporation nor the names of its
> -//   contributors may be used to endorse or promote products derived from
> -//   this software without specific prior written permission.
> -//
> -//
> -// THIS SOFTWARE IS PROVIDED BY INTEL CORPORATION ""AS IS"" AND ANY
> -// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> -// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
> -// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL INTEL CORPORATION OR
> -// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
> -// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
> -// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
> -// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
> -// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
> -// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
> -// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> -//

This dual BSD/GPL one LGTM.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--E9c3Q5DD031znnQp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZIQmrgAKCRD2uYlJVVFO
o+61AP4pzwq0A4ZjYJFUC20BrLGkXwTJtT/KJTgASpfTH4hxaQEAjn/d/D0XtpIc
WpEMr9iKmgvhfWOC7CLCQwRKQq+eJw4=
=TdJy
-----END PGP SIGNATURE-----

--E9c3Q5DD031znnQp--
