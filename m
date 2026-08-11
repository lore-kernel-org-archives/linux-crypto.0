Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE762FBDE0
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 04:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786423663; cv=none; b=eswpM4Glk+11KDUnF13ROj4iBcTqoru/rsM9QX7dTOyDuoKbEs2P7z61K1Z/jV1OpGPtkzAb1/UfWbyOf7CDJo8Ss61M0fjApLIqMOPh3h6k9GOjakRSV5xbDKooVI28Mqwk2DRrd+hbE16+NIEmsD27gy62JoQYGQSc5LdpCRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786423663; c=relaxed/simple;
	bh=5Z0oAUxEu5WEOb0dsLBPx4r248ISJ+rPQrMc9DRkcgY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y1xmh+ivjfe4bZyZHNWL53hnTGQJRglVkvonUpANd9PJW/RIJ+6fwoY0dXswRQXS5vHvVtJ6nt45IlufxfzKHRCfF/dGT2p0q0EKZiOW4jRoXmc5orRx3eYCUGQHmUo8dQM4awEMf8BhhYO0sJV/nBPUEtqXfMMWcyjZxwqndwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YfSL6dwx; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YfSL6dwx"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3900e39d935so2647931a91.0
        for <linux-crypto@vger.kernel.org>; Mon, 10 Aug 2026 21:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786423660; x=1787028460; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TG1xomO85u+aFoUYBWNHKdAe0OaR11ngRHj1PJcG3LI=;
        b=YfSL6dwxpGKDiEMvX1tzu0R4CdKTq4lSx4Lfr5g7yo/VjfM7b+h04uswHYGb81Nx0u
         rZyTnDY0VQRc9LAyrUctruqc0gYclLwBaKfdmX5rq0X5p2txyKGK5eNEBFyAd2kfacns
         OzFub3nG1CSXEenBda7XpWinBTa2bQ48EzpF05mIUxeDTpsOYjlKDpnnpfRo672PQvaQ
         ADWLpjpN17U5eRowY1OlBmCjWjuScRSlOB7rtKwW+2ltViAwL5yZzcIZkPOZh9jNJ0pA
         QS8OBfBTDagPwHu5Epo6c9vUdJ5Bp0FO53srsTjz3E0ASJp1gboK+AShcg0wnqSZfH2q
         Wn+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786423660; x=1787028460;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TG1xomO85u+aFoUYBWNHKdAe0OaR11ngRHj1PJcG3LI=;
        b=r5tk8MXA9SLJTqP9IXhdfOg5N5TSxWS6K5oCMjzzpfeUl07T6lR/2tkZJb73gB+BB6
         j4B3AS0RIC4Ul8Rhc5phryr+oMzCKunvCCHwmvA6h8ZsHokqPcCWH/WFSpx4TAo8Be7B
         riSSkrRUjrDZR06C53Md7lTvVqt4eUcqW2vR2qV2BjcGhubHy1FsKyTmHnnGZOsYn3Ii
         pHE8vtiEJq4OeRGPB8lwGbIPESm8ysF5HfAWdMe4KdsKBged03MLZZsLqoMEAqJcJfvb
         YnZKcgrzAixsI1u4KcQ0TxnTiTMjrK83lU3YjLkcYcwp20OSprwzniZo3YiNGWwZwpDp
         fUrA==
X-Gm-Message-State: AOJu0Yyml5JVIJjBCfU7FoxkhVizqzqlC4fWl1qhEN1toyJh3nIxycG7
	GPuoFNqlxQwYyqDzowCRxtt09CNpqHZvOoFxt6VpQLuasv7NQXlO2opfqMZW4g==
