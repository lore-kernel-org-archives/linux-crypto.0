Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62401227BA2;
	Wed,  5 Feb 2025 00:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738716929; cv=none; b=V8Qw5Pv9eU/hS1GIbl2Dq8nfAhNkwWmcYYNrTCALAYAqkxhjkPksssJrcZiSzGWQuZR3kW8O+HykP2k9rO9TDlnt5rc3DjPn0hfp6cD8WElk9ficdWh38ttMrqvMZYjvmSUse/NXwAaW08k0BhWTdTw1TBX/KGGjf8KtZbxrYqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738716929; c=relaxed/simple;
	bh=lPVUHafT6u9sbNJD4so3zYCJBp2nYW5wRkpR5Sd8ibE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2LBOoFcXi5maARYn6XGk1YtzhbRmhOsqipffhye74gjQxyeo1yQk/gcrm2U2XUm7U49JxH0VK51sPMMMrrje3C7iA5D5coP/tuIgU5SR6jA8oi81VuPgAhTBnWOYjsu20UcbXrUtF9ad9bFbax05tlBvq5LUKX7Jgu6cGyb0p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0y0xlJd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0y0xlJd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E655AC4CEE7;
	Wed,  5 Feb 2025 00:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738716929;
	bh=lPVUHafT6u9sbNJD4so3zYCJBp2nYW5wRkpR5Sd8ibE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0y0xlJdZOk36/zeuu3f9wSVtx6JwaQL6EjaGgRqHXKdLudY6+fpySdSZmoREIe4M
	 YKtG6on7ySLutHfAnlC/CRmU52IdnXQe93k7fDczyCK4Cf8TflZ3Sp3pQ0pmPAt61g
	 kOn/NrCcoYZBsY4lf6LMw1NMQXmpFdbLmDuwDW8VkQnff35ZIquMBFznpRr6fy4o/I
	 lzaNGMe8sMoMiu8jH2BUPggvV4B9uoV/Tmt9La8o14XY+v+sjIskyMrRzznxDxemlv
	 /LAGBtG+hv4WN5xgwFXmEq3zstdLtrwvy9p5GDahHO8aDMU3OANC1g3xvIIOL7G+Ph
	 wFnLaBAa+432Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 3/5] lib/crc32: standardize on crc32c() name for Castagnoli CRC32
Date: Tue,  4 Feb 2025 16:54:01 -0800
Message-ID: <20250205005403.136082-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205005403.136082-1-ebiggers@kernel.org>
References: <20250205005403.136082-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

For historical reasons, the Castagnoli CRC32 is available under 3 names:
crc32c(), crc32c_le(), __crc32c_le().  Most callers use crc32c().  The
more verbose versions are not really warranted; there is no "_be"
version that the "_le" version needs to be differentiated from, and the
leading underscores are pointless.

Therefore, let's standardize on just crc32c().  Remove the other two
names, and update callers accordingly.

Specifically, the new crc32c() comes from what was previously
__crc32c_le(), so compared to the old crc32c() it now takes a size_t
length rather than unsigned int, and it's now in linux/crc32.h instead
of just linux/crc32c.h (which includes linux/crc32.h).

Later patches will also rename __crc32c_le_combine(), crc32c_le_base(),
and crc32c_le_arch().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/crc32c_generic.c                       |  4 +--
 drivers/crypto/stm32/stm32-crc32.c            |  2 +-
 drivers/md/raid5-cache.c                      | 31 +++++++++----------
 drivers/md/raid5-ppl.c                        | 16 +++++-----
 .../net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |  2 +-
 drivers/thunderbolt/ctl.c                     |  2 +-
 drivers/thunderbolt/eeprom.c                  |  2 +-
 include/linux/crc32.h                         |  5 ++-
 include/linux/crc32c.h                        |  8 -----
 include/net/sctp/checksum.h                   |  3 --
 sound/soc/codecs/aw88395/aw88395_device.c     |  2 +-
 11 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/crypto/crc32c_generic.c b/crypto/crc32c_generic.c
