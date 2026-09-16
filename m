Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013017.outbound.protection.outlook.com [40.107.201.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3B84F054A;
	Wed, 16 Sep 2026 11:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789559982; cv=fail; b=ZWJ/L0+iqxNpfer1P2XH8Qbniw27rTh790w/wlUAwDAMKFVub4ojP+RTivkT1oDTRRxLryxcRKzQfOIBsdRQN4uWheb29PY1DEkXPx/ZvfJdEGG1oGmiYNkpIzZEiM6UWSNmlBREQcsc4nisYK06XDQ7OWc0unO3WiWcH1bQWEE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789559982; c=relaxed/simple;
	bh=g4H1pNgGx6egUXkOADkTsOJXNS1+Ro10K3szeLspJBg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AcCy+4B2tdSfIRyf10CppOMqsLeLS9o8IYuKapanM4rI0lbRtie1QsVsMFCkP+SLpGR0z9kIwt2a/8OWaqN9Z44V5SmidJWe4UuEse44s/gTTDkm3cN7uMY3aHJyQUR9GtL9q16R+hBj3hxxJOhNHKEztBHnJM4y6k8W81lCp9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wzwC6nfw; arc=fail smtp.client-ip=40.107.201.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wzwC6nfw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ofOgEZt5/WvZL398DiMP4cnJu+bAOQ7ChdryDjdv6oc3B+1IqZ5xoCor8N7Ik69lXihL8DalFNN9z171VyKvjWP7qM0DDXR3yLwNOmXuBqCv86Gbl8ba8tHqsafdCNrPxltMrbLTHvsJAE5IbcIcl+RldZJlImHm7npnTIGIzJJ1QMcy8I+eqcBMS9ZZqprVDYX2C05fuBYoOpwyswLPdGLbxffVcsQm3S+lV4Mtf7YbMTeFB9fehnnY8S4cHnUSdXF5aINmNiKz7F17iSKPebMKZAIN0MpN0ypjqkW2E4BYk1eFRto289kn9r4R9JwcoGJZ4lcE9S2+Jgiy17XQSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTsg1utTkplWuARlA0qswoeLICanNrYPE/18/PBEUNY=;
 b=rmoiGjoh+6GgaL646m2gMAgAeOVhpofkBX3f/ONIo6agDbJ3NudbMju58xl+C1BXMLqHJHo/SJLgCu6OfZ6ClRdQOK+hdd+xThXKfg0ZOf8ObPpFogMdFYwFsuEVQyDlOqpg6yNgukAg4WRCIldL4HVzAGdtQX2nPGDjHKo/+CXnz1CXQERwq5BbbujDJTMzsYKKk4HZj6Q0ZmvdBb7+OwZZswtvWAkI3jaCClT3FPSNqo8ZTMgGcp9Xw0Zxm0nnnymV0tycimCtTkLIwfYtp4uFWIZo/SDWyrbE3/S4DfvtntmL3XIUE/P/cTKwfr6stSp1zjl52cvPMVYQHPKRMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTsg1utTkplWuARlA0qswoeLICanNrYPE/18/PBEUNY=;
 b=wzwC6nfwNmFtjgfk9sDcnKOMQ04jGfMzMCsC94PMwXHTyprnLafBJ/OMhSdIIZT7e1gKWt5OaYurLNADb4gi+KaWK8d7Qz3Dv4f9nx3JwyUsO5xKzntXU9YygO+pNZBzDvE9YfRcVfyBpz6mQnPpD2GxVC7juJ3ZzS7smUM8JKs=
Received: from SJ2P220CA0004.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::11)
 by SJ0PR12MB6832.namprd12.prod.outlook.com (2603:10b6:a03:47e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 11:59:24 +0000
Received: from SJ5PEPF00000208.namprd05.prod.outlook.com
 (2603:10b6:a03:5da:cafe::ab) by SJ2P220CA0004.outlook.office365.com
 (2603:10b6:a03:5da::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:59:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000208.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:59:23 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:58:59 -0500
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
Subject: [RFC PATCH kernel 11/17] tsm/core: Add TDI status
Date: Wed, 16 Sep 2026 21:51:51 +1000
Message-ID: <20260916115159.1938195-12-aik@amd.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916115159.1938195-1-aik@amd.com>
References: <20260916115159.1938195-1-aik@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000208:EE_|SJ0PR12MB6832:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ed4718-0d0d-4492-fba9-08df13e9f352
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|32650700020|376014|23010399003|36860700016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	1gjrxiOzZs++uLN/08CsbVuU5pzivX1w5sGfokhVo62HhTqsZAyt2altg4jQKy61YsFa5Q4JpAePEy56dZ2EtjTCeKjExL81JRYHJiYMY2uEiMnekm+X4HfnK61KTogTrUDOSWqYPac0RXsqXDF4wcWCECweQL2O+qrasaKF9Ob2twna6aAPVekdisRqgLeJlZeWB+Pyy3Bj167PJL09ZDmneWPqJ/nWbZ0cNzIZ9Uqu+TxE79xdf2uWrFfFyctA02oysbQLQg7NUfSUI+121Lh84kpVXJKbsCp4RX8FM8vKws3J3lHABQArpnrkiLAf2KQseddH0TJq+Gv/qJeo3ppTVrTxG+l8MATdtE6Ao3U3P+6gT3P9M6R6/DAw+GSzx5a/5muRGjOlLBCzMMiMgoy/exC0T3bXU9lf4eS/7wyQMhaEBz721jzLwZwa2Dv1PivZYIiWNzz8ZjfwLrQbmMk5/p8DJ5F9/KW0TMkedGokdgxIMOBxpzKrj0WOPNZTSFL2PdgqRRvebRWS/tn5JkJTmIfnpT4wVrU/EEANzAHAwcREbazlGn77NGogt+eYeQ5dt8vAtItGg7Je1OTdf7apf9IzPoCJmzfouuIh9OdDINS2GF86XJJkhSUJfr/0LPVLQjFXnrujzmzz+zKMX+LG2m67WgXyvo8/Y0n5DPWZ4ATFg4mJDgroef2p5B6hrmxaAbtQhopAI4TWgp6URw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(32650700020)(376014)(23010399003)(36860700016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Fw53La2fWg2oO27psEqX3jIivEE3n3gbx3/xjn+KQHm1lz4FNVBajz48hTuLTPBt6uG2tVEbRRVvKQr7qSZv/THDK5/fsPRLILmlZp0+sWXWEMlp25tRTvdUlkvhgDpQhBBk7Xpw2/WNTNcciwCV4ENZvJuvlLVUt1sTm2llbK9DDNN55pWfltlQswjlh2XFTQbM3dBdqqt+eTE/9bviiGOC+WUEncGgm0s5E9hPqxwtrOEHu++p+E6DTbn76h4jtwoev54pqgHFtv9qpZ3UnUOsoBgI/lRE0iX1qfId86tWTOyfo3im62f04xW5+LNlhm5i3d1Ohcu/n4ZPM6reeV5E+Yufduo2+SyugUAxp87dhY4NTuBXalrrqjLQ46tVhj9YCY3Hk8coI/nSAbVxEzdI6mbCYS8c/Eerz4Y0bR2xhA+W8KI8DfNb2knsosaa
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:59:23.9209
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ed4718-0d0d-4492-fba9-08df13e9f352
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6832

Define a structure with all info about a TDI such as TDISP status,
bind state, used START_INTERFACE options and the report digest.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/pci-tsm.h | 69 ++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/include/linux/pci-tsm.h b/include/linux/pci-tsm.h
index 9b34304d9a1f..2ca577e2a37e 100644
--- a/include/linux/pci-tsm.h
+++ b/include/linux/pci-tsm.h
@@ -11,6 +11,7 @@
 struct pci_tsm;
 struct tsm_dev;
 struct kvm;
+struct tsm_tdi_status;
 enum pci_tsm_req_scope;
 
 /*
@@ -88,6 +89,7 @@ struct pci_tsm_ops {
 
 	int (*refresh_evidence)(struct pci_tsm *tsm, const void *nonce,
 				size_t nonce_len);
+	int (*tdi_status)(struct pci_dev *pdev, struct tsm_tdi_status *ts);
 };
 
 /**
@@ -331,4 +333,71 @@ static inline ssize_t pci_tsm_guest_req(struct pci_dev *pdev,
 	return -ENXIO;
 }
 #endif
+
+/* private: */
+
+enum tsm_tdisp_state {
+	TDISP_STATE_CONFIG_UNLOCKED = 0,
+	TDISP_STATE_CONFIG_LOCKED = 1,
+	TDISP_STATE_RUN = 2,
+	TDISP_STATE_ERROR = 3,
+};
+
+enum tsm_tdisp_status {
+	TDISP_STATE_BOUND = 0,
+	TDISP_STATE_INVALID = 1,
+	TDISP_STATE_UNBOUND = 2,
+};
+
+/*
+ * struct tdisp_interface_id - TDISP INTERFACE_ID Definition
+ *
+ * @function_id: Identifies the function of the device hosting the TDI
+ *   15:0: @rid: Requester ID
+ *   23:16: @rseg: Requester Segment (Reserved if Requester Segment Valid is Clear)
+ *   24: @rseg_valid: Requester Segment Valid
+ *   31:25 – Reserved
+ * 8B - Reserved
+ */
+#define TSM_TDISP_IID_REQUESTER_ID      GENMASK(15, 0)
+#define TSM_TDISP_IID_RSEG              GENMASK(23, 16)
+#define TSM_TDISP_IID_RSEG_VALID        BIT(24)
+
+struct tdisp_interface_id {
+	__u32 function_id; /* TSM_TDISP_IID_xxxx */
+	__u8 reserved[8];
+} __packed;
+
+struct tsm_tdi_status {
+	__u8 status; /* enum tsm_tdisp_status */
+	__u8 state; /* enum tsm_tdisp_state */
+	__u8 meas_digest_fresh;
+	__u8 meas_digest_valid;
+	__u8 all_request_redirect;
+	__u8 bind_p2p;
+	__u8 lock_msix;
+	__u8 no_fw_update;
+	__u16 cache_line_size;
+	__u64 spdm_algos; /* Bitmask of TSM_SPDM_ALGOS */
+	__u8 certs_digest[48];
+	__u8 meas_digest[48];
+	__u8 interface_report_digest[48];
+	__u64 intf_report_counter;
+	struct tdisp_interface_id id;
+	__u64 tdi_id;
+} __packed;
+
+enum tsm_spdm_algos {
+	TSM_SPDM_ALGOS_DHE_SECP256R1,
+	TSM_SPDM_ALGOS_DHE_SECP384R1,
+	TSM_SPDM_ALGOS_AEAD_AES_128_GCM,
+	TSM_SPDM_ALGOS_AEAD_AES_256_GCM,
+	TSM_SPDM_ALGOS_ASYM_TPM_ALG_RSASSA_3072,
+	TSM_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P256,
+	TSM_SPDM_ALGOS_ASYM_TPM_ALG_ECDSA_ECC_NIST_P384,
+	TSM_SPDM_ALGOS_HASH_TPM_ALG_SHA_256,
+	TSM_SPDM_ALGOS_HASH_TPM_ALG_SHA_384,
+	TSM_SPDM_ALGOS_KEY_SCHED_SPDM_KEY_SCHEDULE,
+};
+
 #endif /*__PCI_TSM_H */
-- 
2.55.0

