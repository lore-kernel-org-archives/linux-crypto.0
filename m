Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794591343;
	b=rteYOafjGFSMe2LyrRpOjZSA5XM039RqytJUG+ysdk14+x2TaYs0EoYWN0FuTGaSqsbn
	 e0NSD5LRvgFoplehoZJSAlrTaFYLsSzykWO/+nXN6gUP2VKgxqSCTl3npz/x9z+HSWCMq
	 Us/bW+u6C+CY518kKv0VTAhESmpqZvGgUq199X1wP5YTVE8baTnaeTDIBgNKB5VwN9aaR
	 EXZdNMLGHG0UeAfst4LdnuV79QZT6AAorRYkQqSn4espqpnA7rPR9UjvWfBLjgUcK7fEK
	 U+x3k11gHXOveeFUsuqPX+oT1zVFkqZL/n7I5oEKQw9UY1lnN8it5mYy66TXOx+xwZg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591343;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding:Content-Type:X-Originating-IP:
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
	bh=fLh1MIK/xsALO3Uh6hphO+vJRL63Df2HUV8zs9j8qYk=;
	b=dyYqHwqdScFADUygGsKx4HnsN1r6941dzEjcziOCWCJqTsi6kg2nf9GYcM5QPSSM+u2m
	 bhqUck4qSpDOhwh04NXHNHIHdCtDs+dtnwcxHpBsBsLL0Wk5G3qojzqXkOBde3jmgXAh6
	 7XOOU7BRlzWj0t3YhZn+BsqZIXoQN/DkIWUFGEWDjz3poyvsRCWmSbnExZ1H0QrIjKIKw
	 BUSfaJTO6qTbc1+K4+Jn59KGgzNJzjUorOPMD+t1NVUr1TV83Z/0jqaUh/ccMaYYEbP27
	 6lk7Ptj/0Y6b9/LpjpZlQMowW+e3mwPp4/FFAIWm/OBU3Af4tnt5kkcqwBIsjTCvkjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=nbHa8Zls;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.57
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012057.outbound.protection.outlook.com [52.101.53.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E3F606CEDD;
	Fri, 13 Nov 2026 17:35:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12E3F606CEDD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=nbHa8Zls
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=amjVdEC1YWip+0l9MhOSE64Ekdyirt3Gx6BBOwtxmHqvdgUCgzyMv6ceS4QX/RhT6/lSg/KqOEE1mODRq2WQ1MObpQ/DRFFvMAsjFey3Xyk6yJMuJWxoVbY4AXDwKT0gHohvMu9k+HC53qiPG93/BKBkYWh4WgClEqsoJcrkqK5ZTdHQSptO1UKnm5wbWiFZ+Qnhf/w7RFTzQVX48lWOEOAbKH1xxBLqrjKmAFm9GldmtMq/GtnGKYOUScx6x9PzOw0gqnkL+trK6R+5HW/GeVUlxVYCy9ovqhoajaTo/PdfHxBMbx3lzMPJTuxk2AOJV89+kmN6qDrPJ8ep6iiXaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLh1MIK/xsALO3Uh6hphO+vJRL63Df2HUV8zs9j8qYk=;
 b=S8eRic8Ulmr6jDUHbQ5CQd9QenbJSaU/846ZM9lpURxK0riymvTuU9nzT1fouFo5ZvIN7pXJCBk8IWPD+o7Gju+iVWMlDAh5X+LvIhfFx+LrPS9pDXUQsmPqIPSC2T+ZUZo3uPfnG3RDndSxAubI7lCtAO7ulDq74FJsds9zTM6LtdXImuCieHyvw1fZGxcZ1hNfC98b+rurxjP7xcm67sDDLfDZ82rNBUA+H9yfRZ38k7OfeeyxNfEg3Hu8iM8LpwYNlXlJ55CqQS76NPWvsFziWzLbpvduBDwUm6GIKvlAB+yVueIrWqp3TsltTZ3aCRY0g7TG9guLKuoglaoPWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLh1MIK/xsALO3Uh6hphO+vJRL63Df2HUV8zs9j8qYk=;
 b=nbHa8ZlsuxdmhK1oAZ7Ip4L71w4EOpTdImnnzt9AkTvpc5qTZx1Lz8WBmqwGMCIgv6CI8PAfRW95JogPsAnGoeOgE1vgPWT45JWNFmIzKBhL6nvSLm55wGYMalJ3rMXnIJ9fDIz5tLa6uWTmXL0PDFu/0HieIAMv3I2Ct2U7utg=
Received: from CH2PR14CA0031.namprd14.prod.outlook.com (2603:10b6:610:56::11)
 by DM6PR12MB4299.namprd12.prod.outlook.com (2603:10b6:5:223::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.10; Fri, 13 Nov
 2026 17:32:30 +0000
Received: from BL2PEPF000352D8.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::4f) by CH2PR14CA0031.outlook.office365.com
 (2603:10b6:610:56::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Fri, 13
 Nov 2026 17:32:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL2PEPF000352D8.mail.protection.outlook.com (10.167.254.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:32:29 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:32:28 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v6 2/7] firmware_loader: Stop pinning parent device per workqueue invocation
Date: Fri, 13 Nov 2026 17:31:55 +0000
Message-ID: <1d2829a434690df533af4047ed26d7bac80200ff.1794531772.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1794531772.git.prsampat@amd.com>
References: <cover.1794531772.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D8:EE_|DM6PR12MB4299:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a6e3129-b9f9-4f98-474d-08df41ac1754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|82310400026|36860700016|22082099003|18002099003|261102123227099003|11063799006|10067099003|261028144727099003|260925022911599003|260925021311599003|260925021911599003|56012099006|261021123027099003|261022105027099003|261026140227099003|261021121427099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	e2iLWGGwfLSzeOVZJ6cMxsWlLa1S+PU6h0IlQ9R6CQh+Ek8PNcIcqUUKSF74SpSdC2mmRsKewRQbyBXlcwFJTH21sNSitMb6zUM3m4QOir9B3w3ivrt/7dpWfbSmgejcchp9f7XOwmQ5Rc6stR3ZkUqVnPu8MtWIH769TpEhSpn48XsbGEPoyGrv8tvbzMqRb89460NtYWJ46Di/fDy0qeiQunrOJ+myV/relow5gyqzXDf04Mzy+icgSKbIeE4Wkq8w+4B0Fcv+2uLmm+FP5jjy3z8v8cUA4vPRSk5zX0R9H1oZf2jJ28+i/lpJs2WJAtHDF3ft1tXTdSdc13c9KfAT3LMlBuSXN0bZiYlrUWi7XmtIWwQRPj+1pxo9812DpfivdJi2ZlLs8+QJctDL7o+GhBIXeGsEyKXRdNhOVHDfnx6+ktnsESFTUX3uU3ynvZllsBdxRWds89VXZmCw3EgNwAoWaDJ7o/Sgci0L0/7QiKdRyF/f8f9Bp9HBaU9GPZkJrPmwS/0VXZChTzCq1YPL0sIEjga8O8UdiXasOx04ZXiKqR7ZEpEarw8UInaokVt82lcWNpUXlC2lVoUPb5g3mFMJkvf9Q5vS+ohhixacpdxnPiMH4F9FAjc+Klj/Q06YJoRfMKgEtlf6AOcUvWpXsfxGcquuqf3JURK94QLGPUAZ2mr1bkSG6s4+MUE4QIgiWPWwYCma88eay27ecg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(82310400026)(36860700016)(22082099003)(18002099003)(261102123227099003)(11063799006)(10067099003)(261028144727099003)(260925022911599003)(260925021311599003)(260925021911599003)(56012099006)(261021123027099003)(261022105027099003)(261026140227099003)(261021121427099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	vxNE/nNOIk/7cREVh6GzoLo4FKDQHSL0UOUhOonNEDVECypUMdgGsuGllxPBBmMdrSuAT7dxR3AFIYDLTk1gOmhw+SHcTaKoI+7pI2YmeyyRb31muhqQcjxVj+jWTzmbagu+py2ovheqPzVYpm2cBoJLTi7g7hu6kc/o6oomH79G4pdQi2qCbPNVTYSH5GOekJXnbtIxBGMpC59QfEc3u7SjTrea76MYkn4cZM7N/txxgxqTrtgcURpiGEc0b7HNl8krGBRAdOnTKEVfqXt15gcR30Tp3xu7H7aAl1giXKrSH2z2AMkr6zLAlfxUsGu14UsGR0HJ2HMvqM0TRLS8Zdpybeek8EvA2BpjPPZLXWrF0HUbCaosIuWckSyE6FYCWMfCQfmkBbqjU9OMy7+JKkRlzTPk5aqGt78R6r4Ixs0gf6mviptnNWfGfxBTZtpj
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:32:29.1123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a6e3129-b9f9-4f98-474d-08df41ac1754
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4299

From: Dan Williams <djbw@kernel.org>

The device core pins parent devices while children are registered. As long
as all usage of the parent device by the firmware_loader ends at
firmware_upload_unregister(), no per queue_work() reference is needed.

Now that firmware_upload_unregister() holds its own parent device reference
over the child device_del() and flush_work() events, the per queue_work()
reference can be deleted.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Russ Weight <russ.weight@linux.dev>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Chao Gao <chao.gao@intel.com>
Signed-off-by: Dan Williams <djbw@kernel.org>
[chao.gao@intel.com: drop unused fw_dev in fw_upload_start()]
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v5..v6:
No change
---
 drivers/base/firmware_loader/sysfs_upload.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/base/firmware_loader/sysfs_upload.c b/drivers/base/firmware_loader/sysfs_upload.c
index 6f2123538682..890a242a7c20 100644
--- a/drivers/base/firmware_loader/sysfs_upload.c
+++ b/drivers/base/firmware_loader/sysfs_upload.c
@@ -176,7 +176,7 @@ static void fw_upload_main(struct work_struct *work)
 	ret = fwlp->ops->prepare(fwl, fwlp->data, fwlp->remaining_size);
 	if (ret != FW_UPLOAD_ERR_NONE) {
 		fw_upload_set_error(fwlp, ret);
-		goto putdev_exit;
+		goto out;
 	}
 
 	fw_upload_update_progress(fwlp, FW_UPLOAD_PROG_TRANSFERRING);
@@ -205,9 +205,7 @@ static void fw_upload_main(struct work_struct *work)
 	if (fwlp->ops->cleanup)
 		fwlp->ops->cleanup(fwl);
 
-putdev_exit:
-	put_device(fw_dev->parent);
-
+out:
 	/*
 	 * Note: fwlp->remaining_size is left unmodified here to provide
 	 * additional information on errors. It will be reinitialized when
@@ -228,7 +226,6 @@ static void fw_upload_main(struct work_struct *work)
 int fw_upload_start(struct fw_sysfs *fw_sysfs)
 {
 	struct fw_priv *fw_priv = fw_sysfs->fw_priv;
-	struct device *fw_dev = &fw_sysfs->dev;
 	struct fw_upload_priv *fwlp;
 
 	if (!fw_sysfs->fw_upload_priv)
@@ -249,8 +246,6 @@ int fw_upload_start(struct fw_sysfs *fw_sysfs)
 		return -EBUSY;
 	}
 
-	get_device(fw_dev->parent); /* released in fw_upload_main */
-
 	fwlp->progress = FW_UPLOAD_PROG_RECEIVING;
 	fwlp->err_code = 0;
 	fwlp->remaining_size = fw_priv->size;
-- 
2.43.0

