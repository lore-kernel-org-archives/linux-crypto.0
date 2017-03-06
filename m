From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] crypto: powerpc - Fix initialisation of crc32c context
Date: Mon, 6 Mar 2017 13:48:45 +1100
Message-ID: <20170306134845.133a1980@kryten>
References: <20170303065655.7317-1-dja@axtens.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
To: Daniel Axtens <dja@axtens.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hr2.samba.org ([144.76.82.148]:58568 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752559AbdCFCs5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2017 21:48:57 -0500
In-Reply-To: <20170303065655.7317-1-dja@axtens.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Daniel,

> Turning on crypto self-tests on a POWER8 shows:
> 
>     alg: hash: Test 1 failed for crc32c-vpmsum
>     00000000: ff ff ff ff
> 
> Comparing the code with the Intel CRC32c implementation on which
> ours is based shows that we are doing an init with 0, not ~0
> as CRC32c requires.
> 
> This probably wasn't caught because btrfs does its own weird
> open-coded initialisation.
> 
> Initialise our internal context to ~0 on init.
> 
> This makes the self-tests pass, and btrfs continues to work.

Thanks! Not sure how I screwed that up.

Acked-by: Anton Blanchard <anton@samba.org>

> Fixes: 6dd7a82cc54e ("crypto: powerpc - Add POWER8 optimised crc32c")
> Cc: Anton Blanchard <anton@samba.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Daniel Axtens <dja@axtens.net>
> ---
>  arch/powerpc/crypto/crc32c-vpmsum_glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/crypto/crc32c-vpmsum_glue.c
> b/arch/powerpc/crypto/crc32c-vpmsum_glue.c index
> 9fa046d56eba..411994551afc 100644 ---
> a/arch/powerpc/crypto/crc32c-vpmsum_glue.c +++
> b/arch/powerpc/crypto/crc32c-vpmsum_glue.c @@ -52,7 +52,7 @@ static
> int crc32c_vpmsum_cra_init(struct crypto_tfm *tfm) {
>  	u32 *key = crypto_tfm_ctx(tfm);
>  
> -	*key = 0;
> +	*key = ~0;
>  
>  	return 0;
>  }
