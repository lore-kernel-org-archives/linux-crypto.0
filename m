From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix rfc3686(ctr(aes)) IV load
Date: Wed, 7 Sep 2016 21:20:53 +0800
Message-ID: <20160907132052.GH17176@gondor.apana.org.au>
References: <1472648275-2542-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
        horia.geanta@nxp.com
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59490 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756625AbcIGNU7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:20:59 -0400
Content-Disposition: inline
In-Reply-To: <1472648275-2542-1-git-send-email-cata.vasile@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Aug 31, 2016 at 03:57:55PM +0300, Catalin Vasile wrote:
> -nonce is being loaded using append_load_imm_u32() instead of
> append_load_as_imm() (nonce is a byte array / stream, not a 4-byte
> variable)
> -counter is not being added in big endian format, as mandatated by
> RFC3686 and expected by the crypto engine
> 
> Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>
> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
