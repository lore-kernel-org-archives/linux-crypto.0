From: Yehuda Sadeh <yehuda@hq.newdream.net>
Subject: [PATCH] shash: fix unaligned calculation with short length
Date: Thu, 26 Mar 2009 14:12:21 -0700
Message-ID: <1238101941-12859-1-git-send-email-yehuda@hq.newdream.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yehuda Sadeh <yehuda@hq.newdream.net>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.hq.newdream.net ([66.33.206.127]:58985 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZCZV3f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Mar 2009 17:29:35 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When the total length is shorter than the calculated number of unaligned bytes, the call to shash->update breaks. For example, calling crc32c on unaligned buffer with length of 1 can result in a system crash.

Signed-off-by: Yehuda Sadeh <yehuda@hq.newdream.net>
---
 crypto/shash.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index d5a2b61..6792a67 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -82,6 +82,9 @@ static int shash_update_unaligned(struct shash_desc *desc, const u8 *data,
 	u8 buf[shash_align_buffer_size(unaligned_len, alignmask)]
 		__attribute__ ((aligned));
 
+	if (unaligned_len > len)
+		unaligned_len = len;
+
 	memcpy(buf, data, unaligned_len);
 
 	return shash->update(desc, buf, unaligned_len) ?:
-- 
1.5.6.5

