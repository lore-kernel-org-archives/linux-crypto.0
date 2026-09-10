Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B83845A297;
	Thu, 10 Sep 2026 10:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036975; cv=fail; b=kRDGb84knIVXhhXNWEUW7TcSoQiubogn6Go1cWJtXnBC8l8dhKPUqGaMT/Z9xOWEXoOCIJkUSFDtxv4qdAq1CSTQKlTSdR3q6ECVTZX+9F2M8RFAVy1F/wyGIvJBI3bBTDGc1Ix1qRSJ/fmJPQ1NVr2O5gYn/3pkPhu2iQTGyTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036975; c=relaxed/simple;
	bh=3l+N7VRjb7sCYwjUPdOx+NEFhmC5BVJCOEULINgQzmA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iYnbLr+oy114hTjksEPrinnHR69kJxgshnZFD410I4262PA1vRtTKukDF3mL2KbtDspdF+LGv9hkGq02NG8OAnhqhg9NeKVsu35RcAYHFVSBAULqQXSXsbSPh5IrFlw/iybLYsWrIwfLcYl+0b9MOj2dhErd8EIxZ6QziUq1sx4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=HYKBsgk1; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=AyPYk5Gm; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="HYKBsgk1";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="AyPYk5Gm"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68A8oV9E2934064;
	Thu, 10 Sep 2026 05:42:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87
	no=; b=HYKBsgk1nHAzWC2P+OL1q6m93tl6QZR6XFJbeeXx1WDCxeo18VtTqfg80
	qY2l0KwY9TKeJxmES5sNKOPyas22UcaTa3Z86KoJOppBbsbPfJPuHPYCQEgTHCY+
	fa3PlV7eB0L6qxT4tUpJd78qI10TrsOPYtP/jhUmUJnRDbOyX9W7C4dDbI+HlQ9v
	YUSCHishsPgDEPWeYfJmNAICq7sORbuDTo9RgghtIH644j+JFHmjvGqZFs4OeNV0
	jG7FAKBmf8uuTntrbxcH/NZzWBD07QQf7Mw/DKqSxrTtgiAj0gmZ/IKKnRVpjqcn
	lQfQVu+0kswZVZlhOFTgYXeg2Rd2A==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010065.outbound.protection.outlook.com [52.101.201.65])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gkcxg4xgu-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:42:44 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YvXNU3PAXbyIOXaLsqJ68PRcz7+/QI+oqFBQxozqc4ViufFAfrDfUT0r7kJ6Qha0c7Suhqb9cYaNHVokn8d6Hvti1UHfeLrRl9fP2Hbu1ugFL/Jmp0PM3dxLqmff58LmLrcf0IQpvlE7vY+fTorVv9YUmUZsuKARBnGXTnXyJLcqYVkcvWa9pv3EArPISWlcSy5cPXulntvd0AwtNdDfwsNxFukdwX6751hHyJ6rAipnKZUTDm6U+schAxunQO3+OG12lhg33wjAUDl5z8o8B3Xt7tQIKk1s5fX6LjL66B0EXTtHhsyrzXB243tUrw+VBZjqx1LLUX9u0Zx8h6dYQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87no=;
 b=pmWnyFTy9fvGuVKARPCJUvt+fJX5U49g/AHa8X8RCUClG3F7hKQQKpRJ/dmTqR8ng87d1j85PrgprzsGyyCXX6vn4/0HDLQUzFYBxnfDT9YTT0wLa1aozRa1ntmEbMuAcLCRlxS8guiezZOMv1giVcyzEv2m2+tiQy5RH7FnfyCzJ6iUXKblUuCxF2782VO3lJOxDB8cSiPzRCV587DaeQ0D9MT8mTOBfm4vHCM8bqbhj1/bEpP+zHEz8n+K0Og+UrVhiMqVIypw6UP7K0IUGHleU5a2EfFgj9O7LbOyLN5hlQD8SP/xUKmdl7EnR/wrYRrT/AVcrTvdWCX60VC5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r76QOfszn/d06cjyEn+KvN63bOkOlgpaVUcFIgF87no=;
 b=AyPYk5Gm1CbVyZL2wLby74ZLq67Mi7/rLTrzzWOR+QjglSrrkfSKumyLknSIHLle3fjkBHLpl0VJn4GfnN45gIvTDQF8UU+iB3k3ycXWfcQHCwQ7nDwEdntw8UZv1aLLpYmd2igXLvaD6SZTIe8/xFRlFkgplsRa+7yFBre81Pk=
