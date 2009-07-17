From: David Miller <davem@davemloft.net>
Subject: Re: [RFC] [PATCH 2/7] crypto: authenc - convert to ahash
Date: Fri, 17 Jul 2009 10:03:34 -0700 (PDT)
Message-ID: <20090717.100334.160030992.davem@davemloft.net>
References: <20090716111548.GP20288@secunet.com>
	<20090716111747.GR20288@secunet.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	netdev@vger.kernel.org
To: steffen.klassert@secunet.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33264
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933550AbZGQRDa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jul 2009 13:03:30 -0400
In-Reply-To: <20090716111747.GR20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Thu, 16 Jul 2009 13:17:47 +0200

> +	/* 
> +	 * head must be a scatterlist with two entries.
> +	 * We remove a potentially set termination bit
> +	 * on the first enty.
> +	 */
> +	head->page_link &= ~0x02;
> +
>  	if (chain) {
>  		head->length += sg->length;

Isn't there some interface to do this, rather than revealing the
implementation details of how the scatter list marking works?

If not, such an interface should be created and used here.  Otherwise
any change in that implementation will break this code.
