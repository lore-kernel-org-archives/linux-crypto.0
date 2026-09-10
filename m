Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C52439F99;
	Thu, 10 Sep 2026 10:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037002; cv=fail; b=kVgXnpIV2i/nld2mq9uQvaUPyThbe9flDxJyl+cYZgNqHXHoxAZ6iCyKGGn1FzJPDjiZHt+15ah+io2ao/OH+p1IbWbGKk+7Ep2AZ1FGNBnG1vJbof4tmDYcqB7yl/RY6axebDSoUAs9Ph8ajOoG3MnYNZauDwMH05jbsicPii8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037002; c=relaxed/simple;
	bh=8AiEGfb8lJzH+XTUake6thyKV3Zd4kzDjnDYuThYIjo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aXmOaDjKfmD+ICaPHI2PPN7USChHTgsL69efShXmRVH2yzUNE24zt4K0pIMChRRK8omsKEj3qQhEv9+DdkeszmRCXykdknxECQUalwTQrBqB6FZqdsCMba+Sr5RuQD0sPNtlfkGr1a4B18p7AGgWTnQTgdMdTHIow+33smmNlxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=K41BpiAW; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=DwCeAyNE; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="K41BpiAW";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="DwCeAyNE"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A8oGeH712608;
	Thu, 10 Sep 2026 05:43:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT
	7Q=; b=K41BpiAWxUsR/IvQkFewhm8XzkBLh07yO4tm9aqyPhZLi5CR0vUsS/5Ir
	0G15EqCJF1oaZYIUOEJn4tglR/qbx619sjiqSXlBZYSftHwlZ1VHL3GKvFmZpFWG
	VcUIX4/+1aLwxxXDWWIkupRWVYJp/H/5Gf/wj4e8Bx8axnCJavTymMq24LS8MBgg
	fThmScMw1l8G/5PvC0dpU+E01XEKRm8iJK0qWlxvgUXZGH+nhhuaPgbNxSfD70sM
	H3hA3l7dgBV3tfRg0fGQtS8v+Scjig22u8gEEBqnTCnZ7zIM30KLQVKNSLYqox8M
	Cl6Zrvm+kB91sc+c93gCf0ndSH9aA==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011044.outbound.protection.outlook.com [52.101.62.44])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgcny4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:43:16 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wySa/2ah0ukzN4U/7RtZlusKs6DzCtUboVNj0Vy5nmh01PxTqJQNc/TzmR2vDAKUb+gjKtK9+PG1H1ZgMqzfQfPZLyc4ID/PtsO+eI0ER/WYYhXmn441BmQJXRXbn7feq9PuUuxdA9Y87tjMNP0jnA/U/YJvDXdMuEHlkjIVpBeQhnBf5nk4j5q4DD/uJljlwwZ5PtJ7I6Q6jLl4gTAJqwmgnqmCGqAu8/j0W/y/3NlLfvpRuGvi9lXM0UzzxKiLzM27sE5J/ol5fyfUs4CHrxsM96s0h6fu/J5OMLrJhdLSRO+j8n+lZ8FQsBCqKScCEgH5wDoE8tuVMl2DHfq7Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT7Q=;
 b=Qelfp5ZmrZYGfO+RFDm068TnBbyGqhhwLwEhDo4+KrYH0y4wuIwVQghUzT38lqOXWk7Q9ZtWjejcUYSvyArblDm2g2HV1We0rUo2VNRgAaQYDiQVrlwc2QNISWjvfKWNqrTgdSOMmv8ww3XifBz3y7IHJTEWOtZZv87gA7y3UhzIMxh4OAc3HcqkH2Sxc0BWyFYfsGyvi59vj9nWN+MS85F0oVYalskIFBplcPVSeus7qL5YuFsJaLFfQZFode81jrk0ZsisQrJ2SXne5FRRRl6Lmf280cRj1y8jApwDmDerlR02VNSGXfmwUJqZsFVbYqJUaen4i9JEJLg18UDSTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5beXwKfniW4zqbzhimEbX0XKyemxYErkY0Kg3dQT7Q=;
 b=DwCeAyNE3ssHdD5R3QNGb4DY2uN6PoZ7MseTx1jF9/ihvJv0h2j+fgzRseeOy4/kVdatXloBvEkKm4dCDbrGCHystegqgS/wpDxBAwnf0DyQDP5g8Ll4hi6FhOfZAaVgpuGrdw1SJc3A3Yo9wc0AHUq9NgFGSA/ExOnCmqaudTM=
