Return-Path: <SRS0=aQ9n=XM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 147C8C4CECE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 10:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF3EE21881
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Sep 2019 10:58:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qvBdxxNX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725801AbfIQK6O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Sep 2019 06:58:14 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:43627 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfIQK6O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Sep 2019 06:58:14 -0400
Received: by mail-ed1-f68.google.com with SMTP id r9so2874743edl.10
        for <linux-crypto@vger.kernel.org>; Tue, 17 Sep 2019 03:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d/mbCij81hsdqkMLMwE2XRa4mruKETckBiNT0oN1tm4=;
        b=qvBdxxNXITibFG9bgyt6vnIBtI+xEt8+MfXwDmpCj9TZb5uKg7JmkBK3VpHYfR2+XG
         y9vjZD+xJd7WSAESOLfxLD8JaHo89eXGvZjJ8Ii2hoUfPdjTV9Itr+VM6tGbSqO4BRZS
         fHSrRI6u82/rciZdIRbdYJHNokqp91TQdflsHougBErtMFxR5oEwHP7GbkWU2H44PpDt
         0kmv52Z97v9U7f20Ik0LG0xamcHbO77zAk1XX8h6N/BBJ3JLiO1dUlRG7uuSKcvqHmW5
         LnBoCxxiNGR++UVbk8eWqCoZYbLkot6ct8JwqWj2zh51KHA3X3PipjEC0jkPAqiQZtx8
         ifPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d/mbCij81hsdqkMLMwE2XRa4mruKETckBiNT0oN1tm4=;
        b=JfQGpSTownF4v1Jc9FMg9LVMCQ+wBqMM7HZk0vasgzF0FUlDaye2Nea2jX+gKtOhvi
         Fbrqc6LvAh1g4sp/j//jpCuNl/e0hhFKanQ86oQV028s6n6Q/9NvffF4u0Op24Kad5Hc
         U0Pt75IrnxlDKtuUJrzD5jOg2ugITIivf02tO+petlB4f80qiXbEJfmb9GAf0HRumUy5
         0as52K31X/E+dkIqYDyawAWfT/X3xcfQoizXCBwvwa28yePlFhIxOuzh/qx+2+fb0xNr
         tm+uxaRSPsofqNghdebLWM3NVnTLQl9gY0CcPXU2Q3KSm0knPA9WdSNlzMZ7Cgt1O98J
         xF5g==
X-Gm-Message-State: APjAAAWznbxjmjCNE7JBKtg3UzZXP8UMwuMAkc/hOnqJYGnSyayAXBgz
        cbpmmoLq7MKr259OGOWMcWij4wkB
X-Google-Smtp-Source: APXvYqwWUsBwVhOl2CA6AvHaDwBEN68wv8yD62itSm9DQtMg/gTAWx1g2zoKydoz5CUqcHZA9fj1dQ==
X-Received: by 2002:a17:907:40bc:: with SMTP id nu20mr4055300ejb.309.1568717890989;
        Tue, 17 Sep 2019 03:58:10 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id i53sm367253eda.33.2019.09.17.03.58.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Sep 2019 03:58:10 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH 1/2] crypto: inside-secure: [URGENT] Fix stability issue with Macchiatobin
Date:   Tue, 17 Sep 2019 11:55:18 +0200
Message-Id: <1568714119-29945-2-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568714119-29945-1-git-send-email-pvanleeuwen@verimatrix.com>
References: <1568714119-29945-1-git-send-email-pvanleeuwen@verimatrix.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch corrects an error in the Transform Record Cache initialization
code that was causing intermittent stability problems on the Macchiatobin
board.

Unfortunately, due to HW platform specifics, the problem could not happen
on the main development platform, being the VCU118 Xilinx development
board. And since it was a problem with hash table access, it was very
dependent on the actual physical context record DMA buffers being used,
i.e. with some (bad) luck it could seemingly work quit stable for a while.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index dc04112..ac3e1ed 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -221,9 +221,9 @@ static void eip197_trc_cache_init(struct safexcel_crypto_priv *priv)
 	/* Step #3: Determine log2 of hash table size */
 	cs_ht_sz = __fls(asize - cs_rc_max) - 2;
 	/* Step #4: determine current size of hash table in dwords */
-	cs_ht_wc = 16<<cs_ht_sz; /* dwords, not admin words */
+	cs_ht_wc = 16 << cs_ht_sz; /* dwords, not admin words */
 	/* Step #5: add back excess words and see if we can fit more records */
-	cs_rc_max = min_t(uint, cs_rc_abs_max, asize - (cs_ht_wc >> 4));
+	cs_rc_max = min_t(uint, cs_rc_abs_max, asize - (cs_ht_wc >> 2));
 
 	/* Clear the cache RAMs */
 	eip197_trc_cache_clear(priv, cs_rc_max, cs_ht_wc);
-- 
1.8.3.1

