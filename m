Return-Path: <SRS0=ziyG=YE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FEC4C47404
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 18:04:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00C2F21835
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Oct 2019 18:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570817084;
	bh=N/VcmY3IQiznewIHsfVNXHOUII7hSi60s1YWdvm/NZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IpsWjFwUbyzMUx75K4hFA70b5VK3xofBZIi8DNUk2BWpU2j8FRQGFqIKJ4jgp8mhl
	 XpGru8kfYhX9/uE6QAoA5m93dLMqgS1Qp3bam+6tI0VtO6q+nTuhHwHolalsguJRWG
	 1GcNrcGddFPr9nxF8Feg0Rk58lsoTP7oDNB7SuMk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbfJKSEn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Oct 2019 14:04:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbfJKSEn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Oct 2019 14:04:43 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 068CC20659;
        Fri, 11 Oct 2019 18:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570817082;
        bh=N/VcmY3IQiznewIHsfVNXHOUII7hSi60s1YWdvm/NZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xaWUUYnEj7yTbr6H10WuTCzg0JGu73+KAOGVOH3q69bc+f3ZtPWQU4TtpeaITlYq9
         PSqWc1TsjAEK3tc9ZrLovm0rRvJ9whZDCXqnhrLtwZ/bzQk328+sNmQUmdf70IVO0f
         OIPaM34chq0kNc5uuxdnJqp3zs60hREQ9ps1cbQY=
Date:   Fri, 11 Oct 2019 11:04:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-crypto@vger.kernel.org, ard.biesheuvel@linaro.org
Subject: Re: [PATCH v4 1/5] crypto: add blake2b generic implementation
Message-ID: <20191011180439.GB235973@gmail.com>
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
> +
> +#include <asm/unaligned.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <linux/kernel.h>
> +#include <linux/bitops.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/blake2b.h>
> +
> +struct blake2b_param
> +{

It should be 'struct blake2b_param {'

checkpatch.pl should warn about this.  Can you fix the checkpatch warnings that
make sense to fix?

> +/* init xors IV with input parameter block */
> +static int blake2b_init_param(struct blake2b_state *S,
> +			      const struct blake2b_param *P)
> +{
> +	const u8 *p = (const u8 *)(P);
> +	size_t i;
> +
> +	blake2b_init0(S);
> +
> +	/* IV XOR ParamBlock */
> +	for (i = 0; i < 8; ++i)
> +		S->h[i] ^= get_unaligned_le64(p + sizeof(S->h[i]) * i);
> +
> +	S->outlen = P->digest_length;
> +	return 0;
> +}

No need for this to have a return value anymore.  Same with:

	blake2b_init_param()
	blake2b_update()
	blake2b_init()
	blake2b_init_key()
	blake2b_final()

The code would be more readable if they returned void, since otherwise it gives
the impression that errors can occur.

> +static int blake2b_update(struct blake2b_state *S, const void *pin, size_t inlen)
> +{
> +	const unsigned char *in = (const unsigned char *)pin;

Convention is to use 'u8', not 'unsigned char'.

> +MODULE_ALIAS_CRYPTO("blake2b");
> +MODULE_ALIAS_CRYPTO("blake2b-generic");

Should remove these module aliases now that the "blake2b" algorithm was removed.

- Eric
