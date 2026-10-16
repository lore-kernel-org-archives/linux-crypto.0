Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 516533EE1EE;
	Fri, 16 Oct 2026 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792151350; cv=fail; b=tNUP+qOzJa4qzB9Baa/GD1kCPSMpTysPeXJJUrMbMBxxPGMLB3z/HMvxHkEa2ZPnB9hrHqWP9jVBEpZkKk9LQLxCSu8EX0ZautrAp0y+Vumi1LQ8SpL/K1NoWqmuTQZS1UIeGenrWNQXbfVvvOLYWb3gVttftQOggZtSP8W4LSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792151350; c=relaxed/simple;
	bh=G20zV047MFd5iEJ6D3QSwBF3ONemvgI82QmZKSWTxmM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hjYuGGdhuO6GbBl5iY0+kCRumD1b543xiaELpypVW9/AF6g+Fo7MhoThGFQmIMlhLFzJ3JP1UXxg2snC4PlY4sBiTXGvN88BvvNU/FLLO+WH26mgkzu1S3/hZyLBsnR5uQKlgBnrfOJ0mDwMqjVMgMHmkd0WbzYWZw6bcm087og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=SUYDYJEw; dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b=SmUrXQTu; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="SUYDYJEw";
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.b="SmUrXQTu"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69GACxrX4171202;
	Fri, 16 Oct 2026 06:49:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=KPOCjh7Hdvl1YEbUWkoGHTwjjuJDdmifzZdJYfsQS
	mo=; b=SUYDYJEwNkzlNKQkBGQSf4lIRn4P8Ke61p7Hhg9rXbjSg77jxLzNicJNZ
	wPyKeu0nR6C6iUwc0wPvQinhMLpBi72XksDAgP3nNcp5pVhO3i4VHlZGsWASQHlJ
	1GcVssG6gRzQXCvry8KV5D/FcoXMIrB7PTtMAOBoaVxIbktNAC/ONQCdTdzeTu47
	zYwIIU2m2kFy4qXNfsJI4j1FXWVPyYtA8w5wVYXSN35tiUGO9F/fbisvk9IoUreU
	8WVL/4ycJtAv6x5zeCGFIkGJDmSOfJzNushsV4b6l1J58nfGiGL0Qt+SW70MMAA3
	xqjOeaJ5aQeil7GozBTbYsYoTrNKg==
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013056.outbound.protection.outlook.com [40.93.201.56])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hbhanrjnk-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Oct 2026 06:49:03 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UOhzdimWWXboUBSLAL5YaZYSqOuICdMdrhXWFn2kBUil+ojG9jKVqM4l0JQPvLugwRmtatesUtQZdCrIJfH/kAt0zXaUPaBALY1pZtJwzhxhPJ8ixjsut3lFG0zf0fRKtWqeZEqvBoNub+tBfQPY4S9b563JDz7wZEDfuTTvmCdagau+VepN8VQhV80ZdaJ4DwGAmGKdw3b08WY2WSO7mI8a9ID1onlprF+PVSaVNejnVsfaJ6wCOueNkOld14I5/ONtiSHcAKRJLTXL/pKQPLDnE5vJGBbXkj0YIAzkjvIsHdwO8/tSziZStx30/gQNva4lvL9VyTJ570Ao8VZByw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KPOCjh7Hdvl1YEbUWkoGHTwjjuJDdmifzZdJYfsQSmo=;
 b=Ojxpj8apQsJu26U7iXyzJZxzm+oxWFmu1gu2kr7/pJTi9GiXYKzM7qUe10QO/SKNG9zlIQ37lNZZlaDaI51XQ/P/CK+g+D6iBxHKP/gtJzOHN/Gi9Pcb7J4dgiatuxYUrFFqdqs7b7G/yCb8i1/MrlwNZL9Ihaaip7eVpzrG75tVedvUp+LA8ser8QE1QAvoWoIG1LM1URigjD4n4svYny5nK79DIy8VLpehDYLFbUWfhf1iDa4ihyF/8tf/VTsLAEmsQVyWkT8n51Yc72CS0dO5vAZVVYqIEalims4VV8kuV9xPujOljIuDXbHT3IJEDU/L0IulrvQoNEeCVkgWGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KPOCjh7Hdvl1YEbUWkoGHTwjjuJDdmifzZdJYfsQSmo=;
 b=SmUrXQTuvoIzlzMPcBXIAqSmOuw5aicuMSbDgbbB7+i7S6y+G/bDGR26ZzLxqNBn4eWsssURQ2BdYKn8hm1Q+i8GfnmZ5ZxK4MUcwBCpyq7H693NgAEB1Jsdc55FEqiTWp/3b/qj+PHSbW4wc98//ry4y0gTMG8YKOpRz5GI8zg=
