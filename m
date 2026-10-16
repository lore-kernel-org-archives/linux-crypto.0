Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F5A442FDF;
	Fri, 16 Oct 2026 12:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792154767; cv=fail; b=NYoqEPOSx80E5NNfssA/RtmsEPGMqZ2brIYlccvE+kfPBK+hQRvQOYOW7f0ApupfQp6g2tMftPOmuf1N1aA9GjUQvr3/qW9xZlYaqCloHLb9vZeOD4q5wFUJ9FBapibo76eSescB/cFhdoHKQIUqjxTGPgaSZhnq/ulZGDMisWc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792154767; c=relaxed/simple;
	bh=HzCRMXAllpbnP6elI/AdXoMJH7BncUmMzsyhD4uONoA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=uwvkyWZEP99KpZvFT7Ov7aXtZxtUdWsz3CkyZSqvhkrHwd1B7b8EhLCoUtaUrq9/DTlLZkVDgpvwG7cu5tjGcQZuwCbB8/BO+tXF+jKgD1dVVKcEPGSppGeWevgmJvCifQ1FE8rcCZM+cJL8JsadrrdV/NV/yFHhhEt0klewB5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=hVpisjA5; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=okHsGFdw; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="hVpisjA5";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="okHsGFdw"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 69GACibn3703875;
	Fri, 16 Oct 2026 07:46:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=oBtDtBRRe8BQM
	trrEtM8isMyc2H3MkwNnZQd/w/s1yg=; b=hVpisjA51JfSY1A1kQc5c8jKMV5wP
	WCBqLe1R9GEkz35dHuVo/K1thV03YFIMiD2aH/vV9IZScXm8hE7DlC+4upRanvS9
	llY06L9kCJrM0lC9oLMInY1+XlCe7bjUbFQmGsmidAEZCMzMojPR1zsal+2PKMKW
	s5F/KeXhr5vaojQKyS54CGZ8xwY3fOcJ+f8Q0WDwjv7PjYm3tXwWGVfGHo6CDwsd
	3wKBRNk7LQZ/sLYIo9P8t75q+mROWXsrEG1ZKHgldgjZ6Vz93nZTTGHnezQNbd+o
	BXFx526EjcKo5MLfF5PZAAofMs+iltgU1Yq86aR006UaFlQ+PITCrUMqA==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hbhbg8t7m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 07:46:04 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vom/LAhy7Tt/33GD61HPuM78t/KqI9Q/nQJ59/xig6MnNMOEe0IaNS3fduS1X07s/bT9BKtIrjyn4FMxxLD8/9opUL8RsVmYUYy06Jyvdb0EWn6VYGLZXI3aIiiT0UIpDf8rTEBhdzChqaGOAswVrMG/WueUzVZtUXCOL3zihifcrGGb0Mp0CGVedcZl6w3iKtfTHap4yoIVQ5cggitf5aHydU6NFVLdMDhugr6wP7Jid3erpKMyCrVMBxt8FuQdhsxOsByytefpZvmzIS52CDj11EZl89RkLq3yUJ+2kd3Ob+S/OlzonQv0uMg7kz0Bpo2o4HRSu48ld8QOh7ltwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oBtDtBRRe8BQMtrrEtM8isMyc2H3MkwNnZQd/w/s1yg=;
 b=CYHFt0Z6E8tvweddri+i2PdH2Xr2YoImdgtmO+LHMuGhmZvjcAjuifI5yZAd1mGeyVEjAu0jQfCgBhYldPoj9PNlsTSxuLyxN4p+FfQjPI2TZME3Dc/tUD28KsjcpEQ194fuCsJgHZfCH+DtrXB0I+2TH7j515cyNY9TGq03d9kiZKj4ewehPUB0aAnaAfQVbovfLeFN5gEjjjTETiD4WnqLCb5xyj0qQ+ikrfFmGHnpEMSwPVwe/tSjDfxu9cCKTTL8TpItVGCBlOUk1gpIOXvIuQ42nv8X5H2Qpiyv8GPlQh4y+qTo9SEc5cHtuJy4bnCzz+Nddno9nAMj996XnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBtDtBRRe8BQMtrrEtM8isMyc2H3MkwNnZQd/w/s1yg=;
 b=okHsGFdw7NGCbRrb4fLyTV8D1ZBFK9U3ECiBl6k3sGCq/sT+e7pROKNfnnO60sgnMB1XY9LZ8ASPkeZ2ENW5VT1+WacUFZpPZcbng5aMVIbimssKmwTbFFPmsY0CxaWaKYSYs2eTtAOzsMT2BltEoArHUCbyUTezAXTyhpmvuJE=
