Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C92F4AE8DE;
	Thu,  1 Oct 2026 08:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790844814; cv=fail; b=NYIK6b5fnl6lSZQcgKRbT91y2mv39saEP5vEfA9xslQuz4SUtgHCLk41m6jePQ3zJY+etLSLi+K93UI7CHqQVOvp5AHuVboTGBb2BRZx4vwL3JNBppDioeEib/dqrd2XQ992H+os5i5CFB/DS7GddESI2ktf7BgWkZqU8J9SVJU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790844814; c=relaxed/simple;
	bh=UWNnQQFOWMldlulocf6By0PgAP5rrXm3/StInUh/bDg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D4ec87BC7bd7BKDgzOqofGUBeSgIFlRqoKBI9DbuWpxNfapYE7aS+D9qaNt5q9gKlWM4pG2qhA3UJX8NePADzpqEKz+LH/5/SEzR7g6mww2ROljmEJjEUuWxXSJRqcuk2Hg8Se+7Inecrob0CdQgEfRVW1OOIeINkmfYPOBphgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=k4tO2hdO; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=K2TUFiAZ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="k4tO2hdO";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="K2TUFiAZ"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69187S161207690;
	Thu, 1 Oct 2026 03:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7
	GE=; b=k4tO2hdOG4fxgf/V1Ok/6cR2aot7dFecbePGaZGbx3PLgqYvVypSrG8JL
	tm5mDaxlYRyRNmRR0pThYxfmzj3Cohh34Lp2fk5BVlUkvEOEzr+PQ5n3/KWdK804
	C/Ojhnmbus8gD0KC4lE1Z5qi2w9Ezya8lcP9LWKCcpSOsfrVJRH3+8hM1Wbfa7mF
	I0RUfTAktN6J1VYkg69JeFEHiVkq6zBnqPg3OC9NE+7rnU4J+kQTZmNbmzEFKOCJ
	PjDq1aPPea0rDCjSe6e4HZglvv2grzxfnXWw+xYF0DeIngzX6cOETsm4h1WKboy0
	NuEzpsmBowwzRp9ejF3bPUoXT+QdA==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by m0380145.ppops.net (PPS) with ESMTPS id 4h1kqyg8wn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 01 Oct 2026 03:53:27 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cdyrQlO7dZ3gU9GjrnCVq4bjFGtUXUTn3M+yXHP2VlgqbGfmiNjSAzHx6QngrmCIPT5qhdXziOBPYqY/6JEGOea9eqFeqXSvnkwancDz0Go7GuvYeLJiZlemMri6EGVTa10EDu04ojVASLogzHv7pfvh1X0Zpi59XYVGJ/mg46LjuGf5u8jTR+PVu84bDQlR3PgaszMDCg/pjTyQDWrC5hnOIs8c/UW/8wcZrL7pwqoOyyM6EC8t0kLWfNRWYiG2zq1Nw2Lu9RyRqWEvu9PeNkYUbSqMnvN91n5Zjb3MUPVLOJOImC3m0eR3Kljg/qJpPvMBeBSkNw2YQJ4XKRd0UQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=K+trnbenTYMZlTC0/LVjEk+YaVRf4a8bjSA9opQPAnxaJidvRfTVAf5WU1qeFd4RLK60XxnXSuWLofN2ke7RchCVeai6AVdbOOwp1c37ABYcCuZZ+jLn/1ymGT9E07Mp5jOzgsPoUxzNNwYFAs8MqVOqSlgyKScUNcUqhdB2/PJdzkYxfkgDWDY8s3ChU4Nm2QiG+lghJYYYYutXXcxb11tv/nw9t7Wi7l1Ksd+Jrk9nESU3LtTk5HL+BLtYA75FnjERW+21x21lx5OrDpRGdq5xD09qNFlZTZtFP4bJHINJDLPGRf+GQRKZ7+xgJYELADHyNzNA8DbdE1Webj/oFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=K2TUFiAZp4VHR76P1ym4nY9UAMw2/4pVfaEFhK7GQOw5atL2vbwaikag1uHDSzMEyVe+74w340hzZckCkI+DMnA8LCHvoJVO50u899QNk7MyNE1kT8oYlNb44Yl9aTDWMhCyHOfvZCwjqmglCv4n18Bg5FvVl2eOA2B7zJS8oQo=
