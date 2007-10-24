From: Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [PATCH] do not unroll big stuff in twofish key setup if OPTIMIZE_FOR_SIZE
Date: Wed, 24 Oct 2007 18:44:54 +0100
Message-ID: <200710241844.54215.vda.linux@googlemail.com>
References: <200710212016.25792.vda.linux@googlemail.com> <20071023060748.GA27501@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:11228 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218AbXJXRpD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Oct 2007 13:45:03 -0400
Received: by ug-out-1314.google.com with SMTP id z38so366366ugc
        for <linux-crypto@vger.kernel.org>; Wed, 24 Oct 2007 10:45:02 -0700 (PDT)
In-Reply-To: <20071023060748.GA27501@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tuesday 23 October 2007 07:07, Herbert Xu wrote:
> On Sun, Oct 21, 2007 at 08:16:25PM +0100, Denys Vlasenko wrote:
> > Hello Herbert,
> > 
> > Currently twofish cipher key setup code
> > has unrolled loops - approximately 70-100
> > instructions are repeated 40 times.
> > 
> > As a result, twofish module is the biggest module
> > in crypto/*.
> > 
> > Attached patch conditionalize this unrolling on
> > CONFIG_CC_OPTIMIZE_FOR_SIZE. Presumably, people which
> > want to use -Os will also prefer to not have these loops
> > unrolled:
> 
> Thanks for the patch Denys.
> 
> Have you looked at the performance figures on x86 for the two
> variants? If the difference is small we could just get rid of
> the unrolled version altogether.

7% slower key setup (see patch - there is a comment about it).
--
vda