X-Gm-Gg: AR+sD10msYq6e0klTzdTDmdeSXEUP5B6OfqkATfysA4FdL8etPSbN7SS5MEANBJqq99
	fEBk+xfYwwEh3T6gomcel0L2tCi5w1JJ5El3RriGYw/Q2cIBBsTjX91Cymbk4HtWUuPF0uNrUn3
	SfWKD5ledGNQ3hfUnTRN8V1YtHZk+timULmn1ijVeWbMnXOJsuZJRdckdzFGxBVof8iVpUr2xYQ
	CXL/FWlH7Y7KYYX9xeW9YPFRrhJJS0oHtY6C5GMmI7mjXW0NR6nzf8K8FB7vCzzrGEY76uCxWcH
	kiAStMARmO8tTYC8QVxNg4i+xZ1yt+EPE8/OaKmu51MlJul+ROxJs5a26e/EkHWDZueIgeR5IgI
	UAnErPF+EasrNxje0BDZLrXufIkUHLHcY7KeXzHZsxQ4VLZNvflPSwC2oyJWcGOhM9N/SsKU/Lw
	FNZijX8fCHGmaqy+bXHMkJT8ve/Yy6Ub/mon6+Mqo+5+Dxvb4wxolYS/u5lQe3vNWzJWX9WD+DJ
	tSZ/wBmTPOlJKwN/tAzHauL20kYoMio5F5/Lwnos8AbaaZt4sIu6MtT7TwqhQo/IcwUottQQx3l
	Xp+Bw3wan4b6Q8RVzup05185hH0R0u2rVQe0gA==
X-Received: by 2002:a17:90b:2dca:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-392ec34642fmr719027a91.7.1786423660262;
        Mon, 10 Aug 2026 21:47:40 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392d537d905sm1864029a91.14.2026.08.10.21.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 21:47:39 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: amcc - fix missing DMA memory barriers in descriptor handling
Date: Mon, 10 Aug 2026 21:47:38 -0700
Message-ID: <20260811044738.160653-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix two memory ordering bugs in the AMCC crypto driver:

1. In crypto4xx_bh_tasklet_cb(), add a dma_rmb() between reading the
   PD_CTL_PE_DONE bit (with READ_ONCE) and reading the descriptor and DMA
   buffer data in crypto4xx_pd_done().  Without it, the CPU on a
   weakly-ordered architecture could read stale descriptor data before the
   hardware's writes are globally visible.

2. In crypto4xx_build_pd(), add a dma_wmb() before writing
   PD_CTL_HOST_READY to ensure all descriptor and SA data is visible to
   the device before the ownership handover bit.  Also fix the descriptor
   field ordering: pd_ctl_len.w must be written before pd_ctl.w (which
   contains HOST_READY), not after, to prevent the hardware from fetching
   uninitialized length data.

Fixes: f6c48b76daa6 (crypto: amcc - Add crypto4xx-aead cryptographic
  AEAD accelerator driver)
Cc: stable@vger.kernel.org
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: add descriptions for write barriers.
 drivers/crypto/amcc/crypto4xx_core.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index fd010bfb7020..4b0ce165c198 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -876,11 +876,17 @@ int crypto4xx_build_pd(struct crypto_async_request *req,
 		}
 	}
 
+	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
+	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
+
+	/* make the pd_ctl_len and pd_uinfo->state writes above visible to
+	 * the device before the HOST_READY handover write below, so the
+	 * device never fetches a descriptor with stale length/state bits
+	 */
+	dma_wmb();
 	pd->pd_ctl.w = PD_CTL_HOST_READY |
 		((crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
 			PD_CTL_HASH_FINAL : 0);
-	pd->pd_ctl_len.w = 0x00400000 | (assoclen + datalen);
-	pd_uinfo->state = PD_ENTRY_INUSE | (is_busy ? PD_ENTRY_BUSY : 0);
 
 	wmb();
 	/* write any value to push engine to read a pd */
@@ -1031,6 +1037,11 @@ static void crypto4xx_bh_tasklet_cb(unsigned long data)
 		     ((READ_ONCE(pd->pd_ctl.w) &
 		       (PD_CTL_PE_DONE | PD_CTL_HOST_READY)) ==
 		       PD_CTL_PE_DONE)) {
+			/* order the PE_DONE flag read above before reading
+			 * the descriptor status and output data written by
+			 * the device
+			 */
+			dma_rmb();
 			crypto4xx_pd_done(core_dev->dev, tail);
 			tail = crypto4xx_put_pd_to_pdr(core_dev->dev, tail);
 		} else {
-- 
2.55.0

