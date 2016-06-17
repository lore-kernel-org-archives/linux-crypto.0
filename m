From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [patch] crypto: drbg - fix an error code in drbg_init_sym_kernel()
Date: Fri, 17 Jun 2016 11:23 +0200
Message-ID: <1997601.iEDOaUsuK2@tauon.atsec.com>
References: <20160617091618.GC25609@mwanda> <1774858.Ao0ox7E6zA@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1774858.Ao0ox7E6zA@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 17. Juni 2016, 11:19:58 schrieb Stephan Mueller:

Hi Stephan,

> Am Freitag, 17. Juni 2016, 12:16:19 schrieb Dan Carpenter:
> 
> Hi Dan,
> 
> > We accidentally return PTR_ERR(NULL) which is success but we should
> > return -ENOMEM.
> > 
> > Fixes: 355912852115 ('crypto: drbg - use CTR AES instead of ECB AES')
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> Acked-by: Stephan Mueller <smueller@chronox.de>
> 
> That points to an error in the documentation of skcipher_request_alloc.

Apologies, that documentation issue has already been fixed in the 
cryptodev-2.6 tree. I was looking at the vanilla 4.6 tree for the 
documentation while I was preparing my patch.

Ciao
Stephan
