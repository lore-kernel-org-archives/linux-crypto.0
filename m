Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAFE619D89D;
	Mon, 24 Jun 2024 16:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719246125; cv=none; b=KU7RvCUDXWmOTD0Fl8Y5CQCarFwf2MmacBHAyqWhVrW+Yzv/beEWYZfpfPrHlvsfcmOlQD4b+ZZoSPsSKUD5SNnz4AlLax9k1V5JfnhSPnrHpuys4wQg8Ge9dNbpNLZYL29NV9efjS4TnAgX1dQj5VLTwJNFlyT4GFYKBGB6VPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719246125; c=relaxed/simple;
	bh=MHuZnCBbfRRzSWLLQ/7VVJKbRN/VS3rhtDIjKYgN3p0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdsU4cZ6+2jRqie2BhV3tmoF6g08x5jObpfYNdtam2hixKt3bIMxFDPMJ9Uvk5R08KMEebywlpvd/buT48ySxDS8bxPeMu2t0lPw9smLLPSgqj+ksHYadZsXYuQGGT6DL4Q0ff2U+pI4dG7F5EBW/QWrycNaLuyJ3MDMmX+qHJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-57d26a4ee65so4243648a12.2;
        Mon, 24 Jun 2024 09:22:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719246122; x=1719850922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lI0lpN6kx7yRxic2Ty5k5Kh7yOrOrpZPNGmNxWXyvto=;
        b=eU1OJTSS8Pn3sQpc1zUu0+81ua8ukqDUN4GJSomxuTDh0aiA03ygg0h8JyvfD4EQkX
         Zs4rMy6GDiSaAr8rYjXpd2jABgnnxGOmKwP/kiUkBDg/z0ttrLYd1jvseZmqsQu7zHTh
         EjbfIYcEM6BW9bXIeNJO+uqqRtVvZYhzJzRvX5qS/8rGYPaV3J9OxSsr4EaIk1+K9Pvu
         ad+rHC9iRh70ekhmgKQdljQgHvhdfpmInQVhzEkD2UkRAvH+YcTrf4MbaQEeH8BxeIA7
         urBe0vRLbxVEp3Ed6aKnLNiCJzswS69oOsdCyqb+EVW749qZ0D8NW+CNfUq67ASr/KVH
         x0aw==
X-Forwarded-Encrypted: i=1; AJvYcCXOg4VgFLpUHIyKI+hF6guAwTVmc73bH2LI8C4nOtUZCgBs+/uWfCprw849pedPj8IatOab8alfKOd+Bo3FwezYqA5kQdWvflaUgyouUEg9HQ/hWIN7NfoNSvRRznmyriUS5Pl0LKebwj0kqbQ+cd8DZxeCcrTyJwfNDNEdT3QBkBh4
X-Gm-Message-State: AOJu0Ywa76OSGP2gfu7osoySOyWamh4/LO+L+PYUcg3quyfOthgPNKpd
	6phXK6h/vbnFoMQiTW+zj1SgLmZ6Zxu4DjRccrom8dLz2gWykLAi
X-Google-Smtp-Source: AGHT+IEwMy3K4qn6NThj+xHIEW9HQLoF5ZMgOFTPxFANNhr7dKPUd+SfBDJ7IMkyk+RxYL401G7l8g==
X-Received: by 2002:a50:cc85:0:b0:57c:8027:534d with SMTP id 4fb4d7f45d1cf-57d4a01f393mr3282346a12.27.1719246121917;
        Mon, 24 Jun 2024 09:22:01 -0700 (PDT)
Received: from localhost (fwdproxy-lla-114.fbsv.net. [2a03:2880:30ff:72::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-57d303d7aecsm4854506a12.20.2024.06.24.09.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 09:22:01 -0700 (PDT)
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
Subject: [PATCH 4/4] crypto: caam: Unembed net_dev structure in dpaa2
Date: Mon, 24 Jun 2024 09:21:22 -0700
Message-ID: <20240624162128.1665620-4-leitao@debian.org>
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

Un-embed the net_devices from struct dpaa2_caam_priv_per_cpu by
converting them into pointers, and allocating them dynamically. Use the
leverage alloc_netdev_dummy() to allocate the net_device object at
dpaa2_dpseci_setup().

The free of the device occurs at dpaa2_dpseci_disable().

Link: https://lore.kernel.org/all/20240229225910.79e224cf@kernel.org/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
---
PS: Unfortunately due to lack of hardware, this was not tested in real
hardware.

 drivers/crypto/caam/caamalg_qi2.c | 28 +++++++++++++++++++++++++---
 drivers/crypto/caam/caamalg_qi2.h |  2 +-
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index a4f6884416a0..207dc422785a 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4990,11 +4990,23 @@ static int dpaa2_dpseci_congestion_setup(struct dpaa2_caam_priv *priv,
 	return err;
 }
 
+static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const cpumask_t *cpus)
+{
+	struct dpaa2_caam_priv_per_cpu *ppriv;
+	int i;
+
+	for_each_cpu(i, cpus) {
+		ppriv = per_cpu_ptr(priv->ppriv, i);
+		free_netdev(ppriv->net_dev);
+	}
+}
+
 static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 {
 	struct device *dev = &ls_dev->dev;
 	struct dpaa2_caam_priv *priv;
 	struct dpaa2_caam_priv_per_cpu *ppriv;
+	cpumask_t clean_mask;
 	int err, cpu;
 	u8 i;
 
@@ -5073,6 +5085,7 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 		}
 	}
 
+	cpumask_clear(&clean_mask);
 	i = 0;
 	for_each_online_cpu(cpu) {
 		u8 j;
@@ -5096,15 +5109,23 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 			priv->rx_queue_attr[j].fqid,
 			priv->tx_queue_attr[j].fqid);
 
-		ppriv->net_dev.dev = *dev;
-		INIT_LIST_HEAD(&ppriv->net_dev.napi_list);
-		netif_napi_add_tx_weight(&ppriv->net_dev, &ppriv->napi,
+		ppriv->net_dev = alloc_netdev_dummy(0);
+		if (!ppriv->net_dev) {
+			err = -ENOMEM;
+			goto err_alloc_netdev;
+		}
+		cpumask_set_cpu(cpu, &clean_mask);
+		ppriv->net_dev->dev = *dev;
+
+		netif_napi_add_tx_weight(ppriv->net_dev, &ppriv->napi,
 					 dpaa2_dpseci_poll,
 					 DPAA2_CAAM_NAPI_WEIGHT);
 	}
 
 	return 0;
 
+err_alloc_netdev:
+	free_dpaa2_pcpu_netdev(priv, &clean_mask);
 err_get_rx_queue:
 	dpaa2_dpseci_congestion_free(priv);
 err_get_vers:
@@ -5153,6 +5174,7 @@ static int __cold dpaa2_dpseci_disable(struct dpaa2_caam_priv *priv)
 		ppriv = per_cpu_ptr(priv->ppriv, i);
 		napi_disable(&ppriv->napi);
 		netif_napi_del(&ppriv->napi);
+		free_netdev(ppriv->net_dev);
 	}
 
 	return 0;
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index abb502bb675c..61d1219a202f 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -81,7 +81,7 @@ struct dpaa2_caam_priv {
  */
 struct dpaa2_caam_priv_per_cpu {
 	struct napi_struct napi;
-	struct net_device net_dev;
+	struct net_device *net_dev;
 	int req_fqid;
 	int rsp_fqid;
 	int prio;
-- 
2.43.0

