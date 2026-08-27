Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2072F7AD2;
	Thu, 27 Aug 2026 11:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787830064; cv=fail; b=UrgNXC0XkvNqkEtkx4qgKaJeuRfSIS7OtRlEF50omtb9vEofZP2aw6Ooy00GsGrgbQ3hqvU8cma/WmxACECWm947wM5SCbrePoRaL9A0dproveyij1OjKdGjqOpr+IwJScKEp5u7qm11k1dMg1X11YJBPEFC8SV/ETIN4SeY4jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787830064; c=relaxed/simple;
	bh=XfbI4KixVmCbjQrWySwYw0HFAHd26jB3EJWoe9mAW44=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NPPcb9hn0ydp2qXuBVX2+FwDTnAxC5LPAIS+gCOwikCDKjjRGx991Y2sxijqb4OGXJDu75Rq6RryytlBldRAWKLU15mzqiRCm4Ef5tHwkqD0WCXvRFYB/r24WeVhFdBefWZo6COn9l5h3LsGtKxrtbBOGq51QUB+QU0+WfWzgeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=O2vA/rkC; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Kr/DMHWY; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="O2vA/rkC";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Kr/DMHWY"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67R9Gvxu1734792;
	Thu, 27 Aug 2026 06:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=Zuh9RuZBfr9LH
	FuW4xDEmB5NjKopEGc6VNSk42km0Uk=; b=O2vA/rkCz9fiBCve7ZSx86Jkpm+oi
	dXB8uEM7ExNnF0hy+cxeNNwy3YYgtlPru9ptquZVUhp0bsPccaO4t5hiVcHeNst3
	6tTHhmcLMxEd3dJxxzGg3epOCKFSrEybBprx2dSJh3K6eAIrizwqB2awakKPTL3E
	u6KD54hL25K+XyQDpG0fqKcGpNQgkpNu8SazrSAd6T3RgUsyfAxyGMocnvv0e20m
	o5kE5tqQrbOcsjN79aeaObuPL/1AY+e+tJKQ5kThr1JyAl4Fv7CRmuqTuvXTtZYt
	CoGBx2OgLH+zzudhF9zfvHHA4ypSAmKKQ00tewmMiNlzEsGb+gfhdZ55g==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010022.outbound.protection.outlook.com [52.101.56.22])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gad8sa559-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 06:27:39 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z/VTsPeY+HWDA+V7lE3+9wOO4Faiby3vYdimlmeQW2WIAXlNb3aYIoOuz+IyQB+5RPfYrKvGNYrArpfpHKqQZ8X51x3/FPbS6kyP7qXHwhP8Ygqds2FuwiMNN3TUqMyliOPYvn1aYsLSaFcyZKWbFDf2rhvMZh93y571eqRKMhYe0YNbw9du4w2LL2BnizhF31l0hCa1vGNeW/N09xtCXUqVuaKGoTGIQO3MqGvvUTzuSs+yzgJcks3BMZUf9Vv6kbu9eHnJ6uSAxQC+YTFnM8OaV4tY76A2RaHfitXKtBzmMLlOYUZgaYyAnJRSBIS1ZYMQ9597LADG5la4co+f7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zuh9RuZBfr9LHFuW4xDEmB5NjKopEGc6VNSk42km0Uk=;
 b=VcqRl+wDCGTx9Mh1FRy6fagGCi7VabENG2HdAuV0PHKlJwLjR7XbX1uebdxSjYxvOzmIEq3DwE3JgbrneNVVtLntvzXVvfr8jKao0gM9n/OQBIzcgFr0tMDfhV3AMcgzXWguh/qmpTh5zwlzvG/5MeL5lWwYbHVSYSnM/ZTw5fTP2rSMWBp6xSM7renm9cGsIlb4FW+wP4j0GurlTwA/EH4+Fp7CuLEugRMWYS4pLcdgS2Kdan2fd43B0GimgPeB/B4aH1TL1nLdUrjqem6fQI1mYDcoeAFLUl9MS4HH4VlRBkX3YAWdTJzy7iQVcp4u8yOESHkjr89HVuSTHkLLVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zuh9RuZBfr9LHFuW4xDEmB5NjKopEGc6VNSk42km0Uk=;
 b=Kr/DMHWYKBHX85IDsvXrp7NB71K7mIIDjwTYuMfLGcnGv9soiJJWrG0FXZmWYt99Xor3ossX33vvB2kvJSgPwD0fYeQDFhtIqjJNtccAFxWEsQhACH4x9Z7sJDaczpWEnyQ4A0wmubNgAiXAMRWYoADzj7dSnTnkZo3HSZwutVc=
