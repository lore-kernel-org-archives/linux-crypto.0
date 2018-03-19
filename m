From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: doc - clarify hash callbacks state machine
Date: Tue, 20 Mar 2018 07:33:23 +0800
Message-ID: <20180319233323.GA15897@gondor.apana.org.au>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
 <20180316151642.GA6606@gondor.apana.org.au>
 <AM3PR04MB45284A83B66E00785872DE698D40@AM3PR04MB452.eurprd04.prod.outlook.com>
 <20180319092458.GB12302@gondor.apana.org.au>
 <AM3PR04MB4520497CC3D9B2B98B8E63798D40@AM3PR04MB452.eurprd04.prod.outlook.com>
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
In-Reply-To: <AM3PR04MB4520497CC3D9B2B98B8E63798D40@AM3PR04MB452.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Mar 19, 2018 at 11:04:24AM +0000, Horia Geantă wrote:
>
> The only solution to avoid leaks in this case is to repeatedly DMA map & unmap
> the buffer.
> IOW, if one wants to load/save HW state in a buffer after an .update() and to
> instruct the crypto engine to do this operation, the following steps are involved:
> -gpp: DMA map the buffer, get its IOVA
> -gpp: program the crypto engine with IOVA, wait for crypto engine's signal
> -crypto engine: load HW state from buffer, perform the partial hash, save HW
> state in buffer, signal gpp
> -gpp: DMA unmap the buffer

What buffer are you talking about here? Is it the hash state?

If it's the hash state and assuming DMA mapping was slow enough
on your platform, you could solve it by maintaining a fixed set
of hash states that are rotated through the actual hash requests.

Let's say you allocate n such hash states which are always mapped,
then if there are less than n hash requests outstanding, you could
directly use the mapped hash states in the requests.

If there are more than n, then you simply copy in/copy out for each
hash operation.

The number n limits how many operations can be pending to be
processed by the hardware.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
