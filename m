Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB8D7C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Sep 2021 01:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7B816112E
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Sep 2021 01:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239612AbhIFB0M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:26:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239189AbhIFBXE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Sep 2021 21:23:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 018F961131;
        Mon,  6 Sep 2021 01:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891293;
        bh=GMdO6/NJpyqcf6PL78pSXI3sd5nYENoU1UOu6TmTrkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfQ8K8bjATW8BnaKU0Jb7gjBD9HL4Yb49BYyDJWl7ss6mxkgYosDBo5GHbuCk1tTa
         tTvY4r39TEdg19TyGhSLeWFFtmFUhC/eGsKPNOHScOyL+4Pr0rvsD9WMCJQo5/73SJ
         Eh45rud51fESMr+TGxCjMnZYe0e2VZ+l15Zgva46an29IAcDmNcl4ZS8Nk0dGbi4bA
         umjGLO3tKN5sTBJxUKBt+tnEt/12y7WjFUL8tdQLVpiyIbaJw31R9+rHBodcw3B0l0
         dWmKdTUlSxCbKsoKPdYCEpu04+JOTjmMN+SaLs2h2Q10Q4G9Irw6wCAssG2I5bhm3M
         TwZzn5DebJS6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marco Chiappero <marco.chiappero@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 32/46] crypto: qat - fix reuse of completion variable
Date:   Sun,  5 Sep 2021 21:20:37 -0400
Message-Id: <20210906012052.929174-32-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012052.929174-1-sashal@kernel.org>
References: <20210906012052.929174-1-sashal@kernel.org>
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
index a1b77bd7a894..663638bb5c97 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
@@ -316,6 +316,8 @@ static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	msg |= ADF_PFVF_COMPATIBILITY_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
 	BUILD_BUG_ON(ADF_PFVF_COMPATIBILITY_VERSION > 255);
 
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
 	/* Send request from VF to PF */
 	ret = adf_iov_putmsg(accel_dev, msg, 0);
 	if (ret) {
-- 
2.30.2

