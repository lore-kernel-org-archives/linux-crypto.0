Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7932246C4BF;
	Wed, 30 Sep 2026 11:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767584; cv=fail; b=D+sIiOLjGhn8z2B9VtiaGIPkCMf7wl+guast6OAziKIZiNS+Ukd8guPBBQZ5CnMybQ5/Tgz7pvBJ8rpPWMa5KlMLgdUHML8poYmVbTIBE8Vx4ry4v9f/2kp/W6a/t89nYIRANscb9RCMU9SIAno1GQxoPKAoWS/wATZQu+wN6As=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767584; c=relaxed/simple;
	bh=YC/A7S75qv+4+3WlQfVYWpfOLT28k6/ecphUxP7SPDk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4GK9Pb+f5mup6Bm+FSIuHT3r2xLW6wEQZX2WKgxBaHhhPdaWZxOEVNUsqm/IgtvQLEeb2zPovbQclavj7RVtq7c5xNzDlWlXE+HWqjKEXaoqxiagSHCMquzIrqse/+t9LmU2fcFDv/2oFg6h3xHKmknBRSlVQPchsgKw7jXaCo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=SOwqC2os; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=cclsYxLj; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="SOwqC2os";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="cclsYxLj"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5ckK3552444;
	Wed, 30 Sep 2026 06:26:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+
	WQ=; b=SOwqC2osFqfDZ4eb265YM/JOdB2Ycb5Mh0OxBtI0AB6UI8mdKnELv+Fiw
	0JaD7dOphj13+vc6vQ0pgT2mWZzrzQp6CJLq4R6usxG1leXw+rjhZ1+g+wbnIL7r
	qEpN5k0mYgiC/93G87kYLHTmrHRis4WueIZQiWseETR1g9o12hM9/3Rse7ZG7GbH
	n7l0MxJXjNfViOIRh67W0JrpCI3D4/HW7Ac0EeBVuMuQx+9JjwwECwNiXiFzC5fs
	mKNNiK5UvxoCrrC4kVl1u2XTppFRCw/0kj/ePNEdLx7zSK7qrhzx3Bk0XuAnNOyX
	3FG7ZZEYD8FNukZN/YHqbsE4HX5zQ==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010042.outbound.protection.outlook.com [52.101.56.42])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s208fh-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:20 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ESFM/OxnuY8hAymBU0GvahlpRF30mEbRBz5TU9mLgQOI05F1jtmEcn9wsZdU7YSPo2veQhYIeIWvmd3lXF7PjIDYg1Xt5lTEeJucwuOiQ2fYlr5mtacqJjPFn/0j8RB9snDGDgwDQJZeVpf2j7+S5UB3g8gfTr0yfMyDj0pMAy2MAbJ+EKL9dp7iQbnfhUeVuup+nMJvEChWho/PVqLlWHrtTc2rElz6RaiGRMcc4sSf/esapkJ0J9GK1Sixl61RmRcqLvx3ZZ3oTjBW27L40O/j/M4OA99fKJjGafB+uGu+faFejMhtkwrWnoQLJ4CO7+MOoaFZ2Lu6LjEpUT3m0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=MypFCNwBA3L/weAoKDw8I7jhIpCN6wjsFmBQskCaCm8o9zCbLSp40RIzh8vNc1IXWIvXSs3B5zozmrNqiWpt9GzqrZZQ9T2Km/nT5oOEGcd3GscQJKc2vqTdsvXB+eS1+dj7wVe9RDBZqIpnDgB1x/UGNecsyDvCrt3wmfOyUNcW0V1SQzlGlRpaPDec6qEDtMzia2pwdlz7vxNKp0XVDfsJI1jEkouvZ3mD4kicI9QcHHPzSHCMjrckaNfzWaTAw1j3agAZJM6/lGPDlwdKpHMMvSoUfxTrSjXL/WRAl/RDaJnMukUjlfQz+PmQyluFps6hBfFmAPCgDyOQZneXog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a0HCdrHMm+MNm2XsTRsZj9zTrtiogIDOUdA/ag57+WQ=;
 b=cclsYxLjMYPbUX5ZLgzkw448aY43sCZ3+sWUOMDUCAe9jHRHsd5kox8DOCCKs/JhW4zuxW4rpLLLJon9kf+zvN4ef24n0Hw37DffYcfurbul1zdT/6I/NwYF3fTcN6kf0NmARmmBNvKGT0TyCJWnpSkIF/DIakDFI2W6puyjdwc=
