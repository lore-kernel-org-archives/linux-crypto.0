Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1513B9943;
	Wed, 19 Aug 2026 14:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787149264; cv=fail; b=n2M/M0hpZbpBvGmajVv23UAyxNBG3370J0dyVj+dcwTRBVfS+cY/L+svIYwoCFZx3V902jdtaQVOfO7C2M2YqalkhN7btQsuXFUZ+IN6nYHDug8mlcuRSrXNhwTkru4/z9LQp5KyGwSGkkGgEN0Lh3Jj5z9f9G+QqIE79CQ2CJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787149264; c=relaxed/simple;
	bh=/zrWGwZT8sWwZidpqHWFHoMFfAne4ltFdqXVenGCBi0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bqB+rZv7mNzhqgrZk7/DWiYE9eIl9qeaN+/r+h75GmXd5KahvEA7lIrrt+DAY5EiGdsrw6CpzcIe5mqfj3c9/umIX8aSU8g5bdmBBrdPOllJl7Qw45AiBylelpnIp/AICxsskUjTTw2YD62mxcyMdOocY6hMk5i0EtXctjC2VmM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Lrl3Kv10; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=macnAhll; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Lrl3Kv10";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="macnAhll"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67JCncPf2116230;
	Wed, 19 Aug 2026 09:20:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=oUAxw/ppfmGd4
	12drnOy5RhLSk8xCyshV+0PzfM7uJk=; b=Lrl3Kv10kpCNLYDnlkVLnPsNGCNWV
	89Chut348aHiUf7mcfGGF9ProV5rI6IWinSJfzejTTXwNCDej0Jy1Dgz2Fkyo7nb
	NYf+YhhWtxqjLMjJFx4yUOpLkXDYhlNFr7w7SZvtVK4iLbRKe7pisWblqbFcWmGq
	DN8dZ7HwvEfbcWqS//uAsbBUmfUNAl4RYjuniP9Hou/YCmyg+Eh7xbXgsv9ym016
	uarRdYW3oahc9dvHormJGgm+ApH0zAUN33FNxnqH8LFuWlWuXj1jW61XXoLzXAlm
	EWgsUOyFcHqw2Wij3um3JZLoTCnkFA671pPVxGJ11kkbVnbKx+grNbtyg==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by m0384305.ppops.net (PPS) with ESMTPS id 4g4yemn2mw-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 19 Aug 2026 09:20:53 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WypuSArxXoWSC9yOX0eoaqPhZctj98DWvUXur1Huib1Er502qxCO1pfRZqUm0utUIa+VAotUoOhYT7p+PfUmWqxDFL5cz4SJBW3sG8KvLpEz1Jil3uhfOi7iLfGKhZeBFMDoZLc+6/7j3rwfEzLdl/MznPIdtRefU+CstqMHbz9M2azSUsyOUlf1Qk5CZvXZKsK2FNV14SwExbAZ4lqejfcXPVGeFN99kSYj6UzVDIeFyuNWEKjvcfPUXikumMB01QhFasMzVEiVnpJcOK3mEj/3Nj2mw5SvV2LtGSVFY9cAd8X/JdJDfooIa9tghIXeY2OKwnQ6XcVvugJv5wF9cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oUAxw/ppfmGd412drnOy5RhLSk8xCyshV+0PzfM7uJk=;
 b=HhuJ7tKuzdz4TToHPwWTjLH8agU31qDQqe6FYldXGIE71c/wA6iF9Uh3hyN4c6p9Kd++RaQXfFi7pJRuyocrqr0BOELnAlmZAduBz9I8OxXY29Dc6MOm6dtrOVp+I/s/7Twbb9iTgPq0dHOquTC1j3Wx2DhjMwQr/PoJzR2VcacXeBmxOgHu5fSoADgiERm7lSwgznkM05albVsmBwYlQW0nd4lcz8p/FszS69RYK0aLtpWAGVVHxYYGSuXNidkoKxQJAudHqyviz8Seusf341MEjdWCgw8PvcwAiMnL1yhB7+L9VRfEzMX1SF8kGR0cxpafEO6C1qNQDeWdEnfDzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUAxw/ppfmGd412drnOy5RhLSk8xCyshV+0PzfM7uJk=;
 b=macnAhll9hHdgTwmhVVWrw+2ZT+c9pJEE6C3vlqgi5fufZblCCh/t9mY2K6JWU4Ic7O477Ooxl+oW8FfxquA0oV6YhOUmzusMrVG7EesP0ypfBnypjW3XzeQntM/KZNw91osgEU3XfgPk7aPaVTTcklIdzLymm4nUsWfqRNGcyQ=
