Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EF81CF3CB;
	Tue,  2 Jul 2024 18:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719946619; cv=none; b=FGoRJ38nliNrZSe89vEb4IWnCmTyWUdCpN1GAuQuToXkCb2XDucOGve9tde7yNxX/uTnsgEBdz9XCbKN8e5BrQva9w2Sz9bA2281R6uOCbS5H4sdYS93kWrbXH/8Rm6YkgAGLYaGnEm3ujfSZoorWyEBih2fGZyn7vQR23lvWXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719946619; c=relaxed/simple;
	bh=LewReLZ488nceXVfROCKjjRqr6mgLCSW0OHeBB/hHSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ak7VBnMX5UjX6Y4mBVuJu4IBuOvVV9FGgHB/CXHsTWMqIwuhqBjNHlCA1Sm5d/aDipo+G33bUqcbtcbhEkbHJnBz7/m3tOZK06juxbQv+rH9fztsan17n2co/KdnupTlDittqzfAx/JMGDXI7NSs/ucmVIymlDR+SLZBqFaBnsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a72b3e1c14cso535885766b.1;
        Tue, 02 Jul 2024 11:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719946616; x=1720551416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SKoF4CiVeQZjUAsog/IhvfGsb/vWl4mbiyS3/rCHROE=;
        b=pNzq6ZiTucQdv6VeIN1q//xxZ6EgnrcyB4ndMerzAVAyKwFFOrKmm1L4CGSKczO4it
         zQFozwqHJ+P3xGYpW91DP7jYXFIbaHrpP+PSgy7pbr+QzPC8pUrHanzhUmoT3bfk0QrJ
         Cw3m6iXNrYmtQapyNTdibAxvyGoz5syN5P0UJ1YuS7KfBpkD7Ksjj/9urRYHq2bG3z2A
         BiL3FHQPpCluYjDxO6Dtiyz4MTRDIKkM24uSPzo9F42k8ONHAmkVqL4bKe/pMXDOjeTY
         TzpxsV83IZQNBo/0r7kJU31GBbETsBGXuDgIQ32p9mIhukD0d+RuIfcQ3/+9WoUkXsom
         1UPg==
X-Forwarded-Encrypted: i=1; AJvYcCVsrjDN2f3kaR4TjdLC+ORj7DNFXdSiy9epl8yxv/HSSnPDlXVcuKWq5hqB4ixPQ0A2/KEJSYhhJxua8vDxHQPIa+CGzLxrxc0dwdaFMugPzHfPosaHXrgn7agzMD40bxrnjf7iwXUo7fST1ZQarlxuZCVfTxgCPo27wSdVbTUB8aEy
X-Gm-Message-State: AOJu0YwnWAxpd7bC/shvTgnJA9H69bIJ9Eefp/YhVXN7VpPhzrIoNefx
	Z2ChKRRElOHkRARgCSQ9OK/UT8hPgPHlndjgOQaZLbqIhd/qJcS/WE6U1w==
X-Google-Smtp-Source: AGHT+IEze65jQf7HnZOgqdtG7PyeTgOhJEZRPpZUDwi9ebQf0brT8FCeqOlR9bZHX0qzLiTYp3P1Yw==
X-Received: by 2002:a17:907:9488:b0:a6f:7c8:4fd6 with SMTP id a640c23a62f3a-a75141fb4f8mr873741166b.0.1719946615676;
        Tue, 02 Jul 2024 11:56:55 -0700 (PDT)
Received: from localhost (fwdproxy-lla-001.fbsv.net. [2a03:2880:30ff:1::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72aaf6336csm443042166b.70.2024.07.02.11.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 11:56:55 -0700 (PDT)
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
Subject: [PATCH net-next v3 3/4] crypto: caam: Unembed net_dev structure from qi
Date: Tue,  2 Jul 2024 11:55:53 -0700
Message-ID: <20240702185557.3699991-4-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240702185557.3699991-1-leitao@debian.org>
References: <20240702185557.3699991-1-leitao@debian.org>
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
index 46a083849a8e..ba8fb5d8a7b2 100644
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
+		free_netdev(per_cpu(pcpu_qipriv.net_dev, i));
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

