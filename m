From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH] crypto/xor.c: use 2 pages for xor speed testing
Date: Wed, 25 Jun 2014 21:59:18 +0200
Message-ID: <201406252159.18622.marex@denx.de>
References: <1401930693-6549-1-git-send-email-akong@redhat.com> <201406052357.55383.marex@denx.de> <20140617071603.GC8709@z.redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: Amos Kong <akong@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:36867 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbaFYT7Y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 15:59:24 -0400
In-Reply-To: <20140617071603.GC8709@z.redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, June 17, 2014 at 09:16:03 AM, Amos Kong wrote:
[...]
> > While looking at this code, can anyone explain to me why we have this
> > stuff in crypto/xor.c please ?
> > 
> > 135 #define xor_speed(templ)        do_xor_speed((templ), b1, b2)
> > 136
> > 137         if (fastest) {
> > 138                 printk(KERN_INFO "xor: automatically using best "
> > 139                                  "checksumming function:\n");
> > 140                 xor_speed(fastest);
> > 141                 goto out;
> > 142         } else {
> > [...]
> > 149         }
> > 150
> > 151         printk(KERN_INFO "xor: using function: %s (%d.%03d
> > MB/sec)\n", 152                fastest->name, fastest->speed / 1000,
> > fastest->speed % 1000); 153
> > 154 #undef xor_speed
> > 
> > Why do we not call do_xor_speed(fastest, b1, b2); right away , but we
> > #define xor_speed() instead ? This looks like some remnant or nonsense
> > to me. Shall I remove that with a patch ?
> 
> You are right.

I'm wrong. The XOR_TRY_TEMPLATES needs this #define xor_speed , so there's no 
patch happening here. Sorry.

Best regards,
Marek Vasut
