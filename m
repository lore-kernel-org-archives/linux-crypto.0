Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A3F3AC0E6;
	Mon, 31 Aug 2026 05:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788155345; cv=fail; b=e+JmqyGcJsFdeX/HNcUZg7b3ufm5idyq2Mmt/XoN3ZjY4MlJD7NHyF9OtpcZ46rX5cMs1z/M99iQ3f6sWgiEd4fA9QY8T2MJQm8IP/G8O3LsEnqaUyQrzx487DSqeAWU7Z/0hWb8RT8Mm5q2pNtpUo4gLphv7eDWlaB8RUKGOkI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788155345; c=relaxed/simple;
	bh=/IHRSnG9ylDl0hRNqFAPp8LQMpVS4n8r/48hQ4ai1bI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ePo5syoDpj2UAc91imXZNoaDB/iJ0SKZR0OnRtXCvlLyWvf7KVcN6qVi3cugSExEbWrzbBz5mLvJH8u5gEhZyNwqOMLAEkq9C3uqlcgnLlx07NUeijGGgjK6iBOVkVlxMFvslQl9bd3XtWl9zIcc35l/TkMurX5jVakF6RDtWAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=hM5goojx; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=cBviLbmt; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="hM5goojx";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="cBviLbmt"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67V4xsp34075812;
	Mon, 31 Aug 2026 00:48:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=ZBcBKLMShVYWL
	fpEEi3G1dK1yyUjKyTtXg9NsgfByeQ=; b=hM5goojxGnfPLEHB14Gy55SOCrJry
	+1b+5UtyeabY5ZegzRjyGGZ4CBF/lKNuiAlWvYNnx/agouF09MQOOHH317K3s8//
	2n+/kvIC/lZeMh2HZ4M7My+OBHLAe84AlV0M2uFW1wwsH8ZG3si8vjzmQ0ip3nFR
	rG+2+qR7zuM8SjB+Tv3p4oAfH8YtmKer7/8goIgefyGFIcbN4C4rEHei636Li0Vb
	gajY/c+1gP+LpgKQVREn5+Z6aBE1BOs3C7320eV3ilZAO2ozv2tokmGfwEw+NTrX
	zgqRbIedEl5/VlN+FFN2Mk3wAbx9ZxuQq3b1y4JaVrp5i8vsPjRW17RiQ==
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011034.outbound.protection.outlook.com [40.107.208.34])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gcejputr1-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 31 Aug 2026 00:48:40 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jpCN5N3oNvQTcgJ63Hthly+ClEk64ucKEnE6O/p7tz+sBID9k+STJe7XS2Ybf2Zm2ZL2BgzovNYwFJ6gMJD4FTrzCy6R3/8Q3DkgroKO1kd3H/9epiiuq7MPkwV3bMrVGAY2mABnVCCK9uMFTHJCxT19cVL+3H4ixl7wY451vAI1kyThvEh59n/yfwUTo7m5GuWfapaf0drGgcPTM53nq3suwTYV32ANf1tZ2I4l0uFfbMETF5s+RxVV21th3Aywacyt4n4sfxVrX5d/RBhapa1GbRP4IGH2ayJj24qtxiCL5ihvXTSBrSowTyzMMucaZXu+sktwffaYqxPmNanoVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBcBKLMShVYWLfpEEi3G1dK1yyUjKyTtXg9NsgfByeQ=;
 b=JlxfbFECqn4SYUZaXrw1Ae/ZbmhIThif1uTa2a7gT725poSXtDeBicbKc6x6kE4joJAeMaT6OzdF+KlW4h5LrrO1NqM1xRhHtHSt1YVdSZRYb9/mjtYVOnpbxyADXDaptLzqgEjaN++sfI+IIyN3pS2xcOHD9kKl6b8x/5VjKFsx4vanLyyyJylUr8XTU75QJN3i0ohdG4HGq6uvtqG4Po6EzQnV/Zp7SJ2FFcBPGSw6MZYsnQ0eoHer1oqsDMVkRk3e1PkRr/dWz8yXnGCV8mIQ/v1OGjBqgFHNeN9RtTMEab57cQ8zNVJHeFSNDy0yH0QxGsCpu00bcXazppcaOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=lists.infradead.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBcBKLMShVYWLfpEEi3G1dK1yyUjKyTtXg9NsgfByeQ=;
 b=cBviLbmt6+MSnHmUL1UgtQbJLFgQyMKn3kOv7Y0022lqVjqLljzh4xyea56E1gImCUX2JtWs/Jkpe3aac1i3cFDd3PG2G8UhwPJfiplzM2C1hEV9W/ZfOteh/2MysNZYOjIqWeWaXnhtFtmZ4o00Yg2BMDzvHMHIqaYclP7MZKs=
