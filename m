Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E824E0B8F;
	Fri, 18 Sep 2026 10:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789727015; cv=fail; b=R8Nq31gn230iTcbtJhk8iI3nXMBoriBQsrAuw0orx7t1glj/Z8km5LaMv2++I8n7z1Z83lA0/9sppcCECpitOJ8rnaeM601uWPxKaXIP6EHYApp7SNVL10q+XevQPDHPgLpqoC1jDRE0GMyRnoeCuAE75KoajLrLqY4mquk7EC4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789727015; c=relaxed/simple;
	bh=3l+N7VRjb7sCYwjUPdOx+NEFhmC5BVJCOEULINgQzmA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pv6c0eMFY0tDWoogomY6CjRkvAn3bWz3YQc8IXmVm5vJOleY2p/re2/Ql2MwzYhfqC43TyXpwhXvjshFQAiWIzRnWWeo67FXVV/+GJsRIErKlteBvSe6xKc9K9O9bIpCRamIF1Kwa5GyuxRQP0/gFkj+W+ON9nXdOpjHHijB36w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=HbFZOKuN; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=d7qeefdm; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="HbFZOKuN";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="d7qeefdm"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68I9d8cY1233705;
	Fri, 18 Sep 2026 05:23:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87
	no=; b=HbFZOKuNhjIQSwByOyKAWl5EkyU3JVgrO7p8g9co5ZxUyhDUgKFWAgbdN
	ZuUIKg9dfA7w1Cfe3jfbA3tJh1jruW+NRNlp9EKAuPqEg5EqFqH65Hk89J+96A7G
	7gdjUFlslf/Hko0QnZV2sZ2EQutvoaqcV/lgvu4uJMA2V7HOLG3Pwq/l4l8xMbPs
	j6Tru+s8auR0vcl/Ad5/MYKW+Y5LkR3AfZnwchFM3keMnIJ564kL90wqePiSi50E
	81uG3hdQu2ad6zR5NVFeCEs/m4NIvnlSdpQKzxK6priqdLmHejPDmeCpUN4CJZW0
	n3wfcQ31uGLNEfJna9tPe5Y9c9aPw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011052.outbound.protection.outlook.com [40.93.194.52])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gs2ux07au-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 18 Sep 2026 05:23:28 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gQr2lBOns8CkXj169ZI7+77oos5Yw4ujL6tzKbXaBX+aA2mE8kl2T9BSItPdzyfMuykXzh+wjbOnlIOwwUSFM0S99w9aqv76PwGKs6aTyYOOMo9RPdacOtc4Er9Tio6OCy2jZofrBgsuvsLDW9Wc9E1lGRI7T+kk8Nyng7j0rUtBW3q+Z4XjgVUZ8whRHiQNSZCPwE8qUhLIM7OtYq6E0MEK0o7lCDrPAEYYWFHWwnghQqiWjNGKu1JR2ewmxRHj9G1WC+KCB4VtfjJGuhAHn0Yg2FQeewaY9xyWiAQckJvPHj4zAfqacXy8FrGRlqK/CndlnPiLQIPuX99FoBf4zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87no=;
 b=Ppi44EOh8IKT9G4EvXrKk9NixHgnFKUfpNYSlan5zxCCsTvQcwoagK/z2isWLhkLTG+40ImmCfaXXowxV2Gjna/06Am9om0JRYcTzDwPkTaLCN87Hi/bdzLgW7SfW/GlwL8I+ZTLjFIuMU5D8bQrPvGACUc+KK3U20LFkT/qEsP6433QiiG3zBw9lIKyIjxsjkqPtlWFz9ZdUFTN2GArL52/aN/Kl97EwWAfBwR+badq/HYLbUiasOAkWM7Zlph/wFqUuKa/xrEBYFxtxk1ws2XhaQw4LWAbZNJhcGM84zfYaOkpmZPZPgsmvJzxtkdkXwrYgI/bMHpEKnLG4xcWXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87no=;
 b=d7qeefdm4mfbGL4zGRTFQn1Uv2lxfwkULz7SByDqpErLDtpzVzvtctvoLQkb8f8T5+QfqrX2V/i5F3DQ5v1DnDQIbkuMkFo1Q1lNFjhA1WgKqo85dUdW+MyNlk1RhW1u3AGdOHpb04O9BG+5hi+R7tNRj6CbeYCKTWfr4WwjjUk=
