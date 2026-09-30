Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD264E0B98;
	Wed, 30 Sep 2026 13:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773235; cv=fail; b=jjqolUonUpg09FIxAVO9CwMzJS/hFgWLkAnUtTq4MB7T7uyAY0kq7TUCAG04j7hT8pN4Nce+fiVNEvGnu7q11dp0w1MkiAlKqlHUWYGzAQaDJPC6QNr508H9qo558vVsdP0bfq+VWbY4YzKrsm3Xsgb4XMGYNR6IlEY+fLZbMs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773235; c=relaxed/simple;
	bh=lCNQzFK9UJ37Sea3gL7rPWFDv6GNWE/ObV3aC8JhLeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gQPLV7rruNYmQu06VNUyeopzD4l4ZMnNOT4Rmk5zcKCkigmUWKKI0TSBObptbwsiXfHbr79/g5ANhccTWQgiKb+gaxjlsWxn7uTpGqvLyROAYKFiS8oFFEYhlfyZkg+Qq3KzEfInjuzKd5etSvpvLO1fZ4qY5jE+oE9wEjsXC/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=ZIBmXHmC; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=bXlYT1NX; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="ZIBmXHmC";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="bXlYT1NX"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5c3Y3552444;
	Wed, 30 Sep 2026 08:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJP
	dw=; b=ZIBmXHmCgsMvcJkYfb2doyolmYIceAdL/ha9JOksCjSjUEcs3JW6A3Lf6
	fyVZpS/IbjfSA0OwsqsE8XXeY0oo2Qn3n4EDhAQ3wLQ6LKCFTG2z+lU/HJTidh3N
	CJmQ/xBDXZ9wenZ8ZB9Q7vdrGYC2aY6NELev6Pcf59GoZyrUbQ2v24qZ+GaNLbbd
	Stwe9zgaSEXQ2APjG620iclk/k4D+9nJMG8v4kdXEbJ18KE0T3McyV2SrFMTO5fN
	xgG0XxWPTtdE5MIThbijZRLjfZNhmM86ueM8ao8RKTFAtDBJj9h2n7EQHlHuw5O5
	oJ4b9BpinvJ8J4cDdEtsVsMtw56SA==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010054.outbound.protection.outlook.com [52.101.56.54])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s20qxd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 08:00:20 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S8ZROmamwBGEeZAA45d9nTzTBvup08gUM0b3GuCxeYFs9ifSqA/oOgLZhEDfs35AnpbiAIojRdcr9cAdGxdZADTVQyIvJa2dYW6FKoiNhnugxpgblS42KHw6xt+wxjsOFSgsr9cECdCaeQHKWZD3CEIOvzok+hgT7E3ppZfiODqXjYIW2FNVxNB65TkTbfxC8SQufeFgfyZRLAjJXs8lqibkCqGiMybv0bg9GRnBdoDG8zbnCRruj0MEuvs6SOZoqKrbs/KuvVAUeWZ1diQXpL/BnpAuKEgan6l4ooHe7in5/jYdoHhVQjM4TqFB/Vf1WEF74GLmL5tzTE10GweBPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=oIgYx8As88woE56ivG5lnfSD8+mosIda5Vc5UhkRywWzK1TqUBoZsQn5zTqYl4yR90tlConGsIlMv5A+hc01w8KpPK3yPUeqIvf0sFvhkSvScxsag0TjoIP3rlGvCUSEYAV3YuMXjrHRtp+TbT91fVJJhdOTEKxEDhcpMqynm6l8wD1swq1Z7w1UpXtYwlKnMX8AI3KsKpLW9yCvj2JyjzF/zRiXh+CCabSl8HiVHiCR0MrQQ409pa3/xDCpZLUJxDLCaegihT7cTIDe6U4GVuuUpumTUwdzbhbJWtLe7teB8mW72cyMFXH66TjmAQqtvfIsEhARbf0M5d8e+ouj9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nM6hlj3eUhOW4tQxIH3PY/P9g8fydftR0n2FkksJPdw=;
 b=bXlYT1NX34nNRoCbmUAntFlPNBPaH8mCiJv3mDuYfROb7sxGLy+yN5PXL5vdpD/AVm5MUJsZ9LfRAvP00k/Df6ZTvDzFhdEjNRFNYw1yj/RR5BA6yoc9FR9+EcoYsk52fr74YPTxmN7+CFYrGgtjCuVFHfk3q6byfdKs+I0HZHM=
