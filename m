Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63306415F1F;
	Fri, 16 Oct 2026 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151350; cv=fail; b=k4QhT1b5P9QaLIlaQwLrLZWkvSy6xb9b1zqfFgjhveg7meIpqIIZHmJOWmNEXsJO6zVkxlHSZ32OkAcLpbAFUJ9S0Zs4qQDDUUp60kJQQuEAidVirkIsA0J2MfiV1pkbdjuADovOy/RTZNDhHPDYhFW5fqEkTqUdHduohP1TX2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151350; c=relaxed/simple;
	bh=14+lpbbjuBYbleZZptnnErmVsbsXKn0WAKM8jdF9Cmo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MPTieK/8O85RsGzJuqCC6kYIaxt3rScf2TeCJOG9YlIjdlEhsZZrxwwwm70hPC+LK2txR5riFMunNOj9YDv6SKNh7Yk+KI0W79FUOyD6VwvVOXlgho2BH2b6vbNbqcs0HoP1NdfixwTM8ZNWAxL2grA36Af0cUoDUFWqFkRovYc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=HAQ7F8r8; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=dnLQm3S8; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="HAQ7F8r8";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="dnLQm3S8"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GBOJ36491944;
	Fri, 16 Oct 2026 06:49:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixU
	u4=; b=HAQ7F8r80WU4Jt8nJCPW2Vc+j/MM586iEXUVF7LWzGiU0H592XMFpsKSr
	HzBMho2t+HmLlVM1LDMqLEKtyOototn/7c54t2XzEP6dIlxGHWyLruAHX0dLVD//
	KOkxYXyGSLwCi5k/N2WsNxrVnCjjFfwEXD7lke5kqXO20Qvwzmvg1VYtPaLWGm7s
	pZAVlQBpaOzlEqjwLUBTuM5r7gi4Hqizkan5wPjI4uFAYS3SS75D+AsNXTJtob5o
	w3TODmmt46QMOZriGT0qH/DcSXwlOArkK2g1e+8+vN6T7POG5CBAugjaM9Un+zTD
	FiZC2VWrRAp9plS47zEhZLOA14kJQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011067.outbound.protection.outlook.com [40.107.208.67])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hbk12g3m4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:06 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PO2WCpB6djTgDUOQPPHIcQvIWEamm4rWl0E3cdyyRyCt1EhaQvCsAzDDaqTKJstR/QZUiwv2YxOTpgR92dRBw4J0rP9pbRQNpefgI4GfKQv57kdu2v94zeTdMHuaUVq5uidD6FknQO57nwfov4Q0HIPRdqb9ZSrm1ZmssByKBxzqQ6c5z7ogWQcx+JtiNxYTdGf/BgcRJ9nhj4sBWaxR10mY7uBJoWqT2rwKWcKVRCosD05jx8r4oOCW4S+DsC1HXRaegXbpklYNI+Wo/XauqcAtndhiY+EJwdXDLXTEAmCd54sE57wYqYhzxJkgDEOAtKSzwUQTK7tuia1iWHnBeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixUu4=;
 b=QRgvVz7hRgKKHLTfViOI0L5spKdcdrkUA/NzNJkXDLMhukfVQgBhNa00HbIDlX2oGet+ylr3OUC9ZWreTaCHJBRzMK7ZjUk76I6x4tIn3slscv2xifti7uiWkpMOS6yRsDVvE/iR6PXjFRhKodBTqKuSaf8PPehSnPrrL5ANLeL/17BWe4qhxUb2naV8W3NKf5IdXOrskRzjZ8S9R2QPAoUoR+zwHUFDR6pD0n1OyOrFeK9KSqnb92njRwgZ+QC+szCyjeiWBzVkIeKQ9CyNGaqDTK3RPUCgnKRKh2fpEvBsstAw90gtPFDrw3D0/LTFOjpSMkgplEq9WcwxkUtTMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixUu4=;
 b=dnLQm3S8XR7m1GEbVjklDeA4/5lNexzQmw9FmWr8pJI3fdTGxq92gYghjZ/ZEDLzOj2sQClrhGrhzVInXmf0ttVdsKhUcLgq6ayv4deHlLwCEUIJGygWObqvEF1+617pSu3t8jEZx0E0yGPi6VRVvq4E6r4Nh7U/oxAN90WmJtA=
