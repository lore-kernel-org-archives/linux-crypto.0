From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH v2] crypto: sun4i-ss: add missing statesize
Date: Mon, 16 Nov 2015 09:35:53 +0100
Message-ID: <1447662954-1788-1-git-send-email-clabbe.montjoie@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: arno@natisbad.org, axboe@fb.com,
	boris.brezillon@free-electrons.com, clabbe.montjoie@gmail.com,
	cristian.stoica@freescale.com, dan.j.williams@intel.com,
	davem@davemloft.net, dmitry.torokhov@gmail.com,
	fabio.estevam@freescale.com, herbert@gondor.apana.org.au,
	horia.geanta@freescale.com, jamie@jamieiles.com,
	linux-arm-kernel@lists.infradead.org,
	steve.cornelius@freescale.com, thomas.petazzoni@free-electrons.com,
	vicki.milhoan@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35141 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbbKPIgC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Nov 2015 03:36:02 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hello

The current sun4i-ss cannot be loaded with the error "Failed to load md5".
The following patch will fix that.

Changes since v1:
- Add the correct fixes tag.
- Add the correct #version comment for stable.
- Be more precise against the commit who made this change necessary.

Regards
