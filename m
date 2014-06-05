From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto/xor.c: use 2 pages for xor speed testing
Date: Thu, 5 Jun 2014 23:57:55 +0200
Message-ID: <201406052357.55383.marex@denx.de>
References: <1401930693-6549-1-git-send-email-akong@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Amos Kong <akong@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:33931 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaFEV57 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2014 17:57:59 -0400
In-Reply-To: <1401930693-6549-1-git-send-email-akong@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, June 05, 2014 at 03:11:33 AM, Amos Kong wrote:
> In crypto/xor.c: calibrate_xor_blocks(), we allocated total 4 pages to
> do xor speed testing, the BENCH_SIZE is 1 page, and we skipped 2 pages
> when we set b2.
> 
> It seems that total 2 pages are enough without skipping 2 pages.
> 
> Signed-off-by: Amos Kong <akong@redhat.com>
> ---
>  crypto/xor.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/crypto/xor.c b/crypto/xor.c
> index 35d6b3a..609dfb5 100644
> --- a/crypto/xor.c
> +++ b/crypto/xor.c
> @@ -114,12 +114,12 @@ calibrate_xor_blocks(void)
>  	 * test the XOR speed, we don't really want kmemcheck to warn about
>  	 * reading uninitialized bytes here.
>  	 */
> -	b1 = (void *) __get_free_pages(GFP_KERNEL | __GFP_NOTRACK, 2);
> +	b1 = (void *) __get_free_pages(GFP_KERNEL | __GFP_NOTRACK, 1);
>  	if (!b1) {
>  		printk(KERN_WARNING "xor: Yikes!  No memory available.\n");
>  		return -ENOMEM;
>  	}
> -	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
> +	b2 = b1 + BENCH_SIZE;
> 
>  	/*
>  	 * If this arch/cpu has a short-circuited selection, don't loop through
> @@ -154,7 +154,7 @@ calibrate_xor_blocks(void)
>  #undef xor_speed
> 
>   out:
> -	free_pages((unsigned long)b1, 2);
> +	free_pages((unsigned long)b1, 1);
> 
>  	active_template = fastest;
>  	return 0;

I think this does make sense, but I am not 100% sure, sorry.

...

While looking at this code, can anyone explain to me why we have this stuff in 
crypto/xor.c please ?

135 #define xor_speed(templ)        do_xor_speed((templ), b1, b2)
136 
137         if (fastest) {
138                 printk(KERN_INFO "xor: automatically using best "
139                                  "checksumming function:\n");
140                 xor_speed(fastest);
141                 goto out;
142         } else {
[...]
149         }
150 
151         printk(KERN_INFO "xor: using function: %s (%d.%03d MB/sec)\n",
152                fastest->name, fastest->speed / 1000, fastest->speed % 1000);
153 
154 #undef xor_speed

Why do we not call do_xor_speed(fastest, b1, b2); right away , but we #define 
xor_speed() instead ? This looks like some remnant or nonsense to me. Shall I 
remove that with a patch ?

Best regards,
Marek Vasut
