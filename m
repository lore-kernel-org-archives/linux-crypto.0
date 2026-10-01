Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855044CEE6B;
	Thu,  1 Oct 2026 08:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844862; cv=fail; b=dbPfWRXmzSehCAgJrKPsl+EBgolRvyXLqxzClAtbPVO34WBNfk/s0gFDAOHUeJ9+HP17FWZBHYhw0c3dv4QLo/55MtV524GlRoBvG1JxvSK/2YmzV9Ic2iygYahSGjEW1VRNFuIxNWyT+3hrERNGtxq++pkwhC/qD4KDudrwvcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844862; c=relaxed/simple;
	bh=Fz6141O6onZO78SV7cw1hoqrEuLJOiXK6EO+PyIU2OU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZIht4TKHMrx3nnLhj+reOj2gbHvg7S3IOPRb3ZkCTYBJOrlzCWghQZMoKgihDPZii4ZQJ4fPN4ptoCUMeP2sVcsyv/lo9I7/HbPrU28DQ4ZLU8MYBcq6C1yuUBHXD2e35Z+zTHUwFzTre2fbcnOhfSffXa5rXlesKmxIgZV5aXA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Fz6pD/8K; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=RmDGYoMp; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Fz6pD/8K";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="RmDGYoMp"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 691714Kt1294721;
	Thu, 1 Oct 2026 03:54:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sX
	PY=; b=Fz6pD/8K+IVVLAx7kIAxCsRi1Yxi4Sqr47qC4Y4qrsSVTu8KUL/duX4Gz
	vYr9C6D55VbZOvslBq6r596oDlJF427zA8Q9tKgX87qHEachnAqNGnxNJjNe2fkh
	FvVPfm/btR8OBr+81zZKDyb/dm17/qhCs5i/iMrulkwnNgse5z6cZlckDJWLA6Qo
	M2LY4yo+azBJudCQ4N5xoRbtv5iF/Br0WVr3jspai6XyOuNSYlrxzCxwVJumftXn
	s1WPiX7NemAKTXukiAMpZpLFpeRWZpGrDcyilWeV0avLMpIv/ZhHMpWpoNeFO633
	tpx8I7TA3RTIyrO8PLZplC+bsEGmg==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011018.outbound.protection.outlook.com [40.93.194.18])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4h1eur9t5t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:54:16 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NPuauphP23M8gi7rfGRz1KnWTyPGI2BDLSfDDPP+9fZR2VcR6xI2WI4ISEkrrPYJLB+wtPgk5mL0eMrDfP1xNyMz0EV9WDlzGnsUKcCbcPqEUd8BVJZgdsAWuJU2IiDTHDJI/8/0TogVJR0kgcEm1irRBy9TtG0qaDtCMgop2SVpKjfDr4AYwQDSnSg2YJP8Bk6e/P8MbIh6VMouNNjEueu119ywHhpN6E9/TQTS94PHljaOTXuxvdbD78W9I78a995uwtvU8hbTkDeTYLkMUL2iStcGoi+hy61Fd7iJ8SLxVYNs8Rx7WmXN3b4Nop6Jk/mESjs83MKR37vz8IxZrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=O1KPp5vw5dO8AbQGqvbySo8TA/3hI61KKoIo0biV1/OU+5lbx7IgqzldZYLwdZ+Q3yhsLFU9Bi47nGd0hLb3h36Cd1+VH4TPdkrwrowZXe72Wxm6beVQsfUocv3Wst7y9qnTsw7oA7f/Nvx3UspUg2LpSL0d4vyjmM4By17MMT3w3+Kt6els0T+aRSjWs0rAYQJy4caRLmt1zsHHJqAEdq74Q7p9a7Zm6616l+FkaxJyCz0HYzM8iHinibxJw7loahRbkK+sO1GgBu4wNi2i4IpQxKyFpPHO0AxfbsM/CcEo5KgQik9P7DGNOX+CXXhOOvVdz9PH20V5Apwp4D8XDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t0WbCSWTB0HDYtz3eFDQ6ua+13hjlle1dIefZT9sXPY=;
 b=RmDGYoMpyVYgxyz85WrPcOVLxBYRt+7tmULdqL6A0adyRjRqr+CwEW6UQ6al/BFw0l82a35Ee8SOJQZ9XgGHccH8umY5og2RtJNqJwN0AGxIGOlxD9qXRdvQZz0anwmeiW4LJqJRI6kcCtwn8f4AoNR0WoclOoujzwm7iKSAoOo=
Received: from CH0PR03CA0249.namprd03.prod.outlook.com (2603:10b6:610:e5::14)
 by PH7PR10MB6058.namprd10.prod.outlook.com (2603:10b6:510:1fe::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.14; Thu, 1 Oct
 2026 08:54:14 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::11) by CH0PR03CA0249.outlook.office365.com
 (2603:10b6:610:e5::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Thu, 1
 Oct 2026 08:54:13 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:54:12 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:27 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:53:26 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:53:26 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918rPBr648920;
	Thu, 1 Oct 2026 03:53:26 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 15/15] crypto: ti - Change lengths in AEAD to u64 to avoid potential overflows
