From: Victoria Milhoan <vicki.milhoan@freescale.com>
Subject: [PATCH RFC 00/11] crypto: caam - Add i.MX6 support to the Freescale CAAM driver
Date: Mon, 15 Jun 2015 16:52:48 -0700
Message-ID: <1434412379-11623-1-git-send-email-vicki.milhoan@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <herbert@gondor.apana.org.au>, <horia.geanta@freescale.com>,
	<ruchika.gupta@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0145.outbound.protection.outlook.com ([65.55.169.145]:60755
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750842AbbFPAHV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 20:07:21 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series adds i.MX6 support to the Freescale CAAM driver. Please use
these patches with the understanding that changes may occur. The patches are
provided for review at this time, in order to incur comments for permanent
inclusion. 

Modifications include:

- explicit cache coherency support in the driver
- register I/O primitive support
- clocking support
- scatter/gather entry modifications
- DMA fixes
- RNG buffer cache alignment fix

These patches have been tested on the i.MX6 and regression tested
on QorIQ platforms.
