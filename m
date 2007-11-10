From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/1] HIFN: schedule callback invocation to tasklet.
Date: Sat, 10 Nov 2007 20:25:44 +0800
Message-ID: <20071110122544.GF5485@gondor.apana.org.au>
References: <20071109161214.GA18200@2ka.mipt.ru> <20071109183154.GA27736@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2103 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751662AbXKJMZt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 10 Nov 2007 07:25:49 -0500
Content-Disposition: inline
In-Reply-To: <20071109183154.GA27736@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 09, 2007 at 09:31:56PM +0300, Evgeniy Polyakov wrote:
> On Fri, Nov 09, 2007 at 07:12:14PM +0300, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> > This patch forces HIFN driver to invoke crypto request callbacks from
> > tasklet (softirq context) instead of hardirq context, since network
> > stack expects it to be called from bottom halves.
> 
> And first patch is obviously wrong, since it does not stop tasklet on
> exit path, please apply given one.
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

Patch applied.  Thanks Evgeniy!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
