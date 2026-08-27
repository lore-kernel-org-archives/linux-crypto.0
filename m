Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E98044A3EB;
	Thu, 27 Aug 2026 13:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837131; cv=fail; b=EGg8xG0ww3EhMKrk/5YYJV7TAU3CqlEQQHiwzJOK00YFwDf3BRr+wRBX56XENXHiXrgzAFG6wqncyolSgrustH24F4eIHQstFgdNbxwOY48AKOTHEjQsnRKvtPpklULXMKptzNGA+aYsvRJpNkMjHE9NGyUKbojxu/ioHL/w8qM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837131; c=relaxed/simple;
	bh=IuirD4LQxH1TR5upgYGqqnVZxVhDQsnxgjt/vrRTDHI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qxl949+dab6JtLbRBWcZKUeYb7jTtTHwWtZFaJKGNjHNo7cWMU8R455dslATGbHWlrmaYMog47nX6hwLsBg1pOhNiBzm8FcDumcAh90qVzVrzTHRIAsWdHibIXToHofIKtI7cIdjV90wqO3x2xrBTOMtREzPdIBp5Y5zAkqEefo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=qAIOtwMa; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=UXRbdG3O; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="qAIOtwMa";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="UXRbdG3O"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RCATZB3085440;
	Thu, 27 Aug 2026 08:24:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=ayxzw1XXXTPkbcWouYdN6ift4PID+VGixCU3+9/b5
	ks=; b=qAIOtwMapo+ODfTEIjJWnUYwzKyiH74csbVWTy8KL1fRnmL5LfUIchBth
	VGVjfCduftFcZmPki/uGgQdEAqTWw6ipxrnjnWqYMTeez6gNaQRXocZ8fege13Jg
	X3kmDsiALcMEuFhVpS/JxCai9cxTJ7VkFvoPsVbGWqFKvy5ekXQCjHCgOW3MlnbA
	bgGEgDNonbwVzaUC36ZvNnXkE2MeWS/jjOCpMQwc2YochzmEokppyQ9M57WGAUMX
	y87jHTuxNoj/mwn5LEUP9Mh9TdlttHpvCbAyJCUGQRgWsWlIIe2On96HAKwtFy4l
	szhN2u+HiKhXW4JfEVw5SRGLz9sWA==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011028.outbound.protection.outlook.com [52.101.62.28])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gajhhs3v6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:24:17 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TzLlJUCpTfKL50UbIcgktIxlAr3C8USpaAv5e4e9bY5t7jWbyXVkSVadv2yiqJgE8KYBVumcrnlchTLo57zYJHuDfqpIytKP51l2pfYhxxvlbkBJtzXJKCA203qJ0TyaxgivMoCpnP7rCTwOP0pmz9ecCACAe+3951QJQcsUtS1RIFv8qJi2v15ejd3ByzcRC3wxQWMICyv44x+4rK2Kamupy83TKJ6sM4tCW4bro46elEucLqOke3QMc4c6KszANJdCIA+neNOaTh2b3Y5k9cYBBNxcXWBk51g/Zh9NPIlUnJ29HLU1kDJmBlDD+5FfylLYdzdTujUDs5XragJbsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ayxzw1XXXTPkbcWouYdN6ift4PID+VGixCU3+9/b5ks=;
 b=SoOXVkmvcqwnQfgrtGyon2IPdp7ULPsR0bJ1zUrHgy2Ik2mpSTAlm1wUFElt5oNCDV7EcbCzFivafW43Dhl/Ig5ieQJwHujf9FOx8yu6yBcjgImunUUU7EQ/YoDL0dbdrMM0AVXmu35sVETs6XO3AKPopx7t+zD/mk/jbpoIUk+i+DXoqMT4oo/H70hg6+nWdLMCbaYgO+RNa7sU2rf6Uk5qNz2rBGwEcamVrXuhoz+0br1H4Mc6omKjp9DY+AVnMKRIOgxEO2DXTAN/lQK1xsc+Y6FBr1xSGEkWmP/iLpDj34zYjAVKE0VUrVEOxSuUyaZtPwH2zHXXomxViqxzUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ayxzw1XXXTPkbcWouYdN6ift4PID+VGixCU3+9/b5ks=;
 b=UXRbdG3OWfjWs0Yu/GDlpEGTO/2gvv18RZm/UIEVz/fo9AloKscDGoaXaVj1YbIcGk0Ni3RPLLQINwdth6cvd7ggoxqaPete1banlGtX6qmv6bStTNnFYLN0yUlv5KRAtbXmrgSOgMBi2l2zTFePwmHijw5fdc4bNr5qLv+CwQ0=
