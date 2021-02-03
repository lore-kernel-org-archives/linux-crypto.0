Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40DB4C433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E147064E36
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhBCO4D (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhBCO4B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:56:01 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E990C0613D6;
        Wed,  3 Feb 2021 06:55:21 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id n15so23595197qkh.8;
        Wed, 03 Feb 2021 06:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ij1i0UczQXsIIs1RbuItXD4NnMbz6A6r+qR8YxjqoOQ=;
        b=DDVB+By/qRpJD2qNg7kXnh3pITR4OQmhzJQn8PVmHaSedW4Nt7cPzaI3J3sXGEjKlg
         qzotZThBJzYqrwoXx5DM8G/xtP48S3lr9BS0giOfLiEqen8FWMW6uhGSvLQcOmlDerfb
         6AXaxfTTOnIilZn/oIYlpntdNsciU24ft/59BSMjP+/D2Y16mJ9she304yEku3PktbZv
         PwQEcj+0+wg79DGMlju9rJ1F0ayQ+zywcKpHrCdCKMvp/gqRcvQW3lXy+1+OM/kcfhiq
         K/6KRwAYz8XPuKAkpOgFKZvtorT510SQHOFcrmrEzMEO2AteaFPN7kksk+cwvnbv7WaB
         ZK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ij1i0UczQXsIIs1RbuItXD4NnMbz6A6r+qR8YxjqoOQ=;
        b=hngsCRDR/W7NvjHw6e3dPSG01OocT1ggwnd2Ol8KeHQTf1UN2zHOxi9UYdxliBbgBj
         osSi5i5SGqrQOauJ7iezaeghitdd9HyYNRNKXblBVRQIIiFsOdMk0BKs0B5X25M61N90
         nC8ecPFA0djRxpAIzSEFF1Q5yy37jlJeKLnBoesAWttR/CiCVNS+EpQg8rIDiGkgE4QM
         twHDaXN0v6AIpeq5sZ4VL2ThlESXPxKjYieuvECZ31gPF0kq2iOV5rGe2nOda3GyHKjF
         DGt2Tcet8A06EmTiaqyeUHMLMVjAJ2Inw6o6Wb4PgC0YPqfDlovd3ejl04EApayWPz3O
         ATDQ==
X-Gm-Message-State: AOAM530ynEMzSEo9n//MU7bPD1lrJivi2VO7th1eoxXYTRHGGzFfMpAp
        ovBSJcZQsJhaad4K4D5sVCc=
X-Google-Smtp-Source: ABdhPJwbZXgbAEOuUTMf6C8yiMxA9BvoABXOTZvoogN46BSoroXZwnSkkSRDgdLABV6yTuBMJrhPGA==
X-Received: by 2002:a05:620a:12dc:: with SMTP id e28mr2774104qkl.151.1612364120708;
        Wed, 03 Feb 2021 06:55:20 -0800 (PST)
Received: from localhost.localdomain ([156.146.36.139])
        by smtp.gmail.com with ESMTPSA id 11sm1884799qkm.25.2021.02.03.06.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:55:20 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     giovanni.cabiddu@intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, gustavoars@kernel.org, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] drivers: crypto: qat: qat_common: Inside the comment a spelling fixed in adf_pf2vf_msg.c
Date:   Wed,  3 Feb 2021 20:25:06 +0530
Message-Id: <20210203145506.11928-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


s/messge/message/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 8b090b7ae8c6..a1b77bd7a894 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -169,7 +169,7 @@ static int __adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr)
  * @msg:	Message to send
  * @vf_nr:	VF number to which the message will be sent
  *
- * Function sends a messge from the PF to a VF
+ * Function sends a message from the PF to a VF
  *
  * Return: 0 on success, error code otherwise.
  */
--
2.26.2

