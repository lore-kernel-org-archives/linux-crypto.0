From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/6] crypto: Fix scatterwalk_done() test.
Date: Tue, 18 May 2010 22:54:29 -0700 (PDT)
Message-ID: <20100518.225429.233860122.davem@davemloft.net>
References: <20100517.222237.232897853.davem@davemloft.net>
	<20100519040513.GC20887@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56769
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab0ESFyU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 01:54:20 -0400
In-Reply-To: <20100519040513.GC20887@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 19 May 2010 14:05:13 +1000

> So I'm going to commit this patch instead.  Let me know if you
> see any other issues with it.

Looks good:

Acked-by: David S. Miller <davem@davemloft.net>