index 985da981d6e2a..770533d19b813 100644
--- a/crypto/crc32c_generic.c
+++ b/crypto/crc32c_generic.c
@@ -92,11 +92,11 @@ static int chksum_update(struct shash_desc *desc, const u8 *data,
 static int chksum_update_arch(struct shash_desc *desc, const u8 *data,
 			      unsigned int length)
 {
 	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
 
-	ctx->crc = __crc32c_le(ctx->crc, data, length);
+	ctx->crc = crc32c(ctx->crc, data, length);
 	return 0;
 }
 
 static int chksum_final(struct shash_desc *desc, u8 *out)
 {
@@ -113,11 +113,11 @@ static int __chksum_finup(u32 *crcp, const u8 *data, unsigned int len, u8 *out)
 }
 
 static int __chksum_finup_arch(u32 *crcp, const u8 *data, unsigned int len,
 			       u8 *out)
 {
-	put_unaligned_le32(~__crc32c_le(*crcp, data, len), out);
+	put_unaligned_le32(~crc32c(*crcp, data, len), out);
 	return 0;
 }
 
 static int chksum_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *out)
diff --git a/drivers/crypto/stm32/stm32-crc32.c b/drivers/crypto/stm32/stm32-crc32.c
index de4d0402f1339..fd29785a3ecf3 100644
--- a/drivers/crypto/stm32/stm32-crc32.c
+++ b/drivers/crypto/stm32/stm32-crc32.c
@@ -160,11 +160,11 @@ static int burst_update(struct shash_desc *desc, const u8 *d8,
 	if (!spin_trylock(&crc->lock)) {
 		/* Hardware is busy, calculate crc32 by software */
 		if (mctx->poly == CRC32_POLY_LE)
 			ctx->partial = crc32_le(ctx->partial, d8, length);
 		else
-			ctx->partial = __crc32c_le(ctx->partial, d8, length);
+			ctx->partial = crc32c(ctx->partial, d8, length);
 
 		goto pm_out;
 	}
 
 	/*
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index e530271cb86bb..ba768ca7f4229 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -712,11 +712,11 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	if (!io)
 		return;
 
 	block = page_address(io->meta_page);
 	block->meta_size = cpu_to_le32(io->meta_offset);
-	crc = crc32c_le(log->uuid_checksum, block, PAGE_SIZE);
+	crc = crc32c(log->uuid_checksum, block, PAGE_SIZE);
 	block->checksum = cpu_to_le32(crc);
 
 	log->current_io = NULL;
 	spin_lock_irqsave(&log->io_list_lock, flags);
 	if (io->has_flush || io->has_fua) {
@@ -1018,12 +1018,12 @@ int r5l_write_stripe(struct r5l_log *log, struct stripe_head *sh)
 		write_disks++;
 		/* checksum is already calculated in last run */
 		if (test_bit(STRIPE_LOG_TRAPPED, &sh->state))
 			continue;
 		addr = kmap_local_page(sh->dev[i].page);
-		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
-						    addr, PAGE_SIZE);
+		sh->dev[i].log_checksum = crc32c(log->uuid_checksum,
+						 addr, PAGE_SIZE);
 		kunmap_local(addr);
 	}
 	parity_pages = 1 + !!(sh->qd_idx >= 0);
 	data_pages = write_disks - parity_pages;
 
@@ -1739,11 +1739,11 @@ static int r5l_recovery_read_meta_block(struct r5l_log *log,
 	    le64_to_cpu(mb->seq) != ctx->seq ||
 	    mb->version != R5LOG_VERSION ||
 	    le64_to_cpu(mb->position) != ctx->pos)
 		return -EINVAL;
 
-	crc = crc32c_le(log->uuid_checksum, mb, PAGE_SIZE);
+	crc = crc32c(log->uuid_checksum, mb, PAGE_SIZE);
 	if (stored_crc != crc)
 		return -EINVAL;
 
 	if (le32_to_cpu(mb->meta_size) > PAGE_SIZE)
 		return -EINVAL;
