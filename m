Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2901A372B22;
	Fri, 23 Jan 2026 05:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769146317; cv=fail; b=ioFmU+h3roR4Ci6MNZ/8pSl4zBL6YiAC4kZP/4gQuECL+PcifH1/iUBhwHHgDCngoFLmOo7HgsVFC3EyZkg7mk9E1zLAmgZobJQyO+R1TUGgXvErhMoZhDKX1SdnIqGV4MQE1TuecYtz58jYuZcT+4cqViXHpvSkxK1LMLqXgp4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769146317; c=relaxed/simple;
	bh=zjpFpbMAIbrT7D3xTNhSL5rRkqUmS0FreDagWAtaCE8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uhg0z06j4dnPDh+jQDel4GetRCpoSW/4pNclu/8y+xq4Qiya7WbqGdp84AjmSxtyhbhAALGK0EBVOCxWTXOtxqoY3twTEwEn2BOWw7nej0Uvo8238P64k4Ai2bACsf57PlVLd1FaL7Qn78+nWB6Fpy4dKFEgdclnm6nAY8t/scY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FOUvmjQZ; arc=fail smtp.client-ip=52.101.53.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FOUvmjQZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QlQlFXuKjJYvxStKeCAVxWoAFCVu28KpFiXRMEPClgUrsWjYZHnUzsF4xKodnYDOkgHgs+IFsHaP/jITe+0gjAgixGADdnKf2IcgZMS0JlutpncWighfFZbzeGxo7n3uPXZIsQd7JCP5APw4iAJYdSMsAB+GqD9PwiES8n/mJocRTFwLetseE29g5jbbVPbXqF/fTqE/E/ShYCbDYd2zBgYAWXZAm7q3JbYObwEHzJnogyD6b3+a23MIGh5A4p648brQKNlBognNO4FODe3fnt1dY4OhMjcv3ElyNbeCBLSNPVHsCUGL2q4hQe45HMAcTZO1db3ffei683v9iVipIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wmS215LvOLBU/vSriUbn6xJuUdpFkgdRe9UzrPjJes=;
 b=we75JcBOpBxJwme+EBgubIEE0wt2/VyDFqjPUAxk6hCOTuF6u66oF6L8Q/kABEiZHR95TQpPqzc6gvbvm1gJtZ0Mg6sT8c2vcm7XjPUcsfChhrzohKtAVUDAoW09lVGVmZ3Siwfmn/ozx86Ui676q8sQdgTkbq2/aCOWVXGvgp2VOaMACdPqfIUO6qqfIRd8Zsu7NSM48XHglQ4QyObtWHwaCf9gb6XU2szKKvxQa/YXf4wMVrzfV37piSQajxhwU4JxOsMh30UTe0F8oQuSBVS7kzxT2xHp99jPHy/GigWmXCjQf6EwmHHEmNDVdrGAxlWXqe+w36jsuxvFthiCsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wmS215LvOLBU/vSriUbn6xJuUdpFkgdRe9UzrPjJes=;
 b=FOUvmjQZ1Eoh+8mrytAy2X6kAL5i9SMMZLfmATqzxlV8sgKF3Pe9tmKyNPkOlsgzMOKpBi7cPcGYE1ysYKWYbHAxxbOx4IKZM0vjUcxiYmriLJ3rhafYPN6Ue09pSJz+ohNjK7psumUyjBs+MbsMCEutnXp5aoYPPFEbJ0zkhqc=
