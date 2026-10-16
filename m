Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EE9247FAE0;
	Fri, 16 Oct 2026 11:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151370; cv=fail; b=pGnbGdB19YYdj90/glQ0jwbLSXhYq8iPocZvwwNwnbM82FzHrW8fuvVVqW/p9UDGVaNAQjk/718zZYMd7UAcwG3aKbjvz+mOhWu7bHuf/0PAJLSzMsYRTZoEu5ru4wmaczSVtORePpzRmsFy/Vc5ERPxfCy3tOPhQWttbtL9pE4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151370; c=relaxed/simple;
	bh=Fz6141O6onZO78SV7cw1hoqrEuLJOiXK6EO+PyIU2OU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JsKnKGy6faeENSsvllRamSQftto1VVxqR/BT1QhNLShjdAe4/bqsQCy4QQYEgrlcnaL2v2cHiRFwa8I4Jvf7nOMsI7i2KiTwGryn1n8GBJqTG2ezTOAGdaf8KkWMf5wtL+4uvCpiACe1TT6rVIcdPL0VF1HL7kWTUIkp3LsWjuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=PB68zXtt; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=KzSZqUkJ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="PB68zXtt";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="KzSZqUkJ"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GBNuXT491209;
	Fri, 16 Oct 2026 06:49:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sX
	PY=; b=PB68zXtt3ikUqsy9CUcPmyrAxWqggce+0Vd1p3IbRNOKVsiXuW0miRgxs
	DgiZHxT2znvL7UWASr0zbvgIxx33xsrjFq5KxXzKZtwcaD5Cu5NEY++/EYb/x3+u
	+4kLLg52rrOl0W29cHalL/97UpAbafOOtPJNEfLUS8zWzUOCRyqIihYW7vt6GY7i
	JzIHyyAxeDGr9cM6qvfap/44Tboz8zc1rYQqIG2G6KXcjPxrmY+spaTL0rAN/k1O
	qkEQK8D0uT7gWIoMVs7luBTdqArKR98M5mHDFcPz+5R31GuHR+mwIgVDhyynd3nw
	kb8yQbJWHLTnPWYL+CuS2PSnomFmA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011034.outbound.protection.outlook.com [52.101.57.34])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hbk12g3na-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:27 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v1wTZfQRLWWmI+gbkGhDkL0yKY/3joNUTk48ndOzEAlSUUKLnpUiK2+nDG4csuFjCInhCQMHUun2+hycgo9y35snBtiJ0+H7dn+g3PmwT6sBbOOosdZn9GnB6d+6C82JTB3nvVQ1Rn0afdoLuCETU6a22/w7i25uBHVV1O+t0dtgZaZeiBa0ePkhJ1aqspVtqjoO3fl5oTmxLoYzVXvaw36bPEjWcC9kzBneqmSnUX+IdcSuStkPaXABzgn9veMHCUdLUtNGSLDOP9MYSn9rvJ2OxTmoSDopTfXTKfoHDx/bEt7l+NsGf3b4As6UORyqssbJ4lvkZrj5wcxvYys1hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=CEE2FORpUNapjZ7JkbEDJCU9s2/CmXh0xHsXcg5mwvJXtqcbUlcLzosQvJPoXcawyUgiEL7RhNuHJTdH0iLgqDNQF8HH7VgU/nDnq/CLWHtuvFHX47f/qXRlShkAEmvKVNSGczQTlCQZpEMRovqjmSrmrRCxTp8cdHJ9abdq54OrqaLz3qoYJSvzLvkSYjaU7mgBphiUbcWzng/4dS5XKIRFIVlIcWHbymhE+uQhzbFrfxEInxWkUEVkTMXxLRID8QAoZi8ZJ7cosPewi01mN/Lo0dCCEAlVQrW3x4YIEalKRThanEMo7hIVUSkaMG08lK2F3ed0vZBS+BMxsmoJpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=KzSZqUkJugiWj60Ql7TulNUCv7VtvhaeHlePTvKbZMAM5s9E46GrD5sjzA+ghQCp3ZZXuBF4yFKJZQ/nGO6Ua6TPtLJ/PPEU0fPUkTcwW3/Z7e0PA2N2icRW/wMI6w1YU0c0tJ69iIHXaaMAbvgidk+a9Oz4W4eFRL+vh7wOsLI=
