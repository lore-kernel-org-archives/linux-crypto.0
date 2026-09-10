Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2428563FDB;
	Thu, 10 Sep 2026 17:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063035; cv=fail; b=VFrDBI9qxcSDEFbQnkFBpdJQYl21Gm2YKfJkLbKDDO5pPQ1Wjjem0qeydtqM52lbwW6cWx0BXSwAwUJTePbnis5G/F14sLUgmBgHohIShq5juDF/1cfnr/qJxxrF7hAZ6p26Tm2thQm9tbR8Sw4YQcmfWguMoNzrfOCbiye/KBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063035; c=relaxed/simple;
	bh=3l+N7VRjb7sCYwjUPdOx+NEFhmC5BVJCOEULINgQzmA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P7WpbQEEVsTKL2NAFuo/KMgQKV2h1RunDEFopqOqOlvqalkVY2U/CuM+zpUFN6ug43WjyZlCMMYvaLTeVRTsRZXBfMDFQiE3yjPI1fsKuN83kvra2VkPLmGifkpw16LIZNzRzfTs/P+1hyXMo90hydLHYT0HJ+dpFB1xG3DPoXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=mR6bCtAF; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=uBWUaG6t; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="mR6bCtAF";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="uBWUaG6t"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68AGEWLK3808361;
	Thu, 10 Sep 2026 12:56:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87
	no=; b=mR6bCtAFoE5jlu+5J+aQ5pKUTbQ1nUZE1uIsSmMaV8i5Yy1VB5GxCCc8w
	9vzc2O7OmgGuITFVVDrXzQd427/Pj5GNvIqphGn+5o77gQbkFf0gkP6Amyps8fnl
	WwXm67xZJ0xSu0vhPDFcVYHEP4FAS2HtgK7VMKo5E6MHsQ6cSbJgFZNaFENdXcFY
	YSQrb5Njx3TqgiwmjgtMOnDMQjKeUPpqKhPNAg1oXjbXuo5mR3qlQ6R8Fbiob1OL
	76yXNnDoGxKzEi8Xgm9DinIRgCO2wEjdosksRxV4IWzAnSHOhnNIDCsWfgyESpYV
	K1u+sCtScg/N7NgK3rcPk6nxNF2Ow==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013064.outbound.protection.outlook.com [40.93.201.64])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkyw9gp0h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 12:56:59 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m6SlmtVqHa2AvnHp1U/aXHDKdORu6LnJIiQ5pWD41202bXggxDcmcgZGRNtg/AuYoECOv2f8MahSK8DvocL06LuR9lz2uGJ8E9Pd0z5DI+iF+m0cSpog/H2aiz4Qtb4KHFX1MD279dJ0GqYqtdKH6CCszdCB/hDDJEdhBRxLQDbefcQBLQB5FHmR7XEU2k7LqS7kUtJlvnw+xDrqa/VCChsOZI4j2n6jORWE8kRpZB9C0anpne8wjo5ZBXYtTfEpT4pi7h2u+EsdhpjSewA5SNev5bkT1uIHWZGqkOltZVgckrywP6oKNxOppUcKo8WoA2CziBUTG8qk+VgbPrONZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87no=;
 b=kxjC0bdo6baRZnE3tcQTmn1+V2jjW0+2BpKH6D9dwxJfnBkw/5I/Kkq0TIXRJi6SQpNXVM8W8O4AEGJvBq5hTFCjt3CnxyXl8L17mbdCxYlJty2uhCzVL/wdK7QwcbNqFBzTsi1b9cYOgiGI1NivuQ0a31hZLQJJKsiXvf5sT9+zG/qF6JjMYg+ZeNIk8D0Nk+uT1/gSodoN2kqcCR+ZFIJcEvjEgBcNRIOIEXhrTLkDp4aorSElmk+/0fWiAO6ROfQHv2pk6k41OMwMzVXV2N5TG1zmpZt0JCuQE08zFS3ZNApu514gMYtm2byoNDHWCYF53SKfdngRLd2tpe/IiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87no=;
 b=uBWUaG6tIetZuA9NoPKmlNqDbiBlEm9pCsOGA9aY/R4z1wOq7Ax7XSDJej2hkE+2ODPUuzzYMzutGKMnpD6zyB3CbGvfqURFuRZrJ/In7luQ9mQYyA4NnJcz+Na4Xnn1H8ZlA49JAcXls38kltAnN4mEDlk74EZ359wxE7R7wKY=
