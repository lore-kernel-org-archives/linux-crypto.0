Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1210A27603A;
	Thu, 27 Aug 2026 13:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837778; cv=fail; b=j1nyYF7Gdu7k9A4G+sbtMQ6XdRAiblvpNRIKYY7YM9W5ynRmHXXNCEK79QBH/NniPC/bkunZr7AfOiYUwPwFS5DrYgD8O2X2eSuFV1MzhlL7faJS/o088N+4RKSm4gD3OEMiE/NmewVVaheRWDSDh/DVFvkO4VoZnavwuWhOP4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837778; c=relaxed/simple;
	bh=HozlCLR36ga71qoQwh9Oepa7aANsBORlKM7DBvOwCO0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T4OMukD8wa1PunC0USQHZbz/yRKATeibcXLfDwd4jiVB1Ag1O5AS6vGqggpsyL5UEGcCLyvaXk04iMEzaN0FMxggO5MkVOk/1ezxboZWsHQE/nolkBvEOem10Ny4X+vfN35PDDYWwvwGWaQevTbvCDw0/6N/fFkPWTVvwK8Egic=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=ExtQi0/y; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=IGRRHDz6; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="ExtQi0/y";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="IGRRHDz6"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67RCAM7l2720335;
	Thu, 27 Aug 2026 08:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=2F0bYjLr9Tr9I
	S/RiEjSUtyw78ZgQZyeHJnlBIOkkgQ=; b=ExtQi0/yDCLUNOGKg8yI7omKhii4z
	p3zk9yLwWTo7Vjr3WJhAizzaE85e1pw0ITZHjJh9tKDQ5bFJ8lG5kwPuzxXYSJC4
	48tvV9Et534Dvmykn+M+g0goK4kA9BZW9zlUPVtCVaaz69Ks/ox20YUJR+D5ujp3
	eTEpyUHeqO+O5eLjncEUld/kG8FsJMkmQtGtYFo4gYb6iIofA4GYRrnKUX8MkssU
	uNBIa9mww1cwdNWpFEs9Nn/TklZ5gVuajIOpuEpj5vAw1LY59PB1gJDcQeMImesr
	45lEjer8wjvnjG8G+OFPZXmoXZAgEEQJRAHIp2Hk2UvpQSUYWtPxQO+gw==
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gakag0yf0-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:36:09 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WSSf7sDt4QvgOHNK4zFdJw9iYIeN6CONjYRcXYGEtg8Q5O1XoNxdqR8A2ekPsldWFU9pAHK2Dsf0zmmlqmOKvJJ/bdiDCf0f08bFoFHob1uvTI8rUXFEsSWOsmtk+KTtr9/4IN+E+uw9QY8x/YQ9L1OITIRWMqgdlHW0LtAjtrFiGCnxlpws1akPTQEHZuDx0w/HPGcJKd+hqJzTcVfOxIVz6hB1qn2LcPgEBtpisWiMZ7o2PZLjBSBt+lB/SpmG0k7t298pvEdoOlXW293zOOwpLt+BtHntBBQeuukC5nfZAlsjiADYGhNj5kYrm5nrz3aR7ouzxSnoq3zWCxl5HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2F0bYjLr9Tr9IS/RiEjSUtyw78ZgQZyeHJnlBIOkkgQ=;
 b=xuvc5v4pm9E6uhjRlExqi8+u5DIUTQOa/VYJYzeo//Wzf4i8Y3fjIqLSA4YVxXar5jGS/61zXFAa/pxavI1ySWrn0zemh4KdphgHiKgHsHq1vvAZwjRgZzC7vu98AAMplUbwNbijbqSy1DieuwGtIXX9WsTdVe0n9gmhBXeKIXXbaD5FY8QVd6qMD/HF8yxuM3vNe8s1UVJsDjLplRwH/yu/0YwQRYGmCW6zNszZDIQWRg8I0I1yNvd0c1PobPPy7yZeQk66/Vfxjc7u5VriStcqHAHkCls+/hZAA323sPXXz7HcW2h7MTHRh4yVqSdypYBXoJF5Lcb/s2CdACMUDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2F0bYjLr9Tr9IS/RiEjSUtyw78ZgQZyeHJnlBIOkkgQ=;
 b=IGRRHDz6OfsjbqM4hBzab1Up5ZlRduwQUm71p0b2wsSaUn5Mm0nEsQz0KGmx+bIExyIi3k+QVQRmBt+1Nf55gcfvfc24LDlVqhH4JEAcW68ctSXkm9b4na+Vr/BpNybTdHDfnxPb9BBHw0wt+drlTYELrR8X3nOIr4alk8Yxd9k=
