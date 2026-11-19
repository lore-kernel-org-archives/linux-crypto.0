Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795093125;
	b=369oe6jHX9NKCmArcPzUmMeE8CruTRqTliyVM9/ppPH0gCdCEuJJtGCw8p7I7ge3pivA
	 u1JhDh+yeR8ecIBlMucfgoS4bo4DzqXHisp2ZJAkGMxaOltk1rWQoX1ycaGR+tIAXqFR3
	 QVxJ4ASAq0Ks7u+ddFWs/A+T0FsiJhRu3/X+Zfrf5ZPb84gdSJX/R0Iqv6hchOj8V2LsU
	 lpnbbNuLw4o5XicIlWKkvT0zbH1oJcuqDlwQkvLIvMOGS3vaVPQaAVlLvSR64H44xJvfp
	 pR0HcHMbdVGnSwoITspEDpvGFHpnbCGskW1iHJeC7IQhoYqDIEvm1Mv1zpNeW68LEOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795093125;
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
	bh=8p5GZmC1Fo71kI6crUzGctx91xTlnrxCvdCZ4FtrWbk=;
	b=plOKIWMAdya1Rz85rpYpnqVx9+TuDXl/GQPCWPTbhnXs+TxYsKC0q0KA6GE0eZ0SDF1G
	 Z2bFQHn8iWojBfgFI7HqS44HrbWqzA++BgysuLlGEu3iO2/SujcsHLfPHODLfvyrlsTkm
	 x/U6B3yuI72QESj1Iy9cNFUKvaKIY835610DmvvL5mXD+SrrHF2NE9E9FNcfCFNVpAH/W
	 0iU2VCtMmMauXC9IsBXHqZdh4SzDIly0C7yiuW9gbSXrkx7AB54y1seNmkkQLuNLEPbIm
	 4rpcTpCOuce7Zyjo9V0yEZ5CVS2QJctg/RlFrcL8gexwuvYil8a98kGOu5aSA7PNhAQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=tW0eUWoG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.201.2
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013002.outbound.protection.outlook.com [40.107.201.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05462606A320;
	Thu, 19 Nov 2026 12:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05462606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=tW0eUWoG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cqj/HM0t0v3oqF2SE7ThhjCR3iBoI2NKQw9FOABpqdNeqyrbmd2qa6C1sbQhbeYARdY1ijjO9XgmjVLfexaJnGJBTLNrM+JOC4rT4ifKYLzJWrfZ9SlAAtRoUVECuyr1Ui13+VfCK05No3Q+rSS3KCsxbSkbEwTrdox9Lcuu/p30qSeFz5TtKrCidtt7HsSmJULA7X9k6FEYRhjFm9AP8zJYz0GzxIu9VK7f1PEEZZZYzLEPA5wo54QvVK4XPAnJ0zqegD6TqC6QgE66WYCqXqOR28iSGh/L/xJGBdNKTNmljZjkMZ0jhwK4Y79J95NrCypJEMqNdRiiffHfyA9Txw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8p5GZmC1Fo71kI6crUzGctx91xTlnrxCvdCZ4FtrWbk=;
 b=JYFj07GHrT2+dEFrzJGUw4azLQqe8VB8dN5mfmrTTh1sOgh+MXcsF4G8b7GqpMwYg5/G63YHX4aleH4rJ9aWdAevYqgW1PVWVKEOsze3WaX1c9fx4xUzDanivsjf5kLIg3xEkQp91A4kmeVzqIeUjWZiEg/6F8ap94Po+ZZhqQOfTANdyistzbr3dDgDLQ79xTgsa6FBzJ2W+seHqumfj+QsR1+x/M0WZdgG4fmsHw39iiNOsWYFAIhsas7SsPFRgqFuOtDhPodOkzoTWPD8+OaB7F1AbYY3FS7/Qu6sP4f0W1KyIgnZcotmk/HJieOwx5vrixbIDF6GkUvfSV0+2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8p5GZmC1Fo71kI6crUzGctx91xTlnrxCvdCZ4FtrWbk=;
 b=tW0eUWoGBLdHWBnPJqOjRNc6FK91FztsZWKAbcRh/oTqCZzDHEFupvVwPrXpwjZOR4XxWrR2XxV02i7aBayjc0PqUOxUbXFoDisuxPn1fFGv9PGvSYlaU9c5FSCqQnwmgW3GHeJyAo7KyE4CZege8jRAbuFpbYarvMS6d9Don0k=
Received: from BN9PR03CA0213.namprd03.prod.outlook.com (2603:10b6:408:f8::8)
 by DM6PR12MB4338.namprd12.prod.outlook.com (2603:10b6:5:2a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.10; Thu, 19 Nov
 2026 12:58:41 +0000
Received: from BN3PEPF00022BBC.namprd04.prod.outlook.com
 (2603:10b6:408:f8:cafe::ab) by BN9PR03CA0213.outlook.office365.com
 (2603:10b6:408:f8::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.10 via Frontend Transport; Thu,
 19 Nov 2026 12:58:40 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BBC.mail.protection.outlook.com (10.167.248.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 12:58:40 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 06:58:33 -0600
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
Subject: [PATCH kernel 2/4] crypto/ccp/tsm: Fix potential size mismatch in releasing SPDM buffers
Date: Thu, 19 Nov 2026 23:57:31 +1100
Message-ID: <20261119125733.1860288-3-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BBC:EE_|DM6PR12MB4338:EE_
X-MS-Office365-Filtering-Correlation-Id: b355a9df-4341-4822-2fef-08df463cd585
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700016|23010399003|82310400026|10067099003|11063799006|261021123027099003|261021121427099003|261102123227099003|261009223027099003|56012099006|261022105027099003|261026140227099003|261026121527099003|261028144727099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	owtLuUC7C+1i3J2Y/BA2jyKzkK6zjnjsIrn6EG11CG0BqRX3gKLlZyAw11zWLG5Swfp7/FW1LxDaxXBmB32D4ZJcqbYu7DoRv1vrVGUwSBhrKwyUaXgH60m42Bu9yMw/cvnPj/4nvinDGmN8gIR5irKOXnNEtfRp1CCeoqjMqoXkNpyARphcFg3lnkrQDDvT6dxqh1DcozkwXa+uQJ5ZxapA18B9f1GUKYspZycFI/CZw3gSJqnNYHabVTNNDv073j4rUaQa9u+8Kunvgf0CgnT4kPLiyU0AQs83+S+yMrfihJA3U0ZulMI/4EeY9JjV/vwsBNq1LUD0lHk4ZChEB4AZ4Dt3xxsJlPyMxSziHy41onqoo2W3uzKnSOfEvZJuyZXl8dQyKQh/bxEoV1Nu+poE4e0ffS6lw1VGYQsk12iIdwR4o/If5ms/lF53CHI610RNkB53lzk0ZkbHrQAj/qB4Whfqgj244xmHJ12UdDwKE+/hZdtfkQWUE8fl119TO99GvxL7+0gMMpKuSEkI3W9wJMRoZHIOdIydU9oB00xb6BwlP/T1ZWAieib1/SoegUUyDKIu7HG9WUMUKztyrFVn5NLSwtklGnM4zWVIEFwWPt5tYkRCB3LUCV9L8MQN+QyTv7NMrSC1jhqkGJJ65EvjNDpf9J39djLjktbt1prLY0w6evxGjyu5CR6vDyog0u6lz32BSmgciDwFMUGUAA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700016)(23010399003)(82310400026)(10067099003)(11063799006)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(56012099006)(261022105027099003)(261026140227099003)(261026121527099003)(261028144727099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	pl9kLUC/+ICUhNrIo/EZQB3I46RFgz50cfhrY9gJUziZ0DJhsKwhcrWJ2LRNfOaLDUWdbhb9vhSXyehlzkgRzn+fdrUYksw043QP9PDGjJfzTb8lFE8a81aW1XRMLtoW7qVGWvZ0HdnXUULQCdTmjG9JbzMD7zhK8oEmU9H8hUKTHsAP2RlTjDoZ1asf3ERRBr0umOxxKnlB7xO9WnKvuo0+368aFyMpcK6unqCV1DdGS119V1klBx2HFsImfWLZKEna+I12nZizjWuG2LakcyNkjDGstCMEoplDXi6z3sHj1XU3YZZk+SPQG1t1mvK6U1bGP0fXOo0LLPMOJxVOo+68hs7o2N95Bqy1FHjke56zIeGKhwbPnypDVqx2+WdHzHfe117EgWFH731kE1FUQU2wF0sKMFCkQQf9YM4LjGwEcJRBrmZMIPbSxrNSXibf
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 12:58:40.3732
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b355a9df-4341-4822-2fef-08df463cd585
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4338

At the moment the CCP driver allocates buffers of the maximum supported
sizes which are reported by the PSP, and potentially expands some.

The spdm_ctrl_free() helper though releases all buffers with (incorrectly)
calculated sizes.

Drop the calculation for request/response and use the maximum size
for free.

Use the actual size (potentially expanded) of scratch and output buffers.

While at this, replace the incorrect check for dev_ctx with the correct
check of the output buffer.

This did not bite so far as the maximum for request/response is 4K,
alloc and free are page aligned and the expansion is not implemented yet
in the PSP.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev-tio.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tio.c b/drivers/crypto/ccp/sev-dev-tio.c
index c84e23982b434..37ace91a7d4d8 100644
--- a/drivers/crypto/ccp/sev-dev-tio.c
+++ b/drivers/crypto/ccp/sev-dev-tio.c
@@ -639,25 +639,23 @@ static void spdm_ctrl_init(struct spdm_ctrl *ctrl, struct tsm_dsm_tio *dev_data)
 static void spdm_ctrl_free(struct tsm_dsm_tio *dev_data)
 {
 	struct sev_tio_status *tio_status = to_tio_status(dev_data);
-	size_t len = tio_status->spdm_req_size_max -
-		(sla_dobj_id_to_size(SPDM_DOBJ_ID_RESP) +
-		 sizeof(struct sla_buffer_hdr));
 	struct tsm_spdm *spdm = &dev_data->spdm;
 
 	sla_buffer_unmap(dev_data->resp, dev_data->respbuf);
 	sla_buffer_unmap(dev_data->req, dev_data->reqbuf);
 	spdm->rsp = NULL;
 	spdm->req = NULL;
-	sla_free(dev_data->req, len, true);
-	sla_free(dev_data->resp, len, false);
-	sla_free(dev_data->scratch, tio_status->spdm_scratch_size_max, true);
+	sla_free(dev_data->req, tio_status->spdm_req_size_max, true);
+	sla_free(dev_data->resp, tio_status->spdm_req_size_max, false);
+	sla_free(dev_data->scratch, dev_data->scratch_len, true);
 
 	dev_data->req.sla = 0;
 	dev_data->resp.sla = 0;
 	dev_data->scratch.sla = 0;
 	dev_data->respbuf = NULL;
 	dev_data->reqbuf = NULL;
-	sla_free(dev_data->output, tio_status->spdm_out_size_max, true);
+	sla_free(dev_data->output, dev_data->output_len, true);
+	dev_data->output.sla = 0;
 }
 
 static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
@@ -674,7 +672,7 @@ static int spdm_ctrl_alloc(struct tsm_dsm_tio *dev_data)
 	dev_data->output = sla_alloc(dev_data->output_len, true);
 
 	if (IS_SLA_NULL(dev_data->req) || IS_SLA_NULL(dev_data->resp) ||
-	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->dev_ctx)) {
+	    IS_SLA_NULL(dev_data->scratch) || IS_SLA_NULL(dev_data->output)) {
 		ret = -ENOMEM;
 		goto free_spdm_exit;
 	}
-- 
2.55.0

