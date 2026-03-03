Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010006.outbound.protection.outlook.com [52.101.61.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7DC375F9E
	for <linux-crypto@vger.kernel.org>; Tue,  3 Mar 2026 07:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772522441; cv=fail; b=T6cY8db79X2aIjh9c98J4v/mr8DjTYTNeCsKEOsbuVmkU0vQfIeBcIoKRRIXggD7Vkj2vtyHrnIc8f3rk+LnzKZus9Was+8FARFpr18NpXig+24YvFXi49T6/GW420nAWa9OdwuiTH6B03KxBSMeClP9NQ9UfiaMpcHSQSI0YUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772522441; c=relaxed/simple;
	bh=Q5HUcoGJD7EzJLIDs6FGd08HHqMacJHVE/MSCnFrNkM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UmMUQz9QmZufG+L5uV2eD3StKQvSL1dRiRpyHToCEiozW2rAmANFbe04jrCAX2rYBVOnm4gdYoeVdThEeetEtc1nf4cgh6S3x7dTSDboY0O5HFFxOuCCrUTKZERt+zAKpFvv9tNxtpkwM+QJGYeEWnvRvGNMzc9gZoI6C3dweI8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pBz8g7VT; arc=fail smtp.client-ip=52.101.61.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pBz8g7VT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Oqcpq8fGW4Tpole7cSe/pnHt26VXyRF5b7ZlfmOhAU57xO0ibqVBTcM384qVf+wxKqlSiqo15vjYDXFz1GIYp+5tnUOD0vqonwoFqWUS6mYSJTBE099QTBh5dHbqFAM3pEfK7lWkfEl151LDVgaAEkJlmhuC3d+PJGFrg2iqsbb446wzK3Mjffn3s8XM6i94896Zr7lo/BZUxc/9s1wO/+amUWkufmjbgoni/8QLdTIYs3KVdqlRXdD7HFrDSd69BvvkpaqEXIpRjL4Vh31S0YhRybHsfOVSiONB45GNMAJ9956qGuiWiR2SOln69THzJKupq7lZP5JaRBUteFKELg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KFdljFrgoAyzaDSyqU0vTK5MjGg0kZf/wFF/8ZdgKQE=;
 b=mLiMkVtj3Dhg6bFr3jpO9FmgRvM/5rsnEx3n2k1ekddlX/ymKznjlrEj/qdUF87u4+Nf0D7rS4YI3ci76N+5Yu9YxJiOqHTPYNLH52jf3WDJy212Msn+RXaJNatSPliazT6dfgQhKFovXRqJVA/uRbdClRUIvhTlweOX0WbESV0ZFZpzMKoelTGI0lhkCkIL4ep8qKOQIgPYj8fxdNsujz5MRHr9TYmJY8v6FX+z45BzyYUZyuBIb/zNeBQYPZfV1tNFmhDG0Y40YemefdNdR+Wo2W2QmEEm4bpUfUJmUxVTe+Yq+fdYakkpzcabbk+Wdj8RqBqHZxbjJXnkKu4Sng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KFdljFrgoAyzaDSyqU0vTK5MjGg0kZf/wFF/8ZdgKQE=;
 b=pBz8g7VTfEgkrqcgbX/bFB4wWqowPG/12TPcGxBn1+5mrIHkpLH8Q8wWDTBSFdZg6SefMr+KbR6oRjLo5L/Rp8AAw6vppEfkOD7KRQG16IgrEXH60pByHqfR2vwDcC44B8oF2hP2Rghl+BqGPm2Zw4VkAyGpbdbMp9H8jPC8gZs=
Received: from BL1PR13CA0393.namprd13.prod.outlook.com (2603:10b6:208:2c2::8)
 by DS5PPFD22966BE3.namprd12.prod.outlook.com (2603:10b6:f:fc00::662) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 3 Mar
 2026 07:20:37 +0000
Received: from BN3PEPF0000B36E.namprd21.prod.outlook.com
 (2603:10b6:208:2c2:cafe::e8) by BL1PR13CA0393.outlook.office365.com
 (2603:10b6:208:2c2::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9654.21 via Frontend Transport; Tue,
 3 Mar 2026 07:20:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF0000B36E.mail.protection.outlook.com (10.167.243.165) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.0 via Frontend Transport; Tue, 3 Mar 2026 07:20:35 +0000
Received: from satlexmb10.amd.com (10.181.42.219) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:35 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by satlexmb10.amd.com
 (10.181.42.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 3 Mar
 2026 01:20:34 -0600
Received: from xhdharshj40.xilinx.com (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Tue, 3 Mar 2026 01:20:32 -0600
From: Harsh Jain <h.jain@amd.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>, <mounika.botcha@amd.com>,
	<sarat.chand.savitala@amd.com>, <michal.simek@amd.com>
CC: Harsh Jain <h.jain@amd.com>
Subject: [PATCH 0/6] crypto: zynqmp-aes-gcm: Bug fixes and sha3-384 support
Date: Tue, 3 Mar 2026 12:49:47 +0530
Message-ID: <20260303071953.149252-1-h.jain@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B36E:EE_|DS5PPFD22966BE3:EE_
X-MS-Office365-Filtering-Correlation-Id: 8fa20afb-2887-43ef-129f-08de78f55d27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	Lo+tqrw6yPSrf6VpfEP+2NYYWH3YsFShGTNEfbjBrBNGRlwEFOVruv3wVaVw5iL3CB0+ucuFPZF8cr3oIKm4Eg6KfPmKKpcgy6uu0pl0xaE7MpRi40YcBdNSTk5GSQ+Ed/dcU4SHUT9QRzkJyRyzHM1B7gseqGtxuWR1W1WxhMUIu1W2fG1UpASnp2jUCaiu97d3NXDZ916xQ5Xj0vA+nGlICiZ8r5yPf/sD9j0u1K/7mamuXZt62wiQma5lpeSEi3NsLhopDw1GqTt/ALfubZ6j4PLPMo/+jKriVNXbRR7uWeoGS/kOQcNrVxeV2pWhiW/aZYuuqeDheN/eN1wvJdyc4s1gQJmr8EZMH/YWpHBLCGeyG72BL9AhyaeqAnP0MBl/OQJqfCHvp4xyvon01wufAMd8yTbzHkoBEL2eVjp9Drt1KpFDGzgbY//0H4HjmThx3FDFCPoEfibFqS4lGhWbgOHyX9OhMldZXFPqOdNQYzbAZ7hopwIVuKFw2H8/W1tWza1wlwFHs+j5tPVJOYNtTNri/otdTtDP5BTDIOw/VKNZutWUUowJjYcF5VqaOKPzb8rGzh0YEl1/7C1C1zG0ogW7OsSD31sct/KNLLgcuFl9zpq6mfcb7MnTsPgotBht5vecDw90myfCmGEV6aXdF5nf5bZq/+Lk4XjTbhtrsEQBn1WjAJPGuCs7YfdrdTas9aSY1sZt+u3ow8ntrRu1uWxlJkhAXyeFh42k1Qn7X1quxWKBQCqZQn31W3EvaOyHUB9COkoLi7UIZM6QJx5/BGXCJZ9pkVYw/5zlkWns57ZpsBoHIJHBEe5ei4FtLiez04VOZhw7qHvUWRp5nA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	184p+Nplq8UnV+4bI2KU25J9BUIg85WxI0hLy3WIDYiPIi/RkY5hupRXuPR3acTCbglXZtwRjVEX1g4nKZ11h3t5R4AYsu480MJq9ZZK9QfqP4hJTb22W2rorXQBVKSzri496nalfhoml81BxaVn3yQBA5QNZ16Y4q1ClmnflMNsfd3X3zRr67Vzy1NkExEIwMhImvRlNUHaf2QkpQzNqZNrEtbi2yIzp1s/Lb1m53gu4FVUNlY6i25aSo5q6yuZ7CbG57U4nK0wtFhUvMbhNlzJi1IibdM+ZEmq3v5UxuM4kypMO81GtCx2krSNtYR1fxNNQzlPcKlHWqSCTJ/aUbRcz5su5Ex9zqy4D5VYlegtQlhl9smICfU3rAYVa5lsNib+5Q7EuInAYR7bYTEts1p+wdZm6E2pyoH6zH/EqHmg0p5wKBf8qa46ybjEhxU7
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 07:20:35.7923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fa20afb-2887-43ef-129f-08de78f55d27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B36E.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFD22966BE3

It includes bug fixes and adds sha3-384 algo support for Versal device.

Harsh Jain (4):
  crypto: zynqmp-sha: Change algo type from shash to ahash
  crypto: zynqmp-sha: Replace zynqmp prefix with xilinx
  crypto: zynqmp-sha: Save dma bit mask value in driver context
  crypto: zynqmp-sha: Add sha3-384 support for AMD/Xilinx Versal device

Mounika Botcha (2):
  crypto: xilinx: zynamp-sha: Update the driver to make it as self
    discoverable
  firmware: xilinx: Add firmware API's to support sha3-384 in Versal
    device

 drivers/crypto/xilinx/zynqmp-sha.c          | 460 +++++++++++++++-----
 drivers/firmware/xilinx/zynqmp-crypto.c     |  24 +
 include/linux/firmware/xlnx-zynqmp-crypto.h |   8 +
 3 files changed, 382 insertions(+), 110 deletions(-)


base-commit: 1eb6c478f1edc4384d8fea765cd13ac01199e8b5
-- 
2.34.1

