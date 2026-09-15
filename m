Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE56D480DD3;
	Tue, 15 Sep 2026 09:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466181; cv=fail; b=Y1hKbga4dNwRLyIzfBnPpIe2AVaEUV7/wlrE0bJkg13LcOAYoZIPFnY2PdouHHH1a+JybYB/MTVR7O01oX1jGa4iSo5GbSKiF3p4OcKj++k/ogPP597/YYwJal90k9doLQoyuWFEMU7/xaSrtV1IP21JJT+fMnDwLKqD+DP/bTQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466181; c=relaxed/simple;
	bh=X+vlVKmp+L7sIy+7bps2uygyt+kkr+LDb2zTj6q9suI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=qBT+VJH9Wqu7bDdpN/cvthFw3F1jvpnvUo0RlaKg266PlO1TZCiR+Z2Yv7st1JhMYZ039tMQqhtf34TaeoSOVozG6CWuANLjiau7ZGIqOkerAX1Lq3cE10Dus3pxS57fQy08Bm+e6Hw/03Pn0rU5rAOwCi3bqdfGbFcNUwkgjO0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=Hn5InGpm; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=hP3AYyvs; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="Hn5InGpm";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="hP3AYyvs"
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fLVB4098112;
	Tue, 15 Sep 2026 04:56:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=L9yjm25NU5IcRHFTyU+vw73TYQHwaZz28rjyo3mTw
	Tw=; b=Hn5InGpmAE6Zamsbw6rDuUXXbhpG6KszT8Yl9VHevpWi4REBGXlt06RWL
	Sc9nNbLO4lhpsXhViRlaSMJfHIi1k/UFYAT8ADwLPN0TQqtyQs2r3hB5lmPcL7JC
	SDHlxvJvFt2LV1mIRvLe/bnrRk7zlWpY5+Powo6FGVN8s/fx2miPqa3Q7+2ktODd
	Nxevzis7It6h+JzGsq6L8A79QU3oD4rDbUWBf/ea3IuHMdmclaIahq4rRHr0flkg
	TTY+ot6X3k+5YN/SsY6z4JOTy78fCEPgipSKU/BBMcOhfGEnJNQcx0Jqs1lFjd3f
	icK1FzyyinJ8qz4zYJk842onXc5Kw==
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010010.outbound.protection.outlook.com [52.101.46.10])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gpvpjakff-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:13 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YHTMrGqqWBtRJuHLpwRq0aMtfkS/45d45HyFlZbEMPnSQW6hbTvdS3MmQjnswpwBonrunKvmIrtVoMsFQiibz2hXcINCfI5eP3xUY4Fc8pts1OtsfH7yDhYmklIk//PuLm2DwmBNhlXj+RGLD2xN4e3aMHjCEiswdnMpLhxgijfFwczSUS3fIO0yQ8V0p9w8j5rdtQOPBCJ76u8/zTuIPrYO44bs5SzvXlaLq2Hps88Hhbbnxq20B6qmqvDCJ7yMmtWly0MvhXblSY0WNGfh0uzFRawxUHg17T/Hr7EDehPyRD8WnGsrUmryyTT0LyFoipCoalTryPAn3Sw++vi0xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L9yjm25NU5IcRHFTyU+vw73TYQHwaZz28rjyo3mTwTw=;
 b=OiylQsoQ1huomk167heJm+YhoUHBFTVr42held0BmztWU+uXyt20I28l2uXEOLOnVsq4xlh5tr7KllZDd0fa/2asqp9qoC4kVoeA9aQ+10ndv3ql5s2qVzadTNcX1MYjVk1mtu5JOaPCeEluTxVa8z9ZyrLJ7hrFzbnApHNp7TCbjlJUdtr2JESaDxdqg4L3aWwX+BXosYVSpUh0C5n0+SFIPW7rRfQ2LL6AEy4j5H5Hd4MB9Ey0oFbgqJ5Y7dPgbMXV32mCv8LN+7iajgawCKfuFGm7ri7F8foiHXizUZoXGrJFWCKstcKH2XkTZ30aetdXB632wa9rMrwa/Ue4ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9yjm25NU5IcRHFTyU+vw73TYQHwaZz28rjyo3mTwTw=;
 b=hP3AYyvs0a2BMi+Z02PbACzfSfkA6idGZju2Dn54HlV8YVZeLnVd20AVDwZGCIOZ+JBBkfHhsoIjpHv+LlKUscJ7LuCRePV8cBrdP6EcQOSiGxQPtV7v4iYQJ3oeFeesopJTd7D58y+Nas0ktNSKfmeYegPGk1/hKUAx2Q1qHMY=