Date: Thu, 1 Oct 2026 14:22:45 +0530
Message-ID: <20261001085245.2922974-16-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001085245.2922974-1-t-pratham@ti.com>
References: <20261001085245.2922974-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|PH7PR10MB6058:EE_
X-MS-Office365-Filtering-Correlation-Id: 48db8bed-d965-411c-b9ca-08df1f999087
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|82310400026|23010399003|1800799024|10067099003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WduxGgl50yDF09/POvjHDYa/3cmf4izvN0ipWN4jP2OqXZMRerNVeBVSpfCvAV56XRhklKms7LnJSk33SFYbzW4YUmoh7An40Jk+EidUioHH47aQZPbLw4Bi/ZAE2vMW9MtQgh+TC9AtGLmePKX3OBkq7IQybjG3s7TSWj4/yaRbO19sbDE7VZpqQGNRsKJsBLMpAVCY6mjcGqoqP9f/f8/VMYbQUXYc3FHnnjTQQGF+PpQy9vsiL1SpXeVBjD7bgyQOwBNBWp56/cTo6Azu0ycr4KlALUiw7qSIPeh+SkQKcP6lTQl9LgFcCigSB3x1xjjo5isZxjJ0pRloMTkEg4PnDHqquCp5yVx3yqN/s9rOTEJHDYJhc4y8SqudvuwwfrbW58orQAEHzn0+RhUTxw+CN3UyTVLGYJYrRkHHelpEkZGU50w05sbxjD85JgYEEiOndUPPyRfcV+5RGnkrwMid8lyRFOvWiXMHFsHD/TROgwoWuk2MHfQFmIqGsu510zKTc/V5vwpuBIJSSp499PYPaR5V/rG29malXAZpAqzoJuD6q3jJWz0jrX/AMGvf2o5i0EWJQ/79pFupPReZu8p1YhN2SxG8zbdGARqZRgWSNcMifTqw6kqF17CCAPAoWmcheAkC9aTQO4+BiLm6B7g0b+krTz+TQHHXtSuVIE5sqf8jxQ6555b3TdbFDaQJyvNH5MoBvBWa2NiLUyDtXw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(376014)(82310400026)(23010399003)(1800799024)(10067099003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	acPzfaAZTdF8E9lvG2ynFR+DFnb4O1KC0BompR65hXYFk/6Mt2wh3gxGrmILajBGoYgj0jwPrxEGFTGqoTfuB37GoKVTe4FseJI1cuOmhKwKAP1WJ+QLvDAv6YjsdDjE0U088+z/+zfDRz5M53jS+Kh9n8tzsngqIrIHqAFRNJesT9hAsss+2TbSTR1/CQktoq4OCn1QBupLSzJ0bZg9VmTYKLfIp8V5x1ysgEe/ySyiqAfHtkXMWR/5tsLXyrcGTQWH7VVxwvqjiLY/WOgkEeB/mEH8ASiIQ5NGvIl1BdEGja5mcLhBA0dFwYog/6W8j6L8PCEKUTv/nRqY736n95L/eXguOPGmeofM1JaW003q7wRg8JJ5tND9jL4pKo1UyiuSpbwXPlUvAAsSw8jbhqeWKTWHfQt0SQhQiCl+XaMO7Mn43y4Iam6GtOSYXOfw
X-Exchange-RoutingPolicyChecked:
	Kd1vz3sLZnH3J0730DUMIMmq8t6H1yeyejg1eA1AOMAmB/HoKaCweK1UhVGQe6xKbzHBRMyrf0GIUQAJj0KSN8F9SpVReOF4Lll9cYBwhJzd03A4j45316E3IQb5VnVMS7M3SSVZV6dHDYX57+Oj6qLF4NX7NFTUnlLUxmcawongjJZgi7ZJbg2uS5UMzPa9PF3fLRyyAuwVxR0s1lBiX5XbH0KA6GJoUg+Mowjnu9YEerN+LfukAMDYvxvc8BxLRBxbPLEEx8A8p/9GAltQgMnNcm4KrshG6VaSBW8OLKTuHbovcC0YJlr0ZRkUrNRc/+ZJGRt2LarxjCmqTzQq1g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:54:12.3949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48db8bed-d965-411c-b9ca-08df1f999087
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6058
X-Proofpoint-GUID: 2OnFqbIapzrt-cvzznhMJO5RwE7VbWtC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX/evZkCOKZT8C
 g3VCLtZSRqBrw935tek4sKCMCMkRI1SPxbPJpJEOlleXKGifiz10mT69ueB3ARXb4HDVA/XC2RV
 jLBKj6mywEaCOG2f8F+y3xt/pD2LTF36hk1RtUxnagsQfm/o2VIfYTkjReBqNaSdnS1g9urxfP4
 vKi2cuGUG1CPhOleGPAk1fmdztKfd8Z52geS0JMuXRrFPqaMTDuIBUGyFDcmbFRj6GQjP944MYP
 bGM89n+xoaouACGLVc6x7cEMVxOQgwXrv+ZCoxhcLh8FPbnYLtt0S/JXN/2EfVVkeh0ZdCM0MZU
 OLxdw74mGaOuMkaQwqiDYJNaZoIxntiFa3IpWHD9WwoHZ0WRR6IE3KCe/fL0tP928V/8g4qxmkn
 Bf8Dzh64x66wbbZDWUaeiFuZQG2Qn3wvreCDXY3OXzmTpfCuky7tEtaUWVdrCepvKkFmL1hXhe/
 kxK7kN9dzM2gkOc82bw==
X-Authority-Analysis: v=2.4 cv=KvzYSmWN c=1 sm=1 tr=0 ts=6abe1fb8 cx=c_pps
 a=jA10WLhXiBAWrDGJQFCh7w==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=rGLHzWtdNaH96TCHXsUA:9
X-Proofpoint-ORIG-GUID: 2OnFqbIapzrt-cvzznhMJO5RwE7VbWtC
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX2DxqbAMqWOOU
 Z5b88Eoz6eztBHrfU0aLAxjDsUhTiPAvSnXnDTsWjNCfHCkAHP0iMQQj580qoWEDNSJmaifz5f4
 1Jao2jVQXJbX8vZQrCJZcKeuKxTMGbQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2610010035

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

