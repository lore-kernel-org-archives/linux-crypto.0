From: Stephan Mueller <smueller@chronox.de>
Subject: ghash-clmulni: does not load
Date: Thu, 26 Nov 2015 13:45:26 +0100
Message-ID: <4267678.SA4Iv35LnJ@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34586 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbbKZMp3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Nov 2015 07:45:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Tadeusz,

testing the current cryptodev-2.6 tree, ghash-clmulni does not load. In the 
init function

	err = crypto_register_ahash(&ghash_async_alg);

returns EINVAL.

Any ideas?

-- 
Ciao
Stephan
