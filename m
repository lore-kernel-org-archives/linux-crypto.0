From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] trivial: report backend_cra_name when allocation fails
Date: Thu, 11 Jun 2015 15:35:07 +0200
Message-ID: <4660467.46k1EPzCRb@tauon.atsec.com>
References: <1433942868-16447-1-git-send-email-sergey.senozhatsky@gmail.com> <20150611002853.GA8904@gondor.apana.org.au> <20150611110929.GA453@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	sergey.senozhatsky.work@gmail.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46205 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbbFKNwC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 09:52:02 -0400
In-Reply-To: <20150611110929.GA453@swordfish>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Thursday 11 June 2015, 20:09:29 schrieb Sergey Senozhatsky:

Hi Sergey,

>Thanks.
>
>FWIW, here is my .config (Stephan has requested)

Thank you very much. But I think Herbert already found the issue: SHA needs to 
be selected too (which I erroneously thought is implicitly selected with 
HMAC).

Ciao
Stephan
