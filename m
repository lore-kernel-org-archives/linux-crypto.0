From: pageexec@freemail.hu
Subject: Re: [PATCH] crypto, gf128: fix call to memset()
Date: Thu, 07 Jul 2011 13:10:53 +0200
Message-ID: <4E15943D.24481.3909A04B@pageexec.freemail.hu>
References: <1310027630-26488-1-git-send-email-minipli@googlemail.com>
Reply-To: pageexec@freemail.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from r00tworld.com ([212.85.137.150]:41415 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755683Ab1GGLiz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Jul 2011 07:38:55 -0400
In-reply-to: <1310027630-26488-1-git-send-email-minipli@googlemail.com>
Content-description: Mail message body
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7 Jul 2011 at 10:33, Mathias Krause wrote:

> In gf128mul_lle() and gf128mul_bbe() r isn't completely initialized with
> zero because the size argument passed to memset() is the size of the
> pointer, not the structure it points to.
> 
> Luckily there are no in-kernel users of those functions so the ABI
> change implied by this fix should break no existing code.
> 
> Based on a patch by the PaX Team.

just for the record, the bug was pointed out by a recent clang analysis pass.
