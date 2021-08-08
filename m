Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBE5C4338F
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Aug 2021 20:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67C9A60F92
	for <linux-crypto@archiver.kernel.org>; Sun,  8 Aug 2021 20:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhHHUwz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 Aug 2021 16:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbhHHUwz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Aug 2021 16:52:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C73C0613CF;
        Sun,  8 Aug 2021 13:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=gvBqJCrtIO7/h5aTsrK4fKh+UErHls5iIKGGR8pWIJQ=; b=3277cQlvW9TXLh5cofuwuIbmFU
        jRx52bNUMB9HpOaBT6GpljuPJkwT2my40FTx6voCeaTi1gZkD0XyLaQ8ouDBDj8cZF8dnqBhxsS9h
        5uqxKuBvoVeuChG/wY5CHVtO70sn9r4hgLMmNcMOoSZ0tQlKwkpUy8yLwTOTKL71Dr4CGDbG7BdiR
        1HlI0aCDVHZ3ILgZCmf5TZBBdTkLpKwMXRLv8UpfPTljVgWzHY8Bs+OHEKUimSJ2nm5YYNIk80pBR
        LYpg9HJbWk6d7xSThLv3nrdBYVnosBBkX/Vw7Gsgynqz9f3q4Y96FxoEKV/IMdZht7zCEUOmYy988
        FlZ/7YsQ==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCpmd-00GUaQ-Pz; Sun, 08 Aug 2021 20:52:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] asymmetric_keys: verify_pefile: fix kernel-doc notation
Date:   Sun,  8 Aug 2021 13:52:35 -0700
Message-Id: <20210808205235.21903-1-rdunlap@infradead.org>
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
 crypto/asymmetric_keys/verify_pefile.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20210806.orig/crypto/asymmetric_keys/verify_pefile.c
+++ linux-next-20210806/crypto/asymmetric_keys/verify_pefile.c
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
