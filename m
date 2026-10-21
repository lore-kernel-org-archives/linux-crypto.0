Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.35
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792602354;
	b=zvy/7FhHRCmC5crcfiLHjJ2r412mpCQIOL9NEb2rsRxhcRb9ngepjg8aZzuO0051tlIW
	 2AfNouwx473VjeigV50mgn0eF/ErKvamXixSLSsYq94+BUR6YpolgsGHuqC2GjSa1QxxD
	 5TIbC65v6c5eA0fH74tuPuoKquK6zyArkhpjVAB8BG276IsLrRTwHhSYJy9w/i1FCbiUF
	 WSFXVpdgkirST1gXWGX3Fht98B0hgsm9ejq3F5efNzy81a8by2qF33a6ZTjJG1LWPKrOV
	 HDk8FKJll2Y4fKO9N5OuyC+K4+K4qmlpX6tUfVRUZmStSdJkUcl7Yq/KMJIDPsNwwxw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792602354;
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
	bh=QDdYm9vnz6zHWESjgmWqzMvpFBEJz0eaBUvpqAvz8X0=;
	b=YdWPH2fAkJ7IDLbBMxexJm1Cqm26Pi6EQtuCnNZFlPsQkAXpdeBFnFD/3AJRILVBDa15
	 NlSw1tkAL8EkPMMRkmEjtAdU9ZGvzTFwijvK7MXmRKPdFyJ0U872W5+fBoEGz5Qyd3xk0
	 56/a/tkGPUGvgdK5Fgg5vWWXY2BTM11w1jyS0A6hsKzHCrFvz+6Uu/XmKTajHmHhMpIAi
	 CHNiGTubymkcwMN4yNPwgYQn781r3IuJa/HYe1+jkrnsPgOX3s0Y+49qUDsHgWe46HIkz
	 Ne/s8809iPjWVMgXGO9Dt64xxDudINn4t7JT/EiUAzMFxrmoGoGIkjBiAYWOGSyH8KA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=4PYUXhEr;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.35
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010035.outbound.protection.outlook.com [52.101.85.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA167606A327;
	Wed, 21 Oct 2026 17:05:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BA167606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=4PYUXhEr
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CmZaCmlfCYeVFh0t3WnHIie9enkILPk63+02H3VHgdnAI1CtjMSdjO8sRe66MmhrJZjsfjJKjfb7eg0c7vippI1CRsisuxpUdv1QOnq3JoKu2Osp4/gC+YwnV4axwqNyWtf1tr/m2uMdGZrDUmwQ8Ho9+PBDdEDnyBnd5U0NpPNzRpY/iTlI55gYrRUO0eauVjsKGg381I1SHAt2cb20UyCCqY+s72Dg7Yk8q6mxoblFREgll+97w2Rs9nqC5T0Ou/YlikeDdQUF/iL2l8xjqqbMZUQm5B9Xd37+6m3JPH/gZDGBTZHGAebGEstuFWshmwo6QLqXRMYSHYflaRlyQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDdYm9vnz6zHWESjgmWqzMvpFBEJz0eaBUvpqAvz8X0=;
 b=dMsfGmdFwSsryWuX/xmm5IA4AU5KcQa3c7wWx/bZCeTe27r/WKe6xlR7JzxGuqIJOMbL7pagxscA3B6mKjxl11FRci41QUJokgWriSc3SDHJoZHXyb3uERne+mlhJ1kGp7bNzsD4eeBlJXJ+aCRYnaXZUTscQU8Az5y1MpT9Hwnv7M7wBhXHzDxB7xL0GCZRMeww11YEVLaTtp+3Qu/E7P6GcKen7eWSHKSfuiFEtZbh3FcEFRHHVlLFhwPi/Lf4G9SSapDeLuGOc8910O7t9xz2bLt0NTa1yu+HMh4qzKUvjyvCkNd25DijSkUtrkprHAWwnsfLp9kzEf9dEGIu3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDdYm9vnz6zHWESjgmWqzMvpFBEJz0eaBUvpqAvz8X0=;
 b=4PYUXhErVprC/+N051x2ow8uchp3NevSZd8Do2yrTjQ85YbdkO3J3Nb0iEAu9W1nWGTfV8apJkSPiC2iR9EuZCanknA9c+K7/J/eXdUF3PftTXPN4KYUvhi+Kr+TzdXwJBFB8Tir+gPHHul0CAzzyznCxjDn6c8WzEumtFEvzEI=
Received: from CH0PR04CA0100.namprd04.prod.outlook.com (2603:10b6:610:75::15)
 by MN2PR12MB4173.namprd12.prod.outlook.com (2603:10b6:208:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.19; Wed, 21 Oct
 2026 17:05:49 +0000
Received: from CH01EPF000BE94F.namprd02.prod.outlook.com
 (2603:10b6:610:75:cafe::3a) by CH0PR04CA0100.outlook.office365.com
 (2603:10b6:610:75::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.16 via Frontend Transport; Wed,
 21 Oct 2026 17:05:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH01EPF000BE94F.mail.protection.outlook.com (10.167.244.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Wed, 21 Oct 2026 17:05:48 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Wed, 21 Oct
 2026 12:05:48 -0500
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v5 2/7] firmware_loader: Stop pinning parent device per workqueue invocation
Date: Wed, 21 Oct 2026 17:04:58 +0000
Message-ID: <d39f35dfdddb715fb9de9be5481b8fd8dbb21b23.1792599491.git.prsampat@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1792599491.git.prsampat@amd.com>
References: <cover.1792599491.git.prsampat@amd.com>
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
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH01EPF000BE94F:EE_|MN2PR12MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: 685d9c17-d2f7-4bb2-e5d8-08df2f958e08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|376014|36860700016|7416014|261021123027099003|11063799006|56012099006|10067099003|260925022911599003|260925021911599003|260925021311599003|261009223027099003|22082099003|18002099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	1k1Xr4jaz1JMBK4hOVUHQzdsneMp5qmA/w7i/DjYcecQRUOT1gc4hdM2lGnlLViOF/t8onNVKvsHpiIA4L++zKaJQ40yXhNZtOJec4dPYRfMhKTtJS2JP6W42+tjEJCcNGkNeIhAc3wyIhPB/OV+GIja7/Oco/I2ObC/Ojz+aT665tfR+npNQcOW5F3H/QZqFfmiRBJRm2WgMFkyl7czI7dXuir086CizhxyDMo8crQDkhVR9D8Ngu3Qbg26akKrxQL+zaHCMLqbtTDaa8Zf792uhcmK6zpHDq9HrgcBRi+FhzvlULi8rgCXzC5nQW1ikwAKNSc2gy1eJZblSq2ZFNqnKsxkLfUPkMZ1Osfd/7sHe9WPRmRYNLzFdB9zL+5Bsvo1s3sK2YrVJqdAX0fvNPvufY7UDVr5LSFbZrhwwO+5XvP6Kt59Kes8a614T8tSAbmILHtvRRQv7xi7Z4I8El7qT19vs71wIsELHt99E2oFtsiIFKTRR/tWd0/zWur2ngIdB7ul8/QMAQ64exoT+O+FQ2clsjMl9yJEaMLW0mc3SGsYYyNXHkCRojB1rWZ+8zcwnDIy+oepg6V2VK2XUdIHtysH/f6v7OV02tgCKfRDAMqzfm0lzpG927L327zCcfUODxvK4XLzykVVJqAJAXShC4V/bh/LlFAv5BH5kb2AkHO4tNhIIgFjW3Keg5EQTv8QqZpvGW+CGSo+DWBpXw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(376014)(36860700016)(7416014)(261021123027099003)(11063799006)(56012099006)(10067099003)(260925022911599003)(260925021911599003)(260925021311599003)(261009223027099003)(22082099003)(18002099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	6GK564xvi6EnNXjKi0DW52TNoQZCygu2DbyW23Z9fdLq6NZvDwrCdtI0cku/Z3MIYhcVLqKfWwNYP2BwOfp3tRu2VOcPOZsoXJrB3715q8Rh/NzZ1sp7oV67aTJSXk52j+ASrTr2EkHqmA457PkE1+T2TtbLQXosDGjWZe/XcAdkDYMQ4drqGuukYFUyfllQKwF8sTYsmW1MMPLoTFYugm4M5jucjCMRsv2OPIcjJB9TzKsbCWRXvdIUFkyLgecCihcF+U1i4YsRXQLgtNK4L4uZi1CN7qtVA0IIervngtqkUic5KHcFIS/cn7Ak15gWe7VOY0rittOJD4o4Z5P8+LhYQJ3KWlhqy+bNHBmVtEf7epS0wwQV4z1QpUeVcHBQLf4TxgjsSVNDHYv2ScUYu41huVVdkMdRcW3KsRNzWztjXbgrmhT+NRY1MXxidIpJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2026 17:05:48.8901
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 685d9c17-d2f7-4bb2-e5d8-08df2f958e08
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH01EPF000BE94F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4173

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
v4..v5:
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

