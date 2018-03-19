From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: doc - clarify hash callbacks state machine
Date: Mon, 19 Mar 2018 17:24:58 +0800
Message-ID: <20180319092458.GB12302@gondor.apana.org.au>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
 <20180316151642.GA6606@gondor.apana.org.au>
 <AM3PR04MB45284A83B66E00785872DE698D40@AM3PR04MB452.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AM3PR04MB45284A83B66E00785872DE698D40@AM3PR04MB452.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 19, 2018 at 06:39:50AM +0000, Horia Geantă wrote:
>
> The fact that there can be multiple requests in parallel (for a given tfm) is a
> different topic.
> Each request object has its state in its own state machine, independent from the
> other request objects.
> I assume this is clear enough.

My point is that all of the state associated with a request needs
to be stored in the request object.  If you're start storing things
in the driver/hardware, then things will get ugly one way or another.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
