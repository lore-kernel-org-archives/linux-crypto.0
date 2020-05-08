Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BBA5C54E49
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48D6B2184D
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pbWzq21r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgEHWfR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 18:35:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEHWfQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 18:35:16 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205E3C061A0C;
        Fri,  8 May 2020 15:35:16 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id a4so2660815lfh.12;
        Fri, 08 May 2020 15:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E1Mfd5yafyl5kV91gpEeu6FbVfgj9pE13Xj752dXqhI=;
        b=pbWzq21r7wR6Koc/nr7AFi0gwVhM5+GUtQVNB2D+pcMeyIQEOFwfgvZgTkpY92gfP+
         uHJNgdzSQQ6snGAS0nVrm2VlUsO3GeNrdXcc9iFhYyMa3jqbag7HZ2medKdPqwsCXW/x
         0olNvEtc+3aelOOa0qEIk3W4oNEueEkKLP3gBnfHD3+/1NDyhr2SsKNJHxvMU7F2Vk8l
         PxeN7ma+FycY77JWr0okYxiPivd8hSXI5t8eHZ0f/Uelr5UVgu0PzD7GJSDjPrLnFMQN
         Oz9KKunPx4vC1SpVPN3kjxYeWEbBwDaiDZkcxtYv7oB+XokCzBkwpGMzdW50EcLF2wVp
         Wk/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E1Mfd5yafyl5kV91gpEeu6FbVfgj9pE13Xj752dXqhI=;
        b=nj9ZwA613uSBaFO7U/+BlDqAOp66+M6cVwSD/Vk8G1Gorv15tq0XvDPYQE7MJCMPsk
         yMGOq5UC9+jAnd7eu0TzV0VXolYbQAbXeGiPQWrXtxEopoABSbKN5JSdwN/p24A03xO9
         sP+fDTd2Qe8K0GnSmNNSBwA07ySGvL/RBP/4d7Cxjkx+HgzAZx5OR/yFV8EEj/kpOE7M
         E2M9jTZFw4j/LwOOVp5s97iPJVI182qG6Cnl/qep+3JwNoUhBYZOtAdAW9H/OdtwennS
         kWCghgEHsNrgE7G5eF8PyiJbg/0pY23H+XBuV9K9C1DyWlxWKLQiCU84qfIDpxsqK+Lo
         pTuQ==
X-Gm-Message-State: AOAM531XJxA3QDECxiDl7vOEIA+tdvAzUXgKNxKa9jKuH6GsNQj5GWg8
        QDbhDX6OZxvZcniRn/eds4U=
X-Google-Smtp-Source: ABdhPJwBuvtwQI/hZ8KRpy2OZ3YME+I9gpfT8gO89SJ+zivY5dZqorN1xnakn01xldJ03/zBTqSZzQ==
X-Received: by 2002:a19:6905:: with SMTP id e5mr3291427lfc.175.1588977314621;
        Fri, 08 May 2020 15:35:14 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-22.NA.cust.bahnhof.se. [158.174.22.22])
        by smtp.gmail.com with ESMTPSA id s11sm2316501lfo.86.2020.05.08.15.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 15:35:14 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH 1/4] crypto: ccree - constify struct debugfs_reg32
Date:   Sat,  9 May 2020 00:34:59 +0200
Message-Id: <20200508223502.7258-2-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
References: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

pid_cd_regs and debug_regs are never changed and can therefore be made
const.

This allows the compiler to put it in the text section instead of the
data section.

Before:
   text    data     bss     dec     hex filename
   2871    2320      64    5255    1487 drivers/crypto/ccree/cc_debugfs.o

After:
   text    data     bss     dec     hex filename
   3255    1936      64    5255    1487 drivers/crypto/ccree/cc_debugfs.o

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/crypto/ccree/cc_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccree/cc_debugfs.c b/drivers/crypto/ccree/cc_debugfs.c
index c454afce7781..7083767602fc 100644
--- a/drivers/crypto/ccree/cc_debugfs.c
+++ b/drivers/crypto/ccree/cc_debugfs.c
@@ -26,7 +26,7 @@ static struct debugfs_reg32 ver_sig_regs[] = {
 	{ .name = "VERSION" }, /* Must be 1st */
 };
 
-static struct debugfs_reg32 pid_cid_regs[] = {
+static const struct debugfs_reg32 pid_cid_regs[] = {
 	CC_DEBUG_REG(PERIPHERAL_ID_0),
 	CC_DEBUG_REG(PERIPHERAL_ID_1),
 	CC_DEBUG_REG(PERIPHERAL_ID_2),
@@ -38,7 +38,7 @@ static struct debugfs_reg32 pid_cid_regs[] = {
 	CC_DEBUG_REG(COMPONENT_ID_3),
 };
 
-static struct debugfs_reg32 debug_regs[] = {
+static const struct debugfs_reg32 debug_regs[] = {
 	CC_DEBUG_REG(HOST_IRR),
 	CC_DEBUG_REG(HOST_POWER_DOWN_EN),
 	CC_DEBUG_REG(AXIM_MON_ERR),
-- 
2.26.2

