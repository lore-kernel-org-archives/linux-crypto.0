From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] crypto: x86: Remove duplicate define of SHA1_DIGEST_SIZE
Date: Thu, 29 Oct 2015 09:16:27 -0700
Message-ID: <1446135387.14635.10.camel@schen9-desk2.jf.intel.com>
References: <1444850171-17931-1-git-send-email-clabbe.montjoie@gmail.com>
	 <1445011498.14635.1.camel@schen9-desk2.jf.intel.com>
	 <20151029075108.GA25880@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: tglx@linutronix.de, ameenali023@gmail.com, bp@alien8.de,
	dan.carpenter@oracle.com, davem@davemloft.net, firogm@gmail.com,
	herbert@gondor.apana.org.au, hpa@zytor.com, mingo@redhat.com,
	minipli@googlemail.com, smueller@chronox.de, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:62311 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964920AbbJ2QQ2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 29 Oct 2015 12:16:28 -0400
In-Reply-To: <20151029075108.GA25880@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2015-10-29 at 08:51 +0100, LABBE Corentin wrote:
> On Fri, Oct 16, 2015 at 09:04:58AM -0700, Tim Chen wrote:
> > On Wed, 2015-10-14 at 21:15 +0200, LABBE Corentin wrote:
> > > The sha x86 crypto code use two define for the same thing:
> > > NUM_SHA1_DIGEST_WORDS and SHA1_DIGEST_LENGTH
> > > Replace them by SHA1_DIGEST_SIZE/4
> > 
> > Thanks.  Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
> > > 
> > > Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
> > 
> 
> Hello
> 
> Thanks for your ack, but Thomas Gleixner in the same time NACK this patch.
> Just in case I attach the new patch, for permit you to decide which one you prefer.
> 
> Regards

Looks fine.  But wonder if you should have
#define SHA1_DIGEST_WORDS (SHA1_DIGEST_SIZE / sizeof(u32))

moved to sha1.h

Tim
> 

> diff --git a/arch/x86/crypto/sha-mb/sha_mb_ctx.h b/arch/x86/crypto/sha-mb/sha_mb_ctx.h
> index e36069d..9fd36eb5 100644
> --- a/arch/x86/crypto/sha-mb/sha_mb_ctx.h
> +++ b/arch/x86/crypto/sha-mb/sha_mb_ctx.h
> @@ -94,7 +94,6 @@ enum hash_ctx_error {
>  
> 
>  /* Hash Constants and Typedefs */
> -#define SHA1_DIGEST_LENGTH          5
>  #define SHA1_LOG2_BLOCK_SIZE        6
>  
>  #define SHA1_PADLENGTHFIELD_SIZE    8
> diff --git a/arch/x86/crypto/sha-mb/sha_mb_mgr.h b/arch/x86/crypto/sha-mb/sha_mb_mgr.h
> index 08ad1a9..b295e15 100644
> --- a/arch/x86/crypto/sha-mb/sha_mb_mgr.h
> +++ b/arch/x86/crypto/sha-mb/sha_mb_mgr.h
> @@ -54,10 +54,10 @@
>  #ifndef __SHA_MB_MGR_H
>  #define __SHA_MB_MGR_H
>  
> -
> +#include <crypto/sha.h>
>  #include <linux/types.h>
>  
> -#define NUM_SHA1_DIGEST_WORDS 5
> +#define SHA1_DIGEST_WORDS (SHA1_DIGEST_SIZE / sizeof(u32))

Suggest to move SHA1_DIGEST_WORDS to sha1.h

Tim
