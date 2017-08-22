From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: cavium/nitrox - Fix an error handling path in
 'nitrox_probe()'
Date: Tue, 22 Aug 2017 15:58:58 +0800
Message-ID: <20170822075858.GK6269@gondor.apana.org.au>
References: <20170816051606.14950-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, Jampala.Srikanth@cavium.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170816051606.14950-1-christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Aug 16, 2017 at 07:16:06AM +0200, Christophe JAILLET wrote:
> 'err' is known to be 0 at this point.
> If 'kzalloc()' fails, returns -ENOMEM instead of 0 which means success.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
