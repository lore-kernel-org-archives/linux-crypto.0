From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto/morus(640,1280) - make crypto_...-algs static
Date: Fri, 5 Oct 2018 10:29:55 +0800
Message-ID: <20181005022955.r4osquwg2p3yns4k@gondor.apana.org.au>
References: <113445.1538002178@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: valdis.kletnieks@vt.edu
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <113445.1538002178@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 26, 2018 at 06:49:38PM -0400, valdis.kletnieks@vt.edu wrote:
> sparse complains thusly:
> 
>   CHECK   arch/x86/crypto/morus640-sse2-glue.c
> arch/x86/crypto/morus640-sse2-glue.c:38:1: warning: symbol 'crypto_morus640_sse2_algs' was not declared. Should it be static?
>   CHECK   arch/x86/crypto/morus1280-sse2-glue.c
> arch/x86/crypto/morus1280-sse2-glue.c:38:1: warning: symbol 'crypto_morus1280_sse2_algs' was not declared. Should it be static?
>   CHECK   arch/x86/crypto/morus1280-avx2-glue.c
> arch/x86/crypto/morus1280-avx2-glue.c:38:1: warning: symbol 'crypto_morus1280_avx2_algs' was not declared. Should it be static?
> 
> and sparse is correct - these don't need to be global and polluting the namespace.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
