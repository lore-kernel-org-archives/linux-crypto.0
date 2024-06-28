Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CF91CB328;
	Fri, 28 Jun 2024 16:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719591309; cv=none; b=Gz5QyD/aseiTgUxWORusuXlS0+3ieBTiDilXbnrNdonQ9pdIPMt2yhiy6FxxSKIOyApU9xcX+NEaigv/JIETIU0hd+4XcvZ6f3y0is3kyIxZgmRIf4QfzRkTePhZ7DBxSdjCiX4mM80Y25xIh2d8/xMCeMM46hBqCkqZ0LqL080=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719591309; c=relaxed/simple;
	bh=Q0WHX/k+II+4DpP6gjTskybbhsbGDjvylwIZU4HVzY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chDgUIDCMD8KmzFmJDBkzZu0TSgYpDgwrV0zBxOHdIqte3w7R3kAO/bPg9JaZToPeD6bDBNcN3z3WsKoI5vboO0uYVBRndooDgvABivHVNUnoXjXRvx+zD0W93oTqcc3lcwcJ2aqZBdHaAhhjdVQUUUZmeTAr9tc0o/JvgQdeG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57d457357easo1077204a12.3;
        Fri, 28 Jun 2024 09:15:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719591306; x=1720196106;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=brMkMU/fZcXWQgZzq2O4Dlt1a9kFaqQkd7w5U8F00Jk=;
        b=sjA8AB0BGBq53YLULjziEhmXvAlp5JC1NIIa0VBZEdICSvfFy6zGzLxQbGnH3Xq/Q8
         p5KpfTNEgyIc8FDQodWJ+clm6OL0KU17L0tI2MlqLvb+do66U2OJoLk58gs39rVIo/lM
         JIrOabjd9Gj75dqASJWu9wghGXYTXseYgayVaryTsl0HpNg3G1QWyKgYAH04LsNubDeG
         sAHf9CiQ8jsP0YdfOgcjlsJj4Ghre7Z4kHDDAn4EdjZxuzZ1JLR+FFcW8AcOeGT2lYjZ
         nu5E9oaIPL76HCKsa98d41mszvxyNTAzNbQwTeDtxq6wuSN3KnuIGwgTuzvMCWoWfwho
         lOoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJ+ok/kNUNnyCoxLE6PwVwQpJx+JBJRZsn+SvaLUmd96FZFrAt6mStmgxrHVdhOg+x9UC5jF3QJbRVBX12hIv0u2w5DA29qILffIWd/L/PEslgq2FGqParVfvaWkh2Jun4aRfUs9pNHAA+SM43r10dgsMeZY8rqtBOE2LcTquzOHni
X-Gm-Message-State: AOJu0YyREh2NK8CP5Bgu7CLLmldyI0ptwwkniC+t7Aizjaar6YDReRT9
	4USsqkocRQQQf3cqF01/6mhG02+ZQqfpzDS+8wZRokgy5OGHl2Rr
X-Google-Smtp-Source: AGHT+IFH+V/F78x9fIeQDTsAtVmbSTTECS2cp13Sw3MkRqSbSXT5cF21bdM8c2wrXKkxU0QVckiU7Q==
X-Received: by 2002:a50:d548:0:b0:57c:5764:15f1 with SMTP id 4fb4d7f45d1cf-57d4bdcb7dbmr10014253a12.29.1719591306126;
        Fri, 28 Jun 2024 09:15:06 -0700 (PDT)
