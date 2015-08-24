From: Vasile Catalin-B50542 <catalin.vasile@freescale.com>
Subject: aead_alg request size (request context size)
Date: Mon, 24 Aug 2015 15:52:49 +0300
Message-ID: <55DB13A1.4000703@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0139.outbound.protection.outlook.com ([65.55.169.139]:39248
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753847AbbHXMw5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 08:52:57 -0400
Received: from [192.168.19.128] (B50542-01.ea.freescale.net [10.171.73.217])
	by az84smr01.freescale.net (8.14.3/8.14.0) with ESMTP id t7OCqnAM014302
	for <linux-crypto@vger.kernel.org>; Mon, 24 Aug 2015 05:52:53 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

How can I make aead transformations on the new API allocate some context 
space inside
the aead_request?
Description/comments of aead_alg->init() and crypto_alg->cra_init() 
suggest that they are
triggered after the tfm object has already been allocated, so setting 
crypto_aead->reqsize
has no effect.
Also, it seems that if aead_alg->init() is triggered, but 
crypto_alg->cra_init() is not.
I see a call to alg->cra_init() from crypto_create_tfm, when allocating 
an aead transformation,
but my cra_init() is not actually called. Instead aead_alg->init() is 
not seen anywhere, but
indeed it is triggered at some time. Where does it get called?