Received: from BL1PR13CA0296.namprd13.prod.outlook.com (2603:10b6:208:2bc::31)
 by BLAPR10MB5187.namprd10.prod.outlook.com (2603:10b6:208:334::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.7; Fri, 16 Oct
 2026 11:49:03 +0000
Received: from IA0PEPF00000042.namprd04.prod.outlook.com
 (2603:10b6:208:2bc:cafe::3) by BL1PR13CA0296.outlook.office365.com
 (2603:10b6:208:2bc::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Fri,
 16 Oct 2026 11:49:03 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 IA0PEPF00000042.mail.protection.outlook.com (10.167.249.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:49:02 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:37 -0500
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:36 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:36 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmZuq2451506;
	Fri, 16 Oct 2026 06:48:36 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 05/15] crypto: ti - Trim scatterlists to correct length in AES
Date: Fri, 16 Oct 2026 17:17:56 +0530
Message-ID: <20261016114806.1749515-6-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: IA0PEPF00000042:EE_|BLAPR10MB5187:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d862506-2cf4-46f9-d4d4-08df2b7b794a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|1800799024|82310400026|376014|10067099003|261009223027099003|6133799003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	5AkjKV4BvqWAQ8231VJOriuMvo375nDBUfOXVFxGoAzwY+bYWgoGDtnbHCV4Sc5VL5leeYV9YLDy+OLhNp3RJVoNrE0HLiuygQ3jYem4z9fYzT19kNDG2bnjQt4F60IiL9CDxuXjcNCFSFP+sWQn0jSxC4qKig0kRUxIiGUp2ry55Z04vb5t/XRUCbu5/fSGE8EYsutlVKqPE3Ig+vYTJLf9Egx4DGqXMakYv18hAg2YBo2q+a2wOToajnqJsbpxkVG95z7xHQp3/ZGbAxwvktXZnfwc8FM3MuouXZc4dssPZQh1iG9KMOavjcVBZZsWR5CqlgKcQLDnFacI9nI3RPXfQTQVHcHWcQfDpIqgkaXdmxY67k3jq2ZOKQnIPiDxE1LvAu9+G/ldChH4aR6R64FcokLdyWIo64B0xGKT+HK0WvUCq4PlyNEwjkAruxknMp2PkR1G47n5YC8Ww1AWoYqdcmaV6v2IByht4RRDcAbv9aExd/gRGOWt8ZvAegYdpQIXXg0++mCD7JkKO4xeWVc7Moh+/Nwby5tMJ7SztmG6ereBgZ+0lD1P+feMnj3J8fZcqWJbqten5oXU11W+0VTR+3dTgYfdhfeiPvpnQhy+BZfSnW7wcJ+PJTxXdk9yvjziPdWaxBSXDIOGHz8HpdABo4GohNOwA9mdc+QEaj6+jKS/tbTmOLBq0Xcfk/MlMzwMAF8u84hN61UaZqGgxA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(1800799024)(82310400026)(376014)(10067099003)(261009223027099003)(6133799003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3jza3v66uHDZ8Z2ca0O2vrK6WCwS/3joWMrd3l7zCqLgii/7tbeg88uz6oeOzXSHYPpICvavMM8kilY50LxG1a6Uvl8SSa2AlXLcvAz8lWR6j8wW0lKEVpULi5hE4Bx9EYcisnW7qivLJPcbFD7+SxwcwXAWXCm576AXX8Nt+lU4FNrKHG8ywUjZaBG4F6kio45OasCCaWtpj++4B6wtOrEMJQJzO+VIV0qS6VNE3ScCK+MfnPKxHz+L/5+HVilvDMVrACFuC/U+divy/sgVSmvgfRScryXe8JPiZif1yuv3lJhhXwe/S7X9XpP895H4UKq49jzCiMROYiYDbNupTSU8DYgHtMJ6O8YHOtkwdxmsVYxeqZ1OvPUH2VRAZ9S6Wq2iG9apiF0ykQcQ1OHIy4jmYbNHkClbK0p+W7bOYf4fuZX0W482Hmbg8eOHWSFn
X-Exchange-RoutingPolicyChecked:
	NuV7s2Z1/M5chGRrXhZW3WJdxcxXZXkHcr+S9qgYgxTIQKLz/pJ9GvBQV3OCL9rfcCiaNOrQH8LC57xvsiaEwpWfrfCVf+g3ZDbQ0pf9UmzOsh+JnGnlUibxYm7tldDhkWStqCdefKl0/rUXc1Vws7uUsh668c18ZGQimI23ovHIBRBl0GjBu0yE5vwBpPL02NG1tOvxAZuu4GZs78orGOpiefS6mbgd97sazMALGOsqNWUQQrfb7InwAaG8OstIph9KA6E5TdueIqdHbBUw4p3d1mAeVI807RBQ9CXTkuOt+HlBEPLAFLSdVl8UL+KBV2yhk9tx7IVWyQZBC5oQrA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:49:02.4554
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d862506-2cf4-46f9-d4d4-08df2b7b794a
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000042.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5187
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfXyOvVNQKtzO/2
 YnmrulQ7BYfxFZT/CxUmliX2nZl2CuSrSeGpxOhdtcTAUr4lipRjqIksjZhywGP05A+SZnSLnbZ
 KQizBOXLI1BkUV9qFfqGlIaEWzvQItWUNuRE95d6r61eFGmO6ZjmNq0bQjP8n00SC4QBgxBqtya
 YwwZSgC//xdLfQVdCaeGXT083ggveQ3941utQ6lgMfdsU74lwWm/WEgbQCQ7eUte484/Y4pkJjO
 BQaBwVC1Niyd8Yk2xXaskEWOp4Ehqwq9wv4Ccq9FzLQlaZHzcq5hOiqa8dZmF+gnv3PvgNdcL94
 BBFhXgQ15pEPN9JxziHFuOZaCIF+USjBaLEJmkwpN8yosgBFFB5/9CJFHDsIJkf6bvNavMgv5OY
 SVr7FI6ifKN7bWmbfjMk67GKGKuX0LqcFqeWDUEABZHwdzWQQuY+KP3Akoy8OeKIRb6TXR/WhCz
 wKwOUcNW9BZ0CpQ0qSg==
X-Proofpoint-GUID: 5ESH6lokPPvxmV0J1dUzTMLpFxErrRjd
X-Proofpoint-ORIG-GUID: 5ESH6lokPPvxmV0J1dUzTMLpFxErrRjd
X-Authority-Analysis: v=2.4 cv=fspJ914f c=1 sm=1 tr=0 ts=6ad20f32 cx=c_pps
 a=hqbemJ87bpGpMWfnijcotQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=Tpn98H0sjD_mw3BxSIoA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX9bOpg7CU6KW6
 eXDV0c5nMjzMx0VfbzKzO9cG7uXyuVf70PkWIgJ/+TcoF9e7dFvs/TvC1AN4xONijRYndKmtss4
 fgvmYH1SFigJegXM4/8iqsJP9XN3z8A=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160046

AES functions were using src and dst scatterlists directly provided by
the request. This is problematic as it is not guaranteed that the input
scatterlist is exactly the length reqired. This problem was seen in
IPSec use case when the kernel provides the scatterlist which contains
space for plaintext/ciphertext and TAG.

The problem comes when the scatterlist is mapped and sent via DMA. The
K3 UDMA sends/waits for the amount of data equal to the length of
scatterlist mapped. So when the last mapped nent contains some extra
length, the DMA keeps waiting for the extra data and eventually times
out and crashes.

Mitigate this by copying the nents to a local scatterlist, copying only
exactly cryptlen of data. Note that this does not copy the whole data,
but rather only the scatterlist mapping. So it is not as penalising on
performance.

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
Reviewed-by: Kamlesh Gurudasani <kamlesh@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 145 ++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 76 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 6a8fbe67ef6cd..be7ec62ab2513 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -108,19 +108,6 @@ enum aes_ctrl_mode_masks {
 #define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->dev = dthe_get_dev();
-	if (!dev)
-		return -ENODEV;
-
-	ctx->keylen = 0;
-
-	return 0;
-}
-
-static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
@@ -154,19 +141,24 @@ static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
-		return -EINVAL;
-
 	ctx->keylen = keylen;
 	memcpy(ctx->key, key, keylen);
 
-	return 0;
+	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
+				       crypto_skcipher_get_flags(tfm) &
+				       CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
 }
 
 static int dthe_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_ECB;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -176,6 +168,9 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_CBC;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -184,24 +179,19 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 static int dthe_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int ret = dthe_aes_setkey(tfm, key, keylen);
 
-	if (ret)
-		return ret;
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_CTR;
 
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
-
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	return dthe_aes_setkey(tfm, key, keylen);
 }
 
 static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
 	if (keylen != 2 * AES_KEYSIZE_128 &&
 	    keylen != 2 * AES_KEYSIZE_192 &&
@@ -209,15 +199,12 @@ static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_XTS;
-	ctx->keylen = keylen / 2;
-	memcpy(ctx->key, key, keylen);
-
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
+	ret = dthe_aes_setkey(tfm, key, keylen);
+	if (ret)
+		return ret;
 
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	ctx->keylen = keylen / 2;
+	return 0;
 }
 
 static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
@@ -340,8 +327,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
+	unsigned int pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
+	struct scatterlist *sg;
 
 	int src_nents = sg_nents_for_len(src, len);
 	int dst_nents = sg_nents_for_len(dst, len);
@@ -384,38 +373,38 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	 * We need to handle the padding in the driver.
 	 */
 	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
-		unsigned int pad_size = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
-		u8 *pad_buf = rctx->padding;
-		struct scatterlist *sg;
-
-		len += pad_size;
+		pad_len = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
+		len += pad_len;
 		src_nents++;
 		dst_nents++;
+	}
 
