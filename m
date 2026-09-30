Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2988D4FE2F0;
	Wed, 30 Sep 2026 12:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773201; cv=fail; b=ErbmTa4Homy3QJK/KW4MxRvaGAixCyRzrq/4qZl18Zb6AoPYK/CKqr6Mu/THtAwc8+7EbBpb288J9dtAGMdEjkumyNv6++fZHz6a9AO3zoo7GnW3cemZDxtEIrDH06TaW4Z0ltuvT5XowMJ52hLCoHptY9rvgclNxvwVY10gcq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773201; c=relaxed/simple;
	bh=Zd+YFyNQlDgh9XjZ8Jbmlxiyyyvl7EPV0mQcbY6y4h8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=okaXWZvxi2G+b6R5pbC8LmpPB/WyQMKXgFavsl9VgPG11se7fBehlVdQirWwYj0Q0uztLAEiagBmrE36G6D0+Py1n51vAGVMUgQzPciQIznzdf5++AsxWyezz7pMZFvgLmIpdiRJ2FMd292iRdEIFnfNM8WK22eHpXDruZ47JW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=jLkS4IOk; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=GI7FcoLD; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="jLkS4IOk";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="GI7FcoLD"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68UB61oR3214139;
	Wed, 30 Sep 2026 07:59:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367J
	Q0=; b=jLkS4IOk8DLXKdl1PfSFzg8YYp81gVT3AiW59Frc0jRrmN0+TK7+e6ZEP
	yL6bFM117OD/Ycg1WAaAt5xguA4igMi55cMLb964el4STuxASf7KzBKiC1e5qggD
	ZcDi+0VG/NvTTzmasOh3grqFANW9AQW0prungqJ3guh7OqerBzeGBoxm1D+7zeM8
	Y7UXXmoROlw/ukVmOd3yUlRkNWMWCAj3ZgSMM3FDhIqxhkHmtP9ANMFFLHN1nJEs
	mOcUTH5vfJ4J1ZRw55icq1ahl1isbsnvJChhNpUSa6BFuzX6mHXcAJe7pPyABotZ
	5fQvMBYalQLi73Dsomi4DzZioGm1A==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010025.outbound.protection.outlook.com [40.93.198.25])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h0ydv95rj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:59:50 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5Ygk8jfMzSytW0NS0TuNaKUbeoy4Mpk1EhXwH8UXbz6pw4nudXwqc5HQLNwIqPNHsbsnOS8yL9xoirrILXqTRZHlSQbY1XIAqCoDfT5AKq5KwA1kuqNx80YSXO2brfoNA3MJ5QdsUslDIrdZeBwi67w//jOn1fojounEpTMfJxaZ6YwO5LNvSnHMLtKg/hwtinQQZ1bHMi/NVlo+oa5kXq3xXwgtfEFftAzCGIH4KaR6jrn/WrFzP2d6+UTw/FhKwEYQAOsMC2hWq6rXarzxVjcB4d4NVDrXNxCrgQMM3zYiNKjGoNXzpcKlpLYJJdFm41VEJEa5y6Bg23p7uTvQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=pt0APKlsZJ0DrfI6Uwsxp6YkjOVkgNgTvAWE8TewFrjsq88yHuAadw1v+HFXgqDlPMhKo3uPZ09gayCrpgnJTd+BrQn/w2iEnkTk4as8iXXvHAmY0QIrDUuhkmBNhSLtFKr5qvZpzNYSZBBAeWUr0DxtY/JPel9Ox0UWBwDQyR2XHBVdbTInojMeXAT4QGjZy/SegY0v298InIhyGARKZMwfg+NQtv40g0tunENTkNH/2/+LNds18i9XzBc4NJc4l7XRwVid2b5dq8rDjoc5piRuU/tPPw2RWlTL+T6LQL/vXy9ww/AvD8zEIViJ+kwOGFceVwosPYH0oPfXmUgeUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=GI7FcoLDYKDYymbGDiWflGSjkd6nlNxQVGACJMQrWHZYMIqndTmDTUfAbejJOdEA+5nPTFZJN/umRio5juJTMEmWRa9pEsk870tWmtfwalZsqYHTG2KMIPTZ9Uqy6NNnhchVuezqNprswzpAkXcglQxV9Cu90vGM1ugqcdpo/24=