Received: from CH5P221CA0022.NAMP221.PROD.OUTLOOK.COM (2603:10b6:610:1f2::23)
 by SJ5PPFE25FD365C.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Wed, 30 Sep
 2026 11:26:16 +0000
Received: from LV8PEPF0000005B.namprd02.prod.outlook.com
 (2603:10b6:610:1f2:cafe::64) by CH5P221CA0022.outlook.office365.com
 (2603:10b6:610:1f2::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:26:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF0000005B.mail.protection.outlook.com (10.167.245.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:14 +0000
Received: from DLEE208.ent.ti.com (157.170.170.97) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:09 -0500
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:09 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:09 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQ81G3969933;
	Wed, 30 Sep 2026 06:26:09 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 10/15] crypto: ti - Terminate DMA on all error paths in AES to clear descriptors
Date: Wed, 30 Sep 2026 16:55:28 +0530
Message-ID: <20260930112533.1593952-11-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930112533.1593952-1-t-pratham@ti.com>
References: <20260930112533.1593952-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF0000005B:EE_|SJ5PPFE25FD365C:EE_
X-MS-Office365-Filtering-Correlation-Id: 56f55f58-6773-423e-3f26-08df1ee5a34e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|23010399003|1800799024|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	NLRd56uKmF2wlefufC3qpjC+dhmR6GwDXESt04gywlXnffo8HrVAbvYZubGsaYEQplWvmJilbGVhmYeUC9iA00urBSy5eqQLG/yFrEZV2/Wp8jrlYpDP+H2ZvPxekUZeFSTMgdbexLtWqAByZOFv6oJANY7nNiQ7aoJUDtD1yBYFJp3tBzCVXxTZ9wFpCFfKSuAiUA+54D2F/WRp3xR/iHRWGWjeDy7ChD7plEPTGvxgxqrRrNNvWXzMwPvU+EZJKcv369hIkmiE6gGkWuwf5s4YQFBWojPkHk+41BjozVnF6jk7GMgOgTIbTWzycBkiZlRCvez9H1EKI3IDUPNpkvBCe4c/kUsk9thj6K/ZPR1ziP7nayTx6cQZVN0lgFcmNWRHaRhAa63WbXvRq44eaCJWJUjz0bGngpj7wzRKb/0dfXkiFVcIvFWxCqgGrnpzODTBu3wUeacjMXkbIiwgAOFjpjhNBNLXcXWF+DsZpM7AhIRmCRm6dX87LY95FElYxClQFue6niu75t3mBSyLwtvOm4Y7V+CGemlmEuC0cWkXI2DMsJob3wZ5rZ0l9vwFgMmTRGz4JVDcqzWOCjjYpArwqYDFbzHtlpp/v9/ZpvUFFarMEesTvTxZUGWZcJRyU7BaJnwWfEzkmkOFUBOSR6IUBVewTlpJ589o81/fn9jmaxbsp2BhZApfnxLeuUJcHkz5K7QfFu/hCC6TMNr3+A==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(23010399003)(1800799024)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qxlsrL+/kzNK9CbRllqWiqIK//j0vc/PurYeZnIE4Bcz749F2Sg9DZwE2Rxkyd28KDtKSUoZb/sJdm5XzXQ2c/nL4j2tmUQxHR5cbK763gIkdlGPGzkNDdifegwPcPInAgCdd8VNOhfdNEcmDGD97pBNf4YlNO/FJdQPQqL2WHxNsdHmuDVmykwXEYKVwEgdKD3F0FZKXG+jb087v6DM19pO95OpfVBb+36zju1QKznME8UBEceF2ZJowujfAguFdVBv8xOQAFilXHtOskzvzLqKOqlMD0w5708MZsta0lTW91MUUY8WbzFxgyBDA+1v67TFT5x/mlGCSIys0Z2MjbQNtqTIMU3IFPaNnopQjvvOoVVOkUp/B8pnBJDU+J+T7BICPbu3w4D47bZOy/Uh3ZSyY9enLva/uu3ERnrjX1ZDvTGUpBDqL0pZEzj37BFP
X-Exchange-RoutingPolicyChecked:
	02FdbfZLWtlvQgA0chXZpIHdGnp7Tk89KPiL5tOM7Zubp3NhQem2P85fic4JOHolM+n5dfeSYLrYOHF/7pETWyBRElJv04Q1IYhFD0LhsIO+2N2GbLFvEARpK9DlMi5FNnVs+pvdLe4mOU6pjZagGxqF4HrldesTn3ZZRkFjllEW5PJjL+g7ZNcn3fnv5LqvadZC8MbA9MVyE3qWUjfzpvF973WJW3ZUG+9xujXFRgoI/ACyaRBeIwkEDdZ0R6P1nMDUgS/2Yadc9rc0XUKgng00rDTITrxg8vq8uKtFBIE6B29d/Ly75lT+1ImDmnnx3HIqpBFGIuxkjAALAMQI/A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:14.4851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 56f55f58-6773-423e-3f26-08df1ee5a34e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF0000005B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFE25FD365C
X-Proofpoint-GUID: aPJGojVPEVCNooG3hCC_PN_fv1xIzEy7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX2EywK2ArgMXN
 Zr0uR6HV4SLvxaHNuri7d1YvejC+FARca0c5TZnimYjpYjgvhGybrjlq4VAR6TFJYEjyecZo8+L
 XeoYyVsOE+UErq/tXrDII0GRKQskI/Jr0kaS94QaAEBgcCt5PP2qBzLKJC8k8vXKHMbwCbuPNHj
 /zIJRKrqmKCo+Eoab9oPkV5C4SYc9yVec+hfs+Os7fz2e8/Fp0G2BHJU2F1y3/z5+KgPNJ5su9Z
 2pt2t+FmkCTAmMo8Lg7mKIsdnCX7tC2WQHNi2wh81THYZBgi7seTfysv2ANWZsZJ40Gr+5RdwsN
 irdtAWkRmrgTr8UPtKXaloMxzqrmkSiMj5x5co3IWUtGe4H+UkdwBtutjovi4+4OFPKkJArrq6j
 /IDiClJyaBBELwI8Oxu/cGLSUvjHtyGw1O4CsFVXLrO/ccQ48oRHmQScJrq/RZPa1Ics9QGgskT
 Mzh34eaF6dD+qStKb3Q==
X-Proofpoint-ORIG-GUID: aPJGojVPEVCNooG3hCC_PN_fv1xIzEy7
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abcf1dc cx=c_pps
 a=cLTib2BoJD1e+Gs0wkBYAA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=T1XiGUNGXxSxoSVzcpQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfXxx5MEKPbN/dX
 ztw9+B5j+oPFqZ8rlTnbsyPfeGJKkcDPJG0Vl6PuJc+ncxVaHwbmgv3/ZwJjgZYfBaDy7Jcr/VT
 nWBm4wJcPOvn6N4+dX9bnSM6v2nDd8o=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aes_run() to appropriately clean the DMA
descriptors.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index d75b074ca1e39..ccee60800a664 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -449,6 +449,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	if (!desc_out) {
 		dev_err(dev_data->dev, "OUT prep_slave_sg() failed\n");
 		ret = -EINVAL;
+		/* terminate to free the orphaned desc_in descriptor */
+		dmaengine_terminate_sync(dev_data->dma_aes_rx);
 		goto aes_prep_err;
 	}
 
-- 
2.34.1

