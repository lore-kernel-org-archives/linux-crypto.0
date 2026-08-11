Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F168A42467C
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 21:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786483236; cv=none; b=i8bI+vxWTJsywaTbjERDbd83go1RvN4VOLdywrBLxp7ei12YAs3oWB2wjexoZb8LqhaDHOXJdVnUM1wRBUJXPOicL2Kl7gTrdBBO5KFuv3BilBmt8htLe2oEzLgYYp4AoPKzuy4INUMvuAfeHA+X5oYF9OqMvcxkhgGPAnGd/Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786483236; c=relaxed/simple;
	bh=y4Dlb8ww/ed8rWZEaIPfqD2tENd23+yx1DjCsHqI+so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjz/1xeU6EeF4LQ41S75vRozT4nfhQMV5uio0OGU9HUHPu4/Fr+e1JxozfxUUt8Y7tN9dE4BfME2pjprkECKcaAIFJd9QgbDwVwPitKb4oupzjx1ApBCdxVGLb85OVYewvi/Mn3ufcUgceFCWSN78M7eEIn2sDyclz09s9MOjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=r7dZHyaJ; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r7dZHyaJ"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2caf228a910so3130485ad.2
        for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 14:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786483234; x=1787088034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TTlAMEE9ZBs5bbNdSTHaN1m7xGP9tQTBD2X4N04RR5g=;
        b=r7dZHyaJVNEz+/vfgrLK46KDpRZh7cfm/rW1eMIgaTUMfQ8WwnMpB8AE7AwIMvyBQs
         viLcqU0kDQH526/6NClGDFEIe9naUnEpWJ/gSSBqr/jbOZqOMUdd28ASUSmwtHdm/Qy7
         nvqgnLntgDCJwGvsymT/a8v90QZ3ah9pyLyXDdaVdZLhydo/U0pskhYMIeztN3E/o/eW
         zP0ARAUWloFtKhqYieSI8nADlW55PC87wUrQLi+1eL77zTwhf1otyJrtIcg07SDlNetM
         GcMcRthElooKivbzwoC6t89xYWi5BVGd4c5rEYMENe2hU+NstKp1Qy58iopc3FnDVemn
         Pj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786483234; x=1787088034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TTlAMEE9ZBs5bbNdSTHaN1m7xGP9tQTBD2X4N04RR5g=;
        b=Ugxa+0HwjIiNkWSCI1vviFqCroVkt/V+UVHvYtlVLroB5nbQs1Ea4TCNNNasqhtFn8
         cJ9Sq4X3Jllg2vi16JWgE7uFYtlEsYUsI1RH9Xf9L41YV1xd8uUS7JvyLm7x8pVCZr/3
         /DGv7ALTldTer90bgduy9f4nTewZy8q9SVJoc+5jvvR9JWxx9iRCONbsCoMgcfGvia0k
         tBXrvBTvICBrJ1g57uphnHS2R1RKfVJTVpoxwmI8PzXlMjcZQUNW590tFFvATJzcJH7a
         NM+i+YCkfBqBvKOb/ffNcB2Oo9M3GUtC0K7iWDEL5i4AsFtxTaolA9hHPkGfID0HCZxU
         xyig==
X-Gm-Message-State: AOJu0YzYoDtRU91JBZsFhQOLpRdgM+S3UZcrrhmgZ2AXDxGsV/8LWdMv
	4UYdjxO8QRoqqJKPWLtBW8Lj7tJ44foudHsdE6uDSAd33rhkEzQtSLqzQf77RQ==
