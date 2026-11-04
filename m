Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771156;
	b=2sRFfUUiMFYlxHl240FcphL+qLdYKE2bGK6pWpNrSIv6iZcXznzy1p/QTLkK5jUdiwQh
	 P4s30XypJFHDGbN+4zhFOHQGnMb0CQ0Rgj3Ot0vmy639VqwCFYN/5Ucz0++eGR4nFg25C
	 fFYHKOSHWzDaKUw9OGJsGOFYPq6cMV89pZ3D6/LrvtgsQcC16gtRXzCshbACWlbl7muw3
	 3Wm9T6/6SvHtKSUB7M6PKl1PT1MSCtV5ennhUnG0unREM15T5tbJaN0S2iYIsZe4//MKN
	 WBs807oudTvBGgNoeamP3cEj11rvOslKLDfDidgPjY5FpSUlWsgJ2NZptPIXthD3QQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771156;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:Date:Subject:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID:
	 References:In-Reply-To:To:CC:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=bTgA/Zx5hQ3OAawYsrnvG3wvUZdT1++nSOY4m+Jgbso=;
	b=PlGNWd8I3FWg28NEkhQ1HH4pCOwVHVHfmcxybte+LOpdJ06mD10CKf+HK/GNRLBbWkzs
	 POZ3SE5eE6XjhkkE1GvVaPu9v64lxvhYrxEkunbPYdMkEUrDG1vPSS9oqY+U7aPT9ie6p
	 g759cbuVndbFsPM75JG8nMukTE/CQVp3CpW4U+hNBXlrU33glyTAgEzBNdxV4A4IRR27w
	 VyBdmOL3ag5Hy0GYKZOMPNIUXXQsAdnEAAoYPltzXvzOeUWZSVpIQGBKrdqic/rFD3fs8
	 yvczJlzYb5XTTCPZmYpmff91iyHSiK+9r2jH0AeKUUPpTwtKSWsxqU6h3XwrqgliyOg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b="Opbu/jtg";
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b="qxb/P+t8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD403606A31B;
	Wed,  4 Nov 2026 05:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD403606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=Opbu/jtg;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=qxb/P+t8
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A41c5Xh1167030;
	Tue, 3 Nov 2026 23:45:52 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=bTgA/Zx5hQ3OAawYsrnvG3wvUZdT1++nSOY4m+Jgb
	so=; b=Opbu/jtgUmL1GlgsdiVh7KnFyTiT7xLiwFLdwq76jPoJBnMiC+2HVkVYa
	UDAu9psHhvT5lrvgaybp+rKUbXJDMnbNnCQptfWScWH03ZXHEfOL+6w0hg5QAx/W
	2nnIZ1UqEJ+eChZY1kszuVXvSo5T3nKtmSz/l8HVzAoiU89bQHuEX65Vn093D+X1
	MeeHXKMwJtGxXQRZc0CFthaAm1cUS2FHGakev3KlYsHv1BUz1bJgyPa2vOmpIar9
	Lsvw8v0sFKxcdP82tE5d6BiPwTYt8BEnovuv04evqHiwOQ9mHDzA/Qve0ENZwnZH
	F3H0BfIHZptOivH3pVhHtnXfR/WRg==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010066.outbound.protection.outlook.com [40.93.198.66])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hqu7eh235-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:51 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fE4kNPk6jRwmD3k4Ni+7TQSmBDAqaO4ugZ9sRYUP3toeCFCx2mijPOM13udZqdoXi5MonAhoMS3VJIDMPSrNkK61ev61dzjLtdFr6Q3q48b7hNnUEb3p1Ji+bltqmpXeyq8MeyP3kkwEzof/VTIpRw3TIpTzPx6aUpBzh3hGgFSq1fVYCbPJ00Avhq5VpIlNVcSugBHQMFZiNedfj7vtG4DM/oIK4W4MYBbAwRvwZt7Ncl8U2r3OZuJ8nRVdt6gMdUxkOQkQ8JJ5vYr/uYbpfSpkocmT5K/jMabMgjcJmuocnZnzp383CLfr/JO3ZxQflGA0bihViKKpgJt6aMs97A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bTgA/Zx5hQ3OAawYsrnvG3wvUZdT1++nSOY4m+Jgbso=;
 b=fJluqReMp8LeIbCBXD6DM7U1Vu8JzbROcbA8iugdheMzLQc+lqzmkQfSR/8UvoQruAe8SMrC89CsNWWrUB5L9ewiqigwiCpv5U48uWum7iM26GsoOuKvnxOgJ5rVdJXVNBJDhTUww9ReskTXVkp2k4SGzrkdbMKwsyrqn2b78qJDtziH0AXzwx4qH3yyzBua0af3V/E2GQZsTCA1ksqWAB6MlNjIyrXDxlpQOn55PTvMcHt5F5ODWv4PQflNP1Llyi3vrSmXtpZbGm+6lyf3exXthjNBEB1f4bTe7feaFX/Jme58Wg6DTtPU49CX+pg1EJdtOajcvPpe7bZENfxpLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bTgA/Zx5hQ3OAawYsrnvG3wvUZdT1++nSOY4m+Jgbso=;
 b=qxb/P+t8/12a3Vu/inIMgRyEwOjifYrQGKIBvhmvLook+h75mkc26wI3OVq7DFB8sRJLprkTyYb+k5wnPoKjMleVbUPSKd4zN7ZPaj8hBKq1TtSu4F4six5AUsLY+eltL1IVxcAtGWVEVdqMZC2PTf/dR6HG08weiVzVeCtvbjg=
