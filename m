From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 2/4] crypto: drbg - do not create shadow copy
Date: Sat, 18 Apr 2015 14:51:13 +0200
Message-ID: <5958536.vTU0HmdF9E@myon.chronox.de>
References: <1551177.C0RmlOO9iU@myon.chronox.de> <1700799.nu8dYZU873@myon.chronox.de> <20150418104943.GA5408@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34183 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbbDRMx3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Apr 2015 08:53:29 -0400
In-Reply-To: <20150418104943.GA5408@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 18. April 2015, 18:49:43 schrieb Herbert Xu:

Hi Herbert,

> On Fri, Apr 17, 2015 at 02:54:58PM +0200, Stephan Mueller wrote:
> > The creation of a shadow copy is intended to only hold a short term
> > lock. But the drawback is that parallel users have a very similar DRBG
> > state which only differs by a high-resolution time stamp.
> > 
> > As the locking is changed to use a long-term lock to avoid such similar
> > DRBG states, the entire creation and maintenance of a shadow copy can be
> > removed.
> > 
> > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> This patch needs to come after the lock/mutex conversion.  Otherwise
> you will break bisections.

For the next patch installment, I would like to merge both patches as they 
cannot stand alone by themselves.

The separation into two patches is just done to aid code review.
> 
> Cheers,


-- 
Ciao
Stephan
