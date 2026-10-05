Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013036.outbound.protection.outlook.com [40.93.201.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C254CE684;
	Mon,  5 Oct 2026 16:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791216984; cv=fail; b=PFABJkcQgiqt9E+beQUVo2eJjlQ9kA5g8KYSYMLR7s8MYlYio2V0hoYnRvQjqej3zyrQHHmlezOlllZZ5HGNmQY0a+9ssNBLR2ojynf1r8yBMsz4G3i0CRPAQEDZoahXAdBlvVeVeTw26sYfSpPQJ0hTmV4tQreGZxkjmO+bIA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791216984; c=relaxed/simple;
	bh=vXDSKZelxNCKXKbYssSyB4TbWqvFFRO5sr9P11yiqrg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KNf1gxpOikxw2nrkXs6h379ebxAzgp62GKMSU028t+2jc3ZrdAPJjQzFLRauPQtGNo7iq+mVOiHHvi+vjCMLLbgUw9hn/t1oopjlonYU0ZnG0O7CO6UpWCJLXmu3TYv/gWyck0X1tzIaYE4h9ZdWKZx3FU2Suxrbt9Ne+O/+oII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=1V37rRbx; arc=fail smtp.client-ip=40.93.201.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1V37rRbx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QbrCiZ9vZOzK3cHOpatnUR7VV0ob4MnvRJ7Y6yhjGAqbTLw/HKitry39aEDFLvq+IU3+yRhfwCgKJRL+wrDH5Y2teE6mQeZM+ISiJoCgj3yTQ47/rjgPqe3Ji/G6sYLXHNPYeFidbJVRkCN4Stt1FIWr2qTV9bS/bX76Gbkxftm2vSGgX892njp/XhPqg1j525aHyckwmtdC7Kpo3rILUrnnmA9/hUWEZqf7dOEvmTQtHIV0CmmKyDPGwHm16PUOAzQNh1/6W0QK2M9ahUqBu+6BhLD6OZEOWAzhFsgoZ4adN7VWcfComy1KiLpgq3CX1fxy4NhomN4R6rDESvaN4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFh2VopaElzfTKLt8aBDjde45autjGvJbfnUGE/+gxU=;
 b=lHjNNc5E7IgikMM1rB01keaZY3t0ftea4hAjPwO/81bqp/pZqk666EqsHUKIgux8bqna2+s9z9yn5mUhJCDCHGU98mka+6fN538/u++MkC6ei3w2haaVeV5Q2aycwB5ipyaAICJzKAq7st69XrWPDD30+pAj1OO/FFS9owBfYR4J0sq6vnISayS8v5bNhrigfH8M4LT+VBon3acGZqef8nhFgABj4IR32KljbcHBxCodjltejgOy8WGhyu7MIiGHrWjlqtPAATIRWWHEjadHLgiZUZ75dvRKmbI9tY3JMpQ8IkVuuhtu1VHNES7bJOyf+g6+08LkL+nn1W6JkeqXOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFh2VopaElzfTKLt8aBDjde45autjGvJbfnUGE/+gxU=;
 b=1V37rRbx18eXb7qcAJekFOJwpknla5GjXWcnEL1EtPBLUOyFrcK6q3y7WQ8nLwCgfhGpYRBIZEI4cDsafHXi3NEkxGHNAebjIWokndlvK1XbRhkN+mLy2gSJNpVZv0P+whocIucSHDqBsQ9qeqToxIjO1kpnKz/84bTnswyTyzc=
Received: from BN9PR03CA0216.namprd03.prod.outlook.com (2603:10b6:408:f8::11)
 by CH3PR12MB7690.namprd12.prod.outlook.com (2603:10b6:610:14e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.18; Mon, 5 Oct
 2026 16:16:20 +0000
Received: from BN2PEPF00004FBD.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::11) by BN9PR03CA0216.outlook.office365.com
 (2603:10b6:408:f8::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.20 via Frontend Transport; Mon, 5
 Oct 2026 16:16:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF00004FBD.mail.protection.outlook.com (10.167.243.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Mon, 5 Oct 2026 16:16:20 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Mon, 5 Oct
 2026 11:16:18 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v3 2/7] firmware_loader: Stop pinning parent device per workqueue invocation
Date: Mon, 5 Oct 2026 16:15:36 +0000
Message-ID: <18e6768c89aaefdb260bd2cd55daef67f5118451.1791212077.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791212077.git.prsampat@amd.com>
References: <cover.1791212077.git.prsampat@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBD:EE_|CH3PR12MB7690:EE_
X-MS-Office365-Filtering-Correlation-Id: fa2ba578-827c-446a-4f41-08df22fbfdd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|36860700016|82310400026|260925021311599003|260925022911599003|260925021911599003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	qnOryGs5skMmMTACBxoeBvMuFuSDwt3tanpGUzknlvXTp13JZ8Eqq1FayrlQq9Zfm8qmmGSVwOgzF2HSmw+SR8K5UI0o0MM+Q06TtjS31vIsRKTT9O/jJzQEFwgV2oSNhX/UP0jQDqMtZz3FBjtSFqm0+bA+3p8wuhWn071Vo2ao75bUM7v5I3AtVZarVYKVxQ0M5JckjT4owmLNaBAcQBJ6p8uihNFY8n0WfrhbZydy8+grNxZMOYzyThBQ1RdKr5Cp0YWpOuJq2XO3PxD5slwtZLYv+L5oHc12ZVz7fjsCAkcfOpijNaQaWSRB2iwjmaIL9BtWXCLgAC6YeQTLstW9n+CyUf97/PuNmwmYDmh8hKy12VHQXOuE2BuYyyxXVQv/ZP6z5HDSpEUMLcmg53f+BvQAPGvuXDJtMmQdMDEfaU1HKAXV68XfWpCmHK/FkTIy/sLKk/qhxIUrxyPNKMisDb5S0Xd7A+pbpHkbXF0tEXqm3m2rjDtsfLlXjy3B5XzAt6ZnVaZhR9frKtx/tjl6Eb10JLIVH7ycLdAbnP6Cjm7Ya6zXPjLivvVYovPGRQyauiVgliK5ceWO4g1bzv4W6bVEoCvPQjLTjnzpg4dq8aN5+58vcExLyH/Lz8vzvygLwS9LKl17v7iYNEJdF3MJfAbn4WO6G4Vc273RdcCEUvtWbJFgBQN+Jaq+9ph9jf8eww+H3xNNtHNyiND5Pw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(36860700016)(82310400026)(260925021311599003)(260925022911599003)(260925021911599003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PGH+tbwLmSdHiTwnsKuNLEaD+nF0bkKIDXLHFoQD9ZWOwqxwlZoDf4x9pHjq+63Z0UinrvSvGYto/gWiP09sCcihZxT/6FLkOJYaXdWkkGlWLoeELJ2ogesRm7ElxZ1Nw7Vq5mig/0x7Irb73d6lOdYRaNJxMgBh6MTrhRXnZgV7VlpDTM8W40vSVOtnI9uprqyfomONjkT6S7E3oMsry+aWjzCqS+rcak1L2HFuB5LEgLAnHHOlhEG9Bp6RP9x+Cv/HZ8y9owc6s0sseqyl8PPRwjKOW8jcOdgITxY6lvLCg0YUJbcboFvPWlqI3dW60NANQyHYKFvIYoVdVrDZhrgR1eY2n399shPYyYOzNyCHJpMG/PblzokgV6WKRylh3Zr13fVB+twVrpNtMY4PfQ/1BL2V8tP/tnUbyWlmTQcEOhVjNIx3VbrzOKHvHfhl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2026 16:16:20.0158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa2ba578-827c-446a-4f41-08df22fbfdd4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBD.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7690

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