Received: from BN9PR03CA0512.namprd03.prod.outlook.com (2603:10b6:408:131::7)
 by CO1PR10MB4514.namprd10.prod.outlook.com (2603:10b6:303:9d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 13:00:16 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:408:131:cafe::a7) by BN9PR03CA0512.outlook.office365.com
 (2603:10b6:408:131::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.14 via Frontend Transport; Wed,
 30 Sep 2026 13:00:16 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 13:00:14 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:38 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:38 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:38 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxbrr4098394;
	Wed, 30 Sep 2026 07:59:37 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Wed, 30 Sep 2026 18:28:56 +0530
Message-ID: <20260930125859.1749849-13-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260930125859.1749849-1-t-pratham@ti.com>
References: <20260930125859.1749849-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|CO1PR10MB4514:EE_
X-MS-Office365-Filtering-Correlation-Id: bd6f32e9-44a7-42f8-a94b-08df1ef2c53a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WSeH93+F8mNUlcgirug3p3Z2+pNEkGD5XfV3rgaYUCf+FSAq21ILQl5z2mWQWQWsWiV/qkh1sORMPiF4zBtp7Est3z4PnLVQm+O4ANVF9NmTYCsbWq82mwrUatSl5Clf8E839mJXEZevfzXfSD3mU6AJv8iHHfDL5CQeC8dhj6uMXkU9tZDEtfztbkQGVT+ACWRXDZpBC1X4BgZw63tSXV+koTann8lBCrrPC/VnqyuXxUTMPym15aQGIzOpwAVyibDoFvV0eFsa65go9Eg4dEWjgecS8LHur/3DseN5YAlrCDXpjdX3XLeBYMQus6B9yDkI4FXTghifG8rk+kBiXeAQShu+9qLKi1VN1hUmEz1ORodSpvbOt6vkTQtvhgSGfwioBS/9a5EroCE/nrB9Uzki483LpRKUL3Jw6LoMR9fRoraT1ccMx6rM9t0uTCO1bjRDoPQ+gUra/mVsWcqqg+/DYki8L7qu1q1dfEmguIOGaMgG+OZrOAK7Z+reRMGqRWAuisZhxPH5SkCQGUl/Lm+KCNE8JK1shYnnfbr4niMek8gTlyWRitAEPAuFYYdWKPKmKRyTPukaGHVdjQH0A7OB++NiEH2Q5d+OZNS9Hp2nrIJ9a4nGdKVgklWfSYtRBas8xsLRuvUOScQGtxYTyca6m2w6eSzspJelhI/i0qI6POQX3/VgeVjglBkquC4cBmcj9t8Pxn8/S0b/CE1ugg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KBm/RpikhJFgxu+tUoeql04o/1DR/eVM83IqoYFJJAB/6Oo0qRCJUmSobIGxYjHfwqHVHAVOLjTRHnx8DCpoAs8fN+3c/zsmEa16fkHq46Lp58RZHaMGlBH3dUbnwpvDEDFlumx02yEJNLQsW41KpdoXmonQPUSF9CcYJo3Lc20Ww4Jij+D3qzYcqsmPkG0R6YDDtFe/JEw0OHDUFN1D+Kph++s9W35LUDUpyxfhmdyF39s4XHyzBi5WN0eV2lH2WG0eENGbowzces3Y5IzbtrhwgWMYU9WlnHsmPLmE1KHeX3eJxFOWqJCHWGorYTOJT136RpOQVWB00uPH0LB8aJVDhdvk8zF9BVaobAa4w/ddCQjtdM5ZcSbaoh1I7hbFnHvc3k0rsSywH6N7a7czko0yEVDefqF2TARLVSGISfnlnUVHRyZQ9hrucX0lVI38
X-Exchange-RoutingPolicyChecked:
	D+ynk27QHZ76iOPBfKE9wAG625OVLWuJvjJVBp6gqdJh7MBvxrQVhgR2T2yE45rbGN+5mRvnC59kgLFdTv/knnCdOmF/pOHq1Jl+70FLBpAvq3N0kz+84ribsstaTAWBHOl1jVVRtXeGfPkvtPeWfRAg6UIG3+KW0+fnyseFPIitDHo3FoybJG+68cK4MHd/KmlrD9is7tpPPQOVtzxYRWbxOf2+PBOSCYHfbjqK7vH29f4nGSLbMRYhSKx2LutDd2EiXl+5IvoUXd4zIz9NxzQFq6t5F7cSLlOPH7NTalwVa1Yafk2+En+nXotPusdggrBKxOSaqbeUAgz3fGkQJQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 13:00:14.8597
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd6f32e9-44a7-42f8-a94b-08df1ef2c53a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4514
X-Proofpoint-GUID: IwS205Qr36Kj0r1VCXWwhkGdAPC3Ta3S
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXzur9TxEL3yos
 J/jv828cwnjfTZcHK78Bsu0ERMWo1OFmn+GjOiTIX6fHrhOhYCcIVZ9wa9byi4qDSe02+nQMWjt
 KPTBH8wrk06pBoCScnYnDINaJJN9z2EG6lBix2YVFplAF0XdWoDn7p1UO4dwtxI19+8eIKp16+J
 TC4pWg+GKH7xREPt7AMF4ZmZlyK58cGFGyyKVs0i+GZpr/6/VO1h2uaHgljiyyM36lxF9qhTJkT
 1bwj/Pp9NoXHPgHsClnWLtMe7M2n1nAY6CLFstrCbvKVi5XkKrrycVgRvLcuR0bKEltXQGABfQw
 uhFDgCm94WdfOrk2JJv+05sn1sw0e/HfvOxxV3OGDgCkc5/vVqapX+8pZ+QanaGMNFp+Uyi1G1s
 NOYI+Ix1tTGHqgN9ixGAeQnuJeFYFH2l0JRe9sXZyvM3FJ08f8pcQ12WejoB9RP4ziAiCo6emyZ
 nXPG7ZpvBt8zEwT2WBg==
X-Proofpoint-ORIG-GUID: IwS205Qr36Kj0r1VCXWwhkGdAPC3Ta3S
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abd07e4 cx=c_pps
 a=2iQKv3wDMkjwRE6X2MvZ0A==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXy03RO9YyDMX9
 Hqr7oG2grWKDYKzkdo8BSX2y+eXXWLjzvJnpoaypqERonlXlauu9sRIRu6pHb8vFMASawXcw/dB
 f0UMLL4Nl60ZvKe1FYwzf1T7n9irKZc=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

Similarly in how AES part of this driver, we are falling back to
software when memory allocation fails (we get -ENOMEM), fix the AEAD
part also to only do fallback when we fail only due to -ENOMEM. This is
because we are doing memory allocations with GFP_ATOMIC in the beginning
which might fail. Any other failure paths might have modified the data
or buffers already. Doing a software fallback on them might give
incorrect or corrupt results.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ea6e3b246ed1b..bd26c3f438e34 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1177,7 +1177,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
 	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

