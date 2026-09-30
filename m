Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33189492E49;
	Wed, 30 Sep 2026 11:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767578; cv=fail; b=C39Ws03SNbWIaF3CqSYa+9aFq0M9Q1ztY1bC/PjTaJtuIJIIqNwm8Jib2KJHmt50oDB7+NHQT+e/Sd5FATgxItUQjrCYu4h3t8w+/yN6jHGEx2tJCoZvpAiwL2OPhLKWtc0sp00mF9NQocXIo2ZUlE9dvKnnPVU1+6DUxg1tEII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767578; c=relaxed/simple;
	bh=9zpPK8JkgMlsnxK+gQdFmYtBkD8G/NRGvYjIz4N1AWU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q8jqAg1fgWOLWPhzzekB6KbYLeMnf2nyb/nqrrUbvrdInAmup2doXsKYOYar2FgPB9mgQxmJ+bizBXOpYHF9xCtyz/D57zeu0wN8qCu0wehDyPLQWHF3VeLVO9b6vKMhycAeyzp/ctvJpsCgpnvX5sDQB0LhxCDS+kC/JR+MVdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=GzyFE/s5; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=QGbv9cSn; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="GzyFE/s5";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="QGbv9cSn"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB68VC3214248;
	Wed, 30 Sep 2026 06:26:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=/TDA0JrN8gBVawxNVuij8vd/VXEfeszXyCvjant7B
	9A=; b=GzyFE/s5HoXNBerviIMOucY5KZAmieBOAu2FsqIJtAU9gWRkLcTgvOeXO
	8iygPBRGp/WspzlZ4UuZxovI2F/ys7v0QR7sz2d6nMYZBJ5gk68HcATUnPwTK7zI
	visjTUo8gxV16TkaaP/n6XJYw4Qnj+KTAMG3BjWO6Qivw6gzhh6Zbr4KCUo7Vf9E
	X6ymNTZvrqtmA3qe2ItRZvKzm9X0XTmhOeTA4VeuYeD5MOwsugKDWadpvy7qGsLS
	uovUHBFORYpTFlnGiGo8MIMBMUOebHTZn1uNUfUj46l0XD+j0PcAAuN5mR6IDHuH
	yQhW8UYLXERovBat15XjmFj5qrpcw==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv8q3a-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:11 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bBlRG2ZLjXF+1SseiAW6Y+PQes5uNr3/FCz0ugkQSjOyjbqm5modS+iRqGzOf9z+CAk5uJbJR4HWGvYyDxvFqxOq5G1nCXXjQ3Xy1TTsrnHJVEkJI5gDBGhI71kdh7KgGpLH++bsBmbjcspf19USsgN5KMUak2/U26oSOL7GKOJ9YnoGHcINB+g+qB3XpH4W2xhVg8BzCd19MJPV2XNBvXaB756I17JEiU9Ij6xrg6W/EjjnjYMHLkByMHZHW9x4UsTcWehrImpMxoAAYTrq+8RTmAt2xWdbBfLnl+p/Nh23q5MuNR7zzwgr9Cg6nOv8uTQ+GngfvBNlmxSGLDMU2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/TDA0JrN8gBVawxNVuij8vd/VXEfeszXyCvjant7B9A=;
 b=HY9uK0HoNF9/tIRCla78QWKKzTy4sj/+ChGgzsjgadzNLPLSlPZGnIOU9g+5M8QXlKXR9fFJUYXtTMYkxn5W4ETB2MuKIhYtnQDzfuhyYAHGQa7P8I9k2b37/dZU7g4enYehl8ZrAXPI12uXIqYEpBW5y3fhdIR5DB33eEuaGTPNAcNj7qN+bfHe9SD6BtGucFvkL9YuaZu885/yQZ7eEsGmQsMzB+fdeOsXFAun9ZrVd6y9IwWF45h5geqvM8U0iq/jifMIGGftxScH5fnLHXYi3a3b1IzGHbMFTmWsu9bH25nqvi9ER1dZL9DXLAuemc3e+TI7GRc9ayW9KWVtPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/TDA0JrN8gBVawxNVuij8vd/VXEfeszXyCvjant7B9A=;
 b=QGbv9cSnHEph5hwfTm5FWN6no5zoesM4nxSDdtwZ41l56dPLCRA6xY2Nzy+m+HcVZM0qpReAxgAdoClwJipHv2t2ygYf7rkJD0GyXvwzmNBH5Ca2CO+fMYu0dsI1mcjyl20eTUV5aNVdGmmMcNBiZheXHRxINUnAxPinnveOjuM=