Received: from BY5PR03CA0006.namprd03.prod.outlook.com (2603:10b6:a03:1e0::16)
 by DM6PR10MB4138.namprd10.prod.outlook.com (2603:10b6:5:218::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 12:46:00 +0000
Received: from CO1PEPF00018861.namprd02.prod.outlook.com
 (2603:10b6:a03:1e0:cafe::26) by BY5PR03CA0006.outlook.office365.com
 (2603:10b6:a03:1e0::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.496.5 via Frontend Transport; Fri, 16
 Oct 2026 12:46:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 CO1PEPF00018861.mail.protection.outlook.com (10.167.249.250) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 12:45:58 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:09 -0500
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 07:45:09 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 07:45:08 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GCj7PV1587231;
	Fri, 16 Oct 2026 07:45:08 -0500
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, "Vishal Mahaveer" <vishalm@ti.com>
Subject: [PATCH v10 00/15] Fix several issues in DTHEv2 driver
Date: Fri, 16 Oct 2026 18:14:41 +0530
Message-ID: <20261016124456.1802080-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00018861:EE_|DM6PR10MB4138:EE_
X-MS-Office365-Filtering-Correlation-Id: 571e5c32-43a3-45f5-e82d-08df2b836da9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|82310400026|376014|1800799024|10067099003|18002099003|13003099007|261009223027099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	6TVbOuU6ZbhQ2JRY42TqJT0N+16OyDKbBhvzbM7vtUb6grmYpw2m3B55bscFoCCqABbBuUgQaXLH/aQIHXAu+qhOLPvwXoqtZzqyopikNaDqD6Yrt+G4v1/cEI5HadktVQkpRBlVHc6E2xzgLVVZGu1gE+ho+zH3wOCxh8S7Pf6lrIAEm/naZnn14wFb6yJYMCapKjfnoUVWToktJY7YqgsTF4/927tg35J34O3T8cCg0Dt5UEWsTahVNruXzkl5ftf3EF+SInmYBm+5vyeucRrGZqim+C/PUSGTkOKPTVrpRkTvV4Z7z9PQ9aIsFPkRHwdEPqcQInkHMtMOtsdooEFZ7yRG8NnPhQ8guo+KmREDjLAX/0oIER2KeI7zyiX+CltntthTVWD/RDLlr+3rZy55ZlA1KlzYd3U8lt8tApc2ujQOpqubktDH1DZVQgr9yGmj/raXMIDBc5ujXoNWEWiFxPzZmaZppmtebQsuMVGuDQMVEhZW0fEvEdxZGzv92eugEcAV0k80h0Qf94n8/YDp8SqyBANqeWiPF1Mry4YGmh7pFakU67DYzvC0uHNcjHgcFn4w8qq7Q/2MaNQHeAqf1gc8+E9UzENNWldgcWgRESSjqpIsP5ccE4u6gSegewz7O5NLqi21Q2nCiGV8Gg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(82310400026)(376014)(1800799024)(10067099003)(18002099003)(13003099007)(261009223027099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OBj+NSJYLfWCRhdBHhO5f8CGKjwjLW9LuQUnC7qSi1wCs08q1EzmDi2rZ+JMmsUJOZlWHDoV9Ibmb5irkcdd5L7TCM05AShgW0rs+OHbue77vno1m7zinRsXO4hdrcWojbztmvF1Xr6Hix8G5atkmrFMCDXhhwIHWUfTuR60gZccNcpyM2J0sg5xS9h6gQpJk373yBQNVCSBaCfSaBqYO0TJI/2eXpWVGYq9rXHQU3JFJFiSqww7StSKSdWVsJQYXnoI/2W71HjJ2XyMEfNhgwUzZ6Juoy2lOZgOxSqS3xjMQyaxcrLM+tVyqAq9e5Kl0xm17sisekVnQtMzmo0s09UWFAI82uFp9R8veKJCg+SOw2ogNq39/uhFj31+DCh/ySXOpHE+/FI5hCYg1Nt6AMwhKLuNIsyW8Knr/2TVjbVvCIrVLu4ib9jgepfFO1E2
X-Exchange-RoutingPolicyChecked:
	MyeoszfuIiCEcBAYqs5mvtFuSUjF8C2XN203DGCcY4Xr5Rvv75XEEasRvXXU8Og4EgbAwDRIfv7IE7w9KDDOhYXIiGiQfhEN1y3iNVpXA8sri8199nCF8T2JZs+WNWqTv1IjlKGyxTzCLoH1vDRQud69bofcTbxn9KUP4BiOGNYl1HNTOkiDh0FDfmKYWEY0sAqbUXY8bkaCRhoVokbUgLjqdeJw1GYlwfV+JXjqY3NmlEEvaTzpNdyyL+VmUJMhVshJ9VDYfQnVvzAt79CoQV/RxFG1gnMP+zSLeMSGobDsNOdoU5pa3+r69LPx28BG+xLFmDqD93/DW3NeGDNzvw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 12:45:58.9141
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 571e5c32-43a3-45f5-e82d-08df2b836da9
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018861.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4138
X-Proofpoint-GUID: cu2vWN6XSTc2yuOcn8TYX4d8jEA41sjg
X-Authority-Analysis: v=2.4 cv=BuoIUoX5 c=1 sm=1 tr=0 ts=6ad21c8c cx=c_pps
 a=nvwb1BjkeYK3HDx+lqLWkw==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=UxwojoEslEplIN4H4qAA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX8PItbx4BZ6WW
 1vUkI3xMBNOT3Y1qGtRD8ukjVECvF3iTRkqHUoNXp+0BJcbB+Lk1H60GH9OZPtwLaM9ZNKael6Y
 eZTA8LmacyeHgy/sRZYOSR1W9VrwBaEoIXV4kbtqgTtL06kzDREGXiXjRRfY/WD2Xlgy7fX6T/v
 CI9n3rsMHPCp4L/XyXTGKcvks7NwaAn+B+ZcMECj+0LCsvhLe9DcM5dcou2kY9PL37PHuGhaPK5
 3uOCgAaPbXq1JBMlJfZ5ZwAgunhydNms1SLA7dSPxSNUVMHfK6Or2ZkcJ6QeFi/r2gYrbR/ezWM
 UZSZg0c4DPORodAskM/9SYJi0LNGvRYeuo4DgfmDTBuKn/OHO/rh8D7KaWrQNS6FsGQyQwAu6N+
 Ii4vnnFzQ9ODyG7yzrdxjbrcWpzA5dWaNOZTaH40YN8UhIps1VIm8idINupmPYDnUqyB2D98yog
 q/agBBdP6/wfrE7Bb1Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA1MCBTYWx0ZWRfX3NVs5Oz1B0eX
 L2wv7IGwRikjxa+SurpHHO1DMBFwEu6CEZW+ksihnMByf8Zi/4S+F5nomzMokMTPl0sAZLsufa0
 B92jEt/NxPRQCmVmXKHMmrWa69Gg3hs=
X-Proofpoint-ORIG-GUID: cu2vWN6XSTc2yuOcn8TYX4d8jEA41sjg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610160050

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
[1]: https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
[2]: https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
[3]: https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com

Changelog:
v10:
 - Corrected typo (dev --> ctx->dev)
v9:
 - Changed extensive completion re-init based wait to using kref in
   patch 04/15
v8:
 - Minor fix based on Sashiko comment (corrected spinlock)
v7:
 - Fixes based on Sashiko comments (added locking around
   dthe_put_drvdata)
v6:
 - Fixes based on Sashiko comments (waitqueue -> completion; DMA
   alignment for cache coherency)
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
v9: https://lore.kernel.org/all/20261016114806.1749515-1-t-pratham@ti.com/
v8: https://lore.kernel.org/all/20261001085245.2922974-1-t-pratham@ti.com/
v7: https://lore.kernel.org/all/20260930125859.1749849-1-t-pratham@ti.com/
v6: https://lore.kernel.org/all/20260930112533.1593952-1-t-pratham@ti.com/
v5: https://lore.kernel.org/all/20260918102245.2784000-1-t-pratham@ti.com/
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

 drivers/crypto/ti/dthev2-aes.c    | 368 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  65 ++++--
 drivers/crypto/ti/dthev2-common.h |  66 +++++-
 3 files changed, 344 insertions(+), 155 deletions(-)

-- 
2.34.1

