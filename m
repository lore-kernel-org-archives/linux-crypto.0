From: Marek Vasut <marex@denx.de>
Subject: [QUESTION] Crypto queue handling
Date: Mon, 26 May 2014 17:58:19 +0200
Message-ID: <201405261758.19425.marex@denx.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, Arnd Bergmann <arnd@arndb.de>,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:50759 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbaEZQAv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 May 2014 12:00:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I'm digging in crypto/algapi.c , in the crypto_enqueue_request() function. I 
don't quite understand how the backlog mechanism should work. According to [1], 
I suspect it should limit the amount of requests in the queue to $max_qlen and 
allow one more request to be enqueued into the $backlog ; and if there is more 
requests than $max_qlen, it should start dropping the requests ?

Inspecting the code, I see these situations:
1) qlen < max_qlen
   -> The request is enqueued, qlen is increased , returns -EINPROGRESS
2) qlen >= max_qlen
   -> The crypto_enqueue_request() returns -EBUSY in this case
   2a) request->flags has CRYPTO_TFM_REQ_MAY_BACKLOG unset
       => Request is not enqueued , qlen is not increased
   2b) request->flags has CRYPTO_TFM_REQ_MAY_BACKLOG set
       => Request is enqueued , qlen is increased

Therefore, I suspect if 2b) case happens repeatedly, the queue will grow 
indefinitelly. I'm not sure if this can happen, but I suspect that's really 
possible. My understanding is that the driver will call crypto_enqueue_request() 
and propagate it's return value to the upper layers. They upper layet can 
generate such a request that has CRYPTO_TFM_REQ_MAY_BACKLOG set .

But how shall the upper layers handle the -EBUSY return value from the crypto 
API calls? Shall they stop saturating the crypto API with requests ? How can the 
upper layers determine when can they resume sending crypto requests ? Shall they 
just try calling crypto_enqueue_request() again to see if it still returns -
EBUSY ?

Sorry if this is an obvious question and thanks for the help!

[1] http://permalink.gmane.org/gmane.linux.kernel.cryptoapi/735

Best regards,
Marek Vasut
