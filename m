Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08284E36E7;
	Fri, 18 Sep 2026 10:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727027; cv=fail; b=cb2x/4Nruj0B2yL6NfNeRgz5DOQTpNSGVowgjoR2hd1OzS9BBBqfCeOX7PD+7H7opTCn+Roe7j9bDD/KlFzgr1uC1k5qWtYV7c/8bOWxqQ5VGLokC78x3dQfPBZl+AC1yg4khaQCmmO9RvxROeRLuTVnV+1xs/b8uED0RpMZz0E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727027; c=relaxed/simple;
	bh=rUQPLJgq5f6iNfFebMclARF2zm2Blsr/z89w15P1jeU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=l96Cd6sZ7Mmm8T2n2up+2odlGAWzhj7pFfq7y7YaubNOBC/5vF48qs3KbsKYu8ksHSpL/YJDBL0AXSJDCHNDlWihFTQeU7kOv+avvS68ltqP8Mpfqr8/4CrM5MQVTae7gPPCvPFJ+pThQi2MJdXTkZzOjwvhiPVez1iTBJ+n8FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=BMDitYhf; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=pMb7wxzt; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="BMDitYhf";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="pMb7wxzt"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68I9eKiJ3768408;
	Fri, 18 Sep 2026 05:23:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=3A3/RobuMCLo0
	y33Dz1kqWXG5PhUCwbv7HbWKX2I7Tw=; b=BMDitYhfqX5klE1iUjrgIdyz5CIVQ
	PHdERlj0PTPBj6z+UYmVrqFBx3v4TdaSndXCWHinr/tqNB0IY6VkBbBKCWdlV7vN
	EZ2nQXer15mn6jYQqa03fCC/5cZZPmnn68KGhrhwsZOU+CZvqbGOYb6MEedpDF0U
	Qn+cRL1y83kVo9vJ9XBElAcvrG3+eouowNhDy0bDv2W5qqBDy24yMj4QdcPChyL6
	tRCtXQkS0HtEBCPPsDyzehvERKXCpdWs9wbL98dFkUqkhC+r9UIOoZz9wfMHy3bj
	9H6rjwtn45/Af0zRV6pXY6HOZ4orKGGjEGHw+d17/iYNWRrnGnCKVsOIA==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011019.outbound.protection.outlook.com [40.107.208.19])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gs16cgsmq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:42 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+eW0FRwKZ8ZscNokvaZFdHjoTxaNVsNSp0H8ZHs+PTdPS+6rRjbjVHZrsL5m2gvVZuu94y4FTEe4Bq1gfOjcBGVvSM+D6t7WUQA6/15AGwLJx9UsSxnwdsgWcNadIG/BFtK3tapGsoN8Qlnsn3HuRKk8iUPcqUKHOgaiM+3ZmqGvgUh2ihMvm/W77y8oUuXeqhSOykV4dVohlVAc6Ci7nnIXK/ZQREUChOMiBk/U7AWiIGXNNAGahjyEuVglJ75QuWv0q/O56m/ZU3KJEantkH7NdD0dBZW4rjvgLQPt9AXo6Ad7xYEgY8dyzy5xNeFp91htiiMJ8vDc++IbKP6ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3A3/RobuMCLo0y33Dz1kqWXG5PhUCwbv7HbWKX2I7Tw=;
 b=vDapORsHzqKVelduAWJQK6BLYCP39RWXOmsC8m2nAcp5bNyu053XnX0vYPpFLWtgyO7bB5UdVltm1wnKSe035e9kC3XCu7mOuciIyTjEhiHrgk5HpQo47sI8LyljcoAN6S7dOCXk8top8oFDVEXZMDt1pco0QZjgXjVLAoeUtOwdhejRMoPGnaa/0vGXdH1dxzgmL+9rJ4pcWTIFItYatVPqcFbLkdYfIfZ4MFLRjg0HCpy+cWxnrqwYZ4kMdIvGSu76lqadiNvCUEx1n/kdjjosCrIVXh729Y1ZU4NJDQU2XrKTbLXFLmN2w71IAX7MqM3AQmn3raN+U9pKAt2HSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3A3/RobuMCLo0y33Dz1kqWXG5PhUCwbv7HbWKX2I7Tw=;
 b=pMb7wxztlbmeFwcFTn8/5JCe1bXHoGp/oObpYkeVta4VHZb8fBaWP2cNjPAlfIlawU4h4NUqRlisDKF1Mh5xZk4GskbBxlJYRcpJnw6XbNFe+AwkA5UnE1IatVBqULIOVt+sLI1U1hVJ1cEcvBB+xoW0uWhjNrXGQSRt3Hrkies=
