Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792619853;
	b=UlTkJIQVHcezF3ZeV32K0PW4168+sknBsc1FKBIEx2Sg7o2CrW9p6bqc7Ol1bB5uUX4n
	 IS2ap4nTijI/wu4GgB/77m1NCKSUTUhDuC3hbOwUt5+UbaviCRitgEyUDWVXLWK/4/sUa
	 Kx0fbyX/tMQxv5JsIPwJUoZFFIhlu2k3xyz9gunVlUJTm130WRS0K3zbOu6Z9vO59XECR
	 65VU5eviFkE+ZaGIfmkU5bAMqMP/pzghe1LDzmnUFk1S3EozzyrPYMtcQFe3++9S/REn+
	 fLZc2QCCheTxg3Di8oJ/qj6XfmJC5misikhfSZb/Z6StC3hTDIadgVrVBAlcvdEcbeg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792619853;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=vQHJAznGp/je5ytACKOZiS1UtIKNgRL/SL71t8jdxAM=;
	b=hei3nW2jCohznk6LeuqSdc4PAUSIYmJlXnJn1Ru0OtxrOdfKb6lY22ifE0kcsH/nMCbr
	 dAjWK9xrEiielK7hAHL93uSI1RyKv/Is0T5g+Lw+4tCTLYWBpEdm4HDJRM4k++RKPyOd+
	 GoCUsffiOBuqQAtVXFr2u4MGsBY8G2MeYp0EPliHxA9k9AkfN7yxut+CzIkm3ETlz+YkC
	 GquXCFGOfkM82EBJRuX3fJtkpemMlRlDfFimkwsc/+t9wWcTOHSTIG0U9KtMZifw/YJ7B
	 gttrMVkGQMVGDFMCAkVjzqITGS6kA7LJ44YJRaik62OAFQs8TFnyQJrZz38rDGLJZAA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=cGlU7Mrz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.48.10
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531EB606A31A;
	Wed, 21 Oct 2026 21:57:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 531EB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=cGlU7Mrz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cyyrk8ONzgcLZCuNHslYLQ9mxm4TLjkbP+jwAhqAxc5pR7lmZxjNPDMyDi23AWobke9dJU793gw3Lbae6/NLo4zp1SjyPBFIrgKEPxL86ua9TC7KBs/plz3g33sJLPDPLyDayeusW1WnzSQwrT0Zg4sZxgkgeftA4ymhlb+nm/Aa3fJdQxfHoCFKS75ovmNAdMwWOBGn6am4XNcWUn9Hm08fX3uDQZrKtSyv3F2mUIUXMBnq0jjiaoPedzyl5m69QJASat8uGUeTxbuSHbrXATfIigknmcEX/DbFI1+oRn2sFVkS1B7NNosaIDgzZMWmfxe90uVReNaxN1pF8zVLaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vQHJAznGp/je5ytACKOZiS1UtIKNgRL/SL71t8jdxAM=;
 b=op7/7C2zNxPdM7YNEePzz9iG6024FSI4gKT7d7eX3YVL82rhzLEtD0T6DKbBiXt23wHveQ3MVD+xaLUXilVb36OiIAj4Pdvqq8JOpajYfP176FJgQ/nIr0OtUxaoDjiDaS4NuL4uXgKrZYaMXxigdSKsC+8BiKUI9bc6pzi4urdGnRv8OgYfIda98aGFd+ksMNxN796f4OCXbhS6imJis3sVeaBEOkJLf7LgQsK9daHP//ebRQA15H/TbALhNw1jYeX6gZ6LNk0AcBZW4CBIPdGzb5+chAAcgphpSCDSlFbRX6z1INSDBxufzV3V5uhuAnnmJk8HLuV82podW+xgGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vQHJAznGp/je5ytACKOZiS1UtIKNgRL/SL71t8jdxAM=;
 b=cGlU7MrzY2e4YyY/6l4RRpvLZnerNXWce+X602h2te8Gk7PRW5QrYrULkdfQ3KCM8nYNdB7kPvXga/nxmntTJG2aeE4l7Ku35zB2iaAwoeJBfs/D2zF748qShMVaqL0ONUpX6ftAGy8gKz3qRm35GyWXRHUw+rsE0UIbdWOcmjQ=
