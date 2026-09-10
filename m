Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29FB3DCD95;
	Thu, 10 Sep 2026 10:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789037480; cv=fail; b=Sd6OciiEkZFcV9rygyjfP100P5VnO/sKlTFrSNHcIx1wTyv56b8XW6TT68ZBMmS7Pns+DrTLUXN3fBAukNJu5s6zcU4Vna71oVpUJlPQUor/Uah08aaF07sZPM0D4JyXYd12vEfyFlmbGzgBV3UvOc1OoWEVUg9jnmpPPEGEe7s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789037480; c=relaxed/simple;
	bh=PUoWAy2RFQ+98uMnLazzgy19wgKhGAuU26t8uwukb1M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MHFC+jgQmCwCJkBdAaReysvwe/NdqSjlE2WC687WUnlRk6Yhsci8LYfQzH2VBMN6ZRkCCwUOl76QemcO26/71yyuq2u5DZSiQ0dg53W/2x6WqstmBkgx7Qtv+pdSZcJwPTzhGUZhJTIU1q8Slr+w6siRveUw/Gl1BA1gE3xkNNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=hfCPlEFE; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=PkY8xuky; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="hfCPlEFE";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="PkY8xuky"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A8oGf9712608;
	Thu, 10 Sep 2026 05:51:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=m9u0VPNnqnttd
	IlSl/yjQpV9L7dOZYLYW8AsaawYriE=; b=hfCPlEFENeUmMlf/v84gKqxycojj1
	L42+am4KJClDJqzSbMkKxlcHJbb0S31w916UjJXKK6kpT+g/tkYs1Ju3Zlh3pcC5
	9NUgnn+mJBVwkGDy6+DA7EIGkrREy1yIaH7j8z/qEXx3psgEe4pbOa4lW1Vjg61I
	YOwMLMjRt2nxHkLuc4P35RKRdHJfv6JwmRkMPdpWRoht+xuasLQdB0Ei902T+3YQ
	QvtoqY6zfEU/nGPFAaZ1VTsw4aHpJv49rCF9r/ky5kPhNCaQpy8nsTm9SsiCJ0ks
	qBHjviic6fFPMQHUm0PPZb8C/Jzhc/0HDCUwGCRTrEwrGDQtvLIk0IHFg==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013061.outbound.protection.outlook.com [40.93.201.61])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgcpt1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:51:10 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XV5eA/25nDJoS/OBWcZeLhvjZ6zknX6MyRgsjfHDejWYZ2vsci0EaCFaOyq5ptSpVow6WrupFGHlvpA92tjumTiSNvrlBhg4MK+9c6hddQvPsgmJEvOmMHQ/N/YkfpPV0+ogxL2qmAJCvSKwNu6+lZekBmdjbFmNj+T7xbjdT0V6xQv7A75u4rziTqLav0Qm0BDRDf1D/lOX2njwNGckCG74CaEiJvWb0kyYyKGg2lQwn7yJSotb7mOlN9f8VF1a6zoFgYcCjXtq0vKgJ/YFZ4bZ08cyjS7bww4l4VxrfnZp2dTwlumKT9H2ad8o7oJMEThlIAKymqjXa5n8v6EegQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9u0VPNnqnttdIlSl/yjQpV9L7dOZYLYW8AsaawYriE=;
 b=JthchP2+dcbCw2EdAwpDCeLtOUMDpVBERc5YtttaFUTwwXuP0lxDLhU4FcXvgEgAOxfTCPoyWX9W1aW7Q2UVOPMTROXCzEI9XNMtsAwHRlx0kGSYQfl37u61CAoquL3HOve7eNTI0JCzC9AuxWjH9KyQHRb67EApaf5Re6YRKgBimHR2VJZ3IIppq9HVKiuzA0pt2AWsBBudyLwIEFOy+Bnr/02Ni9eRsA/1MrzEMxlXJ5/xSA/ntvquRNMDMQ82degjcaqmUkBDMO/5v/JSPEu2UWoHRx9KcLZ0zrBvF/TJiFwH0GgxxrrG67WLOEPAGiUxNZ6aOCqhDW5se4K60w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9u0VPNnqnttdIlSl/yjQpV9L7dOZYLYW8AsaawYriE=;
 b=PkY8xukyAS7AmmMDJYfUlaOZrVkcFerjs2hR5a6WzBb+ZlQI3bcwGpmZ2BzfXOtmNQivJ3+GasGpoWQb2zdgE7hyTpaygeAtWdC0V8Y9igCY5L86AWkZWWe/k8BaN/9DJU5OUyb+drdFBPED9bmBOu6xF+zdcCyjGQHcKE2ZMF4=
