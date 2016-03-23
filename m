From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Subject: [PATCH v2 0/2] crypto: qat fixes
Date: Wed, 23 Mar 2016 17:06:38 +0200
Message-ID: <1458745600-1448-1-git-send-email-tudor-dan.ambarus@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <smueller@chronox.de>,
	<horia.geanta@nxp.com>, Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: <herbert@gondor.apana.org.au>, <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0064.outbound.protection.outlook.com ([65.55.169.64]:33695
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755603AbcCWPGu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Mar 2016 11:06:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Initial patch set can be found here:
        http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg18185.html

This patch set is no longer related to the generalized ASN.1 parser.
Tadeusz will remove the ASN.1 parser from qat.

No changes from initial patch set.

Tudor Ambarus (2):
  crypto: qat - avoid memory corruption or undefined behaviour
  crypto: qat - fix address leaking of RSA public exponent

 drivers/crypto/qat/qat_common/qat_asym_algs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
1.8.3.1
