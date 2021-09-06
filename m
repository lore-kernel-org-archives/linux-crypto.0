Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07457C4167D
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Sep 2021 01:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB9AE61056
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Sep 2021 01:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240951AbhIFBcn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351895AbhIFBbN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Sep 2021 21:31:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 029596120E;
        Mon,  6 Sep 2021 01:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891485;
        bh=6iTU7lGJM32Aa0d+IJG1BTR+lZTC4LxxCYjNTs5nnMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdgqU5vTdzGSWhf9MPl0ry4/UfBJqnLEnJe0of1gvorTTbALDmlI8paeo4IVTxYla
         tnDcDIdnNToFAwSOGi+hhb+5wXpwO37JJt/TaNcap9xxkZBHWxED0dn2bfQht0FRoz
         f2oikZLsAsKpoB2Idd/czOJKhbLF6WZT419X9b/cAvf5iL9VAnG12VBu5L/1C3JrIH
         RLyUZzqyOmpkEDY5FJUBryTiKTr5c9SSyO5ISW93/t3l+rNUmv1cUo/N8jy+9szKqO
         hDbZVhw4XckoTxEnLexeVkbxcWu/DiDxhYhg3h934mLOWuuL8NMAT/N+V80Bs/6ngA
         8wSva+NzPATUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 7/9] crypto: qat - fix reuse of completion variable
Date:   Sun,  5 Sep 2021 21:24:32 -0400
Message-Id: <20210906012435.931318-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012435.931318-1-sashal@kernel.org>
References: <20210906012435.931318-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

[ Upstream commit 3d655732b0199562267a05c7ff69ecdd11632939 ]

Use reinit_completion() to set to a clean state a completion variable,
used to coordinate the VF to PF request-response flow, before every
new VF request.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_common/adf_pf2vf_msg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
index 5fdbad809343..711706819b05 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -384,6 +384,8 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPATIBILITY_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPATIBILITY_VERSION > 255);
 
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
 	/* Send request from VF to PF */
 	ret = adf_iov_putmsg(accel_dev, msg, 0);
 	if (ret) {
-- 
2.30.2