Received: from SJ0PR03CA0331.namprd03.prod.outlook.com (2603:10b6:a03:39c::6)
 by DS5PR10MB997706.namprd10.prod.outlook.com (2603:10b6:8:341::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 08:53:24 +0000
Received: from CO1PEPF00012E84.namprd03.prod.outlook.com
 (2603:10b6:a03:39c:cafe::88) by SJ0PR03CA0331.outlook.office365.com
 (2603:10b6:a03:39c::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.472.17 via Frontend Transport; Thu, 1
 Oct 2026 08:53:24 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CO1PEPF00012E84.mail.protection.outlook.com (10.167.249.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.472.14 via Frontend Transport; Thu, 1 Oct 2026 08:53:23 +0000
Received: from DFLE207.ent.ti.com (10.64.6.65) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:52:52 -0500
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 1 Oct
 2026 03:52:52 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 1 Oct 2026 03:52:52 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6918qoOX1594697;
	Thu, 1 Oct 2026 03:52:51 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v8 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Thu, 1 Oct 2026 14:22:31 +0530
Message-ID: <20261001085245.2922974-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261001085245.2922974-1-t-pratham@ti.com>
References: <20261001085245.2922974-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E84:EE_|DS5PR10MB997706:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c9fb12-6ee7-4e77-c43b-08df1f99733e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|10067099003|56012099006|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	URwQu6EizXFPDplE5MJ6wUvarm1dzum3F1Jdud06/bjtZqymz3OrKms1vvY5M6g2RPank5beWxR9sDa12ky2e1kGycqRSutN2Bh8LdOacTUQoqFOWXRoIH3ICcm36v6iuo8drgJ4EtfwSyr9+N221XfUok2DQnkldKCXeEvWtBdRkvIOBwbV40682HpLfuPdJqNU3EcXJowNA3WHb4SG0iGBML20K3AbLqc72cvIl9l/BcfdFAlSd2yU6fQCjameMAl0D+B7noLsc8HOTm6q5AMiKMzRP5znylmkXuYWB7WsBlc3cUGUiFrAoEQ0/qCCIgGBNUHcuDq2paJPmVuTZGW20LMoyCBeHWcLiuZ61HB2c7Qbae7kno9Ujm03Hos5kAs1dqy0MG4FHzGXxQszAxVvqZ14tVBtzyzIq8wE3YGNznRi2GYlqr2Ys5IBNLqax+ZdihWDn0rfs0NYKVT/up1pJnx7IR3I8RmoNdzjV83TaUwHLhQ4eqcq7b2jXBveM40UT9drOJPTXdGskdewkY89HDgYA4zJeypUejh1k/4Sx2CdytaZ/ko36ci8LQFuVgU7I/SCAdOJhOIbGHFSg9R7JwGL0ZN5WAbxcVPO0ld0shpKmnHRc4GgLyLirdPehTfr9JO5vPj67VfG8KPxJA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WMJxPuvmq8gGVnmToG4h74fPA4weOqD8uc6VYRDxGkaQt48Mp7qd+cd9Beq/DfeCUlvC8I7l8rqHYOC5GmMBQi2dDjI9Ktf402FBqdao8IGKPZ7S/vSult3hBQYKLEt1fe0fhxZuZIH4TfOIMP5DHvbUHjmbIpjMtOZhqXb3onJXQh2YIcL5wZ3nAjJCKUz+bEhAmOH31x0Zd+NgnHiKgoC9gvl+Et6iXLSt4oJ7kDduNT/4Rr+8odNyKWWAkI3f7hCp7et54YHJHoM9KKpHZo30A1ZZ4NUHdJval/2d+y9IHBtQbLitmIbiBoNllZZdbMnZJCz89ngcS1uOUPTg1ZaNG0jWF+mcz9krs9cg9VJBRMnOQ9lGI2KfEgj2kDE4onQCZOaSFYsSLTJTRpgXQIpIn1gk+0BOEIGU/5XclUtrCs0vN+UCmJps6BEckQ8n
X-Exchange-RoutingPolicyChecked:
	FpH5ujbWdhGLJrBeuwcAETHv9tq5ShgDYRPBe+5p5wbyXIbLAVPEnDf7iN20albKFPMnG+jyo/8YVghNF6HsxySQ79vM7vryb2lC/0nFOPHdKVPUHmKFyRQSFIyu5ut/uATYsg8G/ht1ug8D2p8oZAZdMlwIYReGaor0YIvIXE8HYImpr2AEIEU5f6PnRLN13iLa2COU1WecR7Y0UJIU8ashmPF5nP0dTFfiUBZlscRNhjGxv4l1pE2v8F6Ph4DiqW8outqgqqiWNoiPdPcelCDIRCLKHGIooFDMRsBRJ+bN/p6fMLP1KeqKK/33K5owGQidMHuYIAuG1yqlF5AJ/A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 08:53:23.2560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c9fb12-6ee7-4e77-c43b-08df1f99733e
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E84.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PR10MB997706
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX3apF33Ekgk27
 NJGGydFoib2CNcrlX8dROUu1vKsqrc0j6OpM4hQdUnjRv+GeSZ/aNfxidcVac2PB4VOqKNN4rJ1
 WPtf1KvT0GaigO+xLKHNh7TgNnra4Oc=
X-Authority-Analysis: v=2.4 cv=a6alZkSF c=1 sm=1 tr=0 ts=6abe1f87 cx=c_pps
 a=ReLZl+GdXdFt35wSL8r9Ug==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8
 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDAxMDAzNSBTYWx0ZWRfX0Ry/z0ZhnVbA
 oR86c7QHbdqgAd56DBIt7CAmxPqppM0SSDjLgftKbl/9OXuRxrdCSKDgcebIwM/d/7rhEEpht8P
 1CCo9TdWz4aTrExL4oJxpvl9HazBemJOgZ/oujCP1/0Ry3hPVkbSZaBSQ1nNbcmcjboB4c0cLoX
 VzUomHWe6H7zaUOpRAYQT0Lfo8XUshK6qKIiA4AekdvnR1QlxmojLZVGI00WcxRoXBBvpobIfV2
 bb7ILIAMFCxSpl6EaZuLpsoyGWVzmrDr6LbKrx46xuSqR/3lRIJqwpBJyEhDlaStIEfgwHkTdeQ
 s5UrzgQgUnxhqjxgQJlqD2jnkObbOCbkhmMUmFHRjVCvXbEbTJnYksImHZ1nOtBTrprlntCMCDQ
 adMOeUT+HhypYWatFVK4WAs4xa8tdlMt4t5SBbxK88G8+G5ZkR6+L173NzlsCZUjnYxcCDp9oCR
 YOkD3+bz5rXe1WDBbmQ==
X-Proofpoint-ORIG-GUID: t3nvhAfKHtS0WBtgxRNJAWITCkfDnZNQ
X-Proofpoint-GUID: t3nvhAfKHtS0WBtgxRNJAWITCkfDnZNQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-01_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 lowpriorityscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2610010035

From: Mert Seftali <mertsftl@gmail.com>

dthe_get_dev() fetches a device from the global device list with
list_first_entry() and then checks the result for NULL. However,
list_first_entry() never returns NULL: on an empty list it returns a
bogus pointer computed from the list head. The NULL check is therefore
dead code, and an empty list would be treated as a valid entry and
moved around as if it were a real device.

Use list_first_entry_or_null() so the existing NULL check works as
intended and an empty list is handled gracefully.

[pratham:]
Add null checks on dev_data in callers of dthe_get_dev().

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202606111933.69GGTKxr-lkp@intel.com/
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Co-developed-by: T Pratham <t-pratham@ti.com>
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 12 ++++++++++--
 drivers/crypto/ti/dthev2-common.c |  2 +-
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index eb5cd902dfb59..4fdd24ee91637 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -112,6 +112,9 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -124,6 +127,9 @@ static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
+	if (!dev_data)
+		return -ENODEV;
+
 	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
@@ -571,10 +577,12 @@ static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	ctx->dev_data = dev_data;
+	if (!dev_data)
+		return -ENODEV;
 
-	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
+	ctx->dev_data = dev_data;
 
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index ba6cde75d3611..cb4b8b38a5ec8 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -39,7 +39,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

