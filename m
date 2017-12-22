From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH 00/17] crypto: inside-secure - various improvements
Date: Fri, 22 Dec 2017 15:28:38 +0100
Message-ID: <20171222142838.GB8067@kwain>
References: <20171214142659.16987-1-antoine.tenart@free-electrons.com>
 <20171222091154.GJ32542@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        davem@davemloft.net, thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52671 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751980AbdLVO2u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 09:28:50 -0500
Content-Disposition: inline
In-Reply-To: <20171222091154.GJ32542@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Fri, Dec 22, 2017 at 08:11:54PM +1100, Herbert Xu wrote:
> On Thu, Dec 14, 2017 at 03:26:42PM +0100, Antoine Tenart wrote:
> > 
> > This series depends on the previous one, "crypto: inside-secure - set of
> > fixes"[1]. The series contains various improvements to the Inside Secure
> > SafeXcel driver, which are bundled in a single series to avoid any
> > conflict.
> > 
> > - Patches 1-4 are cosmetic fixes (typo, more comments and dead code removal).
> > - Patches 5-8 are small improvements, mostly to improve the invalidation
> >   path.
> > - Patches 9-15 improve the request processing in the driver, by moving
> >   the requests dequeing into a workqueue and the result handling into a
> >   threaded IRQ thread. Other small improvements are made in the same
> >   direction.
> > - Patches 16-17 introduce the support of another revision of this crypto
> >   engine, similar to the one already supported. This crypto engine can be
> >   found on Marvell boards. (The corresponding device tree patches will follow
> >   once this series lands in).
> 
> Patches 1-16 applied.  If patch 17 needs to go through the crypto
> tree please let me know.

Thanks! Yes patch 17 should got through the crypto tree as well.

Thanks,
Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
