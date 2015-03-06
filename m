From: James Hartley <james.hartley@imgtec.com>
Subject: [PATCH V3 0/2] Add support for the IMG hash accelerator
Date: Fri, 6 Mar 2015 02:58:25 +0000
Message-ID: <1425610707-9869-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <james.hartley@imgtec.com>
To: <herbert@gondor.apana.org.au>, <robh+dt@kernel.org>,
	<pawel.moll@arm.com>, <mark.rutland@arm.com>,
	<galak@codeaurora.org>, <andrew.bresticker@chromium.org>,
	<ezequiel.garcia@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:43791 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbbCFC64 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2015 21:58:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds support for the Imagination Technologies hash
accelerator which provides hardware acceleration for
SHA1 SHA244 SHA256 and MD5 hashes.

Tested on silicon, using testmgr.

Changes from V2:
	* This hardware does not support importing a partial hash state, 
	  so the init, update, final and finup have been reworked to use
	  a fallback driver; only digest remains as hardware accelerated.
	* Simplified the driver as a result of the above rework

Changes from V1:
	* Addressed review comments from Andrew Bresticker and 
	  Vladimir Zapolskiy
	* rebased to current linux-next

James Hartley (2):
  crypto: Add Imagination Technologies hw hash accelerator
  Documentation: crypto: Add DT binding info for the img hw hash
    accelerator

 .../devicetree/bindings/crypto/img-hash.txt        |   27 +
 drivers/crypto/Kconfig                             |   14 +
 drivers/crypto/Makefile                            |    2 +
 drivers/crypto/img-hash.c                          | 1037 ++++++++++++++++++++
 4 files changed, 1080 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt
 create mode 100644 drivers/crypto/img-hash.c

-- 
1.7.9.5
