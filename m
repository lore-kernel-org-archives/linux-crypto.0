Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D75C4332F
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Oct 2023 04:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjJ2E7e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Oct 2023 00:59:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjJ2E7e (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Oct 2023 00:59:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4576D3
        for <linux-crypto@vger.kernel.org>; Sat, 28 Oct 2023 21:59:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4B9C433C7;
        Sun, 29 Oct 2023 04:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698555571;
        bh=LkQeiNTuvPcVoQXvfSZnCqLZzlPgsA+O7+t3nCIm834=;
        h=From:To:Cc:Subject:Date:From;
        b=Bdxb6Swo6AVFD7qiSkhlMp6C2H9ME79ArC8el1ELdKwKi0dHSgxGLSr+TlgFUJW3s
         /oahQMexiEBXcNQw0ouEuQIeOprODgDFekj/tiWTwS16nQu84wRFugtZJ6JFfesVEQ
         dcoa/IwRkDjdtwME5oQAbw35i4KHdJ+I23lNVbGngLGk1iFaqMg7+m0cubpQaA/sv+
         fpX0PJ4QZQ5FMxW3lM0g6KCIgkdNkOlK1YGHb5hXfb4aEmEoqc3X3fmWO4KiT8Ersk
         aLrSPAXHuds8Sz4zNNELJ8nI1NXv9HiT+vnHt9Ti0jRWSGzkIjv/lupyA6NLot9i61
         nz0BgoWWd7MAg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH] dm-crypt: use crypto_shash_digest() in crypt_iv_tcw_whitening()
Date:   Sat, 28 Oct 2023 21:59:23 -0700
Message-ID: <20231029045923.154267-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Simplify crypt_iv_tcw_whitening() by using crypto_shash_digest() instead
of an init+update+final sequence.  This should also improve performance.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-crypt.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 5315fd261c23..32d230e3180d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -645,27 +645,21 @@ static int crypt_iv_tcw_whitening(struct crypt_config *cc,
 	SHASH_DESC_ON_STACK(desc, tcw->crc32_tfm);
 	int i, r;
 
 	/* xor whitening with sector number */
 	crypto_xor_cpy(buf, tcw->whitening, (u8 *)&sector, 8);
 	crypto_xor_cpy(&buf[8], tcw->whitening + 8, (u8 *)&sector, 8);
 
 	/* calculate crc32 for every 32bit part and xor it */
 	desc->tfm = tcw->crc32_tfm;
 	for (i = 0; i < 4; i++) {
-		r = crypto_shash_init(desc);
-		if (r)
-			goto out;
-		r = crypto_shash_update(desc, &buf[i * 4], 4);
-		if (r)
-			goto out;
-		r = crypto_shash_final(desc, &buf[i * 4]);
+		r = crypto_shash_digest(desc, &buf[i * 4], 4, &buf[i * 4]);
 		if (r)
 			goto out;
 	}
 	crypto_xor(&buf[0], &buf[12], 4);
 	crypto_xor(&buf[4], &buf[8], 4);
 
 	/* apply whitening (8 bytes) to whole sector */
 	for (i = 0; i < ((1 << SECTOR_SHIFT) / 8); i++)
 		crypto_xor(data + i * 8, buf, 8);
 out:

base-commit: 2af9b20dbb39f6ebf9b9b6c090271594627d818e
-- 
2.42.0

