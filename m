Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3A44CDA12;
	Wed, 30 Sep 2026 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790767602; cv=fail; b=lZYLETzY9dp3aGFc1rPy6LYfbqfPEZAl++aGCFt+m3EnvunmagFPDM7ZJ45RA7FRF1D5AGs4zSB0TTBqbNd92jgGQVZapOBr+NjMDBISkww/ZFF9pXt7dnrYgwug2WIOLDvHGx6BsUinrlOHPjHVtm3I9b6+fjfmD3hUu3NNTDU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790767602; c=relaxed/simple;
	bh=2ZFeHgvDd9zsO8LboNh2Zby9keNhh1vjlhrYROuwMfo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DAy5QGC40biPikDQ2NewIZsnvdCBvJ2WtL3hd8wKq/GB4YRzcxm4hBkYeGRM4XOSJ2HEQ51OUOVJNGaN+Ei+89+YDRO7vESq3irmnKmbM7brl8SXJErrUV5Lb58Dulm7+42AEON/Ue/YRjYvRgiMg/PAX45pIOd1XGSr7MExSD4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=dSvTtAhk; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=iOLc3Lv/; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="dSvTtAhk";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="iOLc3Lv/"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5ktN3552625;
	Wed, 30 Sep 2026 06:26:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDk
	PI=; b=dSvTtAhk3HRohd/rw161UBEUhSG3MXXJk12D9BatYSwXgUYbE5Jd5dvu2
	O+rNC+/Pqgid1PDoNd4oEmAQicAuoPB1Yl7RK2jBA3gSifnzMknS+D74f59//1Xm
	ZAql72WCLpgQI1sgN+4yuFYo/GwumUU65+/F2nKJfWiXxpPpyphZQ1BFQc1mCLdt
	rPz6OlSRzrPcjxnYNJn5W5fKYzcEOINFxgGgbVCji/ZlS6CwNalCIxjU4D/Jp0B6
	dsxmK7sTyzpatAAFNUqD4Kum3bTcg4RUV7h0ORg99oCDNTGGnSlhiqbYJ+F6guPQ
	LZICuFWlXGqJ5LfXffLuP8EdjHdbw==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012052.outbound.protection.outlook.com [40.107.209.52])
	by m0384305.ppops.net (PPS) with ESMTPS id 4h10s208h3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 06:26:37 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H2JA3JU0CqCgjqIbIDiIEBseqZuetJXjvF79uR2WYsh5MCuiOuTY651GPZ7i7+eu3qYi2lcPAcKxb1wRfhMG5ohzbUNytQ0wNZFxIQlpCUImmf5Q3QY4xy1ODKRba25Cqy2SSdNqTbNOIJOmkX61RHVqkIi4nUYKcWCFVq5cR0/iA8iLytypQSqewl3Rw+8lcM+kn4ayRM02v+csmBumtfhsO+X3YN5MEstaDPhVIY2+dLuLbJalBw3VxpNrhSCJwbHRFKHzwjE0t7Mje07e1sUFK4eIb//GIGJf2efP9hQZ51lsBf3PJCB/77mhoAnLHOCRXpQdwjttcUrPxKVlEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=Rov8rqcGlHX6a1Xwt4tddRczQgoY4x5yq4QxhZbeZOBwlWCCttlkaW0aXC1VcEb9dA+EwKNsdowYlovmJtJX6fJ1VkKHSdejXbTLPymG6VdZHJiaqOeDSgfmBaKIz9ptoo1o/v3hqx2gN8iFt5NJoXgdNQ5CbBflOLDJLt25bDMmwfvrq3J1QwPL/t+492AH83OURVOkz/COyoTWF4+IekAFhn2hU1Q/TFfL+xuTLGqlCqINJkaUd0aYs/iLnA7Ps9Fja5b0h7Ri4AnLxHhzNfjyGRL5uHYZ82bCe5hmAiqiT1gnbcvpXgnyfYlQ4AABnk69C2Qc++HJgXUtssn8vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5uyqidOPTX9t66qhT6RFwwMn9BS4fd66ncsDfiGDkPI=;
 b=iOLc3Lv/5VmPsvnzaQgN+AERUEZJScuXUaAaRWAiEr59hQ/CM5/3yXGn9gGgr5VGmW1IvsA40WYfO/5GocfFEC4EjW4zQ6/FXl7m7lQgsoWA2OwafVynd0nqKKld4wQ/ZlqaEKA++sdE2Lo6mcu/7pncOL7/wIRLpHGFBheSXiU=