Received: from DM6PR06CA0087.namprd06.prod.outlook.com (2603:10b6:5:336::20)
 by SA2PR10MB4490.namprd10.prod.outlook.com (2603:10b6:806:f9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Wed, 19 Aug
 2026 14:20:51 +0000
Received: from DS2PEPF000061C6.namprd02.prod.outlook.com
 (2603:10b6:5:336:cafe::5f) by DM6PR06CA0087.outlook.office365.com
 (2603:10b6:5:336::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.8 via Frontend Transport; Wed, 19
 Aug 2026 14:20:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 DS2PEPF000061C6.mail.protection.outlook.com (10.167.23.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Wed, 19 Aug 2026 14:20:49 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 19 Aug
 2026 09:20:25 -0500
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 19 Aug
 2026 09:20:25 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Wed, 19 Aug 2026 09:20:25 -0500
Received: from toolbox.dhcp.ti.com (uda0492258.dhcp.ti.com [10.24.68.110])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67JEKLsS3518310;
	Wed, 19 Aug 2026 09:20:22 -0500
From: Siddharth Vadapalli <s-vadapalli@ti.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <stable@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH] crypto: sa2ul - Fix stack overflow in sa_prepare_iopads
Date: Wed, 19 Aug 2026 19:53:55 +0530
Message-ID: <20260819142357.3950463-1-s-vadapalli@ti.com>
X-Mailer: git-send-email 2.51.1
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
X-MS-TrafficTypeDiagnostic: DS2PEPF000061C6:EE_|SA2PR10MB4490:EE_
X-MS-Office365-Filtering-Correlation-Id: 59f51e4e-4a44-4f47-e359-08defdfd11a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|376014|1800799024|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	6WSr6wxkWP0OtJRmNU9YHmg/+njNCy1Ez52EjJEYmVNyaAgGgLTKFShtqDfxGrie2Rkicky0G0zIjmtaxmmnziKQ95d3EjVN1kkhj90/SHQ9We3x8mTsW1SjyEIdKCvAHuQ5UBJkasMpy1wG3US7qfLDw8ZOYsQyM6wLZ4Un82ZKX82nf+NpgEzfxGnbiiz8wfLLHTVUhGd95Z+xpxFcu6kZGhZ8kHj6WVC+S43xYe5AFRGD6oy1UaknOMZ24cd+rdxaRo6lEYy/CokiGIce88cnInWtA+S8JSIE/zlKcXhP7s1gF+Vcsd0HGDONUJUAWnyI4487aWRY7kOoO4+ZLF/9xnqXYBWuWH3VolYjnakJnAg32SSnkul7bFTofEi4U4zf2tlMlBEKHfNn7m68qCHrVV7fLC6U+a4qwrsySKbs9bHjq1tpLqFWRPQpL9LKZhYrrUPaHhSYrIiT17Lsr4VAcXx2tuk5fh37tzg/4CmgD864gLOCw62/frpWAkBzNkvkt+osUKuwWq6ZpPMRwbE1KVxyvdUebTtr5Lft2yVlUj7cQQCYBSq+L7b539bXacLICLAodV7N6L4v9mIyJPhxL613VNvzioR/jx6lP/WDT41kMD6pCgUrtSgYBiXZuV7haQ6+a2QyA7TDavYeTDO/3gk0YPm+m7IrP+H01IrKx0UC3oTUCUF+MsynXIK1KtDni5v9YrNZDpJ1GlFeWQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(376014)(1800799024)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3SylCarAFzq0jBxa0PrbruVGlON7J93q2eAxgP2jw9dgSWan+ew9NfEvmm/zFO0/elWxpxcukNzm3fY9UHouc1eH1y36WRMXZkkMSBn4sY1ULzmgO46T/gc6noW6jt82lF6HvH7zdO1PL6c71yyc/UMxfmZaChyExbZCS/+DVHL//bsweAIVhYcV6gQSb+JzlQyBPBRYobQfn4zST4gJ2hwcegyMDC/8gyu06AC4okdl6qCp/HMpBjM9K7sgO3Nz657Bco0053mBDdFXxtss1sKXGDGMEYlBLyuENKEm+u/rwZKnVKhLUS6xnb1IefpiKwChJQrxY4ehpYxe34CLAXe2FktrRYG6dp1TceYvCzOMzj2YyKkFkJUFi8bxH81mg6DkGdLgquhSaHYuggE4zRUTS+IxVhekJ6NAZ06BnYOlTwbEVdD9Yd0RM9B7QWTg
X-Exchange-RoutingPolicyChecked:
	DiTTP/VV4uST0Ce4G7iFKbpzp7JuV/PlYWFd0GUpz9hXxfigI/9PLonYTsIAq3+8f/HgTN6YREnJRhsWHdhqbqb6PJufAr4jRRwn+GL3VIRrcvJfclZBAtxACgG/uPmuo8mvOUueb7gYVjCTSKkcOCKEtU8AdUIk96M3gjf+C7ijGUI6gnW9sB1XtOffpdKpbsQYlEyMObCcZ6pI+IqlLgKqfI+BA/WrkJPIoqAxBXqM/BINtHIOcKRT3ZCblXiCISc+SNCDNRTLbWp9P2W0/LFKvcepMFEYKaHvrRIcaG1HprGDeauc4gY/DEiMsusEdWFqop7mAAq4VSSRHTd39w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2026 14:20:49.7031
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f51e4e-4a44-4f47-e359-08defdfd11a8
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF000061C6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4490
X-Proofpoint-GUID: Jq68Bnflb4ZAO9xPk0K4GJufYn8cNSHU
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE5MDExMiBTYWx0ZWRfX5dssVyroAkSz
 uMYovwpupBy2goWogjBTcrljVXd7MmqgPONVD2/3BXDcid8PURVs5zsFO0GCNzuamPa7Ox7vtrT
 wm3ZPqkbW/0DrKnr7wEYpjXddaykzek=
X-Proofpoint-ORIG-GUID: Jq68Bnflb4ZAO9xPk0K4GJufYn8cNSHU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE5MDExMiBTYWx0ZWRfX51G3ZU5jBTdZ
 rhJ+JWwCMEDHv1IxQ1JAQWiSTBp7ryDs/cDZz38NA7WGxylS/Eo8GQgEdo4CR/FyrnFf0ar8Zzn
 bmFENHclA1aJKbtrUH76/DE1jEcpxISK0J4FlWRhqfTpP8U6Wv4MyavJ9Kp4UEJ9UfJ3Uypt92M
 4/OEq1xN2l6jOat6NqkuPSZVn4NTEWpy8uFK+t9/98TmD79bP3O+tN4T2sn1tgPqgVTohxtCazq
 vrgTvW3Wdpmwkq+ni/zkjeeDsx1onXBZGoT6PX9lrKSJ7/lNja8Z/XxcN86JXZt4OtOn2NWAcVC
 6407q4432r/kUEDpMThRPyOnxV6V3PmAeEg5yNckZ4Cxhx/31f0yD0FUNS1FTB4lpLsmlzM2ZBA
 sizGTBlmwFuSt8zJloif/LWz0AIY1uDycq1CYYGmFNkbyKz68KRmykVsliJc3n8lJ5ItzBDevz5
 +Tav+T4SRl99UVaDrMg==
X-Authority-Analysis: v=2.4 cv=S9LpBosP c=1 sm=1 tr=0 ts=6a85bbc5 cx=c_pps
 a=KWtdrS0GCFg1xs2m4eMxng==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=XuZ3m0wUC_r101zMSXMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_03,2026-08-19_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 priorityscore=1501 phishscore=0 suspectscore=0
 bulkscore=0 clxscore=1011 spamscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608190112

Using sa2ul for IPSec results in the following KASAN report:
  BUG: KASAN: stack-out-of-bounds in __crypto_sha256_export.isra.0+0x1ac/0x1c4
  Write of size 1 at addr ffff80008df96b08 by task charon-systemd/577
  [...]
  Call trace:
   [...]
   __crypto_sha256_export.isra.0+0x1ac/0x1c4
   crypto_sha256_export+0x14/0x24
   crypto_shash_export+0xe8/0x2e0
   sa_export_shash+0x40/0x110 [sa2ul]
   sa_prepare_iopads+0x264/0x4cc [sa2ul]
   sa_init_sc+0x838/0xa78 [sa2ul]
   sa_aead_setkey.constprop.0+0x3a8/0x6e8 [sa2ul]
   sa_aead_cbc_sha256_setkey+0xac/0xec [sa2ul]
   crypto_aead_setkey+0xa8/0x22c
   aead_geniv_setkey+0x34/0x60
   crypto_aead_setkey+0xa8/0x22c
   esp_init_authenc.constprop.0+0x4c0/0x810
   esp_init_state+0x27c/0x3e0
   [...]
  The buggy address belongs to stack of task charon-systemd/577
   and is located at offset 152 in frame:
   sa_prepare_iopads+0x0/0x4cc [sa2ul]
  This frame has 2 objects:
   [48, 152) 'sha'
   [192, 569) '__shash_desc'

Commit 3bf533787910 ("crypto: sha256 - Use the partial block API") added a
real ".export" function to the arch sha256 shash algorithm, changing its
export format to write "sizeof(struct __sha256_ctx) + 1" (105 bytes).

On the other hand, sa_prepare_iopads() passes a stack-allocated union as
the export destination buffer:
  union {
          struct sha1_state sha1;     /* 92 bytes */
	  struct sha256_state sha256; /* 104 bytes */
	  u8 k_pad[SHA1_BLOCK_SIZE];  /* 64 bytes */
  } sha;                              /* 104 bytes total */
with the size of the union being 104 bytes.

Since crypto_shash_export() writes 105 bytes into this 104-byte union, it
overflows by one byte into the adjacent stack frame.

Hence, fix this by replacing the fixed-size stack union with a heap
allocation of crypto_shash_statesize() bytes. Since the contents of the
allocated heap are written-to before they are read, a kmalloc() is safe.

Fixes: 3bf533787910 ("crypto: sha256 - Use the partial block API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---
 drivers/crypto/sa2ul.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 965a03d5b27a..984b341755ec 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -438,28 +438,28 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 	SHASH_DESC_ON_STACK(shash, data->ctx->shash);
 	int block_size = crypto_shash_blocksize(data->ctx->shash);
 	int digest_size = crypto_shash_digestsize(data->ctx->shash);
-	union {
-		struct sha1_state sha1;
-		struct sha256_state sha256;
-		u8 k_pad[SHA1_BLOCK_SIZE];
-	} sha;
+	int state_size = crypto_shash_statesize(data->ctx->shash);
+	u8 *sha;
+
+	sha = kmalloc(state_size, GFP_KERNEL);
+	if (!sha)
+		return;
 
 	shash->tfm = data->ctx->shash;
 
-	prepare_kipad(sha.k_pad, key, key_sz);
+	prepare_kipad(sha, key, key_sz);
 
 	crypto_shash_init(shash);
-	crypto_shash_update(shash, sha.k_pad, block_size);
-	sa_export_shash(&sha, shash, digest_size, ipad);
+	crypto_shash_update(shash, sha, block_size);
+	sa_export_shash(sha, shash, digest_size, ipad);
 
-	prepare_kopad(sha.k_pad, key, key_sz);
+	prepare_kopad(sha, key, key_sz);
 
 	crypto_shash_init(shash);
-	crypto_shash_update(shash, sha.k_pad, block_size);
-
-	sa_export_shash(&sha, shash, digest_size, opad);
+	crypto_shash_update(shash, sha, block_size);
+	sa_export_shash(sha, shash, digest_size, opad);
 
-	memzero_explicit(&sha, sizeof(sha));
+	kfree_sensitive(sha);
 }
 
 /* Derive the inverse key used in AES-CBC decryption operation */
-- 
2.51.1

