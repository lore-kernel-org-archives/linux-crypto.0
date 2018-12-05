Return-Path: <SRS0=adZj=OO=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:43638 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbeLEBkV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Dec 2018 20:40:21 -0500
Date: Wed, 5 Dec 2018 09:40:09 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rob Herring <robh@kernel.org>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Yael Chemla <yael.chemla@foss.arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] dt-bindings: crypto: ccree: add dt bindings for
 ccree 703
Message-ID: <20181205014009.m7sggymqeh3jjkle@gondor.apana.org.au>
References: <1542102039-22256-1-git-send-email-gilad@benyossef.com>
 <1542102039-22256-3-git-send-email-gilad@benyossef.com>
 <20181129064218.53qc33vus5anla76@gondor.apana.org.au>
 <20181204201419.GA13304@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204201419.GA13304@bogus>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 04, 2018 at 02:14:19PM -0600, Rob Herring wrote:
> On Thu, Nov 29, 2018 at 02:42:18PM +0800, Herbert Xu wrote:
> > On Tue, Nov 13, 2018 at 09:40:36AM +0000, Gilad Ben-Yossef wrote:
> > > Add device tree bindings associating Arm TrustZone CryptoCell 703 with the
> > > ccree driver.
> > > 
> > > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > > ---
> > >  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 1 +
> > >  1 file changed, 1 insertion(+)
> > 
> > Which tree is this patch meant to go through?
> 
> You should take it as it is part of a series.

Thanks Rob!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
