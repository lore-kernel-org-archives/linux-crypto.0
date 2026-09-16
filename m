Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012064.outbound.protection.outlook.com [40.107.200.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF593DB32B;
	Wed, 16 Sep 2026 12:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789560202; cv=fail; b=fByIU9eg6C00lZeaCPD70BPqg+d6iw+fjr1i9fsZ+wEAUIjNNo2KZNFCaskthQy7ipJ6qUIiq5dg9vgiROT1xAonAxBJLqgG8xr0ee5NxAu7rI3H+ANQjB/zrK8P008dKtubueaVl/D41I9KBbcyIVsWy3oem5YAKfyWfFMy/5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789560202; c=relaxed/simple;
	bh=pB1hVU4YwMrkOgLM5EKDTDk1VGxEvuUfUpnoyrdRwig=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ATVo3SDo1at8s9rMS3zNZ/l6T0NJyvL10Cu3NGyyc4/wBgcQR48hpFcFaxUrVROVtoc+rqTjR4JWOEbd69ZQrUv0rB38VD2/H/g2/Ki6xsEAN7qVx1KolODsBVQjDyFA3Nrj7pvVmqT8BvlwXw0Afa16WRW94EtaHhypRqP/9EE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dEagLY+Q; arc=fail smtp.client-ip=40.107.200.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dEagLY+Q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wz0IlNnPvJv+NQAGKSxKEz9M9Zu3liuLwku0ioqfSTQ6l+zxOZoVJ0Co91tG+SSf5sNCiNLxQktZ4JtQaJKg7yawDJfN9Q7k0396HYkuGICsRWGbwYttSz7q5z/GcFw1s2SqTgMoCXyEC3GTTTiSA5f6W//nmzXn0XhMer9rCSgPY1d718e/fCkjyvAorsXdGLmF4+MC6hn7jzzfXCPRd7YakXH/gmxT/YwwLrYZW81/FvM62ZthtuizjcoqeY5fGn9CJndIankLG4xBii7ykgiFg+B7hjaIUuDVli6ZzNctIxXwVKs7cPIOwX8/La6ozlyFR3CbROBdwjcTbpkLJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhr24ObJOq7bbaHkOTfqjQthzL33Uot6iWXZUXcZvPs=;
 b=C3riSyFLxEVKfOLplH1eesMG6rtOSW/nYQi/teGYPwUwjp2FTN6PPIAPa5kQnNFfNnhHNzDUyFXfXjg5Di3qrtT2BEDt0TOpWfqaSFvIjGZgtWKWWv7PFuFcw+cB6PRhtY63vsoKSy+pnz3rwX+Fd9eRBU1CmV933ZKNnoq2Gqrl86HY10c9k72I7QqFdaGu9dYGx60JfeI4OyOKqmreXgpQnVPoSceJdaeOQc9Wx4I3orBJaST5k9KniRmBQRgMBnZG5FDWwevTFsgx1naDh+SOKbhm7oGA+8OlbrErb3s04XT7gape9znrm/9SLM2MF2HUu69+pPaZ81xwc952Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhr24ObJOq7bbaHkOTfqjQthzL33Uot6iWXZUXcZvPs=;
 b=dEagLY+Q3BlZMFubhFKDxlq/VNvHhtoadVYQRpEkP8iywVjbqSaNYxEKsk2CCsd+MrIc+y2wuFiPJJp5DmsVQ/aBXX0/gtkpRi+NCfLn5sGDLixNm5X64cghILOT8DAoUpxwQi3Q1MOkdKZ2KgRt9yUkPQp77HoPLvYG9eAWgf8=
Received: from SJ0PR05CA0149.namprd05.prod.outlook.com (2603:10b6:a03:33d::34)
 by DS5PPF5A66AFD1C.namprd12.prod.outlook.com (2603:10b6:f:fc00::64d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 12:02:49 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:33d:cafe::6d) by SJ0PR05CA0149.outlook.office365.com
 (2603:10b6:a03:33d::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.8 via Frontend Transport; Wed, 16
 Sep 2026 12:02:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 12:02:48 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 07:02:24 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-pci@vger.kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Jini Susan George
	<jinisusan.george@amd.com>, Kees Cook <kees@kernel.org>, Michael Ellerman
	<mpe@ellerman.id.au>, Nikunj A Dadhania <nikunj@amd.com>, Ard Biesheuvel
	<ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, Kim Phillips
	<kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>, Ethan Nelson-Moore
	<enelsonmoore@gmail.com>, "Tycho Andersen (AMD)" <tycho@kernel.org>, "Liam
 Merwick" <liam.merwick@oracle.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>, Xiaotian Feng <dfeng@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, Andi Kleen
	<ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, Tony Luck
	<tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu
	<baolu.lu@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>, Jonathan Cameron
	<jic23@kernel.org>, Jori Koolstra <jkoolstra@xs4all.nl>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Ian Campbell
	<ian.campbell@citrix.com>, Jeremy Fitzhardinge
	<jeremy.fitzhardinge@citrix.com>, Petr Tesarik <ptesarik@suse.com>, "David
 Howells" <dhowells@redhat.com>, Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Christian
 Marangi" <ansuelsmth@gmail.com>, Dave Jiang <dave.jiang@intel.com>, "Michael
 Kelley" <mhklinux@outlook.com>, Ilias Stamatis <ilstam@amazon.com>, "Sumanth
 Korikkar" <sumanthk@linux.ibm.com>, Simona Vetter <simona.vetter@ffwll.ch>,
	Toshi Kani <toshi.kani@hp.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Vinod Koul <vkoul@kernel.org>, Jiang Liu
	<jiang.liu@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Palmer Dabbelt" <palmerdabbelt@google.com>, <linux-coco@lists.linux.dev>,
	<xen-devel@lists.xenproject.org>, <iommu@lists.linux.dev>,
	<linux-mm@kvack.org>, Alexey Kardashevskiy <aik@amd.com>, <aik@ozlabs.ru>,
	Santosh Shukla <santosh.shukla@amd.com>, "Pratik R . Sampat"
	<prsampat@amd.com>, Scott Soule Cheloha <scott.cheloha@amd.com>, Ackerley Tng
	<ackerleytng@google.com>, Fuad Tabba <tabba@google.com>
Subject: [RFC PATCH kernel 16/17] x86/sev: Enable secure MMIO (phase2)
Date: Wed, 16 Sep 2026 21:51:56 +1000
Message-ID: <20260916115159.1938195-17-aik@amd.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916115159.1938195-1-aik@amd.com>
References: <20260916115159.1938195-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|DS5PPF5A66AFD1C:EE_
X-MS-Office365-Filtering-Correlation-Id: 192fdd71-d3ad-437f-84a5-08df13ea6d18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|32650700020|23010399003|7416014|376014|10067099003|10063799003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	rAYJ1ZEaPMY4ebXUUanmtjH5GEDkJnfh2oL7uP/UlnwngJ8+9U59pjrgkf4l5QSbrf8ozYU5eoQwHQTrO5/idOTclo6MIV0wNKOdmHaQZ3INkfDB/XAtTJ4OoqtNPEdJVgzbQMl7CWpSOWXIPrNmyNwJMxi5D4mSrZ0J3e17RhpZDokMYuXqz0mAdKKtqOJd81i+Nd+rcjnx9SKXoi/6JyrpU5X6EvICFAyCThuCOubkPovwahz6YmYcUrkTk663y+v8gXZV8ZcWu6ZJSWtilEg8mj8jjL8+ngQb0DhrBTKcTJeJCq42g8/CMZ7tY817KvogenvedaZ6al+bXS2RjD96VUaawgJhZtZWPSI3g2zh+YS4PbnxVGrHVt2lL/k8UVaVg1Z/fZxYWrpgceiAAa2rV2vBtjAUuJgA5irKPhCsdI5OwiLaYFjxq7/SSUwls1yHzAZnGM44o76zKT4v17sbL2hO+vIjQdAB+dIUqiPoCqSrNhfZzzIDeFT6tYZgfFBbtLA4WcIlG9+zfQN1D6a235f2BCUQBrtMK8/5aI0ICuhL0M9ugvbjzKf1MWvj/dNnqlwGPN5ufUEsx7bSYOj+SOGXTi9bUK1971DWPtqt0iHU/lyofxH40zJH7dJzDUW6842JtzdwvMmsSOZvngAMGq2jaz09qWMm4vJ2joSeGqY4IoDS7lmWYf2HbjTeEmjIDkqTQZuyWDIBP/ufkw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(32650700020)(23010399003)(7416014)(376014)(10067099003)(10063799003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	DCCVrm9p8t6eZOOk4GJCUS43Z8KcgmvI3YzmmAcBE7ZahABBe4I8M2kGS3XT+z98XTu8RWiszsGk3RkVlxAeionzj0+s/hzFqaXr95aBLKliNb8Vy9gGHiv1ty1VW6NMqgGCcwMJbmRWBIUuaOZvGJFmugcuex7+5Se0MrloxwhfaqOgqOuY59lt4SiIc33tTxHRbxS/qKYztBXkCL41CR8p21ARH5RkDUxUEE04b+DGQFcWgLSrWLlV2449Buir2O7ku6XuIGkixZGFshjeWbMuO7z7oGdzhztZoJA9wLBwN3ho9S3/7CytKu7bbicVhiLxJYobMswAmpOBPDSUnOsIYVQ2KkbVc3P/MhbnkmLiXAwltHY6MIAvEvvR6Z6AIOEwTejP0cZtr46zUvlvdMl0g5s22S2HsMxTYOuWxHmn4M2fpWp4MFdvBX+eYvQO
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 12:02:48.2468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 192fdd71-d3ad-437f-84a5-08df13ea6d18
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF5A66AFD1C

In order to enable secure MMIO, RMP needs to be updated. Unlike RAM
(where PVALIDATE validate the RMP entry), MMIO RMP entries require
assistance from the PSP.

Add TDI_INFO TIO guest request command. Request the TDI interface report
from the PSP. Use the report to validate MMIO ranges reported as non-NonTEE
(i.e. encrypted). The TSM subsystem notifies the PCI subsystem to
automatically map validated MMIO ranges as encrypted.

Since for MMIO the TSM driver needs TDISP report, add shared memory buffers
for receiving the device evidence. Use DMA SWIOTLB for these buffers,
explicitly, by forcing 32bit DMA mask.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/uapi/linux/sev-guest.h     |  12 +
 drivers/virt/coco/sev-guest/core.c |   3 +-
 drivers/virt/coco/sev-guest/tio.c  | 394 +++++++++++++++++++-
 3 files changed, 400 insertions(+), 9 deletions(-)

diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index fcdfea767fca..28db79886ca5 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -13,6 +13,7 @@
 #define __UAPI_LINUX_SEV_GUEST_H_
 
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 #define SNP_REPORT_USER_DATA_SIZE 64
 
@@ -96,4 +97,15 @@ struct snp_ext_report_req {
 #define SNP_GUEST_VMM_ERR_INVALID_LEN	1
 #define SNP_GUEST_VMM_ERR_BUSY		2
 
+/* Optional Certificates/measurements/report data from TIO_GUEST_REQUEST */
+struct tio_blob_table_entry {
+	guid_t guid;
+	__u32 offset;
+	__u32 length;
+} __packed;
+
+/* Attestation report: 70dc5b0e-0cc0-4cd5-97bb-ff0ba25bf320 */
+#define TIO_GUID_REPORT \
+	GUID_INIT(0x70dc5b0e, 0x0cc0, 0x4cd5, 0x97, 0xbb, 0xff, 0x0b, 0xa2, 0x5b, 0xf3, 0x20)
+
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
diff --git a/drivers/virt/coco/sev-guest/core.c b/drivers/virt/coco/sev-guest/core.c
index 8448c123ab1e..8710c41daed6 100644
--- a/drivers/virt/coco/sev-guest/core.c
+++ b/drivers/virt/coco/sev-guest/core.c
@@ -23,6 +23,7 @@
 #include <linux/uuid.h>
 #include <linux/configfs.h>
 #include <linux/mm.h>
+#include <linux/dma-mapping.h>
 #include <uapi/linux/sev-guest.h>
 #include <uapi/linux/psp-sev.h>
 
@@ -677,7 +678,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (!sev_hv_features_ptr || !(*sev_hv_features_ptr & GHCB_HV_FT_SNP_SEV_TIO))
 		tsm_enable = false;
 
-	if (tsm_enable)
+	if (tsm_enable && !dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)))
 		sev_guest_tsm_set_ops(true, snp_dev);
 
 	return 0;
diff --git a/drivers/virt/coco/sev-guest/tio.c b/drivers/virt/coco/sev-guest/tio.c
index 99ff2b9c872a..06addbb3a9ad 100644
--- a/drivers/virt/coco/sev-guest/tio.c
+++ b/drivers/virt/coco/sev-guest/tio.c
@@ -22,15 +22,71 @@ MODULE_PARM_DESC(tsm_vtom, "SEV TIO vTOM value");
 #define pdev_to_tdi(p)		container_of((p)->tsm, struct tio_guest_tdi, ds.base_tsm)
 #define ghcb_tio_sbdfn(pdev)	((pci_domain_nr((pdev)->bus) << 16) | pci_dev_id(pdev))
 
+#define TIO_DATA_PAGES	(SZ_32K >> PAGE_SHIFT)
+#define SPDM_MEASUREMENTS_NONCE_LEN 32
+
+static void sev_free_shared_pages(struct device *dev, void *buf,
+				  unsigned long npages, dma_addr_t dma_handle)
+{
+	dma_free_coherent(dev, npages << PAGE_SHIFT, buf, dma_handle);
+}
+
+static void *sev_alloc_shared_pages(struct device *dev, unsigned long npages,
+				    dma_addr_t *dma_handle)
+{
+	return dma_alloc_coherent(dev, npages << PAGE_SHIFT, dma_handle, GFP_KERNEL);
+}
+
 struct tio_guest_tdi {
 	struct pci_tsm_devsec ds;
 	struct snp_guest_dev *snp_dev;
 	u64 tdi_id; /* Runtime FW generated TDI id */
 };
 
+static void device_evidence_object_clear(struct device_evidence_object *obj)
+{
+	if (!obj)
+		return;
+
+	kfree(obj->digest);
+	kfree(obj->data);
+	obj->data = NULL;
+	obj->len = 0;
+	obj->digest = NULL;
+}
+
+static int device_evidence_object_assign(struct device_evidence_object *obj,
+					 const void *src, size_t len)
+{
+	void *copy;
+
+	device_evidence_object_clear(obj);
+	if (!len || !src)
+		return 0;
+
+	copy = kmemdup(src, len, GFP_KERNEL);
+	if (!copy)
+		return -ENOMEM;
+
+	obj->data = copy;
+	obj->len = len;
+	return 0;
+}
+
+static void device_evidence_release(struct device_evidence *evidence)
+{
+	unsigned int i;
+
+	if (!evidence)
+		return;
+
+	for (i = 0; i <= DEVICE_EVIDENCE_TYPE_MAX; i++)
+		device_evidence_object_clear(&evidence->obj[i]);
+}
+
 static int handle_tio_guest_request(struct snp_guest_dev *snp_dev, u8 type,
 				    void *req_buf, size_t req_sz, void *resp_buf, u32 resp_sz,
-				    u64 *bdfn, u64 *param, u64 *fw_err)
+				    void *pt, u64 *npages, u64 *bdfn, u64 *param, u64 *fw_err)
 {
 	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 	struct snp_guest_req req = {
@@ -52,6 +108,10 @@ static int handle_tio_guest_request(struct snp_guest_dev *snp_dev, u8 type,
 		goto error_exit;
 	}
 
+	if (pt && npages) {
+		req.certs_data = pt;
+		req.input.data_npages = *npages;
+	}
 	if (bdfn) {
 		req.input.guest_rid = *bdfn & 0xFFFFFFFF;
 		req.input.npages = *bdfn >> 32;
@@ -71,6 +131,69 @@ static int handle_tio_guest_request(struct snp_guest_dev *snp_dev, u8 type,
 	return ret;
 }
 
+static int guest_request_tio_data(struct snp_guest_dev *snp_dev, u8 type,
+				  void *req_buf, size_t req_sz, void *resp_buf, u32 resp_sz,
+				  u64 bdfn, struct device_evidence_object *report,
+				  u64 *fw_err)
+{
+	u64 npages = TIO_DATA_PAGES, param = 0;
+	struct tio_blob_table_entry *pt;
+	dma_addr_t dh = 0;
+	int rc;
+
+	pt = sev_alloc_shared_pages(snp_dev->dev, TIO_DATA_PAGES, &dh);
+	if (!pt)
+		return -ENOMEM;
+
+	if (report)
+		param |= SVM_VMGEXIT_SEV_TIO_GR_INFO_REPORT;
+
+	rc = handle_tio_guest_request(snp_dev, type, req_buf, req_sz, resp_buf, resp_sz,
+				      pt, &npages, &bdfn, &param, fw_err);
+	if (npages > TIO_DATA_PAGES) {
+		sev_free_shared_pages(snp_dev->dev, pt, TIO_DATA_PAGES, dh);
+		pt = sev_alloc_shared_pages(snp_dev->dev, npages, &dh);
+		if (!pt)
+			return -ENOMEM;
+
+		rc = handle_tio_guest_request(snp_dev, type, req_buf, req_sz, resp_buf, resp_sz,
+					      pt, &npages, &bdfn, &param, fw_err);
+	}
+	if (rc)
+		goto out_free_pt;
+
+	if (report)
+		device_evidence_object_clear(report);
+
+	for (unsigned int i = 0; i < 3; ++i) {
+		u8 *ptr = ((u8 *)pt) + pt[i].offset;
+		size_t len = pt[i].length;
+
+		if (guid_is_null(&pt[i].guid))
+			break;
+
+		if (!len)
+			continue;
+
+		if (guid_equal(&pt[i].guid, &TIO_GUID_REPORT) && report)
+			rc = device_evidence_object_assign(report, ptr, len);
+		else
+			continue;
+		if (rc)
+			goto out_clear_blobs;
+	}
+	sev_free_shared_pages(snp_dev->dev, pt, npages, dh);
+
+	return 0;
+
+out_clear_blobs:
+	if (report)
+		device_evidence_object_clear(report);
+out_free_pt:
+	sev_free_shared_pages(snp_dev->dev, pt, npages, dh);
+	return rc;
+}
+
 struct tio_msg_tdi_info_req {
 	u64 tdi_id;
 	u8 reserved[8];
@@ -107,6 +230,224 @@ struct tio_msg_tdi_info_rsp {
 	u64 reserved4;
 } __packed;
 
+static int tio_tdi_status(struct pci_dev *pdev, struct snp_guest_dev *snp_dev,
+			  struct tsm_tdi_status *ts, uint64_t tdi_id,
+			  struct device_evidence_object *report)
+{
+	size_t resp_len = sizeof(struct tio_msg_tdi_info_rsp) + AUTHTAG_LEN;
+	struct tio_msg_tdi_info_rsp *rsp __free(kfree_sensitive) = kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_tdi_info_req req = {
+		.tdi_id = tdi_id,
+	};
+	u64 fw_err = 0;
+	int rc;
+
+	pci_notice(pdev, "TDI info");
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = guest_request_tio_data(snp_dev, TIO_MSG_TDI_INFO_REQ, &req,
+				    sizeof(req), rsp, resp_len,
+				    ghcb_tio_sbdfn(pdev), report, &fw_err);
+	if (rc)
+		return rc;
+
+	ts->tdi_id = rsp->tdi_id;
+
+	return 0;
+}
+
+struct tio_msg_mmio_validate_req {
+	u64 tdi_id;
+	u8 reserved2[8];
+	u64 subrange_base;
+	u32 subrange_page_count;
+	u32 range_offset;
+
+	u16 validated:1; /* Desired value to set RMP.Validated for the range */
+	/*
+	 * Force validated:
+	 * 0: If subrange does not have RMP.Validated set uniformly, fail.
+	 * 1: If subrange does not have RMP.Validated set uniformly, force
+	 *    to requested value
+	 */
+	u16 force_validated:1;
+	u16 reserved3:14;
+
+	u16 range_id;
+	u8 reserved4[12];
+} __packed;
+
+/* Status codes from TIO_MSG_MMIO_VALIDATE_REQ */
+enum mmio_validate_status {
+	MMIO_VALIDATE_SUCCESS = 0,
+	MMIO_VALIDATE_INVALID_TDI = 1,
+	MMIO_VALIDATE_TDI_UNBOUND = 2,
+	MMIO_VALIDATE_NOT_ASSIGNED = 3, /* At least one page is not assigned to the guest */
+	MMIO_VALIDATE_NOT_IO = 4,	/* At least one page is not an I/O page */
+	MMIO_VALIDATE_NOT_UNIFORM = 5,  /* Validated bit is not uniformly set for range */
+	MMIO_VALIDATE_NOT_IMMUTABLE = 6,/* >=1 page does not have immutable bit set */
+	MMIO_VALIDATE_NOT_MAPPED = 7,   /* At least one page is not mapped to the expected GPA */
+	MMIO_VALIDATE_NOT_REPORTED = 8, /* Range ID is not reported in TDI report */
+	MMIO_VALIDATE_OUT_OF_RANGE = 9, /* Subrange is out the MMIO range in TDI report */
+	MMIO_VALIDATE_NOT_4K = 10,	/* >=1 page is not 4K page size */
+};
+
+struct tio_msg_mmio_validate_rsp {
+	u64 tdi_id;
+	u16 status; /* MMIO_VALIDATE_xxx */
+	u8 reserved1[6];
+	u64 subrange_base;
+	u32 subrange_page_count;
+	u32 range_offset;
+
+	u16 changed:1; /* Validated bit has changed due to this operation */
+	u16 reserved2:15;
+
+	u16 range_id;
+	u8 reserved3[12];
+} __packed;
+
+static int mmio_validate_range(struct snp_guest_dev *snp_dev, struct pci_dev *pdev,
+			       uint64_t tdi_id, unsigned int range_id,
+			       resource_size_t start, resource_size_t size,
+			       bool invalidate, u64 *fw_err, u16 *status)
+{
+	size_t resp_len = sizeof(struct tio_msg_mmio_validate_rsp) + AUTHTAG_LEN;
+	struct tio_msg_mmio_validate_rsp *rsp __free(kfree_sensitive) =
+			kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_mmio_validate_req req = {
+		.tdi_id = tdi_id,
+		.subrange_base = start >> 12,
+		.subrange_page_count = size >> 12,
+		.range_offset = 0,
+		.validated = !invalidate, /* Desired value to set RMP.Validated for the range */
+		.force_validated = 0,
+		.range_id = range_id,
+	};
+	u64 num_bdfn = SVM_VMGEXIT_SEV_TIO_GR_MMIO_MK_NUM_BDFN(size >> 12, ghcb_tio_sbdfn(pdev));
+	u64 mmio_val = SVM_VMGEXIT_SEV_TIO_GR_MMIO_MK_VALIDATE(start, !invalidate);
+	int rc;
+
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = handle_tio_guest_request(snp_dev, TIO_MSG_MMIO_VALIDATE_REQ,
+				      &req, sizeof(req), rsp, resp_len,
+				      NULL, NULL, &num_bdfn, &mmio_val, fw_err);
+	if (rc || *fw_err || rsp->status != MMIO_VALIDATE_SUCCESS) {
+		pci_err(pdev, "MMIO validate failed with rc=%d, fwerr=0x%llx, status=%x\n",
+			rc, *fw_err, rsp->status);
+		if (!rc)
+			return -EFAULT;
+		return rc;
+	}
+
+	*status = rsp->status;
+
+	return 0;
+}
+
+static void tio_tdi_mmio_invalidate(struct pci_dev *pdev, struct snp_guest_dev *snp_dev,
+				    uint64_t tdi_id)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+	u16 mmio_status;
+	u64 fw_err = 0;
+	int i = 0, rc = 0;
+	struct pci_tsm_devsec *devsec_tsm = to_pci_tsm_devsec(tsm);
+	struct pci_tsm_mmio *mmio = devsec_tsm->mmio;
+
+	if (!mmio)
+		return;
+
+	pci_notice(pdev, "MMIO invalidate");
+
+	for (i = 0; i < mmio->nr; ++i) {
+		struct pci_tsm_mmio_entry *entry = pci_tsm_mmio_entry(mmio, i);
+		struct resource *res = &entry->res;
+		unsigned int range_id = entry->range_id;
+
+		if (range_id >= PCI_NUM_RESOURCES ||
+		    !resource_contains(pci_resource_n(pdev, range_id), res)) {
+			pci_info(pdev, "Skipping MMIO [%d] %pr: no BAR %u window\n",
+				 i, res, range_id);
+			continue;
+		}
+
+		mmio_status = 0;
+		rc = mmio_validate_range(snp_dev, pdev, tdi_id, range_id,
+					 res->start, resource_size(res), true, &fw_err,
+					 &mmio_status);
+		if (rc || fw_err != SEV_RET_SUCCESS || mmio_status != MMIO_VALIDATE_SUCCESS) {
+			pci_err(pdev, "MMIO #%d %llx..%llx validation failed 0x%llx %d\n",
+				range_id, res->start, res->end, fw_err, mmio_status);
+			continue;
+		}
+
+		pci_notice(pdev, "MMIO #%d %llx..%llx invalidated\n",
+			   range_id, res->start, res->end);
+	}
+
+	pci_tsm_mmio_teardown(devsec_tsm->mmio);
+	kfree(devsec_tsm->mmio);
+	devsec_tsm->mmio = NULL;
+}
+
+static int tio_tdi_mmio_validate(struct pci_dev *pdev, struct snp_guest_dev *snp_dev,
+				 uint64_t tdi_id)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+	u16 mmio_status;
+	u64 fw_err = 0;
+	int i, rc = 0;
+	struct pci_tsm_mmio *mmio __free(kfree) = pci_tsm_mmio_alloc(pdev);
+
+	if (!mmio)
+		return -ENOMEM;
+
+	pci_notice(pdev, "MMIO validate");
+
+	for (i = 0; i < mmio->nr; ++i) {
+		struct pci_tsm_mmio_entry *entry = pci_tsm_mmio_entry(mmio, i);
+		struct resource *res = &entry->res;
+		unsigned int range_id = entry->range_id;
+
+		if (range_id >= PCI_NUM_RESOURCES ||
+		    !resource_contains(pci_resource_n(pdev, range_id), res)) {
+			pci_info(pdev,
+				 "Skipping MMIO [%d] %pr: no BAR %u window\n",
+				 i, res, range_id);
+			continue;
+		}
+
+		mmio_status = 0;
+		rc = mmio_validate_range(snp_dev, pdev, tdi_id, range_id, res->start,
+					 resource_size(res), false, &fw_err, &mmio_status);
+		if (rc || fw_err != SEV_RET_SUCCESS || mmio_status != MMIO_VALIDATE_SUCCESS) {
+			pci_err(pdev, "MMIO #%d %llx..%llx validation failed 0x%llx %d\n",
+				range_id, res->start, res->end, fw_err, mmio_status);
+			continue;
+		}
+
+		pci_notice(pdev, "MMIO #%d %llx..%llx validated\n", range_id, res->start, res->end);
+	}
+
+	if (!rc) {
+		rc = pci_tsm_mmio_setup(pdev, mmio);
+		if (!rc) {
+			struct pci_tsm_devsec *devsec_tsm = to_pci_tsm_devsec(tsm);
+
+			devsec_tsm->mmio = no_free_ptr(mmio);
+		}
+	}
+
+	if (rc)
+		tio_tdi_mmio_invalidate(pdev, snp_dev, tdi_id);
+
+	return rc;
+}
+
 struct sdte {
 	u64 v                  : 1;
 	u64 reserved           : 3;
@@ -216,7 +557,7 @@ static int tio_tdi_sdte_write(struct pci_dev *pdev, struct snp_guest_dev *snp_de
 
 	rc = handle_tio_guest_request(snp_dev, TIO_MSG_SDTE_WRITE_REQ,
 				      &req, sizeof(req), rsp, resp_len,
-				      &bdfn, &flags, &fw_err);
+				      NULL, NULL, &bdfn, &flags, &fw_err);
 	if (rc || fw_err || rsp->status != SDTE_WRITE_SUCCESS) {
 		pci_err(pdev, "SDTE write failed with rc=%d, fwerr=0x%llx, status=%x\n",
 			rc, fw_err, rsp->status);
@@ -233,6 +574,7 @@ static int tio_tdi_sdte_write(struct pci_dev *pdev, struct snp_guest_dev *snp_de
 static struct pci_tsm *sev_guest_lock(struct tsm_dev *tsmdev, struct pci_dev *pdev)
 {
 	struct tio_guest_tdi *gtdi __free(kfree) = kzalloc(sizeof(*gtdi), GFP_KERNEL);
+	struct tsm_tdi_status ts = {};
 	u64 fw_err = 0, tdi_id = 0;
 	int rc;
 
@@ -258,11 +600,21 @@ static struct pci_tsm *sev_guest_lock(struct tsm_dev *tsmdev, struct pci_dev *pd
 	}
 	pci_dbg(pdev, "New TDI ID=%llx\n", tdi_id);
 
-	struct device_evidence *evidence = device_evidence_create(0, HASH_ALGO_SHA384);
-	if (!evidence)
+	struct device_evidence *ev = device_evidence_create(0, HASH_ALGO_SHA384);
+	if (!ev)
 		return ERR_PTR(-ENOMEM);
-	gtdi->ds.base_tsm.evidence = evidence;
 
+	rc = tio_tdi_status(pdev, gtdi->snp_dev, &ts, tdi_id,
+			    &ev->obj[DEVICE_EVIDENCE_TYPE_REPORT]);
+	if (rc)
+		return ERR_PTR(rc);
+
+	if (!ev->obj[DEVICE_EVIDENCE_TYPE_REPORT].data) {
+		device_evidence_release(ev);
+		return ERR_PTR(-ENODEV);
+	}
+
+	gtdi->ds.base_tsm.evidence = ev;
 	gtdi->tdi_id = tdi_id;
 
 	return &no_free_ptr(gtdi)->ds.base_tsm;
@@ -271,19 +623,33 @@ static struct pci_tsm *sev_guest_lock(struct tsm_dev *tsmdev, struct pci_dev *pd
 static void sev_guest_unlock(struct pci_tsm *tsm)
 {
 	struct pci_dev *pdev = tsm->pdev;
+	struct tio_guest_tdi *gtdi = pdev_to_tdi(pdev);
+	struct snp_guest_dev *snp_dev = gtdi->snp_dev;
 	u64 fw_err = 0;
 
-	sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_UNBIND, &fw_err, NULL);
+	tio_tdi_mmio_invalidate(pdev, snp_dev, gtdi->tdi_id);
 
 	/* Quiesce DMA */
 	sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_STOP, &fw_err, NULL);
 
-	tsm->pdev->tsm = NULL;
+	/*
+	 * Up until now the VMM has been blocking clearing of BME and the device may
+	 * not be able to recover without BME going via 0, do it now.
+	 * Note that the device reset is still needed, leave to the userspace to
+	 * decide on that.
+	 */
+	pci_disable_device(pdev);
+
+	sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_UNBIND, &fw_err, NULL);
+
+	device_evidence_release(tsm->evidence);
 	kvfree(tsm);
 }
 
 static int sev_guest_accept(struct pci_dev *pdev)
 {
+	struct tio_guest_tdi *gtdi = pdev_to_tdi(pdev);
+	struct snp_guest_dev *snp_dev = gtdi->snp_dev;
 	struct pci_tsm *tsm = pdev->tsm;
 	u64 fw_err = 0;
 
@@ -296,7 +662,19 @@ static int sev_guest_accept(struct pci_dev *pdev)
 	if (ret)
 		return ret;
 
-	return sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_RUN, &fw_err, NULL);
+	ret = sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_RUN, &fw_err, NULL);
+	if (ret)
+		return ret;
+
+	ret = tio_tdi_mmio_validate(pdev, snp_dev, gtdi->tdi_id);
+	if (ret)
+		goto stop_tdi;
+
+	return 0;
+
+stop_tdi:
+	sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_STOP, &fw_err, NULL);
+	return ret;
 }
 
 static int sev_guest_enable_dma(struct pci_dev *pdev)
-- 
2.55.0

