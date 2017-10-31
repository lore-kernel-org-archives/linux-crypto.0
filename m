From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr: don't allocate IV on stack
Date: Tue, 31 Oct 2017 18:19:08 +0800
Message-ID: <20171031101908.GA26530@gondor.apana.org.au>
References: <1509436586-17500-1-git-send-email-gilad@benyossef.com>
 <20171031075925.GA26147@gondor.apana.org.au>
 <VI1PR0402MB3342C4C9E798F9973FFDB6A6985E0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3342C4C9E798F9973FFDB6A6985E0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 31, 2017 at 09:05:57AM +0000, Horia Geantă wrote:
> > 
> > The driver that is mapping the IV directly should be fixed instead.
> > Only input that is given in the form of SG lists can be mapped.
> > Everything else should be copied if they need to go over DMA.
> > 
> Herbert, wouldn't it make more sense to follow your previous suggestion:
> "Perhaps we should change the API so that it gets passed in as an
> SG list."
> https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23082.html

Unless someone is willing to work on that then we have to fix the
drivers to fit the current API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
