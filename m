Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C7C8C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 03:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbiGZDtj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 23:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiGZDti (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 23:49:38 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CC229810
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 20:49:34 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r186so12130784pgr.2
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 20:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0OeG3shfDltphYsSXUVO2yZlivCYznbwaGe0X6RqjkI=;
        b=37qhK9Bhn1qiGpmG4CWEWGKbTbOqHNBEpJpgV/5bqzvXYxYNfVlIBtgJGFztFIS+5T
         GkGHxjPGYwcvbk73I9MEIoeWHRdqIjDqkbxauFDCx53WRu1vZwraQlv8RXypCQ/vvZ48
         CElmBIaNUbIBHITNH/Bpuk8gRytuuLf/V+bQfTTVZ0MTesG5SdjNh030Vwxkt+NuzPfK
         Mb62T1yB8E/Up2JVipVOKnA7Bzj+F+yXzXayVxyhFxZig/MNx19js/xEZ0uSDXaUchA8
         MhTEQgxvkaDM/lpEopOiL80CyFUTg+CRFyVdq2HrItgy9WVfzAgFV1Iqro9yetBitc61
         U1NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0OeG3shfDltphYsSXUVO2yZlivCYznbwaGe0X6RqjkI=;
        b=hwhH2+nz0FoxCYxXoaIhwa58l5kBjvFOVB6gGtMrOTYLHgJE0oRgNUMU//WTIPQDxq
         L2tHh3BrhAxEmtTHiZdsh8qsb0w3JbSaFMNBB9W23n/O899YL5NtMe37Rvjd1Oolr51o
         9TY2A3FGOq78MKLgeUfzOLt8mhftdgrcbIAuVc+sMI8PF/0UU9tYKLHCCADtS+eIZMjy
         l2B0/FLKpyv1YFE3E3vTkXeMRgOhtjeVfjw2G/MZqk1a3TOpOVSUJ1q9MZyNknZaU7t6
         ckVEkWTeVmlxrpHQ7HYz8g8qDW/ebwBOiOMaDNCQla/FcrjlQXmjAWgJEI6dIYPQkvp3
         09Bg==
X-Gm-Message-State: AJIora+AxtbkeFUvqmMNQ3qXJfI5FBKsk8Z28ZrSAE3IvOJGn2Q1CeY0
        Jwl5Xf/ioOzoRjeKFFqo9z/rWGJDIqE0MYnq
X-Google-Smtp-Source: AGRyM1s8NPWk6uPN7MO1gXTXN50qbPxl/yLjEX9Etam/Gi4XDgW9vTeNog9ONfPI/pfHeiNHwO522Q==
X-Received: by 2002:a63:ae03:0:b0:408:b78c:e284 with SMTP id q3-20020a63ae03000000b00408b78ce284mr13270424pgf.401.1658807373862;
        Mon, 25 Jul 2022 20:49:33 -0700 (PDT)
Received: from C02F63J9MD6R.bytedance.net ([61.120.150.78])
        by smtp.gmail.com with ESMTPSA id mh11-20020a17090b4acb00b001e29ddf9f4fsm9866214pjb.3.2022.07.25.20.49.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Jul 2022 20:49:33 -0700 (PDT)
From:   Zhuo Chen <chenzhuo.1@bytedance.com>
To:     wangzhou1@hisilicon.com, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     chenzhuo.1@bytedance.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hisilicon - Remove pci_aer_clear_nonfatal_status() call
Date:   Tue, 26 Jul 2022 11:49:26 +0800
Message-Id: <20220726034926.4806-1-chenzhuo.1@bytedance.com>
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

