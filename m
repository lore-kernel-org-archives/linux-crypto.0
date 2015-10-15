From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 3/3] crypto: keywrap - add testmgr support
Date: Thu, 15 Oct 2015 08:41:40 +0200
Message-ID: <7771087.SKby23zovI@myon.chronox.de>
References: <3564891.reL3VOPkWo@tachyon.chronox.de> <2368869.z13cidVPPU@tauon.atsec.com> <20151015005833.GA22073@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34336 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919AbbJOGlm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 02:41:42 -0400
In-Reply-To: <20151015005833.GA22073@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 15. Oktober 2015, 08:58:33 schrieb Herbert Xu:

Hi Herbert,

> On Wed, Oct 14, 2015 at 08:44:53PM +0200, Stephan Mueller wrote:
> > Did you apply the depending patch referenced in the beginning?
> > 
> > https://lkml.org/lkml/2015/6/16/342
> > 
> > I thought I understood you wanted to pull it. If not, I will add the
> > necessary code and resubmit.
> 
> Yes but I want to finish the skcipher conversion before applying
> these patches so please don't depend on them just yet.

Ok, then I will resubmit my patch, including the aforementioned patch giving 
credits to Boris.

-- 
Ciao
Stephan
