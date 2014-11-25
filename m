From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: sha-mb - remove a bogus NULL check
Date: Tue, 25 Nov 2014 22:56:01 +0800
Message-ID: <20141125145601.GC8541@gondor.apana.org.au>
References: <20141122183628.GD6994@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141122183628.GD6994@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 22, 2014 at 09:36:28PM +0300, Dan Carpenter wrote:
> This can't be NULL and we dereferenced it earlier.  Smatch used to
> ignore these things where the pointer was obviously non-NULL but I've
> found that sometimes the intention was to check something else so we
> were maybe missing bugs.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