Received: from BL1PR13CA0158.namprd13.prod.outlook.com (2603:10b6:208:2bd::13)
 by MW5PR10MB5761.namprd10.prod.outlook.com (2603:10b6:303:19a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.4; Thu, 10 Sep
 2026 10:51:05 +0000
Received: from BN2PEPF0000A891.namprd04.prod.outlook.com
 (2603:10b6:208:2bd:cafe::ac) by BL1PR13CA0158.outlook.office365.com
 (2603:10b6:208:2bd::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.6 via Frontend Transport; Thu, 10
 Sep 2026 10:51:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BN2PEPF0000A891.mail.protection.outlook.com (10.167.248.183) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:51:03 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:50:19 -0500
Received: from DFLE206.ent.ti.com (10.64.6.64) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:50:19 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:50:19 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAoHT92188730;
	Thu, 10 Sep 2026 05:50:18 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v8 0/2] Add support for hashing algorithms in TI DTHE V2
Date: Thu, 10 Sep 2026 16:20:12 +0530
Message-ID: <20260910105014.1552521-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000A891:EE_|MW5PR10MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 84ee2974-be6b-45e4-6b18-08df0f2968da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|82310400026|1800799024|10067099003|18002099003|56012099006|3023799007|13003099007;
X-Microsoft-Antispam-Message-Info:
	P4t7KJ92/BP2GLFqc1W8gxuIw32nZAMCnYwg8T3bK1DwpoSzUw3xluFRdrbQ81VhUjqNcM6zjAyHr83aascu8XHYowQQHhHQAbXBhlMYTO06krJjGUCbypLYqnbAAOmG+DCb0Ycew6ZWnVeZNveN+dHw/MWycPgviS+vjhcDmSR42PLQRJiSGiS22d3C3XGAM/VBcq6BGgSjgDoL4iiDuzEQRJ1EFeZ/wNH7W+2HvlkNAd5RmKm5XeqhtLWCT/5zMDYZMiz34QNj2DGS9mBLuGzZAOdLmA/PSS8eWjb7CCzFCqAAfdO8m5tGHDr3x/fCJVfp2ToAixAY+Cc1sGIzwiqknGAm6AYOsE6/kqp0dGedRcrRbaeqJR1snGDiv/ss8KxCNlrUU6VhdbpnvPRL8Ejd91roWsKg4CWDzjJm+5ACKDWIQ1M+p7eJEaPC+QT8cFL3PsdVkklTFhIRoBRyZc2LEP9DI77ZyIKJc+KEuxzkqBFWHHKtfGoXqRyILm0KwPUhxYF4Eo8jMVDJZEJTqDb9rxrK/xjEruUnTNRWsqgImIrLvXGYYtD9i7nIOq0i0fCyz542xs5OQAIvgYCr6qoikTnXVwsapB8MjWZgazJMgJxCURg1eEw/ZC/quSfVPEkQK/eGOvIK+z6ig6KMkEOrILhCEGveNLeJPbysqrI=
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(82310400026)(1800799024)(10067099003)(18002099003)(56012099006)(3023799007)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mxGEqBYD/tMxScdg5UuIlgFvcz/4Cy0Z9bBkspesg7Oq1y4LRr3ARutYqJ7QkS2uZsmY374JaaMbIPCRP48F0G5uBqxkvRB7+rn1FtG0oQrIF3S1HdsdGxLaFXA712YTD06E76duFL7pauKydnO2V2Qz9UjVjBjTrpmpjLOOMb0m1vt5L5omyD66jnbYT33Xe+9MFugHLQXjDk/ktfr7iLloPkB6/YSQrde1RVahOPlXCQ9McgQZWE8x+21NydA81vMEHThGIj55TKuzxKrGnEplhXcJlrTjOosomYtn3b1bqKEGV2fARrZ60+67OU/IIvqxqtd2FWj4cQlNQAf3eNXSl0FSFluan3rYdwx0rjfRBEQfQPz9ebuKkk9045z2WO2bl9aeo4SrU0bhjvH8yjBkpL6EWYWXbg36II+6cdpyB2Ogr5SxZ3PRsxeZioIh
X-Exchange-RoutingPolicyChecked:
	J6nqSu86r3IGKRVTkM0LQMMkvTJ9o0vakROfLDKofxj6zgPtzGvxPatLEcqG1BBE6086FtxgPUTKPudgjnNMpEjWAPkomjgNOTYITRS1j8yycmjK+uutvzeTnFULGdupv+bM2pUEeZEnuAP91wvU20Xceqdu4d0r4EHj2/H28S3ig4VEXZLCjppgs1zV2a8rJSx9o8L2g5B6oroNTGt9e8pc9Qw/8hstqZdsLp+tO/oYnLtlzCABWfVqLP4H+o6jLEu0HKLAmGZLEOAjDAo7WOST1mQ51slQf3DEG2QX6bhOll29WQSA2o0yKBjKPvuGqtqNAog56DGprBUgnE4ZAA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:51:03.5888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84ee2974-be6b-45e4-6b18-08df0f2968da
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000A891.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5761
X-Proofpoint-ORIG-GUID: jqfMkN0ARUsHENdG9y1s55M26Zyi8cE0
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNiBTYWx0ZWRfX0Zd6LHZgxPC/
 eAKlsC3sEKhgQ5FFUuH6l6Z/itpIeqFNvTVaQEg4gcM23Gnb+JQaUqVMnzwyq7cmzL8vUa+KzAw
 k3kAHWwfH+6cG+Ien/n7npAT3P1G9SE=
X-Proofpoint-GUID: jqfMkN0ARUsHENdG9y1s55M26Zyi8cE0
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa28b9e cx=c_pps
 a=fvoc8Rb8ruZSznP819E46A==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=NEAV23lmAAAA:8 a=EkVIMCltSqSwak4VvQUA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNiBTYWx0ZWRfX1qFdYYqAIBVI
 Eep0RNUYi/euunJETBgRs0OoXz3W+52uRHzcWurULT160SFk/CALMRluuhsM9AG9L6DTUWj5a+9
 mnT+T8SAYE5JQbnsX0RHfOdpEsGj7Bn4/42o3FlamMIzWgSAol3YudbMjnAPTST+lVWKsK4SI7x
 SiU9vR+867ObryxIvPrf7Kh6clW8TJa77Q0GniwfGwOJR6yVkInNboPiZP7E1PpCbkkDUJ7lOpL
 s2Bq3nw/DL1J1/VQczneSgYkH93q5VhQT/TvDpVp9xDBPLMN3X8NnShTq63KVHNkiGyR1IIn6Tg
 zkePaA4hi8m9VgTxPAczPWze5A3DiRWEomCnXBfiy+Pd4G3eE9JPe313OwHD7dRV6aSpPP0Un4m
 woTaYG41G8fkHsPpi80+elaj1EKu/7wBnrb1Nf+rxVykBWteQ4S4+ayqiGE0siqRPcCssES3Fqf
 UpAy4e9tWqaJO2WYCdQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100126

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

[4]: [PATCH v3 0/12] Fix several issues in DTHEv2 driver
Link: https://lore.kernel.org/all/20260910104202.1537226-1-t-pratham@ti.com/

Changelog:
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
 - Check for error in registration individualy for hash and aes driver
   algos.
 - Fixed comment style in dthev2-common.c
v2:
 - Completely revamped the driver to use the new CRYPTO_AHASH_BLOCK_ONLY
   framework for handling partial blocks and crypto_engine for queueing.
 - Added HMAC as well.

Link to previous versions:
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
 drivers/crypto/ti/dthev2-hash.c   | 1047 +++++++++++++++++++++++++++++
 6 files changed, 1152 insertions(+), 21 deletions(-)
 create mode 100644 drivers/crypto/ti/dthev2-hash.c

-- 
2.34.1

