Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B80AAC433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Sep 2021 01:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A235D60F5E
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Sep 2021 01:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241121AbhIFB1z (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239659AbhIFBZy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Sep 2021 21:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DBCD61175;
        Mon,  6 Sep 2021 01:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891349;
        bh=ruzdFOpugTE4tvFpaPEodh/V+m9xP7BGuEwvcoe+7SA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tryoocjb/y5wWNwhjxKACiH+BMd/1AryNpgqLfI4/3gwzrER3kahjCR06t/gVOd7O
         XLmfSvLFz2Zz3w5lTOGAGcNV/rN3eGn+ccHZsJ1om/8ZQVMczgxWG6QqmWRtmeIDip
         EUnrV/ehcqR28of+EmIjX95N0NEmMiGLPJIZjs4ZuBERbx29wo77baBosCfpUhHYJq
         YtbmUFxC/0rPadX41fF4VuPxZARzLcxE4WDZuaPLp7xAOUJ3JUKqq1mCQ2I1qaZiEf
         p1kcBQqSEae1MO0Wcw51aKXd9vdgn30cwP0DjG2/F7cBiEW6zKpXJZpxa2p0oGrwMn
         nvIj+etnfa/tA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/39] crypto: qat - handle both source of interrupt in VF ISR
Date:   Sun,  5 Sep 2021 21:21:43 -0400
Message-Id: <20210906012153.929962-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

[ Upstream commit 0a73c762e1eee33a5e5dc0e3488f1b7cd17249b3 ]

The top half of the VF drivers handled only a source at the time.
If an interrupt for PF2VF and bundle occurred at the same time, the ISR
scheduled only the bottom half for PF2VF.
This patch fixes the VF top half so that if both sources of interrupt
trigger at the same time, both bottom halves are scheduled.

This patch is based on earlier work done by Conor McLoughlin.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_vf_isr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 31a36288623a..024401ec9d1a 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -159,6 +159,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 	struct adf_bar *pmisc =
 			&GET_BARS(accel_dev)[hw_data->get_misc_bar_id(hw_data)];
 	void __iomem *pmisc_bar_addr = pmisc->virt_addr;
+	bool handled = false;
 	u32 v_int;
 
 	/* Read VF INT source CSR to determine the source of VF interrupt */
@@ -171,7 +172,7 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 
 		/* Schedule tasklet to handle interrupt BH */
 		tasklet_hi_schedule(&accel_dev->vf.pf2vf_bh_tasklet);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
 	/* Check bundle interrupt */
@@ -183,10 +184,10 @@ static irqreturn_t adf_isr(int irq, void *privdata)
 		WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
 					   0);
 		tasklet_hi_schedule(&bank->resp_handler);
-		return IRQ_HANDLED;
+		handled = true;
 	}
 
-	return IRQ_NONE;
+	return handled ? IRQ_HANDLED : IRQ_NONE;
 }
 
 static int adf_request_msi_irq(struct adf_accel_dev *accel_dev)
-- 
2.30.2

