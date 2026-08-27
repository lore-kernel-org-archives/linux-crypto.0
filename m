Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83299393DD3;
	Thu, 27 Aug 2026 10:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787828343; cv=fail; b=tIg3NU4mauYLuQKRkwtCZaz7d/k3HCNKXksVazUcJDhJNSeMxscDPZhna+mDhD9kV9V8RAOZ2twpsR/i/vq8T28vx4g7uEM7hUXeTj918/VsPK3swa2g8+/N3bni1iwrg6YVTfTKy9D8NTDz/Wkd83Q53yXpduJtBTdFml1XQOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787828343; c=relaxed/simple;
	bh=5hqyVq6v+uTF1JozAVv9KoLLmKZ20AjwVxiBowpTaKk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r39k1jsrrJFG6GYLHyYG/dpix5b/cXv5mRfvZusDlMUJoN0RODDFpwAnLCuI0fMNuLpocZj1Wd4GjvM9kCkGbNQqR/bPmlttZnqy1xlQiJy3K+UzFmaHp0Mmy1Ee8ZjCzygO82paoYKd3ylrFlSlcfXWM7lvTpZtxOpwHM9/UPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=lx8VA5an; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=JfK+cR+r; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="lx8VA5an";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="JfK+cR+r"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67R9LL4E2767527;
	Thu, 27 Aug 2026 05:58:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=aagA3oodfHFhmwZgc56VlZD04q7B5cBQh+xiFCpib
	8A=; b=lx8VA5anzmUWrYSgXoIAi38mNKbRQoUotkcaRPbS1p5m/2UXasGdO37SN
	BtrXSKL5uF1KMrzHs/wFuZdDFKU8UOIU1xjKCHFqSkmxxOrj0N5TLFBzd5V0kG9J
	t4bSdQqtt6g1Ei5ucabT3MD7PQrpY7gJUOG01jFbZkRlp11bFPjN/jwUWAD1r0Cu
	GzqbpkuobPCe2k8eF2RmrOkG8FhQFQKjkjVBkBNpZgiLgZ5VHaFZ8e/VZsVkAHvM
	wMA78n2Lw/grSu6087zjwizSQ97aA0qFGJz7ltQn9SIvZMqoIw2YyVzYGGN1/mB2
	DkDVOnSLcOxRX/mFysaTBxg8PHDTw==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012015.outbound.protection.outlook.com [52.101.48.15])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gajhhrcfp-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Aug 2026 05:58:57 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pQrhO6dIIMLf6Lmo6kvh59oKB/hmstVXUNTuVNsJwggFScx0IZRwgpcbh9Q3XJuUourKxCSlj3Y2aGpoWZzq/2v6MQT+LM6ba5HUGPaDAR3V+GSXvXplfUuGNMUE44mi6+3vtmrYnWyMmcRjAmoBC7rDbvzqS5ryI05roK0WnC7RkqDZVHn9DiVS0WWWrs5eZ1KBopvmToil32q8tUYTdgtyKAc3hcAQoDQFRDVsHDmNYd9+YmrWtaPBYnpExdtqlA7yDxNctWRuSEAJ9E0v8wQpoDaypiixrMZd1s9QGxNgVXwve8JJyvk+C+/1aUkTCS6BzlT6KW/PytpzW23ivw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aagA3oodfHFhmwZgc56VlZD04q7B5cBQh+xiFCpib8A=;
 b=S0CVam8NiPUNqZgvMVbnWOWZrfz2REn3reYqb9EmcksaLpmbPLlC4HjIyHJOREvbn9ENMmj4yqBaJWQlpIuinH4kVBS+ILghC0mcNHpg652xXutRsFHSd1BGL+5TepAuWaFsr2soCyxX/lRyp8aaA3jst6H5Iq4BUcm/Z61TZQ14Ko8rtp5XrMnUSla/MI7YYnvCpSad4JGg/sp1p+hKAXC/LAQBQSK8K4tHh8UnbEHN4Hd90fxSDesO0ar7IsH42KaBjYJDOwybDXe+c8jrMjBSdMN18IerfLKm/LM62sXLY1vmn8JFjHdqPDV3k4vBJqtXTxUPPlYuo4D4Dc1STw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aagA3oodfHFhmwZgc56VlZD04q7B5cBQh+xiFCpib8A=;
 b=JfK+cR+rkEbfV4Z5lsAjw8l/GcT18lfaU+d9GPk8SPlOy2Ojrl9cITGF1bHbnK0umLiLw/URgEOH0MbG/wBjuRjVDxgr+1NV784RMDm32YVgLpSvfbnVmEDTQPY6vVJJZMhkPceCTO60wSnb5NzilIFarGmVobJeQ50Noa6VqC0=
