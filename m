Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9F042F71F;
	Fri,  7 Aug 2026 11:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786100811; cv=fail; b=s2ezXl4EwDJiQODqEo9BNBvIRZVHOQ07tqTnLi4WuzmEJk5Ks96zSMzhtHq6nv+Dov7fHRS9wHslylQX0UlLDQbBKHv/+vfSEgrwjPJH2XKZmxDYFS1qvlZ5uvqtCY3Gody/+9If/mAlclLk2R9afCcEmpcO7gkxlwmjJElw0yU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786100811; c=relaxed/simple;
	bh=HyUiu7333CFvY+/FdUiAVHLFGhNt89JMVzZTqH0JCec=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Elz7IuY+D6eKeIFbi+fA6V+U1H7M+8RCLnBYHufBNG2I/0IPiUZdf4E2mnwcz3qi9d8fQqbLbW1EkYYGX/Mdsv4F3YkZiM+Tfr1Lws8L6ARt46qgC/cu+SO3MH7FpEWz6ax6lndU+vRMZUpASRlLmhz/xC4fd2hbitoGPDLi0tc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=HwypuFg7; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=ag5+uNCG; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="HwypuFg7";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="ag5+uNCG"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6777j0tP2583830;
	Fri, 7 Aug 2026 06:06:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=drs9Mbi8yLZXeb2+Vkc652DgOgwPEHRF2O/jaeZUT
	x4=; b=HwypuFg7DNRCp0LOenVf3xeKvcgFZMxt/jAgv+fHQobXXMwUHImgUU3fq
	WNTu/VqZOREu1qHO4279Hm5XHTihOe46a0GZVY2bJXCUqevH/ssKB2cJGAlLa/l/
	2MImnN5a+Qk1uMg5scnx99E2bT+43wT7ndiQwIebvJaBzDtKHtSW0nzd+0ITHSHf
	Jrl04cl+SZ89eaQXC4ErwE+3PJn8PM3x9fRSaAFGjbrKkQi0Llb1vwMO1igX1asT
	xhL8VaNbCCm5hrF7xZpIRIzUa5TG85LCSzzOhAl67o8cKvlUxo0m9rEXdl3a8Uvu
	w5pHLSwaFFF837rmeUaTSmE5TryVw==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011066.outbound.protection.outlook.com [40.93.194.66])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4fwb8dgwt3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 07 Aug 2026 06:06:44 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m5yk875t2PvsAkZqxu8lIBWVmkn25AJJ4FG70nI0HHO/HPxFNdmmOg5ypOYmA62phLSUwcR27E0eYmnhP0FEwZ+p1KttJQWn+GXhVQ3DZ/JedCPdH7tegXIAwgvVWMDoWMzf/mXY1jlpFBbJG4thplABi9cDTu+P7mqje3MiNG6TGDlVqTYhgj5TfxJwJE1rL/gEatZ6KMrIMaA41mSrr4GEFJ9eIzJ62Zzdvl5j7kyST62kqgzmtIk01w22qz8gVVT8PBjO4sWpsuncOsipbqU2lqzzj6+3E1owTjySsz6fScoLi3dvaag5OUO6W+EX4+mWaYAgMn88G/uBgUHDng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drs9Mbi8yLZXeb2+Vkc652DgOgwPEHRF2O/jaeZUTx4=;
 b=b+zUpbmAWMxuJ81gDV0B68/NlGvH5s2MPtqbboeDIFwwW/pkFqRia4roJHH3Gb6qw8/CmoL6glmLK4dNSJY1MaDhVnU5O1nOpEKaJuTQslbPMH4lJ9gisy8AXXGaiqw7WkOMQvt3C9rcyFuE/9Yc4z71XsUCNZq4XJEhXMlDpjbf11sYBi7pdx/mVXbxIeCmSY3gODAnhWoT293ryMVV0h1512VlRKhPnhg6tndSd0LnVlM2tsPrjga6ZueFUU74M94Fknhq6jx94MWYv2qZUwgmLEYRL2mWleDjm2RvtmyIpjyKxYiPO2j/yjNrIHVCwBp7pcoDr+INvIu90pufUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=drs9Mbi8yLZXeb2+Vkc652DgOgwPEHRF2O/jaeZUTx4=;
 b=ag5+uNCGdH8i8Le6eJGjU/KvzhGZtk0/C9IytJXvKWfJj+YtXoXF9ky5QHcW6ffRgiyXhIYrBgqQ4n68WtIkq56nJgoxA8OiEXtqGb6P2Qme5ySP58otGs5l135ENYgLDrG2G1Mh70wP7GcCgs1ZbJJZCjN8fqw3Vpx+sZjpbBY=