Received: from CH0PR03CA0365.namprd03.prod.outlook.com (2603:10b6:610:119::13)
 by DS4PR10MB997769.namprd10.prod.outlook.com (2603:10b6:8:34b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Thu, 27 Aug
 2026 13:36:06 +0000
Received: from CH3PEPF00000014.namprd21.prod.outlook.com
 (2603:10b6:610:119:cafe::41) by CH0PR03CA0365.outlook.office365.com
 (2603:10b6:610:119::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:36:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH3PEPF00000014.mail.protection.outlook.com (10.167.244.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.0 via Frontend Transport; Thu, 27 Aug 2026 13:36:04 +0000
Received: from DLEE211.ent.ti.com (157.170.170.113) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:35:48 -0500
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:35:48 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:35:48 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDZkAJ910858;
	Thu, 27 Aug 2026 08:35:47 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v7 0/2] Add support for hashing algorithms in TI DTHE V2
Date: Thu, 27 Aug 2026 19:05:40 +0530
Message-ID: <20260827133542.619717-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000014:EE_|DS4PR10MB997769:EE_
X-MS-Office365-Filtering-Correlation-Id: ca495739-9487-46d0-80b9-08df044024bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|13003099007|18002099003|56012099006|3023799007|10067099003;
X-Microsoft-Antispam-Message-Info:
	rwVmIXeXOkgvHOLn4H4/8QoqPvJIP7q+J3LbspKGyHYJeoX1Bq1ndpuPbJuzthUiVBODn3HarQcLOpFShfrJlqg47rmVs9190Ybwml3j4o30nrsjPuXHDT1CgJpTQ6K25LdAcR/AHPNxp/A6GzfjrYyJuAdDsx7Ssz/pwIx4QVhG7iQpXZ+EbN8GmcVkW/0Kw6rgAjjqgUixV0Bsrdn33bct8cM9iAENDuxgWrADKEUJVm7Jkkl8jFCCuQ29n3bmPNaoLbg4e1G1loKXQ0U6IkXUIWtKPGUmFcWhRz1M4N6IYbLR8B9eSENrghBb8s/JHh16bAk8YoY2X5gSnUV70Fi7GD/uz0D+kXP4w7KAJ2KmHbYwEL+jcaYaLP8C07dol4oujZFwZFkn3ToWiCrYIl8eIctdPaewFXhTur3Rdk2UYo4NQCW8JQNXfHmGj0l221KW5oTArrjipJjkF5s/4G96SOl7uc6Ni1xmrPYhBPTq8ovEeUYMy4XovFGMQQIhM78krtyQRva37bcm7ahGP1TtZV7W5/HtLU/vC/0y5ovrGtya/r1a2++5qsJgIeTAsgzkIW67SfVE7jQbVFtaAjYzdbJ/cXW3iaUBwIE6/iJnhnok+EcKd6UlieWhdqKrSjzQCw3YrZ6myL++UgP2qg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(13003099007)(18002099003)(56012099006)(3023799007)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5/5nTwmirCN5stEpkz1X834oIEcFhnd0o3HLuFIdRlbvDJlL0pqC829zIKwAMyhofVOFnhq+/qezYTXvNmhkAaXBxV/QZBpmWRwEgowhL8s6G7aiJhaWSApOYWSaCey8Up2Sy2rAF1cZrzQirRSGfTciIJuDIz2XSKLLSUpntR+P+tuh/6kva3H+dWVz+7/csjzSzdNUwg64m0hw36dibQJAeolcuPwG6dInUVCiVrXg1sxYA0LzohIAlSRXCJBTA83f/V7N75iPByOurUXT/EC8rF9IML7SnFrOcVmo3BwnpeLVjr4MSC3Al25seW6cpoTrNoKt2XLddxk67pa5IhCPBFWQ/PSir5TLcWmRyVbZu6GFwdnP3bqPCnpWoywkG1Jhoci14VMYHSwahiTWgsi3y4FNHd1O5zSV/KtPWp47DAwDdbcVFBxcP1L9GuTh
X-Exchange-RoutingPolicyChecked:
	fajfXNS7PgLuy27Z4Fha5cxwk0H5ERkPW4DI/MMSvWZxyRXr1JtuT/HFAD2f9+d5YLZc+ksCCN7jW+mBVRxg1tkugRCYPYFAQ9DWkTDn31pi4a2XeqV6keVZBKpSxkvK/q0rEDykyUYKkOPjMZipOiHdRizzrYOa7v3CsEpv4vpUuY71VciEz7AtSoZt6ILcWG3cTZPTohmil6lHSaXkvX6j/339Frfk3IdDDaULeiuPN9nIu8lclQrHJh+5TNSr7rKCy1wk1lcAp1XFNOCplQ2OleGii+rGBqx7/ofXTC8IjHLiFA0u3nN6e9knN2I37c1ABfgXwBKedBPWsemq4Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:36:04.9741
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca495739-9487-46d0-80b9-08df044024bd
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000014.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997769
X-Proofpoint-ORIG-GUID: gqZZyUxhkXmqMkQ1ROUkAgwRwtbSNnBB
X-Proofpoint-GUID: gqZZyUxhkXmqMkQ1ROUkAgwRwtbSNnBB
X-Authority-Analysis: v=2.4 cv=VrMTxe2n c=1 sm=1 tr=0 ts=6a903d49 cx=c_pps
 a=QwCZ9Ep3279coiJ7nb8JBQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=NEAV23lmAAAA:8
 a=CEN0k3Drp4yoJXN3_ngA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExNCBTYWx0ZWRfX8QHkt7i+2Unr
 4ljSv04vitav1w9f2Q9ghcAy7wX2c+y99TB3ppij2aNijQ/zPdCK/3VyjYXPPBcqCC2oQoEmNXe
 98qdGdyGomSswAIHyKG47zjvis6l4OaBsIIonAwmTR63yAKxBVO/GHb/df6MUbsoyGGkeUpBT4B
 16cN15PRvJjRMmDA2wjtWE4SyRocG7Brx2r+DQY/W1CEzQtsJM1PApqrqQl/UD3dHVSiCR0DjEa
 YnIyLop1XOy1Us7Nv1Qh0IozQQME6/5rrgYeBmhwpZJs5a8UBznryom6rWUB1TEmisMxRIHmfTR
 JIteTHZFK1i0pV1Cpy0zb1TcRlLltzNySjbAcUFpaAk8bMhzDyszYouXe76NMFvUF4bn7pu6/iJ
 /XvGDf7/XOXNNSz/mjaXv6jsGWL0ASZihBjZMRa84M9/PWXbM8dTvdbmX2h44rNyRTV48qp9QcL
 rGq3FZklUAk+mfxtl2A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExNCBTYWx0ZWRfX21/HasVmBm+C
 +0hfNiyY2fDkem32QevnhclA3eoW2IRk5xuu/2iQmnouzIyFkIb7IyBlCdjHDZywYlfaZwNAhRq
 nvDjJhHG4pewvAJCGiaa93PW4GP2CKI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270114

DTHEv2 is a new cryptography engine introduced in TI AM62L SoC. The
features of DTHEv2 were detailed in [1]. Additional hardware details
available in SoC TRM [2]. DTHEv2 includes, among its various
sub-components, a hashing engine which is compliant with various IETF
and NIST standards, including FIPS 180-3 and FIPS PUB 198.

This patch series adds support for the hashing algorithms
SHA224/256/384/512 as well as their HMAC counnterparts for the hashing
engine of Texas Instruments DTHE V2 crypto driver.

The driver is tested using full kernel crypto selftests
(CRYPTO_SELFTESTS_FULL) which all pass successfully [3].

Some of the pre-existing errors caught by Sashiko are fixed in a
separate series [4]. This patch series depends on [4].

Signed-off-by: T Pratham <t-pratham@ti.com>
---
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 kernel self-tests logs
Link: https://gist.github.com/Pratham-T/fd15b8e0ee815bcb420a60d451a0cf18

[4]: [PATCH v2 0/7] Fix several issues in DTHEv2 driver
Link: https://lore.kernel.org/all/20260827132318.613876-1-t-pratham@ti.com/

Changelog:
v7:
 - Minor fixes based on Sashiko comments on [4]
v6:
 - Dropped MD5 and HMAC(MD5)
 - Fixed errors pointed by Sashiko
v5:
 - Removed CRYPTO_AHASH_ALG_FINAL_NON_ZERO and FINUP_MAX. Implemented
   the same mechanism in the driver itself by witholding one block in
   the req ctx. 
v4:
 - Export initial state when phash_available = 0
v3:
 - Check for error in registration individualy for hash and aes driver
   algos.
 - Fixed comment style in dthev2-common.c
v2:
 - Completely revamped the driver to use the new CRYPTO_AHASH_BLOCK_ONLY
   framework for handling partial blocks and crypto_engine for queueing.
 - Added HMAC as well.

Link to previous versions:
v6: https://lore.kernel.org/all/20260827112653.530273-1-t-pratham@ti.com/ 
v5: https://lore.kernel.org/all/20260807110501.975130-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20260526094355.555712-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20260226131103.3560884-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260121132408.743777-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20250218104943.2304730-1-t-pratham@ti.com/
---

T Pratham (2):
  crypto: ti - Add support for SHA224/256/384/512 in DTHEv2 driver
  crypto: ti - Add support for HMAC in DTHEv2 driver

 drivers/crypto/ti/Kconfig         |    3 +
 drivers/crypto/ti/Makefile        |    2 +-
 drivers/crypto/ti/dthev2-aes.c    |   10 +-
 drivers/crypto/ti/dthev2-common.c |   43 +-
 drivers/crypto/ti/dthev2-common.h |   62 +-
 drivers/crypto/ti/dthev2-hash.c   | 1032 +++++++++++++++++++++++++++++
 6 files changed, 1131 insertions(+), 21 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

