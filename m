Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF294825B6;
	Tue, 15 Sep 2026 09:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466190; cv=fail; b=c8Qk5vkqVxMGcers5w3ncvGtElcgghdK/8cP0WGpE0CQH6Brw6etdtAWjWmXk0cT9vDcvQlrU5Zww/GXKi9W5/HGWC/l/sg/d5gofWjpL9SabsoNuDg8lnnmHgCp6f/TNJ+Mhs6OQHRJ3vsQ6JdRdmTcDonBNDOb6Rm+BjfFqOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466190; c=relaxed/simple;
	bh=TiikugB4BN+4H2nOcalKzmlja42GvMEL0mexg5t7grg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=RlulsQpZyHVZKVtHEhaHgMorbFLYbm1kU64MitVaW37JUL2wQzr/4rpnSx3WcRi86TX2cskVMl7fHK4aUvkFZsItl2rKUEN5dy+hbSfN9XeZLLvIhGG/ROp4yJ3TwUsYYgfXKvFnQ3e55q9SHmVhVNBv7DkPxbNIMMex5jIDiXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=QvgtSJFU; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=dqEn2zVz; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="QvgtSJFU";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="dqEn2zVz"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9esNQ3889302;
	Tue, 15 Sep 2026 04:56:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=93Xr9EjkkeRy8d48Fqse8mucm7g+g4+FfJWz5XlvJ
	H4=; b=QvgtSJFUGw0WD6wvJy3hf3ZE3ZSSS4XXIj08XY3BjtMdvkuPfnRCL0Z5l
	FBE+ASgRAD3Ls8V9S/vac95sjsaVEOkkFuPB24KLNr5ifjyKvNW5yXIIhA//JExs
	mRyEor3OVs5ERGKznBZb+8oCOi8Vc+YGSXgRWZCP0CBHZ1KQ7sMv6ZnG1cFePkZw
	IPc3grMsxdLSiBwteforagYyiOS2TL4ICZI0tb3Oa/fz+l7RuldsdAqqNa3dsI42
	/yy274WzqlzD+TDAFPZy5EaVird29+JE4WoCm7Xm+OwA5kSwNd7X2vfGXUiKDs8b
	ASw+w9NoNfSCTT4Ag32kl8LoZFJXA==
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gppxsm9g4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:25 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mb9razroGvAfo2gYidzquO+Kg0b+82HioXgE1/I6TPuwC26gztXkc3qRqLW1Q/oh4gWAc/gZKeSorcH5yEemb0s7XY5Mb0t1Dvzgx4H9IorbqXyvQZH4msacp1pfBsYCSCl80tpX1XwxZZIRRU4TAC1Y5RRjXkinbBNd2mo37EuNurp8As7rLsrPqdas2Ktlf7qVwvrHb5idzuJH8RmXd4NOV8eBZt7JEh+Enb47o+DIPbL670yazWvH6YqLMI+CQTD3MftgjIJ20RhHwnIcispudezoByTAb4K5LmXbTVgoG3OiVUepleLKm2f70SJ7dPNbOlJX6zO1/Swi+zKuQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=93Xr9EjkkeRy8d48Fqse8mucm7g+g4+FfJWz5XlvJH4=;
 b=a2Dzy8FJDM/RJG0WTb1tIHL6iRwvU7MZDH7BQfXuua9MGlDnRVZaO/Z53GIYyYcFtqKEzvr8/1DUDb4fKXLkLug6BoB6faRzd7A5Bvj0XJlZzdWdgfc2BTt2e52mpS7hqgw439Ah3gFL4HjcstYtnM5aEyub+sNkbvRGGJM+D/zZuidh+tdP8lmBybm1Zn/Qnp9X+6dds5fhsntaeVlE1kPtBXTaKdKOdhyApwhvVRfM/OUBh91m7ImPVRoPSs/2RyFlsGy/gwayfabJv5JhkyfgZ7aP3/LzqDl4vl0cyhXboV7JUAqJE8otSsyp9+vbMmbNFuKBSl5DQyQ2QU3+/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=93Xr9EjkkeRy8d48Fqse8mucm7g+g4+FfJWz5XlvJH4=;
 b=dqEn2zVzwEZ24JzvF12bSGJLNjfqfGLEonWL0ACAJ4XfWQ0VHXNUlwTfUHOmBh9SuGXcEnb5vfoamgG0oZ9cShnemh9jUSsOLS6mH9ETSOP5F89nfCmAMZRsBaGGWn0KAy0+kuzYnyPwmcQEgnzWmbiciVSUJJ13zGOvUFPngTQ=
