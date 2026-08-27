Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4F14746A3;
	Thu, 27 Aug 2026 13:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787837124; cv=fail; b=mL12PWi1nyBkMEhr8VI+Zf6GqrwbtkkDUzfKP5GF9HpxaMNpUX1fd3y9P0f0hZDGVJO9k/3anUiL8y3SeTAaUrSP9NgvEBQCE0FeWVU8ITQAtdWrwZ6U1XSe2j0aWzSAjy+BL0qMJRSmRk7F16TSkNZ6LIrGqA2VSfBnKJwI+ag=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787837124; c=relaxed/simple;
	bh=t7lpdHFhtnjrxBj0Z1jDFKxQM+TiRlQNO9yhoOaqJUA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sv1F3T8p8rAO//2KNZfyna45YCFrxrTPion0r/ukuIDHho9hS1kmltbt4wra0RDyJHD2W24SBw9sPSNGFNQE8rKYxQc6q/sLNGQgc0Qycy2av8XECrfJTCb94CjA4Xo4ZIyBc546h59f+LTsb8yQC3thRB9Fh8Yeptt5EJmFMaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=b00oUEBy; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=F0WVFtDd; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="b00oUEBy";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="F0WVFtDd"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67RCAQVG2053452;
	Thu, 27 Aug 2026 08:24:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=8oIA32i6CXiO/
	UU+aG0FblRvFyv154B7lQREbtA3HX4=; b=b00oUEByRfU9XM1tlx6bmM6ISDN/5
	ZTxcfePHjhuaXnXjzzsUzQaDa31bjrmEnpljES1sIFZL3TS6AYFt812vOZS6bCWb
	KLLpiUDPrkN6tM+qpUkVyOIzNap5bsv5x2k/VmM83JvDJDwhPBYFhzzJPUK/yC9n
	VPbK5y2c95DcUfr1tW0W5nZYT3NfLYf2ijQ8Uhq+WJAua3Lilyin5m1Hu9QQerJ6
	OpXImWMzokiUodWMhnbZ9CtAm31rLZS/dFaMExpOOaUDihLQ0QB74dvpuPtDk5T4
	lKTDrhbCtZUoNlQatpwxyfK5a3CMq7ogEzccqU6/3TdtKiFnr/QBVlGBA==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011052.outbound.protection.outlook.com [52.101.57.52])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gad8saq3t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 08:24:13 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RrW19vZ/lruv1doS6ARTVqzLYXrZPOC9OfB67wfeBd4vp3MBdH4GF6cXLD0JSYq5++EkgUKDbduH1S30EUyW532qqBE/IFIp0tHlAWgrQ904p65IdDGZSeDlb97pC9CRUy+KT3vCxoyqhjiPzSZ5R/aUVi6LbFUq0pWBLUsJVweNCCXugo80y43bwaRWh6r/EmKBbkySw2Eyhgrw4ROICcE4H+2j5XSVlSAEJ0nl7DSoY2MaOteWrRemR+XnFoMxpkrcVQEisBX88xNKVnEAmsKvTlbf9w1LEFstHdjIuVA3F1WSurNbzm2PpWB8b0GkExPD3X8ZymADqggJCBaJOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oIA32i6CXiO/UU+aG0FblRvFyv154B7lQREbtA3HX4=;
 b=e/2eFRoWKlTPAudLKGL+277S0mYvUUXQDkqDKinc3cCzFFxx0R8sr83hlAImMlje24y5IUNv7RV2nKQxQurocTALV59nkrs0J9rPexfOYx2qZbBa5MhGDY0CpkK3i56yBTw7ejYuJKGBqFWv4k8th64x2XhFuKUMS6npiAwD2zzBBdnJ3xp2V24HR+px1qsAxie7WB+KLHNzhVFsGcw16qzaFQaVamQvPezejXieSbZR6efIRNuR24KuCRaiGhlQkMGWoWf90skCUox6NdSX+wmVECxeokogaWSbD2c0CY39/CxBvW+bb1BzXyYFwyTr1jAjvhimbRLip24jcfLcsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oIA32i6CXiO/UU+aG0FblRvFyv154B7lQREbtA3HX4=;
 b=F0WVFtDdMDx0cERHUFXClE6izIE+fm3yPNjjRnYMh9riekm9IakB8hLvFiFB9wU0rsVA1lvwE37+sSSOqur4jzvWpBEwCl/qTC8LhcdCGGARcHcYXLlXnW0nT4MuOGiOexhO0C2IdJs+LjROq4FxFMYyJdJFLjuxIMhJbJsKbao=