Received: from PH8PR07CA0016.namprd07.prod.outlook.com (2603:10b6:510:2cd::24)
 by CH3PR12MB8658.namprd12.prod.outlook.com (2603:10b6:610:175::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Wed, 21 Oct
 2026 21:57:29 +0000
Received: from PH3PEPF0005961B.namprd05.prod.outlook.com
 (2603:10b6:510:2cd:cafe::3c) by PH8PR07CA0016.outlook.office365.com
 (2603:10b6:510:2cd::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.20 via Frontend Transport; Wed,
 21 Oct 2026 21:57:28 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 PH3PEPF0005961B.mail.protection.outlook.com (10.167.243.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 21:57:27 +0000
Received: from dryer.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 16:57:27 -0500
From: Kim Phillips <kim.phillips@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>
CC: Mario Limonciello <mario.limonciello@amd.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Kim Phillips
	<kim.phillips@amd.com>
Subject: [PATCH] crypto: ccp - Run the destroy callbacks when psp_init() fails
Date: Wed, 21 Oct 2026 16:57:16 -0500
Message-ID: <20261021215716.1076732-1-kim.phillips@amd.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PEPF0005961B:EE_|CH3PR12MB8658:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ebe9929-c919-4b0b-eac4-08df2fbe4c21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|82310400026|1800799024|376014|10067099003|18002099003|261021121427099003|261021123027099003|261009223027099003|11063799006|261009221227099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	ohqy1zEDe7RV0EKOI9ZewG8UIZKuSX0vT0llBJP7GzMTilyWnl0fq1pLjtpbApb7H+BFaQJOQ59QvVDICKfgI93+ElAw1kZxvWUf5/mEjwDLl5vI+6O0Ds6oYwuiG6fPXe+umW+U80qbKi3PmUa/qX9IgNz9Q2FX0tNiXQrdPClZmXyudoXbx73iaNCNAxouOAoUkZ73NDE7E5dwvKAFpommx+E7p7N33mu/gdY8lHEw/zHNC/nDfG+BIJsKi4FSdhKYjAQCbubLqrcTvj3EMq4y1Ip2d75uYaXtBK3X6KCBAPZm/0NrzVBAZSKivpdNBxi40hlnEE9GGqEdrGzk++9Wwr+FJ27tTdaC+7LqmSZ/xEbqAwN+XtizEmq2AYksAboOeFUmQXtGKnioQCOBegjt2fJmxSiJ3BhezVl9qsqVUTgoKRs21TiXnSWuvJaTFGVPyF/RzmKqIurF3CTmVAMF1a3r/GlOV2FR/1wQ1s3BG3FK/z2lK/SUUql1yzVmA2eYb7xTISXtwRhE9D5DyU1QnnMZtvWBmlvmXU28cNWHc1veWosm8D1WhBHW94yVqEsQcrUR2G+pw/Hjajh9Wbk43wsCGPTobIw3f1bOopRn++h/rriekAwwMLQgIR+RnPytBHMrT1JsJHUfejuND1M8lxvId4wIT08UnqbPNlAT0Xb3LJPXzmPTZ/2GCld+xuB/AQYVoPTv0VBxK7phCQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(82310400026)(1800799024)(376014)(10067099003)(18002099003)(261021121427099003)(261021123027099003)(261009223027099003)(11063799006)(261009221227099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BRLJBhJNeRFpoM2TbqneA3ku6XLsWZ8qGIRRbOi+YBtn+tnzkyE2oS6unb5XA9u/LMS7yee7mzmlyxzVysb8qlmMKzIeHdni7RjHKgt2QRyMikYh2Dfm3yufg2l2/jnUUTkxsQnaczoTJU67uCqNndf6e02Vo08UiCK7njHRGyok/p9/i6Y3L2AqcaIyHHMepO1f40rE9dKneoZcbL/y5n3kbNEwWWbrphQXkki3TXx68hQhmc+Z3dEGDuALCm3vTHCq1YP5Tfbfd/UEWBgyXsDa6EbMAOtmZ0r4LU2QmkoNL4rNPS/p4RLpvneTZBICieDdvB+/WimXb29PY2GPeHUOVYBK849zMcMTIWaA2pzKjY6kl2O5rY6XKc8Z4hoKLGbK5130GSXK0I7j5Q7zK3GVViZ3zawQpd9wDqksGSymjc2vq+cHmIWFpsL16lB1
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 21:57:27.6822
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ebe9929-c919-4b0b-eac4-08df2fbe4c21
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	PH3PEPF0005961B.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8658

psp_init() brings up SEV, TEE, SFS, platform access, DBC and HSTI in
turn, returning on the first failure.  psp_dev_init() then clears
sp->psp_data, and sp_init() ignores its return value, so the device stays
bound.  At unbind, sp_destroy() calls psp_dev_destroy(), which returns
early on the now NULL psp_data, and no subsystem destroy callback ever
runs.

Whatever came up before the failing subsystem is therefore abandoned.  Not
everything it owns is devres-managed: tee_dev_init() allocates its ring
with __get_free_pages() and it is freed only by tee_destroy_ring(), so a
failure anywhere after TEE leaks the ring.  DBC and SFS are worse than a
leak.  Both register a misc device during init, and both deregister it
from their destroy callback, so a psp_init_hsti() failure leaves a live
/dev node whose backing state devres frees at unbind.

Call psp_dev_destroy() on that path instead of open-coding the IRQ and
master device teardown.  Every destroy callback returns early when its
subsystem pointer is NULL, and psp is devm_kzalloc()'d, so unwinding a
partial init is safe.  This also fixes the teardown order: the callbacks
now run before the master device is cleared, which matters because
__sev_platform_shutdown_locked() reaches the device through psp_master.

sev_dev_destroy() is reachable here without interrupts having been enabled
yet, but it does not issue a command: firmware INIT happens later in
sev_pci_init(), so the state is still SEV_STATE_UNINIT and
__sev_platform_shutdown_locked() returns without touching the mailbox.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 drivers/crypto/ccp/psp-dev.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index b14ce51065d5..4eb49eff9590 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -282,7 +282,7 @@ int psp_dev_init(struct sp_device *sp)
 
 	ret = psp_init(psp);
 	if (ret)
-		goto e_irq;
+		goto e_destroy;
 
 	/* Enable interrupt */
 	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
@@ -291,11 +291,15 @@ int psp_dev_init(struct sp_device *sp)
 
 	return 0;
 
-e_irq:
-	if (sp->clear_psp_master_device)
-		sp->clear_psp_master_device(sp);
-
-	sp_free_psp_irq(psp->sp, psp);
+e_destroy:
+	/*
+	 * Subsystems that came up before the failure own resources devres
+	 * cannot reclaim - TEE's ring pages, the DBC and SFS misc devices -
+	 * and psp_data is cleared below, which puts them out of reach of
+	 * sp_destroy(). Each destroy no-ops on a subsystem that never
+	 * initialized, and this also drops the IRQ and master device.
+	 */
+	psp_dev_destroy(sp);
 e_err:
 	sp->psp_data = NULL;
 
-- 
2.43.0