Received: from CYZPR19CA0023.namprd19.prod.outlook.com (2603:10b6:930:8e::29)
 by DS4PPF109C7C399.namprd10.prod.outlook.com (2603:10b6:f:fc00::d0a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Fri, 7 Aug
 2026 11:06:40 +0000
Received: from CY4PEPF0000EE30.namprd05.prod.outlook.com
 (2603:10b6:930:8e:cafe::26) by CYZPR19CA0023.outlook.office365.com
 (2603:10b6:930:8e::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.24 via Frontend Transport; Fri, 7
 Aug 2026 11:06:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CY4PEPF0000EE30.mail.protection.outlook.com (10.167.242.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.315.6 via Frontend Transport; Fri, 7 Aug 2026 11:06:38 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 7 Aug
 2026 06:05:59 -0500
Received: from DFLE214.ent.ti.com (10.64.6.72) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Fri, 7 Aug
 2026 06:05:59 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37 via Frontend
 Transport; Fri, 7 Aug 2026 06:05:59 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 677B5viW944863;
	Fri, 7 Aug 2026 06:05:58 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Manorit Chawdhry <m-chawdhry@ti.com>, Shiva Tripathi <s-tripathi1@ti.com>,
        Sebin Francis <sebin.francis@ti.com>, Vishal Mahaveer <vishalm@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v5 3/3] crypto: ti - Add support for HMAC in DTHEv2 Hashing Engine driver
Date: Fri, 7 Aug 2026 16:34:59 +0530
Message-ID: <20260807110501.975130-4-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260807110501.975130-1-t-pratham@ti.com>
References: <20260807110501.975130-1-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE30:EE_|DS4PPF109C7C399:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b041202-9d9a-44ec-a51e-08def473f427
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|23010399003|82310400026|1800799024|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	h3gIcvJhLWmBbn1MDt86uU07g8UTjDqAgQT2qaxLzPuvHz0i7gG0Yx7SHxz2Lb0LryyUHxV4nPuQorYl+Qfw6VpPxYbmZBCtzaHPReN2iYTfXm6B6gwlcuLqg22K295Q6ogf5mPscvvZvM3nSKH110lIIkDOS/jXymRjnDMmBqQ/7AIwIv+jjJbSiew4gMjPX/agVeVwZAW9OqITvTemGinjEg2SZrrPCY4OQsHxLvmZGCzZi7AwDCDgu6R7mkMC2MeTbPWFWGwva3uzWPb3gtK4/hqr2ejZwgSgQgXyMu+X6V/xzxDW/aSB63bL+geDvLEnE+1HPToun/BMuTjQ590yrvWiQFpfi3nxsIMAK4ZVsrTzYW/iuxdsZGB44O/6q30AzbGQIMxuzAk8zVwvxJMSN7bAe2O/gYfM3htUL7dExeMhTlZUU/biYtIJRqq4yf9tG1XHNKKMQHja9b0r6IKfomgh/ZXdAWbIR4mVuwsOykkyVkH938ONgTjlYCLfOlljc/2x9z4zIlFMNl2Yi6eMYDO2gGYTl7mjl0joP9va3CE0V716H5N8cliiSp/yqOLy5gt1mkTK088My5gTOrYgGQkS4n2SDRgHClF5jAlxgw6uTcKy4YNCdIFTKKEvaARtWmqHpn5QmMkQN3Z9lkEIvHuS5/ZlPml7thKErpnXd/bwVY7NeddmfQh2jpbVTQVAv5IXDrs1nHpquWSTIw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700016)(23010399003)(82310400026)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rFePVio+C9NCMYFSEA7+fhxew//1ZNzqiGeDPtWs+6XvNmuu3VAvTMto5xrnzX7vTDrGJOD2g+kqK27hwBGmgMHlp/1sEUUyiWLOL+9u0KW7WHjf9FIicY5EK3pv0L0irxLmAvJYnd1Y1YZOcIm7hU4wDn02tlaj7NoDN3SSWS2+wDhdLRjvtBcP61M9oD7DX2svmSmE5obXj5vztywrpHi1vCa/wuQaJ7sFs1xfu6c8VJ2ZmQ/EAytG3LGkwMv8Xn2j/yizXAlGB4njaJ2wKHBtAG7pJL3jNaqej+P0pV1e85tFjKqIU84AEaJoovz4gSgDf1X8tQoGE6VzJsksNFkA0dfecC3EBDofDgTZJTZhey/+/447nVvLfMcXZGdFd+uSrLaDSWZ8MreDbJfseSc3Q3UQujIhAtfgL2QCAgMaKEGfdesmDMcdG1SfSUu7
X-Exchange-RoutingPolicyChecked:
	pD7/W6JlGt6lbStCkRU6M2/jfBxT85pqplE+fQp+JOIZGonGTNg06CqC6gZVBYepOxWrVJo9w4McY/jCHOX283bdh8C8eZ/GUqgrqcidMwhJdf1hujstqtClWrPPzN9TBK66Z03Q43OQGp600vyTHSsJAp3mh4FmDsm8pKuZjCjDgX9cZf6UQHKkQPwmjRm1WWqUXAAkBTQrftxyiqu8Hju0qhbwPQlJu3KDTkQptwzBMz+z6aUNm0zBOVsaZ/S01qCXmZldDWjoPR3lp0pur7Y9V/X9zV7DBeBFzdaryrQsIk8NkEvrrI6G1sJT2RNhvg+zXNk7kXjvZJZOPj0E+Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 11:06:38.7050
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b041202-9d9a-44ec-a51e-08def473f427
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE30.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF109C7C399
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDA4NCBTYWx0ZWRfXxpfSBCq7/3sp
 XfnXPgjjEsf57OtxFUBtKHQNgn2Dlc8dEd1hA0/hfUWaKkMwGcz85xzpv7Zhas5mKlpTFjmYIii
 trYkmMFbtIRZn19GVEEUCOTer8qRSMcayIRHSvCIs0Ksghxh9Pw+vekYY6tsSh81/CATydSxbj/
 YniGTtiq+n8KpKHJyyq9WaCeGTOu9Vdnm6kSrrH+revGPDxr2YDJlO8tTNRYI4akZSSaky4m6YW
 IMHaQgNN8Tk0CTPXrccQW4EW5gmBzBJhsbYrhVPNtnLVs3sBx3RJXtKKH1wH5wXVl+L7MmBcU+T
 5hVoaoV34gHQw98Lxi/FpE0uyXRH0gumWZv9GXGTY0mAE6OiFikd1AkjYkDpZMDoi46IK19rSvi
 urfpPnTuDmVChfo2GOuj/FUsS24RU+3ToI2wti78eBv8LOfOCki3zAKx21xsNcDTeBcsJ9QvSwo
 gE6nMpdenGvI5wXaF+w==
X-Proofpoint-ORIG-GUID: GopJ0ZwglqpdhD4cwXgKz8gnPni-1jRs
X-Proofpoint-GUID: GopJ0ZwglqpdhD4cwXgKz8gnPni-1jRs
X-Authority-Analysis: v=2.4 cv=Ouh/DS/t c=1 sm=1 tr=0 ts=6a75bc44 cx=c_pps
 a=1t1hxDBgkqdAqWWjFE2LMw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=UJvMcVJv5lc1T41YKn0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDA4NCBTYWx0ZWRfXykJxkwK292tu
 w6e9aH6Z0PzSqzVl5pLCfan3kpq4/lFzY15GnsL9ay/r6PgQBL61jnsKA2+6xutupk2ohtceBEa
 UID1wLpIe+/PxC2g9hIDEZon0rZ/TUE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_01,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 phishscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608070084

Add support for HMAC-SHA512/384/256/224 and HMAC-MD5 algorithms in the
hashing engine of the DTHEv2 hardware cryptographic engine.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/Kconfig         |   1 +
 drivers/crypto/ti/dthev2-common.h |  10 +-
 drivers/crypto/ti/dthev2-hash.c   | 334 +++++++++++++++++++++++++++++-
 3 files changed, 340 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ti/Kconfig b/drivers/crypto/ti/Kconfig
index 9c2aa50cfbfbe..68dccf92f5382 100644
--- a/drivers/crypto/ti/Kconfig
+++ b/drivers/crypto/ti/Kconfig
@@ -13,6 +13,7 @@ config CRYPTO_DEV_TI_DTHEV2
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	select CRYPTO_MD5
+	select CRYPTO_HMAC
 	select SG_SPLIT
 	help
 	  This enables support for the TI DTHE V2 hw cryptography engine
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 2c6e06df16d35..965e4004be77e 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -31,9 +31,9 @@
 #define DTHE_DMA_TIMEOUT_MS	2000
 /*
  * Size of largest possible key (of all algorithms) to be stored in dthe_tfm_ctx
- * This is currently the keysize of XTS-AES-256 which is 512 bits (64 bytes)
+ * This is currently the keysize of HMAC-SHA512 which is 1024 bits (128 bytes)
  */
-#define DTHE_MAX_KEYSIZE	(AES_MAX_KEY_SIZE * 2)
+#define DTHE_MAX_KEYSIZE	(SHA512_BLOCK_SIZE)
 
 enum dthe_hash_alg_sel {
 	DTHE_HASH_MD5		= 0,
@@ -93,9 +93,9 @@ struct dthe_list {
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
  * @dev_data: Device data struct pointer
- * @keylen: AES key length
+ * @keylen: Key length for algorithms that use a key
  * @authsize: Authentication size for modes with authentication
- * @key: AES key
+ * @key: Buffer storing the key
  * @aes_mode: AES mode
  * @hash_mode: Hashing Engine mode
  * @phash_size: partial hash size of the hash algorithm selected
@@ -135,6 +135,7 @@ struct dthe_aes_req_ctx {
  * @phash: buffer to store a partial hash from a previous operation
  * @digestcnt: stores the digest count from a previous operation; currently hardware only provides
  *             a single 32-bit value even for SHA384/512
+ * @odigest: buffer to store the outer digest from a previous operation
  * @padding: padding buffer for handling unaligned data
  * @data: buffer to store one block of data to defer operations for non-zero final.
  * @flags: bitfield of flags for internal use.
@@ -146,6 +147,7 @@ struct dthe_aes_req_ctx {
 struct dthe_hash_req_ctx {
 	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];
 	u64 digestcnt[2];
+	u32 odigest[SHA512_DIGEST_SIZE / sizeof(u32)];
 	u8 padding[SHA512_BLOCK_SIZE];
 	u8 data[SHA512_BLOCK_SIZE];
 	u8 flags;
diff --git a/drivers/crypto/ti/dthev2-hash.c b/drivers/crypto/ti/dthev2-hash.c
index 1606b982e4581..7bac7294f0034 100644
--- a/drivers/crypto/ti/dthev2-hash.c
+++ b/drivers/crypto/ti/dthev2-hash.c
@@ -8,6 +8,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
+#include <crypto/hmac.h>
 #include <crypto/internal/hash.h>
 #include <crypto/md5.h>
 #include <crypto/scatterwalk.h>
@@ -25,6 +26,7 @@
 /* Registers */
 
 #define DTHE_P_HASH_BASE		0x5000
+#define DTHE_P_HASH512_ODIGEST_A	0x0200
 #define DTHE_P_HASH512_IDIGEST_A	0x0240
 #define DTHE_P_HASH512_DIGEST_COUNT	0x0280
 #define DTHE_P_HASH512_MODE		0x0284
@@ -47,6 +49,13 @@
 
 #define DTHE_HASH_MODE_USE_ALG_CONST		BIT(3)
 #define DTHE_HASH_MODE_CLOSE_HASH		BIT(4)
+#define DTHE_HASH_MODE_HMAC_KEY_PROCESSING	BIT(5)
+#define DTHE_HASH_MODE_HMAC_OUTER_HASH		BIT(7)
+
+/* Misc */
+#define DTHE_HMAC_SHA512_MAX_KEYSIZE		(SHA512_BLOCK_SIZE)
+#define DTHE_HMAC_SHA256_MAX_KEYSIZE		(SHA256_BLOCK_SIZE)
+#define DTHE_HMAC_MD5_MAX_KEYSIZE		(MD5_BLOCK_SIZE)
 
 /* rctx flag bitfields */
 #define DTHE_HASH_FLAG_OP		BIT(0)
@@ -106,6 +115,19 @@ static void dthe_hash_write_zero_message(enum dthe_hash_alg_sel mode, void *dst)
 	}
 }
 
+static int dthe_hmac_write_zero_message(struct ahash_request *req)
+{
+	HASH_FBREQ_ON_STACK(fbreq, req);
+	int ret;
+
+	ahash_request_set_crypt(fbreq, req->src, req->result,
+				req->nbytes);
+
+	ret = crypto_ahash_digest(fbreq);
+	HASH_REQUEST_ZERO(fbreq);
+	return ret;
+}
+
 static enum dthe_hash_alg_sel dthe_hash_get_hash_mode(struct crypto_ahash *tfm)
 {
 	unsigned int ds = crypto_ahash_digestsize(tfm);
@@ -163,6 +185,18 @@ static unsigned int dthe_hash_get_phash_size(struct dthe_tfm_ctx *ctx)
 	return phash_size;
 }
 
+static const char *dthe_hash_get_alg_name(struct dthe_tfm_ctx *ctx)
+{
+	switch (ctx->hash_mode) {
+	case DTHE_HASH_SHA224:	return "sha224";
+	case DTHE_HASH_SHA256:	return "sha256";
+	case DTHE_HASH_SHA384:	return "sha384";
+	case DTHE_HASH_SHA512:	return "sha512";
+	case DTHE_HASH_MD5:	return "md5";
+	default:		return NULL;
+	}
+}
+
 static int dthe_hash_init_tfm(struct crypto_ahash *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -216,6 +250,7 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 	enum dma_data_direction src_dir = DMA_TO_DEVICE;
 	u32 hash_mode;
 	int ds = crypto_ahash_digestsize(tfm);
+	bool is_hmac = (ctx->keylen > 0);
 	int ret = 0;
 	u32 *dst;
 	u32 dst_len;
@@ -263,6 +298,9 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 
 	if (dthe_hash_flag_is_op(rctx, DTHE_HASH_OP_FINUP)) {
 		hash_mode |= DTHE_HASH_MODE_CLOSE_HASH;
+		if (is_hmac)
+			hash_mode |= DTHE_HASH_MODE_HMAC_OUTER_HASH;
+	}
 
 	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL)) {
 		for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
@@ -270,9 +308,28 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 				       sha_base_reg +
 				       DTHE_P_HASH512_IDIGEST_A +
 				       (DTHE_REG_SIZE * i));
+		if (is_hmac) {
+			for (int i = 0; i < ctx->phash_size / sizeof(u32); ++i)
+				writel_relaxed(rctx->odigest[i],
+					       sha_base_reg +
+					       DTHE_P_HASH512_ODIGEST_A +
+					       (DTHE_REG_SIZE * i));
+		}
 
 		writel_relaxed(rctx->digestcnt[0],
 			       sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
+	} else if (is_hmac) {
+		hash_mode |= DTHE_HASH_MODE_HMAC_KEY_PROCESSING;
+
+		for (int i = 0; i < (ctx->keylen / 2) / sizeof(u32); ++i)
+			writel_relaxed(ctx->key[i], sha_base_reg +
+				       DTHE_P_HASH512_ODIGEST_A +
+				       (DTHE_REG_SIZE * i));
+		for (int i = 0; i < (ctx->keylen / 2) / sizeof(u32); ++i)
+			writel_relaxed(ctx->key[i + (ctx->keylen / 2) / sizeof(u32)],
+				       sha_base_reg +
+				       DTHE_P_HASH512_IDIGEST_A +
+				       (DTHE_REG_SIZE * i));
 	} else {
 		hash_mode |= DTHE_HASH_MODE_USE_ALG_CONST;
 	}
@@ -307,6 +364,12 @@ static int dthe_hash_dma_start(struct ahash_request *req, struct scatterlist *sr
 		dst[i] = readl_relaxed(sha_base_reg +
 				       DTHE_P_HASH512_IDIGEST_A +
 				       (DTHE_REG_SIZE * i));
+	if (is_hmac) {
+		for (int i = 0; i < dst_len; ++i)
+			rctx->odigest[i] = readl_relaxed(sha_base_reg +
+							 DTHE_P_HASH512_ODIGEST_A +
+							 (DTHE_REG_SIZE * i));
+	}
 
 	rctx->digestcnt[0] = readl_relaxed(sha_base_reg + DTHE_P_HASH512_DIGEST_COUNT);
 	dthe_hash_flag_set(rctx, DTHE_HASH_FLAG_PHASH_AVAIL);
@@ -462,6 +525,10 @@ static int dthe_hash_final(struct ahash_request *req)
 		return crypto_transfer_hash_request_to_engine(engine, req);
 	}
 
+	if (ctx->keylen > 0)
+		/* HMAC with zero-length message */
+		return dthe_hmac_write_zero_message(req);
+
 	dthe_hash_write_zero_message(ctx->hash_mode, req->result);
 
 	return 0;
@@ -521,6 +588,53 @@ static const void *dthe_hash_get_init_state(struct dthe_tfm_ctx *ctx)
 	}
 }
 