Received: from BN1PR12CA0027.namprd12.prod.outlook.com (2603:10b6:408:e1::32)
 by LV3PR10MB7795.namprd10.prod.outlook.com (2603:10b6:408:1b6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.5; Thu, 10 Sep
 2026 17:56:55 +0000
Received: from BL6PEPF00022573.namprd02.prod.outlook.com
 (2603:10b6:408:e1:cafe::63) by BN1PR12CA0027.outlook.office365.com
 (2603:10b6:408:e1::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.9 via Frontend Transport; Thu, 10
 Sep 2026 17:56:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BL6PEPF00022573.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 17:56:53 +0000
Received: from DLEE213.ent.ti.com (157.170.170.116) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:37 -0500
Received: from DLEE204.ent.ti.com (157.170.170.84) by DLEE213.ent.ti.com
 (157.170.170.116) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 12:56:37 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 12:56:37 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AHuZG62793554;
	Thu, 10 Sep 2026 12:56:36 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 01/15] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Thu, 10 Sep 2026 23:26:05 +0530
Message-ID: <20260910175619.2122149-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910175619.2122149-1-t-pratham@ti.com>
References: <20260910175619.2122149-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF00022573:EE_|LV3PR10MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: 5029414b-e001-4bed-1abc-08df0f64e585
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|376014|23010399003|82310400026|1800799024|10067099003|18002099003|22082099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	ubiLvY4PD628L/cPokRgt+fWoUAg/Y97Ez/YD3kd3Yhdqpk3DBKSTUV1kflSOuxfYuaz8xwpvtB/SlIRQ7nGsS349YQrAuIiVOuf/0eRh28eaN9EJVY6mdq0eDV1ET18NLESlLXp99t0gQ8FYDHIYMFAGK8zfclXiER+3HrGhxBRHbfFdmO+hphzxTwMHTm5vxodTY1XoegVrZJxskUkuRLh/QUPpUBwG2gfny9JlbsOro0bIBHIn0bMHpHOYaO4y/sgbpIXlJe4IbXH9PjSUOnRoqOv4vbEIuwqa/zC18AV+NkunymAO/NK0Ir4TOG6WRNubmDfGd+/lyPU9+Yw+x54BkA3KzMjbsdncjcXtD/qNoBa1PYeYAGFCeNBJdEn4ikhWiSkJmJSGyuDoNBTo/NyqyRN3xySgkhEK5AI9KwcNRq6+bMnidpys8gKn2lEoQhkmvhooXXWTCxc9SKr0tdXvKN2dDYzYSkG2NMpASVgMPZIW7NoKT0P5qrVrMnT9KjXQstcHZQSu5fQUr+2OcozYQL4y4rngU4TbZWLc4Ja1ooWTzNDVOII1mTNBf1aAsv/dFcgDJw8gixaitdAqiUNTSJggbk0jnNTEpqLZfV4oEKBZZwHD+ugmHcXinxcmfxfieSeb34d+lYSMXAjvQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(376014)(23010399003)(82310400026)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KE5rOVQyTLarYlnDxpKnAdsuox7ZPOzl0rjraKHpNHFumq25AriymSwPjTjck5tkmArjA2p0svC39wuN6xiEUGCZi4EEa4sYhLJHlTkTmVmYFxT/0V7aVfol/yrpcMEDOBBCeIXsk1NfGW83uDw2H+9KEDPY5j2dTSBZnBG24e0g80BOsQ3+QCmqYe+X00Xe8dIduKG6w6xWPuHtEPDMfp5ICP5ZYx1n5MdGkNCGjKxrsScR3eT/qL01uKJH4bgSF0UaCT+5KvbqPO1urR9b1B/0OkjQSQux3fOwcJtC5k6ELpbqFn/PQS2A30nZOZh6K1oKvWJG7SvUAOEE0/AJhxR89kLCH0kJ8xkB0oUQhwvGWyiCi/5z954AwhxtmsXEQSvTYSzD2ASWxpAN7ILlywMEGILTuIAl1iUG5yBoEMmM4ta+npuggxaLQujdX4+V
X-Exchange-RoutingPolicyChecked:
	VJ7gI4YlRWAOBiSvitGFPtx9ah/X7F4dB4QO7AqOnssZb92boYiT0QUvdTI1FKoVR9UucweixY6u2cLyRTmJQwuqWIoVNCTqW/s4PmHv/8kh80hwwkEulV5QVVj+MfGaEizcsS7yBUS8esHAmNbkWVvq38sVqaZf6eNxLHYeVXroHiF/ee58A6tMaA8Dz8Y/PfUD0hSycpodpkFCZV7NjsfDVjamUd7ZTqaGUe/fuUgzYIvazNYan6zI4/deT8a+kt/XLSRjBemk9q9Jo0GoaeBiMYOjBMDpREYvsjPPG2Ej8rMiNw3zOAzVgyYkPWNc8SsMGZSQ1EKeMgrwVcotFA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 17:56:53.0555
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5029414b-e001-4bed-1abc-08df0f64e585
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022573.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7795
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfXyZmK2U1Q1fJP
 EWDl1FWTi3cmYH2ZDXOBbl5aTiIuOv8ql76z+4AwWDE0sAIh9h+F5phGvGXG28pj9nfxZSswTCL
 KQ5PJctnQl8qP0FtPl+umt8rhMXDGgE=
X-Authority-Analysis: v=2.4 cv=ON6yTiaB c=1 sm=1 tr=0 ts=6aa2ef6b cx=c_pps
 a=ff0lUGClKvTotTGlvMT8aw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8
 a=sozttTNsAAAA:8 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-GUID: k11WqPHmEpwnZhFGGPRLRO-JaogfU8Ar
X-Proofpoint-ORIG-GUID: k11WqPHmEpwnZhFGGPRLRO-JaogfU8Ar
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDIyMCBTYWx0ZWRfX6RQQ1cLLehMj
 GY2gYA8Eh/kHkj7RZ5TBI35IZYH7eRALrb9KMy8M+8BrciJtZSYJiLIA77XwJPT07C/gOyf5ECQ
 DBvjrrFNMpTJ806c+F3bibGMyCThaVGoDoIiq8bLzj9iJ9oYWOpMnCbzjRrMgGjyHWl27+1eYoK
 v//Jd78hVfdGLVqpiqENL/7NttCxcKQMYsxqcdUAEmzR9FAh+UraoN3GrQ0SsKs1J6MHQy3gGhL
 qyeneduI0C1VaEPvBEh97tfw2HXkCinNPuMXqTYSzIgJ7fMO8KGCaTpvXtmsbQeAscC8s/j24qq
 XYGNDVIb7SDIzCSkTRLDKZgSztqPZu904n3uoL2xw/HROPmFMAQb1Kb5fnewd2J/hYTwNzvp9j3
 PPgmtjVUneJFb43D1KlwkPdsudXqGlE2S8/SHfGN4+eD2h0J8Y0GEwqgV29+23Kb8gAiJ4UOksL
 ZcLmxecOW+nAMvY1qRA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_05,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100220

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

