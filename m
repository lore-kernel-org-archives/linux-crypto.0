From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [PATCH v3 2/3] MIPS: crypto: Add crc32 and crc32c hw accelerated
 module
Date: Thu, 15 Feb 2018 14:22:14 -0800
Message-ID: <20180215222214.GB49445@gmail.com>
References: <cover.a1aaa0593f5afd4b00e8131611adda3a02c060d1.1518214143.git-series.jhogan@kernel.org>
 <77eab2cb46e52be3639610a7ad574bac7bf78d73.1518214143.git-series.jhogan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-mips@linux-mips.org,
        Marcin Nowakowski <marcin.nowakowski@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: James Hogan <jhogan@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:44452 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163980AbeBOWWS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Feb 2018 17:22:18 -0500
Received: by mail-io0-f194.google.com with SMTP id z6so2301551iob.11
        for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2018 14:22:17 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <77eab2cb46e52be3639610a7ad574bac7bf78d73.1518214143.git-series.jhogan@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 09, 2018 at 10:11:06PM +0000, James Hogan wrote:
> +static struct shash_alg crc32_alg = {
> +	.digestsize		=	CHKSUM_DIGEST_SIZE,
> +	.setkey			=	chksum_setkey,
> +	.init			=	chksum_init,
> +	.update			=	chksum_update,
> +	.final			=	chksum_final,
> +	.finup			=	chksum_finup,
> +	.digest			=	chksum_digest,
> +	.descsize		=	sizeof(struct chksum_desc_ctx),
> +	.base			=	{
> +		.cra_name		=	"crc32",
> +		.cra_driver_name	=	"crc32-mips-hw",
> +		.cra_priority		=	300,
> +		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
> +		.cra_alignmask		=	0,
> +		.cra_ctxsize		=	sizeof(struct chksum_ctx),
> +		.cra_module		=	THIS_MODULE,
> +		.cra_init		=	chksum_cra_init,
> +	}
> +};
> +
> +
> +static struct shash_alg crc32c_alg = {
> +       .digestsize             =       CHKSUM_DIGEST_SIZE,
> +       .setkey                 =       chksum_setkey,
> +       .init                   =       chksum_init,
> +       .update                 =       chksumc_update,
> +       .final                  =       chksumc_final,
> +       .finup                  =       chksumc_finup,
> +       .digest                 =       chksumc_digest,
> +       .descsize               =       sizeof(struct chksum_desc_ctx),
> +       .base                   =       {
> +               .cra_name               =       "crc32c",
> +               .cra_driver_name        =       "crc32c-mips-hw",
> +               .cra_priority           =       300,
> +               .cra_blocksize          =       CHKSUM_BLOCK_SIZE,
> +               .cra_alignmask          =       0,
> +               .cra_ctxsize            =       sizeof(struct chksum_ctx),
> +               .cra_module             =       THIS_MODULE,
> +               .cra_init               =       chksum_cra_init,
> +       }
> +};

Does this actually work on the latest kernel?  Now hash algorithms must have
CRYPTO_ALG_OPTIONAL_KEY in .cra_flags if they have a .setkey method but don't
require it to be called, otherwise the crypto API will think it's a keyed hash
and not allow it to be used without a key.  I had to add this flag to the other
CRC32 and CRC32C algorithms (commit a208fa8f33031).  One of the CRC32C test
vectors even doesn't set a key so it should be causing the self-tests to fail
for "crc32c-mips-hw".  (We should add such a test vector for CRC32 too, though.)

Eric
