Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E54C30DD22;
	Wed, 30 Sep 2026 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773206; cv=fail; b=uLkTON6wdzlJoHwFLpV/PmkDfNYUeomYERf15usuizpZT5Img632tyy1x25/hUqNqNeYt7Td369ZV7zS1qrpdaubmgauCNBuYyfNWTwhvVLT8hGrD7Hc5qX5qbwXIXsWYIgd6vpXsSWc6zGPFtUbPi5SrRZh6tBHIQ2rtWywia4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773206; c=relaxed/simple;
	bh=14+lpbbjuBYbleZZptnnErmVsbsXKn0WAKM8jdF9Cmo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HSZEmFc83yKLQIwWDbV5CWwI/KGlYqIStF4LW9gizK3V+z7c79s361tXJcvJ/IGwZRWX7Pw9h/pSiocy28D2iVCyl9V9/aLK88gIzwsv6SELXLpkmVHksormD1y38aiCwp4bmkSczPjuNuRj4yIEQVOHd7IzImaTvSYC1e41Nf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=CSTxaPLl; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=f0+dkJV/; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="CSTxaPLl";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="f0+dkJV/"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5h0f3552586;
	Wed, 30 Sep 2026 07:59:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixU
	u4=; b=CSTxaPLllbDKhcuDYnwN/REnfP+qmCBMVcGXZlXe99FtnqxZlfpJ0GaQg
	z69g37L2HU0C4OOpl1j/AYLfUMxO+hwJln20dYRiAY3lSBLlamREhLVSyrqJcAWH
	c8Fc115o5UJiE1mZQqViN1dLgodPS3pxAGfFDcnr6/8rzjDZFVRk4Oxym2dc061Q
	fiejaG0KsJrH4lcXPnVp3xdhApak9FkW4L4P//glG3f7JBTjI6Lg56z0M04niutc
	luIUwYmHCxdt3QPuPUkrLSwZSKix0j8Negy4FrCiaM3bD0DeMkImIpgFWb5jj7af
	5MnUr/OsDaZfGA1/BXC2ol6VW3Arg==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013055.outbound.protection.outlook.com [40.93.201.55])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s20qqv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:59:51 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W4z1SJLq/Ftx+TBBLSmtCzAUagywG6p8kMwvcwENnHICfizEYPiAx106nOTeZJYeaE4mNayzwCGuIqxIgPa3jZVVLuLDM8ml+NzSWQVtVh7WKr8ztSMnqVIoYtn5MdilGuTDcTnFNPt9MCihlRLp/vWt9YhMVjAKaBWiol5NQi7UeyyS+8DHmkyT7oDhFF9ZVZHoVHRPlHzj/oTCr85h1ZiNPFDicB643rnPe8qLivGAdV+Nkljj5nd+fn3eZQePoMgmC0JSaOz8DBj/jTk8mcG80Up1HKQdHsPvU4antjm1psWl1LOfaZGfiCrmgMSUw4WfsgKCCeDpdBIdgOHKZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixUu4=;
 b=DARNsH0ozP0FlVA+vIeZlz9oxNqaLUOIYjJ7zOAYZe7X7yJSvHSiVOIMjzD5eTGxXlRUH1m7tgeA+wU+ySOJGsAh2KFO8L0ShLGzcZZeja2kzjXoOlZlX8/U9d6A+ud4ivlUG7WddREyyJj3jbQVrfwq2yUq99DpDO8nVdHCgmXd1A9wu+NP3dDw9BgW5ndU2bBXQuktSRr0Qdda9oMW7ocafaHrLicg4yOvbGX7c8RFU38TOB/1UbTWUfGvNCFRm7LjLNsI4785tS0P0TJPdHZK14k6FmLon8b4Vv7UP2mG73BP1a/lEmUDXQT+UvjHEZ+kdFJR2q2YAHou1DcZTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCBqois36VGrEk3wC02QqgtiaiTky+9IMvxqB6ixUu4=;
 b=f0+dkJV/jJ4LPBA63Yw+LTaLGthanQvRtdS/DeT8R0+J8OaBerde2ZPxUROOGW3DiaPuSBwA/yc0ovzZGA8SGxHbH4lCuY9oFu+O0gTou98fFSOF6S6c45dGZn2QK51TclwDF2JUJOEQcpiNlJwWmQ7SUQrxNK5XcstfCMlFYPo=
