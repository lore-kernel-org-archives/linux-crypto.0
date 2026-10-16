Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6974A47A872;
	Fri, 16 Oct 2026 11:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151402; cv=fail; b=XXTVo+QleO69QboWRr71I8RoWV/m3MN6ZR752eGdxJKG3LoCV0iuKPlcLvxpUHTg7bp51ny27h35nVLnVKldCHrwr6RpKPD1k7G4GW5Hm9ytmklQdh3HmN4DisXu/n0Eb0tS6U4+0i71uUUQWU5ik3eGH0yjUTV/49OYvSjjOZo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151402; c=relaxed/simple;
	bh=2ZFeHgvDd9zsO8LboNh2Zby9keNhh1vjlhrYROuwMfo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nD/j/MDxQ7ZOW6W31MesGUfwowUFnHb+SCneAFpZDp4x65aMizwSI3kQHIFwGI06E+F3WHtMe9aKJiPbzduKJZRsfBDhN9pOH0DO9w3rKHxbMRQyrBQV+ByyNBTRGIk4mQudcNoRG/f6/MvIOKBQ2SIB9arhG8bLDgqSVIgGNmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=jjFc6CAM; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=AfSOV7Xy; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="jjFc6CAM";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="AfSOV7Xy"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GBQKQc695366;
	Fri, 16 Oct 2026 06:49:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDk
	PI=; b=jjFc6CAMqpu13927UCBZk3JbWai10HrJzAt1nQqjLLRF1n1Riuytu5DJI
	v5F/n5e8Jbc2nrYV/PYfseNRGdEg9TrNy8IiiIG0hkBZA38WFjN45K/WetUizF+2
	IT6J7jEcqEUl5kq2m1m8sPX3LYWmgID6snPagBL/3a5reY42rEkBv75KtLw9OKQs
	Nfa8isuHwUGnCWiPbvkrDtoXngpJX4+A46suJkks5UitAYOdOqLgSSS6Zu8KHpHu
	EpY8exkPTowwKa1C42KNnesxk7jmUKDtlDumR/Su4bCJZiTu4jkFySmM2uS0YenA
	C+i9d4LKzihVYHew07K6/hQnglqUQ==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010017.outbound.protection.outlook.com [52.101.61.17])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8gxy-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:56 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2McCPZg4Se0Z3HmvmjmoYcHXXg8RaMjTDOI1d3H7fNK5Cg/qln1YuKhaUic+S4V4S/aNkGjaOY+R8DssgH5Gfd1/OPKrmLNcUwds70oIPk4nqC+jnmAVlbnBQM/hFYscyjPN0qi/mX5lYwuatyNhxeFsIvp0V6+NEu5WHPtc/HM9M1KVTCUJ6qmwpQosVs+tywXwfStltbHAj6x7g4SkIaR0f2Qzoa9PIoQ4RqNNzUrPVL0fT6NuBDb3FXPDkYz75ME5ByCLPi0FDQMoS8Xrs+ed6x9scHb4FkMdyBLH92Xz1cwXoSanv5pLNYhp/CCfZpgATvDLUfeAmiNLLJHDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=M4hzJaxNFa+w91Elgtb8/LEMJ1ltM0WUzf0wFbA9nBvuiCzQVbcJm1P4Hc5XwFOgXDr9EYkZ/G1DYyQPValiKYsLvjwlFAakgUUMokflRzGg9IOUoIZh/WVxpg9lXOlndu+ilqX9/y1DKdo3uiheiwt0IO+jdprF/GP8WYql77iLYVMIkeglt6afqvEXqlY99H+p2NsvndobweusLadbC6/+A/tS2RDAHckxxHSy4a0yzCTkxP4bLO10n4YzfqMYC+rqTN5Lx363BQo6xILgIhr9SMQ4C458V+c5r1aA1bIbtt1d2nQOw3fAxETq03pj7MPZeGyVhSaMYXwqA/DZlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=AfSOV7Xyt9FS+SbhlZV558vrMCUHv7DPJ5BRUnKKMAEkxO2TMJDvgM+JbosDF/ClpflgyOQhaIX6ai93Ycwc48H/PTk2uxFQQsyrIn0aY8ciWqZWK5Hk2+U2jpd7Spp1RbWMTadS53Ux4TZVQDnaL7FmBNPfnGzHjpEORHDbPNc=
