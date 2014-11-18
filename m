From: James Hartley <james.hartley@imgtec.com>
Subject: [PATCH V2 0/2] crypto: Add support for the IMG hash accelerator
Date: Tue, 18 Nov 2014 20:48:45 +0000
Message-ID: <1416343727-2178-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<grant.likely@linaro.org>, <robh+dt@kernel.org>,
	<gregkh@linuxfoundation.org>, <linux-crypto@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <pawel.moll@arm.com>,
	<mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
	<galak@codeaurora.org>, <Ezequiel.Garcia@imgtec.com>,
	<abrestic@chromium.org>, <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:8021 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbaKRUss (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Nov 2014 15:48:48 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds support for the Imagination Technologies hash
accelerator which provides hardware acceleration for
SHA1 SHA244 SHA256 and MD5 hashes.

Changes from V1:
	* Addressed review comments from Andrew Bresticker and 
	  Vladimir Zapolskiy
	* rebased to current linux-next

James Hartley (2):
  crypto: Add Imagination Technologies hw hash accelerator
  Documentation: crypto: Add DT binding info for the img hw hash
    accelerator

 .../devicetree/bindings/crypto/img-hash.txt        |   26 +
 MAINTAINERS                                        |    5 +
 drivers/crypto/Kconfig                             |   14 +
 drivers/crypto/Makefile                            |    1 +
 drivers/crypto/img-hash.c                          | 1061 ++++++++++++++++++++
 5 files changed, 1108 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/img-hash.txt
 create mode 100644 drivers/crypto/img-hash.c

-- 
1.7.9.5
