From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/14] crypto: caam - fixes, clean-up
Date: Sun, 13 Nov 2016 19:35:31 +0800
Message-ID: <20161113113531.GF7399@gondor.apana.org.au>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39009 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933710AbcKMLgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 06:36:05 -0500
Content-Disposition: inline
In-Reply-To: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 09, 2016 at 10:46:10AM +0200, Horia Geantă wrote:
> This is a batch of fixes and clean-up for caam driver.
> 
> Only the fix for the givencrypt shared descriptors is high-impact
> and thus sent to -stable.

All applied.  Thanks.

I decided to keep the first patch in cryptodev as it's been broken
for so long that we can afford to wait for another cycle.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