+/*
+ * Compute the HMAC inner or outer pad state (the intermediate hash state after
+ * processing one block of key XOR pad_byte) and write it to @out. Only the
+ * first ctx->phash_size bytes are written, which is always the raw hash state
+ * at the start of the shash export struct.
+ */
+static int dthe_hmac_compute_pad_state(struct dthe_tfm_ctx *ctx, u8 pad_byte,
+				       void *out)
+{
+	const char *alg_name = dthe_hash_get_alg_name(ctx);
+	struct crypto_shash *ktfm;
+	u8 data[SHA512_BLOCK_SIZE];
+	unsigned int ss;
+	u8 *state;
+	int ret;
+
+	ktfm = crypto_alloc_shash(alg_name, 0, 0);
+	if (IS_ERR(ktfm))
+		return PTR_ERR(ktfm);
+
+	ss = crypto_shash_statesize(ktfm);
+	state = kmalloc(ss, GFP_KERNEL);
+	if (!state) {
+		crypto_free_shash(ktfm);
+		return -ENOMEM;
+	}
+
+	SHASH_DESC_ON_STACK(desc, ktfm);
+
+	desc->tfm = ktfm;
+	for (int i = 0; i < ctx->keylen; i++)
+		data[i] = ((u8 *)ctx->key)[i] ^ pad_byte;
+
+	ret = crypto_shash_init(desc) ?:
+	      crypto_shash_update(desc, data, ctx->keylen) ?:
+	      crypto_shash_export(desc, state);
+
+	if (!ret)
+		memcpy(out, state, ctx->phash_size);
+
+	memzero_explicit(state, ss);
+	kfree(state);
+	crypto_free_shash(ktfm);
+	memzero_explicit(data, sizeof(data));
+	return ret;
+}
+
 static int dthe_hash_export(struct ahash_request *req, void *out)
 {
 	struct dthe_hash_req_ctx *rctx = ahash_request_ctx(req);
@@ -531,9 +645,12 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
 		u8 *u8;
 		u64 *u64;
 	} p = { .u8 = out };
