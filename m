Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600161487D8
	for <linux-crypto@vger.kernel.org>; Tue, 30 Jul 2024 03:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722310923; cv=none; b=hMRjvq1559EgtuN7P3lIo+RGndd9GhZvCiHJjA2AC9jGZIFXSasM7zNWlHeXbetNtsNeMr6QHTmK7TzMpWJzYQf97fnx2+A+FFfNOhhY9saW+brJLedly+kcghhaq0+kzu222oqlcptYHOuVSnOQV59u5zrnJUzuIcO7oLuliRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722310923; c=relaxed/simple;
	bh=SXP0Oik0oC8ADkU92AZPy63Z/idDpt6b3dDwk98H8eo=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4QWZ2qOR/7TLh98upzEIceZwgrGSXP5R3MxFBQ8wj5iEjwSdCvrsBhWIKjm6Wjr1BaAf6F2LY7FT7bpnyGIMD5u1dqSLvkXib5tYMpUgWw+C9QMDcQ6gobQKmYRQSRBXUvCIz66RpjL/WlSZ5GkAao0SxzgBakDz9S64UagqBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sYdbq-0014uN-31;
	Tue, 30 Jul 2024 11:41:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 30 Jul 2024 11:41:55 +0800
Date: Tue, 30 Jul 2024 11:41:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>
Subject: [v2 PATCH] crypto: caam/qi* - Use cpumask_var_t instead of cpumask_t
Message-ID: <ZqhhAxHC53vfGkjv@gondor.apana.org.au>
References: <Zqdd5VASjaXaac9Z@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zqdd5VASjaXaac9Z@gondor.apana.org.au>

Switch cpumask_t to cpumask_var_t as the former may be too big
for the stack:

  CC [M]  drivers/crypto/caam/qi.o
  CC [M]  drivers/crypto/caam/caamalg_qi2.o
../drivers/crypto/caam/qi.c: In function ‘caam_qi_init’:
../drivers/crypto/caam/qi.c:808:1: warning: the frame size of 1056 bytes is larger than 1024 bytes [-Wframe-larger-than=]
  808 | }
      | ^
  CHECK   ../drivers/crypto/caam/qi.c
../drivers/crypto/caam/caamalg_qi2.c: In function ‘dpaa2_dpseci_setup’:
../drivers/crypto/caam/caamalg_qi2.c:5135:1: warning: the frame size of 1032 bytes is larger than 1024 bytes [-Wframe-larger-than=]
 5135 | }
      | ^

Also fix the error path handling in qi.c.
 
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 207dc422785a..44e1f8f46967 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
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
 
diff --git a/drivers/crypto/caam/qi.c b/drivers/crypto/caam/qi.c
index ba8fb5d8a7b2..f6111ee9ed34 100644
--- a/drivers/crypto/caam/qi.c
+++ b/drivers/crypto/caam/qi.c
@@ -736,7 +736,11 @@ int caam_qi_init(struct platform_device *caam_pdev)
 	struct device *ctrldev = &caam_pdev->dev, *qidev;
 	struct caam_drv_private *ctrlpriv;
 	const cpumask_t *cpus = qman_affine_cpus();
-	cpumask_t clean_mask;
+	cpumask_var_t clean_mask;
+
+	err = -ENOMEM;
+	if (!zalloc_cpumask_var(&clean_mask, GFP_KERNEL))
+		goto fail_cpumask;
 
 	ctrlpriv = dev_get_drvdata(ctrldev);
 	qidev = ctrldev;
@@ -745,19 +749,16 @@ int caam_qi_init(struct platform_device *caam_pdev)
 	err = init_cgr(qidev);
 	if (err) {
 		dev_err(qidev, "CGR initialization failed: %d\n", err);
-		return err;
+		goto fail_cgr;
 	}
 
 	/* Initialise response FQs */
 	err = alloc_rsp_fqs(qidev);
 	if (err) {
 		dev_err(qidev, "Can't allocate CAAM response FQs: %d\n", err);
-		free_rsp_fqs();
-		return err;
+		goto fail_fqs;
 	}
 
-	cpumask_clear(&clean_mask);
-
 	/*
 	 * Enable the NAPI contexts on each of the core which has an affine
 	 * portal.
@@ -773,7 +774,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 			err = -ENOMEM;
 			goto fail;
 		}
-		cpumask_set_cpu(i, &clean_mask);
+		cpumask_set_cpu(i, clean_mask);
 		priv->net_dev = net_dev;
 		net_dev->dev = *qidev;
 
@@ -788,7 +789,7 @@ int caam_qi_init(struct platform_device *caam_pdev)
 	if (!qi_cache) {
 		dev_err(qidev, "Can't allocate CAAM cache\n");
 		err = -ENOMEM;
-		goto fail2;
+		goto fail;
 	}
 
 	caam_debugfs_qi_init(ctrlpriv);
@@ -798,11 +799,19 @@ int caam_qi_init(struct platform_device *caam_pdev)
 		goto fail2;
 
 	dev_info(qidev, "Linux CAAM Queue I/F driver initialised\n");
-	return 0;
+	goto free_cpumask;
 
 fail2:
-	free_rsp_fqs();
+	kmem_cache_destroy(qi_cache);
 fail:
-	free_caam_qi_pcpu_netdev(&clean_mask);
+	free_caam_qi_pcpu_netdev(clean_mask);
+fail_fqs:
+	free_rsp_fqs();
+	qman_delete_cgr_safe(&qipriv.cgr);
+	qman_release_cgrid(qipriv.cgr.cgrid);
+fail_cgr:
+free_cpumask:
+	free_cpumask_var(clean_mask);
+fail_cpumask:
 	return err;
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
