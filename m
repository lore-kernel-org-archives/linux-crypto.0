From: Stephan Mueller <smueller@chronox.de>
Subject: cipher implementations allowed to sleep?
Date: Thu, 31 Mar 2016 11:18:48 +0200
Message-ID: <8342050.C1sDSzNQxT@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33826 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756373AbcCaJSv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Mar 2016 05:18:51 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

is it allowed that cipher implementations sleep? The driver of my question is 
whether I can use spin_lock_irqsave() as a lock around a cipher operation.

The cipher operations in question are hashing, HMACing and symmetric ciphers.

Thank you
Stephan
