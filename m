Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D054D3B1035;
	Thu, 10 Sep 2026 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063523; cv=fail; b=roX1G2E+PjDlUzVVyJjunXxvkcrKrtWlqdZVq1dkrX4ya8Hk1GY3hzBz96PZJDzgwI/KFnZ7WK+A9cihpB1yHi3qFFusT0cGn0s84Ghbi7uA0PJ4JygQ4oV9sBcPM2HRUvIKhWJo/tMujDT6traMcJBAloQqyCZrJKspKwGa/Vs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063523; c=relaxed/simple;
	bh=erxedrdfAvEo1DZo0rE9x4xQ2A+zlqqDtjGnVbpsE64=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hZHJFLPst8m9Z/vyO64jzV7hXmAuLCoFac92+FOWbUTz5FQdIBIV6VTt2u5w70EV3Kgt9quc5XtXwEXnt5h8x5PPUbMTilRK1BOOcaufC4fBJRrcm5RVvMskRvhZPAc5dUOHu1o40Q9b7HuB6zJQzzRopMt395WRQmJPkVqYZGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=KbkYtSAO; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=MuhRcdpz; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="KbkYtSAO";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="MuhRcdpz"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68AF63Mk1431098;
	Thu, 10 Sep 2026 13:05:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=1+LaXzYisRYz5
	6YA63xh5VtT9u50oFwmVTCvdmudazE=; b=KbkYtSAOStarvnmfjtKWzHoOniXmi
	sLiMoXOhfT5q0wXZA1pyYx6clOat6mHZ248CwtKjV7uoYzHr8Z42xCnFoubHMvS3
	weChuO40CoR2mtgBZv7KQ5q8ePgVCMjHhvv6x/S/EcGbqddYXEAnWFmvqHf4+aQz
	8RoZbPPBwMwUHtolaMPeq8xxBkdqhsHBQf1kIbG2sDGwN2oIrvfYiJmQ6wC9N3n8
	ymqHOjxMbENcm21JH/HQDXCko0nfgYk4GNU1hJjIp989RH+Z+EsAfPNHfpes1CGp
	xKqesdqmDamtztwm9H0fsm/y1ZpJmfyUU014XMxw0X676rxgMFUvyFaoQ==
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010005.outbound.protection.outlook.com [52.101.56.5])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgfdcv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 13:05:18 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PdSMdgj75bZXlTZtStyMgoRJeAeH1XdqnM1d1HJjFJlZ8Abgh0NjznnY0rfm8TgtnO+kFMQPnEy9z818wyfgSnQMmbqHkhcHtsAKJw/nRXapzy644xKDjUaBkooq6FYv/c1Hg/SXr9gOAGGXlmgIxSFt3n8Lrhl7WWUitxC2O87xGqsRARoIdyDItm/3iYuTs1dzUqnQf7/LTsH9PYuObWXrpE8DMiray8lo6QA09DRn6xiC+7xelq6ScBd/vgi+Mch+DJljpEyjMft4LcK69J7lJ6TcyO7De2gRbOsKruiA/CX9OP3yCXFwAMfYCVLTztz/DLq7JSSz5Hidfu6tGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+LaXzYisRYz56YA63xh5VtT9u50oFwmVTCvdmudazE=;
 b=N/0tJb3jW0ZZFHU77d/I/6i8TvINCaYKOHumjfaf+W9gt6Lz5HR7Tww8zcs+MS13AAvUf/awHEDegu/Czxm4Wd+l4o1HsQvhxTcqzKvWwObKJnVVjDMVTbfe0/B84gtADfOdf2z/IcVukUCB6tlIY4SMhpSjGxToLrajIfMOzrxJJj2X4W9laKJnrO/hdzvCBOWMdeWy7ciwszdT1f/GPsnhX0ZYsCqa+LqWx897bQaCe7Y+vxLiZ6dsgPwINHaBf6C3lTEnIt1XfewFfeV9DtQ89VPhCJIyHKi5+X9L6d6HgdlFDrEUHiSd367q4UIn1Dcd2SBzPebm4cTSql7f3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+LaXzYisRYz56YA63xh5VtT9u50oFwmVTCvdmudazE=;
 b=MuhRcdpzBU/U8Hn1fDXY064/XmdXCH61Ozo5vMplD9L5HUYyfjD0kzYim/tij4/ujxsOmme3XrWcRpXF4vXivuSIL7b/IBTn8TSvfQZE0F6ZC9Gzg21sq/4ZSYkU6qMkDgVGEG8gj1NqckVXEHKJ9I98QlYjuyEdjaEOjkuyngQ=
