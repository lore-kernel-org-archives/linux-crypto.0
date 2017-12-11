From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/18] crypto: talitos - fixes and performance improvement
Date: Mon, 11 Dec 2017 22:07:54 +1100
Message-ID: <20171211110754.GB8823@gondor.apana.org.au>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
 <20171012151959.GI31122@gondor.apana.org.au>
 <VI1PR0402MB3342A19DE16BEEB714DAA98A98300@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Christophe Leroy <christophe.leroy@c-s.fr>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:43806 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1752591AbdLKLI1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Dec 2017 06:08:27 -0500
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3342A19DE16BEEB714DAA98A98300@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 08, 2017 at 03:20:40PM +0000, Horia Geantă wrote:
> On 10/12/2017 6:20 PM, Herbert Xu wrote:
> > On Fri, Oct 06, 2017 at 03:04:31PM +0200, Christophe Leroy wrote:
> >> This serie fixes and improves the talitos crypto driver.
> >>
> >> First 6 patchs are fixes of failures reported by the new tests in the
> >> kernel crypto test manager.
> >>
> Looks like these fixes are required also on older 4.9+ -stable kernels.
> (I haven't seen them on latest 4.9.68-stable mail from Greg, even though
> they are in main tree.)
> 
> In case you agree, what would be the recommended way to add the patches
> to -stable?

I'll forward them to stable.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
