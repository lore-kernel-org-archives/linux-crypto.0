From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr: Allow different compression results
Date: Sat, 21 Apr 2018 00:54:32 +0800
Message-ID: <20180420165432.etiqksfiqsiecdgz@gondor.apana.org.au>
References: <20180411182832.27761-1-jglauber@cavium.com>
 <20180419034210.nsmzuf3f6lmn7suc@gondor.apana.org.au>
 <20180419115840.GA14706@hc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahipal Challa <mchalla@cavium.com>,
        Balakrishna Bhamidipati <bbhamidipati@cavium.com>
To: Jan Glauber <jan.glauber@caviumnetworks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180419115840.GA14706@hc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Apr 19, 2018 at 01:58:40PM +0200, Jan Glauber wrote:
>
> Nice idea. Would a crypto_alloc_cipher("deflate", ...) pick the generic
> implementation or how can we select it?

For our ciphers we generally use the -generic suffix in the driver
name.  The compression algorithms seem to be all over the place on
this so we should fix them all to use the -generic suffix and then
we can simply append the -generic suffix here before allocating it.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
