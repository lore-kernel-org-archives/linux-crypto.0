Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E39C00A8F
	for <linux-crypto@archiver.kernel.org>; Sun, 22 Oct 2023 08:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbjJVISw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 22 Oct 2023 04:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbjJVISr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 22 Oct 2023 04:18:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADDEE7
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 01:18:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89BDFC433D9
        for <linux-crypto@vger.kernel.org>; Sun, 22 Oct 2023 08:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697962725;
        bh=ONmdFDGh+bdASoYWSvdDq7sIj09NLUwaduP/l6rcSpA=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ICc33dfXP9GE11uZHc2PmYJrJYcHN/hRmoX4WA9v95VLTCpdb1eznoHL/sJZszu52
         hav8ltLlbvgRUSC/OAqj+fk8qe3/3Hix5GvSo8x5OQESiqxA+RdnQO7Lc5uskTxJVE
         m8p3Ojo5nBkiFOuJQJpkdsufjQu6v9BhBkkMQPXF/jJcSBUXHR5A/gB1ZMpFzPOlpa
         VYtfZpanksWJLJqkISyg7aU9iBTnUGuNRL0P08lg1/4qw021SHtsdrf5hw10aIqKZz
         4F8/M/YFJiAjhHSYm0ULvPwl23PyxFVdrIUvVA9UwDSE+/4snqPaaRQeYZrP934INz
         gExJ2UFN+HjkQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 09/30] crypto: talitos - remove unnecessary alignmask for ahashes
Date:   Sun, 22 Oct 2023 01:10:39 -0700
Message-ID: <20231022081100.123613-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
References: <20231022081100.123613-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The crypto API's support for alignmasks for ahash algorithms is nearly
useless, as its only effect is to cause the API to align the key and
result buffers.  The drivers that happen to be specifying an alignmask
for ahash rarely actually need it.  When they do, it's easily fixable,
especially considering that these buffers cannot be used for DMA.

In preparation for removing alignmask support from ahash, this patch
makes the talitos driver no longer use it.  This driver didn't actually
rely on it; it only writes to the result buffer in
common_nonsnoop_hash_unmap(), simply using memcpy().  And this driver's
"ahash_setkey()" function does not assume any alignment for the key
buffer.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/crypto/talitos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4ca4fbd227bce..e8f710d87007b 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -3252,21 +3252,21 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
 		devm_kfree(dev, t_alg);
 		return ERR_PTR(-EINVAL);
 	}
 
 	alg->cra_module = THIS_MODULE;
 	if (t_alg->algt.priority)
 		alg->cra_priority = t_alg->algt.priority;
 	else
 		alg->cra_priority = TALITOS_CRA_PRIORITY;
-	if (has_ftr_sec1(priv))
+	if (has_ftr_sec1(priv) && t_alg->algt.type != CRYPTO_ALG_TYPE_AHASH)
 		alg->cra_alignmask = 3;
 	else
 		alg->cra_alignmask = 0;
 	alg->cra_ctxsize = sizeof(struct talitos_ctx);
 	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
 
 	t_alg->dev = dev;
 
 	return t_alg;
 }
-- 
2.42.0

