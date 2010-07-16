From: David Miller <davem@davemloft.net>
Subject: Re: [patch] crypto/ablkcipher: missing return statement
Date: Thu, 15 Jul 2010 19:21:41 -0700 (PDT)
Message-ID: <20100715.192141.242121343.davem@davemloft.net>
References: <20100715075736.GC5164@bicker>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, richih.mailinglist@gmail.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: error27@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57307
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935168Ab0GPCV0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Jul 2010 22:21:26 -0400
In-Reply-To: <20100715075736.GC5164@bicker>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Dan Carpenter <error27@gmail.com>
Date: Thu, 15 Jul 2010 09:57:36 +0200

> The intent was to return here.  In the original an allocation failure
> would lead to a NULL dereference.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
