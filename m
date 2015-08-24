From: Stephan Mueller <smueller@chronox.de>
Subject: Re: aead_alg request size (request context size)
Date: Mon, 24 Aug 2015 15:16:03 +0200
Message-ID: <1707692.anI8hnkTcI@tauon.atsec.com>
References: <55DB13A1.4000703@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Vasile Catalin-B50542 <catalin.vasile@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48151 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212AbbHXNQO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 09:16:14 -0400
In-Reply-To: <55DB13A1.4000703@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 24. August 2015, 15:52:49 schrieb Vasile Catalin-B50542:

Hi Vasile,

>How can I make aead transformations on the new API allocate some context
>space inside
>the aead_request?
>Description/comments of aead_alg->init() and crypto_alg->cra_init()
>suggest that they are
>triggered after the tfm object has already been allocated, so setting
>crypto_aead->reqsize
>has no effect.
>Also, it seems that if aead_alg->init() is triggered, but
>crypto_alg->cra_init() is not.
>I see a call to alg->cra_init() from crypto_create_tfm, when allocating
>an aead transformation,
>but my cra_init() is not actually called. Instead aead_alg->init() is
>not seen anywhere, but
>indeed it is triggered at some time. Where does it get called?

Please consider that the tfm is the wrapper around the key and the cipher 
mechanism. This one does not maintain any state of a cipher.

The state of the cipher (including any memory needed for a cipher) is kept in 
the aead_request data structure. That data structure is created by the calling 
user separately from the tfm.

>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
