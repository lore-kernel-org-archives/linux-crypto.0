From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Hardware Acceleration on Freescale MPC8349
Date: Wed, 21 May 2008 13:52:43 +0800
Message-ID: <E1JyhFj-0004Wq-00@gondolin.me.apana.org.au>
References: <20080520123211.82434454.kim.phillips@freescale.com>
Cc: mr.scada@gmail.com, linux-crypto@vger.kernel.org
To: kim.phillips@freescale.com (Kim Phillips)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59713 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754450AbYEUFwv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2008 01:52:51 -0400
In-Reply-To: <20080520123211.82434454.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kim Phillips <kim.phillips@freescale.com> wrote:
>
> I have one that's not suitable for submission yet; I'm working on
> authenc(hmac(sha1),cbc(aes)) support and intend on submitting it
> before the next window opens.

That sounds cool!

Please don't let the window stop you though.  Because the earlier
your patch goes into a tree the sooner it can be pushed to Linus
when the window does open.

In other words, the merge window should have no effect on your
patch submission.  In fact, if you wait for the merge window to
open first, it'll only mean that I can't push it to Linus for that
release and it'll have to wait for the next one.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
