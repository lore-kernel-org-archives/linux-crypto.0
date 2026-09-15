Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F0C47FB0E;
	Tue, 15 Sep 2026 09:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466195; cv=fail; b=f5AbfNO5LjrfGvhcECzurBQojWi9c+r36+Dye4l1o7xQHDnISQDZqdazcfiXd6GvpX3eFQZ+HDbkzISWJ1GdbURTpo+2/OdA6ngGwkLIxZ667/q+Rofsz/RmPmRNCbIX2oLCSYl+KZx6MbxHQ6sTmfA6Q7mQ+SF5x5QRacQ6+CY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466195; c=relaxed/simple;
	bh=Jv0yhRQLpdO1SSTC2Nznwlk+WMpus/ZnO9swKgHbfBI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=p6e+a270GijdoXuEolujGRIa4Od8L5Mkg49mFi4RJu3KIXtwRN1URWFT+1XBjTzfVZYpzQEaTd66Mmz8buV28lnkuqnqMfAlRXtAKWOoAzbODUbjhEnARHO0tuZ8CvPidvN1TKoFTDcCyHaFo25XsxDmFVa4MkFFVltpEeyt1yA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=NTTiH65b; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=IDsjhizR; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="NTTiH65b";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="IDsjhizR"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9ejHG1480546;
	Tue, 15 Sep 2026 04:56:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=e+rF0G4pKgUYgAtbp3kUCoJlkLgk2rkNSqITfyWb9
	bc=; b=NTTiH65bcxHZj/nTAhHLWyBPSUjkLwiNBKowfr/NYF47AcfrwCmouNIuo
	upQm7mjdH5Ct+IADwwE04y2JpSNg80r4RbJWEa+SV+FOglblJV4d0I0E4mxEyTFA
	u6BwlO5t4ujp0DThTjbG+xzIjo68Bf92Un1ZP7hMO+zsc2jIWYfQr2MZb7Du50OO
	EojqJ4699v39AyOGFLbc6VOYuS41Tw7SrDyRZk3PMYp0zfuMA8Yripwcxc27SRQv
	STwqhvp8j0oQaOE6am8g3TnOQ1qzv3AjYx4fVtMjm1z+xrb/X1rSA3O8fsTuEgMz
	iyiG6sA4pUztme1uQnri03Q57hOug==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012058.outbound.protection.outlook.com [40.107.209.58])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2j1m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:28 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UARzVI/7bjnJGGjRkc3LYGQxPhs0ZEcW7v31icARj2Ym2o3jEvY3MqBykozKrIL32ktL5+nbmLdur5TdBw209g7O0KfoEfKxIOsyrzmUTISWWofM065MmLArdRbiGpV5lg0cgD0uzl3wtdiX+K2CrSklYeA2S/W8nf2ALdQT2IuEnLBfZNINFgfGQBNWlA+U79GSkJK+kSUMN8iLTXLM17ynjavvCEojca/7B5KaGvmOceH1ij1Gupj1DXTXDCq5KRRgPWWR8XDLy8ZnHeO1HlQoodKyD6UN+PKG472qKQV+2ojLDE7r8hZ0u+vytLaISpLx7/KWPLYwt60PYuZdzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e+rF0G4pKgUYgAtbp3kUCoJlkLgk2rkNSqITfyWb9bc=;
 b=rvPqprDaaH9oefU0fOrkuAA8itv5iSz0gEOVH5dD23QX5gnDJerqJkOrOa+FjYXgw9ANpR7vZEyuTGBMS3qIEIOhIQsyjrZrkQVkE1Q4rUSAw2kNHl1P9eeLktFvlOJTaEm0qbcEW/HbfFWolZsl4AkHxWgTfrvpAQvOVEsiWOPC4jczosoGG0AZTtBPrDmjL9shMS2YwRaGSuCml/iY8FcIl9Kf2cES6d8gZ5lpt54YyjNuCukW2UpCWouLA7Zv1w/RIynePs7tPUDbkpm9YVbj111GZCI8xc9vJZwaf3aQXrSiwBzsaq1FVT8/2vzPSP0YQ2wjWDFRbsqra/WYig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+rF0G4pKgUYgAtbp3kUCoJlkLgk2rkNSqITfyWb9bc=;
 b=IDsjhizRUHGuFp02zwkKK7xDR062uu8+OSg7vZijQMPiibsMCr5XxN2VYh+08LkvqH+8IqwpeHlKIVvunTLYxsaYK8XQjdY+tgo188VxmK47Hc+EKyrHIzKYPlxEUMLmEun+bMALmBjfBUwYdLGP3M5lxg6gIiH8omlhRd2jt+Q=