Received: from SJ0PR05CA0125.namprd05.prod.outlook.com (2603:10b6:a03:33d::10)
 by PH7PR10MB5700.namprd10.prod.outlook.com (2603:10b6:510:125::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.10; Mon, 31 Aug
 2026 05:48:36 +0000
Received: from SJ1PEPF0000231C.namprd03.prod.outlook.com
 (2603:10b6:a03:33d:cafe::87) by SJ0PR05CA0125.outlook.office365.com
 (2603:10b6:a03:33d::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.382.9 via Frontend Transport; Mon, 31
 Aug 2026 05:48:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SJ1PEPF0000231C.mail.protection.outlook.com (10.167.242.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Mon, 31 Aug 2026 05:48:34 +0000
Received: from DFLE206.ent.ti.com (10.64.6.64) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 31 Aug
 2026 00:48:04 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 31 Aug
 2026 00:48:04 -0500
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Mon, 31 Aug 2026 00:48:04 -0500
Received: from toolbox.dhcp.ti.com (uda0492258.dhcp.ti.com [10.24.68.110])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67V5m1j6158963;
	Mon, 31 Aug 2026 00:48:01 -0500
From: Siddharth Vadapalli <s-vadapalli@ti.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <stable@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <srk@ti.com>, <s-vadapalli@ti.com>
Subject: [PATCH v2] crypto: sa2ul - Fix stack overflow in sa_prepare_iopads
Date: Mon, 31 Aug 2026 11:21:38 +0530
Message-ID: <20260831055141.1632832-1-s-vadapalli@ti.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231C:EE_|PH7PR10MB5700:EE_
X-MS-Office365-Filtering-Correlation-Id: eccac38a-e2f8-4ee7-34d1-08df07237f3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|23010399003|36860700016|1800799024|376014|56012099006|10067099003|13003099007|18002099003;
X-Microsoft-Antispam-Message-Info:
	GOuUyHeWcJrMfuS+ef8Pkl1TpW69TpE+kaOngSUmQW30MNhu4q2XaCs46HvFRXRX4AISXLg0FlvpFsEVuHpQcdckFW/gK2aNJc3ozsr7rQiIo9rl8w2xS3hA7QQpu/UxlYiwh4xB3lEiktQsUOYutTBOW/t/D8renMjWWvyvBcoDxG7JlJ2M7kB3CEY8bTPg9P+QwErvrgJqk50RyGEWHRpkSmTprYi4rbVq6fGSUVExp3zXw6XGszbkyrDRQILRYlSw76lGOoR9EZSDkXLZY/XGx+hjiWJamk+srKDvYQ8Eh6Bcw0QL3/RnA+zSGWKLBVTHgVj3wGxbj0F5Hn3HpdFofVVXTdswT+IoPU/v6DJV5ycwCiwj98rLfF70koa3n7YiEnd8AjfBo8B6RoxktTng2kvsPf2iztBembPOwoOUIwcctsvxLbY8vnKtTzPuKRI6tgF50r4B0CTTK6i3chXBE7xwz0ANca8KwFlhHcaNZjXraCHTGjUMkENcbxhPFEdW9LC9M0oyJHaVObGxL9+VGGRadrtUlCttWzNtmPZcF3AOB8MY1vbwey4C2biUYIQQQ6WVzyIyRlq77seAWA9diiXEs+2E91EsCLyEYjA8sHWUBSV+XvhQgxIsiOt11phvkdeETOvERFnS2i2O0g==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(23010399003)(36860700016)(1800799024)(376014)(56012099006)(10067099003)(13003099007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	lFrX4KA/QobEiMax7jzBfUJeI1OB7iDK/7Q2xXilkk8Pp1Hm09xPbBnUy3cjwMGrMeyd96+O1ep2T3RyHscupFZGRVN+lbBsyZgDcNnl5e8Ul5jHMXfALkV1Ko9EpHlA8NhvcDI6DAOUQlDRB1FkCJQ/Pqco3t8x3JH9yedO8Z6zLx6mc0jcX6//wkUbEowF5bofW2cKSIPPs8Z0BcemjKLCtjYGoh41fA3DkpHeBAujkgSXXOdyBMlxLJY/czoxPp2M0pInMZGo1IXFwRreQLMALKThIKeH5icTKlXJnKpj4STNlKvhktLIzHW27sUU1qCduUsauHnCwJ1AopfdvWFLpg2dYIpq8aEN/Vrs/NpyKXhnJnWKQWgguKm1pdMW09OVYCOuMtB67AIuANtYSUPn3w/eohggQElT4UpT6tulTVud/xJWIgfJTt33bwNn
X-Exchange-RoutingPolicyChecked:
	vJOr61sgHvZmBoXEH8sKr/Gb4KJsDdzKis0pNmDG5MZ8XdpZi5YAZXXrEIW4ipCcoVsKiDNyjzF9xb+xC//+YjQty0CAG0LJoS9W7dWoy6Ywt8kiHGPQLQcgReuL5AYbcCZ8klta+o8vjU9TE5oL1er/5YpVX31lSReHVS2uPL6kT078lNUOP79Q0eA17a+I4TKHFPEt6iuNjM/qgAZnF0o4UAhNH9X1Rl5+hHMkQsLhYFtg1Sv8xJqRr8eAdg3rZa33kivPwY6M9KjGNVODfqyJOfbnI9SdXndmIiKTrVRSb+jyNqJM/RftgCV9afZKXBbiIcrLkxDM5TUOqcPt0w==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 05:48:34.8692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eccac38a-e2f8-4ee7-34d1-08df07237f3f
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5700
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMxMDA0NyBTYWx0ZWRfX0AuoDcsj2gfg
 Ej57n0O4WrQpV3jak9d4jskAqMBZ8uHJmM8+oR5bY+94LfqCz6liORQTzb1br9O/Kj0js4C8LTD
 r6hKiIE/NqdX0GXcH//Ad57rcipLsNM=
X-Authority-Analysis: v=2.4 cv=b6eCJNGx c=1 sm=1 tr=0 ts=6a9515b8 cx=c_pps
 a=zZIwMYV7Wou7+0JapvgM9A==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=VwQbUJbxAAAA:8 a=sozttTNsAAAA:8 a=c92rfblmAAAA:8 a=AnTYPz4I4B_XLNGOx7IA:9
 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMxMDA0NyBTYWx0ZWRfXxcdn+KZJNSdf
 Olp40+RC87h8kjtGONT9lHcpDtVodCpxr2NvF8y/0nffyn5b/k6cMliZhIOxxhSJzJtg5z+yF5k
 SIhOtEZ5n98w8h51ddAhVJ0BJy1IfFilsNRN8X/LihHXOLLq9vvQQ3SW0yMixf3xNte4Td8XXF/
 vo8f02B0kCzz3CpBasrGQ1/tOM55tgAWRtNmXpvznR7GfCDUxSC19uy8MwfDpq0i/lDL0HLQpQ4
 pMm99tRWociOBR7M9aXJ1p7/MsjspbSK6dM3nl2S0BNDHzT+C4INP6LTM0Qfye606Dn1TWJ0OXo
 07NuXCK7e8SZDknCvom0CDCYy0RztySjAx4/3pEfNVvTCV9c2ySjqmoklrL+elL/SksOK7hHWoo
 eTkBor6nyoHR5ym9zE7I5q1dt9LJ8zqN86gSiI0kCzR79XEENgpPTZSjEwdtsQJISPPH1NbTa+1
 xLyhBrt1nG4SzHbv1Mw==
X-Proofpoint-ORIG-GUID: 3eSumXuCN5k_7-h89VInwuk7LSl_b1Te
X-Proofpoint-GUID: 3eSumXuCN5k_7-h89VInwuk7LSl_b1Te
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-31_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 bulkscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608310047

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

While at it, verify that the size of the authentication key is within the
expected limit.

Fixes: 3bf533787910 ("crypto: sha256 - Use the partial block API")
Cc: <stable@vger.kernel.org>
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
---

Patch is based on commit
cee9395acd80 Linux 7.3-rc1
of Mainline Linux.

v1 of this patch is at:
https://lore.kernel.org/r/20260819142357.3950463-1-s-vadapalli@ti.com/

Changes since v1:
- Propagated error from sa_prepare_iopads throughout the call chain.
- Added missing check for authentication key size being within limits.
Above changes are based on Sashiko review of the v1 patch at:
https://sashiko.dev/#/patchset/20260819142357.3950463-1-s-vadapalli%40ti.com

Regards,
Siddharth.

 drivers/crypto/sa2ul.c | 63 +++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 26 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 9846cbeb3449..13d54f269485 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -143,8 +143,8 @@ struct algo_data {
 	bool inv_key;
 	struct sa_tfm_ctx *ctx;
 	bool keyed_mac;
-	void (*prep_iopad)(struct algo_data *algo, const u8 *key,
-			   u16 key_sz, __be32 *ipad, __be32 *opad);
+	int (*prep_iopad)(struct algo_data *algo, const u8 *key,
+			  u16 key_sz, __be32 *ipad, __be32 *opad);
 };
 
 /**
@@ -433,34 +433,42 @@ static void sa_export_shash(void *state, struct shash_desc *hash,
 	cpu_to_be32_array(out, result, digest_size / 4);
 }
 
-static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
-			      u16 key_sz, __be32 *ipad, __be32 *opad)
+static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
+			     u16 key_sz, __be32 *ipad, __be32 *opad)
 {
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
+	if (key_sz > block_size) {
+		dev_err(sa_k3_dev, "%s: key size: %u exceeds block size: %d\n",
+			__func__, key_sz, block_size);
+		return -EINVAL;
+	}
+
+	sha = kmalloc(state_size, GFP_KERNEL);
+	if (!sha)
+		return -ENOMEM;
 
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
+	crypto_shash_update(shash, sha, block_size);
+	sa_export_shash(sha, shash, digest_size, opad);
 
-	sa_export_shash(&sha, shash, digest_size, opad);
+	kfree_sensitive(sha);
 
-	memzero_explicit(&sha, sizeof(sha));
+	return 0;
 }
 
 /* Derive the inverse key used in AES-CBC decryption operation */
@@ -530,8 +538,8 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 }
 
 /* Set Security context for the authentication engine */
-static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
-			   u8 *sc_buf)
+static int sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
+			  u8 *sc_buf)
 {
 	__be32 *ipad = (void *)(sc_buf + 32);
 	__be32 *opad = (void *)(sc_buf + 64);
@@ -544,11 +552,12 @@ static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
 
 	/* Copy the keys or ipad/opad */
 	if (ad->keyed_mac)
-		ad->prep_iopad(ad, key, key_sz, ipad, opad);
-	else {
-		/* basic hash */
-		sc_buf[1] |= SA_BASIC_HASH;
-	}
+		return ad->prep_iopad(ad, key, key_sz, ipad, opad);
+
+	/* basic hash */
+	sc_buf[1] |= SA_BASIC_HASH;
+
+	return 0;
 }
 
 static inline void sa_copy_iv(__be32 *out, const u8 *iv, bool size16)
@@ -763,9 +772,11 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	}
 
 	/* Prepare context for authentication engine */
-	if (ad->auth_eng.sc_size)
-		sa_set_sc_auth(ad, auth_key, auth_key_sz,
-			       &sc_buf[auth_sc_offset]);
+	if (ad->auth_eng.sc_size) {
+		if (sa_set_sc_auth(ad, auth_key, auth_key_sz,
+				   &sc_buf[auth_sc_offset]))
+			return -EINVAL;
+	}
 
 	/* Set the ownership of context to CP_ACE */
 	sc_buf[SA_CTX_SCCTL_OWNER_OFFSET] = 0x80;
-- 
2.51.1

