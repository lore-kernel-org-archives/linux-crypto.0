From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 00/10] crypto: caam - add DPAA2 (DPSECI) driver
Date: Thu, 17 Aug 2017 16:46:08 +0800
Message-ID: <20170817084607.GA25429@gondor.apana.org.au>
References: <20170810174253.20951-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roy Pledge <Roy.Pledge@nxp.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Radu Alexe <radu.alexe@nxp.com>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devel@driverdev.osuosl.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:47554 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbdHQIqe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 04:46:34 -0400
Content-Disposition: inline
In-Reply-To: <20170810174253.20951-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 10, 2017 at 08:42:43PM +0300, Horia Geantă wrote:
>
> Patches 5-9 are the core of the patch set, adding the driver.
> For symmetric encryption the legacy ablkcipher interface is used; the
> plan is to convert to skcipher all CAAM frontends at once at a certain
> point in time.

I'm fine with these patches.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