Received: from BY1P220CA0015.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:5c3::10)
 by IA6PR10MB997561.namprd10.prod.outlook.com (2603:10b6:208:5e2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 05:45:48 +0000
Received: from CO1PEPF00018868.namprd03.prod.outlook.com
 (2603:10b6:a03:5c3:cafe::3) by BY1P220CA0015.outlook.office365.com
 (2603:10b6:a03:5c3::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Wed, 4
 Nov 2026 05:45:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CO1PEPF00018868.mail.protection.outlook.com (10.167.249.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:46 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:08 -0600
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:08 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:08 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxu521920;
	Tue, 3 Nov 2026 23:45:05 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:22 +0530
Subject: [PATCH v2 12/30] crypto: sa2ul - zero out security context on free
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-12-15ab90b3f9c2@ti.com>
References: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
In-Reply-To: <20261104-b4-upstream-sa2ul-cleanup-v2-0-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=690;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=7zg3Kzv6Hape0u6XNy2a0++qiq/oksxmoAr+ITr21gY=;
 b=AxQAO1ZTqyJSBMEMVVEKIB4tfouZ/O02y1xIiYTKv5M5ZiMSl4Xz3tskykwtRDABkFH/jwdxn
 wcsDQyrhmAZApg1S3yKzFmSbWfjjHy1CJRLe+Lbw31vgDlh73ipUlDc
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00018868:EE_|IA6PR10MB997561:EE_
X-MS-Office365-Filtering-Correlation-Id: 09152480-c31c-4d76-be5e-08df3a36dff5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|376014|23010399003|1800799024|10067099003|18002099003|22082099003|261102123227099003|261021121427099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	4qHJ6OEaoi7CrLvy6iJbRkpQ20JiKQthLBGsbDAzmYnmm/R2JMm0/Gge36DjeEZmN8auP4ryofc0wmM9Wio27308i3K7X86o766qEJ8AlAus2+4zcIFhabmkWAmPMJqGSrqtHmkbJpcRQeHsm46ka44fBRPbWUCSbVgImdRZy00p9X6YAf6+GU4vZBMRRFgaX753NUz0zcBP5hDL7TEObbfsJsNuofgKO+NDPonQKQ0Jmg3/E1RNQzApQO9mdZAgA8cLLWB55SyzCNcPLly+j2WqncEgQ8pCa2vbzcKPlo579zC4hKxXM+Ltf6HLM0PpIJNZD/hUD7r6jw5gq9rI/adL2RwqmH+lWjP0I0QYpxIiIHm4acfbpYuWi2ie6S2wl1WprzS3Z4HltpRxecUGaF1qq/YseJoECj0FVqYN3V3upiztnTS6bJlNw9Cii26mkPDUgmm7sANoHdSFJm7yTeIpnWtKhKp9OBtbnqt+DaR5TSkLNuDkCdlIQ8cOq7GbbqSOWBPE8TBI4++CMUwuSDP7jHR+OI95LnE6HhoePaB7AkIuOvwonED+fE/v6FcdZL6cI5Lr88PVFBUrF1ayF1+qmvgs7kpPyWoQJ1HWP7wylGcf8DZrwhUNgfWSU0kr9f+fCe94VtktbBwu9weYxGIQMRyDJzf0FrTW+9QR+w34EXRPCIUAhIkGjHEFZ6QpAJ71oUsceJupRGWk8LKufw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(376014)(23010399003)(1800799024)(10067099003)(18002099003)(22082099003)(261102123227099003)(261021121427099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+m2BiZIlm+f8HmgBpcfMZDMENjaLMUyp3zCJAv0c1Zhr6LuGndDwVkAcOVW5Q0VN04kUzzix05OmRgrmB6Pc+TFU6oCrc69fc6hvr/idkCViSP/vWWKiJHtb73iVlMkwxzhdIfVDuITRYP7b37IzYJD/LdwEBjoHL4xCWBSj5EHe8CiI9LdFXZKl67OcrKckoR8wLaNIsK0r6Xuf4CK4gwYcEWOCaptXQLm1U773x6s0T+l6cRc7YcdZywmUZtokAl39JqAp2QmVuKCQToD6WpP6Znl4HJ2kYXzbS5mlrSe4Bgt/y99YPK8khCA9U/FwfIvHIkPa0Z9viAtdNW3o2Tc9O2z9Rrlo7M+3TBmATqWp/YGPuldlAh8Ph8MMSo0c91YjbP19g1Di6QdNfNl0nj4X3pt5V/KgefdY3fnTaXPOjsyayDthvd0ZeTD+4X1m
X-Exchange-RoutingPolicyChecked:
	iMD28IXoWojcVD5AqrUK+u8O7n7pFDlYXXREPytft7tK1kShcpKHU2OMXrIQy7zuAGT98xggDRKMWBuJIjw+YHZZTdcs+k12MMjuFBpVCiMsiy+YTxtZFXA+oGkTRwKSHj7qnylIq45t/dwJtRjMngJjUddmOcsbsBmTUKUmI4MhJSuRYmtS2B27rvKjhcF5ahRB+dbpmAb3dr/8DmVAJNUdniwjxm3We3NHJtzkS2PdY4tW9Byy7D6cJAcoOQrIyLc74cGaftDDj6yu9HsVnwtIcUHoD87jBLUl1k920fiOUJhr1fj22MyZ34aGoTeOwRvgGDy0puTx2bJgtfYYXA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:46.8550
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09152480-c31c-4d76-be5e-08df3a36dff5
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00018868.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA6PR10MB997561
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX/XNhz+spzOdW
 7gGPiF2k72tHDkp7yBzARavIH4ShlmdVq9/ZTu6x6G/QZTur5xVR/8B/qaPXshHPSGVwkhS4CAK
 7kzb7P93CG7wsjsfLoLcFqThQWU5eyc=
X-Authority-Analysis: v=2.4 cv=fPusTpae c=1 sm=1 tr=0 ts=6aeac68f cx=c_pps
 a=F8U3mngwmb3oM6JELIq/Eg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=fPAWb5peG099m5CrUpKH:22 a=sozttTNsAAAA:8 a=QMk6ud2451SdQzNupOYA:9
 a=QEXdDO2ut3YA:10 a=ZXulRonScM0A:10
X-Proofpoint-GUID: gjgP1n648oEbDM27MNRobnxigVdNjGQ6
X-Proofpoint-ORIG-GUID: gjgP1n648oEbDM27MNRobnxigVdNjGQ6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX0XeNcj8ESpeM
 fXhqYAzXuf/LR/MF5IxrgDC812ztKdIEYdIp5cO0FHZXDaBpgCps2v0SWPLJiWyI1RZIXw6uu9u
 hlYcEN8FqntICJ9KupyNeoaI40HpkHQKDDGXAFog8nQvZjt4eNVeEs1FX3RhRF6em1AEdQqu5Wu
 tMRgGamkzWoWGu9/rsybGD1Djm7R0DcJfhv0oXL+QrZfTeHu/JPyVmtld7Uzuie9GSJzUfv5OVj
 yXh+3vOQaGo9jk1HqLfoFSvigyeX6VoHPwkV9CqgJpF5oeJfYDbXOQbliUw6rAGGvWRuQScVolL
 e4U0bMf1pbOeTmhRvmGrii50tOsES3WP0DZFgdUT2RKGkCSCUuL0uO76tAbscPVDcptOid89TZY
 J8WvBhzmycAS2fca7Tyi4p1NlCa/kIuJotbLOZcUlt2ZYTPnQnHnsjCR4nTaSv7uLB6+APr8Zrf
 ZaC48S1uf3r5UPbuBQQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 suspectscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040022

Zero out the security context memory before freeing to prevent
potential information leakage of cryptographic keys and state.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index c0b1c7c5da7f..23a821de46cd 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -697,6 +697,7 @@ static void sa_free_ctx_info(struct sa_ctx_info *ctx,
 	spin_unlock(&data->scid_lock);
 
 	if (ctx->sc) {
+		memzero_explicit(ctx->sc, SA_CTX_MAX_SZ);
 		dma_pool_free(data->sc_pool, ctx->sc, ctx->sc_phys);
 		ctx->sc = NULL;
 	}

-- 
2.43.0

