From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto: caam: Introduce the use of the managed version of kzalloc
Date: Sun, 1 Jun 2014 18:56:41 +0200
Message-ID: <201406011856.41778.marex@denx.de>
References: <20140527182548.GA6333@himangi-Dell>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	julia.lawall@lip6.fr
To: Himangi Saraogi <himangi774@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140527182548.GA6333@himangi-Dell>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday, May 27, 2014 at 08:25:48 PM, Himangi Saraogi wrote:
> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions.  Also, linux/device.h is added to make sure the devm_*()
> routine declarations are unambiguously available. Earlier, in the probe
> function ctrlpriv was leaked on the failure of ctrl = of_iomap(nprop, 0);
> as well as on the failure of ctrlpriv->jrpdev = kzalloc(...); . These
> two bugs have been fixed by the patch.
> 
> The following Coccinelle semantic patch was used for making the change:

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
