From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC PATCH] [XFRM] xfrm_algo: correct usage of RIPEMD-160
Date: Mon, 2 Jun 2008 08:51:32 +0200
Message-ID: <20080602065132.GA11128@Chamillionaire.breakpoint.cc>
References: <1212340578-15574-1-git-send-email-rueegsegger@swiss-it.ch> <1212340578-15574-2-git-send-email-rueegsegger@swiss-it.ch>
Reply-To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:60053 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751110AbYFBGvo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 02:51:44 -0400
Content-Disposition: inline
In-Reply-To: <1212340578-15574-2-git-send-email-rueegsegger@swiss-it.ch>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Adrian-Ken Rueegsegger | 2008-06-01 19:16:18 [+0200]:

>This patch fixes the usage of RIPEMD-160 in xfrm_algo which in turn
>allows hmac(rmd160) to be used as authentication mechanism in IPsec
>ESP and AH (see RFC 2857).
>
>Signed-off-by: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
>---
> net/xfrm/xfrm_algo.c |    4 ++--
> 1 files changed, 2 insertions(+), 2 deletions(-)
>
>diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
>index ac765dd..23a2cc0 100644
>--- a/net/xfrm/xfrm_algo.c
>+++ b/net/xfrm/xfrm_algo.c
>@@ -200,8 +200,8 @@ static struct xfrm_algo_desc aalg_list[] = {
> 	}
> },
> {
>-	.name = "hmac(ripemd160)",
>-	.compat = "ripemd160",
>+	.name = "hmac(rmd160)",
>+	.compat = "rmd160",

On the other hand you could rename the algorithm itself couldn't you?

Sebastian
