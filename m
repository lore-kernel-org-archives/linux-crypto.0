Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF09B420496;
	Thu, 10 Sep 2026 10:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789036963; cv=fail; b=WHDhDeWX4cmcKbtKAyB7Wuj50og3lkk4Vef89QdFBjvTv0/p7QbxmoUfSDwk+GCGxqCYbeUlwS5NLvZVUDrk8AoZkDeoBe5LwBNsL4EzsGdtk8tGVbtV7+RiQwtK2benl02uuF2WMiAgRT89dgbe8HtXsVRMSF42bWFvStDrJcY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789036963; c=relaxed/simple;
	bh=+1dIB9hkFHnLVLd4gpZUu0SefHDmHLfCcPbm4wYXgZk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pkZz9Xivw95nkKTpONtFjo4/FNzkut03ZD0ws+QLUkJFBNy1QOHYwZDkyJlrM1b5N408ZiIwk2CdtObVIiN6HidERAKOacbdKBYlP/3Av4GQHGFhvr+OO4g8hMyt3+dRHcHfLV8P1TjwzlOH3SdLjZZ7d5qOzxwGHkojuoYfRXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=FeSPGYST; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ulwy44W/; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="FeSPGYST";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ulwy44W/"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68A8oHSY712625;
	Thu, 10 Sep 2026 05:42:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=NW5NMUFNaQ8Qm
	uRTlu0wJ9+D052WJj+znKhq6NTAPP0=; b=FeSPGYSTD7QVe+P64FTs2xakWx5Ik
	kjftlAl24lOgXpqjwU3Ds4Ml084bC8Z0xVp/86oMSKlLXzzImJUsX6laLlfrrMcq
	vkYs3KCHqk+tFGiOXWPUNCBwKk+APE4j11oQJLbmIoNNQpcholvbmN6mBHiYTFiQ
	2JDWcyZF4Ci0bhmuDoTJ28XabTr37W2aholc5UcOA0x81QWEmjaSv+LFtQcmdM0Q
	XFH1biqZ3j4sdm9x6MzvqVu+WBq6W4sQVJJgIw0fKRL9bKiQXDmVX4w0UVYtzvgt
	+iUH6s73Y2CbN0lc/HTPS3omoTMpNJR6+5GLlXZQI4hw/W1da+2ePOY5A==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010007.outbound.protection.outlook.com [52.101.193.7])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gkcxgcnux-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Sep 2026 05:42:34 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sZRphqDGqk0pL+uAH+vogi35+JJGP5rcza4CGpyoEa+5J1zgfHDsuPHGTQ1vKLEkzk9NyCzILEt7FvCRV5WOLpSr2t878FPj31VUULrrompj/oVDMortoTVVnxXj3eWZNoqF82dEVGla25XG9qMQE3o0aCzbaOdTWwuHEn0PYS1ZX2E/OcpZ9kNxG4v4yrqgHpEb/jC3rhWFbbQAyGjzR3WKi60en/bAwdBSR2MuxpES6WdSe42yih5y5Ffiilt13VMnmzPVS6S4J7uRwJZ2E5eT4YUCgxIhMojnx+0wxlsUlWRLIUKXjHmOPwRJ1sKDJ1YY8H6YtlPTVEz28cIbrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NW5NMUFNaQ8QmuRTlu0wJ9+D052WJj+znKhq6NTAPP0=;
 b=WGRE3JG63OclBjO0SOWEuzNVE2rN30iK6t0rw5atsdNUqC5d4huz2NXwBrdqManDjLtd4l4c0eeo19bNZ/PIip66Tl649PT0ePfZ68uacS092IznVPcM4KXmT1d4UkCmJFsEoju/2zYx2jHl9yVsrEYBfRU2S/7ERpzayMeSRWgixyD8Xap43BwGu9l+lKpvWrJQTm59Gqjul+BkbEDcOnzTuPUGWN0R1lAkuZNfQCMv0a1l8TWIz4PfcYUtCJGzqczOj2eYbkmnZZLC341KiMHO/e9g4yBI/YkiI+AF1caHLr3K8QpZ0PWOv6lIvaduSaBF1KMDDus0ni6r+dtOPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NW5NMUFNaQ8QmuRTlu0wJ9+D052WJj+znKhq6NTAPP0=;
 b=ulwy44W//dU9uIxDcJqckB7Fe6H3It0+BojmkBfC19xYPJR9BkRM0eSJ2fiF7tGyRFrmz4l5nCgvupSX/e2yIYB2T8o3fGpIfriLKFdX6BU5YIT13Q0II9DTrcq4/KijL++5ODDRy9zczaGIvoniWJKzNM1MnM8QCuAKmQ32om4=
