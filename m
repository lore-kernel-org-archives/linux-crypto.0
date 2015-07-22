From: Stephan Mueller <smueller@chronox.de>
Subject: DocBook update: skip the akcipher for now?
Date: Wed, 22 Jul 2015 22:24:40 +0200
Message-ID: <1592921.a47nh6Krko@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47993 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbbGVUYn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 16:24:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert, Tadeusz,

I am just developing patches to the kernel crypto API DocBook. Thanks to 
Tadeusz, the API calls are nicely documented. There are only a very minor 
tidbits I want to add.

What is missing is the link from the DocBook to the akcipher API. I would like 
to prepare the patch, but I am not sure whether I should at this point. As 
Herbert mentioned, there may be API changes depending on the outcome of the 
discussion to use SGLs instead of linear buffers.

Herbert, Tadeusz, shall I wait for a DocBook update covering akcipher?

Ciao
Stephan