Received: from PH8P221CA0032.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:346::12)
 by PH0PR10MB5730.namprd10.prod.outlook.com (2603:10b6:510:148::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.19; Wed, 30 Sep
 2026 11:26:07 +0000
Received: from BY1PEPF00026968.namprd05.prod.outlook.com
 (2603:10b6:510:346:cafe::2e) by PH8P221CA0032.outlook.office365.com
 (2603:10b6:510:346::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:26:07 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BY1PEPF00026968.mail.protection.outlook.com (10.167.244.152) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:06 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:51 -0500
Received: from DLEE208.ent.ti.com (157.170.170.97) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:25:51 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE208.ent.ti.com
 (157.170.170.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:25:51 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBPnKA3969382;
	Wed, 30 Sep 2026 06:25:50 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 03/15] crypto: ti - Fix potential memory corruption on highmem pages
Date: Wed, 30 Sep 2026 16:55:21 +0530
Message-ID: <20260930112533.1593952-4-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF00026968:EE_|PH0PR10MB5730:EE_
X-MS-Office365-Filtering-Correlation-Id: 462a8f92-4178-4cbe-6180-08df1ee59e8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|36860700016|82310400026|376014|56012099006|10067099003|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	QtBUzRzZusHpkLxC+Lkuy0+yYMI9Y2FAPrIzaT7uQa7NfjVe7tIp9qw8+Gl5fZRHiuW1YR4P3meyK85ksBWceu3x9ZOcuoSwo/t6hBU2BwvuckKdwGvhlKxD+gvmG03jxnR58yPr2AMHlV7RX6BjhJgVfLVegrZRxMSto9qtAVWF0qRssZOjVCkhHPSgS4y5JVC9SvqjNv9gjkGXxgm6utmuA8R5w3o0B6O4TZ4IWcni9h0E6toPP9YcqZVG+9jEU/oNZmcUK6sKDhQ1KZbrXaebw5tcVjU7T+Wx3hm2pYAJVeNP2MKsP0LxAhzs3sdm8lzVz7P663TlY3ajGowwhM1lPoNu2Pwoll0JNW8paPKlWockmSjG6GALPKmox4kjkhYslPoKyMXNjrTukGeH6w49tS9ZvShM4kJ6DOyk5+DWq1Yb+fwa0MZNz+NYDGmUrKLMzi1ZFBtEX+1RtNUOyaRzC9QOz9matXyl+E97qNNidvEMZMlS/mTVCjmiCKy/LY1H2USOHUhdKEaRhVzj+MrhVNxbNmjmvt/cBAFTDNxORzHphgkdJfbv+XwZaVS64srLpskAC8ByqKag5NvDYn9b0sYrKYjnLW7bUKGZENfE4YiT0de5DyEp7zgiZWcaYxN9qO/xvG2jN5pnPW/flrJbFgtMBt3yl3n1vTe54LqMtPwFleZZ0e3BTwbJAuR2C0jK2L5DR1UDLjEoBJ+42w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(36860700016)(82310400026)(376014)(56012099006)(10067099003)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	nX/niXN9V9MCVbHsUAsQJrxIn13mA2GuX0cWndpVOmZY5ZyAxz6rG6VPblVet6m8ny0VxwBgnPvWkz+Gv7/MC72PbgKD3GunNown6KO1QJgSXR8JNGCJPX2upM/ecvWH5VOcWn3fYrDDYgNAEPGxkilUP5UF6FRp5xDxHSkeOyeKlhvQzOoa9ePVPaC8Bi2N4YBwUwbUscf/5ZamuSZQbbFza6jBof3NAhL7vrTGRjfDnrKrDOnonp44KbwwEOpzHXrEaBSV47DRig4Ij+4PGknxtjKkI/gE8Vws0vLB6h81+iSoTFDesQa59tGa5tpVW+IPp8z3Y+VBoHQgYp7JxCYrNJX42wxij6Acv35/9wwa2kYNPeb2TFfCwnMAy2kjQUNKTYXHPa0QGa708V3WuJPRsTJcLw4Y+y3rxCR1aKFibDjhyx3+3Q8aBZxAz9kR
X-Exchange-RoutingPolicyChecked:
	0EmgGjmddm3aFE/CBZ4hmqbs8PbXtRYtotyEU4IjKBqCNtrdyhgMMrBMexvqShwoGJ2nju5Em1tW6dgJSEyn1I9xGVMs7Lmd0JDT6iC6ACu76X2s7BnLAxb3+cuehf2TCj4E4Drs6STmwrG6Rpvl/CtbtqvHus6nf7AXqdkESxp5xxYFFTCmO8A3LBb4p0hfVtWjp9nOWFnntDD39KlJkhMT6GvxghXP+3eMreVmbFC6nU6xnunH5VilQX4QohT2bxjQ6l/px9fhEsJIOUGNRyTgGz+1L58awQ+dIqX8hqWhtChtB6MrZrsr1UlA9wtz7VhBCLoyh1Xwi622CxUExA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:06.5019
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 462a8f92-4178-4cbe-6180-08df1ee59e8e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF00026968.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5730
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfXydi19vsKoexR
 jGY5XYsX7StY1ufS3YtoGpTctfMxCZRrsw12/B4y1Elo8f/cjTGToTK6Droj2J53aYIqBS/uMS2
 6OfzNqpKIOKsLt3fai6dC0ONeZS5ZNk=
X-Proofpoint-GUID: 0wcjYypQqluGCPQ0f_GuktT4AjEWsbHF
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abcf1d3 cx=c_pps
 a=25df8hqnvvr9QcO7WBwFwg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=IXP722aH8NCvtdUuCEcA:9
X-Proofpoint-ORIG-GUID: 0wcjYypQqluGCPQ0f_GuktT4AjEWsbHF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX5cgElKHOgu7/
 Gz9ruK1XDUF86oDfRIBuTwLV2rGHoIsS0XvNF03+g+O8SNH/+ZnT3JwoaUPsp2LYog2SOSRsV8e
 2wZkBcUxmVpSyh93otT2DLHr+fFrHvKeAQrGFS08qdKHR+tppxlp7y9l4h9LO6ATrah8prKx4qu
 HVdGKSNcMigGDXfKPTI0PPCvvHCceTlIIm326yJb3a3D5KhkSfOqc2RGYG7b8/I63Umd9qlAQ62
 933CF8fmEGOAg2seQluDYx8pyu9PBI5i2w46okFKMi/goWFIMlwsne+XfRB7q7SmXMqA2j7l7z3
 FccNEbPA985AaQ9kEk06yA+69UBfkACIPX/6C0VCAuBbKm53L05PPmy+b8ejL8PhZxwzGJHINeL
 5w9kV9kWiRCIoP3oFNybnziDi14dYticpEDBOUFSxfaQy2G56y69QGXKi129TB+ygaojSV/u1ZL
 2PNZ+Hfjboy6ymv9D0A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

Change sg_set_buf to sg_set_page in DTHEv2 dthe_copy_sg function to
avoid using sg_virt() on scatterlists. For scatterlists containing a
highmem page, sg_virt() yields invalid or null adrdess, causing
potential memory corruption. While we are here, also change function
signature to change buflen from int to unsigned int.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 4 ++--
 drivers/crypto/ti/dthev2-common.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 1886538168103..b8b02b82317b8 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -49,7 +49,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen)
+				 unsigned int buflen)
 {
 	struct scatterlist *from_sg, *to_sg;
 	int sglen;
@@ -58,7 +58,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 		sglen = from_sg->length;
 		if (sglen > buflen)
 			sglen = buflen;
-		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		sg_set_page(to_sg, sg_page(from_sg), sglen, from_sg->offset);
 		from_sg = sg_next(from_sg);
 		to_sg = sg_next(to_sg);
 	}
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index d4a3b9c18bbc1..75d9a097650da 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -126,7 +126,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
  **/
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
-				 int buflen);
+				 unsigned int buflen);
 
 int dthe_register_aes_algs(void);
 void dthe_unregister_aes_algs(void);
-- 
2.34.1

