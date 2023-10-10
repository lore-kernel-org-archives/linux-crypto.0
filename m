Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480D3CD68ED
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Oct 2023 06:42:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442241AbjJJGmx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Oct 2023 02:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442260AbjJJGmu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Oct 2023 02:42:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A005E97
        for <linux-crypto@vger.kernel.org>; Mon,  9 Oct 2023 23:42:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB280C433CC
        for <linux-crypto@vger.kernel.org>; Tue, 10 Oct 2023 06:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696920168;
        bh=xA6xEHEpi4PkMd4hcqKI5rOcbnJVAifbAg3rvW4GN2s=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XyNcSB/8DH3GrGUcI/cbWZ2MXmlP1hmpv+X18fHFMgc4czxed+EX4DfldVDcAaHDv
         msnGd+8S1aktMZ122+OrdO/95Q5+hp12mBZ+RAallDrzC5hWywn72Ltyq/xhz0W8fY
         XQmqckexnXIKGuvNw5nkt5+GiEQNyWCcEpT2a1lfo4Lod0PzbuTonagXNgeirRTayd
         azcNDBBQrFk53gEXSU0WloawCASjSVrhgWqQjkpmrhgkyzA12XbAp/pLR7eLFFLJus
         2YOeSCPTNjre5o5a/TcF/FxIJvx/T0YOG8g+UvcQaBTvpKXiakgGJBbxzOs+hVaONu
         ZZj5o88BTW9hg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 5/5] crypto: arm64/sha512 - clean up backwards function names
Date:   Mon,  9 Oct 2023 23:41:27 -0700
Message-ID: <20231010064127.323261-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231010064127.323261-1-ebiggers@kernel.org>
References: <20231010064127.323261-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In the Linux kernel, a function whose name has two leading underscores
is conventionally called by the same-named function without leading
underscores -- not the other way around.  __sha512_block_data_order()
got this backwards.  Fix this, albeit without changing the name in the
perlasm since that is OpenSSL code.  No change in behavior.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/sha512-glue.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/crypto/sha512-glue.c b/arch/arm64/crypto/sha512-glue.c
index 2acff1c7df5d7..62f129dea83d8 100644
--- a/arch/arm64/crypto/sha512-glue.c
+++ b/arch/arm64/crypto/sha512-glue.c
@@ -23,8 +23,8 @@ asmlinkage void sha512_block_data_order(u64 *digest, const void *data,
 					unsigned int num_blks);
 EXPORT_SYMBOL(sha512_block_data_order);
 
-static void __sha512_block_data_order(struct sha512_state *sst, u8 const *src,
-				      int blocks)
+static void sha512_arm64_transform(struct sha512_state *sst, u8 const *src,
+				   int blocks)
 {
 	sha512_block_data_order(sst->state, src, blocks);
 }
@@ -32,17 +32,15 @@ static void __sha512_block_data_order(struct sha512_state *sst, u8 const *src,
 static int sha512_update(struct shash_desc *desc, const u8 *data,
 			 unsigned int len)
 {
-	return sha512_base_do_update(desc, data, len,
-				     __sha512_block_data_order);
+	return sha512_base_do_update(desc, data, len, sha512_arm64_transform);
 }
 
 static int sha512_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
 {
 	if (len)
-		sha512_base_do_update(desc, data, len,
-				      __sha512_block_data_order);
-	sha512_base_do_finalize(desc, __sha512_block_data_order);
+		sha512_base_do_update(desc, data, len, sha512_arm64_transform);
+	sha512_base_do_finalize(desc, sha512_arm64_transform);
 
 	return sha512_base_finish(desc, out);
 }
-- 
2.42.0

