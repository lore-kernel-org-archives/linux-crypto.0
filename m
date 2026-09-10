Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA8455D86A;
	Thu, 10 Sep 2026 17:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063027; cv=fail; b=iu42CB4A5ydNkLSZnO8gDZo43IBBoe8+e35wZpzimjySW2ZO2Oag4Uj1/TdqMyRTGzRhv521ih/UKWeAAr0tfkwE8/ufr0JO0tLUd2b9Sp/tc2dAlsGQyBga/H5DNUdf6jMSw7lEGVySK3AtNZ02yPZbEjnem6XhPxyau68+aLE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063027; c=relaxed/simple;
	bh=xb+vL0JDbiPKN7Wt2F5InRrdoz1YYUcDoCoOu4uU4Hg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IXgJKBaXATS76hycx+X5eqtyF/FQEYujevRqLQv8WKbnJe7+cceDNQcREmlEZFONRSgOsFgttRKETE9cQAnulDJXOdmePyVEUVF2/pe46Xh7snRtVgbCTFmArLM1GTOSLNw5F4VMuaoKY+fYiK3LOqXG5OKArI1dXSHeLxJ9QAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=V3vgUCh6; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=irmscqJN; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="V3vgUCh6";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="irmscqJN"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68AF66BA3467971;
	Thu, 10 Sep 2026 12:57:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J
	8o=; b=V3vgUCh6NdZEQyHTmn7BHsw7Vz8c09uE3ipwdvRfY1R+A0/dagBy1FVfJ
	MsaHbuu0I4eDQeiDbYgZMmtlm95uEc3kAyMAEHO7iPqOzhJUfg5TYfNhu2cy64bB
	Gqi7LWIiUzpotw3E2fcBhPK4E9VWb9zFHMTjMH1Cn73vp9e3ICHPEguA76tnQPOq
	fomkVR2yiHV635+hZvzXDSkWxw9r0MudrKXAlkFKbXuQbBwQEpVVPDYTnhbZrNdF
	nof1EpuSPVW63aHX/Vyel3W3S4Dd5O5Mjv9dt/wHjcMCYjGhg3Akp6tP/V4Ap67r
	eLxL/Yow7pWDX3EPj9L3s0TPlmWQA==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010017.outbound.protection.outlook.com [52.101.193.17])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gkstvb3yr-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:57:02 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lEK1aihcjuJsS07MP0CsigEr6JZpEYc7UiVj8oPf6xAL8FWdOsSLwqRK8LkDJkkdbPzFuBYCMfaLip6G5j711u8roWmM0CRE94kEVYq4w+ssQB6nldnSr1NzmU+DcL3wrHnt20nGiK+NozlYjpYqT3SHZNghcRWNUGC1YOHraV4gw3nWK/gAKyp4sqo+UfHa9mb1LgJJIU3ThCBRKYyJm973x1H9RvznyWWVnR8k7gOmuOot34umP/I9HQUtw48eIjnmDoGRXbidL/QT17w7M4PUOLBUrbdjkgV8W/6ezHPlS39wD4HfHMs+4gw4XIXa1DECL7hUKdlhDEULRSf2Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J8o=;
 b=LLNrp00qBNgIeeoUyCqSdp/bg3Ub5rohXvG4eNU/oiNAapC+0sXvkuID6UfHVzANvjilVYGLqzQhB1GTgKtVBroHset/scpB7kU9cUiW16IKA4/4lDxw44G/iDV9Qd94Z24Rlc3RmRo3+CA23SGPMpZnMkMAMBCoAoDH7sbgGy6t54SIigXX94p1WK3SjNopwBQkjProxSm+7Nln81RBn8wzD1ViPjflAiPOC85Rt0oNNGvfEZHsNYStbDxXA+/Kryuc4iDoZwFiqDdmCEtlNNE1xISt+JUlNt1rfCcEpLgvm5QHl5du3dRUWxOL6l6vtM4w9t0ODw+evVWYI77u5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9AAog4xG5I3fqrRUyrRYVntKwYPVthg9NlLstka6J8o=;
 b=irmscqJN0ZF0wSU8X+aIDtAln7WArYxNtVXUyfqWNlqpy7q0EA15RUkID2/5rdOk/5NxOIDY0uDUlMCE5TQG1P2Dl2Ki2HKz9uvt623uIHXHJ5TnHpySxX0mPkUqHkI3iy8eCRanwxtxzvAxCxH5+Dt2kgle35hLaBGqtVHoqGc=
