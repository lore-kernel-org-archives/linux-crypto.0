Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.70
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794591436;
	b=AzM2w4dM54O5dqWPzAwpCPxEQ+0KnoYH0OV99NdyfnMyYaHlEo/6ybSOFbCntlBkeAzG
	 8yOqNOKQ2iwY4uw0juLUdfqOnlaT/dJbwEZRSLTAao9zhIDpTCZATlE4JW6aDYHAqgGKH
	 NzbRnFyG4VRgiGgZtgrNMqS1pyBR1gHi5uT7fXtue1eIn0KOO4Sgkhi8/nVu1PBdoIB6N
	 6LJubyMZEdHhD7s/uBviZIchFAgbPwZ0kOJ69H3Yo+bW4UzKmhA1MVkY0pxeuINdoIBfx
	 z1d3VH745qRLHSxoA6HNGbpZo7iIKtkkXR3vngzyhy6EcCfB/W2bwwnLfwof69Kf7rg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591436;
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
	bh=0XS2Cp4/EtCAYHWNUL5VlhKg9Xu0Q06lfJvYBnhjCbo=;
	b=Ewk5thuNf2wKuqEVlpKetpzYBLLlV1czh8mS5hwrFKcvKdjSOxBXxXXaDpD0eT63ULVU
	 MAyRfCrgFMyOQE9QUXjYRIK2N3CZD7QI/fQiRza+yOgpCrWK6ntZkPc0NFiyzjFenMaHX
	 876Wn25rJd7nYOaxhegnoYptJnml/1fztMx7/iCL0jQqa12g/txtpx5ck6N7AtBJTNFze
	 tyNGKFErTITLsA9j4Gb3YwH2lEJRhJFCA3adPai7l4Y0wK+YMhZk35pMGJJHctUi69jXF
	 olFp0G/FZ5nvzbODb1G9M0pHWLNNqzgTbHi3nZ7X0MROlEwd90JGm5wI8Cwi4GdduyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=A++QsLSW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.70
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011070.outbound.protection.outlook.com [40.93.194.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D46607B5BA;
	Fri, 13 Nov 2026 17:37:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53D46607B5BA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=A++QsLSW
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HFc/jFzQ8PNh6ovFO7AFTn8NSCaDq8x734PVD0DglBwjEroZzvYv0t+6LIqxq4MA68xCuRHpvPmYzZlwVmNLlPie8vzyLCgBb7u4nh++2N/pGmq+MLfj/kWM4WwSHfOe5WUiUxwMYlWvXjoxST+dHqq0msJYHuLhfVZworySakwKjDGRG+QJQjCaa3OjGx+hl7xLuyeNxNFnXu+tMepX/5GrXSmaLI6VKNPFp9EzGDMUSClGD8JL1NgXRMRg/TtGaS21t36A93g52EiJiOpC6bg1GRi+flTU954ldplE4tQLPh8S0YttFS0kBWp9qhCwBq9M8zSCUSY/Sdj/pSCigg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XS2Cp4/EtCAYHWNUL5VlhKg9Xu0Q06lfJvYBnhjCbo=;
 b=btH9lzmrP9VongQboA6CfEfZusccD7h/5MmDHAsotS5Yx/VVzJTwhMgAvnt7GymewTuo/wNnTpTIHhqDtxs3Uerwn0Ovel2QxHgnQ5cinXzWrI+5scUE1tCh/aHuYRzn/ZBTB2KBRgcawpIlsQOLdkDJ2NZp0vdSIfF7IlT9Ca0dl3XZ9DTHMykZJKvex+T9eSOa6f8YXgwh/ScNk7ofpohMfc4+9f6K0fXGRgUJXzfYXt29v7Ka/L2GZulaIyWl5hHz74l/n9YlJ4uOuZwBbrNFzk+Ua8Z1MBQFzFOaHc8mZn7RqvU4rfBIaDkggNppMglrZ6DvTnFoPsigYcnTPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XS2Cp4/EtCAYHWNUL5VlhKg9Xu0Q06lfJvYBnhjCbo=;
 b=A++QsLSWG8AZ57EnoRJwQcB2p0/Itx9od8O8ohDEtAdnbpmmMo1KDHp3nD3U84ndygl1ZuqiFM0Mkjj0lB+v5VTQ8J/gA6sy6WO3/w9JMgAY4qRTvLTfXZuFmz4dejsKOijIhSnIV0DlyrHre3T8Ba3gUCy2Wm8PxFVZcLrw52U=
Received: from CH2PR07CA0051.namprd07.prod.outlook.com (2603:10b6:610:5b::25)
 by CH3PR12MB8460.namprd12.prod.outlook.com (2603:10b6:610:156::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Fri, 13 Nov
 2026 17:32:18 +0000
Received: from BL2PEPF000352D7.namprd02.prod.outlook.com
 (2603:10b6:610:5b:cafe::53) by CH2PR07CA0051.outlook.office365.com
 (2603:10b6:610:5b::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Fri, 13
 Nov 2026 17:32:18 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL2PEPF000352D7.mail.protection.outlook.com (10.167.254.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Fri, 13 Nov 2026 17:32:17 +0000
Received: from speedway8455host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.53; Fri, 13 Nov
 2026 11:32:17 -0600
From: "Pratik R. Sampat" <prsampat@amd.com>
To: <mcgrof@kernel.org>, <russ.weight@linux.dev>, <dakr@kernel.org>,
	<ashish.kalra@amd.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<gregkh@linuxfoundation.org>, <rafael@kernel.org>, <chao.gao@intel.com>,
	<aik@amd.com>, <tycho@kernel.org>, <nikunj@amd.com>, <michael.roth@amd.com>,
	<shansinha@google.com>, <prsampat@amd.com>
Subject: [Patch v6 1/7] firmware_loader: Stop pinning modules on registration
Date: Fri, 13 Nov 2026 17:31:54 +0000
Message-ID: <92fd64a674c49c7128cb86cda55df3b6709d4a66.1794531772.git.prsampat@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352D7:EE_|CH3PR12MB8460:EE_
X-MS-Office365-Filtering-Correlation-Id: e345ed3f-70a2-4e4d-9731-08df41ac10aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|1800799024|7416014|23010399003|376014|22082099003|18002099003|261009223027099003|13003099007|10067099003|11063799006|261021123027099003|261022075727099003|261102123227099003|261102130727099003|261028144727099003|261021121427099003|56012099006|261026121527099003|261022105027099003|261026140227099003|260925021911599003|260925021311599003|260925022911599003;
X-Microsoft-Antispam-Message-Info:
	1vr6QuKn23tmMhj44TOrNe8vzCL8VFHSuGOJc+PXlqOJubEa4fGp0NMtd3/F4o+CRuWcTNtQki8viFfYe/l9ZBylaIj/ZkNYpcHLND+LHP9YQaWg0jCrg5WFIhuNE/njifLMZtZjv0zdltcrUBsA6Ju7ETxNxc5FYIC7EUGAN8Lp2DbBhYtsHjuEfU9svb/B/i5Lv4D0R291BiOvNxaQd14ndepNL5Lms5v3j+fziapNS9iMvkQoJ6NgsA5C2cMiPLmiymh4HJ9CB4gB/mUyT9GhoSOdCrMB3hI5E+/x7+ESXVOPy9dNsVFkt+tauhFZTE1qq1ZmyM1qlSE0xkScBHeYBBnhhAdpp8UN7wwWybxQme37GQ+GKURnnBzg4svSR+W07BEC3zUg0o3OA60+LWUsPAoqEjZ7MrCjnDPp57wivMRRbTCERhX9rXpcCOtpYwC5iL6QMy2Zm2nsYcnhMtEGUOv+/0nZgawfcP16u1QU3ucExqtpi29EgBPoT2qwAE8tA1gg/9BtghPNzQw8ghp+8EiVyvoaM4GV12Ij79JYm9IvLwQ8t/E9tFheU7Yqj8Iv0urgyXyT4TL4lRae1TGgiOBJUs8ZU7Z4/JxEmw1/d0NPoJNsw7JnmYO+9gereXf+iUt4KeZhzN6t+99gRg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(1800799024)(7416014)(23010399003)(376014)(22082099003)(18002099003)(261009223027099003)(13003099007)(10067099003)(11063799006)(261021123027099003)(261022075727099003)(261102123227099003)(261102130727099003)(261028144727099003)(261021121427099003)(56012099006)(261026121527099003)(261022105027099003)(261026140227099003)(260925021911599003)(260925021311599003)(260925022911599003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UG6wdCk97p5O11UwvxHC63tB0ORa8qRtO8ku5Xuv6ggdASq1J3sA4cHw2IYAAIByqvcm7sMS6tjZeU3G7VC7OAhL+18NvYgrLwnooWYszAyyuA9hdRRPFwSqzo7g7yAD7vNVgci0TKyGIhf3pxW8JoaXM4WU0hA7H2lhMadLLJPAFadeHFnx+/rDxhFhPTQL4bb/LDsqTtvcoSnhBnefNVnBAvRxYlnO7gzQFEiwbrPxU0TTlqVUkA6lj2V0z8ZX+jkM6B5YO233UGkOrSbscxgO94MD6rXjHLDrdpd7gzAMbur2PukbRoK0lpfC1ljVdb8yBDbTCaoeUNSHAxSTurxHe9Dl4cLRUtQXzxFY5D/X7E3Iqu8u8Nm1thvh17Ax7O/+RQl1D/ZofGovYysmy8w6sO2YosGBbyBRz0gy0DQ2Pt7kZE//4Ptqy0P0scxV
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2026 17:32:17.9262
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e345ed3f-70a2-4e4d-9731-08df41ac10aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352D7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8460

From: Dan Williams <djbw@kernel.org>

The module reference counting can result in callers pinning themselves in a
circular loop. The module reference counting is unnecessary.
firmware_upload_unregister() must be able to guarantee that all ops are
idle at return.

All ops are either called from sysfs or the workqueue, so unregister sysfs
to stop submissions, cancel any started transfers, flush cancelled
transfers, and then release the device.

This also solves a theoretical race of new submissions starting between
flush_work() and device_unregister(). The module reference was not
protecting against that race.

Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Russ Weight <russ.weight@linux.dev>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Reported-by: Chao Gao <chao.gao@intel.com>
Tested-by: Chao Gao <chao.gao@intel.com>
Closes: https://sashiko.dev/#/patchset/20260326084448.29947-1-chao.gao%40intel.com?patch=10705
Fixes: 97730bbb242c ("firmware_loader: Add firmware-upload support")
Signed-off-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
---
v5..v6:
No change
---
 drivers/base/firmware_loader/sysfs_upload.c | 31 ++++++++++-----------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/base/firmware_loader/sysfs_upload.c b/drivers/base/firmware_loader/sysfs_upload.c
index efc33294212f..6f2123538682 100644
--- a/drivers/base/firmware_loader/sysfs_upload.c
+++ b/drivers/base/firmware_loader/sysfs_upload.c
@@ -312,14 +312,9 @@ firmware_upload_register(struct module *module, struct device *parent,
 		return ERR_PTR(-EINVAL);
 	}
 
-	if (!try_module_get(module))
-		return ERR_PTR(-EFAULT);
-
 	fw_upload = kzalloc_obj(*fw_upload);
-	if (!fw_upload) {
-		ret = -ENOMEM;
-		goto exit_module_put;
-	}
+	if (!fw_upload)
+		return ERR_PTR(-ENOMEM);
 
 	fw_upload_priv = kzalloc_obj(*fw_upload_priv);
 	if (!fw_upload_priv) {
@@ -361,7 +356,7 @@ firmware_upload_register(struct module *module, struct device *parent,
 	if (ret) {
 		dev_err(fw_dev, "%s: device_register failed\n", __func__);
 		put_device(fw_dev);
-		goto exit_module_put;
+		return ERR_PTR(ret);
 	}
 
 	return fw_upload;
@@ -372,9 +367,6 @@ firmware_upload_register(struct module *module, struct device *parent,
 free_fw_upload:
 	kfree(fw_upload);
 
-exit_module_put:
-	module_put(module);
-
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(firmware_upload_register);
@@ -386,23 +378,28 @@ EXPORT_SYMBOL_GPL(firmware_upload_register);
 void firmware_upload_unregister(struct fw_upload *fw_upload)
 {
 	struct fw_sysfs *fw_sysfs = fw_upload->priv;
+	struct device *parent = fw_sysfs->dev.parent;
 	struct fw_upload_priv *fw_upload_priv = fw_sysfs->fw_upload_priv;
-	struct module *module = fw_upload_priv->module;
+
+	/* hold a parent reference while child is unregistered */
+	get_device(parent);
+
+	/* shutdown the sysfs interface to block new requests */
+	device_del(&fw_sysfs->dev);
 
 	mutex_lock(&fw_upload_priv->lock);
 	if (fw_upload_priv->progress == FW_UPLOAD_PROG_IDLE) {
 		mutex_unlock(&fw_upload_priv->lock);
-		goto unregister;
+		goto release;
 	}
 
 	fw_upload_priv->ops->cancel(fw_upload);
 	mutex_unlock(&fw_upload_priv->lock);
 
+release:
 	/* Ensure lower-level device-driver is finished */
 	flush_work(&fw_upload_priv->work);
-
-unregister:
-	device_unregister(&fw_sysfs->dev);
-	module_put(module);
+	put_device(&fw_sysfs->dev);
+	put_device(parent);
 }
 EXPORT_SYMBOL_GPL(firmware_upload_unregister);
-- 
2.43.0

