From: Vakul Garg <vakul@freescale.com>
Subject: [PATCH][RESEND] crypto: caam - Moved macro DESC_JOB_IO_LEN to desc_constr.h
Date: Wed, 10 Jul 2013 11:57:21 +0530
Message-ID: <1373437641-21841-1-git-send-email-vakul@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:17225
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924Ab3GJGag (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jul 2013 02:30:36 -0400
Received: from mail154-co9 (localhost [127.0.0.1])	by
 mail154-co9-R.bigfish.com (Postfix) with ESMTP id 4FD66420201	for
 <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2013 06:30:34 +0000 (UTC)
Received: from CO9EHSMHS005.bigfish.com (unknown [10.236.132.247])	by
 mail154-co9.bigfish.com (Postfix) with ESMTP id 59D5D2C0060	for
 <linux-crypto@vger.kernel.org>; Wed, 10 Jul 2013 06:30:31 +0000 (UTC)
Received: from b16394-desktop.ap.freescale.net
 (b16394-desktop.ap.freescale.net [10.232.132.33])	by
 tx30smr01.am.freescale.net (8.14.3/8.14.0) with ESMTP id r6A6ULbr030942	for
 <linux-crypto@vger.kernel.org>; Tue, 9 Jul 2013 23:30:23 -0700
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

DESC_JOB_IO_LEN is a generic macro which indicates the space required in
the descriptor for placing SEQIN/OUT commands, job descriptor header,
shared descriptor pointer. Moving it to descriptor construction file
which can be supposedly included by different algo offload files.

Change-Id: Ic8900990d465e9079827b0c7fcacc61766d7efb6
Signed-off-by: Vakul Garg <vakul@freescale.com>
Reviewed-by: Geanta Neag Horia Ioan-B05471 <horia.geanta@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
Tested-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/caamalg.c     |    2 --
 drivers/crypto/caam/caamhash.c    |    2 --
 drivers/crypto/caam/desc_constr.h |    1 +
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index bf416a8..7a9052c 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -65,8 +65,6 @@
 #define CAAM_MAX_IV_LENGTH		16
 
 /* length of descriptors text */
-#define DESC_JOB_IO_LEN			(CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
-
 #define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
 #define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 16 * CAAM_CMD_SZ)
 #define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 21 * CAAM_CMD_SZ)
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 32aba7a..ae765ac 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -72,8 +72,6 @@
 #define CAAM_MAX_HASH_DIGEST_SIZE	SHA512_DIGEST_SIZE
 
 /* length of descriptors text */
-#define DESC_JOB_IO_LEN			(CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
-
 #define DESC_AHASH_BASE			(4 * CAAM_CMD_SZ)
 #define DESC_AHASH_UPDATE_LEN		(6 * CAAM_CMD_SZ)
 #define DESC_AHASH_UPDATE_FIRST_LEN	(DESC_AHASH_BASE + 4 * CAAM_CMD_SZ)
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 29ba318..c523b64 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -10,6 +10,7 @@
 #define CAAM_CMD_SZ sizeof(u32)
 #define CAAM_PTR_SZ sizeof(dma_addr_t)
 #define CAAM_DESC_BYTES_MAX (CAAM_CMD_SZ * MAX_CAAM_DESCSIZE)
+#define DESC_JOB_IO_LEN (CAAM_CMD_SZ * 5 + CAAM_PTR_SZ * 3)
 
 #ifdef DEBUG
 #define PRINT_POS do { printk(KERN_DEBUG "%02d: %s\n", desc_len(desc),\
-- 
1.7.7.6