Received: from DS1P223CA0008.NAMP223.PROD.OUTLOOK.COM (2603:10b6:8:453::18) by
 DS0PR10MB6750.namprd10.prod.outlook.com (2603:10b6:8:133::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.7; Thu, 10 Sep 2026 18:05:14 +0000
Received: from DS1PEPF0001708F.namprd03.prod.outlook.com
 (2603:10b6:8:453:cafe::2d) by DS1P223CA0008.outlook.office365.com
 (2603:10b6:8:453::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 18:05:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 DS1PEPF0001708F.mail.protection.outlook.com (10.167.17.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 18:05:12 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 13:04:27 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 13:04:27 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 13:04:27 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AI4PIv2807678;
	Thu, 10 Sep 2026 13:04:26 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v9 0/2] Add support for hashing algorithms in TI DTHE V2
Date: Thu, 10 Sep 2026 23:34:21 +0530
Message-ID: <20260910180424.2131193-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0001708F:EE_|DS0PR10MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: 9008a5b2-476c-4c31-dd7e-08df0f660f76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|82310400026|1800799024|3023799007|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	FO9ApVWNv9/Raic45OQUVL5ZgQyAApXdKLjLEXL6m6ZDmUrnCTt4VvSxebLzxJWGKORDhH4Ni6THPyQjJE180BbnfYniQjODMeJjLoji+ah6ALliJbYswsqZPqtofWE78Dy0FzLUs9gowl+gs2T6FDnrpG3lH32bYAPBJ6yWlCL+Yz2VvWSp5O22t8bz12Ugu/O1HL9y+Q9T5DrKhqsJ4sPNh/04X00P7heRndeibYiG6QPW2ivZzQSy5u3DbRpYwN2oa6T5Iht+DuBgUITlu9XtjcdP+yHnnYmc+9hJ2Kxle1Kjdu7wUM/SB9VmBD0Jg8fHm2EcdY8EBkyGs8QwoAHkjchrh70YaejZTiG3g6PGc2VP/bY9j3pSpz9+gVJ0dHLPvbEVI188qedqoOUgFHYghUBF+6XDOH6SYszMd1qM+KL/dBASprRyXjtmqegUmMc5TrWpxAccohxxL45rspMytI4ops6FG/8owb1ZoUgTUTuIpeJ01yfZ4WCXCstd9C0C2vpj0fuRv18RucZLi7M+GdknI+jrCfmxqraH/J4A7ocQVXva0Tf/ULtkXehZ4W9sLdy5mCI1TbKY7AXmyn7hs8aT09SGUVgLM8TBwZ3I9TKHcGAwReYzd7dV2KsfzVNxUl8iqRMrvpxlK0mV1rUCQWt43v+mpxcooZdNGnY=
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(3023799007)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	AHQBS+391mTCEDMJKbyIeP8kopQAa21oFk2uIOmVaBhTWOEFEgltW/d0R3lKXkgGJiPZwKExnsbxL+q3XjdZpuBSHOHiOu4IzWJ7XX9VX6L0Wdhnj7cnNY7h28sEhnPUZV/yEPyZsQmJmeREtqlGH3AGdTTEliAaNtn32SBvJbVxiZkVfWgB82mkqexLWu8rFkMyKPv+D/SlQHp7NZeUdRpDC9/ejWqjHxPU+/NWUbbz8xZrwZEz+en4HVyvYZiaL42/PHiUofDg/+S3WHWncM0/r8A9MxPd/V3XGSjdnc+Jry+jGA47a4YExDJUtCWQEDfmpmdIj6kmyXCfbCaQ0epoDHxMS8JxLWk4xZqTD4R4hlCcpO+LfxllFwYf+bccOH0DFYwoFaDWmRy4wbHHk/BXzudeZ6jwbjOFjraCIk8hIqm8J7FXJ17hWUANU4jj
X-Exchange-RoutingPolicyChecked:
	MpX29T0bUhikCjgV/I9gUYWCBpTTYcVIPya9gxVuu/zn/vZf4XVAppQErJAUcJc17Ar3kAuynBKqlieOye8p18fncbuUIUC6ov2nwX1ubg8uZdU8zo3jM9isyjLLYIxNy3Yp2acFGjImwtJ5QEmU78jqfTju8X4KvmuNcSTFgrvcWbiFNFtaiCK1U9K/q8BfKHEY0tu7Q1aVqgCGJqHlrZLDIYXJ3PCiGF2fD/9Qz/5F2tdvVAcZYOLLevcawSU/1zFHdRMkRH1Sw9kVH4eBcfr6sN6j8ys83Mm89mH4KpYMDwW3XXLBj5Rt4me9GjiW6fwOM7o4oH9CxBo9bmh8GA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 18:05:12.9468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9008a5b2-476c-4c31-dd7e-08df0f660f76
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF0001708F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6750
X-Proofpoint-ORIG-GUID: 7X1xau_UGM-RooTqXvTFOhieyuJzX6xx
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMiBTYWx0ZWRfX4gG5QZM9q/OO
 cEKyVWOTjFY0hIC7wC5R2y8PpUo3caZp93jJ8NaAnOeRiqze2wWcTiwTVKNUboIMChDFwgTONa+
 nMsFsXs9aqRDqxnZTjsgxBY3jw2OqhQ=
X-Proofpoint-GUID: 7X1xau_UGM-RooTqXvTFOhieyuJzX6xx
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa2f15e cx=c_pps
 a=sh1HRyDNv5RGx04/W1QObA==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=NEAV23lmAAAA:8 a=EkVIMCltSqSwak4VvQUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMiBTYWx0ZWRfXyVT7gT79Mt80
 4foDIv4qzJOKkGAlFKk8TGQ/8x1cnSvet1InNdlicNIyWFCWJ5F/HaZ/rvzdEfKz1sj1p/ZGeLA
 bosA3Ednl3WOnnGZiLG0+A7BncO4mzRtk5/kvcxuIe6QZ/Vzg6zeWOoI3uJ8ScM/eiLjMjPc+3C
 BWGo+2H54huUVFXn5kDq77sO0IZ5z3EX3/y+ooBf3PfPovvRzJdtz1a9GxXuFulBzUTqgH57d+T
 qL8QKSGH4SIKLUvHBts6r17gUoAbTEE/NDpCKjR19fEgNcsXQW+JcN/Rqcgkdqc5IZ0t9jz/MdJ
 +NmgUFvzkjDdsYkvRMiD1HijiOc3vmK/6k9QhtaebERhSIbrXzPU7lHILT4XGBfi9kWujZhPrpF
 SoVs2JcQyyyitQZrOeRzLttTvvxG7cAgu/xFG6xRPTg0VukhKydL2C4TgyRRvNxf/BHxTh0UYnf
 CsgQKtWiN23k3MgHH5Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100222

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
[1]: [PATCH v7 0/2] Add support for Texas Instruments DTHEv2 Crypto
Engine
Link: https://lore.kernel.org/all/20250820092710.3510788-1-t-pratham@ti.com/

[2]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf

[3]: DTHEv2 kernel self-tests logs
Link: https://gist.github.com/Pratham-T/fd15b8e0ee815bcb420a60d451a0cf18

[4]: [PATCH v4 0/15] Fix several issues in DTHEv2 driver
Link: https://lore.kernel.org/all/20260910175619.2122149-1-t-pratham@ti.com/

Changelog:
v9:
 - Added overflow check on addition of lengths
v8: 
 - Minor fixes based on Sashiko comments on [4] and changes in [4]
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
 - Check for error in registration individualy for hash and aes
   driver algos.
 - Fixed comment style in dthev2-common.c
v2:
 - Completely revamped the driver to use the new CRYPTO_AHASH_BLOCK_ONLY
   framework for handling partial blocks and crypto_engine for queueing.
 - Added HMAC as well.

Link to previous versions:
v8: https://lore.kernel.org/all/20260910105014.1552521-1-t-pratham@ti.com/
v7: https://lore.kernel.org/all/20260827133542.619717-1-t-pratham@ti.com/
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
 drivers/crypto/ti/dthev2-common.h |   68 +-
 drivers/crypto/ti/dthev2-hash.c   | 1051 +++++++++++++++++++++++++++++
 6 files changed, 1156 insertions(+), 21 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

