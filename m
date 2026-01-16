Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C12A327BEE;
	Fri, 16 Jan 2026 01:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768527950; cv=none; b=h8wGrhV9Djv50s4noeNp0NomwXl3DyRY7gBBXzTR1G83WsWM2kGM7alFMQP2W0qquhszlqyEsXDQ7Wp+gRC9ygl4YzMmk5JBVAdcvnJoHwtAn49fxxg4EEE7/tXmlfOSsMskq6z/EOoTuK3ddEzs008jgoW5ilImtLcK7VQurxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768527950; c=relaxed/simple;
	bh=N8nx05NpUJCQcARRlnCOoF0KjTvr4d7Okg0/G/a28xU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OUS++eHC78+nYvvbJbzm+fn4i6xgRLVvvZJhQAt9YuD2SZwOLjje/FcnnL9uQybgMW0MjrGrExUKI0Mbx/FBT6uzipxCvXuYdcFUhyeWnO3eDuZ8DUf8O+aoPAC3mcAi8ezqhixObnuqoMlRHlpsSAjsqsvn/8GnbUgsI/4z6ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=AmFbTY+p; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="AmFbTY+p"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNW7jC2869923;
	Fri, 16 Jan 2026 01:45:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=DT5InPEjU
	RTU+77Kel4C/qvfHL+qaXMdK4705sb3jLs=; b=AmFbTY+pexRLEJ5Da1pBqEVIE
	1wEnVujXYt0tQrNBbE2aDSFpohWsaAZPEIbzIAZjtgX9ZsKKyYETSLWiCq+rfVuC
	DNMg+MXDK4MaFXKJ0X8wLJPONisnW/E5jPLeghCSX86bjIX65daHUo3pKxQWKP9D
	B3RikeA+JaDO3Jjjvs1j+xhWoqX2Ap8z3aynvjJUgGJcXhBtjxGMrlw+lHJXkJEW
	znTGCjzcTGdZMYJUpHdRSZ3O8M2mR5U5W8L5QpgP7SFlirUCQ7Hl7iFKQl62b1ho
	wOATLgJNNfxfG3A7LVoffHWMsbDag6LFKTafTvEzoRuUBfYE0J2qv8a5uZq7w==
Received: from ala-exchng01.corp.ad.wrs.com (ala-exchng01.wrs.com [128.224.246.36])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4bq97n859p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 16 Jan 2026 01:45:00 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Thu, 15 Jan 2026 17:44:59 -0800
Received: from pek-lpggp9.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Thu, 15 Jan 2026 17:44:56 -0800
From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
To: <horia.geanta@nxp.com>, <pankaj.gupta@nxp.com>, <gaurav.jain@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <leitao@debian.org>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jianpeng
 Chang" <jianpeng.chang.cn@windriver.com>
Subject: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
Date: Fri, 16 Jan 2026 09:44:55 +0800
Message-ID: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: vI31eMzRTyHEBxyTQ3jPEPX7Z3GXFiHP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDAxMiBTYWx0ZWRfX0CbaJmXt1Dq1
 9JOm9W9LGCgCrVSsga0IYV3V2ejmFFEgSmn4KYMQ0zFVM00aycyiKkmo2Jq4GUkdFUsMDRDJMI4
 av0ONnDQc0zIY2fDGEThjiptnNEblYnc+39rn+fJl7MQBFmzg/vj0o1LeuKSKf5vpfD9q35EnJx
 ppxDmrxWuxIDA9olaNlMu5II2mgskwQhm1m4cPhFcIDtlwFj9XTwiu1MeP8Dzkjtd3jtUD0a6CD
 SkorlrqswgJTS+gUgBBskH27+OUFwEBm8nfOoJBSqK/F7hWMA8yafM0pY9tlUlyHTU1QJHZiRNn
 VIyQc0lQGDtY/eXgnArLHmTtYcWbPrjBz/AjDYfs47+rNxA7iowSqpNw9E0TKJvy1d0l+eCbHT8
 RWGIOtr8P/NFlLLs/fpW6FjXtnW1rmKR1mPfi5KK6COcvW1wGYdTWNDq8NhPXiI94vpLaI8j3eq
 POJWdLeNyKsE5g/bB5Q==