Received: from SJ0PR03CA0102.namprd03.prod.outlook.com (2603:10b6:a03:333::17)
 by CH3PR10MB6902.namprd10.prod.outlook.com (2603:10b6:610:14e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.4; Thu, 10 Sep
 2026 10:42:41 +0000
Received: from BY1PEPF000264B5.namprd02.prod.outlook.com
 (2603:10b6:a03:333:cafe::86) by SJ0PR03CA0102.outlook.office365.com
 (2603:10b6:a03:333::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.8 via Frontend Transport; Thu, 10
 Sep 2026 10:42:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BY1PEPF000264B5.mail.protection.outlook.com (10.167.242.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:42:40 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:29 -0500
Received: from DLEE205.ent.ti.com (157.170.170.85) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:29 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:29 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgSrK2177497;
	Thu, 10 Sep 2026 05:42:29 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Mert Seftali <mertsftl@gmail.com>, Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, kernel test robot <lkp@intel.com>,
        "Dan
 Carpenter" <error27@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 01/12] crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()
Date: Thu, 10 Sep 2026 16:11:51 +0530
Message-ID: <20260910104202.1537226-2-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260910104202.1537226-1-t-pratham@ti.com>
References: <20260910104202.1537226-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B5:EE_|CH3PR10MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: 450d6d28-ac9e-4835-faba-08df0f283d09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|82310400026|1800799024|10067099003|18002099003|22082099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	nTYSy4gXnOzVvgOQ5dxDIknQ7jcPGiaUEhLiej6VhqAK1RPJHLTJv/kqTic2cf1m5hq1jiX2noh5viJdMaRLozKoPGgnBn1HmrCHI8qbj/3X4HlcevjFt2ePTy87B3Wbq+SkR+plDYLPs0IL+SJIzL6XS9wUUlzUwSO9UIB/GWNVI6UeQvwn2sxVwzu0FjlE4XHiTmFLCK2ktAze2ANlSieQGGVtCFjFY5jo72NmbAvoYbAGYnEPnDruhUnhRfHi1wHb7DMmj7IqUoks/s6VqXJ4Sg8jfXbeREyS0hb1j2BLKR8Qg2bNJ6jZ0VdMwYzhYVUUtkV0Rkhiy2um8eozy+Jmcl+vCt5dWHViGbZswPS/HHPbpBaKh6yu27mMa0Fhn0i1tTcHXa5bbETLVp9QwMlPXX8+Fmy9640s34X3jaTtDNizCSut6VcRVnj5QQxYASsMH5lq7CkBj3prWFI2XKsF3BNLyqyxshBB7eo7Ei8t2CBBlmIfsFFUglirP0uyU1vOUoqIzb21zxA9dA9IwZ4eftTmWY/5HSHY9cYYytubHAkXaJoyxNx+JUZUTT+XnidebkW5JInYCRevC8uFAehxCPLy1h7A8NYo/2z8xLHqowdJ/0Tu6TC8OgNPP4XwTsfRiN8PphxyEeSfoEEI3w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(82310400026)(1800799024)(10067099003)(18002099003)(22082099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	e49AzYLyvC9WkKBmKPlEXmjGkTciZsJ6CiEJnH7pk5F+mIYNVuJvzWa9383bD0a//VmdvQ9yR25UTvkbe+FTyRCskJyKi8wJyTupUoEHjnmce4P6kK41alThyLYQQe0Yd3Op83ztcOWRobyxdTO9UL+ohrh1P3BjW/21Qehi0WYGFgMn4VzrkKh0zmdO2GiaxfcJBYOZz2U3kUuvPF2eOHGI1c4l8dirFePG3FhXJFNbjpa9ZDVlnuZ46POjq8Rqxdt//vhwjKMFNXqSzaeZkRqfro8edQUtY1a3hWP5/VGcAHlkt8pHHS0MwRUoXfysPLzahOACjHjA8GU8NBsWbwdnh/Pn1GryfQwOImc9OFm8WvU6PWqURRDbh5r6xewOO1xpaDqekpcdVAjpl3lXfVBp4+I5y2Ep0HmXC/x5SADIxNmKW5xBS7S51ZNCY/5k
X-Exchange-RoutingPolicyChecked:
	madZF5l989HRgffBWACqXG44m2LDPaNlVWxasmtKqxeMzwXksYc7cB0kNTlAIAmdwkuNe928fDZL1WmtqJ3C/8F8qZ0MmSdl4l33H6YNXDN//QxaQuQQ8NrJGAMAj+H+bubzqMDjgV2wabsESZNFYftIk0/+6POERoVcYQgB0i+3tXxu8nF76Cmg0WSSTkhFMdDepXflWnwuFZUYcw87M2EWHGpkqNX6KmdMF3bc6/ttaKCG0dRldv2vsO8RMNmXM3WWOq/Hh8BtcTDRblEOJp6UEKKqtdjCGgDRFho1NmricII6C/+cnrXlQsJhxvwD1ezp7JQZ0il+ei6K/Dvq1A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:42:40.5679
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 450d6d28-ac9e-4835-faba-08df0f283d09
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6902
X-Authority-Analysis: v=2.4 cv=MpPHeGae c=1 sm=1 tr=0 ts=6aa289a4 cx=c_pps
 a=Lj9o+5Kg1g76LDS8oSCIAA==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8
 a=sozttTNsAAAA:8 a=HYHyqeARaHjSmq2Pe6sA:9
X-Proofpoint-ORIG-GUID: cUXxvipXNwbTs1Y3XMzATNNGewjuvMG3
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX28iGQJnkAZqY
 4YddLxNJHXdurFxCo4PK65ZskEJngKlgELrP8qGpVNqVxWLCOecCpOmuDzxhNrA1CXwtMGTDjtB
 aTK0tNdHyURoAubzXrxjhEBW5ip61+E=
X-Proofpoint-GUID: cUXxvipXNwbTs1Y3XMzATNNGewjuvMG3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX7kO/mlXK/+Dh
 7P5dMPl77AW7dijtqrOsw+l+WwmHDdLlE2fkSbxfl/5eU6yEoC5RahspKIBBPTPw5ifFE9EhIKT
 pjxAFtsN6in0G/ifA1nVpn9RRmLTjDF+pR/7OWOWcY8/WtRlA1UFneDPwIjhBRcA4x1TO2pP8BQ
 +pGR4VvMdrDz3P/+bxIQu+gD1EL+mdo+F8azIclRg8ZJuhXCN8q4cxqxlGNTDjCoFqhO570NVL2
 pntm3C3XyD5hLN5Dim6cjvDKpUMGQ3VKjS0AAY/Bxfv0CYzWh6RyDjDDBW3P0zHi6UYcCfXaJ/r
 3pfr0sCIduo9UytDYTfRFZAZUEK8+Ra+cd3VMWq4tlm6d9djnDFq89amlxF+YFUSM4aVrBbPgrl
 0wYDUXEpQDyJoOMxh905juyVHC8KwMu0jF1kviqLVdMNhOzHm+gz7jXsC7I6GnhE4iF3FzMrm0y
 0PnM2fwdzLkcTW1mU6g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 suspectscore=0
 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

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

