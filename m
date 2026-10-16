Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AB12D5932;
	Fri, 16 Oct 2026 11:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151339; cv=fail; b=clqFdSreSY6RT7aP8Uz3z7madTytpXRuXHuLnwYFA7QSx2a7EagtEJa+0AiNudT/O8ptY3Wyu9U3tgzyudbTGqpmEtyUoAio8TKBbxajEdZinZJrZ+Rv097Te5rxUnubm1dCCjPxVNNIryuqyFmUXaBs7oZPJodVtGp0qyPlP8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151339; c=relaxed/simple;
	bh=UWNnQQFOWMldlulocf6By0PgAP5rrXm3/StInUh/bDg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PN/iYaHJr2bKD3dXH6Xz2M6vdHa5sLzjaX49Qvx3ng+gmwb0x6ItWlFOfHHUm+IaZzt50DM9cmjSL1oaY3iCsPJPmV3SeYyyaJbWahnDXI41/zMYGG6Jrw+Ivvk6501rh/KSR93eQbXTLmjxPDlWWqZaCJNiEnOk/GQMhK1kw+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=BvNu+ENm; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=L0Bn6mUW; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="BvNu+ENm";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="L0Bn6mUW"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GBG50x3818349;
	Fri, 16 Oct 2026 06:48:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7
	GE=; b=BvNu+ENmycMdI//yvbqE8BGsmnjr1+7u0WEbmv3E678WgFnXZGEikft+z
	15xlFUNWtgmy7FGAE6tQfmu+AKE09FBcYXcosZskuWvNF8kckRmE9w+5BwtGHJf0
	TdwTKixRs8LhPl9V0c0n7TTvzbZQH3ilFKndn+vqdgRAL1gOx9W0C8Ttmjk/ynzQ
	Enpjwa4opG8lbDG0Yr3QTqXdKf26Ukxt0WPzYZN/Cqtt5DBJC0m0EyjHYIUMET3j
	CMmd5+QZOz3CSyI0gD9YguqKQf8AHurAZWdruALBLgfdJEcDNjIUrTAXRtjNAl7I
	1Yd2/0w/zkbJjBZGCR1kHSLAhss+w==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013071.outbound.protection.outlook.com [40.93.196.71])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hbhbg8jdd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:48:53 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iqRXUDWMXVPXioHm59HS1k14835kwKiqqjeFoTiZsokcLE6iJNdIVyBY1ajKfo9i07Wt89MH96TIIXCzQqI3cX9LnjsaNxloRdg3voRVmkxQ+6wFGFPmiEHScp/mrDgEwX52b9WzzPbWOD74GoU9W5XCcmODTyTYT6LAnyGY9oJq6PM8J6MWODxHPsIpEmglkLmFqdgBRN5ufzrr3qR6wkt9aL5U0H2LGgH+mtRiWkX/Ws5NIO05K0fUvdsC2W6gwVdk/7jIKrxrLfZX1lXvCQ7elMlbB1Agn9hOizRQ2MyCab190AEknqKXYvt6ZLn30gscGGRjeQ0JkjE7Dku9wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=A1tOAzfHokvTmqCXKCbehfbXMmExYjaSH7hgmM/9aLA+ig5YUjzIm95j/tXkC9eZrmchsAdBz58sPhO5Ln3XXyuCBvQLT7OxqLvLwQREX7PXqhyXpcO+wxG2ca+tF5L4Wzcoh6oG9MmiMsOdodqqgRUHWExCEHdKaQ/MWjD8dqYTjrFViU/Lsk8FU5ilRm6OH5lrTNraJQsizO6dj8nqoE9fl1iilov9Pk1aZs1fEugMB11XAJ0Td80puxr2qQixzyGyNImjIMlyzoqBoSuDE1z0W/259dKC3va+4IZa2RsSOuxIlLdqPk8N7c+XqxJQVHNbNPGFAdYpD/grsHbxDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WC4dzdgIyYOQvNxIJmIniLPFWBZ32UcdK5i+uOKE7GE=;
 b=L0Bn6mUWPi9xlCa43gkbvLq8i1qTfUXmR4TbSm55D+tsnZ7ERD6m6/ZPTdaZYiKzWCdm73DOk4ekK7ErOsbOSyNiNx1ngCm0nt2UKcIZkfR0dIuCWFgvJgg2lszEc6YAgaUWQIyFeuzLJcNyu+r7ZPp1+8bCvzSarlA6J8jL+oA=
