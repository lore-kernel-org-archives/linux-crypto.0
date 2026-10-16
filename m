Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14864A8A2C;
	Fri, 16 Oct 2026 12:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154796; cv=fail; b=m6E6G8jK/IudJi5CI26iVQIL0eyaAVevB7ELE+mJ+gzDpzg5rwPv+aN465HljCYjWbbE0wMPjD4mwk4MU0ylbnrh5W9nt0WgkIBc9ThDkTK+XuAWBL3ofdrrZvHTBGb4TF9hZ69GNZeGflbjsVgrItGuMpYdAOeZAO4RqbSNhjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154796; c=relaxed/simple;
	bh=2ZFeHgvDd9zsO8LboNh2Zby9keNhh1vjlhrYROuwMfo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Le+fCDBfqF0rAyeeJedF0K4hZSNoEtTbkxM3LeXl4mOLxNrOq5uXKrceHy7YgYOOFTWky4cgS2Hpxn9VejmcMGfsJumtALJMKXdJS3TUVGb0nUOpruBK0vCgNlCI6iTGLAqpQ/y/vK0dfxztG2SOhV6grRIbMHeU4K0DXBuzWl8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=KQ9vF56W; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=XSbm0pfw; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="KQ9vF56W";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="XSbm0pfw"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACkhi559681;
	Fri, 16 Oct 2026 07:46:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDk
	PI=; b=KQ9vF56WX+rz0vQXVdvWAVgzQ5VbVDVE/AE+haGtcLxczKIM8w4jzHFtV
	2ABkayJ1PN8e3szUhbrzPxlfcCZ8H7yNzrGCcipiWcsEwr167bGuIWKbvnbXHSFS
	aBnQ3wNEtA3UQgKXTLbPUzix1XxwSuXzq3ZcEU3dPd7IUurE0qa9FQvQ2SS+TTpE
	0AX++Ux2KTvYQueSgsP9SD2COgZl9EaB6W0mnw3oZyxBiQflxRM+yQFkkhgnEjR7
	oK7WjwS9EMyK5u2fyBRalpMN9Y+opLYFjJx+V3UgOJWS5NW2cAx89ZGN71GFHnhV
	SZhlxuBTXIM5k0Q/YlKahmgC3X1AQ==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012039.outbound.protection.outlook.com [40.93.195.39])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhbd8sjq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:31 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nd+IdIazviAB4zXBv71vqOqTrCkuKh6ihf2/UU5vn/datAZXwp87B0DurSTWsZHB4XMfGjOm2ETmVs0UkORdePLcm/1RgFPfLRZkdOONW32vH00LawvAfLqJOTxU5/dc+fHrm5mK6v8upFt3R3wmjO5F4nSiI4FEPFeLJd8YsPtkML0fmaucvy6r0oxRDGBi9h1acNAjhmL3SFO10Y7rfJehDbEwMMBmeV/TuRwnxCqp4cU2ytKWzSaGG3d0UrTO5zVzmaSAHRd4WomzEpv0wwMSZgocRFjWXOX5BRrNnZq10W9pkgQb39y1sJJUlXDPF1HbtdP+zOvlfvodIujhaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=D5kjC6iQ46FNOX2WOznWPGV2IhJBdAhx/UgzxxQVrDOVmpo8Qzi84RktOV1VOu5duhpMfhaaW233NFJYix6GF5kyGagbhNXSqofata2/rtvGe+SlJ4QWhKd4jh8vvHzLjsZVOx3Qxm/eZged8+HcB/PzyOFLUy8nCjdOVbl6XgWp9KA3jkQrlvNcl4Q5StIiZZFpxzsFOGD2SbjMY49n+z63+2eYfQptO1GfFN4N/dqbN2k/QUvDJ0RFzln8PH+7pFO495O+Z2Xbcvmc8FBajf5zmWxSxFgYj04can47ZZkFLWTthh8tHZLF/vXsoKik8tEPXcbOVJDjeA8gQUUijA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=XSbm0pfwyLEjA+D7qpwbSo1wXHpT/jAWifbIJoi2Mk9hgNl6lYKztE3R8XGXI5dlTFF/TLWgh3YvV0rcACgXc+ZsNz7MrBS+Y6f0he3vxHrz5Kam5DmovzuG2I8fSSvzaraq6omvOg2PutfViTBK/JGUIrIVh3HsH43TxNo2Zqk=
