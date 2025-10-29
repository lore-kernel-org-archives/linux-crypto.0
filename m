Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013012.outbound.protection.outlook.com [40.107.201.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA5730BF59;
	Wed, 29 Oct 2025 10:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733387; cv=fail; b=IKeOtLK9kzECVQw1m3KM/XYKs4zJYVhV89uRhGgwzHQt/6mACld8+++WyvyNCQZrMZ/N29GR4tIMcUYDH3EeXQJ0lB0r4xGFaMSyJEurlTGYn/+cMm33Hvuns4uzHIDir6suxchh0z4EeqP12NJfIUNo3ITH+3x/uVEmq0ULb+E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733387; c=relaxed/simple;
	bh=nPP7acjeIg83PbHnd+nnOF8pwk1zgYwbv6OevdhU8Hs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fk935pO9GP0HeQ30gjMvh5YnELa30REDf132UjRgLQWjcNp82E+Rkk9CHzHFLiC9uf8oqGDLJT4ygbFNuJN8gDL6BxnIm3q1kAyC1jTlpPJ0cUbPZlqNAj5O+CswrJ5zuRWf8pCn7NjYxtsKTt0BNf0/oMgYcXW41rS5KUxIkI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wQGPUjgE; arc=fail smtp.client-ip=40.107.201.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wQGPUjgE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nDvKhHgD1CqCBKQHMr2JyCO56FWYyhEgHKOfSweJ++Um0L4buo7xSc6UgzzWbKQEzzRILSwCFDJmG2866hVrT5bhHffrUu1pM4hJ22HWk3gkE42PoTwU4zq/3+26k4zzaFRTiECe/bOe5C/MUFatyPClviMe3JbUfFDkT9ir/B5gbC9oj23nW2E9JYFL8yNBDKSSBLs1Og92b88lQmuWt9IQozA5bqgZc4WaW5ShVXoPLKP6CvAxoI+jScS8xcVau73LBd6GHIQsJWdwD+ex3GEeXHB76xQrJwtDx35baoNqH0Ednzp1/jg7+Xv9sAuYUpkeYLg3zzxL1dsbY7VXZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BLlRafDWGwjxvBo1GVdKnHqzv2zsctKpQyaV6jpY49M=;
 b=ZTJS0Ir5rubUmRd6lQFmkK5kLUkYJ+zUp7IJnhlOpXQQSugmrbvFkxpnBT4Mz0uu4gpSFNFw5qZdYeqqEAH1fj8d/NMRERVEqn+15z8a4wwGx/gJj2e6Xzhg3TgThDX0dIzTHqaAv9wJslG2uR89sug6xgjbLMy8YVeBn64O0O5Rzxib0aoqEX2Kg/nMafvwd6+3eul51s+NZZUvTLoMLERDa6OPcs/DkMwqzkiqm06O3ht8pt8P+AbqxcE8gCJkbi2ui/9TR4kmmFLXM8BmIRydITAXDWnsmrWcGOuyj90D+VRyFAS6ExfgootgLkC34Bm5+pXZMXsKYVvWJg5zRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BLlRafDWGwjxvBo1GVdKnHqzv2zsctKpQyaV6jpY49M=;
 b=wQGPUjgEMgd2SJXNibj7wL3zIU+LK8s2ltqeD126vogxoYcTRjDTUMWRyfqv5ibx4UuSwnXMr695eWZYjCpgw4APpLMZIjHolzUztIlTHA5394i1E5gKVO5+ptFerYJkMkvrLpJshFPuC60vQ11+ZHedCK6wK8UYtwwPRW4D8tE=
Received: from BL1PR13CA0087.namprd13.prod.outlook.com (2603:10b6:208:2b8::32)
 by BY5PR12MB4147.namprd12.prod.outlook.com (2603:10b6:a03:205::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Wed, 29 Oct
 2025 10:22:59 +0000
Received: from BL6PEPF00022574.namprd02.prod.outlook.com
 (2603:10b6:208:2b8:cafe::e9) by BL1PR13CA0087.outlook.office365.com
 (2603:10b6:208:2b8::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9298.4 via Frontend Transport; Wed,
 29 Oct 2025 10:22:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 BL6PEPF00022574.mail.protection.outlook.com (10.167.249.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.10 via Frontend Transport; Wed, 29 Oct 2025 10:22:58 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:42 -0700
Received: from satlexmb07.amd.com (10.181.42.216) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 29 Oct
 2025 03:22:41 -0700
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Wed, 29 Oct 2025 03:22:38 -0700
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<robh@kernel.org>, <krzk+dt@kernel.org>, <conor+dt@kernel.org>,
	<mounika.botcha@amd.com>, <sarat.chand.savitala@amd.com>,
	<michal.simek@amd.com>, <linux-arm-kernel@lists.infradead.org>,
	<jay.buddhabhatti@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 08/15] crypto: zynqmp-aes-gcm: Avoid submitting fallback requests to engine
Date: Wed, 29 Oct 2025 15:51:51 +0530
Message-ID: <20251029102158.3190743-9-h.jain@amd.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20251029102158.3190743-1-h.jain@amd.com>
References: <20251029102158.3190743-1-h.jain@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022574:EE_|BY5PR12MB4147:EE_
X-MS-Office365-Filtering-Correlation-Id: 30d9bc04-79d1-45e6-20c1-08de16d5221a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GF/Sn5tNT6+foZOVI9XONsnQvYoId26y2VfI+1YG7d46Wtk/shLfK/SOEe7p?=
 =?us-ascii?Q?Q6Bn4K3DIKvfzyJctlX8lrcZmABGlC3QawZgTa4s1/9Dl8CsXXeRTOczZAkC?=
 =?us-ascii?Q?dfqY2CtXGhsjj5LEN4yBYTK2VBq3EUu6mSoJSpxxIIp5nR0RFKXFLBmWx8Hn?=
 =?us-ascii?Q?JlNJd+1XwbLjazGBe3/h0lQLgEIvKIKIwZC4gf7vOVaSigEdj40ye8pBI8qi?=
 =?us-ascii?Q?LodjuzDR4D2UlyN33V5rvZahg1PFPVSFBJYDa3uHMDabrymNPWDDvCJ1VRtg?=
 =?us-ascii?Q?hRODQ3RjFOuuNd4KKyLYEEosOuC/Q8/isbY3vFEc1XonmiuAxVG2d4Z293hY?=
 =?us-ascii?Q?ZOtawU2QhsamMoN2ugACvDJyzzRhN/sMBsD0rhmvUF+KJEt/13+Gjevca6yu?=
 =?us-ascii?Q?fL7ljc3hUXlnBNOtOocFEBUTZ+2GfXO7rLk9CT0QN5X+jFJn7ydqNUcnKOyN?=
 =?us-ascii?Q?aQ/EDc7hJRXLv4OgiG3g5go79Qe879bL+B+iacnZa7lDxgwgwz/kiy27uedC?=
 =?us-ascii?Q?nBZ5Qc6xnKn/b6tyqDyqgr4VA1zKVVO5O9Z8q9nko1+ENKI5rcFqCZZpLdkQ?=
 =?us-ascii?Q?Xxlg+TDk6mixApQLJwL60zSAlMPz39mfCpIzkge903x5Dokc9bRuFo2X4Gfg?=
 =?us-ascii?Q?KRHFFAp9JYLxKQoObTREWwpTZkUFyhSwvAcEEDruODE4Bw8wXtThrTQpnPRJ?=
 =?us-ascii?Q?5RwSDrnVIvdhqiWkp9pX2I1xb8gUkcVFPpd0qwU9Zz7ynu7bxV6rD2AQozhp?=
 =?us-ascii?Q?0BZZkaEhk91r3hKg47jv4e/T3Tc4HMn5qgtY1kZnG03exCpaWbAOkTU6g/1Y?=
 =?us-ascii?Q?nF15bR53fVD1N4yYBhJpyjEeFAHM4VPVkqwTDpZTPX8k3DdiM9fXBI44QjYd?=
 =?us-ascii?Q?JIi6KB0bpgrIc1BCgCHgV0FYXGk4IMDKHcaih6x3t6onu+xDq2YC4FvzSmzH?=
 =?us-ascii?Q?pa5ZUwN77d8NwhxzvELtdJdDG4vUu69Q8t4PgMncKJw07Uqf9kAbLo/kpzh2?=
 =?us-ascii?Q?m58l9OcP1eFnzinaQ4tMVFcFG/fwzwm7kamm74RBe8zYADBl8BcSB9Sm0Zaq?=
 =?us-ascii?Q?X2cNWqF1oESLZAGawasCi0tXSVHfvVr8xRs3oX/cB+PKbjueAq6MEfdYJUJk?=
 =?us-ascii?Q?iskcF2zCNAa5xBpUcokgZweJpnZx0o3MiBHnsQPbAe5qY5ftqk9E0FD16e4P?=
 =?us-ascii?Q?3D/gbG4qf69SZ5xz3qosAFxyc3Q4Jn9xAQaL43pCfjUJuyrRhczdGXYPXlYF?=
 =?us-ascii?Q?vjZ+pHPcq2SJXK0KgyqYWNwfvsCFaW0EwafEvssOu0pE9q8lTS/t4UvQg/xy?=
 =?us-ascii?Q?msmgzSjgdQYoy5JYZHdKjktL9Jit3ML+1z1kRYBaUOP5xKFM0vNXcFQ9+mbd?=
 =?us-ascii?Q?g+Jnc4rI8sL9l8+038CGghHC+eUOOuQLPvGmxak/UxvWlf8/EzNBBX9i9a+F?=
 =?us-ascii?Q?kfzMCTrTncoNfEXKfOiG/lr90T7hhNH5wBInh1b8R6MPKXLQOJg9Yf6JHKPV?=
 =?us-ascii?Q?k/ccoMkoEkjwvSbkXvB3gDEgkWXSWKMavmt29Wv/w/CYp/y/ns9VeWKWKyMt?=
 =?us-ascii?Q?/v54O+amLKsGazfB4qptkgxUMIw9uK7VWxdVZJ1c?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 10:22:58.8731
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30d9bc04-79d1-45e6-20c1-08de16d5221a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022574.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4147

Don't enqueue requests which are supposed to fallback to s/w crypto.

Signed-off-by: Harsh Jain <h.jain@amd.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 62 +++++++++++++++-----------
 1 file changed, 35 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 3b346a1c9f7e..9be1305b79d2 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -204,31 +204,9 @@ static int zynqmp_handle_aes_req(struct crypto_engine *engine,
 {
 	struct aead_request *areq =
 				container_of(req, struct aead_request, base);
-	struct crypto_aead *aead = crypto_aead_reqtfm(req);
-	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
-	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(areq);
-	struct aead_request *subreq = aead_request_ctx(req);
-	int need_fallback;
 	int err;
 
-	need_fallback = zynqmp_fallback_check(tfm_ctx, areq);
-
-	if (need_fallback) {
-		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
-
-		aead_request_set_callback(subreq, areq->base.flags,
-					  NULL, NULL);
-		aead_request_set_crypt(subreq, areq->src, areq->dst,
-				       areq->cryptlen, areq->iv);
-		aead_request_set_ad(subreq, areq->assoclen);
-		if (rq_ctx->op == ZYNQMP_AES_ENCRYPT)
-			err = crypto_aead_encrypt(subreq);
-		else
-			err = crypto_aead_decrypt(subreq);
-	} else {
-		err = zynqmp_aes_aead_cipher(areq);
-	}
-
+	err = zynqmp_aes_aead_cipher(areq);
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, areq, err);
 	local_bh_enable();
@@ -281,26 +259,56 @@ static int zynqmp_aes_aead_setauthsize(struct crypto_aead *aead,
 
 static int zynqmp_aes_aead_encrypt(struct aead_request *req)
 {
-	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct aead_alg *alg = crypto_aead_alg(aead);
-	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct zynqmp_aead_drv_ctx *drv_ctx;
+	int err;
 
 	rq_ctx->op = ZYNQMP_AES_ENCRYPT;
 	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
+	err = zynqmp_fallback_check(tfm_ctx, req);
+	if (err) {
+		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
+		aead_request_set_callback(subreq, req->base.flags,
+					  NULL, NULL);
+		aead_request_set_crypt(subreq, req->src, req->dst,
+				       req->cryptlen, req->iv);
+		aead_request_set_ad(subreq, req->assoclen);
+		err = crypto_aead_encrypt(subreq);
+
+		return err;
+	}
 
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
 
 static int zynqmp_aes_aead_decrypt(struct aead_request *req)
 {
-	struct zynqmp_aead_drv_ctx *drv_ctx;
+	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct zynqmp_aead_tfm_ctx *tfm_ctx = crypto_aead_ctx(aead);
 	struct aead_alg *alg = crypto_aead_alg(aead);
-	struct zynqmp_aead_req_ctx *rq_ctx = aead_request_ctx(req);
+	struct zynqmp_aead_drv_ctx *drv_ctx;
+	int err;
 
 	rq_ctx->op = ZYNQMP_AES_DECRYPT;
 	drv_ctx = container_of(alg, struct zynqmp_aead_drv_ctx, aead.base);
+	err = zynqmp_fallback_check(tfm_ctx, req);
+	if (err) {
+		aead_request_set_tfm(subreq, tfm_ctx->fbk_cipher);
+		aead_request_set_callback(subreq, req->base.flags,
+					  NULL, NULL);
+		aead_request_set_crypt(subreq, req->src, req->dst,
+				       req->cryptlen, req->iv);
+		aead_request_set_ad(subreq, req->assoclen);
+		err = crypto_aead_decrypt(subreq);
+
+		return err;
+	}
 
 	return crypto_transfer_aead_request_to_engine(drv_ctx->engine, req);
 }
-- 
2.49.1

