From: Andrei Varvara <andrei.varvara@freescale.com>
Subject: [PATCH 7/8] crypto: caam - Add define for Adjust Output Frame Length in PDB
Date: Mon, 13 May 2013 17:53:02 +0300
Message-ID: <1368456782-2082-1-git-send-email-andrei.varvara@freescale.com>
References: <n>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <Kim.Phillips@freescale.com>, <AFLEMING@freescale.com>,
	<vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:45511
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753554Ab3EMOxI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 May 2013 10:53:08 -0400
Received: from mail87-ch1 (localhost [127.0.0.1])	by mail87-ch1-R.bigfish.com
 (Postfix) with ESMTP id 3608C48039A	for <linux-crypto@vger.kernel.org>; Mon,
 13 May 2013 14:53:07 +0000 (UTC)
Received: from CH1EHSMHS039.bigfish.com (snatpool2.int.messaging.microsoft.com
 [10.43.68.238])	by mail87-ch1.bigfish.com (Postfix) with ESMTP id BA05460051
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2013 14:53:05 +0000 (UTC)
In-Reply-To: <n>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add define for "Adjust Output Frame Length" in order to
set the AOFL bit in the IPsec ESP Decapsulation PDB.

Signed-off-by: Anca-Jeanina Floarea <anca.floarea@freescale.com>
Signed-off-by: Andrei Varvara <andrei.varvara@freescale.com>
Reviewed-by: Phillips Kim-R1AAHA <Kim.Phillips@freescale.com>
Reviewed-by: Fleming Andrew-AFLEMING <AFLEMING@freescale.com>
---
 drivers/crypto/caam/pdb.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/pdb.h b/drivers/crypto/caam/pdb.h
index 62950d2..3a87c0c 100644
--- a/drivers/crypto/caam/pdb.h
+++ b/drivers/crypto/caam/pdb.h
@@ -40,14 +40,15 @@
 #define PDBOPTS_ESP_ARS64	0xc0 /* 64-entry antireplay window */
 #define PDBOPTS_ESP_IVSRC	0x20 /* IV comes from internal random gen */
 #define PDBOPTS_ESP_ESN		0x10 /* extended sequence included */
 #define PDBOPTS_ESP_OUTFMT	0x08 /* output only decapsulation (decap) */
 #define PDBOPTS_ESP_IPHDRSRC	0x08 /* IP header comes from PDB (encap) */
 #define PDBOPTS_ESP_INCIPHDR	0x04 /* Prepend IP header to output frame */
 #define PDBOPTS_ESP_IPVSN	0x02 /* process IPv6 header */
+#define PDBOPTS_ESP_AOFL	0x04 /* adjust out frame len (decap, SEC>=5.3)*/
 #define PDBOPTS_ESP_TUNNEL	0x01 /* tunnel mode next-header byte */
 #define PDBOPTS_ESP_IPV6	0x02 /* ip header version is V6 */
 #define PDBOPTS_ESP_DIFFSERV	0x40 /* copy TOS/TC from inner iphdr */
 #define PDBOPTS_ESP_UPDATE_CSUM 0x80 /* encap-update ip header checksum */
 #define PDBOPTS_ESP_VERIFY_CSUM 0x20 /* decap-validate ip header checksum */
 
 /*
-- 
1.7.3.4
