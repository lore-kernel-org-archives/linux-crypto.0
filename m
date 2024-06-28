Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8E31C9EBB;
	Fri, 28 Jun 2024 16:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719591312; cv=none; b=I6bdORb1kbTxG0y0nVC7xdEnxsCL+mzvST3zH9o9MQqIhX0hJFzAtin0esEY9g58SCLukKsmi1wtYMFYMZSyCvWLTafbWl+IIL1FnKqUhH6jOWWWirKzM8GioGh/mtP91TvwDbAPjUCcs+FZLtpjVCJ2F3rWtHSy+5UE22YA3TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719591312; c=relaxed/simple;
	bh=JNl2l3vdXcnwyiGAaHW2mChV80yaVjG0lqiKdNOQ6eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9EOAMJIZQ3Q/DoL984eYkOE3ASCyDAhgEnVvsqrstI8nqu1GTFX/MDYSKoJB6mN4Of+NWDZVwx5LChNHa4PtFmcVlIaqKLtk1dQKjz9zIG6mQGZsxzeAOamxM+9MJ0bdUPVZYXbRBB9kOqCSVfC2nB86s8vrdr/3lV1HxKyOVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-57d4ee2aaabso1004271a12.2;
        Fri, 28 Jun 2024 09:15:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719591308; x=1720196108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oSy9xn6zf0uOofSAGvu9prtSY8Ipz+Uu9GyDLC9cna0=;
        b=Pofl9nP8iv5+HgsVIMAkqhLInUEvsw5rhx3Hj/uDdxbFABoyLpyyavXJngFwaTXXjm
         A98w3sfvvkLemHKoWaoQf3R+ZXbvk20Zaq6jIFGtTgzHrK33neTgLVUAiWguAJufv8OR
         aCMpJ8yxKoLP/SOWnzLIJJQS16wXeyY0RCRDRlflAQD0SWVPTFu0E+WGQKH/y3BWApwk
         bthsRaYAym3SE6zPSqUeP1kwuJb3hHcmRdH306YV9PDiz9LJjE6nmVIPSZjTnHFWr8kP
         MSSL7s8d23gsR+CZMOQ/JaWMg4FV7i7HIe9eatQwKMNgurTn5P+Frw1CsJYdkM1FNSRu
         M/yQ==
X-Forwarded-Encrypted: i=1; AJvYcCXOzlLuNDE+5OWw6ZcDelm7bguGekrb5QddMh3WREqr/50ih0sYtRVSup73igZQESyyE/h/HWvqHx+eucV7Q/cy04iNrFgpYQNLyHwa4hjYwwfZpwj9XX8DwFw9zSc47lJzkAdEVd7IOXhqV+2jp3+2nmCeFM11Lg1Y+lNQuO94E/TX
X-Gm-Message-State: AOJu0YxkDGBW6l7WesgFzjN14qiqt7Aaf16fG6XS5J2HbMB20V0HnrFh
	jRopCC27q87zyzunb6JkP/Bbr5PLrR4yQnpk8adtgTNZ5ppdamVK
X-Google-Smtp-Source: AGHT+IEI13owInrcsX3vcD1RQV/l7LlALBAyBs3DzqEg5fx21AUZHdN9YixOlZ2Uv5OumVsudWoVBw==
X-Received: by 2002:a50:aa95:0:b0:57d:261d:f825 with SMTP id 4fb4d7f45d1cf-57d4bd810eamr11679706a12.21.1719591308007;
        Fri, 28 Jun 2024 09:15:08 -0700 (PDT)
Received: from localhost (fwdproxy-lla-114.fbsv.net. [2a03:2880:30ff:72::face:b00c])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-58614f3d5c1sm1197502a12.91.2024.06.28.09.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jun 2024 09:15:07 -0700 (PDT)
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
Subject: [PATCH net-next v2 3/3] crypto: caam: Unembed net_dev structure in dpaa2
Date: Fri, 28 Jun 2024 09:14:48 -0700
Message-ID: <20240628161450.2541367-4-leitao@debian.org>
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

Un-embed the net_devices from struct dpaa2_caam_priv_per_cpu by
converting them into pointers, and allocating them dynamically. Use the
leverage alloc_netdev_dummy() to allocate the net_device object at
dpaa2_dpseci_setup().

The free of the device occurs at dpaa2_dpseci_disable().

Link: https://lore.kernel.org/all/20240229225910.79e224cf@kernel.org/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
---
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