Received: from SJ0PR03CA0168.namprd03.prod.outlook.com (2603:10b6:a03:338::23)
 by CH0PR10MB5034.namprd10.prod.outlook.com (2603:10b6:610:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Thu, 10 Sep
 2026 10:43:14 +0000
Received: from SJ5PEPF000001E8.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::ad) by SJ0PR03CA0168.outlook.office365.com
 (2603:10b6:a03:338::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 10:43:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 SJ5PEPF000001E8.mail.protection.outlook.com (10.167.242.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:43:14 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:56 -0500
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:56 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:56 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgtH63150518;
	Thu, 10 Sep 2026 05:42:55 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 09/12] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Thu, 10 Sep 2026 16:11:59 +0530
Message-ID: <20260910104202.1537226-10-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910104202.1537226-1-t-pratham@ti.com>
References: <20260910104202.1537226-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001E8:EE_|CH0PR10MB5034:EE_
X-MS-Office365-Filtering-Correlation-Id: 7eba3ee3-c394-4100-90bb-08df0f285101
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|1800799024|36860700016|376014|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jrt289kBdkp010SxejUXZKP627r+SPlq4tmvJLH6pdYCbR9xvz+xSo+/FKzr04ws9Vi0p5aOquXsSZ4pXZ0BvZ8QMqePihDOGd+sejcYIeDOitu0aKbVP8EbaC2ZAF8XaCGICiQZqD6o26HtKg9KQAhUq2Qp1ZTN+My2ZyIuIf7maCGMHVl05kq9JCe4suqqDLJLSyTGZwVcvVQtIoabXN05BH+N+MhBA4RTLwyD6dx63VA+wIh2HGY36inaHi9JZGi0/gOAdqiAjj09S6HWiRhLPm79b9YjhldWctUPbyqAf1KqIf5HzrOfBVkCWurA9X0gioErpuiTySeHjI/Zv4UPQZ8ofcajuW1rtUBaoqTJs555EWJP30jkUjVjKgDV9DQf+5+5JyjTlNeECGw9TL1ZE0cbHMCWrZnOPCqopUhnCjMLnG3JRtQumizPjG6TXNj4WkRbBoa5+yrHM3T37mACB5Uld8cNCiuLNF7SSkDXj4j2hw4jVwpyLpHxsLvSB108RQEJ/5gcj7mbeTiGVZV1DpcPa29YKC0CUz0QON+TNtq/IP3Ls/IHUyl6dvwigRsN0TXjHeCmvgXzsih3iGQ7oNUy1Gc1U8U5X1gs5QiuVmYQmm+KhxtdRQ27s39P+NhEwvH7XJh/lNLYxXprijghXgsOJFAyYnhNsp27DuHGav+q+A3EpRIpBFpJHIg0E52GzfKrBpu+oDaRFQui8A==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(1800799024)(36860700016)(376014)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RqK/7zBxxnfOD1gAYphErnbvFUbAD/Lf5o99IRkoNClLhDff3qj24qb9Gt75YQYSQBGxeXO62qv8ESobS1dXGbfvuL8H7KgupeDyhI1ZwZWo8HvbKhoCNKq4uOOTyIt6h2dDyS1S3RQW2UB/vV9paahrqrFWABPn8Dsc3djN7XMemHT+nAWAMWC9ylqPZs/iM/2tvFkq4mgHn/8mUuh9wToZVqSNxL65UCMab300Lp+vvbw6EYn0oSpnSLFizYyxekIzCgRW8HebW4Kg5mFgQnflYpwfFY2N3NM8ELbDoWwwDdsIpH1gboNCyiQOoKKRhlPT6We+WqkFyoq1XEF0Q+HTxbN4V47OOEehiz0uly4WlubOOm0BLSi6eGiORpqLURzksAZrfuJDi0m+1W6lRHVBgoBvgfYAjRya3DC7voXnWziWhkeVsE8//fUp0ia4
X-Exchange-RoutingPolicyChecked:
	WAMPNP4L5Om3AAaei+wo2SB0Vl/DBJVgrKAl+WrHvU8G2uGLsBEYMQV2Oz361xSFHGcsyA3uSzZnLdnBNtnfmmPC8hzR3//9Ijb2CTbb4HAuy1rLAOSReINQAOol8XLJaW48Q+Ztiroa1ylhHld9Ul+GtLpMYVEqljAPNUry2yBSHnbr0eG8ZtgVNNZP/R//9XI0SK1/APdzzVuD35RpnP6Q9oMsLzk/3G+TJJKRLruXb477KNri3w3C5M80RqVNpVGQNjdDoXJ7rF0T7MAjZh/iEYeE742s9f5pmhu79k5hW7CuwHeBQBKHhQbmG0nDMhXeCwtLrpdzG+Pz9MoiiQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:43:14.0655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eba3ee3-c394-4100-90bb-08df0f285101
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5034
X-Proofpoint-ORIG-GUID: YBtjy7S0r45S8gLkHjrEXNdaFl-6DLSl
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXyx9TGpyz1Pie
 /1ZBLgUd5BXoOmzaJhR5rpB2MJwl1r9QYqjdGMdhng+ZQw7HvQbWFwfxPdYKE9PHJV+js4onoRg
 7iovCy0eqdIqA+R5e6HJd1B0ZBlGyvo=
X-Proofpoint-GUID: YBtjy7S0r45S8gLkHjrEXNdaFl-6DLSl
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa289c4 cx=c_pps
 a=Z1Yvi+W4mc/VVWckEa0YUw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXyyf+x+9bIAh2
 7VjTtRDeW8Pip5RkOiB4/k4aRxQa2KaV1CXIIxJTy2pjqU1CrQ0iNsFydvZwHweqXpCd1aZ+KPi
 3Ggkq8qLgfoQrfdv38yLZZi5ka4/4iHTK6XbV5MJQU5KXv9siob6rfLGpktDWZPoUsWVVziBDne
 gFVXrLHAOxtZ8nFfHriWeCwVkyFdAVM52bIpFxDgZBX834ejdc05uZ7540+Lw/iL3dR7VP1eBOW
 JAxw9DL702KfO0N1u6r4PeB118uteMDobIiblU+uhUqPX8FlXDb496e+TeU+EVAKPBEvMvpUrwQ
 l5FylmXOvzvexC40uGXL1zHVEtVpy/+Pdck1d9Uo0JhSdxIOAYqr37VKIQoALInYpIHXbjdnkRw
 wtuprIb/g2dimcH34Cmfp2lEtbtXCc7e6/ssHlbZFMh/fM+zhS5IirTxvCuNTw6wb//em3jsFWN
 mlfYCzD/a7IeBFLcQHA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

sg_nents_for_len() returns -EINVAL if the supplied scatterlist is
shorter than the requested length.

Add explicit checks after each sg_nents_for_len() call in DTHEv2 AEAD
driver.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index bc3591ec58a1c..65a53fcf80467 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -641,6 +641,8 @@ static struct scatterlist *dthe_aead_prep_aad(struct scatterlist *sg,
 		return NULL;
 
 	aad_nents = sg_nents_for_len(sg, assoclen);
+	if (aad_nents < 0)
+		return ERR_PTR(aad_nents);
 	if (assoclen % AES_BLOCK_SIZE)
 		aad_nents++;
 
@@ -697,6 +699,10 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 		goto dthe_aead_prep_crypt_split_err;
 
 	crypt_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (crypt_nents < 0) {
+		err = crypt_nents;
+		goto dthe_aead_prep_crypt_mem_err;
+	}
 	if (cryptlen % AES_BLOCK_SIZE)
 		crypt_nents++;
 
@@ -756,6 +762,8 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
 			     req->assoclen + req->cryptlen);
@@ -777,6 +785,8 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
 			   req->assoclen + req->cryptlen - ctx->authsize);
@@ -973,6 +983,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (assoclen != 0) {
 		/* Map AAD for TX only */
 		aad_nents = sg_nents_for_len(aad_sg, assoclen);
+		if (aad_nents < 0) {
+			ret = aad_nents;
+			goto aead_dma_map_aad_err;
+		}
 		aad_mapped_nents = dma_map_sg(tx_dev, aad_sg, aad_nents, aad_dir);
 		if (aad_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map AAD for TX\n");
@@ -994,6 +1008,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	if (cryptlen != 0) {
 		/* Map ciphertext src for TX (BIDIRECTIONAL if in-place) */
 		src_nents = sg_nents_for_len(src, cryptlen);
+		if (src_nents < 0) {
+			ret = src_nents;
+			goto aead_dma_prep_aad_err;
+		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
@@ -1014,6 +1032,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		/* Map ciphertext dst for RX (only if separate dst) */
 		if (diff_dst) {
 			dst_nents = sg_nents_for_len(dst, cryptlen);
+			if (dst_nents < 0) {
+				ret = dst_nents;
+				goto aead_dma_prep_src_err;
+			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
-- 
2.34.1

