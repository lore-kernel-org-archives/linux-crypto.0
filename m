From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/5] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Tue, 20 Jun 2017 11:37:47 +0800
Message-ID: <20170620033747.GB17764@gondor.apana.org.au>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
 <20170524141035.21031-2-antoine.tenart@free-electrons.com>
 <20170611085353.GG31464@kwain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com,
        sebastian.hesselbarth@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:60866 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdFTDig (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 23:38:36 -0400
Content-Disposition: inline
In-Reply-To: <20170611085353.GG31464@kwain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 11, 2017 at 10:53:53AM +0200, Antoine Tenart wrote:
> Hi Herbert,
> 
> On Wed, May 24, 2017 at 04:10:31PM +0200, Antoine Tenart wrote:
> > The Inside Secure Safexcel cryptographic engine is found on some Marvell
> > SoCs (7k/8k). Document the bindings used by its driver.
> > 
> > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> 
> Since you applied the Safexcel crypto driver patch, I think you should
> also apply this patch adding the corresponding bindings documentation.

OK I've restored it in the patch queue.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
