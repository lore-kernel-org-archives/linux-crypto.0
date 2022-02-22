Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3C1AC4167D
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Feb 2022 16:32:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiBVQdJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 11:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbiBVQcq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 11:32:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41527A1472;
        Tue, 22 Feb 2022 08:32:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D16F760AE7;
        Tue, 22 Feb 2022 16:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B647C340FA;
        Tue, 22 Feb 2022 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645547540;
        bh=uWKvcbndHUbVrYNRcixdhR5Elks38X+3GOL0tdfRPzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ieNUGNnXSHNKaVr1+0n5C4OGbzjh8+RApiiRpmD9IWGLKqlKo+faMq77/wn0IOHzO
         7tE/CuRKrnSlvV55q79nm9CRk3ecj1ECY/9MemIUOWBYdUmJUDThKQqAJWrwYdPVeU
         PI/urv8P3Hn+TztOQI1jTDMABmI2GddCcVHOw4vEUQd52J9jcysYlGBPKIGrHpxm2T
         SBpEX9aPVfCj08okWmiN9/18ISSV3zwTw3b4DBX/SH3ac6ppOKWXv+SDbDWCoGKMXg
         +89YtCMB/o6uVD72f6yIRvb/XGP4UXdOlteEiCLXzixHiDTkOhSExbS2w9wfm/vS04
         VGYH3orrCxn6A==
From:   Keith Busch <kbusch@kernel.org>
To:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
        colyli@suse.de, Keith Busch <kbusch@kernel.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 01/10] block: support pi with extended metadata
Date:   Tue, 22 Feb 2022 08:31:35 -0800
Message-Id: <20220222163144.1782447-2-kbusch@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20220222163144.1782447-1-kbusch@kernel.org>
References: <20220222163144.1782447-1-kbusch@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The nvme spec allows protection information formats with metadata
extending beyond the pi field. Use the actual size of the metadata field
for incrementing the buffer.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/bio-integrity.c         | 1 +
 block/t10-pi.c                | 4 ++--
 include/linux/blk-integrity.h | 1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6996e7bd66e9..32929c89ba8a 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -165,6 +165,7 @@ static blk_status_t bio_integrity_process(struct bio *bio,
 
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	iter.interval = 1 << bi->interval_exp;
+	iter.tuple_size = bi->tuple_size;
 	iter.seed = proc_iter->bi_sector;
 	iter.prot_buf = bvec_virt(bip->bip_vec);
 
diff --git a/block/t10-pi.c b/block/t10-pi.c
index 25a52a2a09a8..758a76518854 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -44,7 +44,7 @@ static blk_status_t t10_pi_generate(struct blk_integrity_iter *iter,
 			pi->ref_tag = 0;
 
 		iter->data_buf += iter->interval;
-		iter->prot_buf += sizeof(struct t10_pi_tuple);
+		iter->prot_buf += iter->tuple_size;
 		iter->seed++;
 	}
 
@@ -93,7 +93,7 @@ static blk_status_t t10_pi_verify(struct blk_integrity_iter *iter,
 
 next:
 		iter->data_buf += iter->interval;
-		iter->prot_buf += sizeof(struct t10_pi_tuple);
+		iter->prot_buf += iter->tuple_size;
 		iter->seed++;
 	}
 
diff --git a/include/linux/blk-integrity.h b/include/linux/blk-integrity.h
index 8a038ea0717e..378b2459efe2 100644
--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -19,6 +19,7 @@ struct blk_integrity_iter {
 	sector_t		seed;
 	unsigned int		data_size;
 	unsigned short		interval;
+	unsigned char		tuple_size;
 	const char		*disk_name;
 };
 
-- 
2.25.4

