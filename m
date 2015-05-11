From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: correct 842 decompress for 32 bit
Date: Mon, 11 May 2015 18:53:36 -0400
Message-ID: <1431384816-21606-1-git-send-email-ddstreet@ieee.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Fengguang Wu <fengguang.wu@intel.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37198 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbbEKWyD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 18:54:03 -0400
Received: by igbsb11 with SMTP id sb11so85959361igb.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 15:54:02 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Avoid 64 bit mod operation, which won't work on 32 bit systems.
Simple subtraction can be used instead in this case.

Reported-By: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 lib/842/842_decompress.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index dbeb058..999b629 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -185,7 +185,7 @@ static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
 		/* this is where the current fifo is */
 		u64 section = round_down(total, fsize);
 		/* the current pos in the fifo */
-		u64 pos = total % fsize;
+		u64 pos = total - section;
 
 		/* if the offset is past/at the pos, we need to
 		 * go back to the last fifo section
-- 
2.1.0
