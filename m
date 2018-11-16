Return-Path: <SRS0=1iZj=N3=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37590 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727353AbeKPQ3U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Nov 2018 11:29:20 -0500
Date: Fri, 16 Nov 2018 14:18:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Agner <stefan@agner.ch>,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH] crypto: bcm: fix normal/non key hash algorithm failure
Message-ID: <20181116061812.5lhfyriycqz2sc3v@gondor.apana.org.au>
References: <1541492938-29261-1-git-send-email-raveendra.padasalagi@broadcom.com>
 <dbac8a57-a1dd-1926-624f-cdbb2e4f6dff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbac8a57-a1dd-1926-624f-cdbb2e4f6dff@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 06, 2018 at 10:02:47AM -0800, Florian Fainelli wrote:
> On 11/6/18 12:28 AM, Raveendra Padasalagi wrote:
> > Remove setkey() callback handler for normal/non key
> > hash algorithms and keep it for AES-CBC/CMAC which needs key.
> > 
> > Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
> 
> Should this have the following Fixes tag?
> 
> Fixes: 9d12ba86f818 ("crypto: brcm - Add Broadcom SPU driver")

I added it when applying.

> >  drivers/crypto/bcm/cipher.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