Received: from BN0PR03CA0023.namprd03.prod.outlook.com (2603:10b6:408:e6::28)
 by BN0PR10MB5062.namprd10.prod.outlook.com (2603:10b6:408:12c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 11:48:53 +0000
Received: from BN1PEPF00018074.namprd04.prod.outlook.com
 (2603:10b6:408:e6:cafe::11) by BN0PR03CA0023.outlook.office365.com
 (2603:10b6:408:e6::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 11:48:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN1PEPF00018074.mail.protection.outlook.com (10.167.245.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:48:51 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:47 -0500
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:46 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:46 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmj6o2451652;
	Fri, 16 Oct 2026 06:48:46 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Fri, 16 Oct 2026 17:18:00 +0530
Message-ID: <20261016114806.1749515-10-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018074:EE_|BN0PR10MB5062:EE_
X-MS-Office365-Filtering-Correlation-Id: f4a26dc0-25f4-4ae1-d3da-08df2b7b72b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|23010399003|1800799024|376014|10067099003|22082099003|18002099003|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	xi0dcXmCFIWzDRFTwkBzth8TW+wbboyjheuHLnyAptyHOCB2XW00iXdl/GZ7eGH3JkCVMNWrRabQ6UCqyBkbKtKwfzO02DPno59N07u+fiwPF0L0df6LqEHXUwld+ZPiRJLgIy+9qQj0zgqZJ6tdry9UoscP0499FBpWuiYwTi0fmkSqknw9a1HaPC1OB+6yQnaBnZgeZCu6ASbkA7LOxZBHtAmpgX0xgqVgMkMgb1D+sv8tjxbA7qO8x5liho0O7eorwL3rONNEobMWMUDNpJdohoda4MqRdC+N6e6tZ+7a5ZEPUZLTHkWI1FDzzrbZDihZOfvsQbX523qFax2JpY2MauVLImtoIz5FhJl0futB8NvgLl/vMYmi3rZzPwKs8OQb+kSxJ2bh9v5LN+4Me88sPfUHq++DSAaVTy9NKVNpY13zB/t/V4ri+LDzqOQze0NHCZOXbDTFQZkW5YEFQwt3CujKphDWB0CHqvAL/BGop17/V+Ex3OKNnrVG+GqFw7LpyQ7YuJo2xMa6aRSjzu0sU8Cf2ld6HKtOdYdD1XeMgharlXv+fLy9POf/QLU82JGLR78bXGTkWe2FbiiEqpp1b+YitvG8yhL+ElVMghOAVovskrzVVV8OOGbAKGCHMjuI7pUorVQ0B+Wo3jfytqI/O4bgn8rPAt60+1K9Z/JlTB4+hLG8/+sZL6SgMeB/QMT57tdvYiFZUZ/2oTg2Ug==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(23010399003)(1800799024)(376014)(10067099003)(22082099003)(18002099003)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+vgoUKfMZZGeCEgL5swAtG0pzDztktVuIYpjG4kADLaFlX6R+Ls7LOjBDU1GjxQh4Nxfi8eI9l4P5XUle20dWka5qT7419abAji29Nu6ajWXWK8GNgwqyfLnUYT/iUl0l02q4vzSorgr+39vBU2UfCx3jLvEGLk+kh3hrBnjD4Ul7U/9ODz4rgr0fdOLzmczgL39K5Ewz1Ryh7/YE1+HZC0zMsZtxWQcfq7q2enfvSzHXe1DIjBxwbaU43D+MHvJU/EfmZ3Tacim9S46Z+05hjy/Vsm9Gp7k5hm5BnN4DCJ6K4lHorZlDFdHmL0LOAXoFP5HFBcEj1+22aR9ESS2oh4u7zFPWjoOs13+nPz51pf1asMH1P8PPSrn6Lwr3HqixGMXsqiKevHE8R7O4iwRV7SKivjqogz+bduG5uHQSLqHCCHKkTVYnPaN3B68oP5T
X-Exchange-RoutingPolicyChecked:
	w7YWI0QasmN7TjwITlRNBoesNMs0KEM7izgKpnO/DVqnC6qBlcx1P1aiT1Q+Urr/byFS5Rs+/VyKSDAhUvUUSC/TfvoHAXnsrn//RRakKfKVpOYU0PklZEd2f+XHmYOuThS07lZeA3UTWIpc4ADx3XI0Wya20JFgN7xyo+ExZ/g+mCE3e66vltvwzobIHZykw9ucXL+16WEo8DLG353Wrgh24Mw3OF2dKIbi6c7PbrYPsFeRlW5ABl6ijrXDHUGdH6PyxjHWZo6qOv9RdjtTv/IfoaDEPyIyigDRQ6j4qYX3UQugVbrQuIH/frvckXXSfdwc60nY+f5O1ZWCv5leng==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:48:51.4043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4a26dc0-25f4-4ae1-d3da-08df2b7b72b3
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5062
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfXysqK2p38SqI/
 N1ie9pNsO8r68dKnmhS7rKwSQ4hZSy64XHOc4izCaSv6JFeRVTrNLJRYN7c2oGFd4FuKXholAZ9
 dBr5IE0/DiLEa6E40Qg/xogo0DvXAhM=
X-Proofpoint-ORIG-GUID: qn9G1AAL03kXWao2aVUNk9e8ZMCVS9X6
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad20f64 cx=c_pps
 a=j0s4GuvBXASr6P23UuHsgA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfXxpqyp+kUlGMr
 JQzMm0hPNv5wetg8KgWa3y/1R6VdKTX49JChrn73YBbojwsmWefplLyvuLFk8dYxUefuWPUhlO6
 3kzXFloW8bGEPq0xYv1qQ9Uir9auhdWc7BtHnn/wijyMh1cVm051q2GaWwYe6QKFpJWpjgoORXf
 XCRZVdIhFlkLwEAPYiZBCxm5SDI+z+6ytEIP0Uf0olvgmFF0ck9aRoZ5n7qCvgeBYidVXKFkWmU
 SoLqWfW3uGV3yQadeyhBfbjDEZUcs2WFJngHXLgOD6HOCW4EZAXXWszxlTdbRkC57jKU/TMmoH9
 6WbsD0GXQUC3sGtEv0Yo8TUcS9BAmfX66ZhUXlP5gMi6kgojD8zCbjWkYxH5TEHcVhtbm2c+02y
 2TEDBHdlkygao889WNFCJlk/eDcmpnQ3ubThtjuTlYxMEhl0Amqz8k+Zv6yKyaIxKcbSAX4SDZS
 7NE4qGixVipnHi5Bq+g==
X-Proofpoint-GUID: qn9G1AAL03kXWao2aVUNk9e8ZMCVS9X6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160046

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

