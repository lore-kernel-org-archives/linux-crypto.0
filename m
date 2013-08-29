From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] kernel/padata.c: Register hotcpu notifier after
 initialization
Date: Thu, 29 Aug 2013 14:43:08 +1000
Message-ID: <20130829044308.GC25208@gondor.apana.org.au>
References: <1377256353-7979-1-git-send-email-richard@nod.at>
 <20130827093041.GD7660@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Weinberger <richard@nod.at>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, gang.chen@asianux.com
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130827093041.GD7660@secunet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 27, 2013 at 11:30:41AM +0200, Steffen Klassert wrote:
> On Fri, Aug 23, 2013 at 01:12:33PM +0200, Richard Weinberger wrote:
> > padata_cpu_callback() takes pinst->lock, to avoid taking
> > an uninitialized lock, register the notifier after it's
> > initialization.
> > 
> > Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Looks ok,
> 
> Acked-by: Steffen Klassert <steffen.klassert@secunet.com>

Also applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
