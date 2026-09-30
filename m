Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD954DA9DC;
	Wed, 30 Sep 2026 12:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790773193; cv=fail; b=S2z5FLuw6yBM8+nf7YQAnexp3noIjeFTQ7pqhbNPtMepI4jLqp7ssGGCH25r0g4tRuI7CZz8Q6gqbWAExBoFURLQbzKHv7xeI1aC2/qpBR8EqPPIPkTZDz07TZxqadtyL0Nf0RaqJEfKFABmdbGoh6KHssPdfv8K+PVEViaFA7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790773193; c=relaxed/simple;
	bh=mBIXRK/uy+++K09H6uXKzMb6EznCWwLQrxUZMw7ao5k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A9zAfsyHs5NFlgp3wHpx1VKyHYOKNQcYBxu3AQtfdTVdhfYE8L6u/ncGTtpEWnZUyiRaKhVm6Gi0ycWnYqpgrfYMUhg5EgR2gUPgqqODG818fMiqNAMcEwFsH17MXS5TzEbcRTSVb7yOql3UAmakR9zTFybV3lpkgCEnutYFv5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Kvq0pN/k; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=WPD5vJki; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Kvq0pN/k";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="WPD5vJki"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68UB5ePD2989907;
	Wed, 30 Sep 2026 07:59:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=nO6u9xPWyqDOl
	pMc4cAUc7AAt1HNqrIWc9o3+qL5P+E=; b=Kvq0pN/kb56TPmdMdmS3BwQSYG83h
	qgQeZagp/qHECfAm3xnwhc1GxUW2PXl6W8YFQRtXUu3vqQWxtkYTr+ob3A2+J5Bo
	a6M1HBxsedLcm4FlQQUNRh4iNqtJauVzq3gCQwTAcf7Ea2Z79a3yviPcdNJk2yK3
	+tvsp7McY+i2ujMn4tqKByMWif97J2yjWvHgkJl0MvJO57Q99fjwoA2TOGh+oVuD
	OBwqmaESAZQ64kYwuOhNdSN9YnaJjGeYAJAhR1SBQRQGo1wU9XY3tKNrGZ+k66L0
	fbI5OuEv0XU8lcSQ3ar1y7W+eq5JW5oG7yVUC87/On1K+w5CBWnx29nIw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012043.outbound.protection.outlook.com [52.101.43.43])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h10t1rpx5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 30 Sep 2026 07:59:41 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qLpFWCqD8RYppAU/hk5h0IxctkKrNXjGG7yHDU7O4N3RxK4vIft232oH8X9HIRmrW9SDovRc4T74oLrKbYr4wBxzSWc2VYyfrWVacOVDCwT7tm+R3DaHMJdGFXe31+qfKBFp+2AzLt8Nakkai1bDr8gDU7/m9wI/UBd5D5lYVW8rVWP+M/dO2P8W12r24NN9mQtSYUrABVSu86zXXp0O/ciRM44ucwVGV91Z9amOlus3B0fgzx7smF7v2KZrqHUpeEACI7qFfYN6ps4MUVgIXzwSPur7qHo3lpewG5tDjkJ9Fe1l9Go/2JvQckAlu9FCPny5ouchtu3RSMJUwFCYAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nO6u9xPWyqDOlpMc4cAUc7AAt1HNqrIWc9o3+qL5P+E=;
 b=EFJ8ZliguNy+2rfbuZ3ENd1v8DHspjJSbjxooMIQ7TCk/z4IsrG/ZDRe1Durtps+TWRyWu+Kew00wGyM9JPfGvQhATsBtlXvp8ile65gkuBYAJNvAaWVGhQ/ZAYou02j6vd2Aeq/JxPhYJQjyzJsL4R6iSc7EZGVAjeeVwQWqmn9B32p0Io6VRY3ogUe0LCRkRtelU/aVixBRDt3JvavwDbX5dTXQGZvl6KmJx2hz3gD+CIdztj+5VJ6MxGC9wTieOFhvBKiTPS0u03oDHokshPuoS1WWL4mXSmL/BCQ6p8NzY/pt9Duvv/+V1gUzkBBzL4Jvi/W6+ybtSyfIO8Vag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nO6u9xPWyqDOlpMc4cAUc7AAt1HNqrIWc9o3+qL5P+E=;
 b=WPD5vJkivey2GYhIEb+Jn08NJXheR+fiKDyD6pMzF1me/3CC/vwxeBr4laR8KYnn5p8Jcd2T7QZaN149f3hdBi7Tr2dlMZ4bJqArp/P1SynrnP7pzJjH9auH09vLLIWTVB7ysIxXufsiELB5h3ziS78+S2k3/1B8ccpb/4DGFT0=
