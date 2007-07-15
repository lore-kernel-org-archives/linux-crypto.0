From: David Miller <davem@davemloft.net>
Subject: Re: Crypto Update for 2.6.23
Date: Sat, 14 Jul 2007 23:48:39 -0700 (PDT)
Message-ID: <20070714.234839.34761809.davem@davemloft.net>
References: <20070711130849.GA10494@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: torvalds@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53343
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751875AbXGOGsh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 15 Jul 2007 02:48:37 -0400
In-Reply-To: <20070711130849.GA10494@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Wed, 11 Jul 2007 21:08:49 +0800

> Here is the crypto update for 2.6.23:
> 
> Please pull from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git
> 
> or
> 
> master.kernel.org:/pub/scm/linux/kernel/git/herbert/crypto-2.6.git

I merged this into my net-2.6 tree, there was a tiny conflict
in crypto/Kconfig I had to resolve because of the async_tx
stuff that went in upstream.

Herbert can you contact the async_tx author to make sure that
his crypto/ bits go through you in the future so that conflicts
like this can be avoided?

Thanks.
