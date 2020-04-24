Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49423C54FD0
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2971021569
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="E+x3rdrR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbgDXOCg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728393AbgDXOCe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:02:34 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C4FC09B046
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:34 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so10979300wrx.4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pWbS/s39PP0txqZELi1mJMojHzNj+5WACojohoe9Hn0=;
        b=E+x3rdrRxvqX1kENH+jscSW/UABchcxO9CTu8cF7INE3cgmDdcyjYFNwNnpsPJD0pV
         pqj+mL8Zr/uwctjOn7VXSKS33FDb3TWefuH61KfabcCGQzoJ2PuX19rLlCg42zV3+utH
         zqbCA1cRtJ7ETeukeoyLFrX1+EVirtX3y5h14D78M0dCeh/D4EqIa9AhJt6e2ycilSiB
         cjR6F52GHmmvibz2W7qF3cPxKBxJmqk0XF7cQM6U20PzylljFQtyc2jDurramlxknrlo
         ShpWCwAhWqgUPDNbj8tcS18HZVLnamflivFwMR6baPuGtbYPoC/HlcYeyN20/kvqQ6Jb
         wJRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pWbS/s39PP0txqZELi1mJMojHzNj+5WACojohoe9Hn0=;
        b=OWmF+wN6DzbVBAp5GrzRUYzx2Skt6g7wm4N4W9cRN/yyXfOxopU+U/kRn0pwe5a10N
         kJDoUOD8JP/mU/JUxdMl4QFfq4fDRhBIhBSSKw6OC14KIbnEtmwHITciCoIcE/LMIOtG
         9OTA1UoUJBojh6OWspHboG2seBABk5tlp1s+uoaRLzzCwUlggSJwmHcEH2011ouRMUd7
         aObaOOlo0xFA59iqTLs+5jNMKH1LlPuybUq7b7iSWhrVTBWm+wmwrUly5IyUkd7LqH32
         yOnvDywtDr6UXfqz+Z3SjsIe6Qx4N6BmQM3i9hul2te3FHewP+73wjlUUppfbxkM0gSw
         dqiA==
X-Gm-Message-State: AGi0PuYu1yOhZ4dBr+Lo5ZlB+veu+v9H24WpOfRP1bNjraEgz7Hh43cP
        6AWmWx27gqcESqgRfP3WME+InQ==
X-Google-Smtp-Source: APiQypJH9QGS65GaHZzbaFfyRpcD4LWiy1aLfIgzk3v8rGB/dgx0iG+5nhX26nePSEEAadRUEN1Ldg==
X-Received: by 2002:a5d:5745:: with SMTP id q5mr12045617wrw.351.1587736953294;
        Fri, 24 Apr 2020 07:02:33 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v131sm3061051wmb.19.2020.04.24.07.02.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 07:02:32 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 05/14] crypto: sun8i-ss: Add more comment on some structures
Date:   Fri, 24 Apr 2020 14:02:05 +0000
Message-Id: <1587736934-22801-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds some comment on structures used by sun8i-ss.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 056fcdd14201..b2668e5b612f 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -171,6 +171,8 @@ struct sun8i_ss_dev {
  * @ivlen:	size of biv
  * @keylen:	keylen for this request
  * @biv:	buffer which contain the IV
+ *
+ * t_src, t_dst, p_key, p_iv op_mode, op_dir and method must be in LE32
  */
 struct sun8i_cipher_req_ctx {
 	struct sginfo t_src[MAX_SG];
@@ -193,6 +195,8 @@ struct sun8i_cipher_req_ctx {
  * @keylen:		len of the key
  * @ss:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
+ *
+ * enginectx must be the first element
  */
 struct sun8i_cipher_tfm_ctx {
 	struct crypto_engine_ctx enginectx;
-- 
2.26.2

