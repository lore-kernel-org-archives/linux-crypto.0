Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E5D7478;
	Thu, 19 Feb 2026 01:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771463795; cv=none; b=BeaZR4VIPZ/hq/qnc4+T6unNYaeHQUCrFepN6e/DZ7XpSXYYjyBnfdu1r/K1J2PNqG4a5T2XKec32btj045FpoQiPKl1mwbgY9GTWeku6AuidVOdN9JfbCHB3RxPAJf+OoZ8eoZqmR6g1oarvHUZAKccNCdRjdww25Nb+YHMHYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771463795; c=relaxed/simple;
	bh=9Xnao/qxvuDv5ixS9cd4LLE0obV2SnchuVolUm4Ck/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WNHvePkxpNbuQAs5QXeSoMl3CaZpLR4FoYNeP6SfAEtRgkHEYojNVGjq11oq3arTN5bVVH4tPKINey2y5i0FakHUTvTFHm3q9I/JtIpk/IqiPBYGsPDVSZr6BiEmRnxN5+f2PiW2kJV7W8zqLlNpgjL6U+MIVXC280lQpW+0gZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 9B59A72C8CC;
	Thu, 19 Feb 2026 04:08:00 +0300 (MSK)
Received: from altlinux.org (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id 85C1036D0184;
	Thu, 19 Feb 2026 04:08:00 +0300 (MSK)
Date: Thu, 19 Feb 2026 04:08:00 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Tim Bird <tim.bird@sony.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, lukas@wunner.de, 
	ignat@cloudflare.com, stefanb@linux.ibm.com, smueller@chronox.de, ajgrothe@yahoo.com, 
	salvatore.benedetto@intel.com, dhowells@redhat.com, linux-crypto@vger.kernel.org, 
	linux-spdx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: Add SPDX ids to some files
Message-ID: <aZZiNnEEIvAKgtGj@altlinux.org>
References: <20260219000939.276256-1-tim.bird@sony.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260219000939.276256-1-tim.bird@sony.com>

Tim,

On Wed, Feb 18, 2026 at 05:09:38PM -0700, Tim Bird wrote:
> Add SDPX-License-Identifier ID lines to assorted C files in the
> crypto directory, that are missing them.  Remove licensing text,
> except in cases where the text itself says that the notice must
> be retained.

You are saying "except" but in at least two cases in this patch you
removing the following text: "retain the above copyright notice, this
list of conditions and the following disclaimer." Aren't it should be
retained?

Also, in one case below you skip dual-licensing in SPDX record.

Cam you also state in the commit message the reason why you are removing
existing license texts at all and not just adding SPDX?

> 
> Signed-off-by: Tim Bird <tim.bird@sony.com>
> 
> ---
> Note that this does not finish adding SPDX id lines to all the
> files, as there are a few special cases with weird license texts.
> ---
>  crypto/algif_rng.c           |  1 +
>  crypto/anubis.c              |  7 +------
>  crypto/drbg.c                |  1 +
>  crypto/ecc.c                 | 22 +---------------------
>  crypto/fcrypt.c              | 33 +--------------------------------
>  crypto/jitterentropy-kcapi.c |  1 +
>  crypto/jitterentropy.c       |  1 +
>  crypto/khazad.c              |  7 +------
>  crypto/md4.c                 |  7 +------
>  crypto/wp512.c               |  7 +------
>  10 files changed, 10 insertions(+), 77 deletions(-)
> 
> diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> index 1a86e40c8372..a9dffe53e85a 100644
> --- a/crypto/algif_rng.c
> +++ b/crypto/algif_rng.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>  /*
>   * algif_rng: User-space interface for random number generators
>   *
> diff --git a/crypto/anubis.c b/crypto/anubis.c
> index 4b01b6ec961a..18b359883d99 100644
> --- a/crypto/anubis.c
> +++ b/crypto/anubis.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * Cryptographic API.
>   *
> @@ -21,12 +22,6 @@
>   * have put this under the GNU General Public License.
>   *
>   * By Aaron Grothe ajgrothe@yahoo.com, October 28, 2004
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
>   */
>  
>  #include <crypto/algapi.h>
> diff --git a/crypto/drbg.c b/crypto/drbg.c
> index 5e7ed5f5c192..410cecc45ab9 100644
> --- a/crypto/drbg.c
> +++ b/crypto/drbg.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>  /*
>   * DRBG: Deterministic Random Bits Generator
>   *       Based on NIST Recommended DRBG from NIST SP800-90A with the following
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index 2808b3d5f483..c38e4bc0d613 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -1,27 +1,7 @@
> +// SPDX-License-Identifier: BSD-2-Clause

The file also have the line:

  MODULE_LICENSE("Dual BSD/GPL");

Thanks,

>  /*
>   * Copyright (c) 2013, 2014 Kenneth MacKay. All rights reserved.
>   * Copyright (c) 2019 Vitaly Chikunov <vt@altlinux.org>
> - *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions are
> - * met:
> - *  * Redistributions of source code must retain the above copyright
> - *   notice, this list of conditions and the following disclaimer.
> - *  * Redistributions in binary form must reproduce the above copyright
> - *    notice, this list of conditions and the following disclaimer in the
> - *    documentation and/or other materials provided with the distribution.
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> - * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> - * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
> - * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> - * HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
> - * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
> - * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
> - * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
> - * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
> - * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
> - * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
>   */
>  
>  #include <crypto/ecc_curve.h>
> diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
> index 80036835cec5..63c542ec5b85 100644
> --- a/crypto/fcrypt.c
> +++ b/crypto/fcrypt.c
> @@ -1,45 +1,14 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later OR BSD-3-Clause
>  /* FCrypt encryption algorithm
>   *
>   * Copyright (C) 2006 Red Hat, Inc. All Rights Reserved.
>   * Written by David Howells (dhowells@redhat.com)
>   *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version
> - * 2 of the License, or (at your option) any later version.
> - *
>   * Based on code:
>   *
>   * Copyright (c) 1995 - 2000 Kungliga Tekniska Högskolan
>   * (Royal Institute of Technology, Stockholm, Sweden).
>   * All rights reserved.
> - *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - *
> - * 1. Redistributions of source code must retain the above copyright
> - *    notice, this list of conditions and the following disclaimer.
> - *
> - * 2. Redistributions in binary form must reproduce the above copyright
> - *    notice, this list of conditions and the following disclaimer in the
> - *    documentation and/or other materials provided with the distribution.
> - *
> - * 3. Neither the name of the Institute nor the names of its contributors
> - *    may be used to endorse or promote products derived from this software
> - *    without specific prior written permission.
> - *
> - * THIS SOFTWARE IS PROVIDED BY THE INSTITUTE AND CONTRIBUTORS ``AS IS'' AND
> - * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
> - * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
> - * ARE DISCLAIMED.  IN NO EVENT SHALL THE INSTITUTE OR CONTRIBUTORS BE LIABLE
> - * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
> - * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
> - * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
> - * SUCH DAMAGE.
>   */
>  
>  #include <asm/byteorder.h>
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index 7c880cf34c52..ad1d60252a96 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>  /*
>   * Non-physical true random number generator based on timing jitter --
>   * Linux Kernel Crypto API specific code
> diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
> index 3f93cdc9a7af..1ff0d5800b72 100644
> --- a/crypto/jitterentropy.c
> +++ b/crypto/jitterentropy.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
>  /*
>   * Non-physical true random number generator based on timing jitter --
>   * Jitter RNG standalone code.
> diff --git a/crypto/khazad.c b/crypto/khazad.c
> index dee54ad5f0e4..0868e0fb6ad9 100644
> --- a/crypto/khazad.c
> +++ b/crypto/khazad.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * Cryptographic API.
>   *
> @@ -11,12 +12,6 @@
>   * have put this under the GNU General Public License.
>   *
>   * By Aaron Grothe ajgrothe@yahoo.com, August 1, 2004
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
>   */
>  
>  #include <crypto/algapi.h>
> diff --git a/crypto/md4.c b/crypto/md4.c
> index 55bf47e23c13..3f04b1a2e839 100644
> --- a/crypto/md4.c
> +++ b/crypto/md4.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /* 
>   * Cryptographic API.
>   *
> @@ -13,12 +14,6 @@
>   * Copyright (c) Cryptoapi developers.
>   * Copyright (c) 2002 David S. Miller (davem@redhat.com)
>   * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
>   */
>  #include <crypto/internal/hash.h>
>  #include <linux/init.h>
> diff --git a/crypto/wp512.c b/crypto/wp512.c
> index 229b189a7988..1c9acdf007f3 100644
> --- a/crypto/wp512.c
> +++ b/crypto/wp512.c
> @@ -1,3 +1,4 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
>  /*
>   * Cryptographic API.
>   *
> @@ -12,12 +13,6 @@
>   * have put this under the GNU General Public License.
>   *
>   * By Aaron Grothe ajgrothe@yahoo.com, August 23, 2004
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License as published by
> - * the Free Software Foundation; either version 2 of the License, or
> - * (at your option) any later version.
> - *
>   */
>  #include <crypto/internal/hash.h>
>  #include <linux/init.h>
> -- 
> 2.43.0
> 