X-Gm-Gg: AR+sD13V86wbFogbu4pK/SzR46RMR1F7vP68M6Ck6WUfn87n2ZUEQkw4mx3p9XCrlo9
	eOwpn2k+AdZBqCmbt5Um14WWsdYtb7akJVlE+P6xBpmWi85YmQ26THa8GcZh5hWPa/yThGT6h3R
	sDBshaqsWDHDxEwrQQLGNF/7Ruw6wZo+ELVHUpHcDlowr9ozci1NF0lP0rwIQQR3/C73o4EiOmT
	z+HwmuEQNEYDnD/ZakHj+hts2AMgQr/mL/i9yruemVxMU2wlBZn4U0izziYsVNbOxDuNhkx3cMH
	G5m6G6OhMucFUA7CH3r6bHtYXi2DCbDWlhkre6r2caaXI/wN24k0oo91PtwvkDgUZrEBvUM1Byk
	pVMd8rozPaHApZnuNQvax9Lkab5rpyQ7vSotFkkLZXD+BI7KmmqrEvZRys0QCM/lyKL/sjnItf1
	L35lyl7BDQmEKBOcnRlJJwXGNWQ5dqfsAZmVqw/rMvwBIuV3BNH6zTx97rt+s1lRhg9Rwa7FiOy
	2s9PBcJEIOqAKHgJTJ+zjvU1VXRWdoXOSpDXvhdxoBfRr1SnklmlRQ3A730Pu+ubhzV0bKzRI4z
	L47qm4IWhmSKyomeYjo9lLhtXQcmJenDE7fzuw==
X-Received: by 2002:a17:902:fc8f:b0:2ce:e75f:b713 with SMTP id d9443c01a7336-2d3456f5f5cmr5099095ad.23.1786483234249;
        Tue, 11 Aug 2026 14:20:34 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315f2e10dsm12605465ad.23.2026.08.11.14.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 14:20:33 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/2] crypto: img-hash: fix IRQ teardown ordering and fetch clocks early
Date: Tue, 11 Aug 2026 14:20:30 -0700
Message-ID: <20260811212030.20057-3-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260811212030.20057-1-rosenp@gmail.com>
References: <20260811212030.20057-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The IRQ handler schedules tasklets, so free_irq must run before
tasklet_kill in img_hash_remove(). devm_request_irq only freed the
IRQ during devm unwind, after remove() returned, leaving a race in
which the handler could re-schedule a tasklet during teardown.
Replace it with request_irq and free the IRQ explicitly in remove()
and in the probe error path.

Assisted-by: opencode:deepseek-v4-flash-free
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/crypto/img-hash.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index f7265347901c..4153972ec3e7 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -125,6 +125,7 @@ struct img_hash_dev {
 
 	spinlock_t		lock;
 	int			err;
+	int			irq;
 	struct tasklet_struct	done_task;
 	struct tasklet_struct	dma_task;
 
@@ -978,16 +979,16 @@ static int img_hash_probe(struct platform_device *pdev)
 	hdev->bus_addr = hash_res->start;
 	hdev->hash_clk = hash_clk;
 	hdev->sys_clk = sys_clk;
+	hdev->irq = irq;
 
-	err = devm_request_irq(dev, irq, img_irq_handler, 0,
-			       dev_name(dev), hdev);
+	err = request_irq(hdev->irq, img_irq_handler, 0, dev_name(dev), hdev);
 	if (err)
 		goto res_err;
 	dev_dbg(dev, "using IRQ channel %d\n", irq);
 
 	err = img_hash_dma_init(hdev);
 	if (err)
-		goto res_err;
+		goto err_irq;
 
 	dev_dbg(dev, "using %s for DMA transfers\n",
 		dma_chan_name(hdev->dma_lch));
@@ -1008,6 +1009,8 @@ static int img_hash_probe(struct platform_device *pdev)
 	list_del(&hdev->list);
 	spin_unlock(&img_hash.lock);
 	dma_release_channel(hdev->dma_lch);
+err_irq:
+	free_irq(hdev->irq, hdev);
 res_err:
 	tasklet_kill(&hdev->done_task);
 	tasklet_kill(&hdev->dma_task);
@@ -1026,6 +1029,7 @@ static void img_hash_remove(struct platform_device *pdev)
 
 	img_unregister_algs(hdev);
 
+	free_irq(hdev->irq, hdev);
 	tasklet_kill(&hdev->done_task);
 	tasklet_kill(&hdev->dma_task);
 
-- 
2.55.0