X-Authority-Analysis: v=2.4 cv=KcHfcAYD c=1 sm=1 tr=0 ts=6969981c cx=c_pps
 a=AbJuCvi4Y3V6hpbCNWx0WA==:117 a=AbJuCvi4Y3V6hpbCNWx0WA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=t7CeM3EgAAAA:8
 a=CefbV24u0As9B_iXbnYA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-ORIG-GUID: vI31eMzRTyHEBxyTQ3jPEPX7Z3GXFiHP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_01,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 suspectscore=0 clxscore=1011 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601160012

When commit 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in
dpaa2") converted embedded net_device to dynamically allocated pointers,
it added cleanup in dpaa2_dpseci_disable() but missed adding cleanup in
dpaa2_dpseci_free() for error paths.

This causes memory leaks when dpaa2_dpseci_dpio_setup() fails during probe
due to DPIO devices not being ready yet. The kernel's deferred probe
mechanism handles the retry successfully, but the netdevs allocated during
the failed probe attempt are never freed, resulting in kmemleak reports
showing multiple leaked netdev-related allocations all traced back to
dpaa2_caam_probe().

Fix this by preserving the CPU mask of allocated netdevs during setup and
using it for cleanup in dpaa2_dpseci_free(). This approach ensures that
only the CPUs that actually had netdevs allocated will be cleaned up,
avoiding potential issues with CPU hotplug scenarios.

Fixes: 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in dpaa2")
Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
---
 drivers/crypto/caam/caamalg_qi2.c | 31 ++++++++++++++++---------------
 drivers/crypto/caam/caamalg_qi2.h |  2 ++
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 107ccb2ade42..a66c62174a0f 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4810,6 +4810,17 @@ static void dpaa2_dpseci_congestion_free(struct dpaa2_caam_priv *priv)
 	kfree(priv->cscn_mem);
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
 static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
 {
 	struct device *dev = priv->dev;
@@ -4822,6 +4833,9 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
 			dev_err(dev, "dpseci_reset() failed\n");
 	}
 
+	free_dpaa2_pcpu_netdev(priv, priv->clean_mask);
+	free_cpumask_var(priv->clean_mask);
+
 	dpaa2_dpseci_congestion_free(priv);
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
 }
@@ -4991,17 +5005,6 @@ static int dpaa2_dpseci_congestion_setup(struct dpaa2_caam_priv *priv,
 	return err;
 }
 
-static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const cpumask_t *cpus)
-{
-	struct dpaa2_caam_priv_per_cpu *ppriv;
-	int i;
-
-	for_each_cpu(i, cpus) {
-		ppriv = per_cpu_ptr(priv->ppriv, i);
-		free_netdev(ppriv->net_dev);
-	}
-}
-
 static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 {
 	struct device *dev = &ls_dev->dev;
@@ -5126,8 +5129,8 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 					 DPAA2_CAAM_NAPI_WEIGHT);
 	}
 
-	err = 0;
-	goto free_cpumask;
+	priv->clean_mask = clean_mask;
+	return 0;
 
 err_alloc_netdev:
 	free_dpaa2_pcpu_netdev(priv, clean_mask);
@@ -5136,7 +5139,6 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 err_get_vers:
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
 err_open:
-free_cpumask:
 	free_cpumask_var(clean_mask);
 err_cpumask:
 	return err;
@@ -5182,7 +5184,6 @@ static int __cold dpaa2_dpseci_disable(struct dpaa2_caam_priv *priv)
 		ppriv = per_cpu_ptr(priv->ppriv, i);
 		napi_disable(&ppriv->napi);
 		netif_napi_del(&ppriv->napi);
-		free_netdev(ppriv->net_dev);
 	}
 
 	return 0;
diff --git a/drivers/crypto/caam/caamalg_qi2.h b/drivers/crypto/caam/caamalg_qi2.h
index 61d1219a202f..8e65b4b28c7b 100644
--- a/drivers/crypto/caam/caamalg_qi2.h
+++ b/drivers/crypto/caam/caamalg_qi2.h
@@ -42,6 +42,7 @@
  * @mc_io: pointer to MC portal's I/O object
  * @domain: IOMMU domain
  * @ppriv: per CPU pointers to privata data
+ * @clean_mask: CPU mask of CPUs that have allocated netdevs
  */
 struct dpaa2_caam_priv {
 	int dpsec_id;
@@ -65,6 +66,7 @@ struct dpaa2_caam_priv {
 
 	struct dpaa2_caam_priv_per_cpu __percpu *ppriv;
 	struct dentry *dfs_root;
+	cpumask_var_t clean_mask;
 };
 
 /**
-- 
2.52.0

