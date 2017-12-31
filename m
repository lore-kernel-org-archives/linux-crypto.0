From: Himanshu Jha <himanshujha199640@gmail.com>
Subject: Re: [PATCH] crypto: Use zeroing memory allocator instead of
 allocator/memset
Date: Sun, 31 Dec 2017 22:16:23 +0530
Message-ID: <20171231164623.GA2709@himanshu-Vostro-3559>
References: <1514723063-5614-1-git-send-email-himanshujha199640@gmail.com>
 <1514735169.1967.13.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:41002 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdLaQqb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Dec 2017 11:46:31 -0500
Content-Disposition: inline
In-Reply-To: <1514735169.1967.13.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 31, 2017 at 07:46:09AM -0800, Joe Perches wrote:
> On Sun, 2017-12-31 at 17:54 +0530, Himanshu Jha wrote:
> > Use dma_zalloc_coherent for allocating zeroed
> > memory and remove unnecessary memset function.
> > 
> > Done using Coccinelle.
> > Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 
> I thought you were going to change this tag to
> not use the "-by:" form and use something else
> like "generated-using:" or "created-with:".

Thanks for pointing that out!

I was going to ask this to Julia for the appropriate tag, but it slipped
my mind. In future I will definitely choose more appropriate tag
on the Coccinelle patches.

Just to give an insight of the problem to everyone :

While running checkpatch on patches involving the above Generated-by
tag, which is generally used to specify the cocci script used,
checkpatch prompts the below warning and error :

WARNING: Non-standard signature: Generated-by:
#10:
Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci

ERROR: Unrecognized email address:
'scripts/coccinelle/api/alloc/kzalloc-simple.cocci'

Joe suggested to not use the "-by:" form since it should be reserved
for actual people's names and email addresses.
And if you use other tag than the "-by:" tag, then there is no
error/warning produced.

Thanks
Himanshu Jha
