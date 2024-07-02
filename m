Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256901CF3F9;
	Tue,  2 Jul 2024 18:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719946620; cv=none; b=NsrztHudx780pSlFlKpqcGKEb7vX7OquenxjkbQURUWZUkGeeN/iVByi8yVkg3ixmbkT9V8jrEor56nWifsEQu1eRUz+nFYTCUSnst/u6WzBFR0ayHLJ/US4kqxo/SeJ/VmkkjAKFIdsujD2FsLTE6QazDZs38JAl0fUtF1I3PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719946620; c=relaxed/simple;
	bh=JNl2l3vdXcnwyiGAaHW2mChV80yaVjG0lqiKdNOQ6eM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQmwP+NLMgi1hYcYt3PNQDcB/gG6kcOSVZh6wW+07xdTRtG96JjJ8z9oCZX9CNveCgTY1MawfVp6K1+0mwBmiIpA71VWC99BRpZgxRg3WE2cbUh0f72yMc2KlOdGjkAzdOuaX06NAI/+8hAzed0TtxSSxM6UHNqamfwRrlGslbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a75131ce948so418996066b.2;
        Tue, 02 Jul 2024 11:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719946617; x=1720551417;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oSy9xn6zf0uOofSAGvu9prtSY8Ipz+Uu9GyDLC9cna0=;
        b=tR+4OdhakwwDdUHxw8/qXVuyjzP84H6JIIJS550oHF5c4O8sWAgGW1iGZLDN5/6TcN
         LsRQoj7e5Iu1aU0DiEKdulmTbhMyFmxDx7EvXOfc1cV6D/UVq/qfsKEX46EO2cUO1Opm
         E9FkonQcZ8IGRMO7i4Bv4WGYG+4aDSaFFVY8j8eAIo9FtsDqISYuPF1dFhXHf5jbZJJX
         RQP+L7u63XMcnYW4lq4N9vA8HZKBjPMV42LbaWDLZZ5xtI/Nw1b/bDTKIGcZhXAoUnxE
         yNZ8gz9DrQNzak70fLVC7xfRtNbSkzz2IK1BJBAWb9Y4RPDUrMmIA9Fdav3waAkYwbyB
         2b7A==
X-Forwarded-Encrypted: i=1; AJvYcCVuLTs1tjXmdGqojknwpfpUWSpgx6Hvoj78A7Yf9DOWWad2ZueOQ9td7WK/YkEMedf5NRPjTry+0IPjkza64/154e3uYsa/SFjs+09JDD+b1iTa1dOT87ImRfESRJeiPXlLMwBQMIcmSCyFTSYP6H5Omu6IAGPLlfNEa93MNrIOvrJo
X-Gm-Message-State: AOJu0YyOU8NUlKwWoanYnCvxvQPWz/3hcylhwjRfV6oF/E3k/QY2/RVG
	y6w13nfpIVQso+pWV3Ba720e0jS0JSz0oosKUUV8M4tZlI+4o09N
X-Google-Smtp-Source: AGHT+IEXvPn8naD3LbFJ25auYC36fl2hcqanVnNALKBRNbctpka4Tp29E80aHtwxaClGB+NJLiSMzQ==
X-Received: by 2002:a17:906:3450:b0:a72:8100:c3e with SMTP id a640c23a62f3a-a75144a2848mr512170666b.48.1719946617501;
        Tue, 02 Jul 2024 11:56:57 -0700 (PDT)
Received: from localhost (fwdproxy-lla-116.fbsv.net. [2a03:2880:30ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72aaf63360sm444217666b.64.2024.07.02.11.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jul 2024 11:56:57 -0700 (PDT)
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
Subject: [PATCH net-next v3 4/4] crypto: caam: Unembed net_dev structure in dpaa2
Date: Tue,  2 Jul 2024 11:55:54 -0700
Message-ID: <20240702185557.3699991-5-leitao@debian.org>
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