Received: from BN9PR03CA0871.namprd03.prod.outlook.com (2603:10b6:408:13c::6)
 by SA3PR10MB7044.namprd10.prod.outlook.com (2603:10b6:806:31c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.8; Thu, 27 Aug
 2026 11:27:37 +0000
Received: from BN3PEPF00022BCC.namprd03.prod.outlook.com
 (2603:10b6:408:13c:cafe::38) by BN9PR03CA0871.outlook.office365.com
 (2603:10b6:408:13c::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 11:27:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN3PEPF00022BCC.mail.protection.outlook.com (10.167.248.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 11:27:33 +0000
Received: from DLEE200.ent.ti.com (157.170.170.75) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 06:27:31 -0500
Received: from DLEE209.ent.ti.com (157.170.170.98) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 06:27:30 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE209.ent.ti.com
 (157.170.170.98) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 06:27:30 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RBRTRE731290;
	Thu, 27 Aug 2026 06:27:30 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v6 0/2] Add support for hashing algorithms in TI DTHE V2
Date: Thu, 27 Aug 2026 16:56:50 +0530
Message-ID: <20260827112653.530273-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BCC:EE_|SA3PR10MB7044:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a3a430-6bd4-4392-4d8d-08df042e3093
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|23010399003|376014|36860700016|13003099007|18002099003|3023799007|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	daarWIa6zF5+c3LLnlIreBWYDIS76XRomEDpKEyFTxGe1/gUTqaQ/a0BYsXvluY0OEjkeCHy5kX+APAUyaG6HKB2h7mkZktaR6JJl5VQLwh+mkiOOZxEZpwYltFJuCrLsihVrbF7QqlBODgAhgaXLctANTcGBqiXcfHwkJWd6ea0Da7YJ0aaCVUsYax9eFaUtd0saeYVRt2Mo3oxJGJtl24oXD6sFKU/33Irt94pyjwxbr1dz3AwtAnLHweYKOPv2XhTD6hdBOGnpKKAvoNFad9ZCrd+9tSxqjt6tT5YtjbdZjUOYeGx5hnJd/l1Qn7bSVFqtNaQO8EkU8FJYMyWQFvFF7tDrs4iFGtneGUFGWE/0HL2QDNvlVmeAIJmsiDHWJLQc5hTcOm+Gi8IGZER5d/6eQoU1ln41E4WaPzvaPNzH2mEio79FVWkrhXncsFfGBKMkDtvsmHkcBdsEZ5z3U9oovLgRa0lnvsVT0FwdVGl6pDb/+he6jDzZ7zRY3xYrm8mNVjBxS7eKxyA3kTLcYQHrpzoyH6HPJ+JpDxpS/5rCacG72A1thp1R4sDGFa8kSm4Nv3EiW3/f4Q/i4P+x6vBFs1jJBMiA5GEjxtsaK9t/m7W05AX62j21ElI2Gr8C7Q4/YCxFwNIi8bQfYBlFA==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(23010399003)(376014)(36860700016)(13003099007)(18002099003)(3023799007)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	eEBBCh5t6IUdqRFb0kcayzHDfcVPEAhn/6LJLjXETN/1pHeta6+YoxwiCQ9LOI3MZhziS8Ph7wsAFlock8owLQ/0rdKqwv3nTShF/MiIzuTT+OBhOBDY8gjbv2gCU1EPfVVqY8Ks3BQ73vPXIAQzi5d19MibVposC4Zb9+Rtiq1ChzHisLVU+mu/mX3V2Qi3VPydu4758S95qUIw51+lMMaCz/c7ApMDxmzmXDiLWhoGklY4qYumKU2ei7FHBhD9zN44i8vIJ4gkHn+TKFRqmn93QqNTaZpkYjlpy9N3qSfhC+TNIMB6RfRhikTLUrK/yRsQX7Vu1XufgpSJme0IeyNTHBeDBixvXVm/TiNkuoRDRxgSPwxIg/+8W8+G6o+ZKVk7MZYZM74kT3hPcjXXlKH3iAo95ljuCRFCX/t5HYBLLQ/F9bT+XjtckQxH8o5t
X-Exchange-RoutingPolicyChecked:
	sS2FrbhzESzI9QxmkkxScsiDsLds2xpbjjaT3c+yg2ZrVVPRNQKHnkjRhYJpxT96ruTGxdVsqcyouc72hgexhSHVs9DKDEgDS1ZKINjTgg0++o0k+bJeI3hlbixbMY3a3MfXC6S4N/+7wYxS6hkciq47E4JXH5rg9i3YPdkCcf1QfGeZ2R/s1EI+j64FtEENN8EPB0d425QQkEaNyv1RKt+y1SsYnHtDrfMQe/EKeMFAlXZOU4oDu4TI4rhNgcEABG+ApG9cIb9wkC/BNWXLTm9p4yISTWkRqpn7+5991IkUdzFJicQi6JVRuVFGbMYD65YyQIWqOdXHhJEqVyk/vg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 11:27:33.8640
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a3a430-6bd4-4392-4d8d-08df042e3093
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BCC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7044
X-Proofpoint-ORIG-GUID: YUX8RiUr4Etkpg6XQ-NENfF8Ul0Yx2TP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5NSBTYWx0ZWRfX/wjTj5pV7Ray
 7pc0GLZDduR+glLvinQx2H2C6A6ztHtk2Vo+Np97rL6NBt1yytoYNnEMSlep1+flCFgNok97QPe
 UzDrtO1iLj5XcEE7VCbYthiVMdWnALm3fq8SSbWQ+m8aVieV+5Y+nd0VJ6vHkybrUHkfGZXXmp5
 WXJzu1jbaY0kGuoQQk+aoQ3tN5/O9WRaziYbWKrTcDDnO4kg8Nyw0NiN5r1hgel970uBhNmJfoI
 yodowX0YQF60iVFrMgofZxhijWPzwYZjk0qNI1rpruxutCPACs1ugumvc5wW6tngvi3+3ct7AeE
 zgoxKuel2tc43qnRHZvKwZY7Wk4Deu9MK1NAhQXIEGvDDCerrNmsriALZYV8lTrh68uhB2Ff7m/
 8q6E2K1F3DR/voW2PXxmxasbxKlRVo/Ci0+VDcG77AEHrRqNBzOFgWQocrrwLiQvqQNU7BofJ9s
 fE0gzZkYPNN4RF9xNIA==
X-Authority-Analysis: v=2.4 cv=TJ11jVla c=1 sm=1 tr=0 ts=6a901f2b cx=c_pps
 a=wVrytDogCwW2gNy9sPioUw==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=NEAV23lmAAAA:8
 a=CEN0k3Drp4yoJXN3_ngA:9
X-Proofpoint-GUID: YUX8RiUr4Etkpg6XQ-NENfF8Ul0Yx2TP
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5NSBTYWx0ZWRfX73kqZuuz3sZ5
 HR+Y6wiJ3tKq8qyv/dqLcJSKs5GaEefbq686xkM3odHzZTyNgjux4LPiTGRDhU0yKO+nm/qqZKy
 5deWuZOL5nbJCFkwFUL9nbzDDHkuR10=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270095

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

[4]: [PATCH 0/5] Fix several issues in DTHEv2 driver
Link: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/

Changelog:
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
 drivers/crypto/ti/dthev2-hash.c   | 1028 +++++++++++++++++++++++++++++
 6 files changed, 1127 insertions(+), 21 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

