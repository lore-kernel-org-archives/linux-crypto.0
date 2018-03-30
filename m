From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: doc - clarify hash callbacks state machine
Date: Sat, 31 Mar 2018 01:41:16 +0800
Message-ID: <20180330174116.GF28120@gondor.apana.org.au>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
 <20180320075612.22719-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180320075612.22719-1-horia.geanta@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 20, 2018 at 09:56:12AM +0200, Horia Geantă wrote:
> Add a note that it is perfectly legal to "abandon" a request object:
> - call .init() and then (as many times) .update()
> - _not_ call any of .final(), .finup() or .export() at any point in
>   future
> 
> Link: https://lkml.kernel.org/r/20180222114741.GA27631@gondor.apana.org.au
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
