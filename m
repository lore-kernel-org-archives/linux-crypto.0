Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686741D6DA9;
	Tue, 20 Jan 2026 01:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.178.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768874170; cv=none; b=DSGSuwu6VYEdZHZh35c8Ore7w9NoJ0vDH92kl+u//b5KtE7Q1kDynGyf91exBjH/Z1LrGGUp02IrfWZ9PQtHpwnC5/TlJreqs3515uxc70ldSUxVzXisDLwwe/UMVH9shuI9ymH7dVMLuML8SYGiPQjej6xf3zL5RkjAeTSvXPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768874170; c=relaxed/simple;
	bh=nP4Ww8NLjbwRFxQb1fLKugkz1tMmsiUtd5EpnQeP5WU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CUiqRSL9Jki+VPbXvkw5AuCuobYLS7moyZ63n5/aO9ioJ6GOqlKJpH+e3CsYEnAY7t2hQ2i4KSIyBTJjllSUE+f5RwvR46X8R/eWNEGd19ZB5lhF9/ttw6JavokYVL2PAU9TySdqNYz8THGTxj43y0C0fmpaTli+XKMjSLvz1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=mnq64BMu; arc=none smtp.client-ip=205.220.178.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="mnq64BMu"
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60K0Y9Cw585121;
	Tue, 20 Jan 2026 01:55:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:message-id:mime-version:subject:to; s=PPS06212021; bh=vIZfxpr+J
	256TlD0uo/sr8jWoAJouBLaAJNcJomxm0Q=; b=mnq64BMuqzV1xgV9qMK5UQsOQ
	ypS1INMPKb2F6cSAKN2EXRhzQZ60lpdXvnkhBnLiwkOI3IEaQ8iZKkjZv8sq16AR
	C9ZWIycWEHRNSG/SbBGvksR7Q8BG4ZP4cWu8Lpv3niJCo8er0L/5drjN3IFMnepG
	kaODcv7UebbS15hzOF8yVUi1u9nyBCUqTludnDzRvWJojsz3ncDh6lh09qL5rGys
	wvp2b+DmmtoeLv8xiHqgKyoB8nVoG+KVs26om+2O6ykABrPn79sbchpH49y9AXL6
	M9MSlMBgzQrlf/3ZD7VMS6O0q233MQkGAKz5klJ698EJTxNklwd1ZtwD5otzA==
Received: from ala-exchng02.corp.ad.wrs.com (ala-exchng02.wrs.com [128.224.246.37])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4br1d4aegs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 20 Jan 2026 01:55:29 +0000 (GMT)
Received: from ala-exchng01.corp.ad.wrs.com (10.11.224.121) by
 ALA-EXCHNG02.corp.ad.wrs.com (10.11.224.122) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.61; Mon, 19 Jan 2026 17:55:27 -0800
Received: from pek-lpggp9.wrs.com (10.11.232.110) by
 ala-exchng01.corp.ad.wrs.com (10.11.224.121) with Microsoft SMTP Server id
 15.1.2507.61 via Frontend Transport; Mon, 19 Jan 2026 17:55:25 -0800
From: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
To: <horia.geanta@nxp.com>, <pankaj.gupta@nxp.com>, <gaurav.jain@nxp.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <leitao@debian.org>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Jianpeng
 Chang" <jianpeng.chang.cn@windriver.com>
Subject: [v2 PATCH 1/1] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
Date: Tue, 20 Jan 2026 09:55:24 +0800
Message-ID: <20260120015524.1989458-1-jianpeng.chang.cn@windriver.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: jFkvrQjOETy4SZRSiV_EjIy1k_6Qo75T
X-Authority-Analysis: v=2.4 cv=Rs3I7SmK c=1 sm=1 tr=0 ts=696ee091 cx=c_pps
 a=Lg6ja3A245NiLSnFpY5YKQ==:117 a=Lg6ja3A245NiLSnFpY5YKQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8
 a=CefbV24u0As9B_iXbnYA:9 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: jFkvrQjOETy4SZRSiV_EjIy1k_6Qo75T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDAxNCBTYWx0ZWRfX84omGWDItIaC
 e5k8Ct9F3TfqJ9iJeuXawKMh1HeYzPAr5PV50AoC09zoY5tru3KfcdGKjiPm+Xx/HNMr8vyGaj2
 7NAoz3qIMtsgck0jrMBwvdUQ9HcU0fv/VuF34sXjgXJlwEeYvUn6NnvfTxs5LTa9njO0tZSnory
 //eUwvPWQb/+uWNTdifrG0hDQPLofeQgtBg9rBLOSMPU4WcJyS2M0IE7+pBvyKz/3E0jjwWkQiI
 8PiWLtEDita5LtrTDvfJRV+AimWbkgcIAzH7q3ANVkkFuyfOgwlG7CAdAYAcrTLTbYXToA4RDbp
 oCQ38NSpuj5Dx9hI2oT3sSLQSo5w1+HgzVazbYgVs3qG0KKmsN8JBCPeE37VwvTV/ReDTx+nx/p
 aqXiUKuJ453QXZ+3VSHkCATcCECvWn38gog7xn7cZQ13gJtJFrLXuZgbnobyiv8ebcLCZpzQW6+
 +xk8LImXT5LNDo+IefQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-20_01,2026-01-19_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 suspectscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2601200014

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
v2:
  - fix the build error with CPUMASK_OFFSTACK disabled
  - instead of the movement of free_dpaa2_pcpu_netdev, implement it
    directly in dpaa2_dpseci_free