Received: from CH2PR12CA0014.namprd12.prod.outlook.com (2603:10b6:610:57::24)
 by IA0PR10MB6841.namprd10.prod.outlook.com (2603:10b6:208:437::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:23 +0000
Received: from CH2PEPF0000013D.namprd02.prod.outlook.com
 (2603:10b6:610:57:cafe::46) by CH2PR12CA0014.outlook.office365.com
 (2603:10b6:610:57::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CH2PEPF0000013D.mail.protection.outlook.com (10.167.244.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:21 +0000
Received: from DFLE206.ent.ti.com (10.64.6.64) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:48 -0500
Received: from DFLE205.ent.ti.com (10.64.6.63) by DFLE206.ent.ti.com
 (10.64.6.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:48 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:48 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB803000901;
	Tue, 15 Sep 2026 04:55:45 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:16 +0530
Subject: [PATCH 10/30] crypto: sa2ul - remove unused includes and defines
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-10-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=4651;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=Jv0yhRQLpdO1SSTC2Nznwlk+WMpus/ZnO9swKgHbfBI=;
 b=JU298eChqPqOx/sqTcUrb4RBySpXJUSTeFqT9EK0sRySNYFlbgfZsnVBeEnU4Yxp9YkxVo6HF
 sBp0rElo2xIDBoOrw013gSd2qi4GNegHkum5RqdeV9BkTr5UV1nfm2w
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013D:EE_|IA0PR10MB6841:EE_
X-MS-Office365-Filtering-Correlation-Id: f10e1148-f873-4c6a-e908-08df130f9883
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|376014|82310400026|1800799024|56012099006|10067099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	8LtYb2yrfmQiVhLPX4dx2d+a17YFLenGU62CKmPjU9SwLAWv32lIGY+nZM2lwDTz9oGawgHr196RZrvDducNTJ3why0vLw59KGKrxILYnNY9DjUNXwjaL9D3LxGH3PizTxHJquuhETecreVaRcxDD6xcG3JjtJN3j5DyoqwVCM0u838Fucawuu1hI01UugO4EbyYlJFJ9GfBbrgQAsYPZP8WzEdS+RkeuBK2JE29G1P0p+Uv2AYhGWCfc0H8YXOcKdd3iPslvYlMQvJmsHOWp71vdFgkGgC4fvNfW+pDZJhYdm2nCBd4IYlz4Fj48YkKnc8H2EKxS36kijmuK13q/6WvZ+s9JsZ+ZPGxDC29KKkx3wSyijA1h+/HUejZrLriebvyvNC4ouDllDfYnkk4W/q+9d6p9cbcHQoQNzav7x3EX7R3af3246ey1Fv0Y7lwWjrToK+DZmMAEiaqzs66ozX9GpCo/hzaPQviJdr0L0/9cbE2rUW0wCsW9zVhJnPUVbk+W7SEHGUtcS0p0Uhcom77JJx0KucwOJAppMxN+g49JfR59UB5ElnWBSXN0yF6MdL9zb6o+kIP6Nq+/cLWbUESiQDynDn+H/VNYYy6satbjD9rDGtTbKpYzesCqG/Sug0R9HJoXEQu7LNok0J8TE2fVu4O2oHuFDZSqY/PjB3cd1pLqVP9K4SVa7e9e4FOS3OjnTX3Ng1W81I13IQbmg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(376014)(82310400026)(1800799024)(56012099006)(10067099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dDw7dNGlx4+ggNn9so+nqWu0rAKiNXGKHcb1A770HR7I8kkgRZTMm70naPYXWoiJSwGA8XZC+7XIsy3opr5A0A6+Jd8urJAxqx1x126tDZtcY4ns5+uNEVtNsqPMyCEb/r2bd+EGNxZg5Fnf/wFoC5lhI7N6IHhdFWWCdYPVJUiyL7/rB/XfFkLvdwZbTN8oCBCeib/uh03XYTzLuTQUirEldAlGrLnZ3omWiNEyrks+Hhz7gGQyTWNUBn0B8J+Wp+q5A5l5pNrmB7Xz0Aghbrvx8ocBKG9l0otexK1t062bs6APIWW2pKUZK8Wq4Fm6oPUvWv62Pfe5TxiqmyxBtjijyVFzw3s54vdxbKWvimedK5lTvdUX3X3cvc0soQxH75zEcT4zIJwzf9NHWiX2QXWHbRXvD4dqFHX4DY13UbitIV1n4y3MiljiBgGoELo+
X-Exchange-RoutingPolicyChecked:
	vM55ektsThUjak1K6o7nEAcgp5Zh1+ja0hdtYS4XUcQWbeelssGl6rPzAgra+J9Q6g4cfnxda73+vVHQCb2Iv5z//u76eFykwXKNd6D0NYkOfCbX/EzQX9wtVDgL/juFe6ZTOGsItKyBrG8ktKwM0Vq7XTHT8fmh9tjXc9hQdxxWBJmi/PfH0JyfSHymE53RdPNZx2AG3E8Hii24ittQKYn1HCW4jC0M12E13fTY46+1ZJQ+fU6KPTkePiAeHCXUXwZghuNnnUovwIg1cfG772bkozdhO4ybXo3hlUtzRhXPwb6T0wMs1RFgo6hvYdNnLjk8g3pvUlrit02sw82GLw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:21.3121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f10e1148-f873-4c6a-e908-08df130f9883
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6841
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX42qVtTNNWIjN
 c1BFwsEBBkcGQvUo7Y43M1JgjIKbYznQVyEZFGO6MjVZRY4R/drECde9tIpSRbPBFjAjYAVDqi+
 2qFa64MgcVKl3ndPu37OClRLV4G/lp6WaVq+Bfsm094/e2Bip/J4QkvtOLiEIAHzQYNo+dsNcs9
 zIhsw83wF81bnQXw5PvIxENdTbd5LGISRJtmfu2dFIKctHQBko4y0JRqe/C2HPCjeXOm5WM1ecK
 0w9wNrZn08jyC2e0LLuQxQap+mO97rFstEJsdwRqi3bHpV+zDBe3gvCuRsHYlNJsnarwWHvv6Rv
 8wi95zVhpcZGpS/bpQGCad4/MXRaZKxF4cKzUmax4IQ4vOkRCFT795ojGTOKtq9zqCouN2Yarsj
 0pDeiW8+uF+GLXfBLsJe4FD3xJsX4XQ9WplYaYO0S+rpSXHslZHv6YcO8YOaT+nDs0a9tw7arVa
 ocHrH3jR8o131PJsnGA==
X-Proofpoint-ORIG-GUID: y3gE6iXd_yUbtLkMFNcmbSczPILHstub
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa9164c cx=c_pps
 a=dnat/ZFdcaejr8kp+uhwWQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=4-SKDGY5lZiqGY3zoJ4A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: y3gE6iXd_yUbtLkMFNcmbSczPILHstub
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX5MWxeaxOHyBf
 P8I3qvo6ZjNnrwUHRh7fVhcJ0fmtzkOr236XWPEhPWFUhMKupkJAwQ1KUNOfb4k15PT/3rxSN06
 MA5YWy2/j9jCo+8JUM4REVCeot53xFs=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Remove unused includes and define statements that are not
referenced anywhere in the driver.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 13 -------------
 drivers/crypto/sa2ul.h | 12 ------------
 2 files changed, 25 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 13e941f58c4b..f98d199729d0 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -9,7 +9,6 @@
  *		Tero Kristo
  */
 #include <linux/bitfield.h>
-#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/dmapool.h>
@@ -70,14 +69,6 @@
 #define SA_SW2_EGRESS_LENGTH		0xFF000000
 #define SA_BASIC_HASH		0x10
 
-#define SHA256_DIGEST_WORDS    8
-/* Make 32-bit word from 4 bytes */
-#define SA_MK_U32(b0, b1, b2, b3) (((b0) << 24) | ((b1) << 16) | \
-				   ((b2) << 8) | (b3))
-
-/* size of SCCTL structure in bytes */
-#define SA_SCCTL_SZ 16
-
 /* Max Authentication tag size */
 #define SA_MAX_AUTH_TAG_SZ 64
 
@@ -199,14 +190,12 @@ struct sa_rx_data {
 
 /**
  * struct sa_req: SA request definition
- * @dev: device for the request
  * @size: total data to the xmitted via DMA
  * @enc_offset: offset of cipher data
  * @enc_size: data to be passed to cipher engine
  * @enc_iv: cipher IV
  * @auth_offset: offset of the authentication data
  * @auth_size: size of the authentication data
- * @auth_iv: authentication IV
  * @type: algorithm type for the request
  * @cmdl: command label pointer
  * @base: pointer to the base request
@@ -218,14 +207,12 @@ struct sa_rx_data {
  * @mdata_size: metadata size passed to DMA
  */
 struct sa_req {
-	struct device *dev;
 	u16 size;
 	u8 enc_offset;
 	u16 enc_size;
 	u8 *enc_iv;
 	u8 auth_offset;
 	u16 auth_size;
-	u8 *auth_iv;
 	u32 type;
 	u32 *cmdl;
 	struct crypto_async_request *base;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 48ed1933ecae..7c0ca2ca966e 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -169,7 +169,6 @@ struct sa_match_data;
  * @scid_lock: secure context ID lock
  * @sc_id: Security Context ID
  * @ctx_bm: Bitmap to keep track of Security context ID's
- * @ctx: SA tfm context pointer
  * @dma_rx1: Pointer to DMA rx channel for sizes < 256 Bytes
  * @dma_rx2: Pointer to DMA rx channel for sizes > 256 Bytes
  * @dma_tx: Pointer to DMA TX channel
@@ -184,7 +183,6 @@ struct sa_crypto_data {
 	u16		sc_id;
 	unsigned long	ctx_bm[DIV_ROUND_UP(SA_MAX_NUM_CTX,
 				BITS_PER_LONG)];
-	struct sa_tfm_ctx	*ctx;
 	struct dma_chan		*dma_rx1;
 	struct dma_chan		*dma_rx2;
 	struct dma_chan		*dma_tx;
@@ -193,12 +191,10 @@ struct sa_crypto_data {
 /**
  * struct sa_cmdl_param_info: Command label parameters info
  * @index: Index of the parameter in the command label format
- * @offset: the offset of the parameter
  * @size: Size of the parameter
  */
 struct sa_cmdl_param_info {
 	u16	index;
-	u16	offset;
 	u16	size;
 };
 
@@ -208,7 +204,6 @@ struct sa_cmdl_param_info {
 /**
  * struct sa_cmdl_upd_info: Command label updation info
  * @flags: flags in command label
- * @submode: Encryption submodes
  * @enc_size: Size of first pass encryption size
  * @enc_offset: Encryption payload offset in the packet
  * @enc_iv: Encryption initialization vector for pass2
@@ -217,7 +212,6 @@ struct sa_cmdl_param_info {
  */
 struct sa_cmdl_upd_info {
 	u16	flags;
-	u16	submode;
 	struct sa_cmdl_param_info	enc_size;
 	struct sa_cmdl_param_info	enc_offset;
 	struct sa_cmdl_param_info	enc_iv;
@@ -262,7 +256,6 @@ struct sa_ctx_info {
  * @dev_data: struct sa_crypto_data pointer
  * @enc: struct sa_ctx_info for encryption
  * @dec: struct sa_ctx_info for decryption
- * @keylen: encrption/decryption keylength
  * @iv_idx: Initialization vector index
  * @key: encryption key
  * @fallback: SW fallback algorithm
@@ -271,7 +264,6 @@ struct sa_tfm_ctx {
 	struct sa_crypto_data *dev_data;
 	struct sa_ctx_info enc;
 	struct sa_ctx_info dec;
-	int keylen;
 	int iv_idx;
 	struct crypto_shash	*shash;
 	/* for fallback */
@@ -284,13 +276,9 @@ struct sa_tfm_ctx {
 
 /**
  * struct sa_sha_req_ctx: Structure used for sha request
- * @dev_data: struct sa_crypto_data pointer
- * @cmdl: Complete command label with psdata and epib included
  * @fallback_req: SW fallback request container
  */
 struct sa_sha_req_ctx {
-	struct sa_crypto_data	*dev_data;
-	u32			cmdl[SA_MAX_CMDL_WORDS + SA_PSDATA_CTX_WORDS];
 	struct ahash_request	fallback_req;
 };
 

-- 
2.43.0

