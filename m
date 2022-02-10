Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B87C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Feb 2022 14:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbiBJOmJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Feb 2022 09:42:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243092AbiBJOmG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Feb 2022 09:42:06 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33388CC6
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:42:07 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id a8so15866739ejc.8
        for <linux-crypto@vger.kernel.org>; Thu, 10 Feb 2022 06:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=Q9vjqRcbEx3G5/Z1C2zvbBDueYb3rslHgsJMw5Sxo48=;
        b=CIZKLW2YpERiYqilNBZwn1KHtJi4mKpGR7KnVZSu1uvFr69gO21mxe60rfczbSuuTZ
         aaoFfqSf+GRrAvvGsBYVEiz5OHGvqCV47N3BVS3F8qlZFdxrHvgtqI4bRGPwzUXHMUjB
         pHj0/cQr9mEIbzTdN9yETmDUlbciEO5oTyazJB8hnw6URay8vxV9Jpy1CAk9pwDBbz0l
         cXr9lMPn+Jg/Xo1MyuSLP0YXcjJ+aH3PXm56p2InZU/r88eizSr1Zc1yY6tgl+yp5D5A
         aNMD25gfFraWRjSK1nKRJ5jJAYXm7fhEQjnmQk+b9mAcIah3jof0msx8bPMEaVDMlTmM
         Kx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Q9vjqRcbEx3G5/Z1C2zvbBDueYb3rslHgsJMw5Sxo48=;
        b=41gQbp9/zg/rkUgChJPoI9KiGjwwTshM7JZov7qoAuvWRkf3vLUlpjKh6Je1wSASR5
         WMioSlBmg8ZAT+gUU8W3sDmVoM+L61hr0jZi1CiT3I9lKohBQqTgOR9o8k/O7HgW3/Dt
         LNS27+oxocJwkvQg3j35hIaigJEZ5a5tVFUED9dmEDhGghVtwsPGNSNQ27/hOOl/vxfb
         e95AqHWtt1MD9l44QFwNA4+QWcyj8Al98SNqy9V4eb4uu+Obc6RS5kxxN+NEueX/lq62
         3ExUF6Eyh5y1QM1KrCVsd9GWclEsaEzTfcLf65/ZOA3MykhufQ18hh7vjsfhAqPV5nLo
         8ZFQ==
X-Gm-Message-State: AOAM533cW9IV5HlvT9ixxqqu/76nEPdliWnZEnkFLSyyqXmzASgXPirc
        PJlOKTp9GgOFHe51503b/fnjJe5JAy2+6mPiwwMnbrMi26I=
X-Google-Smtp-Source: ABdhPJw5FBc5vxzlkyZ4+7kjEwwAF6td20gPG38h+3EoXGBLC/yBwOV/rzsMm1GzemCj5+nwrNcMxMPKxd5GyZ8NSO4=
X-Received: by 2002:a17:907:7292:: with SMTP id dt18mr6773682ejc.649.1644504125521;
 Thu, 10 Feb 2022 06:42:05 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 10 Feb 2022 22:41:53 +0800
Message-ID: <CACXcFm=whnpd3v5gJAoTJ-pL27NOOkMKvD3W_RQXy1kj2B6p=g@mail.gmail.com>
Subject: [PATCH 3/4] random: get_source_long() function
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This function gets random data from the best available source

The current code has a sequence in several places that calls one or
more of arch_get_random_long() or related functions, checks the
return value(s) and on failure falls back to random_get_entropy().
get_source long() is intended to replace all such sequences.

This is better in several ways. In the fallback case it gives
much more random output than random_get_entropy(). It never
wastes effort by calling arch_get_random_long() et al. when
the relevant config variables are not set. When it does use
arch_get_random_long(), it does not deliver raw output from
that function but masks it by mixing with stored random data.

Signed-off-by: Sandy Harris <sandyinchina@gmail.com>
---
 drivers/char/random.c | 74 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 9edf65ad4259..6c77fd056f66 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1031,6 +1031,80 @@ static void xtea_rekey(void)
     xtea_iterations = 0 ;
 }

+/**************************************************************************
+ * Load a 64-bit word with data from whatever source we have
+ *
+ *       arch_get_random_long()
+ *       hardware RNG
+ *       emulated HWRNG in a VM
+ *
+ * When there are two sources, alternate.
+ * If you have no better source, or if one fails,
+ * fall back to get_xtea_long()
+ *
+ * This function always succeeds, which allows some
+ * simplifications elsewhere in the code.
+ *
+ * This is intended only for use inside the kernel.
+ * Any data sent to user space should come from the
+ * chacha-based crng construction.
+ ***************************************************************************/
+
+static int load_count = 0;
+#define COUNT_RESTART 128
+
+/*
+ * Add a mask variable so we can avoid using data
+ * from any source directly as output.
+ */
+static unsigned long source_mask ;
+
+/*
+ * Use xtea sometimes even if we have a good source
+ * Avoids trusting the source completely
+ */
+#define MIX_MASK 15
+
+static void get_source_long(unsigned long *x)
+{
+    int a, b ;
+    int ret = 0 ;
+
+    if (load_count >= COUNT_RESTART)
+        load_count = 0 ;
+    if (load_count == 0)
+        get_xtea_long(&source_mask) ;
+
+    a = IS_ENABLED(CONFIG_ARCH_RANDOM) ;
+    b = IS_ENABLED(CONFIG_HW_RANDOM) ;
+
+    if (a && b)    {
+        if (load_count & 1)
+            ret = arch_get_random_long(x) ;
+        else    ret = get_hw_long(x) ;
+    }
+    if (a && !b)    {
+        if (load_count&MIX_MASK)
+            ret = arch_get_random_long(x) ;
+    }
+    if (!a && b)    {
+        if (load_count&MIX_MASK)
+            ret = get_hw_long(x) ;
+    }
+    /*
+    * no source configured
+    * or configured one failed
+    *
+    * or it is just time for tea,
+    * (load_count&MIX_MASK) == 0
+    */
+    if (!ret)
+        get_xtea_long(x) ;
+
+    *x += source_mask ;
+        load_count++ ;
+}
+
 /*********************************************************************
  *
  * CRNG using CHACHA20
-- 
2.25.1