Received: from CH0PR03CA0408.namprd03.prod.outlook.com (2603:10b6:610:11b::9)
 by MN6PR10MB8192.namprd10.prod.outlook.com (2603:10b6:208:4fd::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 12:46:27 +0000
Received: from CH2PEPF000166BF.namprd04.prod.outlook.com
 (2603:10b6:610:11b:cafe::27) by CH0PR03CA0408.outlook.office365.com
 (2603:10b6:610:11b::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Fri,
 16 Oct 2026 12:46:26 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH2PEPF000166BF.mail.protection.outlook.com (10.167.252.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:46:24 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:39 -0500
Received: from DFLE203.ent.ti.com (10.64.6.61) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:39 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:39 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCjbLM1588042;
	Fri, 16 Oct 2026 07:45:38 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v10 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Fri, 16 Oct 2026 18:14:50 +0530
Message-ID: <20261016124456.1802080-10-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>
References: <20261016124456.1802080-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BF:EE_|MN6PR10MB8192:EE_
X-MS-Office365-Filtering-Correlation-Id: 28c3b71c-de37-4a83-c07f-08df2b837ce7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|23010399003|36860700016|82310400026|56012099006|261009223027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Avywg5qrv/t87+VuETEFUcjQxYZIaLXNbtmcl9cnFvVnad+B1RJsEXFILsPMVUrcaGJq7LemDYLZhEpVyIfKW/5eYm6ebdKHnTj8FScdv14PhdwKamX+mVq9jOCfynQZpp14dMnZdU9OJUoj0pg++gjaXg87Ygb87yx4eUxUvbc8Z9bqzsk/CrBq3jMYZlKbZOuGTrXJyUAP0kpxktPrW3ymCvC5q6Sz9xFG5SMkjmtzFCzpJXUruuv9GabWAvXS9KqL8EVcdVx/lbt3sL1zA3jqIZlbx9zaFc9MXS5u2viHlxOFJ2ltTJJjUmf+/hNIrJn0Q7NJUAEXIoUJUdFmI//rBwizCWp2wGWQN05TccWuUWz7I7QuTtBoIPBDSRF2GckLw/0ldrJJrcv/QtzeU2hGDBduFrupPsSTzgCvRjUFceov9h6jcJYGjX+L35W/usPnkNCYX8nf39iHMoTy3S7LJ1geFmfLVzltouziwge51MsMBQoB49mDquE/FllxOXWKueZgDBLHlr3fbJhl//ysLOVLybps/ZJeT/mbuyrfBDnnr/28tNBNdbSrao7Thrw2BX/B6UYtsXC9T4nU0UT7bFFd8OYaZ01MbqSHB5p0p3aO0jJDAxyJB4S3lCtthif1YjnaJ3Inlfj8y9ieM/LkHJy14kTlvDLJT19ZXb1Ugqfl931TNQ5Vv+4Pw6zHjHUqOq+xfBgzVOFwcYhB4A==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(36860700016)(82310400026)(56012099006)(261009223027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vbLg4udoTAL9hXOrTlpY1eR+qvYFA7WM6RpakX2SyRReSngOoRBULKjgyDhbop3O0sT9jvWjlSMKQFfPu3BoR/GiROkXp2hKToRGn+Kfts2j69c6sKxFbf2/yaDYDCHGPT8u2BvPbCyM5F0bUrRZGkjPPaRLRxpNWnSafPoGnY9T8Ur3Wg2qOlWkvCw8YIb1BrbsUQk4BBpiitup8WZeyK+PLFwuamd0L/DCiWdtItiw4U4z7hTNa9nI5Sut04eWMCs7lHJRRBU7AKFPOKKwO6Pwfe8tF3MXgG/N9zxSkgevv9t2FXrcGzCBkdlkEmdKEuSQ3x23avQW+uUNgJChsfuxwh+m5D4v0mZodc9i6sMiJ3HOSML2LUMHaqFjO36RoXhHwSfZIqtc1KlpnPXR1tSL9AqZQq48j1LBSSGd3rOXMTzf29lymq71EbPo17bc
X-Exchange-RoutingPolicyChecked:
	4OdEzpG7v5/qJTgcC+/H6ObcxxXsv1dovxDZhKS3Bp0r+uHqkJDmvNeLHBj9VbUD4o43xs8KHdhJYdUxIDUJbLqPw/2oIOMo+PS6QlTtd4Dzt27SMsM/AZaGzOVAqG8nmwmdWCiswvxCll/qDwpU87LtVo6eWNRC3y2bra3EI17W8LjQM82WfNWimoSocCo+/omuWSHMkO4GYKeDZMyU2udb6fUlPaSrz+bDNvyu83QN9UP6i1M9KqWtah3RbRuPbzK6x0Ekfi/q6nNP0MW98JWJV0pVLjr6/VsNNkH8uVUq7ebDqsQke+LO7lgqXFZgWhD/+ROOsY1zUVpc2m9/Xg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:46:24.5225
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c3b71c-de37-4a83-c07f-08df2b837ce7
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8192
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX8cw8CdbiFopN
 +Wr7dKzfCDHNyHfG7mEwcws6H0vYCWCfnXVvh4TBcJWxaviZIg7VJmdL7zFJOXLBPBcZF964t3K
 ZfeszgG549c99OTLHDAYcYJHCpsgj4g=
X-Proofpoint-ORIG-GUID: 1MruR_T5p092Vit6Q7UYNNShRv3-8QbN
X-Authority-Analysis: v=2.4 cv=BooIUoX5 c=1 sm=1 tr=0 ts=6ad21ca7 cx=c_pps
 a=zwUidnFXtIpczQ2t7519XA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX96H2mlrbKnm9
 3LBzboo+RwDMx8sdcJ8SpgsUHvJGeIXMl8LeLhLA4tYx1zIbZKg/1xZ79gZLTggxHRaRHRdu0EV
 cZGga5S1AjPlvQcMdM886qEycAK8NEHVJ9xY6HiQF/6XqbmskXHoNp8P+06eGsB2ul3rGKb4be3
 xqA5PNVQ7LWzJdUYLUxJY9GOX3oLDXrS6JfRuqM3Us2bSPIi8kogBEQm4vdD4hc198llMXbZV77
 QvceauK0K4VBmcwobfTRhbNit5+/bSDLz6U4+t8gI+WVv9lZEWZzRAFwH/6YHZ0Sc2R2BO/Q56n
 XMC1JbTg5QGIfhIIapq3TSKyR2UXmOSQXd6mp+v2K2JPUFTJS4jJAPV7O7XpwzaKKyYmQDuy0Vp
 uPPMbzDSYYt/FAuQNMyA1UfPL50AGraa4VLx/i6PlzoL91HJNAw8rt3c6xuR8fpca8y9faemdO4
 dcCHFYBpZiUYGLjxuTQ==
X-Proofpoint-GUID: 1MruR_T5p092Vit6Q7UYNNShRv3-8QbN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 phishscore=0 adultscore=0 priorityscore=1501 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160050

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