Received: from MN2PR15CA0059.namprd15.prod.outlook.com (2603:10b6:208:237::28)
 by IA4PR10MB8756.namprd10.prod.outlook.com (2603:10b6:208:562::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.7; Wed, 30 Sep
 2026 12:59:37 +0000
Received: from BN7PEPF000000AB.namprd05.prod.outlook.com
 (2603:10b6:208:237:cafe::e) by MN2PR15CA0059.outlook.office365.com
 (2603:10b6:208:237::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.16 via Frontend Transport; Wed,
 30 Sep 2026 12:59:36 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BN7PEPF000000AB.mail.protection.outlook.com (10.167.245.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Wed, 30 Sep 2026 12:59:35 +0000
Received: from DLEE211.ent.ti.com (157.170.170.113) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:07 -0500
Received: from DLEE212.ent.ti.com (157.170.170.114) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 30 Sep
 2026 07:59:07 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 30 Sep 2026 07:59:07 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68UCx5OK3153618;
	Wed, 30 Sep 2026 07:59:06 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, "Vishal Mahaveer" <vishalm@ti.com>
Subject: [PATCH v7 00/15] Fix several issues in DTHEv2 driver
Date: Wed, 30 Sep 2026 18:28:44 +0530
Message-ID: <20260930125859.1749849-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BN7PEPF000000AB:EE_|IA4PR10MB8756:EE_
X-MS-Office365-Filtering-Correlation-Id: 81e4db1c-07f4-475a-901c-08df1ef2ad7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|82310400026|23010399003|36860700016|13003099007|56012099006|10067099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Vktu0FDmlzVUptTv8ywV16IoPCt3ZusB7riGYx4zf3CL9ZhFPq30fxdn2LXM6XXNx//vUwtaXqOkhA0gxZxljfX+d097zYjXZdzteYtAaeGGlRl9e6sTVVWbCLDeZaKkO14wl6oYz1ktj2ZoRN9wLUfoWeCdrqZKB4NhkjrS+crHSdnvlE6bdd5qaye4hEZ+wv776+HX38qm2gTNzIhFPOVTAYnfenlDkf6GkhlBn34ClwSkK8HJcZa8oHIlkLdCaoMTlsf2K0QbF8GL3iBtzdApahYa52vqtBVmVRwJ4GMlJaL268NLsgaqAg3a5JS7lsN98Q/nkzcrz72dNrDtzXzS1q0K1guFQsSDPp5kJPmzwInFPHJntL/XiUT5froxbMyhLHC+oix4KrXRZaGQfGjYOvZPzxKh6Q7eZDlMzNtJcGF1UhAOAJ3WaBjvfSQdMcQkY2GbCrsRZtfG3fNHKF4by0vEOCnHWy7Dx1wip+RIn7kcNXtEPsaOu81guVJxWbMpOaxPacChVm0O5BWq6EoiLCVY8lCKYt5yClLcTVh7IRQ5dDe/iIegbAEJU1vbCFI0Q+zmqbR49fEVHWbmpBkXHJ6sIgwMF7XbU+EN9eg6Oem+VpxlRhYSy9VhfaVLEzaihqdyORy7l7hKmliwUg==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(82310400026)(23010399003)(36860700016)(13003099007)(56012099006)(10067099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PhZyWOn1qRXi6TqtDPX7p1oSakRa6huk5cy/NM1kSQcR0z2O4bIZc7Elrt0Hvh89LEzh4ChFa3RF4AemtOt5n2L1pU0T/HRj7mndWRSF5VgX6cJkaWBdlrTEM8xwVztcNnmS28BpHrxHlaYdK6o8Zs9M1gcYUaV3SmZVTujIQi4ZzbPXtiSxup8wRuWlPEi8ztrpmp4e7s9xIRFcDzBgsfk2KrPzJuWxB9nbpg5SOfqVoFk+UwttTCDHq1Qx5XZv4a8czHajY5gKlpCFSIVxtXenRuwwWjkVn+8rjtF5dxzBWxATlIH7k4M3JZFUJfV41pbqeuHDIHsR66xfUQe8JA8nNSMGJTQi6UHMcM/RmymEsPKB+bbas3PXole7JLdsB/aSgqd9NqeM0DeMYrgMaZ1ihbFaWX10rDismxNjSO3vk+f1R2XWQq+H91YTDnPi
X-Exchange-RoutingPolicyChecked:
	c/TV3CefOC7/jpUH73usbP95SEYU5BQ1cM8jLLctYifLXR2MCuwTCs6LMCOwQOCTQedaDmSjVYgRj7OlzFQFrthrEs4CC3lv5GRJXmPJJXqaReTNNSCsZv+WxDkP0tkT2PP01KFzvPXtL33EUAbREfujmhPUSzrhL8hMR0FA4Fe2hMuC1Kh8lnkb4T2ZJBksCtk/7i9uiFxsYS4tIjMc35CCUVfOrwCfp0fYGwfrImGVs7+ApeBsf5yt8f15S1OyyeFb/LNHVzSbjEbCdj1vLOS/Br9/901eussty88YGe8/CoAKnReyzwJC9O0RXjeiaQiTvesKSbtdtLwWhio9gA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 12:59:35.0322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81e4db1c-07f4-475a-901c-08df1ef2ad7c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN7PEPF000000AB.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8756
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX2cpjtOzXytR0
 wWvzAsB4LaAT9xblPngESp2RS4Jn25XP5pBC6NSir6O1hqoH8pf6qoMYvu3DD+sXpn5/Nc4Czut
 REnxLCz3VtbZd1poMXc1mkN/At0y2b4=
X-Proofpoint-ORIG-GUID: 4JUjrkN_5SVkDJq_KyLEbw9zfVRVHx5r
X-Authority-Analysis: v=2.4 cv=C7R8WgP+ c=1 sm=1 tr=0 ts=6abd07bd cx=c_pps
 a=qH/fS2hzlQnCJHG7LpbWtA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=UxwojoEslEplIN4H4qAA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-GUID: 4JUjrkN_5SVkDJq_KyLEbw9zfVRVHx5r
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTMwMDA1MSBTYWx0ZWRfX9FP8dSGUtMho
 Oq+YnGERApDpvlms97rjQbz9vtfm/4PiJXOCEEfmri5+R8uDp/Sf1plT62ef49z4DlLnlHgL8Kg
 l+Y/EZU85fcxY6SA59q9e/yKqthgoobwdgUncP/NuzLxbfCrJIspLPtQ1zFivX0YxKvAgJh81mb
 qtcIONKEnaOFXPUSLpR05RGYaRg8nmZ+ZjgmAF1f2c0PaftBQOj8jjtZHqcH5TukXzErl4+F8xv
 HkquZzQ9Mn+ETPflVAdCjYwKPTIXIgxXw6TPiES6dgISbShvtJFMhdzujPpi94Y8jeA5DUFlYGI
 hdLpKiCBP2/9w7hSij0zJLDll5GrY7rv8r2GcIeI/gRPB+LWlM/7g5+UPr2QfG9dC4a7WfgQgrv
 UomdB2Fcf1K4tzC8+X0LazkuFHkJe/tYlDte/k3/V53exsDhjFgPD+O88dNyU4TIBe0bs+o4oNF
 XBSRy+2FT255RlgRyGg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-30_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 spamscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609300051

This series fixes a handful of independent and mostly benign till now
issues in the DTHEv2 driver which were flagged by bots and AI agents.
Except for the fifth patch in this series which was found in an
internal testing.

The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
some pre-existing issues which needed to be fixed [1].

One of the issues had already been flagged by kernel test bot and a fix
sent on the list by Mert [2].

I included this patch in this series with minor edits. Then the Sashiko
review page for [2] had more comments [3]

Overall this resulted in a bunch of fixes patches which would have
deviated the DTHEv2 hashing driver series had they been included with
it. So I clubbed them together in a new patch series which is this.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
Links:
[1]: https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
[2]: https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
[3]: https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com

Changelog:
v7:
 - Fixes based on Sashiko comments (added locking around
   dthe_put_drvdata)
v6:
 - Fixes based on Sashiko comments (waitqueue -> completion; DMA
   alignment for cache coherency)
v5:
 - Fix spinlock inconsistency patch
v4:
 - Fixes based on Sashiko comments
v3:
 - Fixes based on Sashiko comments
 - Some reordering of patches
v2:
 - Fixes based on Sashiko comments

Link to previous versions:
v6: https://lore.kernel.org/all/20260930112533.1593952-1-t-pratham@ti.com/
v5: https://lore.kernel.org/all/20260918102245.2784000-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20260910175619.2122149-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20260910104202.1537226-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260827132318.613876-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/
---

Mert Seftali (1):
  crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()

T Pratham (14):
  crypto: ti - Fix spinlock inconsistency in DTHEv2
  crypto: ti - Fix potential memory corruption on highmem pages
  crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
  crypto: ti - Trim scatterlists to correct length in AES
  crypto: ti - Align buffers to cacheline for DMA
  crypto: ti - Separate padding buffer for src and dst
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
  crypto: ti - Terminate DMA on all error paths in AES to clear
    descriptors
  crypto: ti - Terminate DMA on all error paths in AEAD to clear
    descriptors
  crypto: ti - Do AEAD software fallback on only ENOMEM
  crypto: ti - Correct AEAD tag operations against dma cache
    invalidation
  crypto: ti - Change lengths in AES to u64 to avoid potential overflows
  crypto: ti - Change lengths in AEAD to u64 to avoid potential
    overflows

 drivers/crypto/ti/dthev2-aes.c    | 368 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  57 ++++-
 drivers/crypto/ti/dthev2-common.h |  67 +++++-
 3 files changed, 338 insertions(+), 154 deletions(-)

-- 
2.34.1

