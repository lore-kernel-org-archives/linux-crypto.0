Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B6119DF75;
	Mon, 24 Jun 2024 16:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719246123; cv=none; b=GZGnFzLjwz6Q9+hh7JfZhLCLetz6aREUxri9zcD6jGhEMDY+EopLb3l6jWMuseYwmhBeblphqWQ+rDD5F1wcDXsuvQq3Ed9zC5ZMkOgE6cmLCepZGGi68NqZ4w9r9lF4HeQglkbkO4I1or/+VEHma738FSZcc0iOf5wcTrLnl0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719246123; c=relaxed/simple;
	bh=Hf1JcrPFGgbliS47DEWpPQTyHuO2Y/8vOtnCS3MUbUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+wibatRBjjHTrUJMyQXVxOSWtcmZT1xjv3wgi4Ww4O/pOLrehfuRYyRQNek/px0qqKRilDbZGnuMEXh598mrue9FFpMJ3oyJljE5+KZ5BGg7+j53b0Hwx0JxdpnD0bAaESzvKuwuH6wBJu/0d/kIjV68DnjNRAam+BzYiF53Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a689ad8d1f6so574145266b.2;
        Mon, 24 Jun 2024 09:22:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719246120; x=1719850920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SNRZatXFYSvT7dWA5Z47QsnQSl5EsRqGGJzSsqaHcYY=;
        b=IWptkYdD+0CFv8tUwlJ4nBr4jDyDW6TU2R536VocCu63ZafH3uck+8XtFHHk8ytCQ8
         LSmjmC3rjjjt29dFkaMeHyOMsV7wkJnxjQCTTiWqTAbkNi6JbU2eizwL3pJ1xtp13TUY
         G5Z6PpZ4/YLQgVnc3uQpm9lDWShi3zvM4pdoek3gJMdoEr+5MMO7hIpcysa7wtVa18lE
         gQttZ4uMtAsyNvNd8nPyOBCOgSru13lHp/Hyt9gIvfNKQgN348mlvL9aQp7olHCX+Wt4
         uMB3hgwantX6MT6kE9b5nJd7QbMiYA076C1QHuFL7IuRM6OzMP6J2MINA5s7RExkmCcP
         XPTw==
X-Forwarded-Encrypted: i=1; AJvYcCU5MkHdM9VV1WeO2zPuerpMUAsRMf0Z8bty8G6dTXBqIn0EBqASRUiOSioXtaq4rSfvNEzCxS9qfmFbGj0NiucQcu9MqpZF3SmnNWWs02Z0KcwZzLd88+itTIWkwQDwQrDJPoR1BJXikh2yarJ6U7Wpaim0YMawh8C9VViI0wDnXPzy
X-Gm-Message-State: AOJu0YwJKqAQDqz8ZbIEsEbsKot3GuMs99sJBIiIUD+Dx3h2L/jEcIpE
	lL0quMMVRi4ds0c/JiplIM+TcZwjXdy6LpV8Vevdwf1aI7yTJXvL+u+jmeEW
X-Google-Smtp-Source: AGHT+IGzJL+qgZxR9ubJMoPUs7gDPXfWNurJaThSzu++EbZAe9YtGjEOTHF/GkySo3VJEwJszmtBpw==
X-Received: by 2002:a17:907:d509:b0:a6f:27e6:8892 with SMTP id a640c23a62f3a-a7245dc9697mr402052666b.60.1719246116948;
        Mon, 24 Jun 2024 09:21:56 -0700 (PDT)
Received: from localhost (fwdproxy-lla-003.fbsv.net. [2a03:2880:30ff:3::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72541fc49asm132301866b.74.2024.06.24.09.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 09:21:56 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: linuxppc-dev@lists.ozlabs.org,
	linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org,
	=?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: kuba@kernel.org,
	horms@kernel.org,
	Roy.Pledge@nxp.com,
	linux-crypto@vger.kernel.org (open list:FREESCALE CAAM (Cryptographic Acceleration and...),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 3/4] crypto: caam: Unembed net_dev structure from qi
Date: Mon, 24 Jun 2024 09:21:21 -0700
Message-ID: <20240624162128.1665620-3-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240624162128.1665620-1-leitao@debian.org>
References: <20240624162128.1665620-1-leitao@debian.org>
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
PS: Unfortunately due to lack of hardware, this was not tested in real
hardware.

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

