From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v8 7/7] Add documentation of drbg.stdrng
Date: Mon, 26 May 2014 13:30:36 +0200
Message-ID: <1427752.f9YxQ9FBNN@myon.chronox.de>
References: <1672386.pGc00MSMM2@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, aquini@redhat.com,
	jeremy.wayne.powell@gmail.com, clemens@ladisch.de,
	pwalten@au1.ibm.com, joe@perches.com
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:43780 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaEZLbG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 May 2014 07:31:06 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S110> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 26 May 2014 13:30:58 +0200
In-Reply-To: <1672386.pGc00MSMM2@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The drbg.stdrng kernel command line flag allows the selection of the
DRBG used as stdrng.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 Documentation/kernel-parameters.txt | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 30a8ad0d..b970ba2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -855,6 +855,16 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			The filter can be disabled or changed to another
 			driver later using sysfs.
 
+	drbg.stdrng=<name>
+			Kernel crypto API name of the SP800-90A DRBG that
+			is marked as "stdrng". Parts of the kernel requiring
+			random numbers may use the "stdrng" random number
+			generator. In FIPS mode (when the kernel command line
+			parameter fips=1 is provided), the priority of the
+			DRBG stdrng is increased to be higher than other
+			stdrng definitions. This implies, the DRBG is used as
+			default in FIPS mode.
+
 	drm_kms_helper.edid_firmware=[<connector>:]<file>
 			Broken monitors, graphic adapters and KVMs may
 			send no or incorrect EDID data sets. This parameter
-- 
1.9.3