Received: from PH7P223CA0018.NAMP223.PROD.OUTLOOK.COM (2603:10b6:510:338::35)
 by DM3PPF6AE862AC6.namprd10.prod.outlook.com (2603:10b6:f:fc00::c2d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 10:42:31 +0000
Received: from BY1PEPF000264B1.namprd02.prod.outlook.com
 (2603:10b6:510:338:cafe::71) by PH7P223CA0018.outlook.office365.com
 (2603:10b6:510:338::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.7 via Frontend Transport; Thu, 10
 Sep 2026 10:42:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 BY1PEPF000264B1.mail.protection.outlook.com (10.167.242.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.5 via Frontend Transport; Thu, 10 Sep 2026 10:42:30 +0000
Received: from DLEE211.ent.ti.com (157.170.170.113) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:22 -0500
Received: from DLEE207.ent.ti.com (157.170.170.95) by DLEE211.ent.ti.com
 (157.170.170.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 10 Sep
 2026 05:42:21 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 10 Sep 2026 05:42:21 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68AAgKb13149910;
	Thu, 10 Sep 2026 05:42:21 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Vishal Mahaveer <vishalm@ti.com>, "Praneeth Bajjuri" <praneeth@ti.com>
Subject: [PATCH v3 00/12] Fix several issues in DTHEv2 driver
Date: Thu, 10 Sep 2026 16:11:50 +0530
Message-ID: <20260910104202.1537226-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF000264B1:EE_|DM3PPF6AE862AC6:EE_
X-MS-Office365-Filtering-Correlation-Id: e05f3243-b03a-4ec6-2271-08df0f283725
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|376014|10067099003|18002099003|56012099006|13003099007;
X-Microsoft-Antispam-Message-Info:
	HaKNeZ5TXJ7v0VRHk6Vt4TQK8T+PkusujuIsNLreEa5yan4NBgWOYZAn7QkjMsRPKIObFGXqfVcOoT9v53Djctqj7C4rkhHVNSFZp4eQ0Z3PB+dYrjha+iew+oPzJ2qS2E5SCXI7yDz3lxXsOZsvZfMncEuSI+OfBxhDDrgJWBF8WmOgDf7hh5uEmZT8tN4dcEJtMEsSpKSd+oB9bn/zNJZLlA1cwHzT4eAq5P7uJK46xl1AY6IFlp6COzauNQgtwtmrk139WM2Q7EVrd8nXbffwpu+Xz79eDmDWj/E+F44pp6WlC7Yl0QB1Z2Gkdy2s9u9633zhzIDN56lkBPNAxqzO8Wj3d41fZexavsoS52NetP1Do46EDqzSmBWmKNfTwdzAwN20tRpunECmw5bvianTokEyXRp6Aw7S1CiBhzmNAz1HOXh78X89MU++r15ZoGOnYqm9RAZHh2O+/+ssprS/AMRVyEM6XBsfsn0sYXXd6D/+hru/1yHvYJV81uIo1jY7nBW8K7SRH+1CHfk7omJbJNF1qK7c7ylhlQGEW6TPh4ae2G0TE50A3nbC6P5tG3SW0tQ68x5ZNA/mKCvxIftQwOkne175Xkt7uB1o+oqYWhsXumY6TvLVIxgDKeCB4T2VdgaVpsn22Q8zb5nYfQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(376014)(10067099003)(18002099003)(56012099006)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XadL8xFT4W4FzWSgoXejSzhgThpw09oR053Hj1KqbP7FBUxm95eygpWwpqW5+ZTQsZ5btnhAIvJ/q5Qa8S4WTK3xTq/eizcffk7eZ/ZdzFWm01fkBbSAmE1Sytb0ik2rm5BvTuzUA60v/7yNd6V2JE0XvFvnKUeqEpUiQQhchYB40zHRU6Z6mOONV8aXAx9rlAJAn/VBXJwRF+P8RCPmBsyn744fGKOQS9yZAViKYHQHsNfgspdjpO9jv/uJVVTKY7cWMHvhzTocPiawC49nzENYgm7vU4cxkWDLzL6YkLclFRtHKU5c7K390d3jo/BPJwDwGt7/HtbCZFMDFUazjxciAOBvMR+UyMir7e091RQUH0TrjXprFJe+qV8Kr+KAnk1ON4yKjiV0L0tTlsvnzyPYajK6UdWBZ64pxss7jkCrkHt5toth+JMQSuMMZBwa
X-Exchange-RoutingPolicyChecked:
	Lk01Y5bKLdeBRQvKMkS5cSnj2mlkLPwYxYMnGbICp1ccQEF39L/RemgM23OnnN9DcOkB9mkiuxx/xrZ4VHuPiHY+5grTcE6JUTAj8JEFP8VGmKdW/TigDMoYLnVpoys1CvS9sYhtyYLXWR1bIPLjZS7GTGPLFj+vj2hGNmpFl8DxcK6DDsOXMJHnZcGHFRfOV/e6I3w0IpT54rAdhOCW/9mWM2ATicaWPwJ6SYrJmzdXr/Xl7FwfHfZfuwIjsb0BGsc4yK1LoCYK9mrZ96qE0UDxQ4bdtXOzGtmPeDSV5b3nngcDPBzrB2xJaX+19MlA+Nawlr0FxzwvZzaXrrUczA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 10:42:30.6859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e05f3243-b03a-4ec6-2271-08df0f283725
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF000264B1.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF6AE862AC6
X-Proofpoint-ORIG-GUID: At4nItyIubdLcra2wbJsnakh32owYUQI
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfX4ykwbr77Tt0k
 iZSqSF2rMAwAzGPbOPUDaB4vgaMEGKMOhQpetMnw10NVBZG8vPoZ4KdcnqsGKuIk10FLwaTlu5Q
 6yqCZ8aM5GLjWekLND4O6rBQqYjrhzw=
X-Proofpoint-GUID: At4nItyIubdLcra2wbJsnakh32owYUQI
X-Authority-Analysis: v=2.4 cv=MqbHeGae c=1 sm=1 tr=0 ts=6aa2899a cx=c_pps
 a=4LksaTFCu4UF49iUfNHgJg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=VdqzKS8jKosA:10 a=s63m1ICgrNkA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=anyz7pXEI2FM5XLJWiMA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTEwMDEyNCBTYWx0ZWRfXwnRTSigXN5BD
 epwKYIs/9YRP5Jg8spNbWZj6ZgfvC/pi/AItIjWymK8XO4d7k+RRlDg8SZAID6xfs5lRvXWfVdX
 yR0bfNiursRVFlMz+6rodVckLgmAl3KJVDUEhPj2uIGPGJIA6LOx/1bYhXwTXIjem7BQAn4Jclb
 FXLb9/rAJMnane2YDp4j2iZHgFm7ocu69laS9LPVySQxwturCTTjRQM+sCMRextOlTViXPmTiG6
 BdfVRca90EGFOItbSOFg1yhNCq6G4aZCgH23HcFys1DTjxLXecGTP6HlYbijgzZ/jwQqSfoyVAy
 o7AQL6fF2nYmkLPuwhl4FikiwGHR9MLhmirk2PiASRpRz4uLqQ+OX3NJfR+kE0j+k+qXj5oGM3s
 y9qnylBHvmOFyVUBzWl8lHDwZgjhhX2A0DWyXVs92muOiyrVe050DdAXe7nGEPUdbI7zlcCbNU9
 BoPsRsf8Xd+IeaJRVZg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-10_03,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609100124

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
v3:
 - Fixes based on Sashiko comments
 - Some reordering of patches
v2:
 - Fixes based on Sashiko comments

Link to previous versions:
v2: https://lore.kernel.org/all/20260827132318.613876-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/
---

Mert Seftali (1):
  crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()

T Pratham (11):
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

 drivers/crypto/ti/dthev2-aes.c    | 269 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  47 +++++-
 drivers/crypto/ti/dthev2-common.h |  58 ++++++-
 3 files changed, 262 insertions(+), 112 deletions(-)

-- 
2.34.1

