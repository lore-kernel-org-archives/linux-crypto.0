Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4564BB27E;
	Wed, 30 Sep 2026 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773215; cv=fail; b=Fgb1P8Ukh/3bnWWTglCIglt8u13v4kZyO2gw5obu1lOderkDTVEIWBK6pshUUB7uBq7xezeaA98Y+pCNxZiXeCKFsPwDN4qjl16SRBxiekaDf2ToWC8gSfFxqS7R5CEmaYDVyImuUZ4/2IzJeq9OEN4glz0Yqeqp8T6MrFTEVnY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773215; c=relaxed/simple;
	bh=2ZFeHgvDd9zsO8LboNh2Zby9keNhh1vjlhrYROuwMfo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kD6OJsgs7tTZoH4RpLup1ALrJVWzruVicA40G5nQvgRWmaYDT1nC6WRAiirksCglfeG1qA9aOMPQ2D5bDE+E0XnxwOYJlMetk8223IkAPdeHDA2Hhf3fVQd7xi14bGhT7zdKXRdYRfRNhtPp658DjSmfn+NVplFyJaGtW6WhPPk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=EMGoJeyG; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=j2E5QUeB; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="EMGoJeyG";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="j2E5QUeB"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5daM3552447;
	Wed, 30 Sep 2026 07:59:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDk
	PI=; b=EMGoJeyGPgU62SCRczw6/FYDWSFJRwwlSpQHLb/T4pUqDyWsEAUC3qdDv
	EQ/fQcFyOYTVfacWpVKqxTwjKWt6AwFQNgW3GJvJWxhTE6JjTNyHQdx3Wc/XOoZO
	ZoYsWINQPZ9vya9u80XihPd88NJ1NjWGx+nj++6vznyhuzakyDdRENUEQPoFZSnt
	o2SS05PNfYvFxKFfdaswbmdJ6b32DSPYP+Cyof7SkKLQH9pdSXlnKy2aMzq2H8OB
	Gb9KLDkBhts2BWEIlUo2cYy+oUk1WCVaYY9iWrAp2n6he1fV9In0CyQjmd7IZtYB
	Ak3jr1lHMBFKhqn8nlEeaTlTMfekw==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010013.outbound.protection.outlook.com [52.101.61.13])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s20qs2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:59:59 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pagvP/IVwUr0+KKkk5p7OkPN1zxN4vzy8R54M9Xyl+R6yMCXFQRKGLEpzh+ufqJnq1fJOQgXtqbthec+F4CSplUtpzxN1UovsL3pVd3tsmclSuT+GbdE9uWVyZ/vC4G2k9LQei64PPK/2YI6ZOXU6QMPoRMi40eFtJjYqtcNbu8Gu0KFc/gb483zkttz6gNxQh9lnPLgUXH2rloa2MzCwu7SBtwJHOHzr97sP5+lI2BmmiUuqBBFpS8PM0hADOBep2AWP8yjiYVtilomMNZk55FOwUnc/c/gZk8Aq76DHtX97xoNkV+AIokAxGZeRbVWoW7s0tPYSGhboDS6Wmx8ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=cx/rHnF/7ED8a0nR74Sb0A1OByJ3Y18UHXYODo29jD4mgKEX+twT3+KmWykBHZ925b9XeMMsM6sgKk/wb0YrcWoOW1qU6pOja7GF0T8r3cmyiVjppj96d6F4bISQu63E045WjS8tz2NbuoqGnTqhR9B3xyOxaib6DioUb44kNeuJFcXoweggDZ/q9PIIc+vZurwh+h+M4TLrB7TN8OmHYyHTKlEk6NIgewpp0F5LBb5D2cHNBzDlQabjy9HBh2oWjVtJcDtvvxfSh6WCxf5XMp0mpchXVkkZv7natM81wyB9U2aHU3aWMKmfMFDigqjYZfPC5IHBzO87oVEUqeARew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=j2E5QUeBYH43kZLtyAePmOTtgSTpQQhxYZfPZnIlJvXI6LHa64n2cdRxaZgKs1JgjjLFcdjRK3SoFhoq9ZxbdOPeMRcGqEwPNQ0i2Mr7VfTisx4TGqCiaqZdCSR26HC7hZpljWurWuVm1eT+jNLo9KSrxNrLsHJVdccdn8jTyx4=
