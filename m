Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795093164;
	b=5jipXX+fgKmcNVwsc4QWvFjZZNvnQineue3PX9mL+oxlVdu9GHYWe+VFnLgEu94c1frV
	 8CAeDzzJmHsjI8ymNQOj1hBgzeLufPMopY4+Xsi7vOp4KXMnlxU7IofGRcSPuTTMs//is
	 kGxLBw8VHorI3dLHTQTvkFmpjxrtf+Q7yk6WLZ6Ek/ZTR+JwFSsyk43TfIj8PdrRA5/6U
	 7i44EABLXy/DEAGkxE7vF56zv6fWGWL612+yAyX/EcTRoV1w4ZJb/jrsHION2hX1AIYjR
	 M89KajIP0PsN3/BWtf6nyZW6vRyqAqvyczfqszCYf67dPV39bBfjDvCRl6H/gYgy/mw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795093164;
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
	bh=8uCGX6ydygiXmsC5NMlgjCdNt5XA1o6vNx+pEUU/vyE=;
	b=aLU2chrjrLi9FAcV7Z91fd1AABqHR0tlJVM38QARS2PTFrahfwqX2eZFOM2wS26KZ9jw
	 SFrbAwBoLI/hkiY58jKLCfdgCcIex0l0qSSuixbX5LhTBhACgksvgLkEJEtgiDXTI26Iq
	 NcZOuy8lyLGbHJa8kriZ2z1lfLivX3jJcTKFjRQkmyF9nUZWbx2qNtjdEwWhWAAwJxGrT
	 v7nBS1hwfm4eb4i0fUHQQrl2s6oVECFqi47CDIwwVSYUOK4t79xKbyupw+ab162/wbB+/
	 SFSADMFQIH6EAn8qyl4jxLiuvQmyEpw02cQTcHCTZeIYQlGPnoi4LceLOTygtGUy1qA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="eeTH/IkA";
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.45
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BEA606A320;
	Thu, 19 Nov 2026 12:59:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00BEA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=eeTH/IkA
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vXT820Y6Fd56pUn8WsEyUpYDdLqtAlxTduM8DoATuBltGgoFwTOhRyIBchYWMm3R/xDvUWmvhXcFT/tNVaLjlDi6P84sj31FV+bJhtj3TZyCOdkQwgoYGfV3oRPHU38A+6qJ1Eia9WYbd02pgo5Ou6vc30YP/wQCfmOfpYNDLG3AndbPu80OVHaHCDfhzNcMHVu6Ko7nHBnoiu8gJ6ugksXOFF+Ir7iuc0b5/vl1ufjRtK1MNLsvFYKhW7GJaujXDNH6Lx9Kn+T6IWW7op1Q/YT5SLzQeB1joH24NeygPJ5Wl5AldrIGoC0II+BCcUFYNn2Z1K9vpTKTg3VDsjyBlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uCGX6ydygiXmsC5NMlgjCdNt5XA1o6vNx+pEUU/vyE=;
 b=e/09oc8uL2PkH/yS7b3yXY+RsyBACRRIlxmVhAmgVS8gqJlbFJ98yPriKU6Aw4siVRcgayUrZxNrs2hfO661xsHZ2SaJnB4t0G/0D07D+Yy/QBlNJYhUfIesCryeZZqrrBLEiQcAaak1gvvv2GBYpkxTJ3ZZON/YHM5O6LjKB6dD4gRca7loEiygLpulvcV08EVBSaSGfCiPWl9/CMQnuzJA4/2I8yKiUP8TmdpAVisjMGh0iP6+1rOKDzSArgjy66BATextluZJO6W030+u2RN/Lj2Bo0VHnPalNUoKaQjrcAd58BBULbxsGQulnLRlQmQVtNVuXhORZfnRHS/k+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uCGX6ydygiXmsC5NMlgjCdNt5XA1o6vNx+pEUU/vyE=;
 b=eeTH/IkAvqcqcEWtEvrJ2PrnYojPVIodacryQ/AZTf1tgTX3jZ2OWZKsBcpedWa8O83MyTPSIDwuWyK84qPD8njQeyXEMMpvQa4DHmjaz9AYJpHgPLeGMATHURL0FZGRjpjkII5qYR83c8DJ0yl9ImrAbqoI2c6ukKHLz1T+uhg=
