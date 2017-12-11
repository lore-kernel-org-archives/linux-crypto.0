From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam/qi - use correct print specifier for size_t
Date: Mon, 11 Dec 2017 22:44:32 +1100
Message-ID: <20171211114432.GC12014@gondor.apana.org.au>
References: <20171128164808.19363-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43898 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752484AbdLKLpR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:45:17 -0500
Content-Disposition: inline
In-Reply-To: <20171128164808.19363-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 28, 2017 at 06:48:08PM +0200, Horia Geantă wrote:
> Fix below warnings on ARMv7 by using %zu for printing size_t values:
> 
> drivers/crypto/caam/caamalg_qi.c: In function aead_edesc_alloc:
> drivers/crypto/caam/caamalg_qi.c:417:17: warning: format %lu expects argument of type long unsigned int, but argument 4 has type unsigned int [-Wformat=]
>    sizeof(struct qm_sg_entry))
>                  ^
> drivers/crypto/caam/caamalg_qi.c:672:16: note: in expansion of macro CAAM_QI_MAX_AEAD_SG
>     qm_sg_ents, CAAM_QI_MAX_AEAD_SG);
>                 ^
> drivers/crypto/caam/caamalg_qi.c: In function ablkcipher_edesc_alloc:
> drivers/crypto/caam/caamalg_qi.c:440:17: warning: format %lu expects argument of type long unsigned int, but argument 4 has type unsigned int [-Wformat=]
>    sizeof(struct qm_sg_entry))
>                  ^
> drivers/crypto/caam/caamalg_qi.c:909:16: note: in expansion of macro CAAM_QI_MAX_ABLKCIPHER_SG
>     qm_sg_ents, CAAM_QI_MAX_ABLKCIPHER_SG);
>                 ^
> drivers/crypto/caam/caamalg_qi.c: In function ablkcipher_giv_edesc_alloc:
> drivers/crypto/caam/caamalg_qi.c:440:17: warning: format %lu expects argument of type long unsigned int, but argument 4 has type unsigned int [-Wformat=]
>    sizeof(struct qm_sg_entry))
>                  ^
> drivers/crypto/caam/caamalg_qi.c:1062:16: note: in expansion of macro CAAM_QI_MAX_ABLKCIPHER_SG
>     qm_sg_ents, CAAM_QI_MAX_ABLKCIPHER_SG);
>                 ^
> 
> Fixes: eb9ba37dc15a ("crypto: caam/qi - handle large number of S/Gs case")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
