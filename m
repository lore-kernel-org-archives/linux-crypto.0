From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: make lib/842 decompress functions static
Date: Mon, 11 May 2015 07:22:35 -0400
Message-ID: <1431343355-32005-1-git-send-email-ddstreet@ieee.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:32926 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbbEKLWx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 07:22:53 -0400
Received: by igbpi8 with SMTP id pi8so69997619igb.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 May 2015 04:22:53 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Make the do_index and do_op functions static.

They are used only internally by the 842 decompression function,
and should be static.

Reported-By: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
Oops, I missed making these static.  Thanks for catching it!
I left your Signed-off-by even though this patch covers do_index
also (I assumed you agree with making both static :)

lib/842/842_decompress.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
index 6b2b45a..dbeb058 100644
--- a/lib/842/842_decompress.c
+++ b/lib/842/842_decompress.c
@@ -214,7 +214,7 @@ static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
 	return 0;
 }
 
-int do_index(struct sw842_param *p, u8 n)
+static int do_index(struct sw842_param *p, u8 n)
 {
 	switch (n) {
 	case 2:
@@ -228,7 +228,7 @@ int do_index(struct sw842_param *p, u8 n)
 	}
 }
 
-int do_op(struct sw842_param *p, u8 o)
+static int do_op(struct sw842_param *p, u8 o)
 {
 	int i, ret = 0;
 
-- 
2.1.0
