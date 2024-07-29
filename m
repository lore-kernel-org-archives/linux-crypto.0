Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB09F135A63
	for <linux-crypto@vger.kernel.org>; Mon, 29 Jul 2024 09:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722244596; cv=none; b=i5IYZVI8LW4nengyOp43M63KHUOjalaIgCjwPqSjVsKrvh0X4XXIvwLYo7ByXOLUeSllxwzHgVYS3NOAy2JW7mkRu8A6gC5kdudIrulz1NqnnIZns6T4e39g1OMmDnAkG8N1uM5RuT+nl1piljpcxkzMeZ99Dtj7OqjHWWJLFEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722244596; c=relaxed/simple;
	bh=ZLv9P2DdxmjrXyKmD+B6e8EyDDtVX2Lnl09dSr1kSEg=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=k8jdYKwb9vYA9J9ejzy42zBXmbPK5IDV9YUK5mMx2JPKSrBL1IJpy1eZReTNmFN8CLs+TTwG9VHsl8QvCXXtCL+gwa9Pb/kWRWG/Y6LPRjGuSldQCsU92jqb68oIYTlW3tF9EadPQANBIlJxeXxxxOkjvwRARBq4Ae5sLSrsJ7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sYMLw-000sOm-0A;
	Mon, 29 Jul 2024 17:16:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 29 Jul 2024 17:16:21 +0800
Date: Mon, 29 Jul 2024 17:16:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Subject: [PATCH] crypto: caam/qi2 - use cpumask_var_t in dpaa2_dpseci_setup
Message-ID: <Zqdd5VASjaXaac9Z@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Switch cpumask_t to cpumask_var_t as the former may be too big
for the stack:

  CC [M]  drivers/crypto/caam/caamalg_qi2.o
../drivers/crypto/caam/caamalg_qi2.c: In function ‘dpaa2_dpseci_setup’:
../drivers/crypto/caam/caamalg_qi2.c:5135:1: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]
 5135 | }
      | ^

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 207dc422785a..c01ca44e1eea 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4990,7 +4990,7 @@ static int dpaa2_dpseci_congestion_setup(struct dpaa2_caam_priv *priv,
 	return err;
 }
 
-static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const cpumask_t *cpus)
+static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const struct cpumask *cpus)
 {
 	struct dpaa2_caam_priv_per_cpu *ppriv;
 	int i;
@@ -5006,10 +5006,14 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 	struct device *dev = &ls_dev->dev;
 	struct dpaa2_caam_priv *priv;
 	struct dpaa2_caam_priv_per_cpu *ppriv;
-	cpumask_t clean_mask;
+	cpumask_var_t clean_mask;
 	int err, cpu;
 	u8 i;
 
+	err = -ENOMEM;
+	if (!zalloc_cpumask_var(&clean_mask, GFP_KERNEL))
+		goto err_cpumask;
+
 	priv = dev_get_drvdata(dev);
 
 	priv->dev = dev;
@@ -5085,7 +5089,6 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 		}
 	}
 
-	cpumask_clear(&clean_mask);
 	i = 0;
 	for_each_online_cpu(cpu) {
 		u8 j;
@@ -5114,7 +5117,7 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 			err = -ENOMEM;
 			goto err_alloc_netdev;
 		}
-		cpumask_set_cpu(cpu, &clean_mask);
+		cpumask_set_cpu(cpu, clean_mask);
 		ppriv->net_dev->dev = *dev;
 
 		netif_napi_add_tx_weight(ppriv->net_dev, &ppriv->napi,
@@ -5122,15 +5125,19 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 					 DPAA2_CAAM_NAPI_WEIGHT);
 	}
 
-	return 0;
+	err = 0;
+	goto free_cpumask;
 
 err_alloc_netdev:
-	free_dpaa2_pcpu_netdev(priv, &clean_mask);
+	free_dpaa2_pcpu_netdev(priv, clean_mask);
 err_get_rx_queue:
 	dpaa2_dpseci_congestion_free(priv);
 err_get_vers:
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
 err_open:
+free_cpumask:
+	free_cpumask_var(clean_mask);
+err_cpumask:
 	return err;
 }
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
