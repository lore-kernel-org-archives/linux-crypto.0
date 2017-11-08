From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 1/3] staging: ccree: copy IV to DMAable memory
Date: Wed, 8 Nov 2017 23:07:29 +1100
Message-ID: <20171108120729.GA30436@gondor.apana.org.au>
References: <1509610224-14708-1-git-send-email-gilad@benyossef.com>
 <1509610224-14708-2-git-send-email-gilad@benyossef.com>
 <VI1PR0402MB3342B8E2BF19C2C5E298981F98560@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <CAOtvUMeOXh=erNTQPzuYx2upfy4H2eQaSy+mBci_btaDuE46iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org"
        <driverdev-devel@linuxdriverproject.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOtvUMeOXh=erNTQPzuYx2upfy4H2eQaSy+mBci_btaDuE46iA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Nov 08, 2017 at 01:54:03PM +0200, Gilad Ben-Yossef wrote:
>
> As a HW based crypto driver maintainer I sympathize, but let's play
> devil's advocate for a second here:
> 
> In the current state, HW based crypto drivers need to allocate a buffer
> and copy the IV, because they don't know if they got a DMAable buffer
> or not. SW based crypto drivers don't need to do anything.

When I suggested an API change, I was thinking of an option of
supplying an SG list instead of the current kernel pointer.

IOW the existing users do not have to change but where we know
that the pointer can be DMAed you can opt in to the new interface.

The crypto API can then provide a helper to do the copying where
necessary.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