Received: from localhost (fwdproxy-lla-009.fbsv.net. [2a03:2880:30ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-586137218b8sm1225013a12.41.2024.06.28.09.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 09:15:05 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: kuba@kernel.org,
	horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: horms@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 2/3] crypto: caam: Unembed net_dev structure from qi
Date: Fri, 28 Jun 2024 09:14:47 -0700
Message-ID: <20240628161450.2541367-3-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240628161450.2541367-1-leitao@debian.org>
References: <20240628161450.2541367-1-leitao@debian.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Embedding net_device into structures prohibits the usage of flexible
arrays in the net_device structure. For more details, see the discussion
at [1].

Un-embed the net_devices from struct caam_qi_pcpu_priv by converting them
into pointers, and allocating them dynamically. Use the leverage
alloc_netdev_dummy() to allocate the net_device object at
caam_qi_init().

The free of the device occurs at caam_qi_shutdown().

Link: https://lore.kernel.org/all/20240229225910.79e224cf@kernel.org/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 drivers/crypto/caam/qi.c | 43 ++++++++++++++++++++++++++++++++--------
 1 file changed, 35 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index 46a083849a8e..0c13ffc81862 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -57,7 +57,7 @@ struct caam_napi {
  */
 struct caam_qi_pcpu_priv {
 	struct caam_napi caam_napi;
-	struct net_device net_dev;
+	struct net_device *net_dev;
 	struct qman_fq *rsp_fq;
 } ____cacheline_aligned;
 
@@ -144,7 +144,7 @@ static void caam_fq_ern_cb(struct qman_portal *qm, struct qman_fq *fq,
 {
 	const struct qm_fd *fd;
 	struct caam_drv_req *drv_req;
-	struct device *qidev = &(raw_cpu_ptr(&pcpu_qipriv)->net_dev.dev);
+	struct device *qidev = &(raw_cpu_ptr(&pcpu_qipriv)->net_dev->dev);
 	struct caam_drv_private *priv = dev_get_drvdata(qidev);
 
 	fd = &msg->ern.fd;
@@ -530,6 +530,7 @@ static void caam_qi_shutdown(void *data)
 
 		if (kill_fq(qidev, per_cpu(pcpu_qipriv.rsp_fq, i)))
 			dev_err(qidev, "Rsp FQ kill failed, cpu: %d\n", i);
+		free_netdev(pcpu_qipriv.net_dev);
 	}
 
 	qman_delete_cgr_safe(&priv->cgr);
@@ -573,7 +574,7 @@ static enum qman_cb_dqrr_result caam_rsp_fq_dqrr_cb(struct qman_portal *p,
 	struct caam_napi *caam_napi = raw_cpu_ptr(&pcpu_qipriv.caam_napi);
 	struct caam_drv_req *drv_req;
 	const struct qm_fd *fd;
-	struct device *qidev = &(raw_cpu_ptr(&pcpu_qipriv)->net_dev.dev);
+	struct device *qidev = &(raw_cpu_ptr(&pcpu_qipriv)->net_dev->dev);
 	struct caam_drv_private *priv = dev_get_drvdata(qidev);
 	u32 status;
 
@@ -718,12 +719,24 @@ static void free_rsp_fqs(void)
 		kfree(per_cpu(pcpu_qipriv.rsp_fq, i));
 }
 
+static void free_caam_qi_pcpu_netdev(const cpumask_t *cpus)
+{
+	struct caam_qi_pcpu_priv *priv;
+	int i;
+
+	for_each_cpu(i, cpus) {
+		priv = per_cpu_ptr(&pcpu_qipriv, i);
+		free_netdev(priv->net_dev);
+	}
+}
+
 int caam_qi_init(struct platform_device *caam_pdev)
 {
 	int err, i;
 	struct device *ctrldev = &caam_pdev->dev, *qidev;
 	struct caam_drv_private *ctrlpriv;
 	const cpumask_t *cpus = qman_affine_cpus();
+	cpumask_t clean_mask;
 
 	ctrlpriv = dev_get_drvdata(ctrldev);
 	qidev = ctrldev;
@@ -743,6 +756,8 @@ int caam_qi_init(struct platform_device *caam_pdev)
 		return err;
 	}
 
+	cpumask_clear(&clean_mask);
+
 	/*
 	 * Enable the NAPI contexts on each of the core which has an affine
 	 * portal.
@@ -751,10 +766,16 @@ int caam_qi_init(struct platform_device *caam_pdev)
 		struct caam_qi_pcpu_priv *priv = per_cpu_ptr(&pcpu_qipriv, i);
 		struct caam_napi *caam_napi = &priv->caam_napi;
 		struct napi_struct *irqtask = &caam_napi->irqtask;
-		struct net_device *net_dev = &priv->net_dev;
+		struct net_device *net_dev;
 
+		net_dev = alloc_netdev_dummy(0);
+		if (!net_dev) {
+			err = -ENOMEM;
+			goto fail;
+		}
+		cpumask_set_cpu(i, &clean_mask);
+		priv->net_dev = net_dev;
 		net_dev->dev = *qidev;
-		INIT_LIST_HEAD(&net_dev->napi_list);
 
 		netif_napi_add_tx_weight(net_dev, irqtask, caam_qi_poll,
 					 CAAM_NAPI_WEIGHT);
@@ -766,16 +787,22 @@ int caam_qi_init(struct platform_device *caam_pdev)
 				     dma_get_cache_alignment(), 0, NULL);
 	if (!qi_cache) {
 		dev_err(qidev, "Can't allocate CAAM cache\n");
-		free_rsp_fqs();
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto fail2;
 	}
 
 	caam_debugfs_qi_init(ctrlpriv);
 
 	err = devm_add_action_or_reset(qidev, caam_qi_shutdown, ctrlpriv);
 	if (err)
-		return err;
+		goto fail2;
 
 	dev_info(qidev, "Linux CAAM Queue I/F driver initialised\n");
 	return 0;
+
+fail2:
+	free_rsp_fqs();
+fail:
+	free_caam_qi_pcpu_netdev(&clean_mask);
+	return err;
 }
-- 
2.43.0

