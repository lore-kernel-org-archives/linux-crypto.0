Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16D0AC00144
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Aug 2022 03:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiHBD36 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Aug 2022 23:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiHBD35 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Aug 2022 23:29:57 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A53A2127B
        for <linux-crypto@vger.kernel.org>; Mon,  1 Aug 2022 20:29:56 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id d1so8344078qvs.0
        for <linux-crypto@vger.kernel.org>; Mon, 01 Aug 2022 20:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=0OeG3shfDltphYsSXUVO2yZlivCYznbwaGe0X6RqjkI=;
        b=EU7FRMol2oZb8rxXgI4zEUJOXkVWUo/91fIoGU7Z2xS4hMCSYL4MX+SDkyHUQahCkX
         F0YLwFAUY62SuL6wbqVd0iwaKzavQqrBOjiKVa+mddt/8dfoA+4eZ9ts9PpaP0GGIeSB
         CaPU77OHQArUbz+pWCh3rMBB4yU4Nz2sgHwSbyXwyD5DNnjmej0rxVBUHYmMJhJtYeHb
         mQmPqF0GiD33M3I9fkdGJ2OZ2CqiV3tU1pP/Os++5LxVpE0QBJlb6ZyrcKP8rDvhMKmP
         sw5T/2mQy/EtfifaVX0UXfVUB0sdxPM9D8KE8kI+i5WxbYscp11O0PcyA66KWX3Gf668
         WxAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=0OeG3shfDltphYsSXUVO2yZlivCYznbwaGe0X6RqjkI=;
        b=HKKz3zKXImErA+oruBEjGmrPAW757F/0O12zxTEwoNuE4evxQUX0oJP8cGV2xYEZ+7
         vP+VUuR5piPfXW0OM7+ScrzuL5oqYDNUD6Msk/CY4Aevmi3MBSQlmmdk1g+HUBPRIXmZ
         I/jKCVBBGGyJy17IFdv1xguKTTMtenL5YxyKOSkaMRZDrj/vMD0BDFw4scLRQ+W57Aze
         Lse8IC85hyrf8OaIe04HGTKaehHfaoFXTFrAkbIi/SM42QRrZq9wT5SqTZMHUKbUQ9Vj
         7tHfQXQXvlNBjDVBQP/gQUV29JpUxBlMYizZGDWWaKCj1M4Lx8Yb9tzbW40ah+KMQfJq
         xPCg==
X-Gm-Message-State: ACgBeo06DMlej57nn+0MDMzrI+wvPuTdrJd5szloc2EVUUAl8VOs4S7w
        vNoxjZY/d0WiMmJBiTEKQU+0aHrAHRR6yzyJ
X-Google-Smtp-Source: AA6agR57o6Xc13fPW4A4+k8d0xGrSl0ws4HnUEn9veeLE0b5mTFHy+E//FCCnvfhHVb+9tjXlGkIHg==
X-Received: by 2002:a17:902:f787:b0:16a:1e2b:e97 with SMTP id q7-20020a170902f78700b0016a1e2b0e97mr18686767pln.27.1659410985435;
        Mon, 01 Aug 2022 20:29:45 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.78])
        by smtp.gmail.com with ESMTPSA id 139-20020a621991000000b0050dc76281e0sm9433003pfz.186.2022.08.01.20.29.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Aug 2022 20:29:44 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     wangzhou1@hisilicon.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     chenzhuo.1@bytedance.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] crypto: hisilicon - Remove pci_aer_clear_nonfatal_status() call
Date:   Tue,  2 Aug 2022 11:29:37 +0800
Message-Id: <20220802032937.27117-1-chenzhuo.1@bytedance.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Calls to pci_cleanup_aer_uncorrect_error_status() have already been
removed after commit 62b36c3ea664 ("PCI/AER: Remove
pci_cleanup_aer_uncorrect_error_status() calls"). But in commit
6c6dd5802c2d ("crypto: hisilicon/qm - add controller reset interface")
pci_aer_clear_nonfatal_status() was used again, so remove it in
this patch.

note: pci_cleanup_aer_uncorrect_error_status() was renamed to
pci_aer_clear_nonfatal_status() in commit 894020fdd88c
("PCI/AER: Rationalize error status register clearing")

Signed-off-by: Zhuo Chen <chenzhuo.1@bytedance.com>
---
 drivers/crypto/hisilicon/qm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b4ca2eb034d7..fc11e17abbfc 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5431,8 +5431,6 @@ pci_ers_result_t hisi_qm_dev_slot_reset(struct pci_dev *pdev)
 	if (pdev->is_virtfn)
 		return PCI_ERS_RESULT_RECOVERED;
 
-	pci_aer_clear_nonfatal_status(pdev);
-
 	/* reset pcie device controller */
 	ret = qm_controller_reset(qm);
 	if (ret) {
-- 
2.30.1 (Apple Git-130)

