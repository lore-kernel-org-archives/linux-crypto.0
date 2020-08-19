Return-Path: <SRS0=AsAY=B5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D35C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 17:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE9F120758
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 17:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597859551;
	bh=mARbbccibp0w+1VVZDf+WZpyqmdv+vpiA7azcsNO8a8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=2ljSS/qJxPyqbrxm4nixlVABrvMtykWf9sHAJZCgVqHQEcTUZfzk+/ZUv1aZ57Mzl
	 DWopUbN4iRRLjsTN0sAMD4utlaONjRmm3UUSyD5/pNtNtNd1t4BRKToWMBKJfT3exE
	 MCZYfEYe8xAVPnHy9q59Kbm5N7ONXl05X+G0yKCk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgHSRwY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Aug 2020 13:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHSRwU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Aug 2020 13:52:20 -0400
Received: from kozik-lap.mshome.net (unknown [194.230.155.216])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A6CD2067C;
        Wed, 19 Aug 2020 17:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597859540;
        bh=mARbbccibp0w+1VVZDf+WZpyqmdv+vpiA7azcsNO8a8=;
        h=From:To:Cc:Subject:Date:From;
        b=K8afYfVtXLEOHFe1BlTb6CxX+sO5OcEaiQB3sUlKQuvzyGK7V8Dcy62weFFktkG4M
         fudltBQPDaApRwTm9UgHYqmV+MEbm/AwjxbDGIp9whSMKzvtBojX5oQaKL5bbdZwsP
         J9+TI0SKZSCw4I0m/Ft7aYnONn1IrL52laQfBvVk=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>
Subject: [RESEND PATCH] KEYS: asymmetric: Fix kerneldoc
Date:   Wed, 19 Aug 2020 19:52:12 +0200
Message-Id: <20200819175212.20583-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix W=1 compile warnings (invalid kerneldoc):

    crypto/asymmetric_keys/asymmetric_type.c:160: warning: Function parameter or member 'kid1' not described in 'asymmetric_key_id_same'
    crypto/asymmetric_keys/asymmetric_type.c:160: warning: Function parameter or member 'kid2' not described in 'asymmetric_key_id_same'
    crypto/asymmetric_keys/asymmetric_type.c:160: warning: Excess function parameter 'kid_1' description in 'asymmetric_key_id_same'
    crypto/asymmetric_keys/asymmetric_type.c:160: warning: Excess function parameter 'kid_2' description in 'asymmetric_key_id_same'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
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
2.17.1