+	int ret = 0;
 
 	if (dthe_hash_has_flag(rctx, DTHE_HASH_FLAG_PHASH_AVAIL))
 		memcpy(out, rctx->phash, ctx->phash_size);
+	else if (ctx->keylen > 0)
+		ret = dthe_hmac_compute_pad_state(ctx, HMAC_IPAD_VALUE, out);
 	else
 		memcpy(out, dthe_hash_get_init_state(ctx), ctx->phash_size);
 
@@ -542,11 +659,16 @@ static int dthe_hash_export(struct ahash_request *req, void *out)
 	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
 		put_unaligned(rctx->digestcnt[1], p.u64++);
 
+	if (ctx->keylen > 0) {
+		memcpy(p.u8, rctx->odigest, ctx->phash_size);
+		p.u8 += ctx->phash_size;
+	}
+
 	memcpy(p.u8, rctx->data, bs);
 	p.u8 += bs;
 	put_unaligned(rctx->flags, p.u8++);
 
-	return 0;
+	return ret;
 }
 
 static int dthe_hash_import(struct ahash_request *req, const void *in)
@@ -566,6 +688,11 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
 	if (ctx->phash_size >= SHA512_DIGEST_SIZE)
 		rctx->digestcnt[1] = get_unaligned(p.u64++);
 