Received: from PH7P220CA0031.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32b::32)
 by SJ1PR10MB5953.namprd10.prod.outlook.com (2603:10b6:a03:48c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Thu, 27 Aug
 2026 13:24:12 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2603:10b6:510:32b:cafe::3) by PH7P220CA0031.outlook.office365.com
 (2603:10b6:510:32b::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:24:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 13:24:11 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:50 -0500
Received: from DLEE204.ent.ti.com (157.170.170.84) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:50 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:23:50 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDNmtN894301;
	Thu, 27 Aug 2026 08:23:49 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 7/7] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Thu, 27 Aug 2026 18:53:18 +0530
Message-ID: <20260827132318.613876-8-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827132318.613876-1-t-pratham@ti.com>
References: <20260827132318.613876-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|SJ1PR10MB5953:EE_
X-MS-Office365-Filtering-Correlation-Id: d1e634a4-3d58-4fe8-172b-08df043e7b70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|56012099006|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	N5EIu67yCIW3DBHJX4S642Pt0+ID19AKxJUKis9615X/Ggdyr6gm07oLVk3BccgCM7nu9/KGkDAz20mxZGW0ZSO71WJAyXaJLmXiSr7/jbS3bujaMiQFUVp3elYIBO0+j/t0caBg3eQkraIJIbAM5bR3tstcSfQ+v3DpFAjr//VGPiZz8NAq0gN5+inl6NXo7Cltm21SZ39IokZohr/FG/EVBH6+kOt5ZhXEyxuGn6STv1N/UZf7RPo+yL02onp8MSAMbN0To+kqOFtg3wuCMFy/e2J5Qf3h4ADVndPthqop6GP3W4dTxaeEXczHeLH6luCT900agU/E6fGjeLKniF5gjX8Xz7av8EirbqMasrdkMDfXWoY4nts8uqrB1tGwNeI6uIXCPLxuM4iNEpSsH/dN6m4rDqYGHuS3N9V+ja6JbnXhVjkJXaCvwq9kaidtggLVjSuK6WYaNvFznJ/HoSWaiMbvLeBEOdj+rdEU07Z8fHtOQkkhZD8mtfgkoj1ZLO5lhL0JSS73yNiTi4GJ2gTnpkjCamvgCVpkX39M6LwVDd2A8/7VXPAPpZP/CFdQ9SZ2XxkT2PqOEWI91d0p+NH1yDny+6iZ6XXDN25QipCVEhM8r1KlR48mU/MwnP4tRoihC/OwXm5WDQE4cjyxNpeRzuwXCbFUlRwr6awqwlSyeZH0ZszvJO90zX4nm4nNFJxWM0k1H/VurDSTtrutJA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(56012099006)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ACTKwTSrjlDSyrwYy4YN1uwey1USuXROj0EGJPtPqWiL3wkTo5Xp9F1XvIv7EmpcA+qZ6kU2AvyRsfwJb0IVsoF6rGuw9LDUEtQnuf2DlhnrIh0N859ANmkCaGKclT8qZS3FT5pNMaLW07njhEiH+Oi5wFHW9KnbFtWqoveUfpiLFjjFObFSLGGtaQlLHadn1odiIELUioEaX3S1Cwu3CLKIb2RVeFDjsWUZF1oS7DOfirtQ7BREwHuom/xz08lVL9bNdd9GkCckgqmOpM2OjZy1dR0gocCzgQ8WkmwiMmOve+/j8Q4WJlXrQsZiuVUDWhPMJKU5knCd+jsqUVtMMUE/WU2dw3Z+gGfsLgndhwzTWOf++AC9Eh0eAo5CVulr7kn8/RuzGw7lYQEXFaokQGWK4P6kOsWul5pz/RCSdzXJnc1JXtjQqy57EPS4ls5u
X-Exchange-RoutingPolicyChecked:
	eU3wAeUW8jVU05+fCHgL8PGZVi7R+fekTMUGsZXcWcp6vr2AEbfm0V4c2X8/ZbPxPbEo/JXDqVnY/vGbj7kFObS/+OHsCIadYqPKRGLYiEeiRU9KxZakfx3dJvU91VKSBwkwhVp3B5pruWaCD2dAOZRrE9dYiWpaTtrCyta+BxnRX+wL20UPrV14APs+3p3qn+NntXv9pGCj9K/DzOAtiwrpGYwcneMhSzNmXbX42LfoQ1VxSw4pcnZBf5WAT5OuhRWc2WRZ+n9m9QiOCRMOgaruhjmtp16v4igd7muQEex8ny53TTZ3yD58bYcbQOfb4duOg3CE6G3iM8Y0FrGvcw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:24:11.4516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e634a4-3d58-4fe8-172b-08df043e7b70
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB5953
X-Authority-Analysis: v=2.4 cv=Fu01OWrq c=1 sm=1 tr=0 ts=6a903a82 cx=c_pps
 a=1ZuumbNKwQvJCYYZUadJFg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-ORIG-GUID: G3pADYX7fVxVH9LWBkblIOIi0Hmomo87
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfX9Ou3JzyKiIjd
 oMSbpXRk7SuOdhDZvtgGkWtlEKy2NUN1d0ZZzFvOM8BP6Yx/vSqyrA4sz6aI+W+iSOFJw8oCpWa
 vLqEzXACsaUq2CO9bIdww7Uhqkoj88K2TuzxEMmkFd2m5jPLAxXG8PgxUQfK7IplIlLTXE1LLdQ
 ZxK4OsJ1we8A7S/FXCq0jZhxkJq4xXTSPHik1x5+pdwCRlS1LKmloWkfXUrSeneHQIyMtHLPyoa
 BtnTLmnQ3O7tg7cUqJ9NWZyOyeOytbNUPh7Zv4YXRlJOZIDoMEuXptMd574EnoG3jVxy3yaxjDN
 XOdM4/CkkNAQxCgNtvQl9RFdFVhGYYSd7SeSBG3pG4vXd9v69J8O5flqxFuWhBkXEFHF3UCWF5v
 0cgsE5JVN2ApLb0Hw0vWXL5r895j/ADmLfFUsnKWpQiAK1Jm9H9xvhMgTQmtGHnWWrPsoWuRTIU
 utbU6XcrfGRCm1Lus6g==