Received: from CH2PR14CA0040.namprd14.prod.outlook.com (2603:10b6:610:56::20)
 by SA2PR10MB4796.namprd10.prod.outlook.com (2603:10b6:806:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.5; Fri, 18 Sep
 2026 10:23:37 +0000
Received: from CH3PEPF00000017.namprd21.prod.outlook.com
 (2603:10b6:610:56:cafe::8d) by CH2PR14CA0040.outlook.office365.com
 (2603:10b6:610:56::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:37 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CH3PEPF00000017.mail.protection.outlook.com (10.167.244.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.0 via Frontend Transport; Fri, 18 Sep 2026 10:23:36 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:22:53 -0500
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:22:52 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:22:52 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IAMpHH1533895;
	Fri, 18 Sep 2026 05:22:52 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v5 00/15] Fix several issues in DTHEv2 driver
Date: Fri, 18 Sep 2026 15:52:30 +0530
Message-ID: <20260918102245.2784000-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000017:EE_|SA2PR10MB4796:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c0d443c-9551-427b-c10a-08df156ee642
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|23010399003|36860700016|18002099003|13003099007|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	jfx5V7zzsh/q7vSfeNds1bpCudR9/Kb3DSJC1ysKo4IsELO4dvYTGyp7OFXG2uY/s+2cDnrUGVe4OO2PlRTGhC/CexPRmZbmMGbp+CaCg+JK/xntiUHE4WPV4wcO6wmyMvMPZxv2hlptmaFlU3v8hTZSjZeNoULAJf8p2YiDCOkCdqt0Js0sLN/UjpvuMr7TBQlPqvGUamy689sSN+5dmFD/bZuLpE/Op1APu7ufewcI4RQxdHViRGiMyyugXa8QfGj4wSyWZ3+su7OImqtvr6Xu0shFUV9y0FdzNcLpUFCLgOMM6auICNxRyq822gzjZj6kQ7pgOvRzswaBkzd7NWwTNkK0aKm3lOjJhmWSCN674rFkMpOGs8TJUHLu3trWhaZES1Ujhqc1qbt/bFncNru6teA4sbX/E0tl7Blf3tSj2Vdl1n2rNizV9PH2BPrJHPi2IGWxjyeL01KRDFdVrdHmTjE+bqgiXC4TSmRLz12lns/4zQj7F8TMdJ7hRiPaN3/RK8KHIXSHIQpXaUqag5rnPfcMwS4FJ4wyOgh0fbbWGAdWL066wK5Hzg1S6G+EStY6t3TtKp/e3eRKc0/sMmfBgLHMpU9vzZYP48QGM3c0deU+a5fOPcSbTu9rxRho/10KqdSodT9J+IAUvR5B7Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(23010399003)(36860700016)(18002099003)(13003099007)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4Vr54wZ2vQwSJ3kWP8iFZzhg5Xafigneq76cDM2KmWBGRoThzfSV+4BcIOq273+8ttZ0Prbji4WYvGA8HKXS7Ve5Hi9lOGqcANs4qwfFfAmQossCYJ4v7XCP1kM0vKJB0eu7tT2TGs4QqCcCZ0Fztns2uM/0SfdFtotD5jXwYMIsQ/rLJdZd6ta9xGjrUZJKKCbX9HFI+wiPaxgLT/BOvRLgUnt5qulSKjOh8ioTwC7zGvq+QxBtvPul+xhtxio+goeim8LxYGVpCIePM4Xdaf+j4vq1mEAf+0Iu5jx8H8BGZ796/3Xho1qAtRObRd6Cd55WhRKjf10rpdGIH7QMmp6z/a5svB0i58JKa24EkTgmDrzQW4juFsj3voXj/nWMs03N6+mgX2WPLddNEQBG7tdcsTLxwfH33fJzr245MkFndHfGe/dFyPoPymRi+8gM
X-Exchange-RoutingPolicyChecked:
	Kp9y8P/sQLyETDkBs13L0PveGPUpJjhNz4jMehOG5hx/rqXdWneMBagG/JiwE1+93iPWuzmd5jtsRS5t+fpWdt2bmRoE8KP4wN0ym/ubJ5XKyuEyMEmv+0O2cHceLrAUt7UCUeAezoLpitdyruBzQSG0V+De2XOrrk2W3Dauo9ceLOqDNykEpOzlZVutaCiGcONzE2Z3LIQjwJbVFtmCOfxdKe/35/tDZgIs9Z7PPUfG9DjaD2tqFr1UOcP7hQqnfjJCZgw5YynFJ7U38Y51je/ai7L2GYNdZnLLIZRepCDsJhSf3bN/8KGBWJgkFYQvkeCu7+qE0OoRmqBAJOi8tw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:36.2761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c0d443c-9551-427b-c10a-08df156ee642
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000017.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4796
X-Proofpoint-GUID: KdKccAUSkWyWrYYnrBxQXrMvMSVewP_P
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX0ZILIVZXUekX
 c40adrMfbkRX+LBnFFRA08quBcqds3nSih+ThBV2/G1qAM7xU+1MVYqsg3Ieih/Vk5lbx4qhGkL
 7cFy+J9Lx/32dSxH2WjBLMyYgombRik=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX/Gs4vRYQH1Yl
 RjwjwbMT4ucCa0J8dokHhveE8w05yt8v0P2AKGRTJgHjbRlWgOJivZuVQz9C4gAPLBQUWp0y8+E
 diTarKrupRrgGf2zRBrVgDwkOwwWf2OJjWDZ0oDwKkw8uYTcx6XSwjN5iPZJOAwniQnLN0DNLQ3
 1E+iTfBb7TNPCTT9uY6HnLeMYcsfYHKTgRisCTNVP5z1FwOCBUkxcD8WiIPd2esDW7eZP5kv7Dr
 KEh1UQ0FFkwPPq7/jpkupllzdjvRAL/kIRSzdgpXOrLuZJUalG7ntTvJkKD9p356xl6yacPlsW5
 uTjXB2wTwwgQDNOxjK8FQLA3N+ACmq5CskDjnt7p3Ql39AnAwB0pYywnhb4/UCOhlVJQXj1/p2N
 PMWqb4dwKGaQGEkaUAhDTYagkvK26STI1tSaFJXNgEVHHY5auA57X3PYX/PhfhBQLu7VSA/q1S6
 R8JUz4CuxC12s2Fkq8A==
X-Authority-Analysis: v=2.4 cv=cKh1IVeN c=1 sm=1 tr=0 ts=6aad112e cx=c_pps
 a=eOcJweQzB5mT18+DdV5GwQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=anyz7pXEI2FM5XLJWiMA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-ORIG-GUID: KdKccAUSkWyWrYYnrBxQXrMvMSVewP_P
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 clxscore=1015 spamscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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
[1]: 
https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
[2]:
https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
[3]:
https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com

Changelog:
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

 drivers/crypto/ti/dthev2-aes.c    | 324 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  52 ++++-
 drivers/crypto/ti/dthev2-common.h |  58 +++++-
 3 files changed, 299 insertions(+), 135 deletions(-)

-- 
2.34.1

