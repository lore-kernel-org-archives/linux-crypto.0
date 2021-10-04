Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CDBC43219
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Oct 2021 00:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C88996137B
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Oct 2021 00:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhJDATY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 3 Oct 2021 20:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhJDATX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 3 Oct 2021 20:19:23 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52708C0613EC;
        Sun,  3 Oct 2021 17:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=BzU97T2pVgwYr7cYRocxRO+B5/awNlxV2NqnFxavjBQ=; b=vfwPlLrq1cIOHBtwtb6s8g17Ey
        3pEGc/CTVXJCsEh0CLa9CghSJ9TkNbgKugPNZkrddLWrsXu5jnfn7awIqaJPFzHOeYV3MrpdbYjdG
        QwovKNBTF+jgTaUQyrsZHrWOQRA84ZaK/cC7vin2l2xm+fxZUVP99m7rq4CFgcTf9EbkCFeO7T4CN
        c638/qQjuetoC37wyDWKHS+b3Vya8JhkFmN5Y9IaaoToCtm4bMPUxg5KQohFcyjNk9oAxCvZjN+Rt
        XeiO5g9XhGdOn9n7pI4lrwYbVFpCA4tA3td9oauzGTbCrXqxFNc500NnFdh9Pwy/+ht8N/4njeC3f
        46ee/Wgw==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mXBfg-004klb-Az; Mon, 04 Oct 2021 00:17:32 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2] asymmetric_keys: verify_pefile: fix kernel-doc notation
Date:   Sun,  3 Oct 2021 17:17:31 -0700
Message-Id: <20211004001731.26240-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Correct the warnings from scripts/kernel-doc:

crypto/asymmetric_keys/verify_pefile.c:419: warning: Function parameter or member 'trusted_keys' not described in 'verify_pefile_signature'
crypto/asymmetric_keys/verify_pefile.c:419: warning: Excess function parameter 'trust_keys' description in 'verify_pefile_signature'
crypto/asymmetric_keys/verify_pefile.c:419: warning: No description found for return value of 'verify_pefile_signature'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
v2: no changes, just rebased and resent.

 crypto/asymmetric_keys/verify_pefile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20211001.orig/crypto/asymmetric_keys/verify_pefile.c
+++ linux-next-20211001/crypto/asymmetric_keys/verify_pefile.c
@@ -387,13 +387,13 @@ error_no_desc:
  * verify_pefile_signature - Verify the signature on a PE binary image
  * @pebuf: Buffer containing the PE binary image
  * @pelen: Length of the binary image
- * @trust_keys: Signing certificate(s) to use as starting points
+ * @trusted_keys: Signing certificate(s) to use as starting points
  * @usage: The use to which the key is being put.
  *
  * Validate that the certificate chain inside the PKCS#7 message inside the PE
  * binary image intersects keys we already know and trust.
  *
- * Returns, in order of descending priority:
+ * Return: in order of descending priority:
  *
  *  (*) -ELIBBAD if the image cannot be parsed, or:
  *