Received: from BN0PR04CA0203.namprd04.prod.outlook.com (2603:10b6:408:e9::28)
 by PH7PR10MB6035.namprd10.prod.outlook.com (2603:10b6:510:1fd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Wed, 30 Sep
 2026 12:59:42 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:408:e9:cafe::6a) by BN0PR04CA0203.outlook.office365.com
 (2603:10b6:408:e9::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.15 via Frontend Transport; Wed,
 30 Sep 2026 12:59:42 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.3 via Frontend Transport; Wed, 30 Sep 2026 12:59:40 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:31 -0500
Received: from DLEE213.ent.ti.com (157.170.170.116) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:31 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:31 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxTVq4098281;
	Wed, 30 Sep 2026 07:59:30 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Wed, 30 Sep 2026 18:28:53 +0530
Message-ID: <20260930125859.1749849-10-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|PH7PR10MB6035:EE_
X-MS-Office365-Filtering-Correlation-Id: c05bdb48-f42b-4c57-481a-08df1ef2b100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|82310400026|1800799024|36860700016|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	B6U1iwcIhK8/NI+LMKeFQxGgy32G9Q1iMz4mWJfEre3yi76hNQ7+nE9dinTTpd7cp+2jEZLHpwpg/nXimJvFLxwWCPwPgLEc9mhtXObCbwTtpyeFEF4YO5hi2EWrDLQf2yShnVvt0LpZiSDBo/S1PVXjuT94mWcP1HKjdIaplzFhRWKhiR8Il2jK/xXi87HG1B2OeKA2V4AtOzFgwYHVAcRsKJHaK/SiZWMWkiPmvmAMkkMYTHVl6kYkvFbCrjPszbvK4PLxdWu2WABoHb66IVcNHXgGPxfvfZy1A4toY6+OxfrHbR3uDkMMLPRi4eK4AlvayPsN8YWepf1LwRhQ5MnGNy1HmKkzv2qBhq2jATpWyFlGrdwOMXS0pl316hBYlVOWgrjXW3FTiyEmyI7XEsBLpzhOA2WkI2pfdxpBC5eMw2wJ1O9gWptPnS+QcEdZhuD+AeYLx1PRoZQ+7NWg9v0uPI1S4/m5zc9uYj3pCY9z94UjdERnSGhSTYe1yVJSVxGVXBP6DIjEQuD+4nBPY+KSIb42K7I8annQ5dXzDG0ewXvK1ySx/NeoPpbVelQdS9xmkWcsrPuNshZNwP+qer6gTO+/7NL4BBiqGBeeXysVdgLR2Z65i3suaSLjI1fdBO5q3abftLSg2HvqeFIgOHF4uiyoF0saXvyCcJ8yGzIzO42t4RtfCGbSWA+QTLzZFolUMIrke4HfcvT+t2/fgw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(82310400026)(1800799024)(36860700016)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	fJEtRw7XevTf0xGZK6FXkOr6Tw8xkTh4/gKVgf/DFcrdhK/GGj06dHuUvdWjbEUZUMy8SyLXdvRfUlO19rdIScbBTzXNNWZLTq5OQ4NDICca7Jo+h5rR+6JOoSOSumwP2/XxJkapV8v7uIg6vdtVWTRupzFgN1yEwwh1IrSwchPfrgHhmkaHjah7Of44fOGzg7mLyS7w5PLIiTcI00XA7ZUlR3445+Amd/ttR2+hpn7NjL4xznn0a7FSAF7G5sffOitHKEtslDpptaYbGvFLfefNSXzxfFerIopZV3eA+ehhP9xYqCe3mWIcTAS2j/KN4ASMoZoG01qFZXWCm02wssCos5Q7ljal+NsxPWKhw7bVmgffDeyqh7rr1jPBhPGll1Gd+555rSXZM7cyFKhHAlQzZil82KE+v+CQvQW43nqpJJMONqkiQrTqC18J8cWw
X-Exchange-RoutingPolicyChecked:
	KnmEi2kWpi6cENQlM0HwnGQOShxLPIow38WkeOQ6SVsrOJO+ual/YfZcpQc7pfqbIWuMa0ExUBnKX+3zusYTqTvQP1fpU58QLR5NmAO36vzLxujwKZNRwCVjfyIJi5cQYUkxsHOJPwcNm0mNaLusVDXHWb9os8D7ntmclCJBxnNUoG4K+Jy8yLxKhuXcJBR2rxfR5GOUp4KVLhxEmRToPJa9s5NDbGkFSFI6zqJdCDHeNcCPxuOqSDqCRSOln1eQi7gzVVOpFohYRYtA+t2vRx1b2rpjUdZnt09g5jf/f543OV/tSPCrruR5VzpGfmz/U1ZoY0tO4uSbpS5RS4JYSw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:59:40.9230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c05bdb48-f42b-4c57-481a-08df1ef2b100
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6035
X-Proofpoint-GUID: 8UI5oEjoXkkG-pODe4AIYJTcP41UW_us
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXwxw4v2M4TCoV
 8+bJJhjdRO8d8VF53mlC4hbYVKdUs2yykm1Wc/zLk1UMJE8DPh88nJ0zDX3HnxFFiUe/A3eVige
 XAjJujdbSo+Y2OEXkzI2O6LlXrqWYhW4Jbjwf+f/pNlQH7OeohB6dVwGffl0hlPJOlp18eflBgX
 +O4gCeDoC0T/evOYPLpS/o1jLFhPLNVxIAB69QuT7P5m5LzXSGNjQjR31O75vWHJgMxG8p/Mb3A
 LCmkQ5PCeo6NykClVemaVLGwGaBNcMHc0g1JYZkFey28LMseUkD2HVTgQHlLLOnzQNVinhKiwCA
 LXW3szgj+3+qWCS8V0Dfmi/uAtLA6f48vEsfKXm5XVV0q080u1k1S46D8a3EMAxcEvdxanibtR1
 aO+0cJU18Q4tbelaY6mko3Xv+T8dNBrW10gFdGqredPxQJdFExB4Krp+MB9FJxaeXib9CfosgV/
 U8asAiwR8v/dQVZ30Rg==
X-Proofpoint-ORIG-GUID: 8UI5oEjoXkkG-pODe4AIYJTcP41UW_us
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abd07cf cx=c_pps
 a=NgWOhXrokr2/NniB/8N7+Q==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX993xVkqrgz8D
 WMGFkk7yewuTbOj94E5auDEOi8v58OsZAMUyfPuU5qYpDV6VPcbJvCVV7rPpGdK3WqJNgfuqGCW
 n2tA5NZ481tLZoDn3MQSihir0tBtw4o=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

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
index 0447144b77ffe..d75b074ca1e39 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -643,6 +643,8 @@ static struct scatterlist *dthe_aead_prep_aad(struct scatterlist *sg,
 		return NULL;
 
 	aad_nents = sg_nents_for_len(sg, assoclen);
+	if (aad_nents < 0)
+		return ERR_PTR(aad_nents);
 	if (assoclen % AES_BLOCK_SIZE)
 		aad_nents++;
 
@@ -699,6 +701,10 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 		goto dthe_aead_prep_crypt_split_err;
 
 	crypt_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (crypt_nents < 0) {
+		err = crypt_nents;
+		goto dthe_aead_prep_crypt_mem_err;
+	}
 	if (cryptlen % AES_BLOCK_SIZE)
 		crypt_nents++;
 
@@ -758,6 +764,8 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
 			     req->assoclen + req->cryptlen);
@@ -779,6 +787,8 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
 			   req->assoclen + req->cryptlen - ctx->authsize);
@@ -975,6 +985,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -996,6 +1010,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -1016,6 +1034,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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

