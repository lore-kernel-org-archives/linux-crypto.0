From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH] crypto/ccp: remove rwlocks_types.h
Date: Wed, 11 May 2016 11:21:12 -0500
Message-ID: <57335BF8.5000000@amd.com>
References: <1462961180-11135-1-git-send-email-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, <tglx@linutronix.de>,
	Peter Zijlstra <peterz@infradead.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:31360
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932541AbcEKQgv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 12:36:51 -0400
In-Reply-To: <1462961180-11135-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/11/2016 05:06 AM, Sebastian Andrzej Siewior wrote:
> Users of rwlocks should include spinlock.h instead including this
> header file. The current users of rwlocks_types.h are internal.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

There's already been a patch submitted and accepted for this
in the cryptodev tree:

commit 7587c4075400 ("crypto: ccp - Fix RT breaking #include <linux/rwlock_types.h>")

Thanks,
Tom

> ---
>  drivers/crypto/ccp/ccp-dev.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 4dbc18727235..2a8ad712a5f2 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -16,7 +16,6 @@
>  #include <linux/sched.h>
>  #include <linux/interrupt.h>
>  #include <linux/spinlock.h>
> -#include <linux/rwlock_types.h>
>  #include <linux/types.h>
>  #include <linux/mutex.h>
>  #include <linux/delay.h>
> 
