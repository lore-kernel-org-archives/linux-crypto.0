From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: arm64 broken
Date: Thu, 12 Jan 2017 15:50:43 +0800
Message-ID: <20170112075043.GA14302@gondor.apana.org.au>
References: <0795D328-B031-4EFA-AA0B-603B66F9F035@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Rob Rice <rob.rice@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36033 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750937AbdALHuw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 02:50:52 -0500
Content-Disposition: inline
In-Reply-To: <0795D328-B031-4EFA-AA0B-603B66F9F035@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rob Rice <rob.rice@broadcom.com> wrote:
> I’m working on updating a patchset. The master branch in crypto-2.6 doesn’t compile for ARM64. The first couple errors are listed below. A colleague believes that the following commit in rc2 fixes the problem.

I presume you mean cryptodev and not crypto.

> commit b4b8664d291ac1998e0f0bcdc96b6397f0fe68b3
> Author: Al Viro <viro@zeniv.linux.org.uk <mailto:viro@zeniv.linux.org.uk>>
> Date:   Mon Dec 26 04:10:19 2016 -0500
> 
>    arm64: don't pull uaccess.h into *.S
>    
>    Split asm-only parts of arm64 uaccess.h into a new header and use that
>    from *.S.
>    
>    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk <mailto:viro@zeniv.linux.org.uk>>
> 
> Any chance we could either pull in the fix or move to rc2?

Sure I'll pull it in.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
