From: Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH RFC 3/3] crypto: tools: Add cryptostat userspace
Date: Wed, 20 Dec 2017 20:09:27 +0000
Message-ID: <1513800567-12764-4-git-send-email-clabbe@baylibre.com>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
To: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:46611 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755752AbdLTUJt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Dec 2017 15:09:49 -0500
Received: by mail-wm0-f68.google.com with SMTP id r78so12178456wme.5
        for <linux-crypto@vger.kernel.org>; Wed, 20 Dec 2017 12:09:48 -0800 (PST)
In-Reply-To: <1513800567-12764-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add an example tool for getting easily crypto statistics.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 tools/crypto/cryptostat | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100755 tools/crypto/cryptostat

diff --git a/tools/crypto/cryptostat b/tools/crypto/cryptostat
new file mode 100755
index 000000000000..314e108eb608
--- /dev/null
+++ b/tools/crypto/cryptostat
@@ -0,0 +1,40 @@
+#!/bin/bash
+
+for dn in `ls /sys/kernel/crypto/`
+do
+	dnpath=/sys/kernel/crypto/$dn/
+	algtype=$(cat $dnpath/algtype)
+	algname=$(cat $dnpath/algname)
+	echo "$dn ($algtype) $algname"
+	case $algtype in
+	hash)
+	echo -e "\tHash: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
+	;;
+	cipher)
+	echo -e "\tEncrypt: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
+	echo -e "\tDecrypt: $(cat $dnpath/dec_cnt)\tbytes $(cat $dnpath/dec_tlen)"
+	;;
+	compress)
+	echo -e "\tCompress: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
+	echo -e "\tDecompress: $(cat $dnpath/dec_cnt)\tbytes $(cat $dnpath/dec_tlen)"
+	;;
+	asymetric)
+	echo -e "\tEncrypt: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
+	echo -e "\tDecrypt: $(cat $dnpath/dec_cnt)\tbytes $(cat $dnpath/dec_tlen)"
+	echo -e "\tVerify: $(cat $dnpath/verify_cnt)"
+	echo -e "\tSign: $(cat $dnpath/sign_cnt)"
+	;;
+	rng)
+	echo -e "\tGenerate: $(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
+	echo -e "\tSeed: $(cat $dnpath/dec_cnt)"
+	;;
+	kpp)
+	echo -e "\tSet_secret: $(cat $dnpath/dec_cnt)"
+	echo -e "\tGenerate_public_key: $(cat $dnpath/enc_cnt)"
+	echo -e "\tCompute_shared_secret: $(cat $dnpath/verify_cnt)"
+	;;
+	*)
+	echo -e "\t$(cat $dnpath/enc_cnt)\tbytes $(cat $dnpath/enc_tlen)"
+	;;
+	esac
+done
-- 
2.13.6