Received: from BL1P221CA0042.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:5b5::7)
 by BN0PR10MB5047.namprd10.prod.outlook.com (2603:10b6:408:12a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.11; Fri, 16 Oct
 2026 11:49:00 +0000
Received: from IA0PEPF00000045.namprd04.prod.outlook.com
 (2603:10b6:208:5b5:cafe::a2) by BL1P221CA0042.outlook.office365.com
 (2603:10b6:208:5b5::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.522.17 via Frontend Transport; Fri,
 16 Oct 2026 11:48:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 IA0PEPF00000045.mail.protection.outlook.com (10.167.249.169) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.6 via Frontend Transport; Fri, 16 Oct 2026 11:48:58 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:34 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 16 Oct
 2026 06:48:34 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 16 Oct 2026 06:48:34 -0500
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 69GBmWFw1508621;
	Fri, 16 Oct 2026 06:48:33 -0500
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v9 04/15] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Fri, 16 Oct 2026 17:17:55 +0530
Message-ID: <20261016114806.1749515-5-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016114806.1749515-1-t-pratham@ti.com>
References: <20261016114806.1749515-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: IA0PEPF00000045:EE_|BN0PR10MB5047:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e7a9e98-f3ed-4d82-c751-08df2b7b76d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|36860700016|82310400026|56012099006|261009223027099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	LnFqailWR6XW9R7O77PTP0GgiID+AvHqIDFI/q5op2V+SMjFEf0mnWSxdUnjHRTq1/wImmI0LfXd99C3Py7RTu+DIWFIQT0PvotidLEruU+JTQXG/E8dDGJQWpEIBGU6Srx07m2SaoxIFzZV6xyotp5fV4YM+QTb6eW7L5z0EqK4s/fFGBtRQgU+XQVWxSIkQknKqgEi4LMAe5V3BXDsaDRmF73jyYKWgNN2sImPmgbjdvqPhRIi/DB6qdnRwFy7sN+WxOMlM2R35m6ilfNeChsh3IVRaJmZ+htYiDgAOEOqHzT6KZ0bJEBNInvwwNan5T8W6Miu/rntJ4znw1F1SNRH1Xny5s0WKc4fb8m7qmVpJXDj4ecokAYfU5ht+8kmQlh0ul1ehu5LqJzHCPIhAMVCOZkc+8V8P0xwtj23MmOM1WQgEYVH+BhIUMWW3SkmhoWbGUlPXvdEFZOPEcfXvKt1ZbNnKWeP+qtI/jw15CSi+Xc7VO0hKdUbB5WDHz8pVnMwfYDV2f0Q5uEu5mA/GvtLrSVx5bSG/jOcBRnqb327yqNFVcA41o/IMtboayRaL2s7ePiPyrKOA5bBe2r64Js7mUvMLH1VQF4TwOcM8+LvVIuja27iH5hBcpjkk8OT/5pp26iQuWL4+TqiDVJHUUKxIN16zZtlff8RIDLlHZg0wI+ahHJC3HqHxIZ4GSK0zqt4R5pB8qJk18k905ZEog==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(36860700016)(82310400026)(56012099006)(261009223027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Jyy1sUj1QlHuz30hNCgcE8on+ilgjBESh2ZiAJ0KO9zKuPu1qfG7ZMz0khkUlGHtzOm2R4wt0d1v5C8ahLuJUcDtYJo6/JjkdmrR6MfCuzWrBi9WjTh9IO5hGHmkha0qlwwgVUbgOA7Aw0tQp8IC5AX25qUKWJtPeuvVPymUa1iiy2kckToLB3YYLddYI/CVT9UEUcbZdhGdM3KmTppBDyrt6QCwz7bvtyHpbRXKhnSSGinaYLdnvoR4S4tThqFpyM9mWsmWMOUJOHugonbnFXdnl7p5No3D+6/anmyHrsDPaFe2A1INU6TbJvAmnJltQfITeSsMqsgMqcYd6QOVZkFpdXa6UwPsKjXVl1ylo3VfyTQVf6AKRuw7SEA8YOPBJhn8cB7rN+4xVkYXeg/j1grRbwcLc7dfZmO1z7XE1YvrYidJQqNwfWv3kSc+qmSO
X-Exchange-RoutingPolicyChecked:
	0ISj/x+6Bqbtx/2i8z47ArFNWBRteo/5m8hOf8hE1j2hFuhEGwK9oIwpg+9+whRCWyjD1EfdPM89it9cc1pQczdaud2hvqYTnbhHfnOA4BjMmQV9Z2xMcamvzhqhiFtmejWtCYbt0+bTrUuRxIYO+GJzMtqD9N/FYMZWW4DD0aSwm5JfSNMR978jo+BxFKaBqoZ2UIroL6FZyONI7rv5PR0Eik5BF1AAb8LGHK//uNlr3j19R9L8r9/bhc1EGpC4Khcb0+/mO2IOmTimGk4g+of48XfAUisUE8Nz5KQAukP7UvJYuEhT6aQ1wYt5bvwDHBiTMQeF0Ob9hMkD6QoHcA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 11:48:58.3096
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e7a9e98-f3ed-4d82-c751-08df2b7b76d0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	IA0PEPF00000045.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5047
X-Proofpoint-ORIG-GUID: y4qY1Ocedr1FJxTBYNQ-C1BlPOM6OWob
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX4Q0zOYLVzYBV
 c6LCmN1bfSYD/2Za/+4wevqlmebRDbDw2eRiVa0DUz2D2I7IggmVsprIA8sqatxBa+6KUgwNSIP
 SqataddIRNjoueL5gGCMvTNTpGq/M20ZtDRm3nlN5safY/Hg6dVLvdxUqwR9/ycc8jT6KXKFQJO
 QYSipE1vTVYK7abArHK8QLzIjz7RPAinA+Y2Mmcg1cBkBOyqeTe7BWcLoCemAENk0FpidNgKs3W
 FlyC5DVMfyAUlcEILlWNu0A30uouYe7rxPvXBH2l5zif6MeJXaJbwM8VnLKYLKCP9jyYNbxRoRk
 nNeBdUJ/dlaadKpCc3sz80Qi3RSaUUIfCVzOcvgdQq1MlKbpu0n3BZUDwwj6qrfGrD9qzbJ9n0+
 IXplTSQR7E7gL2LjIME7eRDcVpcTU++/731IZsfoyP8BPtGHvTclGq7NaTiluUdf7rez7DU3QQ0
 MoKOv5Dl++ivp/tlWpg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDA0NiBTYWx0ZWRfX5jY9Iojqu+6L
 ulrNOq9z+BH6kkAFqgFgzsXFwh/X4DgcEJyWmKbUoaFP9Pg5TOA/YSXWHhXJ/jPev5HarHz25b+
 YFgQJkbq9uO5jneq6p/rtjmQrpsthx4=
X-Authority-Analysis: v=2.4 cv=NvhE4MdJ c=1 sm=1 tr=0 ts=6ad20f2f cx=c_pps
 a=nYaA4L0hYP7ZHAKl0WLIGg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=660iZSQnnn4A:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22
 a=sozttTNsAAAA:8 a=QiMhJC1N2krko7GUhYQA:9
X-Proofpoint-GUID: y4qY1Ocedr1FJxTBYNQ-C1BlPOM6OWob
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-16_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 spamscore=0 clxscore=1015 suspectscore=0
 lowpriorityscore=0 malwarescore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610160046

Each *_init_tfm() caches a pointer to the per-instance struct dthe_data
in its transform context (ctx->dev_data), but never takes a reference on
it. If there are tfms in progress when dthe_remove() is called, the devm
allocated dev_data gets freed. Then ctx->dev_data will point to a memory
that has been freed.

Move dthe_data to req_ctx structs of algorithms, and store the device
pointer in tfm_ctx. Add a kref refcnt to struct dthe_data, which
maintains a count of number of requests enqueued in the crypto engine
queue which reference the dthe_data object.

On reaching zero, this counter triggers a completion which is waited on
in dthe_remove() before doing the driver teardown.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 74 +++++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.c | 49 +++++++++++++++++---
 drivers/crypto/ti/dthev2-common.h | 52 ++++++++++++++++++++--
 3 files changed, 143 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 4fdd24ee91637..6a8fbe67ef6cd 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -110,12 +110,11 @@ enum aes_ctrl_mode_masks {
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
 
 	return 0;
@@ -124,20 +123,19 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
-
 	ctx->skcipher_fb = crypto_alloc_sync_skcipher(alg_name, 0,
 						      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->skcipher_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->skcipher_fb);
 	}
 
@@ -149,6 +147,7 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -225,7 +224,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 ctrl_val = 0;
 
@@ -337,8 +336,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
 	struct scatterlist *src = req->src;
@@ -520,14 +519,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
+	int ret;
 
 	/*
 	 * If data is not a multiple of AES_BLOCK_SIZE:
@@ -553,8 +555,18 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 		return 0;
 	}
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_skcipher_request_to_engine(engine, req);
+	ret = crypto_transfer_skcipher_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
@@ -576,19 +588,18 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
 static int dthe_aead_init_tfm(struct crypto_aead *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	const char *alg_name = crypto_tfm_alg_name(crypto_aead_tfm(tfm));
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
-
 	ctx->aead_fb = crypto_alloc_sync_aead(alg_name, 0,
 					      CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(ctx->aead_fb)) {
-		dev_err(dev_data->dev, "fallback driver %s couldn't be loaded\n",
+		dev_err(ctx->dev, "fallback driver %s couldn't be loaded\n",
 			alg_name);
+		dthe_put_dev(ctx->dev);
 		return PTR_ERR(ctx->aead_fb);
 	}
 
@@ -600,6 +611,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 /**
@@ -711,9 +723,9 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
 	return crypt_sg;
 }
 
-static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
+static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 val;
 	int ret;
@@ -734,11 +746,12 @@ static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag);
+	ret = dthe_aead_read_tag(rctx, tag);
 	if (ret)
 		return ret;
 
@@ -753,12 +766,13 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
 
-	ret = dthe_aead_read_tag(ctx, tag_out);
+	ret = dthe_aead_read_tag(rctx, tag_out);
 	if (ret)
 		return ret;
 
@@ -859,7 +873,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int assoclen = req->assoclen;
@@ -1130,6 +1144,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
@@ -1137,10 +1152,11 @@ static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
 	bool is_zero_ctr = true;
+	int ret;
 
 	/* In decryption, last authsize bytes are the TAG */
 	if (!rctx->enc)
@@ -1191,8 +1207,18 @@ static int dthe_aead_crypt(struct aead_request *req)
 	    (ctx->aes_mode == DTHE_AES_CCM && !is_zero_ctr))
 		return dthe_aead_do_fallback(req);
 
+	dev_data = dthe_get_drvdata(ctx->dev);
+	if (!dev_data)
+		return -ENODEV;
+
+	rctx->dev_data = dev_data;
+
 	engine = dev_data->engine;
-	return crypto_transfer_aead_request_to_engine(engine, req);
+	ret = crypto_transfer_aead_request_to_engine(engine, req);
+	if (ret != -EINPROGRESS && ret != -EBUSY)
+		dthe_put_drvdata(dev_data);
+
+	return ret;
 }
 
 static int dthe_aead_encrypt(struct aead_request *req)
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index ca8bab4950d28..9ab97b72f7ed2 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -31,22 +31,54 @@ static struct dthe_list dthe_dev_list = {
 	.lock = __SPIN_LOCK_UNLOCKED(dthe_dev_list.lock),
 };
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx)
+struct device *dthe_get_dev(void)
 {
 	struct dthe_data *dev_data;
-
-	if (ctx->dev_data)
-		return ctx->dev_data;
+	struct device *dev = NULL;
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	dev_data = list_first_entry_or_null(&dthe_dev_list.dev_list, struct dthe_data, list);
-	if (dev_data)
+	if (dev_data) {
 		list_move_tail(&dev_data->list, &dthe_dev_list.dev_list);
+		dev = get_device(dev_data->dev);
+	}
+	spin_unlock_bh(&dthe_dev_list.lock);
+
+	return dev;
+}
+
+void dthe_put_dev(struct device *dev)
+{
+	put_device(dev);
+}
+
+struct dthe_data *dthe_get_drvdata(struct device *dev)
+{
+	struct dthe_data *dev_data;
+
+	spin_lock_bh(&dthe_dev_list.lock);
+	dev_data = dev_get_drvdata(dev);
+	if (dev_data)
+		kref_get(&dev_data->refcnt);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	return dev_data;
 }
 
