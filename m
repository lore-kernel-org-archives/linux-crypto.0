Return-Path: <SRS0=z7PZ=EE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB2DC4363A
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 15:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5EE920790
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Oct 2020 15:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603986518;
	bh=IvQP1dDAbNODidswNW7by3Hqoc8OdOVCEcn2toqRwHA=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1T1kNiaMlly+fSSlNmU4xLmLff3LePW0UOs7bXTVC5mxcsLZFlaoO58d/Ch25TfIz
	 tWRuvBZ3N9f9uhLoCNshMOBJd3wFDbk1TJIfsBJiv3VwD6lVO9cZlvdDDaUW3fT8pj
	 +JYPBmxMzMRqvGnwCwNZotzIj8/stcdj9cX4Sow4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727832AbgJ2Psi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Oct 2020 11:48:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728112AbgJ2Psi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Oct 2020 11:48:38 -0400
Received: from localhost.localdomain (adsl-84-226-167-205.adslplus.ch [84.226.167.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1E5B2076B;
        Thu, 29 Oct 2020 15:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603986517;
        bh=IvQP1dDAbNODidswNW7by3Hqoc8OdOVCEcn2toqRwHA=;
        h=From:To:Cc:Subject:Date:From;
        b=lCc5ALxazQH5Yvn1QsYl4aM9AsWW1OS/NX0icDf7qFCmXCu5acBDNaI1KJq7RUL15
         VnTUUFeFOFxaraYxAqiEfC7V9ApLlQNSuAJYyUZ0kctp25MYqpsJ3NCIY0nPw6f6rV
         Oa+0JTPKKOKvK4v2yRpleb6pWvHUUO3jfaUBwci0=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [RESEND PATCH] KEYS: asymmetric: Fix kerneldoc
Date:   Thu, 29 Oct 2020 16:48:30 +0100
Message-Id: <20201029154830.26997-1-krzk@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix W=1 compile warnings (invalid kerneldoc):

    crypto/asymmetric_keys/asymmetric_type.c:160: warning: Function parameter or member 'kid1' not described in 'asymmetric_key_id_same'
    crypto/asymmetric_keys/asymmetric_type.c:160: warning: Function parameter or member 'kid2' not described in 'asymmetric_key_id_same'
    crypto/asymmetric_keys/asymmetric_type.c:160: warning: Excess function parameter 'kid_1' description in 'asymmetric_key_id_same'
    crypto/asymmetric_keys/asymmetric_type.c:160: warning: Excess function parameter 'kid_2' description in 'asymmetric_key_id_same'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
---
 crypto/asymmetric_keys/asymmetric_type.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/crypto/asymmetric_keys/asymmetric_type.c b/crypto/asymmetric_keys/asymmetric_type.c
index 33e77d846caa..ad8af3d70ac0 100644
--- a/crypto/asymmetric_keys/asymmetric_type.c
+++ b/crypto/asymmetric_keys/asymmetric_type.c
@@ -152,7 +152,8 @@ EXPORT_SYMBOL_GPL(asymmetric_key_generate_id);
 
 /**
  * asymmetric_key_id_same - Return true if two asymmetric keys IDs are the same.
- * @kid_1, @kid_2: The key IDs to compare
+ * @kid1: The key ID to compare
+ * @kid2: The key ID to compare
  */
 bool asymmetric_key_id_same(const struct asymmetric_key_id *kid1,
 			    const struct asymmetric_key_id *kid2)
@@ -168,7 +169,8 @@ EXPORT_SYMBOL_GPL(asymmetric_key_id_same);
 /**
  * asymmetric_key_id_partial - Return true if two asymmetric keys IDs
  * partially match
- * @kid_1, @kid_2: The key IDs to compare
+ * @kid1: The key ID to compare
+ * @kid2: The key ID to compare
  */
 bool asymmetric_key_id_partial(const struct asymmetric_key_id *kid1,
 			       const struct asymmetric_key_id *kid2)
-- 
2.25.1