Received: from CH0PR13CA0033.namprd13.prod.outlook.com (2603:10b6:610:b2::8)
 by SN4PR10MB5541.namprd10.prod.outlook.com (2603:10b6:806:20e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.8; Fri, 16 Oct
 2026 11:49:21 +0000
Received: from CH2PEPF000166C5.namprd04.prod.outlook.com
 (2603:10b6:610:b2:cafe::af) by CH0PR13CA0033.outlook.office365.com
 (2603:10b6:610:b2::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.4 via Frontend Transport; Fri, 16
 Oct 2026 11:49:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH2PEPF000166C5.mail.protection.outlook.com (10.167.244.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:49:20 +0000
Received: from DLEE201.ent.ti.com (157.170.170.76) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:49:00 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE201.ent.ti.com
 (157.170.170.76) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:49:00 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:49:00 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmx6e1508959;
	Fri, 16 Oct 2026 06:48:59 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Fri, 16 Oct 2026 17:18:06 +0530
Message-ID: <20261016114806.1749515-16-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C5:EE_|SN4PR10MB5541:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cb1a5d3-ed22-4815-fb9d-08df2b7b8436
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|1800799024|82310400026|23010399003|261009223027099003|56012099006|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ZqbXbRSGi++mFqCMRHC4gLBQryyaM4a7Jy3XQYxI0KlPdRgnf+UNhm3edTpuslXDY4ucgs2sB7um+3s8zFdbh5natvgIll6E5Yrk7dCe5fWMAiREa+aVhEGEi9eWnIRx61JA/3MG6R4g/4scUWu4OOrRp1yx7TTueelF/1JRrTfFPPZoHErHt4rtMWHyTq817+aKwgbHl12TQ+7tDWszNl4WkU5P3LrjzLDxka0SiTbjR3NtohfbEp9gQ+I1rD2KLyIbT/rg2CkgeKtF9ENuQ5U1cOb/BLjE7jy290sc/ua1vc91JQ1oX7mudk5xBKLGPBgkHFBnBvqH3WvslaScnYIkvfzPPP/YbFwdL93Tdq9SRjO3vKHuXeKGSFrA70Yif+30h57tteWBBDywwvtjmen8ruAmNYoaIyhMtbsy7HofMTunvAh1gFvUOddmI0PXiFHwpQVoVh44Om236l4Fwu5VdTpdqO2PkN7yEBdotsPYv24EF5wqQeankPW7N7iND5H67Vfz0Tlnv8YqX7wqcKU/YzBw1difHRNKR0M2WTnUNYB3GrfzG2/LJH7GBYjPQOhYr4Hj/GebsD/r2MiXpgHCJE8tWvqVPuz4VmAFiIMaz5NLG/Gx9KdbsLk8JGyw0XJHW84DWTyOEMHGPOOXet7teYI+IkxNzCqQMSd+Hnvgin962RVlMRE2mI/Hexfnoq8e8kchL1QPWMURHtXiJw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(1800799024)(82310400026)(23010399003)(261009223027099003)(56012099006)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	hSssWlUVdNXlVRE/1CbseAacjm3HfgKwxS6owxTN+1OoFaZg3aTXa+r8bVeUwY0d20ENAxBqtVYeRv0cSFJOGx8s/rd50A2FEvTIKMAShMMZYFVj5nBtjkZlUrV7zqN8Tvhux+sRYbfsE6G6EbTIdovsVkX7Nb6ahBitVMdIYUX0DXK9AidzGRZl0/dm1FiBvO8aoU9ZlvILOFGrzzXwUqVym1FeizGrAbIoIhC5etFnKgjncM40y9dkeOhWUHNYLSXztu/SlyfFIqPpMGsnisCM6Vd7/P8lyFBaFCiUE35uMLIegZUcfr33CBiyU15FEPhQCQxC7ojAFcIIUmg4zxm0G/H2y48MzIlpJAgTfnrIPuI6CCl1Hwy75KelpjvqZI7fLjLYUkGUbmqPzl6V1bE8T8C5CpdvN78J3VeZJ6pU0P29Pub0UTGx39b3VUe+
X-Exchange-RoutingPolicyChecked:
	acPo815j1117y94TT64PKvy8p1S6S8c4eVdEczxBf76FYygdoksIRIMKpa0yuIhmpfbUBGreDK9XvNyv3UNwfQqtG22g2Tg5CrbZc9BbpBVW7J+dfKkGwo9fjhP03Aofrka+zMXfjB6Vy1Yhg3s1AJdIHdKpzjAs5J2K7EjTi4EeXetahO6OWRpY1et87WIOjFN8IxiHkaHu6HXGUzVJXh3oohEWJxcetRsHFtUDxHov2Oq7gKPbxgr+z2PM7DDHZd87rgLqcDQf0YFRTVNEunXu5E2RFz+zSHCEX+z4SF7Lwgz36kAHB9wRSYOwk1eMaQj/jTKQlBT1aAGhBwVrMA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:49:20.8061
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb1a5d3-ed22-4815-fb9d-08df2b7b8436
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5541
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX1rh8cnsjSGvT
 EyDCZJyJ2jNWeGN9gpFEVSEcwFb/KX/bhbYWkJlyiTq0mgJYPfspqWEd5WrvgvsDMROcNd4ZaE3
 4hsxg059xbgB9LtkkS9Nmd/A08ovspvcG3sz54dB73mOzwIv/V/cBle9oYuTlDddizyG50GSwFF
 GNKrU9xT53ZItOoYj1Tuffjhwtxy6VZNG+VQ0YTGyO6Qr3EOINBQ3Y706PcrpykIgtNqDwcXYVG
 8hf5j7l9TH0z85P+eBnE32Iwvm5XhtpbYld+9HApxR0u4vVv2WUVHwTQvCXXvCxT0e6gGULCDcL
 ZhCB3mCSEUI4CM0w2udhX7AhcEgDHWpQaXPNuBdqEUu28ME9gg2YQUfn0kLZ6zqoRyUng6qzmPv
 hSydK04KI1twUI4PyQ4dUXlpYD5tlcdpjWB2MRU96CVpvHvZ6bHbIfv4TBq9FZUweY+rpjiWZ95
 6yKg4XWLq1hsOMwZuUg==
X-Proofpoint-GUID: lwkuZIRV6rfq9SFo6MlK1aLBOdzud6bX
X-Proofpoint-ORIG-GUID: lwkuZIRV6rfq9SFo6MlK1aLBOdzud6bX
X-Authority-Analysis: v=2.4 cv=fspJ914f c=1 sm=1 tr=0 ts=6ad20f47 cx=c_pps
 a=W8CcAi5xdRL/7wP9pBfUSA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=rGLHzWtdNaH96TCHXsUA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX89CM2UTnWaOg
 egDA+YNEaFytYX9O2t8GxBGDsGrfrs5Iw6pjaRASqiUIn3sRKPEXAaIeGPb3sfSRc5y7W0nO85s
 zoZrFjdSbwxzlwvUsAcO7fEWRaa4B8w=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 spamscore=0 phishscore=0 impostorscore=0 bulkscore=0 adultscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160046

Change assoclen, cryptlen, authsize from unsigned int to u64 to avoid
overflow when they are added (in TAG offset and padding length
calculation)

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index e141ab8980000..2d7fd335b770c 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -758,6 +758,9 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -765,12 +768,12 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 	if (ret)
 		return ret;
 
-	nents = sg_nents_for_len(req->dst, req->cryptlen + req->assoclen + ctx->authsize);
+	nents = sg_nents_for_len(req->dst, cryptlen + assoclen + authsize);
 	if (nents < 0)
 		return nents;
 
-	sg_pcopy_from_buffer(req->dst, nents, tag, ctx->authsize,
-			     req->assoclen + req->cryptlen);
+	sg_pcopy_from_buffer(req->dst, nents, tag, authsize,
+			     assoclen + cryptlen);
 
 	return 0;
 }
@@ -781,6 +784,9 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
+	u64 assoclen = req->assoclen;
+	u64 cryptlen = req->cryptlen;
+	u64 authsize = ctx->authsize;
 	int nents;
 	int ret;
 
@@ -788,14 +794,14 @@ static int dthe_aead_dec_verify_tag(struct aead_request *req)
 	if (ret)
 		return ret;
 
-	nents = sg_nents_for_len(req->src, req->assoclen + req->cryptlen);
+	nents = sg_nents_for_len(req->src, assoclen + cryptlen);
 	if (nents < 0)
 		return nents;
 
-	sg_pcopy_to_buffer(req->src, nents, tag_in, ctx->authsize,
-			   req->assoclen + req->cryptlen - ctx->authsize);
+	sg_pcopy_to_buffer(req->src, nents, tag_in, authsize,
+			   assoclen + cryptlen - authsize);
 
-	if (crypto_memneq(tag_in, tag_out, ctx->authsize))
+	if (crypto_memneq(tag_in, tag_out, authsize))
 		return -EBADMSG;
 	else
 		return 0;
@@ -889,10 +895,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
-	unsigned int cryptlen = req->cryptlen;
-	unsigned int assoclen = req->assoclen;
-	unsigned int authsize = ctx->authsize;
-	unsigned int unpadded_cryptlen;
+	u64 cryptlen = req->cryptlen;
+	u64 assoclen = req->assoclen;
+	u64 authsize = ctx->authsize;
+	u64 unpadded_cryptlen;
 	struct scatterlist *src = NULL;
 	struct scatterlist *dst = NULL;
 	struct scatterlist *aad_sg = NULL;
-- 
2.34.1

