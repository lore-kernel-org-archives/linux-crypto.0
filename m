Return-Path: <SRS0=rw2L=VZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3A2C433FF
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 15:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A540D2077C
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 15:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="vi4jU9Th"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfG1PgL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jul 2019 11:36:11 -0400
Received: from condef-10.nifty.com ([202.248.20.75]:62400 "EHLO
        condef-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfG1PgL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jul 2019 11:36:11 -0400
Received: from conuserg-11.nifty.com ([10.126.8.74])by condef-10.nifty.com with ESMTP id x6SFXI7b012791
        for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2019 00:33:18 +0900
Received: from grover.flets-west.jp (softbank126026094249.bbtec.net [126.26.94.249]) (authenticated)
        by conuserg-11.nifty.com with ESMTP id x6SFWd9d012823;
        Mon, 29 Jul 2019 00:32:39 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-11.nifty.com x6SFWd9d012823
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1564327960;
        bh=lco2zjYmjTJqgvnjGdaA/ghHBLIAeeXpv7O1t3+DWAY=;
        h=From:To:Cc:Subject:Date:From;
        b=vi4jU9ThyytEKltzI0Y0y0G2tQzjv2RZKUoXH8rmMh5/6reHrdLcMzRHdlTW0jvfy
         pKWANoi7MJxnPY5OzKM9DT4tcM1gash0yLtx4exMqr4epEcM/wsjcpbEcVl8/R42sV
         SXHdoCCxMGYQc3kLGkhpGOqtzQWAppaZbz48ZtpsmD/R+P213TQbhhk0srKJyHnGll
         VjR4DllpKNYvzASX0tvqPLQ0DMishjIjfxX0ZUJk5zyYHP0zyVCUU3vkEEp4YkFV6h
         qpsy9kQNnLLYykc10jyhGAxfnMLbA/Bw7q4bELvINC9B64I1COcg8Xv8ryDpPXPPvM
         Exm3tlDf0YG0w==
X-Nifty-SrcIP: [126.26.94.249]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hwrng: timeriomem - add include guard to timeriomem-rng.h
Date:   Mon, 29 Jul 2019 00:32:36 +0900
Message-Id: <20190728153236.9937-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a header include guard just in case.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 include/linux/timeriomem-rng.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/timeriomem-rng.h b/include/linux/timeriomem-rng.h
index fd4a6e6ec831..672df7fbf6c1 100644
--- a/include/linux/timeriomem-rng.h
+++ b/include/linux/timeriomem-rng.h
@@ -5,6 +5,9 @@
  * Copyright (c) 2009 Alexander Clouter <alex@digriz.org.uk>
  */
 
+#ifndef _LINUX_TIMERIOMEM_RNG_H
+#define _LINUX_TIMERIOMEM_RNG_H
+
 struct timeriomem_rng_data {
 	void __iomem		*address;
 
@@ -14,3 +17,5 @@ struct timeriomem_rng_data {
 	/* bits of entropy per 1024 bits read */
 	unsigned int		quality;
 };
+
+#endif /* _LINUX_TIMERIOMEM_RNG_H */
-- 
2.17.1