+static void dthe_release_drvdata(struct kref *kref)
+{
+	struct dthe_data *dev_data = container_of(kref, struct dthe_data, refcnt);
+
+	complete(&dev_data->drain_compl);
+}
+
+void dthe_put_drvdata(struct dthe_data *dev_data)
+{
+	spin_lock_bh(&dthe_dev_list.lock);
+	kref_put(&dev_data->refcnt, dthe_release_drvdata);
+	spin_unlock_bh(&dthe_dev_list.lock);
+}
+
 struct scatterlist *dthe_copy_sg(struct scatterlist *dst,
 				 struct scatterlist *src,
 				 unsigned int buflen)
@@ -152,6 +184,9 @@ static int dthe_probe(struct platform_device *pdev)
 	if (IS_ERR(dev_data->regs))
 		return PTR_ERR(dev_data->regs);
 
+	kref_init(&dev_data->refcnt);
+	init_completion(&dev_data->drain_compl);
+
 	platform_set_drvdata(pdev, dev_data);
 
 	spin_lock_bh(&dthe_dev_list.lock);
@@ -202,10 +237,14 @@ static void dthe_remove(struct platform_device *pdev)
 
 	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
+	platform_set_drvdata(pdev, NULL);
 	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
+	dthe_put_drvdata(dev_data);
+	wait_for_completion(&dev_data->drain_compl);
+
 	crypto_engine_exit(dev_data->engine);
 
 	dma_release_channel(dev_data->dma_aes_rx);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 75d9a097650da..03a0b426041ac 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -18,6 +18,7 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