Received: from BN9PR03CA0770.namprd03.prod.outlook.com (2603:10b6:408:13a::25)
 by LV0PR12MB020964.namprd12.prod.outlook.com (2603:10b6:408:609::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 12:59:20 +0000
Received: from BN3PEPF00022BBE.namprd04.prod.outlook.com
 (2603:10b6:408:13a:cafe::16) by BN9PR03CA0770.outlook.office365.com
 (2603:10b6:408:13a::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Thu,
 19 Nov 2026 12:59:20 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BBE.mail.protection.outlook.com (10.167.248.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 12:59:20 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 06:59:13 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Lukas Wunner" <lukas@wunner.de>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Jonathan Cameron
	<jonathan.cameron@oss.qualcomm.com>, <linux-coco@lists.linux.dev>, "Santosh
 Shukla" <santosh.shukla@amd.com>, "Pratik R . Sampat" <prsampat@amd.com>,
	Scott Soule Cheloha <scott.cheloha@amd.com>, Ackerley Tng
	<ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>, Fuad Tabba
	<tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, Alexey Kardashevskiy
	<aik@amd.com>, <aik@ozlabs.ru>
Subject: [PATCH kernel 4/4] crypto/ccp/tsm: Use TSM API for DOE
Date: Thu, 19 Nov 2026 23:57:33 +1100
Message-ID: <20261119125733.1860288-5-aik@amd.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261119125733.1860288-1-aik@amd.com>
References: <20261119125733.1860288-1-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BBE:EE_|LV0PR12MB020964:EE_
X-MS-Office365-Filtering-Correlation-Id: a7bc9042-8fc0-4d57-ea08-08df463ceda0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|36860700016|376014|82310400026|261021123027099003|10067099003|56012099006|11063799006|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	TbbWH8n1jq3z44t36OPXvhmqG6gNX8dgsnL19GejgbnFhioRCv1nZ3/coh6qIcKU6InX6/iSwTHR/QhOf4xaEGLYQ+qHM4FV0igMtT7fd7alvm3a0zBVNI2BU0k83YFMQEgk99QIx5XkS29QnXIDVvSsxC3Lf/1Q/GoRX+XIiHlqGfSs24CmHWkPygi1T6bJiW6QrHL7PBFfGcZLAlnJw22nI1JwJsINc65cWDHKNRbyWA3h1YJWMlX8UTqST70V3gspCzTtzCMiuFEiTARlrtIbnGeDkR5WHX/DjTzlO4nUSjvTFPkOrvVxECb/enXef1MW86rkXmqth6f28uPijJJMEin5K/c7rQ2rs+NLO20pyArmS8lWsnSMvBrZ07tISMtAgr9TAVMW+qE2rc9b1Gi+Pr6qOn/spu/myzaB0k0gAsWhM4tIIwmHimY61rd+DDVLXD67Cv5gf12YDoxdfQydEqtEYvfWGCoGZojBL3w9/Ut+MW0xZRpArMzFNLkBR+C/+fNXpnkyyEEDnLMID39dbJdkeav9XHOIDLWHyNx2OY57+sKytPIdHpqkl4VEie7rOMXyv3/F9Tj5M5QVaUwoKTumV2PQbs+kXUMLvNuYRx9QKMS6KtcYWAY58fKJKbdBOLVLL717vaK3SSwdKhRK+8KUsXLCnAIxHg/tX2UYDs9wAP1ytzw3IHB4fzV1
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(36860700016)(376014)(82310400026)(261021123027099003)(10067099003)(56012099006)(11063799006)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+qqIhav5HptdHxwLZo/92UF1kwX5DQkowW6xCeTnwuTQAw305nHUE8yJn/OnRwAS1l7iD8SBfYHU+7ZxeUpSZxKqn+enw0LzW0K0QbULkES/jS4/DQU6s9zoGi4r61C+ygJhuW1jyTFIQLhBVZxEleYLUkCjBXDAmN02WN9lKc97Z4fDbLebThbk6EVu8jmxer63KZljPeKy4Ej5e3ddEBfxXtCfz4uTh//DBzuL6X7C5fjcUY9fCniTUD/nY6/Xsnn1I6Y0HOhzJoD9CwASlem50yuhNHTmEdkgC4codZeHOGGR9i6VmHV+NI9G6fLP/KzOUOxjmv11Jjo5b2jHOGkYF5SLC7nWPKlPfTodC8kRe8ln/qsgUJvjL+J/t8G+1fYClMwZEC/2cvep3B6NjIbOFjNk3Hx26QuCnUvDBboWUeqhL7lgP6ZFdQUlBYDr
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 12:59:20.8187
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7bc9042-8fc0-4d57-ea08-08df463ceda0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR12MB020964

Compared to the currently used pci_doe(), the pci_tsm_doe_transfer() helper
performs a few more sanity checks, use that helper now.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index eb16948e1561b..70aa26efd6a6c 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -39,8 +39,9 @@ static int sev_tio_spdm_cmd(struct tio_dsm *dsm, int ret)
 
 	/* ret > 0 means "SPDM requested" */
 	while (ret == PCI_DOE_FEATURE_CMA || ret == PCI_DOE_FEATURE_SSESSION) {
-		ret = pci_doe(dsm->tsm.doe_mb, PCI_VENDOR_ID_PCI_SIG, ret,
-			      spdm->req, spdm->req_len, spdm->rsp, spdm->rsp_len);
+		ret = pci_tsm_doe_transfer(dsm->tsm.base_tsm.pdev, ret,
+					   spdm->req, spdm->req_len,
+					   spdm->rsp, spdm->rsp_len);
 		if (ret < 0)
 			break;
 
-- 
2.55.0

