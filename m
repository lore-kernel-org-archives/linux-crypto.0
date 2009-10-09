From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] crypto: pcrypt - Add pcrypt crypto parallelization
 wrapper
Date: Thu, 08 Oct 2009 23:18:33 -0700 (PDT)
Message-ID: <20091008.231833.107456737.davem@davemloft.net>
References: <20091008072537.GG15653@secunet.com>
	<20091008072818.GI15653@secunet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: steffen.klassert@secunet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55029
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbZJIGSh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 9 Oct 2009 02:18:37 -0400
In-Reply-To: <20091008072818.GI15653@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Thu, 8 Oct 2009 09:28:18 +0200

> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 1af1e4b..6bc5dde 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -350,6 +350,8 @@ enum
>  	TASKLET_SOFTIRQ,
>  	SCHED_SOFTIRQ,
>  	HRTIMER_SOFTIRQ,
> +	AEAD_ENC_SOFTIRQ,
> +	AEAD_DEC_SOFTIRQ,
>  	PADATA_SOFTIRQ,
>  	RCU_SOFTIRQ, 	/* Preferable RCU should always be the last softirq */
>  

Steffen are we going to end up adding a softirq for every crypto
transform type?

That won't work, softirqs are to be scarcely allocated and operate
at a very high level.

I can think of two alternatives:

1) One softirq that does per-cpu padata work via some generic
   callout mechanism.

2) Use tasklets

Thanks.