@@ -53,6 +54,9 @@ enum dthe_aes_mode {
  * @dma_aes_rx: AES Rx DMA Channel
  * @dma_aes_tx: AES Tx DMA Channel
  * @dma_sha_tx: SHA Tx DMA Channel
+ * @refcnt: Count of requests currently using this instance.
+ * @drain_compl: Completed whenever @refcnt drops to zero; waited on by
+ *		 dthe_remove().
  */
 struct dthe_data {
 	struct device *dev;
@@ -64,6 +68,9 @@ struct dthe_data {
 	struct dma_chan *dma_aes_tx;
 
 	struct dma_chan *dma_sha_tx;
+
+	struct kref refcnt;
+	struct completion drain_compl;
 };
 
 /**
@@ -78,7 +85,7 @@ struct dthe_list {
 
 /**
  * struct dthe_tfm_ctx - Transform ctx struct containing ctx for all sub-components of DTHE V2
- * @dev_data: Device data struct pointer
+ * @dev: Device this transform is bound to.
  * @keylen: AES key length
  * @authsize: Authentication size for modes with authentication
  * @key: AES key
@@ -87,7 +94,7 @@ struct dthe_list {
  * @skcipher_fb: Fallback crypto skcipher handle for AES-XTS mode
  */
 struct dthe_tfm_ctx {
-	struct dthe_data *dev_data;
+	struct device *dev;
 	unsigned int keylen;
 	unsigned int authsize;
 	u32 key[DTHE_MAX_KEYSIZE / sizeof(u32)];
@@ -103,16 +110,55 @@ struct dthe_tfm_ctx {
  * @enc: flag indicating encryption or decryption operation
  * @padding: padding buffer for handling unaligned data
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
+ * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
 	u8 padding[2 * AES_BLOCK_SIZE];
 	struct completion aes_compl;
+	struct dthe_data *dev_data;
 };
 
 /* Struct definitions end */
 
-struct dthe_data *dthe_get_dev(struct dthe_tfm_ctx *ctx);
+/**
+ * dthe_get_dev - Get the device pointer after increasing its reference count
+ *
+ * Description:
+ *    Picks a device instance and gets the associated device pointer through get_device()
+ *    to maintain its reference count by the kernel itself. Callers must ensure to call
+ *    dthe_put_dev() at exit to decrease the refcnt.
+ */
+struct device *dthe_get_dev(void);
+
+/**
+ * dthe_put_dev - Decrease the reference count of the device
+ * @dev: Device pointer to be released
+ *
+ * Description:
+ *    Decreases the reference count of the device pointer obtained through dthe_get_dev()
+ *    by calling put_device().
+ */
+void dthe_put_dev(struct device *dev);
+
+/**
+ * dthe_get_drvdata - Get a reference counted device driver data pointer
+ * @dev: Device pointer
+ *
+ * Description:
+ *    Returns the instance's driver data if it is still bound, with @req_refcnt
+ *    incremented, or NULL if it has been removed. Every req accepted for
+ *    processing must call this and balance it with exactly one
+ *    dthe_put_drvdata() when done.
+ */
+struct dthe_data *dthe_get_drvdata(struct device *dev);
+
+/**
+ * dthe_put_drvdata - Decrease the refcnt of the device driver data acquired through
+ *		      dthe_get_drvdata()
+ * @dev_data: Driver data previously returned by dthe_get_drvdata()
+ */
+void dthe_put_drvdata(struct dthe_data *dev_data);
 
 /**
  * dthe_copy_sg - Copy sg entries from src to dst
-- 
2.34.1