Received: from MN2PR15CA0059.namprd15.prod.outlook.com (2603:10b6:208:237::28)
 by LY0PR10MB465448.namprd10.prod.outlook.com (2603:10b6:404:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 12:59:48 +0000
Received: from BN7PEPF000000AB.namprd05.prod.outlook.com
 (2603:10b6:208:237:cafe::9a) by MN2PR15CA0059.outlook.office365.com
 (2603:10b6:208:237::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:59:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN7PEPF000000AB.mail.protection.outlook.com (10.167.245.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:59:47 +0000
Received: from DLEE203.ent.ti.com (157.170.170.78) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:21 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:20 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:20 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxJFA3153824;
	Wed, 30 Sep 2026 07:59:20 -0500
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
Subject: [PATCH v7 05/15] crypto: ti - Trim scatterlists to correct length in AES
Date: Wed, 30 Sep 2026 18:28:49 +0530
Message-ID: <20260930125859.1749849-6-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AB:EE_|LY0PR10MB465448:EE_
X-MS-Office365-Filtering-Correlation-Id: d6e82957-b3be-4d7f-9cdc-08df1ef2b51c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|10067099003|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Sy+Ggxb1MtM7ckAZDcc3KJct8wO603tB20tTuWWOei7bITn6eHEBofoVVHmiGuMvlKXj/1sKUTixSo5+UjITXY5FlSL6qDJDLLnPbPnVr0L+a3Q39MawSULNdTsmeocZ5J6Jf4vF0Sa0SmpIwh8PqPYuDc3kKZYN/ss89N/veZPvY1XvTvb1Epqr4LaB/0IYeyHw/HukBbVvs8K2eISfZHIY7DnZ4/ZNMF7adjR9RZnBFaYQGs5tZKbBAASZkYT/2PkjDuvvPStTz9Ote6pP9gIBo68Dkbuw7TWaGC4HT8Y3tB/QbJmF+V7LCDUuJ/ByGNxbTP4CvRSMc08fy3KFuUAsGhd5OsGJrX9wuCcdS5WZD0EeauaiC9CtZagZ5tkdECc4vdQLb0ZLOOfn7hLf01Io17gY/ZwBCGfTe+SNkjVsUMI3YybOwCLD6SflTtuheNFBiVPPH8zoTTwocrqYjx6ZKYLXonlBkeBXMZRFKRHhLTbMGZEch9uzz4bw8nCJPEifwuwv1TuvZBUE2TQAynavKouLrJLT4tpx18NGYh/zzfBa7X+a3PNbKllh/2Hf/Cjo1vPTdw7IEgIndufRjZ7Om1WjF79n6b3b6nD5Jq3qxL5RnnlX4VNWu7rdwdrLuWF8HtQLIh8yUOBkJY91QCwVTITjWVKGslPNvRK82N5OFMd/6CgEcA2R5v5zwk4qL73i9at7ejKkL/BuP60xPg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(10067099003)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ceT+McU9yTvKq/59PQsmWt4jh/YAoHj4nj4ysyZrFAc5MMeRIKtHxM7q9A5NdQfGyKegj/0OUkd37ftiqqOGfURyPpysQyCTujxLsfYwzBk3lscPe2GveHglvZ2UqblcuofD+ksq9E2q8AYPq6glaTNjvaXuffoDLn/iff4Ty1dwfwE128yE8EoAciW4YiN4r7JEm0T0qRhhNCiumhhimLPjdBkuzjG9Ysib6VTXllpNxe3B2YsLxBUX5BDzRfQMN8IUyp+WOmEVfPIGoQlwU9Cs4FVXdPzCbUxy5aQYn49Z0GWE8RLiGkwkHq518C5i4hdho7jSCxZRGE1/Rne9fW4G7STDsS8rJasyJYII8Z8JXnZcBQcedJG/GsirAOXl/9Ji0JavHJwqz06iWeowhhLa+p6enePvknfxsMsFP7rhCx1ehGCHnkqJacXeyHjW
X-Exchange-RoutingPolicyChecked:
	012caVeCnjhLLDd3lGZlDfTTVEEGu4K95rDp4h7e3ChZJzYGHB9eCiFP+fCfBlc0pldJnQGADtgCKsrhQEHdSlFZpszqKc1kjBUHVLzh289oNbdL+t6lKZs43oFVfSVdwMXb3twEwdmbBRZk75fwYBRDAC92GkKR2PpDTu17k8RUNN3qFhlVxqMgpuKzlzqz+s0LFKbk/z+V+bxSA4jz+5bE1p1kT8wh8YVzeXyaCiS+xTber/J2ewjoijLxej36TvkTo/V1TohBA4QAgLmvULgp7JCvL0z/Ppp+kIMV1OmNp0n9spz3Ldrg7krI7ArdeeKgkR218UBk1fL1tI0RXA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:59:47.8226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e82957-b3be-4d7f-9cdc-08df1ef2b51c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LY0PR10MB465448
X-Proofpoint-GUID: wCj3ccVkXqpqXun7HDqTAN08SAdimwSp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX/XwrbjKCDF6R
 GsyBPIMl1LYFJ1+TjqNoCE1yRFqfKw+20KG4sUxp65Qo3XffKOz4gdV1yRvqpJZzMqnzOTlTWyw
 J8jBRBfjNV7FmxqLAIPcWOwK4VlYKTpUcrjLep+Difs2eCHxRQjqNgiLTGvGyTAQkXTe4zyCaQ4
 QgFa1M2lp1GByFx3Hq+TDs0dbsjgcsGZe5W6dOCl2sEYS1trvSi7fnoBSCyP5HaLidfsANtHiCi
 e65FlzAm+Q8S+7pBP1OX1+E2F1B+jGZY4hU1mFSutpsEST7jEcvMaEW+7cVgOCju0lR7PUHEBvU
 ArrsTmfy9Qf9eYsFDehyiEykCLY88m7xZ4/EHNiXKKv1LBVaxGkffZvNE+gRXKEHyaReKms1HwR
 Twykd9xYq4bG/LAWihQtF5JB4IvBQ/wUZnQG27uZET8pTitB60KlETWuPN3+/YlUIgrF6eFucCm
 1LoMdBwkNzd5e40kdAQ==
X-Proofpoint-ORIG-GUID: wCj3ccVkXqpqXun7HDqTAN08SAdimwSp
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abd07c8 cx=c_pps
 a=lT9N4OFqmOca6tf2P0aJdw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=Tpn98H0sjD_mw3BxSIoA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXwj9ewYZpF1pY
 JRI+ScC5bM9aorHpxcDKmQGHgIC/598r3TOM5svzK6tFLRpyMxSiUVaHBJLA8lhN46qlS7Isgl/
 ikIQEsZPdrF6htZ4ezo6q8lPvqtG6Wg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

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