Received: from CH2PR18CA0035.namprd18.prod.outlook.com (2603:10b6:610:55::15)
 by MW4PR10MB6461.namprd10.prod.outlook.com (2603:10b6:303:21a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Thu, 27 Aug
 2026 10:58:54 +0000
Received: from DS3PEPF000099DC.namprd04.prod.outlook.com
 (2603:10b6:610:55:cafe::4a) by CH2PR18CA0035.outlook.office365.com
 (2603:10b6:610:55::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Thu,
 27 Aug 2026 10:58:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 DS3PEPF000099DC.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Thu, 27 Aug 2026 10:58:53 +0000
Received: from DFLE203.ent.ti.com (10.64.6.61) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:32 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE203.ent.ti.com
 (10.64.6.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 27 Aug
 2026 05:58:31 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 27 Aug 2026 05:58:31 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67RAwUwM694642;
	Thu, 27 Aug 2026 05:58:31 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, Praneeth Bajjuri
	<praneeth@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/5] crypto: ti - Fix potential memory corruption on highmem pages
Date: Thu, 27 Aug 2026 16:27:09 +0530
Message-ID: <20260827105711.527182-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260827105711.527182-1-t-pratham@ti.com>
References: <20260827105711.527182-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099DC:EE_|MW4PR10MB6461:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b0ee568-5e7b-4873-052d-08df042a2f4d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700016|23010399003|1800799024|6133799003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IF8K7av8TrBSlxrqF0vRQt69sUsKaQnYYLR2ExACa5s30fJ8OAVhE01jT9FTdZ7JQZTicRot/8xtAcW+kUOp2LREp5LWKvTToYeq10f2AxkTOJ6dzp9zKcTfLD5cs46rcy8NcL5xaDQ9xI0kWq/dCqCnlCnQXnJlSAnHMAsOM/a2d4Aq6bkKBtKISJEKQu2IyMsmL8+UDy1eE+jJKNycgZNcWP1lVqCA5p2Z+zN79jt6Cvf2vayGt4htfqW6H3gwJl2bvacP0Ll2qNmZT6red7sifM7FneeFQYmTghdX/l+oxGDt/MtLJoa3BS+o2iOUsYJMZlm1rCvGy2ZDTKTJiM3sZXHtgU85OjYrqOWG9rY7xEmVsZxtUwQjlWGw743ash4gQUlpwL3GMt9TB4GY6ASontkMrV4hw8PfBUt2iNxYrFQstx3QC0c9dGZacFxhK5Tlr7uIaLB0bOE3O9SsyBRiohFWxeiBFNZ2CXD8zFSGf5j/BNpQgq9juz0krKE+0U23jz6ZMs5rhMAFeLyhXvmdlFhADJb576Hxxm2wvLIYPwhmZN6j/Oxi9Dhb1arES336Bkn/FPEsu4zaW5Aza2gqWv+axoTbKPvv0WAExiuioxS9AfMuBIxLDVkfNZ8fv57Wke5CrLyZjpbn7BZYp2uFv7SurxZ5p7Cm8B3VzqE5VbronrujAlCn0lIzToc0gXu8lRF7IA4+6MWMfSL+tg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700016)(23010399003)(1800799024)(6133799003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5DTRwOBccnPHqVeb4mIwA5z5tLZQovmviD9hxNjN7B7QYiZmGYtLJAw1M/sR+Si6lUJtryKyOugftJYV4w6pydaWnexyaPAetgrGmok6GZ69k3vmZomc3eDmPX7gX2qUF92baC3xo+fAdcwtfNmNjMBkBSc3dVnCx8N7EFtNynI8VRBZycQox3KurV7OxXNkWxmAi1MYIvfq2ywoEhrZyFrxDyhU2Pilsy+xsulLzRqibo9J3UzpmRUbLkNHHM4DxQklDF7uUavfi0e4u3Da32pRXzzsDnbAVPe7fEq+b6QmFxi0BHl6YMBHnHexoaV1tD0DFYZF3MN+z0IQEcd+o/dYOmclAOoD18DJfqzTitquztEXeH367IyQRAIL8BdjkPINQOczZbsIfiRm5IAgy0oa+uSW8myk1oSIiVddm4kh6NmexQL+Lc/A9ctUgqX4
X-Exchange-RoutingPolicyChecked:
	L2agOmzGecfqyQj9x1AZ9ML/8pVoCIerFXhFIKR6V4JL7t+x6f96bFhyCwQ7hBUKgnb729KYX8RM6GS5awKGsISt6sBTX1WizmljfkRPew0e9dgQgFjmyBErDhKV8A61ZS8JYTJrkdlQ/NZLRH5GGKK26sVVsh/g34SuOgUAkENYVDgK88lxHC1vrfJUK0IqTqZ1Gav2uRWvwZr2KRwCcnFg5xt9CKdlqtlWiIz7MJxDgAkRkDQGqLQ8fOBzjGy24O+alGLo5nGVZBiHK41yDJmohIkhVkt27L0BbAnS5P/gcPBAhqijza/4+HYVElSe7wee6xrmUHNbd2hoHARirQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2026 10:58:53.7549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0ee568-5e7b-4873-052d-08df042a2f4d
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099DC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6461
X-Authority-Analysis: v=2.4 cv=Fu01OWrq c=1 sm=1 tr=0 ts=6a901871 cx=c_pps
 a=cLI4zmX3yytpP84iY95SKA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=VPAvt0e__hU7bH23DkEA:9 a=zZCYzV9kfG8A:10
X-Proofpoint-ORIG-GUID: xxu9TgYFjEWXFyz0Rb59_E7KfBpp0a70
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX/thEFKXTW4m1
 P4qroq+xlYOWIq+GmETQVOu7I/TnFNNb4eSpp09wV/Ds1+fDZ1jWZ+BWqMWeAmHPb7dg/O6Txpr
 IDVwouhVv/htb93YR4D5/nfFOHHpaQN4nKXf5wTAF+QT0PmtoxY21pOthyulD/XekL3TdeEUB8d
 aAFem5jnOqCjowUitkjr6NjlMpFgZDSFdttmsY56hPQ1znIJJogfGdGpuMUGr6CISnlxFYixazu
 5+GPjIbT+u45VXlysJLgZZp8kZzvyRxODs+omzLC78Z8H0P4SlSifVyVNt6206p1+Wp7J2OEVVp
 SwtpDP0BQGwXy7p2exZF5Y7Z/8COOx1Z9QSh9LnXMwmQ40qE1+hX+VRN3gHaoDOkrdIClncVNUS
 +2LO0ArW3rY0YmWoD+fI5hQfMuwBukyvN/cMwPo/u9xy01rXP7Vm6NaIzOgzTz9ikenVMRsUc2B
 BQzayFZrqEjq0XaIBXw==
X-Proofpoint-GUID: xxu9TgYFjEWXFyz0Rb59_E7KfBpp0a70
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA5MCBTYWx0ZWRfX82te2ufrGE/u
 lIWzXPsIJ3KTKq4yGbnk+ItzluT23pKPMsfUEEpxqwroimbrtfFTF5NO2cOdTvwcwW3LTBjYaQ5
 pZ29OG+wy4zlFtOYJq4ZUYUhl873BSI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_04,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 adultscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608270090

Change sg_set_buf to sg_set_page in DTHEv2 dthe_copy_sg function to
avoid using sg_virt() on scatterlists. For scatterlists containing a
highmem page, sg_virt() yields invalid or null adrdess, causing
potential memory corruption.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index b315c850f05d6..5ca1576664133 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -59,7 +59,7 @@ struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 		sglen = from_sg->length;
 		if (sglen > buflen)
 			sglen = buflen;
-		sg_set_buf(to_sg, sg_virt(from_sg), sglen);
+		sg_set_page(to_sg, sg_page(from_sg), sglen, from_sg->offset);
 		from_sg = sg_next(from_sg);
 		to_sg = sg_next(to_sg);
 	}
-- 
2.34.1

