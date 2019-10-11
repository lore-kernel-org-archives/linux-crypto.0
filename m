Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42196C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 18:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1429F206CD
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 18:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570817475;
	bh=Vy91gWb39GX55L6RG91h/D2B4BNBN3lQmgOpTzHBEOk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=deEbcixtyFTTfBhy+z5Hzyhou5xxc1+HvNR16F6AAk9csmYoj4Jn7IkTOLs7UyLTn
	 saobX2g2DEevXzzZpNCiLhMAF6ljJqZhXV1L4Qb1y579wTbahAzYupDy1Cu1ZeowpZ
	 7YH4Eb93zkxYHRr+DUREGhpzyq0O9OW5pMDaOAXk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbfJKSLO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 14:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728374AbfJKSLN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 14:11:13 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F050220659;
        Fri, 11 Oct 2019 18:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570817473;
        bh=Vy91gWb39GX55L6RG91h/D2B4BNBN3lQmgOpTzHBEOk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ConMc7KNj22I1kOLdEqcRxj6zXyAh4j8bNIRq/968WYO+LGTZ36qvQTyjvBizT2df
         ZmIGrsZwWOxSGc9z8rf2+i8gjm+1f2HY0ZZU3v2cE05Ow+MMqYGqsv8KxOFGjN6GOq
         4dOYKrnoPrdeceHNlcEsz/SEWPMDjo9yD6klrLgc=
Date:   Fri, 11 Oct 2019 11:11:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
Subject: Re: [PATCH v4 1/5] crypto: add blake2b generic implementation
Message-ID: <20191011181110.GC235973@gmail.com>
Mail-Followup-To: David Sterba <dsterba@suse.com>,
        linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
References: <cover.1570812094.git.dsterba@suse.com>
 <6494ffe9b7940efa4de569d9371da7b1623e726b.1570812094.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6494ffe9b7940efa4de569d9371da7b1623e726b.1570812094.git.dsterba@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 06:52:04PM +0200, David Sterba wrote:
> The patch brings support of several BLAKE2 variants (2b with various
> digest lengths).  The keyed digest is supported, using tfm->setkey call.
> The in-tree user will be btrfs (for checksumming), we're going to use
> the BLAKE2b-256 variant.
> 
> The code is reference implementation taken from the official sources and
> modified in terms of kernel coding style (whitespace, comments, uintXX_t
> -> uXX types, removed unused prototypes and #ifdefs, removed testing
> code, changed secure_zero_memory -> memzero_explicit, used own helpers
> for unaligned reads/writes and rotations).
> 
> Further changes removed sanity checks of key length or output size,
> these values are verified in the crypto API callbacks or hardcoded in
> shash_alg and not exposed to users.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  crypto/Kconfig           |  17 ++
>  crypto/Makefile          |   1 +
>  crypto/blake2b_generic.c | 418 +++++++++++++++++++++++++++++++++++++++
>  include/crypto/blake2b.h |  48 +++++
>  4 files changed, 484 insertions(+)
>  create mode 100644 crypto/blake2b_generic.c
>  create mode 100644 include/crypto/blake2b.h
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index e801450bcb1c..192cbb824928 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -691,6 +691,23 @@ config CRYPTO_XXHASH
>  	  xxHash non-cryptographic hash algorithm. Extremely fast, working at
>  	  speeds close to RAM limits.
>  
> +config CRYPTO_BLAKE2B
> +	tristate "BLAKE2b digest algorithm"
> +	select CRYPTO_HASH
> +	help
> +	  Implementation of cryptographic hash function BLAKE2b (or just BLAKE2),
> +	  optimized for 64bit platforms and can produce digests of any size
> +	  between 1 to 64.  The keyed hash is also implemented.
> +
> +	  This module provides the following algorithms:
> +
> +	  - blake2b-160
> +	  - blake2b-256
> +	  - blake2b-384
> +	  - blake2b-512
> +
> +	  See https://blake2.net for further information.
> +
>  config CRYPTO_CRCT10DIF
>  	tristate "CRCT10DIF algorithm"
>  	select CRYPTO_HASH
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 9479e1a45d8c..2318420d3e71 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -74,6 +74,7 @@ obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
>  obj-$(CONFIG_CRYPTO_WP512) += wp512.o
>  CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
>  obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
> +obj-$(CONFIG_CRYPTO_BLAKE2B) += blake2b_generic.o
>  obj-$(CONFIG_CRYPTO_GF128MUL) += gf128mul.o
>  obj-$(CONFIG_CRYPTO_ECB) += ecb.o
>  obj-$(CONFIG_CRYPTO_CBC) += cbc.o
> diff --git a/crypto/blake2b_generic.c b/crypto/blake2b_generic.c
> new file mode 100644
> index 000000000000..e31fb669383b
> --- /dev/null
> +++ b/crypto/blake2b_generic.c
> @@ -0,0 +1,418 @@
> +// SPDX-License-Identifier: (GPL-2.0-only OR Apache-2.0)
> +/*
> + * BLAKE2b reference source code package - reference C implementations
> + *
> + * Copyright 2012, Samuel Neves <sneves@dei.uc.pt>.  You may use this under the
> + * terms of the CC0, the OpenSSL Licence, or the Apache Public License 2.0, at
> + * your option.  The terms of these licenses can be found at:
> + *
> + * - CC0 1.0 Universal : http://creativecommons.org/publicdomain/zero/1.0
> + * - OpenSSL license   : https://www.openssl.org/source/license.html
> + * - Apache 2.0        : http://www.apache.org/licenses/LICENSE-2.0
> + *
> + * More information about the BLAKE2 hash function can be found at
> + * https://blake2.net.
> + */

Can you also adjust this comment to make it clear that this isn't the reference
implementation verbatim, but rather it's been modified for inclusion in the
kernel?

Thanks!

- Eric
