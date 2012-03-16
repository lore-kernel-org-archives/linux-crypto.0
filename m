From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: [PATCH] crypto: Fix byte counter overflow in SHA-512
Date: Fri, 16 Mar 2012 15:26:28 -0500
Message-ID: <1331929588.3549.4.camel@key-ThinkPad-W510>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:36168 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2CPU0S (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Mar 2012 16:26:18 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <key@linux.vnet.ibm.com>;
	Fri, 16 Mar 2012 14:26:14 -0600
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 03C9C3E40036
	for <linux-crypto@vger.kernel.org>; Fri, 16 Mar 2012 14:25:53 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2GKPakK091558
	for <linux-crypto@vger.kernel.org>; Fri, 16 Mar 2012 14:25:36 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2GKPs9t001546
	for <linux-crypto@vger.kernel.org>; Fri, 16 Mar 2012 14:25:55 -0600
Received: from [9.53.41.73] (ennui.austin.ibm.com [9.53.41.73])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id q2GKPsse001536
	for <linux-crypto@vger.kernel.org>; Fri, 16 Mar 2012 14:25:54 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The current code only increments the upper 64 bits of the SHA-512 byte
counter when the number of bytes hashed happens to hit 2^64 exactly.

This patch increments the upper 64 bits whenever the lower 64 bits
overflows.

Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
---
 crypto/sha512_generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/sha512_generic.c b/crypto/sha512_generic.c
index 107f6f7..dd30f40 100644
--- a/crypto/sha512_generic.c
+++ b/crypto/sha512_generic.c
@@ -174,7 +174,7 @@ sha512_update(struct shash_desc *desc, const u8 *data, unsigned int len)
 	index = sctx->count[0] & 0x7f;
 
 	/* Update number of bytes */
-	if (!(sctx->count[0] += len))
+	if ((sctx->count[0] += len) < len)
 		sctx->count[1]++;
 
         part_len = 128 - index;
-- 
1.7.5.4
