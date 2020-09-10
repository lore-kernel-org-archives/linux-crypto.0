Return-Path: <SRS0=7O7/=CT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB03C433E2
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 19:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22B1621D81
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Sep 2020 19:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599766301;
	bh=hL6w8E8SUjjPiOKWWzA5Ali9T6LnigQnlGkrYfgRtaI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=RWxznKu1XEOmU4YzoDWagMBkBlys6Bvbo/rRaj07gahwseoY72uyBpvFbo6rJAHSq
	 wOWww4/XSYIyGHjN6RTnR1qmcFN4FtYQSRycVC6STTLBhxTKJEfAtOw+WMYjQ62qqS
	 7J+MaEouG03XdoFIpgaof5iHUg+Nx14l9nPqZZsQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgIJTbh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Sep 2020 15:31:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727807AbgIJT32 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Sep 2020 15:29:28 -0400
Received: from localhost.localdomain (unknown [194.230.155.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA4620882;
        Thu, 10 Sep 2020 19:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599766166;
        bh=hL6w8E8SUjjPiOKWWzA5Ali9T6LnigQnlGkrYfgRtaI=;
        h=From:To:Cc:Subject:Date:From;
        b=x84wJj85EWTbHdmxLHCcca3DxsfFMsG5BqTYdZV6EXFQI3f9917GjfxRCRslYuc9m
         Etxu4BonuYY/VCMILOoyvU/yUt4mKRBC5qjGZ/oVZi4ZOsLZrjmWNCg6EmArpuPXdx
         UIoQu++lCJCrdk5jovaAHaOen43XILBCHQRS6B/c=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Krzysztof Kozlowski <krzk@kernel.org>
Subject: [PATCH v2 1/4] crypto: caam - Fix kerneldoc
Date:   Thu, 10 Sep 2020 21:29:16 +0200
Message-Id: <20200910192919.12503-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix kerneldoc warnings like:

  drivers/crypto/caam/caamalg_qi2.c:73: warning: cannot understand function prototype: 'struct caam_ctx'
  drivers/crypto/caam/caamalg_qi2.c:2962: warning: cannot understand function prototype: 'struct caam_hash_ctx'
  drivers/crypto/caam/ctrl.c:449: warning: Function parameter or member 'ctrl' not described in 'caam_get_era'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v1:
1. Fix more warnings
---
 drivers/crypto/caam/caamalg_desc.c |  1 +
 drivers/crypto/caam/caamalg_qi2.c  |  4 ++--
 drivers/crypto/caam/ctrl.c         |  4 +++-
 drivers/crypto/caam/jr.c           | 10 +++++-----
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index d6c58184bb57..f0f0fdd1ef32 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -373,6 +373,7 @@ EXPORT_SYMBOL(cnstr_shdsc_aead_encap);
  *         with OP_ALG_AAI_HMAC_PRECOMP.
  * @ivsize: initialization vector size
  * @icvsize: integrity check value (ICV) size (truncated or full)
+ * @geniv: whether to generate Encrypted Chain IV
  * @is_rfc3686: true when ctr(aes) is wrapped by rfc3686 template
  * @nonce: pointer to rfc3686 nonce
  * @ctx1_iv_off: IV offset in CONTEXT1 register
diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 66ae1d581168..0441e4ff2df2 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -59,7 +59,7 @@ struct caam_skcipher_alg {
 };
 
 /**
- * caam_ctx - per-session context
+ * struct caam_ctx - per-session context
  * @flc: Flow Contexts array
  * @key:  [authentication key], encryption key
  * @flc_dma: I/O virtual addresses of the Flow Contexts
@@ -2951,7 +2951,7 @@ enum hash_optype {
 };
 
 /**
- * caam_hash_ctx - ahash per-session context
+ * struct caam_hash_ctx - ahash per-session context
  * @flc: Flow Contexts array
  * @key: authentication key
  * @flc_dma: I/O virtual addresses of the Flow Contexts
diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 65de57f169d9..f7adcf6ecea5 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -444,7 +444,9 @@ static int caam_get_era_from_hw(struct caam_ctrl __iomem *ctrl)
  * by u-boot.
  * In case this property is not passed an attempt to retrieve the CAAM
  * era via register reads will be made.
- **/
+ *
+ * @ctrl:	controller region
+ */
 static int caam_get_era(struct caam_ctrl __iomem *ctrl)
 {
 	struct device_node *caam_node;
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index bf6b03b17251..6f669966ba2c 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -324,7 +324,7 @@ EXPORT_SYMBOL(caam_jr_alloc);
 
 /**
  * caam_jr_free() - Free the Job Ring
- * @rdev     - points to the dev that identifies the Job ring to
+ * @rdev:      points to the dev that identifies the Job ring to
  *             be released.
  **/
 void caam_jr_free(struct device *rdev)
@@ -349,15 +349,15 @@ EXPORT_SYMBOL(caam_jr_free);
  *        of this request. This has the form:
  *        callback(struct device *dev, u32 *desc, u32 stat, void *arg)
  *        where:
- *        @dev:    contains the job ring device that processed this
+ *        dev:     contains the job ring device that processed this
  *                 response.
- *        @desc:   descriptor that initiated the request, same as
+ *        desc:    descriptor that initiated the request, same as
  *                 "desc" being argued to caam_jr_enqueue().
- *        @status: untranslated status received from CAAM. See the
+ *        status:  untranslated status received from CAAM. See the
  *                 reference manual for a detailed description of
  *                 error meaning, or see the JRSTA definitions in the
  *                 register header file
- *        @areq:   optional pointer to an argument passed with the
+ *        areq:    optional pointer to an argument passed with the
  *                 original request
  * @areq: optional pointer to a user argument for use at callback
  *        time.
-- 
2.17.1

