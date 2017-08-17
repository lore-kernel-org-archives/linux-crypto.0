From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: [PATCH 5/6] crypto: jz4780-rng: Add myself as mainatainer for JZ4780 PRNG driver
Date: Thu, 17 Aug 2017 23:55:19 +0530
Message-ID: <20170817182520.20102-6-prasannatsmkumar@gmail.com>
References: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
To: herbert@gondor.apana.org.au, robh+dt@kernel.org,
        mark.rutland@arm.com, ralf@linux-mips.org, mturquette@baylibre.com,
        sboyd@codeaurora.org, davem@davemloft.net, paul@crapouillou.net,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37865 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbdHQS0a (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Aug 2017 14:26:30 -0400
Received: by mail-pg0-f66.google.com with SMTP id 83so11083867pgb.4
        for <linux-crypto@vger.kernel.org>; Thu, 17 Aug 2017 11:26:30 -0700 (PDT)
In-Reply-To: <20170817182520.20102-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add myself as the maintainer of JZ4780 SoC's PRNG drvier.

Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
---
 MAINTAINERS | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 45ec467..ee8c6f6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6733,6 +6733,11 @@ L:	linux-mtd@lists.infradead.org
 S:	Maintained
 F:	drivers/mtd/nand/jz4780_*
 
+INGENIC JZ4780 PRNG DRIVER
+M:	PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
+S:	Maintained
+F:	drivers/crypto/jz4780-rng.c
+
 INOTIFY
 M:	John McCutchan <john@johnmccutchan.com>
 M:	Robert Love <rlove@rlove.org>
-- 
2.10.0