Received: from BN0PR04CA0206.namprd04.prod.outlook.com (2603:10b6:408:e9::31)
 by LV3PR10MB8035.namprd10.prod.outlook.com (2603:10b6:408:281::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Wed, 30 Sep
 2026 12:59:47 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:408:e9:cafe::21) by BN0PR04CA0206.outlook.office365.com
 (2603:10b6:408:e9::31) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:59:45 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.496.3 via Frontend Transport; Wed, 30 Sep 2026 12:59:45 +0000
Received: from DLEE203.ent.ti.com (157.170.170.78) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:36 -0500
Received: from DLEE202.ent.ti.com (157.170.170.77) by DLEE203.ent.ti.com
 (157.170.170.78) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:36 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:36 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCxY0w4098334;
	Wed, 30 Sep 2026 07:59:35 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Wed, 30 Sep 2026 18:28:55 +0530
Message-ID: <20260930125859.1749849-12-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|LV3PR10MB8035:EE_
X-MS-Office365-Filtering-Correlation-Id: f2adcd3e-9f22-4645-4e14-08df1ef2b3aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|22082099003|18002099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	PBaJSsteHL8UvqpLXRzE3BAI7FN35hN4tOVv+sECvmAfzd1s3pyB0NXExm0qDJyRl3XAhAtmViE8UdWpQJjWq5jqaD4as5dmNVe9NWYJfdGwrFMGLZCSIyXM+YxH/gDQDQEE8xdKkOVloZKu9jRzJzJOU5iWP9JHWYCnVFIhQGWoOkQRAy3VsyQ2uonuC0GHaa9wW3xN9Lk3OQXGh1PF+Vb2/HIt/kWE7RyuafMrJ9jve2XHx4nPu6wrslG2ALA1g9KG3nUvvxLJifG4yhJl8MWG4Nosnh82V+gFlZ8bfVTmjhR/b5pQ+p0DejiI4uEahtktC2sUI9QPHIt9vi6CttPMsr5iNchf56tNDpkuPWA1/25lcArDAUa3orgKflAgXsDFKaUtCCCjIcE6zEd27odTQcUPgAUmgcce1HAiunobSlQ/T4AzZZBFiMhe6Ud3hTO1iLQ7uiyJGUNykqiei12lRcB2RxzF2dfvNC/WkE7MAi6GDh8sDNp+Yixu1c5F8Mk6WohYy2YpWDe6Jwo4P78amI9JG5ksPda0/UPhhl7sXlCPSbgoPaySX6vlEx7fm45dkoa1DI5P/vKEWsoeOdWI8WqyZ8j/7IhREHJIJzRRjJR4HUJov6Jdv6xR7HfXB4g9BdVjzp3ilACh9RAMbEx9PmXNgPyq0TvvbOVoVgyVkwd/x5eMu4Wv7ZqsRGmXWZyXCnqhiWy5R2g+26849g==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(22082099003)(18002099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zNh+5y8wvQjE0zFcObObK7PtxVCtsnqWvFPv6A2E+4Cqu+4BDPrQjyqJRr3y/m4UDaNNzRctNYF3mqWQA76MIowAmMJr/EV6CzHQnVJFCnQxBsfH0CcPYj14uk7Kb6kJaNrGJsgH4AcfINhLTO4zs9Ki4rYfyqDb9FikcbDkQcSYYoF+OXT0IuZ9kjNs8z4K/Mf1c0p3T73sKUCDo2pjjwFB7pWfNH7CAWbTveTvIeIs/0mtD/7+TWLDe7Km5EerAMjElk4LD2Fctmrx80lCMCrHS5Cf1pRGNaYo55q12OK6gLrccHzCrSRtWz2FHorlYYWinxIEEXr/eqRIPtdlJubu+FE6NeSnlA3Ewjs8e9yIZ+nGbLg2BiUvrsy8ldU+JYIerPqVAl6dLCmrf7rfl6mojtumn2MbTSuPhrViFIJ3WnwrVMp3RC8VL9W75hki
X-Exchange-RoutingPolicyChecked:
	ETeHxTxlcMms9kHSaPAI7c6bRo4+0O0Qk+25qB5wFKiNGpeaB6yO5dHcCh+tCev+MqeUkdlL3jIEZDe6Cka7bhCvG+wHtNV4rfisvP5kValCg4wxQZFTpHNaQ+PFKbq8w3bodmFpYQVuOcWIen9S1lc2/6QAsZxWKc/MNM1VgDI+3TmoS+1jb2vKiVGYsg29KQQeVbdoeon3I4J/fj0S3Z4HtKTW1NlZLAi66/EU6wv5+rj59cPr902S8ZxaYXd/EV6sMJJCSu6dCWWiaRGiIR8s+caoaFXdkf0q9ZM4uWNIqFX+ptrywre+xkPccp+mJDg3sjR1Ao8wqimlFSH5Rw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:59:45.3950
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f2adcd3e-9f22-4645-4e14-08df1ef2b3aa
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8035
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX7RLMZv3Tw8Kx
 QLVBstaZmXtIfnqmSEfh7mOQpJ/LQmVSKJm8hdS8es6xFnhk27eKuirAxmDCAKG+flmormLxF4D
 6EEDCcZXHrMfp/gRkTcThTLMK/3otvg=
X-Proofpoint-GUID: Q2s4vPslg1u_N2XJaCyjO3ZrnKo1hZ9F
X-Authority-Analysis: v=2.4 cv=TegDJhQh c=1 sm=1 tr=0 ts=6abd07c6 cx=c_pps
 a=Eox/QAxx2gIfswQ7UCXYtg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-ORIG-GUID: Q2s4vPslg1u_N2XJaCyjO3ZrnKo1hZ9F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfXyqJ57F8qkHPS
 YfIj7RJNNZXIC7qG5uzPH9AhWlw2tuAY45gua0sjK+8/ZkKI9RX6eoikdSSNcUjryU25exzIV5A
 SK8mW01kkIugi/5jDcj0P2+b4dWA3o/g3AA8Q+Tsv3MKpbherAuXxb0g58RUyGmpmGeT68Uhp0l
 KpfPSO7nFq492HOkPdn7uZDcoIVIFyZ0vz0QRzsvhzKg//bjY2MYFhWUAvpLGXldkh5revkvbBK
 YmPkdnlHcriUA+SZfS/5kaN4VX4Z6fXzQwkUfRcAP+eO9JgizqrrLrQuo+5EZ1dcsPELQv7Drmd
 y69cYpsWyjxHGoNjJmNexE619bLapPs5Btz9S7OownCscMQlSspyW8kjTitdZYjblMRsF9p4wx9
 nP7tFYV/wmWDXam7b1vVLCYQQ9EXdz1VzAloCF1//emRuRU1rlXzMgij5Qb1e066l1xwXROmmNd
 vNUmGaBgQL53f7jitog==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0 bulkscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aead_run() to appropriately clean the DMA
descriptors.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ccee60800a664..ea6e3b246ed1b 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -914,6 +914,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+	bool cleanup_tx_chan = false;
 
 	int ret;
 	int err;
@@ -1014,13 +1015,15 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		src_nents = sg_nents_for_len(src, cryptlen);
 		if (src_nents < 0) {
 			ret = src_nents;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
 			ret = -EINVAL;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 
 		/* Prepare DMA descriptors for ciphertext TX */
@@ -1030,6 +1033,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_out) {
 			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = (assoclen != 0);
 			goto aead_dma_prep_src_err;
 		}
 
@@ -1038,12 +1042,14 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 			dst_nents = sg_nents_for_len(dst, cryptlen);
 			if (dst_nents < 0) {
 				ret = dst_nents;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
 				ret = -EINVAL;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 		} else {
@@ -1058,6 +1064,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_in) {
 			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = true;
 			goto aead_dma_prep_dst_err;
 		}
 
@@ -1147,6 +1154,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_dma_prep_src_err:
 	if (cryptlen != 0)
 		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+aead_dma_map_src_err:
+	/* Free any descriptor prepared on dma_aes_tx but never submitted */
+	if (cleanup_tx_chan)
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
 aead_dma_prep_aad_err:
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
-- 
2.34.1