Received: from PH8PR05CA0008.namprd05.prod.outlook.com (2603:10b6:510:2cc::19)
 by SJ0PR10MB6432.namprd10.prod.outlook.com (2603:10b6:a03:486::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.9; Wed, 30 Sep
 2026 11:26:27 +0000
Received: from BY1PEPF0002696B.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::1d) by PH8PR05CA0008.outlook.office365.com
 (2603:10b6:510:2cc::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 11:26:27 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BY1PEPF0002696B.mail.protection.outlook.com (10.167.244.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 11:26:27 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:07 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 06:26:07 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 06:26:07 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UBQ5Ya3969870;
	Wed, 30 Sep 2026 06:26:06 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v6 09/15] crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
Date: Wed, 30 Sep 2026 16:55:27 +0530
Message-ID: <20260930112533.1593952-10-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0002696B:EE_|SJ0PR10MB6432:EE_
X-MS-Office365-Filtering-Correlation-Id: a4bcd9a5-96b5-49cc-6fc6-08df1ee5ab0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	yXbTxHJvYyR5bD5OPuOuvAFU4fIalAmbiRSPbIwZnzvxG5WamFMJiCcIVsAZQab5kPU8F7vHJFnutNqVJvNTXN6OQ5gHCOxfJWrH1739dzjsnxir2+sgDpUc4NAFTTRtR78Y0vAasrBHpDktpHM+OppwgfJZIfAImK5eNifUtrKRs5VVvhz64xV3Lq7xqqfOojfY58Ch8jrN6A9VbAanEOurHR4VKn+UEx1Cl0pbCd6BECSttd+o78D603n5NfTzNGs7aB7fu6kqM9oBlcnpmo2NaEn95RYeUJ7HHCIasout+Dmm6f/COAA2/cDsx36WpB8jcDm/XX1teAtfRhN5YYZc84VlV1g/y8byXDjyrrfipHZqRxGwIVvG+mDl4rm/IH6oBgTPVfLJDgny9sQZXydqsBnyjQTKDrVO4e7aFmmB2f1/yWQGHKJ4m72iLEwK6UPzh5ZB84sKqI019FVv/xMt1Dub95PD6CyqizrSr4TdsL1o9QC9LAXio594h4Yy5oQBAifNbhIFSny5zl2RcObb0NHi5ND9XEB+1QaaFZ2m4kWT2B0aRfb8mj61havMwcUt3er1Ixd2W4YY2ACF3Z1V1XcaJSv5FH6rpAhuNFeobEyCKHRbyPCz3cN8AE4zeA0az8khdhOH5FSGGEcz97e0Iv3ADeu+Q0kxhXl3fAKxnH4675tUsXq7Z1vCuR6Jlt0eRxe7bC1DAX55BimSjQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4mYgP88NQplZLrqo7jP84zMjezxE0lfRviEoFQ33DuAd5QFA1k70pqmJWMMHC7BU3Csnc80he6Xcw0M73wSL5Qtm0X7TotmopM291tmK7yEN75nxWdDqt2ycOVQLUWwJ4UES2z6rBIEtlbJCLuh+rzJI3jy195Gaa0vfJQ/aAicyo7HDd4L1oqTRh5gEysSq5zK9Hr1CZ2CqygGcnnum7JZOufx4UrgA6vbfstXAkr9vh9RnV2V+S7ii5ypLlSp7AP2H/OeDcRhklmZmVFCWrqOW7/rpRj2Xqs6IxoZO4YRS8jODTxiab7jLLSFkXr/BJjUMhkq+2tw9ZuumTzfiR82yTYOKsmON4ndhoqs5whhrDZwZsbQ3c+t+v+jVMoobAd8x7/wUcWvz/TNS6GlwmtjqtNdxv7vqd3KBLuGgS/ofHN+WuOg2XgVeZgltOstt
X-Exchange-RoutingPolicyChecked:
	TMxwlIClHvrEdwRdU16GErgyZhPEZEjNKvakn+L7DFl4W4az1cocfz+4jIoS+7UPHhSztyyxRRr4mzlKKysM8aloSxO0cUAQ87+gi6HsiLHTFmH/+e7NdlUIvahKktc9+hOoZwcdeYCpzsLmPySyqqtYFjh/gvKtlcvlIXNlaKaMbVkZWt96I4OuuesPlikyEfZ2yXqhxh9totmrdqGhgkg3qu47ZgMGE4TDQaUK5jNA2E5xJ6/SzgXEMusQmy0qWiQPcLgMobKm0d7OcHy91jwwcIZNM+UL9dzOv6D0VsHNG5zCuNV4igUDCEyZz0cOxU1jLHDbd9xmhOEHwRCM7w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 11:26:27.4814
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a4bcd9a5-96b5-49cc-6fc6-08df1ee5ab0e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0002696B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6432
X-Proofpoint-GUID: v7LoqLjUgubYh6lW_x2JoIC4N6Hdsl45
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX01yWJ4mu28MD
 mN6N8w9dGRG5z0syPBb5PY3A+CIuy0Bq8TClUCFgBX+/NpAvJH9jkefLejHH47ZCHEXuUwUjyhe
 FkceY6K4dk08WVOCwfUtAEi6dY0OyqUHn8XJnBlZkjanaDtteiH4XJPFVbQ7bEejK3XhO8hRULs
 e4n5wf5FHTaauNuHMQbPaq1WFM837KZ82i+upVSAmNYzV9CAXLgH0Ew4HVabQZGtrMDWwSntNdg
 rkuXZOxg2hhnc86RVGo7NiRri+L4jERKYz3uuV+3MzRJOApU/ARKLGve1tA67wK2iEfirKq5vnw
 tUiEoJGgxuV6Bl2PAZcBtjj7HBSPaQ6GPrXhdNtkNpVSsFxTpnVzzxqM0q0K8FdbzoFR/3suqts
 5gtlB0n7ab8Xz8koe7LDSWC8RHt4NWYE01rKPdqzC99jRKfXqvHGcAl09+8VBV/hfTWOtNFhkwF
 Y5ARM+HMT1xdGXOCrlg==
X-Proofpoint-ORIG-GUID: v7LoqLjUgubYh6lW_x2JoIC4N6Hdsl45
X-Authority-Analysis: v=2.4 cv=G6aJgNk5 c=1 sm=1 tr=0 ts=6abcf1ed cx=c_pps
 a=GeWWyO5P+zJVL7v3m8oIig==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=iMD6g9N4YQ2QoEUmFGwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA0NSBTYWx0ZWRfX0cpzDOj3pE3S
 vpfeBk/USaHpqJUwj6Q+SCHLeP5PNcHlg65Q+EHFc/GCGh5EYpJ1hzRz5z6E4ZRxo488zConcwS
 yxPz45ehmVE0TZ4vkIVATY9eBvwiwt4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300045

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