Received: from CH2PR07CA0044.namprd07.prod.outlook.com (2603:10b6:610:5b::18)
 by CH0PR10MB7461.namprd10.prod.outlook.com (2603:10b6:610:18d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Thu, 27 Aug
 2026 13:24:10 +0000
Received: from CH1PEPF0000AD7F.namprd04.prod.outlook.com
 (2603:10b6:610:5b:cafe::9d) by CH2PR07CA0044.outlook.office365.com
 (2603:10b6:610:5b::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 13:24:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CH1PEPF0000AD7F.mail.protection.outlook.com (10.167.244.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 13:24:07 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:30 -0500
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 08:23:30 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 08:23:30 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RDNT1H1930687;
	Thu, 27 Aug 2026 08:23:30 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v2 0/7] Fix several issues in DTHEv2 driver
Date: Thu, 27 Aug 2026 18:53:11 +0530
Message-ID: <20260827132318.613876-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7F:EE_|CH0PR10MB7461:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ff85f2c-c5eb-470d-f50d-08df043e78ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|36860700016|1800799024|82310400026|10067099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	LGttcMdx3mEtmbBrKywU08t4dyGfl/fGDjKDAu8WtRxlTnwjsXTSmNIs8cUemk10fxmSniCMrynj4ZEy7BCc37qR+82P6KYT6hoLmA8pNr8/10vseCLAVFzJP0UAYSFO1MsHnLcxClTpGyXRT2HYxbkbd+bqrWxVExnMQvEt4Y4bHucSeIFJyHtnWuxXnsCH1XCCuOQuDMLXKz5S3SeEHGPWvu11mCe4o2n0WEd0JKLPVnWL7O0smjWfCyq/nF9zpv6YYhjeB9H4yKkDOU2OmrqFudTKx26Z+SoH+THxuUTpFOiTeIGZ2Aez9DktFEOCYCNBBqofosvR6SWQzm8lZOU8nZcxVpxVdvbhmWZ+Hyn1Pa9WYv1M1saTT2tvaPvHCQQ8kFu1OvCjpMBvK/RphM/TEFtnQTb55KnNPLckmg44amLwUmBCPRtyB3cdig5FSneak2WqQIPU5kMZT3jGqou2n6FQkMU5oUpB04+bggasS7/sYPIp4OH4ktn/1HE5ayDLoy6ttbTQVs6bM4yCtE+r6c2KPlANAmDTiYilMyZAXwvMU5hMRc9IAvumvOVjTZWVmNxpES6qbu3+FP/oN9FB4YWYSOmAXLaaV9NgCSlYhEdSuHal0BkJUsiEuwbyPpqads2BvgHXOt269Jj2RA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(36860700016)(1800799024)(82310400026)(10067099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	zx0ajUe/+vtBaJ1UWou6PGJIaqLBbZ0LjZvIUTZvDxMZyqNJQBFn5nMqVNy8ItTd/wpcpSqeHLxCFo2aoHrCcTF2q6rhPUq+wRtxoYZDqPb4Y11DucJwgrjKhUyEgDrPxLUPpvRrbJGOfm/lFB4shrFcjl57boSFC6xUwOrbBDS4/vzS4A1IaN5ifOqgo95Np0mlG+SmVYLq1UXMvrihEc/EGCfNQHz0IIBInqvdnVxZ6AGfHxppChuwNsvDyqvsG+kDNMK9pWNkBUBH+CLkKMkOk6XXVrEKtrHQ5Q/CbHsbtxj35GTjAAwMyIj3i+41XSVVUZKyG3/y+tJqVZ0lrylCPBAXgfbCSZWPpAvdiUa/y/Ag3gToAZrIMqrKY4k5V5hge+N/WoRUkAtqlTxA+wtEIQ2mJ3MFuSAkqY0c6Bg2Ewi+ov6t6ENzZ7QZQyHb
X-Exchange-RoutingPolicyChecked:
	VVkt4D8lYuUeeWFsTWzQM4t5hVqBeRvhVAc4zCA7spEIAJrQV2p84pGrkLrjm+jwffCUui+q8iwUvKmzdWCYxvhH6mYMpbYSMrzpKOfu6fY1k/Z/9Y4yxCg6hiH/6Q8rRfqgNctCyWa5/tmWL0W+Du4v3XT3lY1S2DomIhBz0wl4Zt1kHWCojfBeOnRD7H00Q4dqMQWQVlvpNhjExefqqh6e5Zov06L9jQyg9gbjFgfEuM1y0fNPaTugQ1OUaRlJMKcLZzE9EC45v1BBKzSb4XN3UF4x/57YTABwzW4jvO43loEztkjcFFf1rzHo6OPAy2XiKpnNv31gJ1nyoZ6fEQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 13:24:07.2230
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff85f2c-c5eb-470d-f50d-08df043e78ed
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7461
X-Proofpoint-ORIG-GUID: 0wxKygLHPQ7Gotg1vnxH2WTr4ADGVw9I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfXxWFAB0IWYn0Y
 JbobpWUh+zO64M1T2I38BPvKsTz+Nrv/eCNgnV/V6DFtn9fOfm9aX1OXE7Oy0RtvVx8+Xlg/LvG
 6bCuDoIJrU6WM6jLHl9fwZitK5vG3rGpY3jqbqH400s9mS71y2RqqWk0CEHwpftfUEfpgHTewAj
 84yfRot/QSKFWU0KBcoJNeOOCMO3oNTOwd3pamrl2SFh54eiW+VftEuYc1bz1OaybYZJfMPz0IA
 pEEMwJPTrTMO+s5mTq6mqrxvS1xsv9+2D3ZZtOMJ8iHqfH3M/s9KenVxg6zEZe3Iv51CZYMhSS9
 z26cW0GLIql/gl0j9olVoSlOgzyIhdwUXEyrqJwHuDDF0foOI0rPni9BPVfQcvEWQK1t81rpl5m
 ZEP3lrTMPj0gfcMW/Ksp8432BgAaa8C9EczDX9zcqNVOswMPEIrQnRdl/Xi54eJEgWTgRbJSyCM
 +IxxvBzQ0ewb3CoJfaA==
X-Authority-Analysis: v=2.4 cv=TJ11jVla c=1 sm=1 tr=0 ts=6a903a7d cx=c_pps
 a=TarwAQ2eZTQc/qcP07j9+g==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=8F2zfpSVp_VeWh-fdiAA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: 0wxKygLHPQ7Gotg1vnxH2WTr4ADGVw9I
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDExMiBTYWx0ZWRfX99LvoSAmhpVO
 yCnlSrqAADR1ROtghg5wXAoU3G/yIfprBSRrkJkvcBp0XamhC+5kYU8SJQvTmmyuGu3AA9SZ/AU
 8IVwqz+aF0FTvpf3gFzlSHXshcozkVQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_05,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 impostorscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270112

This series fixes a handful of independent and mostly benign till now
issues in the DTHEv2 driver which were flagged by bots and AI agents.
Except for the fourth patch in this series which was found in an
internal testing.

The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
some pre-existing issues which needed to be fixed.
https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com

One of the issues had already been flagged by kernel test bot and a fix
sent on the list by Mert:
https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
I included this patch in this series with minor edits. Then the Sashiko
review page for this had more comments:
https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com
Overall this resulted in a bunch of fixes patches which would have
deviated the DTHEv2 hashing driver series had they been included with
it. So I clubbed them together in a new patch series which is this.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
Changelog:
v2:
 - Fixes based on Sashiko comments

Link to previous versions:
v1: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/
---

Mert Seftali (1):
  crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()

T Pratham (6):
  crypto: ti - Fix potential deadlock bug in DTHEv2
  crypto: ti - Fix potential memory corruption on highmem pages
  crypto: ti - Trim scatterlists to correct length in AES
  crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD

 drivers/crypto/ti/dthev2-aes.c    | 184 ++++++++++++++++++------------
 drivers/crypto/ti/dthev2-common.c |  32 +++++-
 drivers/crypto/ti/dthev2-common.h |   7 +-
 3 files changed, 140 insertions(+), 83 deletions(-)

-- 
2.34.1

