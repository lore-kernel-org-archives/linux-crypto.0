Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF19C433E1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1E8D25244
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="BJOjqXD+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgFUTcA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 15:32:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730314AbgFUTbT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 15:31:19 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12521C061797
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:19 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id q2so12130195wrv.8
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pWbS/s39PP0txqZELi1mJMojHzNj+5WACojohoe9Hn0=;
        b=BJOjqXD+nsaxOqQ5ljgZU6YBIKULo7nIoGsWOOOoP8gdxxcN9CoFeswu4LAU/gj+Ei
         11vp3ricYQA/9FZZhd6pyGgU88HAQqNRiws4bHeLjmnRhOM6XNHcoL43+T3YoD5dQNvx
         JcAfKEwnL1DMCp7PKu9t29hbH/zne2t/oW7vW+QvP3B1inNqMrIXX+P20Kit56+iwaKD
         OV5NgiC+MG0EkHBwLw5/1K4FmwUgh+OgU/pGqu34tgLKf21q8zmq2iEPHHnUF+gzH1ek
         4co8bpxoXt0s5hEqZXSKsYF4rY7EohtbKmm4wFd/bRVLQrjc3pLBBXdPbV1oWlvbRwkx
         po2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pWbS/s39PP0txqZELi1mJMojHzNj+5WACojohoe9Hn0=;
        b=aXemrGCNozirRsCapbQVK3DJgwFnD9HM0dmdJGUvxLbaS2c1ek78702hog23INcX6X
         JwD22HwOCoOd+8AK68RA7iSjtIcLblZxGVRg32oNXbFMI20fVIUWwfZIqldVCb0g56I7
         JRVUPo5sCEmzoju7H9p1lwHV1y+P+YeJUJZoG6g/ZmHfuzgonhlyQjIWYmX93Ot7e1vN
         UA1865w33jccrMSaEXWuejp9gxBcMZgwscunZTIxTD8IYBqqEvNT1MsdvGBvZ/CBLMFF
         U1nAJoEjH+6yFCCQfItRyt885dnnVM7ySWLuSNjTWnj/ghAB8c2a+ULIfxwSoY42bSk6
         FAiQ==
X-Gm-Message-State: AOAM532CCrbSf55loIevtoIfKMWZw+cEqj1m4QLmoAQDTAG3NW632RDK
        Ycu0eMj1WNoVWYu2ppGogyPugg==
X-Google-Smtp-Source: ABdhPJzMlXEXio7MPRvY9GtF/rb9OQ8MYawObyl8dLaR3nJ8x796EQGek7kPSa8VqSA43uztrfsjRg==
X-Received: by 2002:adf:fe46:: with SMTP id m6mr3679916wrs.192.1592767877783;
        Sun, 21 Jun 2020 12:31:17 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e3sm16086924wrj.17.2020.06.21.12.31.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jun 2020 12:31:17 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 05/14] crypto: sun8i-ss: Add more comment on some structures
Date:   Sun, 21 Jun 2020 19:30:58 +0000
Message-Id: <1592767867-35982-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
References: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
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