-		src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
-		if (!src) {
-			ret = -ENOMEM;
-			goto aes_ctr_src_alloc_err;
-		}
-
-		sg_init_table(src, src_nents);
-		sg = dthe_copy_sg(src, req->src, req->cryptlen);
-		memzero_explicit(pad_buf, AES_BLOCK_SIZE);
-		sg_set_buf(sg, pad_buf, pad_size);
+	src = kmalloc_array(src_nents, sizeof(*src), GFP_ATOMIC);
+	if (!src) {
+		ret = -ENOMEM;
+		goto aes_src_alloc_err;
+	}
 
-		if (diff_dst) {
-			dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
-			if (!dst) {
-				ret = -ENOMEM;
-				goto aes_ctr_dst_alloc_err;
-			}
+	sg_init_table(src, src_nents);
+	sg = dthe_copy_sg(src, req->src, req->cryptlen);
+	if (pad_len > 0) {
+		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, rctx->padding, pad_len);
+	}
 
-			sg_init_table(dst, dst_nents);
-			sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-			sg_set_buf(sg, pad_buf, pad_size);
-		} else {
-			dst = src;
+	if (diff_dst) {
+		dst = kmalloc_array(dst_nents, sizeof(*dst), GFP_ATOMIC);
+		if (!dst) {
+			ret = -ENOMEM;
+			goto aes_dst_alloc_err;
 		}
+
+		sg_init_table(dst, dst_nents);
+		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
+		if (pad_len > 0)
+			sg_set_buf(sg, rctx->padding, pad_len);
+	} else {
+		dst = src;
 	}
 
 	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
@@ -502,19 +491,19 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
 		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		if (diff_dst)
-			kfree(dst);
-aes_ctr_dst_alloc_err:
-		kfree(src);
-aes_ctr_src_alloc_err:
-		/*
-		 * Fallback to software if ENOMEM
-		 */
-		if (ret == -ENOMEM)
-			ret = dthe_aes_do_fallback(req);
-	}
+	if (diff_dst)
+		kfree(dst);
+
+aes_dst_alloc_err:
+	kfree(src);
+aes_src_alloc_err:
+	/*
+	 * Fallback to software if ENOMEM
+	 */
+	if (ret == -ENOMEM)
+		ret = dthe_aes_do_fallback(req);
 
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
@@ -1240,6 +1229,7 @@ static int dthe_aead_decrypt(struct aead_request *req)
 static struct skcipher_engine_alg cipher_algs[] = {
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ecb_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1251,7 +1241,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1262,6 +1253,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 	}, /* ECB AES */
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_cbc_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1274,7 +1266,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1284,7 +1277,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CBC AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ctr_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
@@ -1309,7 +1302,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CTR AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_xts_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
-- 
2.34.1

