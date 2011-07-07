From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto, gf128: fix call to memset()
Date: Thu, 07 Jul 2011 02:10:39 -0700 (PDT)
Message-ID: <20110707.021039.1936036404024998528.davem@davemloft.net>
References: <1310027630-26488-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.hengli.com.au, linux-crypto@vger.kernel.org,
	pageexec@freemail.hu
To: minipli@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:42699 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab1GGJK4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jul 2011 05:10:56 -0400
In-Reply-To: <1310027630-26488-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Mathias Krause <minipli@googlemail.com>
Date: Thu,  7 Jul 2011 10:33:50 +0200

> In gf128mul_lle() and gf128mul_bbe() r isn't completely initialized with
> zero because the size argument passed to memset() is the size of the
> pointer, not the structure it points to.
> 
> Luckily there are no in-kernel users of those functions so the ABI
> change implied by this fix should break no existing code.
> 
> Based on a patch by the PaX Team.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Cc: PaX Team <pageexec@freemail.hu>

Acked-by: David S. Miller <davem@davemloft.net>
