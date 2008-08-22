From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: how can I verify that CRYPTO_DEV_IXP4XX (ixp4xx_crypto) works?
Date: Fri, 22 Aug 2008 21:37:12 +1000
Message-ID: <E1KWUx6-0003if-00@gondolin.me.apana.org.au>
References: <48AE9F8C.1000506@wpkg.org>
Cc: linux-crypto@vger.kernel.org
To: mangoo@wpkg.org (Tomasz Chmielewski)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56891 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751529AbYHVLhR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Aug 2008 07:37:17 -0400
In-Reply-To: <48AE9F8C.1000506@wpkg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> How can I verify that CRYPTO_DEV_IXP4XX (ixp4xx_crypto) works?
> 
> I have XScale-IXP42x CPU, the ixp4xx_crypto module loads fine, but I'm 
> not sure how to use it.

Just use something that uses one of the algorithms provided by it,
e.g., setup an IPsec SA.  The system will use it automatically.
You can verify it by either looking at the refcnt field in
/proc/crypto or through lsmod.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