Received: from SJ2P220CA0005.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5da::17)
 by DS7PR10MB7177.namprd10.prod.outlook.com (2603:10b6:8:e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:09 +0000
Received: from MWH0EPF000C6187.namprd02.prod.outlook.com
 (2603:10b6:a03:5da:cafe::32) by SJ2P220CA0005.outlook.office365.com
 (2603:10b6:a03:5da::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Tue, 15
 Sep 2026 09:56:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 MWH0EPF000C6187.mail.protection.outlook.com (10.167.249.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:07 +0000
Received: from DFLE214.ent.ti.com (10.64.6.72) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:25 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE214.ent.ti.com
 (10.64.6.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:25 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:25 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7r3000901;
	Tue, 15 Sep 2026 04:55:22 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:09 +0530
Subject: [PATCH 03/30] crypto: sa2ul - remove unused algorithm ID fields
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-3-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=6314;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=X+vlVKmp+L7sIy+7bps2uygyt+kkr+LDb2zTj6q9suI=;
 b=gWA27bQoJMSgF/npngNDCdOVqh28H/iCJg+EctEp+VE4qwYfuolqfhBPn7unOL9tOSWnBPHml
 60PCssZDzO3A+pAtbkO/trP83AChT+xkAf7Dg0r6vCdG9j9bND5P8Q0
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6187:EE_|DS7PR10MB7177:EE_
X-MS-Office365-Filtering-Correlation-Id: eb9db906-0669-4347-f2cb-08df130f9051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|82310400026|36860700016|1800799024|56012099006|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	9uXdVI89Il8ky3JOew+D1zRo0mtQIelN76qs/Eqy83eesROiHIwNRrreBwE4zoJomWlSpememtjCPynSfxVvepqZAKO1btBIs9FZQelr41uvpFRYdLQjXTUzEJ0Z2HleEnfaUar9KLa6IJAdfRbf1413U2OyDlhzVZ59JiFXDYumzOxFMbyJZk4GjIuUVF8bS24TC4dxxr2LF7498WTS0lseclkrZ5cbswR5WHUcG8wwSgd6EjkU36V43grsPGLQ3lh5NBg1zM+9IlCAJDaX+9CqUuuceL+mqjyWChyMiUoPb7GeBhNMevpmJTWLatYp2lWpiKPjW8lbExeUx7ISvTlADI3rQUvKuaNUu7jpDYgQC6om1i0a9MXmtTH3txNs4HEpXUOwEPuOI2/cU+QcjZoyP0SpiqfNrxboAClrZbnLddpfVci+r0cYOMrqyJQUvCMZ2pKIYQ+ASDmbtpf8a7oIcJU5Q4oHdNysv9juPnQtVC3/W0VtoQMFRGAN4yNolSECGeE7U0Bd0qLoZZUykjuy+YMH+/1iVNvaLja7gSCltf+OvgBM1144rsAe1P1WteeTQZArjP7S3gbQxjmQ6J+e6BZqopY+Bt8vHQZ1nP5G6bhxloSIaCOwQ7sP3XqZBUBClUW0zQ5PhqoiOiurCntiItiU/JnO3LCTcSVr0LlvSqJZEE/7X5He9TOvYd1i2eth5R0f4Tr9F5S45T0o9A==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(82310400026)(36860700016)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	rwxFwWJvMNKrUmEXF4hCo1ER8fdAe5xD2kNWjfDULG9+Vv1B3feG/bdmp2dN3sBlJmNIzEv6+qwY81aUtb9ooGqG39GB5RGUemvrMpfKzN5Y6y8WeQ/dhiIHKUcsfRAH5pvhBl5s/efmtNPixupbLU5kcVogT2QqlflH5UVvtY6m5veixc2X1jnS52GdPALwBJr9x129W0bpPOymOrC8l2TJ1GColt0kY6bFJx9U/jIM+7swRVQjvkX9NGmidjU02ijo0XWnCdzT4TJMBck6bJiN4vNb/FnH0x4xEoY+NEHLouNhE2YwLE4DIlDgsI+CnwhSFGD7gEanasvyBY4Sd5ogF6YMKY9eigawrY1TmiaHnsCFyZ4zXhsUA8hEz1CKAZVZHDb+0pEo5Tq52J8WYlg9aOHM7+shIfDX1k/qW9UDkEEZ/hrqxEvNqctyFL8N
X-Exchange-RoutingPolicyChecked:
	YIG85A1E7qpqXVFVfyQbWTui5ZfU1vw3gPUazYXjaAB8mJMrwPiubqEZW/qKi1RLcOsz6bpcq656QgLL/Z/H/Jjrz8A2RI5E4++tM6EsGpgvwE58FP8bFg7pRtAPWPir1B5EsRKIxMXSMpk+i3SCR1BBQt+gw2yb3OMTqfZx30wRDQzUXcRjO2dt/Gd8CqomxVEZUtIxf8TkajiprdB54V3wgUy+ydf8pBAAHshGMwOFzZNO1H/doAbJdbPFgrI+nkzeuYDz/IwzXZRraYxLkcBzxFWSCukIq9X88WfmyD9uEfZ2M8FOsovIIN5whE0uQ+lpe5E4xKg7/8GoyXpLDA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:07.5381
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eb9db906-0669-4347-f2cb-08df130f9051
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6187.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7177
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXwcMq45AUkUJb
 KOYaUCuWIyX50KWEnYKmsvw47Fqy9wAgPgghhilTaJTcNlt+a0Nq7Nx+NQkIL+BOoiBXIkrArIL
 aunVTqhoDM0twnBd/TtN5hUZGAWWdDM=
X-Authority-Analysis: v=2.4 cv=KvnYSmWN c=1 sm=1 tr=0 ts=6aa9163d cx=c_pps
 a=Szpykk5hBk3mC7HHiWFpbQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=luWjcLmAkgMxxOjGXh0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: _Zl3NFgOHD0t_hxhHsoTPb4iAWXtdqXd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX+1mE7gqK8Awm
 LT5CNd6lWvxYxBYcCuB9q0FvBaRkIYrwMoeK3kh8FsafV/Ww9fr1c0xXDZTgr/ka/Ldo5eLKld7
 7X28lJhsFgFjC/w+mZh4EiJkvEWHeqgEb0omcIl1l22QqgDqhLKCObYPS34SwEicuhxVEu8Uf+P
 /vqcNec2NWsjzQA65TOagI3RC+edvrzNYqI/PaKlSv073bSku48pm5RtX+F0k2j8DCu6SBfdu6+
 LqUFYPjlk/S/E9aDs1IaMabBjyaMh1tprhMDeB+iMUwqnYnk+aoEG2ZR6hFX0GtsR2QDLPphCzA
 v+hqRKMmFv8BT8UD5FiCdaTFlRXYblTLadp0DL0NV8S4v2Y2cWY7OxwORU8/wzq4crq7oJJjdn3
 eOKAc+WFCdxS1C154nHFhOVyJVmLGAUwGYIBdIJgKhZwaryNw+PzmgDuZlBiOIcyMlplju8Hi5g
 Fj7UltoZuIwn83HlLZw==
X-Proofpoint-GUID: _Zl3NFgOHD0t_hxhHsoTPb4iAWXtdqXd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

These algorithm ID fields were never referenced. Remove them.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 19 -------------------
 drivers/crypto/sa2ul.h | 34 ----------------------------------
 2 files changed, 53 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index f7e4f58c02c2..3297a25d9d9d 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -92,7 +92,6 @@ static struct device *sa_k3_dev;
 
 /**
  * struct sa_cmdl_cfg - Command label configuration descriptor
- * @aalg: authentication algorithm ID
  * @enc_eng_id: Encryption Engine ID supported by the SA hardware
  * @auth_eng_id: Authentication Engine ID
  * @iv_size: Initialization Vector size
@@ -101,7 +100,6 @@ static struct device *sa_k3_dev;
  * @enc: True, if this is an encode request
  */
 struct sa_cmdl_cfg {
-	int aalg;
 	u8 enc_eng_id;
 	u8 auth_eng_id;
 	u8 iv_size;
@@ -118,8 +116,6 @@ struct sa_cmdl_cfg {
  * @hash_size: Size of digest
  * @iv_idx: iv index in psdata
  * @iv_out_size: iv out size
- * @ealg_id: Encryption Algorithm ID
- * @aalg_id: Authentication algorithm ID
  * @mci_enc: Mode Control Instruction for Encryption algorithm
  * @mci_dec: Mode Control Instruction for Decryption
  * @inv_key: Whether the encryption algorithm demands key inversion
@@ -134,8 +130,6 @@ struct algo_data {
 	u8 hash_size;
 	u8 iv_idx;
 	u8 iv_out_size;
-	u8 ealg_id;
-	u8 aalg_id;
 	u8 *mci_enc;
 	u8 *mci_dec;
 	bool inv_key;
@@ -934,7 +928,6 @@ static int sa_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	ad.mci_enc = mci_cbc_enc_array[key_idx];
 	ad.mci_dec = mci_cbc_dec_array[key_idx];
 	ad.inv_key = true;
-	ad.ealg_id = SA_EALG_ID_AES_CBC;
 	ad.iv_idx = 4;
 	ad.iv_out_size = 16;
 
@@ -954,7 +947,6 @@ static int sa_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	ad.mci_enc = mci_ecb_enc_array[key_idx];
 	ad.mci_dec = mci_ecb_dec_array[key_idx];
 	ad.inv_key = true;
-	ad.ealg_id = SA_EALG_ID_AES_ECB;
 
 	return sa_cipher_setkey(tfm, key, keylen, &ad);
 }
@@ -966,7 +958,6 @@ static int sa_3des_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
 
 	ad.mci_enc = mci_cbc_3des_enc_array;
 	ad.mci_dec = mci_cbc_3des_dec_array;
-	ad.ealg_id = SA_EALG_ID_3DES_CBC;
 	ad.iv_idx = 6;
 	ad.iv_out_size = 8;
 
@@ -1429,7 +1420,6 @@ static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 
 	memset(ctx->authkey, 0, bs);
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.aalg = ad->aalg_id;
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
 	cfg.iv_size = 0;
@@ -1577,7 +1567,6 @@ static int sa_sha1_cra_init(struct crypto_tfm *tfm)
 
 	sa_sha_cra_init_alg(tfm, "sha1");
 
-	ad.aalg_id = SA_AALG_ID_SHA1;
 	ad.hash_size = SHA1_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA1;
 
@@ -1593,7 +1582,6 @@ static int sa_sha256_cra_init(struct crypto_tfm *tfm)
 
 	sa_sha_cra_init_alg(tfm, "sha256");
 
-	ad.aalg_id = SA_AALG_ID_SHA2_256;
 	ad.hash_size = SHA256_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA256;
 
@@ -1609,7 +1597,6 @@ static int sa_sha512_cra_init(struct crypto_tfm *tfm)
 
 	sa_sha_cra_init_alg(tfm, "sha512");
 
-	ad.aalg_id = SA_AALG_ID_SHA2_512;
 	ad.hash_size = SHA512_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA512;
 
@@ -1770,12 +1757,10 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 	ad->mci_dec = mci_cbc_dec_no_iv_array[key_idx];
 	ad->inv_key = true;
 	ad->keyed_mac = true;
-	ad->ealg_id = SA_EALG_ID_AES_CBC;
 	ad->prep_iopad = sa_prepare_iopads;
 
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.enc = true;
-	cfg.aalg = ad->aalg_id;
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.auth_eng_id = ad->auth_eng.eng_id;
 	cfg.iv_size = crypto_aead_ivsize(authenc);
@@ -1831,8 +1816,6 @@ static int sa_aead_cbc_sha1_setkey(struct crypto_aead *authenc,
 {
 	struct algo_data ad = { 0 };
 
-	ad.ealg_id = SA_EALG_ID_AES_CBC;
-	ad.aalg_id = SA_AALG_ID_HMAC_SHA1;
 	ad.hash_size = SHA1_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA1;
 
@@ -1844,8 +1827,6 @@ static int sa_aead_cbc_sha256_setkey(struct crypto_aead *authenc,
 {
 	struct algo_data ad = { 0 };
 
-	ad.ealg_id = SA_EALG_ID_AES_CBC;
-	ad.aalg_id = SA_AALG_ID_HMAC_SHA2_256;
 	ad.hash_size = SHA256_DIGEST_SIZE;
 	ad.auth_ctrl = SA_AUTH_SW_CTRL_SHA256;
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 847d6586c036..097a496067e1 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -316,40 +316,6 @@ struct sa_sha_req_ctx {
 	struct ahash_request	fallback_req;
 };
 
-/* Encryption algorithms */
-enum sa_ealg_id {
-	SA_EALG_ID_NONE = 0,        /* No encryption */
-	SA_EALG_ID_NULL,            /* NULL encryption */
-	SA_EALG_ID_AES_CTR,         /* AES Counter mode */
-	SA_EALG_ID_AES_F8,          /* AES F8 mode */
-	SA_EALG_ID_AES_CBC,         /* AES CBC mode */
-	SA_EALG_ID_DES_CBC,         /* DES CBC mode */
-	SA_EALG_ID_3DES_CBC,        /* 3DES CBC mode */
-	SA_EALG_ID_CCM,             /* Counter with CBC-MAC mode */
-	SA_EALG_ID_GCM,             /* Galois Counter mode */
-	SA_EALG_ID_AES_ECB,
-	SA_EALG_ID_LAST
-};
-
-/* Authentication algorithms */
-enum sa_aalg_id {
-	SA_AALG_ID_NONE = 0,      /* No Authentication  */
-	SA_AALG_ID_NULL = SA_EALG_ID_LAST, /* NULL Authentication  */
-	SA_AALG_ID_MD5,           /* MD5 mode */
-	SA_AALG_ID_SHA1,          /* SHA1 mode */
-	SA_AALG_ID_SHA2_224,      /* 224-bit SHA2 mode */
-	SA_AALG_ID_SHA2_256,      /* 256-bit SHA2 mode */
-	SA_AALG_ID_SHA2_512,      /* 512-bit SHA2 mode */
-	SA_AALG_ID_HMAC_MD5,      /* HMAC with MD5 mode */
-	SA_AALG_ID_HMAC_SHA1,     /* HMAC with SHA1 mode */
-	SA_AALG_ID_HMAC_SHA2_224, /* HMAC with 224-bit SHA2 mode */
-	SA_AALG_ID_HMAC_SHA2_256, /* HMAC with 256-bit SHA2 mode */
-	SA_AALG_ID_GMAC,          /* Galois Message Auth. Code mode */
-	SA_AALG_ID_CMAC,          /* Cipher-based Mes. Auth. Code mode */
-	SA_AALG_ID_CBC_MAC,       /* Cipher Block Chaining */
-	SA_AALG_ID_AES_XCBC       /* AES Extended Cipher Block Chaining */
-};
-
 /**
  * struct sa_eng_info: Security accelerator engine info
  * @eng_id: Engine ID

-- 
2.43.0

