From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: caam - convert from ablkcipher -> skcipher
Date: Thu, 1 Sep 2016 18:12:58 +0800
Message-ID: <20160901101257.GA3362@gondor.apana.org.au>
References: <1472479884-1887-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40427 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbcIAKN4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 06:13:56 -0400
Content-Disposition: inline
In-Reply-To: <1472479884-1887-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 29, 2016 at 05:11:24PM +0300, Horia Geantă wrote:
> (a)blkcipher is being deprecated in favcur of skcipher.
> The main difference is that IV generation is moved out
> of crypto algorithms.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Thanks! Please hold on though because I'm not quite done with
the driver-side skcipher interface yet.

> but I am not sure block ciphers with IV generation - for e.g.
> seqiv(rfc3686(ctr(aes))) - make any sense and/or are useful.

This should be removed completely as IV generation is now done
at the AEAD level only.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