@@ -1778,12 +1778,11 @@ static int r5l_log_write_empty_meta_block(struct r5l_log *log, sector_t pos,
 	page = alloc_page(GFP_KERNEL);
 	if (!page)
 		return -ENOMEM;
 	r5l_recovery_create_empty_meta_block(log, page, pos, seq);
 	mb = page_address(page);
-	mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
-					     mb, PAGE_SIZE));
+	mb->checksum = cpu_to_le32(crc32c(log->uuid_checksum, mb, PAGE_SIZE));
 	if (!sync_page_io(log->rdev, pos, PAGE_SIZE, page, REQ_OP_WRITE |
 			  REQ_SYNC | REQ_FUA, false)) {
 		__free_page(page);
 		return -EIO;
 	}
@@ -1974,11 +1973,11 @@ r5l_recovery_verify_data_checksum(struct r5l_log *log,
 	void *addr;
 	u32 checksum;
 
 	r5l_recovery_read_page(log, ctx, page, log_offset);
 	addr = kmap_local_page(page);
-	checksum = crc32c_le(log->uuid_checksum, addr, PAGE_SIZE);
+	checksum = crc32c(log->uuid_checksum, addr, PAGE_SIZE);
 	kunmap_local(addr);
 	return (le32_to_cpu(log_checksum) == checksum) ? 0 : -EINVAL;
 }
 
 /*
@@ -2377,12 +2376,12 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 				payload->size = cpu_to_le32(BLOCK_SECTORS);
 				payload->location = cpu_to_le64(
 					raid5_compute_blocknr(sh, i, 0));
 				addr = kmap_local_page(dev->page);
 				payload->checksum[0] = cpu_to_le32(
-					crc32c_le(log->uuid_checksum, addr,
-						  PAGE_SIZE));
+					crc32c(log->uuid_checksum, addr,
+					       PAGE_SIZE));
 				kunmap_local(addr);
 				sync_page_io(log->rdev, write_pos, PAGE_SIZE,
 					     dev->page, REQ_OP_WRITE, false);
 				write_pos = r5l_ring_add(log, write_pos,
 							 BLOCK_SECTORS);
@@ -2390,12 +2389,12 @@ r5c_recovery_rewrite_data_only_stripes(struct r5l_log *log,
 					sizeof(struct r5l_payload_data_parity);
 
 			}
 		}
 		mb->meta_size = cpu_to_le32(offset);
-		mb->checksum = cpu_to_le32(crc32c_le(log->uuid_checksum,
-						     mb, PAGE_SIZE));
+		mb->checksum = cpu_to_le32(crc32c(log->uuid_checksum,
+						  mb, PAGE_SIZE));
 		sync_page_io(log->rdev, ctx->pos, PAGE_SIZE, page,
 			     REQ_OP_WRITE | REQ_SYNC | REQ_FUA, false);
 		sh->log_start = ctx->pos;
 		list_add_tail(&sh->r5c, &log->stripe_in_journal_list);
 		atomic_inc(&log->stripe_in_journal_count);
@@ -2883,12 +2882,12 @@ int r5c_cache_data(struct r5l_log *log, struct stripe_head *sh)
 		void *addr;
 
 		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
 			continue;
 		addr = kmap_local_page(sh->dev[i].page);
-		sh->dev[i].log_checksum = crc32c_le(log->uuid_checksum,
-						    addr, PAGE_SIZE);
+		sh->dev[i].log_checksum = crc32c(log->uuid_checksum,
+						 addr, PAGE_SIZE);
 		kunmap_local(addr);
 		pages++;
 	}
 	WARN_ON(pages == 0);
 
@@ -2967,11 +2966,11 @@ static int r5l_load_log(struct r5l_log *log)
 		create_super = true;
 		goto create;
 	}
 	stored_crc = le32_to_cpu(mb->checksum);
 	mb->checksum = 0;
-	expected_crc = crc32c_le(log->uuid_checksum, mb, PAGE_SIZE);
+	expected_crc = crc32c(log->uuid_checksum, mb, PAGE_SIZE);
 	if (stored_crc != expected_crc) {
 		create_super = true;
 		goto create;
 	}
 	if (le64_to_cpu(mb->position) != cp) {
@@ -3075,12 +3074,12 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	log = kzalloc(sizeof(*log), GFP_KERNEL);
 	if (!log)
 		return -ENOMEM;
 	log->rdev = rdev;
 	log->need_cache_flush = bdev_write_cache(rdev->bdev);
-	log->uuid_checksum = crc32c_le(~0, rdev->mddev->uuid,
-				       sizeof(rdev->mddev->uuid));
+	log->uuid_checksum = crc32c(~0, rdev->mddev->uuid,
+				    sizeof(rdev->mddev->uuid));
 
 	mutex_init(&log->io_mutex);
 
 	spin_lock_init(&log->io_list_lock);
 	INIT_LIST_HEAD(&log->running_ios);
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index 37c4da5311ca7..c0fb335311aa6 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -344,13 +344,13 @@ static int ppl_log_stripe(struct ppl_log *log, struct stripe_head *sh)
 
 	/* don't write any PP if full stripe write */
 	if (!test_bit(STRIPE_FULL_WRITE, &sh->state)) {
 		le32_add_cpu(&e->pp_size, PAGE_SIZE);
 		io->pp_size += PAGE_SIZE;
-		e->checksum = cpu_to_le32(crc32c_le(le32_to_cpu(e->checksum),
-						    page_address(sh->ppl_page),
-						    PAGE_SIZE));
+		e->checksum = cpu_to_le32(crc32c(le32_to_cpu(e->checksum),
+						 page_address(sh->ppl_page),
+						 PAGE_SIZE));
 	}
 
 	list_add_tail(&sh->log_list, &io->stripe_list);
 	atomic_inc(&io->pending_stripes);
 	sh->ppl_io = io;