+	if (ctx->keylen > 0) {
+		memcpy(rctx->odigest, p.u8, ctx->phash_size);
+		p.u8 += ctx->phash_size;
+	}
+
 	memcpy(rctx->data, p.u8, bs);
 	p.u8 += bs;
 	rctx->flags = get_unaligned(p.u8++);
@@ -573,6 +700,51 @@ static int dthe_hash_import(struct ahash_request *req, const void *in)
 	return 0;
 }
 
+static int dthe_hmac_setkey(struct crypto_ahash *tfm, const u8 *key,
+			    unsigned int keylen)
+{
+	struct dthe_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct crypto_ahash *fb = crypto_ahash_fb(tfm);
+	const char *hash_alg_name = dthe_hash_get_alg_name(ctx);
+	unsigned int max_keysize;
+
+	memzero_explicit(ctx->key, sizeof(ctx->key));
+
+	switch (ctx->hash_mode) {
+	case DTHE_HASH_SHA512:
+	case DTHE_HASH_SHA384:
+		max_keysize = DTHE_HMAC_SHA512_MAX_KEYSIZE;
+		break;
+	case DTHE_HASH_SHA256:
+	case DTHE_HASH_SHA224:
+		max_keysize = DTHE_HMAC_SHA256_MAX_KEYSIZE;
+		break;
+	case DTHE_HASH_MD5:
+		max_keysize = DTHE_HMAC_MD5_MAX_KEYSIZE;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	if (keylen > max_keysize) {
+		struct crypto_shash *ktfm = crypto_alloc_shash(hash_alg_name, 0, 0);
+		SHASH_DESC_ON_STACK(desc, ktfm);
+		int err;
+
+		desc->tfm = ktfm;
+		err = crypto_shash_digest(desc, key, keylen, (u8 *)ctx->key);
+		crypto_free_shash(ktfm);
+		if (err)
+			return err;
+	} else {
+		memcpy(ctx->key, key, keylen);
+	}
+
+	ctx->keylen = max_keysize;
+
+	return crypto_ahash_setkey(fb, key, keylen);
+}
+
 static struct ahash_engine_alg hash_algs[] = {
 	{
 		.base.init_tfm	= dthe_hash_init_tfm,
@@ -729,6 +901,166 @@ static struct ahash_engine_alg hash_algs[] = {
 		},
 		.op.do_one_request = dthe_hash_run,
 	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA512_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha512)",
+				.cra_driver_name = "hmac-sha512-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA512_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA384_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha384)",
+				.cra_driver_name = "hmac-sha384-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA384_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha256)",
+				.cra_driver_name = "hmac-sha256-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA256_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(sha224)",
+				.cra_driver_name = "hmac-sha224-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = SHA224_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
+	{
+		.base.init_tfm	= dthe_hash_init_tfm,
+		.base.init	= dthe_hash_init,
+		.base.update	= dthe_hash_update,
+		.base.final	= dthe_hash_final,
+		.base.finup	= dthe_hash_finup,
+		.base.digest	= dthe_hash_digest,
+		.base.export	= dthe_hash_export,
+		.base.import	= dthe_hash_import,
+		.base.setkey	= dthe_hmac_setkey,
+		.base.halg	= {
+			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct dthe_hash_req_ctx),
+			.base = {
+				.cra_name	 = "hmac(md5)",
+				.cra_driver_name = "hmac-md5-dthev2",
+				.cra_priority	 = 299,
+				.cra_flags	 = CRYPTO_ALG_TYPE_AHASH |
+						   CRYPTO_ALG_ASYNC |
+						   CRYPTO_ALG_NEED_FALLBACK |
+						   CRYPTO_ALG_KERN_DRIVER_ONLY |
+						   CRYPTO_ALG_ALLOCATES_MEMORY |
+						   CRYPTO_AHASH_ALG_BLOCK_ONLY |
+						   CRYPTO_AHASH_ALG_NO_EXPORT_CORE,
+				.cra_blocksize	 = MD5_BLOCK_SIZE,
+				.cra_ctxsize	 = sizeof(struct dthe_tfm_ctx),
+				.cra_reqsize	 = sizeof(struct dthe_hash_req_ctx),
+				.cra_module	 = THIS_MODULE,
+			}
+		},
+		.op.do_one_request = dthe_hash_run,
+	},
 };
 
 int dthe_register_hash_algs(void)
-- 
2.34.1

