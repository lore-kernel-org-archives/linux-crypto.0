From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: glue_helper - Delete some dead code
Date: Mon, 19 Jun 2017 14:40:26 +0800
Message-ID: <20170619064026.GA13800@gondor.apana.org.au>
References: <20170510055226.5mlkw654cl6djc65@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170510055226.5mlkw654cl6djc65@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, May 10, 2017 at 08:52:26AM +0300, Dan Carpenter wrote:
> We checked (nbytes < bsize) inside the loops so it's not possible to hit
> the "goto done;" here.  This code is cut and paste from other slightly
> different loops where we don't have the check inside the loop.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