Received: from BN1PR12CA0007.namprd12.prod.outlook.com (2603:10b6:408:e1::12)
 by DS0PR10MB997603.namprd10.prod.outlook.com (2603:10b6:8:314::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 17:57:00 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:408:e1:cafe::3a) by BN1PR12CA0007.outlook.office365.com
 (2603:10b6:408:e1::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:57:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:57:00 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:49 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:49 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:49 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHumWx3763736;
	Thu, 10 Sep 2026 12:56:49 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Thu, 10 Sep 2026 23:26:10 +0530
Message-ID: <20260910175619.2122149-7-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910175619.2122149-1-t-pratham@ti.com>
References: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|DS0PR10MB997603:EE_
X-MS-Office365-Filtering-Correlation-Id: 3abb372e-fe0d-412b-0243-08df0f64e9d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|10067099003|18002099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	BSc3XdVOpQyWsFquucCmtpIhMAvpTKPLJ6NlXoLlSMB82vihcsa1rM6oSgXNgxxWAzU8wyAbLpuQBDSo1HG9+aRSZGFW1Hbg1YRmB77m8RU2X3syNnJv+nSm5kdCv6S0J2wzQajArxxzD2SYPwUunDw8ld+8NrS/0tko96iZJN6qK5K+PKhLHlo5pjSi9N73E/Wez/Z/7/Zg735tM/wCK1QLawNIwozZB5eZCs3O/dGbNvaFcY+XGab8Le87RwqVgjYmWJhsfN6o2BuWwttgEh7L5iRJ3fDVdMVmPbphj/k3AyHVJY3vgetap0f7L+XR5zFrNAYUvlfln4N82bfHe1BhrRWdjvKK54CxgJ9gZ15VXHBv1nV7EkO/QyHUbYosZWD8ycxTC6RgO8FuiczFBQSZBqqdQiMDz4LCR0tbJgwEZDsplc9HgNU7x9eft36NqWYE6sspI1Q53TvrZEOulaV27JSI/qQUJwNaVX/sQ256txNT7D+rCW97fWeOoYl5qX9VURtlk6ITEHfqYPYyjpQwYD5hUiClHJVV7tYXFA//Xf5J45Hxa4Cm6dTUBxK/eLvSVwpDudtde1H1nUanJdcKWENMF9QNKCqM0LrbYBcnGZ3KQ6CUHjG1Vw6fJlKIM0mEJvIRc1EMiAU58/nye7XTALAz+BOpfwzNxx6evAb4JCxLTabOawIwKUV0IjoI
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DxVJ/0sjKUmVgDFYSEC6ldpZ0t1ViXYbnCHXVr8xIQX1SnE+kcXs9eKFqpsg8oqcmLPXTHvENpMUcchlCmiQuWk1IJ9KmOLpkf+4tAg/mbWQYQ/3MB98/0Gu172oeTbiSk8v7VLno15z1UocNCzrxzs3WTtFTtJvw6SssPxJhJtZZT9ZOXE6DKoGUUomXeILP5HJ58LC0Hkm1MNG00gf8Dr201Z/itIQbFQd4LCqMGJ7nKcmKQFOaK1MSXKJI7Us7vyJ79eRFAIP/aQc4mnNzHR2vT8fDINdMqrmS7SosfAcWCjyzGHV9JN6EN6kR6+TIIXv2vKSMjDW3x0Wdx8kJA1l0QQW+uAHhoCASZO/U94MtBzm52+1U4n2+OkoMak6IBqYw/jAgojSoaPCRxJ3bCu51H5x5zZo2zd9gXp+TX2g7rqeHx21bTWnrktXEhXB
X-Exchange-RoutingPolicyChecked:
	SSOoBrdE07GHoGGuNv0m2X7LtwhCaQdpDVDFAnPHhfJss4CAVhnI25Az8YJ264udb+5hJjvrEGv8SZS+0fZlakB81GLwjri95ie4hfmM50KW/ljYeAPkItJpMjHl3knGAyNBYfq14fFOcp4Ll/S1mkdRsOFeudSX7exIeqYLEeZq0CGKYerht251K+Bm/COKuEvYiWus5jEWb31+M0ChkXFC1avPOpDbF7sUteIRrZz/GEEP1w4X2nItCMXlAVa3mfmLuyk685FPBbDWroGrjiOEdYSw2c4QY4OWxYbSznp6E8wEg+tn+iddmBD4gGXcqr/9x66fz31iodgqffSPAA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:57:00.2791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3abb372e-fe0d-412b-0243-08df0f64e9d5
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997603
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfXxDF+LQgZA8g4
 5H+glRU4G7vN6zWx2qPc/8HffbBV3HtI2bdE1R3zEVd8ox56uNtcOm95JUzEGA5oyTQR+Hd8exw
 v2vCkurk3D5UNZq8MwDFalueCPVTWfM=
X-Proofpoint-GUID: AOq3eX4Ee9oNTxtzWAmNFBcEq0Kuwqxo
X-Authority-Analysis: v=2.4 cv=VvG2kO2n c=1 sm=1 tr=0 ts=6aa2ef6e cx=c_pps
 a=ZlG836pX3zBvGR9gn4UHEQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=8TpikKgA1nL99BGwQjsA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX95ytYJ+yqHvv
 1Krjgf3bzEod2sekPQN/TMhrlOHUCu7Fr0kR+8xG++9dkt950N+ugZDIBHVXOunnqozHT0TaNCr
 mqV2idN8sGMZt7lYT355xSNRYVSW2R66g5LtWMbnn58R/NOt5iUF1j/SLN4i9f/httVGujI/UV/
 6aqLEfZjfLf3/4yGcCsbF/X+s5jgOK8bn7A7gNTJ6wo4eWvMTpPX1Up1g4AkTfJJsLnRFDwlTct
 4Hz4kwcoCkUdrbpzJYwX4t53MsZCWacWMk/z9x8URQEjeAt4I9zzRehtsvFaLz1WwkHt06vC7mg
 Nj5mfymwI2ZaIRan/sEGvZfKcULFFh29HdGJ0mJuWU8pLdoez18WVJnEHT/MB7SxSnO+g4dTVy7
 IB4SzFGGOn6K6SNJnoOq1dV+9k/yLzjhjdDqVDZyc1Mn2eaX4yWQoO6vufLHQAg/teVAVor+qfS
 HwS0+egUpqWraTzjYwQ==
X-Proofpoint-ORIG-GUID: AOq3eX4Ee9oNTxtzWAmNFBcEq0Kuwqxo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609100220

Align padding buffer which are DMA mapped to cache line to avoid any
potential cache coherence problem.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index a827817e8119a..cfb50255a5dce 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -114,7 +114,9 @@ struct dthe_tfm_ctx {
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	__dma_from_device_group_begin();
 	u8 padding[2 * AES_BLOCK_SIZE];
+	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