Received: from BL1P221CA0036.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:5b5::6)
 by DM6PR10MB4137.namprd10.prod.outlook.com (2603:10b6:5:217::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.12; Fri, 16 Oct
 2026 11:48:47 +0000
Received: from IA0PEPF00000045.namprd04.prod.outlook.com
 (2603:10b6:208:5b5:cafe::66) by BL1P221CA0036.outlook.office365.com
 (2603:10b6:208:5b5::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Fri,
 16 Oct 2026 11:48:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 IA0PEPF00000045.mail.protection.outlook.com (10.167.249.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:48:45 +0000
Received: from DFLE208.ent.ti.com (10.64.6.66) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:26 -0500
Received: from DFLE204.ent.ti.com (10.64.6.62) by DFLE208.ent.ti.com
 (10.64.6.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:26 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:26 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmP9Q2451383;
	Fri, 16 Oct 2026 06:48:25 -0500
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
Subject: [PATCH v9 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Fri, 16 Oct 2026 17:17:52 +0530
Message-ID: <20261016114806.1749515-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: IA0PEPF00000045:EE_|DM6PR10MB4137:EE_
X-MS-Office365-Filtering-Correlation-Id: 60eebf03-1515-4900-dbdd-08df2b7b6f69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|56012099006|261009223027099003|10067099003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	VjEYo652NZoWX7Jx59PvPYqsrQUXV5CSOLW73huJFENNJvEGhdHoZy7NRoqP5aDaSFzgPsddp+BhiJAk0ekpsvbiF5g6BAhXnfNsgqy6nV/U2lQdF/LM9USI4YcvdRHaH8/+OdCJE0tca/dtSHBkolAR1YhcEW9/4dYBQc1tYzyRvLbVDSVOtI4hY21OQ3/UxlQ3122RAkut9yuhO/FNNv7p/ORjLPXkr1lZxCB+/yR08Psqw4qHv6HZ+Ag+zYZBJD/b5OmCt6yAHqMe/VneAIt7TV4j70wnTeQf1nBIvDI8txJYKmCQG01RkgnkmyUEGLTTRb4cxZUuh3Epsm54+x5DCV8N3bPRWIdo0sgebXF/YwC0JJNFRa2RMqFZBLF4zG8G7JnlYoAnI6PAeGOpX/cUDOyh3vI+Di9mfVCKoiztD/UP2qMtA8Hr0zRwGmGY5eb8Xji4uQvBkBRu+GOGKay1Y/8Kvydf21doshjxxCf2W26io2nDY17bpBKaASkPn4AKVdArpS0TRnV5dyBk4nFpKbYPZ/hmxUo+WFocmr4cwogm0+XJmz9KySHQzuwAh/zuefXeknmZnd7wzCqve2wXrLxlSLYJGjWeOI7yRCoR3RQPeprqrXQV6WFxjjYAQRHDqotzYZ0oouat50MX9Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(56012099006)(261009223027099003)(10067099003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TocVSt7Yp4MGLgDyvnzVzXLQt/tBwL+vORmx1oLz0lWipWSLuXxP/VGTrJcIyLXzR8bbj98tgVa0aYCbc+61cjqJJzeof5L05AhpY8aXRrfFj2acnZ3nAt49+PKdEm+CRFrC3D39XaSMNRfCKTqiEjk4IcxZqHbMbMeZEPTKaEr5rHwvDRw3A+F6JE3kZNHQmZ3VdqFwqh3zDQZcAzY8YGcXWVXICK3uEH9BRlccAayFZSY90Ae3bkLxpvHHFyCwzHkY8tIndg3j7/VWIWKwgncyFw3mN/JagI2alpVkxmqnYyKEPtLn2adjwCQ/zI9FgoPuhDtaMV5po61fpQnhd/swMFsx+Md5KvxJ3RjNpKIIvT/5AKnalszuZvZPFA2Hxnytczm5MAno3x2wmTlznMT9PbyeH6nIWYomrnHuEingb7dq/npT/p9ZNWGGNENK
X-Exchange-RoutingPolicyChecked:
	h1yCfAasM8P4fHegniCQmoxrTFndNpo5NsV9PrlD5lnsDZbEezvtLjiuYT7Haje6lQhH5o91m+myOzd//uUyiWZLswk7oNArtm9HOLIlClbSXODmapL66Alic5ft2HW/2YvB43cQWhBUal6DMz5Kuw85xW3zO9Ira0UFTK83mozSdVh3Cl37q5l8K2K5/I6UH1mbKCQ3OVc9TV/D0BEDEB9vADSut6w/bO1sLsF1lqO3OoJ9sDrpw7Et2oiyYoOO8CpvcL2N8+gQhLsv9jR44tN4iYE6oKaZJZHHl7E5fwMGdk6THTLqxHEEjJQcZ3pJ4W/98ytBEt4tZg4ZJd9xqg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:48:45.8971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 60eebf03-1515-4900-dbdd-08df2b7b6f69
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000045.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4137
X-Proofpoint-GUID: VtQCRIvwVqt_80GXA34Tbg8NCK0Lr-Kq
X-Authority-Analysis: v=2.4 cv=BuoIUoX5 c=1 sm=1 tr=0 ts=6ad20f25 cx=c_pps
 a=5eE4sFn3BonZCz/fQf+K5Q==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=sozttTNsAAAA:8
 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX469ssTDi3sjb
 RNuv3cBXGp9qVhYE7u+mxaXQWXwIClwteJeon7SMKkh5CcYnjhuu7lMNs91vp3Cn9ibWaMz22cw
 yo87FLvsbLXyw6FBp+XoQZe97xsjRRnL3V0SjLhqp7OHtH1mgpshJ1X76Mr/wXMYibTuhgy5VRj
 9A25hyWPSX2LXhq8x9PGZ2ENeMQXCDut2jeXoIPSzjpjUkhRpv54zeJQFMViG6OyFlEuJwO8aO7
 z1/ucJUM99md5dZ5CzexEdF/P/Z1LBXthKkXMGbtBk9WPDnbfIU1AheF+gNFADShrnI4SiJN5tm
 bLjWsQ0UC7JeVpkyHlu7dY/DJTLIRfUdNZpcn5JGBvq49Z6075mSAeXX8xKv+VgqtmPWDYKgmJM
 Mss/2BISGPgZYvNT6cQGgDK47fPcjDGWs2AWPv/LoT7nRqsMkDnErw8/iwPaHdanyzQi/YbgJde
 RnToWJUW8DbgSdRjtoA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX84L7f5dQHWcY
 RdRJpqBYYOdKiRw+O5SixCTzvD6BarY3EAYTx/2X4F0GbVpCjPofLDS6PXfjJIhZkwwsycUcklQ
 UMAAsTMSUv3GXzj3NWBT7axPZOhHC+M=
X-Proofpoint-ORIG-GUID: VtQCRIvwVqt_80GXA34Tbg8NCK0Lr-Kq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160046

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