X-Proofpoint-GUID: G3pADYX7fVxVH9LWBkblIOIi0Hmomo87
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfX9JwDsdCZXc02
 s+MIp5irzlUhvRdPmWeigUMhV365Lhb2oapuu3gUWLMGkeYx8Ul7rKjvEaPTT1lsmvi+ezCrAde
 cHHv8MSXOTnygJ2fz1VAPW/4+O0sIWo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270112

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
index 99fce19de81d3..7e7a232f5ed10 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -627,6 +627,8 @@ static struct scatterlist *dthe_aead_prep_aad(struct scatterlist *sg,
 		return NULL;
 
 	aad_nents = sg_nents_for_len(sg, assoclen);
+	if (aad_nents < 0)
+		return ERR_PTR(aad_nents);
 	if (assoclen % AES_BLOCK_SIZE)
 		aad_nents++;
 
@@ -683,6 +685,10 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 		goto dthe_aead_prep_crypt_split_err;
 
 	crypt_nents = sg_nents_for_len(out_sg[0], cryptlen);
+	if (crypt_nents < 0) {
+		err = crypt_nents;
+		goto dthe_aead_prep_crypt_mem_err;
+	}
 	if (cryptlen % AES_BLOCK_SIZE)
 		crypt_nents++;
 
@@ -741,6 +747,8 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
 			     req->assoclen + req->cryptlen);
@@ -761,6 +769,8 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 		return ret;
 
 	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	if (nents < 0)
+		return nents;
 
 	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
 			   req->assoclen + req->cryptlen - ctx->authsize);
@@ -957,6 +967,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -978,6 +992,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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
@@ -998,6 +1016,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
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