Received: from MN2PR16CA0037.namprd16.prod.outlook.com (2603:10b6:208:234::6)
 by SA3PR12MB9107.namprd12.prod.outlook.com (2603:10b6:806:381::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 05:31:41 +0000
Received: from BL6PEPF00020E63.namprd04.prod.outlook.com
 (2603:10b6:208:234:cafe::35) by MN2PR16CA0037.outlook.office365.com
 (2603:10b6:208:234::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.11 via Frontend Transport; Fri,
 23 Jan 2026 05:31:28 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00020E63.mail.protection.outlook.com (10.167.249.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Fri, 23 Jan 2026 05:31:39 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 22 Jan
 2026 23:31:33 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>, Dan Williams <dan.j.williams@intel.com>, Alexey
 Kardashevskiy <aik@amd.com>, <x86@kernel.org>, <linux-coco@lists.linux.dev>,
	"Pratik R . Sampat" <prsampat@amd.com>
Subject: [PATCH kernel 1/2] crypto/ccp: Use PCI bridge defaults for IDE
Date: Fri, 23 Jan 2026 16:30:56 +1100
Message-ID: <20260123053057.1350569-2-aik@amd.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260123053057.1350569-1-aik@amd.com>
References: <20260123053057.1350569-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00020E63:EE_|SA3PR12MB9107:EE_
X-MS-Office365-Filtering-Correlation-Id: 90cde54d-d5ed-4d37-59e6-08de5a40af14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mH+a0/lBjXJNy27XzKDvrVgRFGqGjKHxi8SqZjred8IqfSjbeFyDeQj2gE1Q?=
 =?us-ascii?Q?9HRfrPDwKVn0KoKIkuEbLR55Ttv4Qs/lOW9R4bg8BfT9LEJuJkTefOxLHm+b?=
 =?us-ascii?Q?uakqiVrwbRHACE6YykqudTZFFfrB8jKJQNxidt85geuLQm+MgL+efpywHoj7?=
 =?us-ascii?Q?74iekadzO3pF515thQBKR4yzlT+iiT66SpelRfJpvZJvPiDy/GZmj8v7HY3F?=
 =?us-ascii?Q?l1SbluP/SVJNQeYTAz499rPwk5Zu6uOF7Re3wF44AmwsCxi9ctLe+Vt1i+BD?=
 =?us-ascii?Q?PwuYryxfx7tMpsrY9o0P2BeSSscRVTPdxijkOmEsg90yRei0HeRv3F+5LCkA?=
 =?us-ascii?Q?3h2erlM4a0L1nlix8Mbl2cUXGVWoAnVCNmNPMM7AMQuGnYozDKnnvcuRJcSR?=
 =?us-ascii?Q?5Cpvqll22O1ffMLsoOFP1UU3R46U4vpLe8pJK1GeqoeFO7z3gxysJZKT1DHu?=
 =?us-ascii?Q?DKvfp6C3pyMjxiZiS6UkrpmrMoY0fVcKCBhH6SMkj3VSLumH69qPyRSa3JkW?=
 =?us-ascii?Q?/+9QE3D0pKRi5dYykIPRH5YS418T+7++zmxPyqaAwTOShPp3CI640Lsqz+H3?=
 =?us-ascii?Q?icen1ORmlJxrUkn26yzacGkF7+C/D1GJOQxjmuJHUEvnemBenmlcODfWFCCV?=
 =?us-ascii?Q?5Nd4omgj9VI1Y+hSnJWx6LflMRP0U5LjLNpMtivwEN8HtkivvsQ6UyRojKz+?=
 =?us-ascii?Q?4oUbGorVDdoTUVEbbUMKbTR27ksOPHcTmJLBTP5VqOtJ+xcz+UBEPRqfDDPS?=
 =?us-ascii?Q?bn8f84jz6UWOIZdnZtd9S3IpSyhfo5LIoBoLpGzFQ3mYm7K7FV6+OLs82n/a?=
 =?us-ascii?Q?0zAg3rEWQ2B4weoERhalSQSXJKo1k04ul1tyftP9FrsMzOSjEM+SkVQujj2J?=
 =?us-ascii?Q?Pc6eSA7ehPMwAF0xvcsrBucpQ9fu0zJL8tQOCthdHgWk7xNTwsvKcX9/kcKb?=
 =?us-ascii?Q?vpuD6daQ85RcJ/wZjGfp1N4EsGYlwgTgEQn/lgw0TI8Ulf23IRA/+6PrxMDi?=
 =?us-ascii?Q?ZnN+ZTGgh8G62b+WLwoC07e+Lg1vN2DwIHe4WZHrFA1gRC7MeBE+4qgQY/Y9?=
 =?us-ascii?Q?vmqJX4cszQreNXyS9pt+2TWhPRZzeQfPKZVdHNHl8s++6Tu9IZMsIo/RQEop?=
 =?us-ascii?Q?3NSlymMCnsImNB10mmFcqNxPIVPKPMc3/8E/imSjgIsRgsApU+gRrFxdGBuF?=
 =?us-ascii?Q?fG0qu5ee836kJy7Q9z34e0IpZSc5fB+cGJWv+kYhyF7e+V2+8BXkYZp9Zu6U?=
 =?us-ascii?Q?0Le4HVrj0ilCUCIeJn321nX7oHq73X/ZpBqoMy3kqidNNvMo8FYlIupzqmpo?=
 =?us-ascii?Q?MaCQ90jcgfMlQiXm4KcbtG8Bc/3dD9r8imZZ2gao0xA3T9kv+LVLLafrQIi2?=
 =?us-ascii?Q?T0K4An7EBoFTVF6wulxdTrYjBnNmEzfZaFTu+DUbE7HuUY3oS+bHCBP7Ioa6?=
 =?us-ascii?Q?nslCNWpMl6FOuOgTChPqzWgvfhdrp2qK9jxWEymdBkLGP3VIJkRbYqtRbYTr?=
 =?us-ascii?Q?2msJkqQyhiaopulJ9X+iblc5i9uT0VBFz5byMgiNNkXLJ5Ap2SHOrCX6G6Be?=
 =?us-ascii?Q?iWnPEQjT8VDQZFajgvb9u7xB+endnKcZtP3Mg0wrDqsnfwJs5ZjZiNDVoHRQ?=
 =?us-ascii?Q?ZOp6dMWxs3M/qiKm9+ONz2WUwc4p5BbmjLCKrrf55wcZc/F7Gha1jmSnW9La?=
 =?us-ascii?Q?9jJ+1A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 05:31:39.4584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90cde54d-d5ed-4d37-59e6-08de5a40af14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00020E63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9107

The current number of streams in AMD TSM is 1 which is too little,
the core uses 255. Also, even if the module parameter is increased,
calling pci_ide_set_nr_streams() second time triggers WARN_ON.

Simplify the code by sticking to the PCI core defaults.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index ea29cd5d0ff9..7407b77c2ef2 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -19,12 +19,6 @@
 
 MODULE_IMPORT_NS("PCI_IDE");
 
-#define TIO_DEFAULT_NR_IDE_STREAMS	1
-
-static uint nr_ide_streams = TIO_DEFAULT_NR_IDE_STREAMS;
-module_param_named(ide_nr, nr_ide_streams, uint, 0644);
-MODULE_PARM_DESC(ide_nr, "Set the maximum number of IDE streams per PHB");
-
 #define dev_to_sp(dev)		((struct sp_device *)dev_get_drvdata(dev))
 #define dev_to_psp(dev)		((struct psp_device *)(dev_to_sp(dev)->psp_data))
 #define dev_to_sev(dev)		((struct sev_device *)(dev_to_psp(dev)->sev_data))
@@ -193,7 +187,6 @@ static void streams_teardown(struct pci_ide **ide)
 static int stream_alloc(struct pci_dev *pdev, struct pci_ide **ide,
 			unsigned int tc)
 {
-	struct pci_dev *rp = pcie_find_root_port(pdev);
 	struct pci_ide *ide1;
 
 	if (ide[tc]) {
@@ -201,11 +194,6 @@ static int stream_alloc(struct pci_dev *pdev, struct pci_ide **ide,
 		return -EBUSY;
 	}
 
-	/* FIXME: find a better way */
-	if (nr_ide_streams != TIO_DEFAULT_NR_IDE_STREAMS)
-		pci_notice(pdev, "Enable non-default %d streams", nr_ide_streams);
-	pci_ide_set_nr_streams(to_pci_host_bridge(rp->bus->bridge), nr_ide_streams);
-
 	ide1 = pci_ide_stream_alloc(pdev);
 	if (!ide1)
 		return -EFAULT;
-- 
2.52.0

