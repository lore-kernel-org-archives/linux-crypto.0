Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA5DDC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 06:10:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiDMGNK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 02:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiDMGMv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 02:12:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C282FBC0A
        for <linux-crypto@vger.kernel.org>; Tue, 12 Apr 2022 23:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75598B820FE
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 06:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D243EC385A6;
        Wed, 13 Apr 2022 06:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649830228;
        bh=K86UuUlnXgPDcRGacM3VflCtzqp2PXlnztBKexZNyFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IL4EBRA1Kx+HmiwMsJTmJhrwlja9uugwfiG64z3xlRoS91GMMcdcyMDFg0Jbe4kxd
         l4e+jhl8X75UCG93p3uyNAeKbGkuUkiBk0p9so0b2Ahw8R7KSZL3wUpE77HHHGhnJa
         9ZaJoT7XSECPGsrkgzf12SvY91yGoPDfl3xKXu3cE3Goxozotq2XxBEsY2chgoUA9G
         I8O7p8Aqqj6D7riaOjHuwIgLODJwWBS+93H8KfgP+OXSqpDL6u7vOV4zakKrYTf+Sm
         bQ3s058tWnVGxko8XLhn+5e5Px2jqMOYtIoNg4HVBekiduIG2PgJfdVOb9lGlzFi6x
         dKXn1rpZH9CjA==
Date:   Tue, 12 Apr 2022 23:10:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 8/8] fscrypt: Add HCTR2 support for filename encryption
Message-ID: <YlZpUijo/1nJp0Bw@sol.localdomain>
References: <20220412172816.917723-1-nhuck@google.com>
 <20220412172816.917723-9-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172816.917723-9-nhuck@google.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 12, 2022 at 05:28:16PM +0000, Nathan Huckleberry wrote:
> HCTR2 is a tweakable, length-preserving encryption mode.  It has the
> same security guarantees as Adiantum, but is intended for use on CPUs
> with dedicated crypto instructions.  It fixes a known weakness with
> filename encryption: when two filenames in the same directory share a
> prefix of >= 16 bytes, with CTS-CBC their encrypted filenames share a
> common substring, leaking information.  HCTR2 does not have this
> problem.
> 
> More information on HCTR2 can be found here: Length-preserving
> encryption with HCTR2: https://eprint.iacr.org/2021/1441.pdf

Please quote titles to distinguish them from the surrounding text.  E.g.

More information on HCTR2 can be found in the paper "Length-preserving
encryption with HCTR2" (https://eprint.iacr.org/2021/1441.pdf)


> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>  Documentation/filesystems/fscrypt.rst | 19 ++++++++++++++-----
>  fs/crypto/fscrypt_private.h           |  2 +-
>  fs/crypto/keysetup.c                  |  7 +++++++
>  fs/crypto/policy.c                    |  4 ++++
>  include/uapi/linux/fscrypt.h          |  3 ++-
>  tools/include/uapi/linux/fscrypt.h    |  3 ++-
>  6 files changed, 30 insertions(+), 8 deletions(-)

Can you make sure that all fscrypt patches are Cc'ed to the linux-fscrypt
mailing list?  In this case, just Cc the whole series to there.

> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index 4d5d50dca65c..09915086abd8 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -337,6 +337,7 @@ Currently, the following pairs of encryption modes are supported:
>  - AES-256-XTS for contents and AES-256-CTS-CBC for filenames
>  - AES-128-CBC for contents and AES-128-CTS-CBC for filenames
>  - Adiantum for both contents and filenames
> +- AES-256-XTS for contents and AES-256-HCTR2 for filenames
>  
>  If unsure, you should use the (AES-256-XTS, AES-256-CTS-CBC) pair.
>  
> @@ -357,6 +358,14 @@ To use Adiantum, CONFIG_CRYPTO_ADIANTUM must be enabled.  Also, fast
>  implementations of ChaCha and NHPoly1305 should be enabled, e.g.
>  CONFIG_CRYPTO_CHACHA20_NEON and CONFIG_CRYPTO_NHPOLY1305_NEON for ARM.
>  
> +AES-256-HCTR2 is another true wide-block encryption mode.  It has the same
> +security guarantees as Adiantum, but is intended for use on CPUs with dedicated
> +crypto instructions. See the paper "Length-preserving encryption with HCTR2"
> +(https://eprint.iacr.org/2021/1441.pdf) for more details. To use HCTR2,
> +CONFIG_CRYPTO_HCTR2 must be enabled. Also, fast implementations of XCTR and
> +POLYVAL should be enabled, e.g. CRYPTO_POLYVAL_ARM64_CE and
> +CRYPTO_AES_ARM64_CE_BLK for ARM64.

"same security guarantees as Adiantum" is not really correct.  Both Adiantum and
HCTR2 are secure super-pseudorandom permutations if their underlying primitives
are secure.  So their security guarantees are pretty similar, but not literally
the same.  Can you reword this?  This potentially-misleading claim also showed
up in the commit message.

> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index ed3d623724cd..fa8bdb8c76b7 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -54,6 +54,10 @@ static bool fscrypt_valid_enc_modes(u32 contents_mode, u32 filenames_mode)
>  	    filenames_mode == FSCRYPT_MODE_ADIANTUM)
>  		return true;
>  
> +	if (contents_mode == FSCRYPT_MODE_AES_256_XTS &&
> +	    filenames_mode == FSCRYPT_MODE_AES_256_HCTR2)
> +		return true;
> +
>  	return false;
>  }

This is allowing HCTR2 for both v1 and v2 encryption policies.  I don't think we
should add any new features to v1 encryption policies, as they are deprecated.
How about allowing HCTR2 for v2 encryption policies only?  This is the first new
encryption mode where this issue has come up, but this could be handled easily
by splitting fscrypt_valid_enc_modes() into fscrypt_valid_enc_modes_v1() and
fscrypt_valid_enc_modes_v2().  The v2 one can call the v1 one to share code.

> diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
> index 9f4428be3e36..a756b29afcc2 100644
> --- a/tools/include/uapi/linux/fscrypt.h
> +++ b/tools/include/uapi/linux/fscrypt.h
> @@ -27,7 +27,8 @@
>  #define FSCRYPT_MODE_AES_128_CBC		5
>  #define FSCRYPT_MODE_AES_128_CTS		6
>  #define FSCRYPT_MODE_ADIANTUM			9
> -/* If adding a mode number > 9, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> +#define FSCRYPT_MODE_AES_256_HCTR2		10
> +/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
>  

As far as I know, you don't actually need to update the copy of UAPI headers in
tools/.  The people who maintain those files handle that.  It doesn't make sense
to have copies of files in the source tree anyway.

- Eric