v1: https://lore.kernel.org/all/20260116014455.2575351-1-jianpeng.chang.cn@windriver.com/

 drivers/crypto/caam/caamalg_qi2.c | 27 +++++++++++++++------------
 drivers/crypto/caam/caamalg_qi2.h |  2 ++
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 107ccb2ade42..c6117c23eb25 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -4814,7 +4814,8 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
 {
 	struct device *dev = priv->dev;
 	struct fsl_mc_device *ls_dev = to_fsl_mc_device(dev);
-	int err;
+	struct dpaa2_caam_priv_per_cpu *ppriv;
+	int i, err;
 
 	if (DPSECI_VER(priv->major_ver, priv->minor_ver) > DPSECI_VER(5, 3)) {
 		err = dpseci_reset(priv->mc_io, 0, ls_dev->mc_handle);
@@ -4822,6 +4823,12 @@ static void dpaa2_dpseci_free(struct dpaa2_caam_priv *priv)
 			dev_err(dev, "dpseci_reset() failed\n");
 	}
 
+	for_each_cpu(i, priv->clean_mask) {
+		ppriv = per_cpu_ptr(priv->ppriv, i);
+		free_netdev(ppriv->net_dev);
+	}
+	free_cpumask_var(priv->clean_mask);
+
 	dpaa2_dpseci_congestion_free(priv);
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
 }
@@ -5007,16 +5014,15 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 	struct device *dev = &ls_dev->dev;
 	struct dpaa2_caam_priv *priv;
 	struct dpaa2_caam_priv_per_cpu *ppriv;
-	cpumask_var_t clean_mask;
 	int err, cpu;
 	u8 i;
 
 	err = -ENOMEM;
-	if (!zalloc_cpumask_var(&clean_mask, GFP_KERNEL))
-		goto err_cpumask;
-
 	priv = dev_get_drvdata(dev);
 
+	if (!zalloc_cpumask_var(&priv->clean_mask, GFP_KERNEL))
+		goto err_cpumask;
+
 	priv->dev = dev;
 	priv->dpsec_id = ls_dev->obj_desc.id;
 
@@ -5118,7 +5124,7 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 			err = -ENOMEM;
 			goto err_alloc_netdev;
 		}
-		cpumask_set_cpu(cpu, clean_mask);
+		cpumask_set_cpu(cpu, priv->clean_mask);
 		ppriv->net_dev->dev = *dev;
 
 		netif_napi_add_tx_weight(ppriv->net_dev, &ppriv->napi,
@@ -5126,18 +5132,16 @@ static int __cold dpaa2_dpseci_setup(struct fsl_mc_device *ls_dev)
 					 DPAA2_CAAM_NAPI_WEIGHT);
 	}
 
-	err = 0;
-	goto free_cpumask;
+	return 0;
 
 err_alloc_netdev:
-	free_dpaa2_pcpu_netdev(priv, clean_mask);
+	free_dpaa2_pcpu_netdev(priv, priv->clean_mask);
 err_get_rx_queue:
 	dpaa2_dpseci_congestion_free(priv);
 err_get_vers:
 	dpseci_close(priv->mc_io, 0, ls_dev->mc_handle);
 err_open:
-free_cpumask:
-	free_cpumask_var(clean_mask);
+	free_cpumask_var(priv->clean_mask);
 err_cpumask:
 	return err;
 }
@@ -5182,7 +5186,6 @@ static int __cold dpaa2_dpseci_disable(struct dpaa2_caam_priv *priv)
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