@@ -452,11 +452,11 @@ static void ppl_submit_iounit(struct ppl_io_unit *io)
 					     ilog2(ppl_conf->block_size >> 9));
 		e->checksum = cpu_to_le32(~le32_to_cpu(e->checksum));
 	}
 
 	pplhdr->entries_count = cpu_to_le32(io->entries_count);
-	pplhdr->checksum = cpu_to_le32(~crc32c_le(~0, pplhdr, PPL_HEADER_SIZE));
+	pplhdr->checksum = cpu_to_le32(~crc32c(~0, pplhdr, PPL_HEADER_SIZE));
 
 	/* Rewind the buffer if current PPL is larger then remaining space */
 	if (log->use_multippl &&
 	    log->rdev->ppl.sector + log->rdev->ppl.size - log->next_io_sector <
 	    (PPL_HEADER_SIZE + io->pp_size) >> 9)
@@ -996,11 +996,11 @@ static int ppl_recover(struct ppl_log *log, struct ppl_header *pplhdr,
 				md_error(mddev, rdev);
 				ret = -EIO;
 				goto out;
 			}
 
-			crc = crc32c_le(crc, page_address(page), s);
+			crc = crc32c(crc, page_address(page), s);
 
 			pp_size -= s;
 			sector += s >> 9;
 		}
 
@@ -1050,11 +1050,11 @@ static int ppl_write_empty_header(struct ppl_log *log)
 	/* zero out PPL space to avoid collision with old PPLs */
 	blkdev_issue_zeroout(rdev->bdev, rdev->ppl.sector,
 			    log->rdev->ppl.size, GFP_NOIO, 0);
 	memset(pplhdr->reserved, 0xff, PPL_HDR_RESERVED);
 	pplhdr->signature = cpu_to_le32(log->ppl_conf->signature);