Received: from CH0PR03CA0344.namprd03.prod.outlook.com (2603:10b6:610:11a::35)
 by SN7PR10MB6384.namprd10.prod.outlook.com (2603:10b6:806:26c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Fri, 18 Sep
 2026 10:23:25 +0000
Received: from BL6PEPF0002256F.namprd02.prod.outlook.com
 (2603:10b6:610:11a:cafe::37) by CH0PR03CA0344.outlook.office365.com
 (2603:10b6:610:11a::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.13 via Frontend Transport; Fri,
 18 Sep 2026 10:23:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 BL6PEPF0002256F.mail.protection.outlook.com (10.167.249.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Fri, 18 Sep 2026 10:23:24 +0000
Received: from DLEE215.ent.ti.com (157.170.170.118) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:22:58 -0500
Received: from DLEE211.ent.ti.com (157.170.170.113) by DLEE215.ent.ti.com
 (157.170.170.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 05:22:58 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 18 Sep 2026 05:22:58 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68IAMvwS599960;
	Fri, 18 Sep 2026 05:22:57 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Fri, 18 Sep 2026 15:52:31 +0530
Message-ID: <20260918102245.2784000-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918102245.2784000-1-t-pratham@ti.com>
References: <20260918102245.2784000-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0002256F:EE_|SN7PR10MB6384:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e310508-99a7-4ad6-c471-08df156edf7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|1800799024|82310400026|56012099006|10067099003|22082099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Q0Wr9a8i3/n+5Z6CVweO/riDEl5pGglvfX0tChUxk71536g05bl9UtG6/evsGCTqktIkV5R+4xVvRWWBIBi4ZajhE56kY60UfIYCIVxXjJ4Y22wRgvug5zr/+YSu23+KtDvH8K5BVMBccLPWt0v8f3aHLmM/BT6kvi/SB1QrCKY9VFYTur8r5Hz2uzD7KPSbpQG1WSWoN7myuTh5N/W8PnBgmM91PMSFjlEUybYQZ6PGyZrysvnQ4cDxTreBKk6eyCxB85ttDfYQxhJtKkqIKjIVqJB71NSbUJAxenXVMPZ3VJzclXt7Jm/Nj4akKMVAg9ng+CaEBbZSKoaAUAiCWIgCF3Xasu5u46PD81WfZyjyKMxHadRK5gexnz+NXJzLvK0SL3+QhBQHm7TMD914WQtP74UrE88ajuT2YshDlA4OolC6E9oGIXtVyWnkhrguSoATgn7tdURkhv6pl6SCu89BqwRCsd3eZbv0f08Xz22vc4EBl2AwsaJYQRUrjAXTuQ+hb2cDHwjbGdcg5vdG7B1OeAXKQquxfOG8KnDrfWrxwD8WrdLfMaI9tbebVCqQqGHzWbl16vOS6twZ6tr6uIvbRzDFqgIrYRRD8IGchJitwayFV8KqmxNl0y+tcIsV1GMgpZBhzYWxRJaGeChKAw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(1800799024)(82310400026)(56012099006)(10067099003)(22082099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	4BV3Xzm8jMN/xANUJaRbnI0l1e+P5lAkS/HvjxqmvHN4pWeYDGbn3pbc0BSmz2rQxOvMMdRqWNw5DgzTynzHTJuF4vGapbKLxbaNNfkmhVFlg8xr+2BuWIVSNFaGZyiBeO2JZLehOTFi07SqDQedLtFcl/G4XCmM8ChpPFfcMpoYJodSWL+Ugswfv0ZtRpPZTmMtFW+hZU4HOezBvrCFLmz0g/VZOjaVkVaZrWDxZNc/DHgCHX++9Uekg1r5ueKIyZMDLCTpgj7zLXutPqw7nLpz7zYdxNAN6CBo7BAd6hQj9NGP50Ufn5d3LFiAnIkA82Dj9Du6FbPA0v0U1iXF5YSzGRhf/wRe0epuy0mL/KkYulFg9R1f7REpR3aiPcD5XdA+ClsGUVUKBUoFzJuqs1wOe55tDrt0hlnFPtBp7+dc7ehdNW4SzZmo/6LFEMek
X-Exchange-RoutingPolicyChecked:
	NNM/7ltLbC78eoocEEgrTi+hp0N5AqiapWOWvcQ0qfBVzdr2dJ36glahVvVCGxP6IvYYDi941Uw5bPYEDKZ/048gj/1eqx7eyDo2R0qyRYwRmrhqrIcl7trHRZbZkI3VZa8KT7AdMY2EhxFvx65YJJp5QEDK6wc3dfW7V5A7jCJk8AjRvfub2rodVYdOiHAjT8b2I1Sqp+ArYNESuUY3gEH+DP/ntB4F+27G7RxQc/mVNlhyZDf/1xUJ4QPJN2VotzfhzsOVlY3aBigpRFRj3Efu4VinoCkUBKGz+jvln66WlV7TTsOHCa4qejJXnvynzar3ksEwXFB4BLSqRvh9JA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2026 10:23:24.8968
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e310508-99a7-4ad6-c471-08df156edf7f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0002256F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6384
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX0VY2B3AXu1Sb
 zazRWAd9NLKV7uLFU2HkKqcUNDG5iHRf0c4QjJJsKWZmxWkvq9u5xH4Bh3OcEMvXnlrY4zomQyV
 jgqsjpenJ2Zy7BOfaCKUcbcKTofuNsfRhmuZ6ecNY3DmcSMEQzNiMSoc1+F/EMKHloN+6sXJDeH
 ZTC3zQprvJUqObH+s0PNl3Ivg23ROsW52NP1+nE4cBEyLYeysA2a5V0tUNgLSjdGekMhOIRYScp
 t4a4rNoLzEZ7oaTtkOZrGl+1UwmHJwCRNWFzoGh+1m4kYMpSoowKGJSoGk21LfUPby3nyjWc/5G
 jWNg+5BKsMl2qgW7TmCPFwuWdTKXhh2COUWORh/nzIg1P7KuonSJoDB/RCWQCwzcKeL5SqGW0+E
 yUzOforj5idzUMW00p7rL5vwRperRek7M4IvW/FU7+S2Td9i3heUlWEWGTvyIlGEJ+nUIDuyUDK
 eF159GQy1Z5a0RpxDnA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE4MDE0NCBTYWx0ZWRfX8FPxPOLUKdT0
 jQoBp/3QaabZjAzwIJJpGeX7K0X4MsolMLAEs6mhBcvGrHkfeAwUxPh/DjFoJj4cb94lz/hbOEN
 VgTPhfX+HDz8llEY96m7XefQmjNMvKE=
X-Proofpoint-ORIG-GUID: xahzK6128Xu_4qgBvIVGZhiiGXWsGzpq
X-Proofpoint-GUID: xahzK6128Xu_4qgBvIVGZhiiGXWsGzpq
X-Authority-Analysis: v=2.4 cv=adH0Dhot c=1 sm=1 tr=0 ts=6aad1121 cx=c_pps
 a=mU7wo4rWgHT00F++7wGdfA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8
 a=sozttTNsAAAA:8 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-18_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0 adultscore=0
 malwarescore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609180144

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
index a2ad79bec105a..cc02449382673 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -40,7 +40,7 @@ struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
 		return ctx->dev_data;
 
 	spin_lock_bh(&dthe_dev_list.lock);
-	dev_data = list_first_entry(&dthe_dev_list.dev_list, struct dthe_data, list);
+	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
 	if (dev_data)
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
 	spin_unlock_bh(&dthe_dev_list.lock);
-- 
2.34.1

