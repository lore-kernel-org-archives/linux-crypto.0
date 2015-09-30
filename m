From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH] crypto: qat - remove unneeded variable
Date: Wed, 30 Sep 2015 05:40:00 -0700
Message-ID: <20150930124000.14742.58408.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@intel.com,
	qat-linux@intel.com, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30901 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899AbbI3MmD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Sep 2015 08:42:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Remove unneeded variable val_indx.
Issue found by a static analyzer.

Reported-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/qat_hal.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
index 8e711d1..380e761 100644
--- a/drivers/crypto/qat/qat_common/qat_hal.c
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -1034,7 +1034,7 @@ static int qat_hal_concat_micro_code(uint64_t *micro_inst,
 				     unsigned int inst_num, unsigned int size,
 				     unsigned int addr, unsigned int *value)
 {
-	int i, val_indx;
+	int i;
 	unsigned int cur_value;
 	const uint64_t *inst_arr;
 	int fixup_offset;
@@ -1042,8 +1042,7 @@ static int qat_hal_concat_micro_code(uint64_t *micro_inst,
 	int orig_num;
 
 	orig_num = inst_num;
-	val_indx = 0;
-	cur_value = value[val_indx++];
+	cur_value = value[0];
 	inst_arr = inst_4b;
 	usize = ARRAY_SIZE(inst_4b);
 	fixup_offset = inst_num;