Received: from CH2PR10CA0009.namprd10.prod.outlook.com (2603:10b6:610:4c::19)
 by DS7PR10MB5136.namprd10.prod.outlook.com (2603:10b6:5:38d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:20 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:4c:cafe::36) by CH2PR10CA0009.outlook.office365.com
 (2603:10b6:610:4c::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.11 via Frontend Transport; Tue,
 15 Sep 2026 09:56:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:18 +0000
Received: from DFLE210.ent.ti.com (10.64.6.68) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:42 -0500
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:42 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:42 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7w3000901;
	Tue, 15 Sep 2026 04:55:39 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:14 +0530
Subject: [PATCH 08/30] crypto: sa2ul - remove unused SC ID range tracking
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-8-57ab34e97162@ti.com>
References: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
In-Reply-To: <20260915-b4-upstream-sa2ul-cleanup-v1-0-57ab34e97162@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>, Keerthy <j-keerthy@ti.com>,
        Colin Ian King
	<colin.i.king@gmail.com>
CC: Andrew Davis <afd@ti.com>, Pratham T <t-pratham@ti.com>,
        "Kamlesh
 Gurudasani" <kamlesh@ti.com>, Udit Kumar <u-kumar1@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Manorit
 Chawdhry" <m-chawdhry@ti.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=1906;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=TiikugB4BN+4H2nOcalKzmlja42GvMEL0mexg5t7grg=;
 b=58GeFloJ+DeNMIw1/UbQsZmssx/qK21z9VrXHosTtPGuG1Dyoo95ShzCaDGK4YN9rH+TcCwrN
 jDYvL6ln0qUDm3Ve6XoRzdfapiQG8hr/c8+xrBp+kMEkh1puPXb3Kui
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|DS7PR10MB5136:EE_
X-MS-Office365-Filtering-Correlation-Id: 24236ae6-90b1-42de-0d15-08df130f96ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|23010399003|376014|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	MBGpt5WPqfK6/dx7tnHxU4YFKXwjvgShIPhBFt+wnv8WklhNp3MeKJ0W9j/CosCgn0WnwN2x+VxNJwlqY305KdqeBjAcM+Ko3b0LTmk5QSnrk1KwnZDTB96OdoJ/RtTUXjr6Z/3UcVLMgAthM/4Pp1cj7AU3H5K30//dtrFwPCY8FWpUEUvOu2Cwa98DPXvSYQNW+sIOwNE6hfy5q5UlQNzaf7y0moinHIehGiKvytsUSaIvWaaw7iRSbiLNIQCGuv77H/2V4qLghSd3pL8JS3Y7BtprdkMGQ3tOAIxSHW44D2J6+DVteorDdLc1bqqT6Csd3U6IbrzXy+j68f6W6RfwvindRY3SXBF7L/JZ+QOTr2CPgMMXxiv6y0O1xKhg4fB/kWnBXaZKlvf9TnBJZG1lUtBI1mp7fKDWYMPMrh/CbEiNajOEj+o3Nc+QPNpLV7t63RdO/O8mRQvH5koPSu1+rCSSktqLm4kV07xi6C2EJZkwOLhZL7V5oHSnAznkcKYfHmjUrybv/am0a8cAnuGz1h+L7pekqQw15HWAVGSkH8beNV/RtQnu42AdQsRDKoVZjxPtrmHvQVZX04pR3T6B0zujVD9Mzrqw+GcXoOCTt1vyqHwetM9/Sgn1lwCHhNUoEe9k0zQBewLK4SIBAggiDVSYJL9PhNDppIOjJ8g3RgQp1hUmXLHRtxxql1hzWtpkHisjgmN0CvzGQg5F2g==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(23010399003)(376014)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	92AXUY8/MryG6dFbYrUGWKWzYXgCgEwUplVa6/dvHOF7baBJZglSRHuQQX34NAvsx7t7J7f8RU8hqhotgYb5DKKWsl+cieYgcE4q6AgUy7waKzghC3ZTr6SMOSdh8pdri+t1yGgCWvUWh/rCI2yVF9lo+Fm1r1CWsO3vL1n5QX6yKtshQpdzWTRMalOhwTTGslk4GjEJbVHwKiRe0ozM4w8amx6odOZfiJr84MMxBMFY1zChh9mn9gIvU0Y9JYo8DjFNvjibhY8pWY5vS7+RSYfShHKREFGYRVfdBgC/Ky+cFQZEiCYrVKOuziQA8pf3xogqeBtLvrDR1B+3gO+eLqeRKkgBgPiCMgsFvhLhO1XQrDCbuO4kseohVcd/IV38K72rs3EYX5Pkep61kyIeZP0uDUYBZEKC1l8VmHorcH/zIdBxgEokiLqDbwMWxcM8
X-Exchange-RoutingPolicyChecked:
	hMOdEjHk5H6Qqvy8OoMZi9ILNyu6l8NqNOSpZ9cEOmWiXOAnOCsyEoUXuOIUupJl2cf+jT2K7OQYi65ZrkABG3wAmRd9czxg3A8NpEI0yCanbLhBj1QE44AotmiNgGy9Bjb1b6F4N1jo+eErnOsqAMxGbzfeeZmGdodYsyiKF5dw248Oh3fvyN2nehP/jjmI/6fPb7bQSwFqjkmhEQFXSfY+QWqG+nBOn/JIkJWRsOzZWXMvx6wC79L1bLruwhuRW9Cjy/Z0yjcNhUlXoOisT2915p/YZXuda+p77TjqjNErIT6Mb8zt5VQRTxDdIKwoo8j0w4OdTuRvyWGp1b+Sfg==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:18.6580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 24236ae6-90b1-42de-0d15-08df130f96ee
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5136
X-Proofpoint-GUID: Ad8qyWuQsO0RHXaw47XNp_5c0XgSAuoa
X-Proofpoint-ORIG-GUID: Ad8qyWuQsO0RHXaw47XNp_5c0XgSAuoa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX6YWgTsA7nTns
 2v+5ehTsmNC583BktagLxK8iQMKaKJU6xzLPDDyRfjnjzZ+Bmv2OXGH7i3p9P6caJBYawT21Zck
 OOwiNm/0mYBJZ4e746Num4suiPh9FBOty7N6nBCinzfFGffHjYW4Z4Y3tK5NqkRQdNMknFzeOb5
 /TKRCxmmMWqbPeXRoKxfliyZRCZke+blbVZASS3PHDZvWwe9tWUB7G2eindGrs2d+wNYFaY9P5Z
 8M42FuPwjBZfc93C868GM0mK3enukrcsPvX3zU7DNCKKCcUZtM5vwXK2tqUXOYTENO1VtEcWHTX
 71lsoavxXXS4XDwOKv/gPIKVAlcQFWe8Rb/87w5RPHm8xKa63H8hCNzf2km+VUCAzPg+l1zSM10
 r1drihECP1NAZHrOWjrcrmq6N3TNQE7U7ogwSoeeWdvt/hxGzc4TW+PfRyZNG2asLwOvqDlT1AR
 PI59Ssv/YKhdbneaobg==
X-Authority-Analysis: v=2.4 cv=bYP+w+PB c=1 sm=1 tr=0 ts=6aa91649 cx=c_pps
 a=HLJbjerEQdjma44f6ZsklA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=TZd5T8kqcK8ENkXl4jYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX0AOp+xp3K2B6
 ZdBJY1I0uo4w9zYHbvL0mZIGPNxuObDGjnwr0g3Vtu0EAVrWbMgesrwM/aSTA6oS03fBWBTx24/
 VnQj4CISQyNVI2Z/FHfnHTrDQ7XJ2Dk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Remove unused sc_id_start and sc_id_end fields from sa_dev_data.
These were intended for security context ID management but were
never used in the driver.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 4 ++--
 drivers/crypto/sa2ul.h | 4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index cde08686f27a..72be29820859 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -764,7 +764,7 @@ static void sa_free_ctx_info(struct sa_ctx_info *ctx,
 {
 	unsigned long bn;
 
-	bn = ctx->sc_id - data->sc_id_start;
+	bn = ctx->sc_id;
 	spin_lock(&data->scid_lock);
 	__clear_bit(bn, data->ctx_bm);
 	data->sc_id--;
@@ -788,7 +788,7 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 	data->sc_id++;
 	spin_unlock(&data->scid_lock);
 
-	ctx->sc_id = (u16)(data->sc_id_start + bn);
+	ctx->sc_id = (u16)bn;
 
 	ctx->sc = dma_pool_alloc(data->sc_pool, GFP_KERNEL, &ctx->sc_phys);
 	if (!ctx->sc) {
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 94101300736c..c41c688687f5 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -168,8 +168,6 @@ struct sa_match_data;
  * @sc_pool: security context pool
  * @dev: Device pointer
  * @scid_lock: secure context ID lock
- * @sc_id_start: starting index for SC ID
- * @sc_id_end: Ending index for SC ID
  * @sc_id: Security Context ID
  * @ctx_bm: Bitmap to keep track of Security context ID's
  * @ctx: SA tfm context pointer
@@ -185,8 +183,6 @@ struct sa_crypto_data {
 	struct device *dev;
 	spinlock_t	scid_lock; /* lock for SC-ID allocation */
 	/* Security context data */
-	u16		sc_id_start;
-	u16		sc_id_end;
 	u16		sc_id;
 	unsigned long	ctx_bm[DIV_ROUND_UP(SA_MAX_NUM_CTX,
 				BITS_PER_LONG)];

-- 
2.43.0

