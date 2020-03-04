Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2382BC3F2D8
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0C9220716
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583361880;
	bh=guigaYqeraIW/KayIP4VoOTQFQRQPlX7LdTXIVH60aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=IIZf7mXIE08GDENsiKpr85eVeF/DjoL3vL8ia2LgIHnMz6WgQzwGg3VB4GHK4YPmv
	 9IB1lnEW0vb2jprSxgyTe9iiQ806NmP1sI4Y34w/guR9Hb6fGWaj9wB17bpuAKSqdf
	 QNru2skNPxv3Yq2XQnkzD8tUUyazeE3MISJn9jRY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387931AbgCDWoj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 17:44:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:49318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388400AbgCDWoj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 17:44:39 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B230320870;
        Wed,  4 Mar 2020 22:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583361877;
        bh=guigaYqeraIW/KayIP4VoOTQFQRQPlX7LdTXIVH60aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kmkqd2WGrV47Tl4gA5Py5Ekkg47qDew7I+b7VxYdOQpIWz+z2Hx3q8Taf9W6mLtJO
         aduwFAxuQQqGBYpntgdUrhRgWsPKAaS9ZooAQ5r9xtOrG+txk2wxXdQE03DlbLPXpv
         w6eKjEsiuE8qYw4tvrlaIYaWz1HJZKw/ZIIL1dxk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>,
        Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 3/3] crypto: aead - improve documentation for scatterlist layout
Date:   Wed,  4 Mar 2020 14:44:05 -0800
Message-Id: <20200304224405.152829-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304224405.152829-1-ebiggers@kernel.org>
References: <20200304224405.152829-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Properly document the scatterlist layout for AEAD ciphers.

Reported-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 include/crypto/aead.h | 48 ++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/include/crypto/aead.h b/include/crypto/aead.h
index 1b3ebe8593c0..62c68550aab6 100644
--- a/include/crypto/aead.h
+++ b/include/crypto/aead.h
@@ -43,27 +43,33 @@
  *
  * Memory Structure:
  *
- * To support the needs of the most prominent user of AEAD ciphers, namely
- * IPSEC, the AEAD ciphers have a special memory layout the caller must adhere
- * to.
- *
- * The scatter list pointing to the input data must contain:
- *
- * * for RFC4106 ciphers, the concatenation of
- *   associated authentication data || IV || plaintext or ciphertext. Note, the
- *   same IV (buffer) is also set with the aead_request_set_crypt call. Note,
- *   the API call of aead_request_set_ad must provide the length of the AAD and
- *   the IV. The API call of aead_request_set_crypt only points to the size of
- *   the input plaintext or ciphertext.
- *
- * * for "normal" AEAD ciphers, the concatenation of
- *   associated authentication data || plaintext or ciphertext.
- *
- * It is important to note that if multiple scatter gather list entries form
- * the input data mentioned above, the first entry must not point to a NULL
- * buffer. If there is any potential where the AAD buffer can be NULL, the
- * calling code must contain a precaution to ensure that this does not result
- * in the first scatter gather list entry pointing to a NULL buffer.
+ * The source scatterlist must contain the concatenation of
+ * associated data || plaintext or ciphertext.
+ *
+ * The destination scatterlist has the same layout, except that the plaintext
+ * (resp. ciphertext) will grow (resp. shrink) by the authentication tag size
+ * during encryption (resp. decryption).
+ *
+ * In-place encryption/decryption is enabled by using the same scatterlist
+ * pointer for both the source and destination.
+ *
+ * Even in the out-of-place case, space must be reserved in the destination for
+ * the associated data, even though it won't be written to.  This makes the
+ * in-place and out-of-place cases more consistent.  It is permissible for the
+ * "destination" associated data to alias the "source" associated data.
+ *
+ * As with the other scatterlist crypto APIs, zero-length scatterlist elements
+ * are not allowed in the used part of the scatterlist.  Thus, if there is no
+ * associated data, the first element must point to the plaintext/ciphertext.
+ *
+ * To meet the needs of IPsec, a special quirk applies to rfc4106, rfc4309,
+ * rfc4543, and rfc7539esp ciphers.  For these ciphers, the final 'ivsize' bytes
+ * of the associated data buffer must contain a second copy of the IV.  This is
+ * in addition to the copy passed to aead_request_set_crypt().  These two IV
+ * copies must not differ; different implementations of the same algorithm may
+ * behave differently in that case.  Note that the algorithm might not actually
+ * treat the IV as associated data; nevertheless the length passed to
+ * aead_request_set_ad() must include it.
  */
 
 struct crypto_aead;
-- 
2.25.1