-	pplhdr->checksum = cpu_to_le32(~crc32c_le(~0, pplhdr, PAGE_SIZE));
+	pplhdr->checksum = cpu_to_le32(~crc32c(~0, pplhdr, PAGE_SIZE));
 
 	if (!sync_page_io(rdev, rdev->ppl.sector - rdev->data_offset,
 			  PPL_HEADER_SIZE, page, REQ_OP_WRITE | REQ_SYNC |
 			  REQ_FUA, false)) {
 		md_error(rdev->mddev, rdev);
@@ -1104,11 +1104,11 @@ static int ppl_load_distributed(struct ppl_log *log)
 		pplhdr = page_address(page);
 
 		/* check header validity */
 		crc_stored = le32_to_cpu(pplhdr->checksum);
 		pplhdr->checksum = 0;
-		crc = ~crc32c_le(~0, pplhdr, PAGE_SIZE);
+		crc = ~crc32c(~0, pplhdr, PAGE_SIZE);
 
 		if (crc_stored != crc) {
 			pr_debug("%s: ppl header crc does not match: stored: 0x%x calculated: 0x%x (offset: %llu)\n",
 				 __func__, crc_stored, crc,
 				 (unsigned long long)pplhdr_offset);
@@ -1388,11 +1388,11 @@ int ppl_init_log(struct r5conf *conf)
 	atomic64_set(&ppl_conf->seq, 0);
 	INIT_LIST_HEAD(&ppl_conf->no_mem_stripes);
 	spin_lock_init(&ppl_conf->no_mem_stripes_lock);
 
 	if (!mddev->external) {
-		ppl_conf->signature = ~crc32c_le(~0, mddev->uuid, sizeof(mddev->uuid));
+		ppl_conf->signature = ~crc32c(~0, mddev->uuid, sizeof(mddev->uuid));
 		ppl_conf->block_size = 512;
 	} else {
 		ppl_conf->block_size =
 			queue_logical_block_size(mddev->gendisk->queue);
 	}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
index 8e04552d2216c..02c8213915a5d 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c
@@ -2591,11 +2591,11 @@ void bnx2x_init_rx_mode_obj(struct bnx2x *bp,
 }
 
 /********************* Multicast verbs: SET, CLEAR ****************************/
 static inline u8 bnx2x_mcast_bin_from_mac(u8 *mac)
 {
-	return (crc32c_le(0, mac, ETH_ALEN) >> 24) & 0xff;
+	return (crc32c(0, mac, ETH_ALEN) >> 24) & 0xff;
 }
 
 struct bnx2x_mcast_mac_elem {
 	struct list_head link;
 	u8 mac[ETH_ALEN];
diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index dc1f456736dc4..cd15e84c47f47 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -310,11 +310,11 @@ static void tb_cfg_print_error(struct tb_ctl *ctl, enum tb_cfg_space space,
 	}
 }
 
 static __be32 tb_crc(const void *data, size_t len)
 {
-	return cpu_to_be32(~__crc32c_le(~0, data, len));
+	return cpu_to_be32(~crc32c(~0, data, len));
 }
 
 static void tb_ctl_pkg_free(struct ctl_pkg *pkg)
 {
 	if (pkg) {
diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
index 9c1d65d265531..e66183a72cf94 100644
--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -209,11 +209,11 @@ static u8 tb_crc8(u8 *data, int len)
 	return val;
 }
 
 static u32 tb_crc32(void *data, size_t len)
 {
-	return ~__crc32c_le(~0, data, len);
+	return ~crc32c(~0, data, len);
 }
 
 #define TB_DROM_DATA_START		13
 #define TB_DROM_HEADER_SIZE		22
 #define USB4_DROM_HEADER_SIZE		16
diff --git a/include/linux/crc32.h b/include/linux/crc32.h
index 61a7ec29d6338..bc39b023eac0f 100644
--- a/include/linux/crc32.h
+++ b/include/linux/crc32.h
@@ -27,12 +27,11 @@ static inline u32 crc32_be(u32 crc, const void *p, size_t len)
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32_be_arch(crc, p, len);
 	return crc32_be_base(crc, p, len);
 }
 
-/* TODO: leading underscores should be dropped once callers have been updated */
-static inline u32 __crc32c_le(u32 crc, const void *p, size_t len)
+static inline u32 crc32c(u32 crc, const void *p, size_t len)
 {
 	if (IS_ENABLED(CONFIG_CRC32_ARCH))
 		return crc32c_le_arch(crc, p, len);
 	return crc32c_le_base(crc, p, len);
 }
@@ -43,11 +42,11 @@ static inline u32 __crc32c_le(u32 crc, const void *p, size_t len)
  * IS_ENABLED(CONFIG_CRC32_ARCH) it takes into account the different CRC32
  * variants and also whether any needed CPU features are available at runtime.
  */
 #define CRC32_LE_OPTIMIZATION	BIT(0) /* crc32_le() is optimized */
 #define CRC32_BE_OPTIMIZATION	BIT(1) /* crc32_be() is optimized */
-#define CRC32C_OPTIMIZATION	BIT(2) /* __crc32c_le() is optimized */
+#define CRC32C_OPTIMIZATION	BIT(2) /* crc32c() is optimized */
 #if IS_ENABLED(CONFIG_CRC32_ARCH)
 u32 crc32_optimizations(void);
 #else
 static inline u32 crc32_optimizations(void) { return 0; }
 #endif
diff --git a/include/linux/crc32c.h b/include/linux/crc32c.h
index 47eb78003c265..b8cff2f4309a7 100644
--- a/include/linux/crc32c.h
+++ b/include/linux/crc32c.h
@@ -2,14 +2,6 @@
 #ifndef _LINUX_CRC32C_H
 #define _LINUX_CRC32C_H
 
 #include <linux/crc32.h>
 
-static inline u32 crc32c(u32 crc, const void *address, unsigned int length)
-{
-	return __crc32c_le(crc, address, length);
-}
-
-/* This macro exists for backwards-compatibility. */
-#define crc32c_le crc32c
-
 #endif	/* _LINUX_CRC32C_H */
diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
index f514a0aa849ea..93041c970753e 100644
--- a/include/net/sctp/checksum.h
+++ b/include/net/sctp/checksum.h
@@ -28,13 +28,10 @@
 #include <linux/crc32c.h>
 #include <linux/crc32.h>
 
 static inline __wsum sctp_csum_update(const void *buff, int len, __wsum sum)
 {
-	/* This uses the crypto implementation of crc32c, which is either
-	 * implemented w/ hardware support or resolves to __crc32c_le().
-	 */
 	return (__force __wsum)crc32c((__force __u32)sum, buff, len);
 }
 
 static inline __wsum sctp_csum_combine(__wsum csum, __wsum csum2,
 				       int offset, int len)
diff --git a/sound/soc/codecs/aw88395/aw88395_device.c b/sound/soc/codecs/aw88395/aw88395_device.c
index 6b333d1c6e946..b7ea8be0d0cb0 100644
--- a/sound/soc/codecs/aw88395/aw88395_device.c
+++ b/sound/soc/codecs/aw88395/aw88395_device.c
@@ -422,11 +422,11 @@ static int aw_dev_dsp_set_crc32(struct aw_device *aw_dev)
 	if (crc_data_len & 0x11) {
 		dev_err(aw_dev->dev, "The crc data len :%d unsupport", crc_data_len);
 		return -EINVAL;
 	}
 
-	crc_value = __crc32c_le(0xFFFFFFFF, crc_dsp_cfg->data, crc_data_len) ^ 0xFFFFFFFF;
+	crc_value = crc32c(0xFFFFFFFF, crc_dsp_cfg->data, crc_data_len) ^ 0xFFFFFFFF;
 
 	return aw_dev_dsp_write(aw_dev, AW88395_DSP_REG_CRC_ADDR, crc_value,
 						AW88395_DSP_32_DATA);
 }
 
-- 
2.48.1

