From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - don't DMA map IV from stack in
 test_skcipher()
Date: Fri, 13 Jan 2017 16:46:20 +0800
Message-ID: <20170113084620.GF22022@gondor.apana.org.au>
References: <1484290756-20868-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45715 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751146AbdAMIqh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 03:46:37 -0500
Content-Disposition: inline
In-Reply-To: <1484290756-20868-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 08:59:16AM +0200, Horia Geantă wrote:
> Fix the "DMA-API: device driver maps memory from stack" warning
> generated when crypto accelerators map the IV.
> 
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Hmm, the IV comes in as a pointer.  So you should not assume that
it can be DMAed at all.

Perhaps we should change the API so that it gets passed in as an
SG list.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
