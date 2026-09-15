Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B24647F2CC;
	Tue, 15 Sep 2026 09:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466183; cv=fail; b=qmEF3BgsmN4Vb5zhj6pUWMR0+1XsjD8oCcv93TkIyFDDUmDeJn3XrNDRlSmj1mqY5DyW91xO+QU1kYxG5qXAHwHJWcsHE4ym4PHMWn3WcsbSbDGYDf62MU/znGbTfOl9Ufab1lEH5+SbSscI/VX0D5DJeh2gheC2s0uWUoSZkVg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466183; c=relaxed/simple;
	bh=jmsa6jNIoeZ+DbILI0C5EiO1X3L0rub0JqcahmYXZLw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=T0cKhslpsxWVqxu17kMLSTGhcWheiP8UeQ2jpZNiCEW/Jt4gii7Yq8pjsf9vixuBL5Df+i29nVJTF5GgUB/ixILhPAA8tuFXc1CKh2kCEd7tN8QZOxvez8Qs5PaVuK3gX2ENkQA4pyuJzu3nZwlT/kctq3Pc8HcSt3FHdHg5B78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=XKQIAQZs; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=BA73tGoQ; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="XKQIAQZs";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="BA73tGoQ"
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 68F9eiAC1480537;
	Tue, 15 Sep 2026 04:56:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=2cM2MT78SvV0O2h2a5u3sFk8QsOGIP2+m8UFGDpsV
	sc=; b=XKQIAQZshF7vTMPsk0xl4tRbj+R4F/K8erPCFJWtl5uetmv22CRq2k2ny
	x/1ymNU+WkiaXRbippT3/5c4cyEeA2pViQ+706hILkZBQsrKs8B6Ga2WLjss8ur/
	uNbQBaQZzF/9DbACPcFgTQinszbDgjtFZdZQSBCb7Yy6XzZBAYk4bX4oSvA2WBnU
	PE/ax0R2+uBuSDl/jM7r/U5Ambs5/QU4Ip96ae8WV/V6OWXLdMdNPwvtyGyQFOYo
	moECQI4q6APEJnDkXWQ0CSedsw02zAbChvI2ALABhw8d+FtjWe7ktDXS9Za3Ep/e
	eOvccjqw0mCBxVHirqZTaDd3qitdQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011060.outbound.protection.outlook.com [40.93.194.60])
	by m0384305.ppops.net (PPS) with ESMTPS id 4gpvpa2j0g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:18 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiZeJ+AMaGVPrKK1UTkRnfHX9cgEdzTr8hqD51lMCmc1xdcIPNGjCbof7utDvT29XHsBz368P87QWxVZbiTsXLP9aToAKVzKYBnHM4AHeNX+2C6hk1RaaeChf08puULh476pG8sW8WGrYZZaWtBVqWXjnRvJSo7QcTEn+VvFkp2WUdhYPmyKUvaGXWkjmwRYvZSiobxRxikwCt51o0xqH9KxDAZb+ypi+d/uJT7MDTSy2NV+ZEHNSeBK6JedboY5YBX9LvKMIVC+/pahSVO+tweXnTJfClRe8IF0B/2UzV5UPae2uxAbFZ/5t65ik6WkTp4vm9CMsB6CZTysc7hCow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cM2MT78SvV0O2h2a5u3sFk8QsOGIP2+m8UFGDpsVsc=;
 b=mDp3g6ggSFMUxzh6hmOcLvpoUd2GDqTrJQMLUSaiv6zGFumlWRy8dnXuYt7UH+pGqx4rYif/C9BGmoiwpCPmZytyMvEcs/G6CPZ4zYzU1rKLyG3HSLSb+TGvWzwovtf4E6xW3TkXBw28h96aGr2XaNPN1YAF9pWcBrLtDiEk6u8bAF4vi6Wk739wSKJeUYOXQFm2e0olLscijGa8YdEGOitkPINU8k5Y4qqV/xJyVqbrxeM3XKWFdTAceDQKTvJ/AfJD0lzlVhhNTvdciUsYz04AtnDmzadXuOUbimmMHz6tjBvmkfELXU+uJxuon9eETFzytGwrUHRj9WgGL1WC9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2cM2MT78SvV0O2h2a5u3sFk8QsOGIP2+m8UFGDpsVsc=;
 b=BA73tGoQ0ldjgg6d/q5CcGqdQosTRFioa7DwfAWh1h4E3632IKt+fnKcbDcwOOxN6xx8rjmsm1kF4+Ak9L7wXJ6Cdpze0XzEcM8t50iAaUcr/cecgtFAPZSmRpdzP/A8HTnyLVHGE1mqfervP1nliKEqdoqcrcVtoVU+pzLdh44=
Received: from CH2PR10CA0013.namprd10.prod.outlook.com (2603:10b6:610:4c::23)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Tue, 15 Sep
 2026 09:56:14 +0000
Received: from CH2PEPF0000013C.namprd02.prod.outlook.com
 (2603:10b6:610:4c:cafe::4d) by CH2PR10CA0013.outlook.office365.com
 (2603:10b6:610:4c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.11 via Frontend Transport; Tue,
 15 Sep 2026 09:56:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.194)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 CH2PEPF0000013C.mail.protection.outlook.com (10.167.244.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:12 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:38 -0500
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:55:38 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:55:38 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB7v3000901;
	Tue, 15 Sep 2026 04:55:35 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:13 +0530
Subject: [PATCH 07/30] crypto: sa2ul - consolidate encryption offset
 definitions
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-7-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=7390;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=jmsa6jNIoeZ+DbILI0C5EiO1X3L0rub0JqcahmYXZLw=;
 b=lZHrqx3youcaPifpg/wC2ZXy5/rDOp7hm67bOuz9Im//t3H/5n0JD1XJ5jsx9OPxSSm7y5aEe
 xzwb/SmXkG/DUEgiZCTq9kq75ly5VRjlxx2dLBo4XWNkjrcLE1JTEUK
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013C:EE_|PH0PR10MB4568:EE_
X-MS-Office365-Filtering-Correlation-Id: 85c6272a-34c1-4f57-f6f8-08df130f9379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|3023799007|56012099006|22082099003|18092099006|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	v5dwrRqy8GqFWgxNM1aG/ec/UFItPSim9lw2YQLPVaMGCr7CpXH1mfGnMkVlKlkQg6X6f3EBZROqBFBZMq+otb+O5axFFEwEBRBlmE5V8d1PYcUYGiKmWfYfCbPIaJg9JUnYcTmNdnP58hSFcZ9vwIO1DQyuTxh7abWDJ6pGOyOBDINQukwRwj+rqUTDYOo0OhgBOrGAYgeyUwRL0Sp1nd8tKM+r9Q/Urf2Ss6WxWyo1joZUkvE1KQAi6VNLJ85gzt9fPsI8XNxHGaThjkif6F6byD0uLIm6VNLZLtTuZz9hs3/CukUsYa6+GTNyoRXBXRyYzkANTf+hBqc9UUnz9Rmpx3JY6eTuM+5d1T3AZAvJ+zdPFv8kKm6QucszqnsibVumuPLmY4hBmWNk7H6dClIaebFwc0Nky/ojyEJCmOS9expZc5mNsf+ZFd8QsXkgzzCWSqg+4Rb++YFdP1gpDpQtwIkMJzNpScfTsJMoPPwpRstR+BtqGt9NssH3aECu6GRXSRu7sddCgve+Gv7EVv02YzxzY/GJZT4UyTnTZtxu5zNLJLd7zlmO6uEW4z5ZJ8iVIF5IT0Rk4qJDHKGMwwS6sT6Pv7Dn80/avX/p29dEaunw6bj0avZoU3myPZTL8E3rMcDdL4x2WCr6U6EHhcy2KDyTbXE6CrUrzBpfGj2YTbbjkRTGM7muuGKqVZzIo2pjIxelVo6HU8pAnXGUcw==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(3023799007)(56012099006)(22082099003)(18092099006)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UhwROGgZVWHIIcFE31XVdI58oKFkRpRLr5ah4yiRulxK8MT1PgJVQ8+w6KqKrhD/gvd2gxEZ9c8oXUhfo/Aez0hbDPSk/N69Xxj2BYomfTIQ+K2Ck40kFtZHUC1NNJh1Uw5/M35xxiNy/zeKhUezOL4TPczsLgEQyI3o7Tngrugjm1SAVcOSGxO3wsAvrItpr6KJV7e/oNi3Vwi/YNw46gIXUDXeHPhHCZ9OBpnf1P0b95xmarUopjua8jbu+4/5rNmqI69kgsZvMyFjTLr+4SGhGuMMhcyTfnp3ILfc8HXnSYNXWR+9JRsU+a3yPpYr67Y8dQsHtSD5eYOjtcEQoAeU2LZUFDN3qRkxcKtjamYfh42PKgIeRcqu08Sd0V3TNlroht6m0H+2wWZhfsz6vJ0xcDn3zYo+Jn991eDytNpiK76+d0UfxHb3nUX6nPAU
X-Exchange-RoutingPolicyChecked:
	Sk8NPuHNxA73SBiNpbj9q5Wu7yWH47ZdlC6/TL0T8tVhFdDR4cK1KO3Ahot0IQQFYYucyUVy7XdwdtFeJpHQzW3FSIw8mpMEOPwrcvySQECh6Caz3cJXKoPXJ1ZwC4tm890ppVm29j/m+8IWV7TpwsI8+If1lqe0GqEdyx0UGoV+wYdG11xl5EilPT1lhsyCtABigLFEWzVn05ILkllfQHXfKRa3OkVbh7RmcHLJZUvT/AtFBYQn374KKPjoyZx2ntNTEi24WzspKo60a1R4PGPMKEZSmP9db3VEmdAuVjV/xcugolAPI+++3mRpyawzmlEUTim6VpdKoYrGja7QMw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:12.8618
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 85c6272a-34c1-4f57-f6f8-08df130f9379
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX+RqAtS5uzpWw
 o6AcgbrqPvK6azg28c2DBTSXLsb6zBrC2cdSvyMJ2HWBG3CpkjC2Pg9zsKNGJXy4ZupMhKoQz0o
 toxzYE1wg4suaazyEcuW9ojtMDa95Y6nLNQ7aINSG1i2VqkvPLZJKJcemA4Uf61FjUSmK2XSvHg
 YV+xDvEhwjHt9MW4Fqoqscf+3tr3+k1QlbS53ZEAF1Q0K27aAZ3ZoABjhI+IzhWCdRe2Et5vPTc
 xLrqksY728EusIQPa5Lbb3oVGZVpzbx6Z9L8apobNAqMM2VyAJJ6xf0JesIj1TDP2/CG9bZ60Nb
 yoZ37zYntTr/bt2fN0mp9NR7vD9nUBq4VVF9MZZfO6plpdjXFhIbFMLURfOb+T8dDr+OICYHUeE
 NT9OOB3fkYGMhfZ9V9HzKGHTOQLVnk5rfRiEwhxFRFzcAwe+oeCALK10CDwUzFvhjraKfLk9dET
 vcgFalultS/Jv/el1pA==
X-Proofpoint-ORIG-GUID: wVpNPa1X2yoM78i12zFwQVbXMMkzbICm
X-Authority-Analysis: v=2.4 cv=U7cHnuru c=1 sm=1 tr=0 ts=6aa91642 cx=c_pps
 a=kwi3Ow37oS+QRMqxGNLpqg==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=3sdfgBQbHt-tfeuNKwgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: wVpNPa1X2yoM78i12zFwQVbXMMkzbICm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX2ozi4+RIv5zg
 Fn7o9bDK5N5M1HseElM5d7aYBOotFyXWEttnNS9DxJv0CmkFNJaLAL5G/N/jJ+mK/+jG5JU1KFd
 T57U9L/J7Jkdt+yf0Xd0DCF5WQpz7qA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 clxscore=1015 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150143

Move all SA2UL encryption offset macro definitions to a single
location for better maintainability. No functional change.

Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 44 ++++++++++++++++++++++++++++----------------
 drivers/crypto/sa2ul.h | 13 -------------
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 09cefd766c95..cde08686f27a 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -33,10 +33,23 @@
 
 #include "sa2ul.h"
 
-/* Byte offset for key in encryption security context */
-#define SC_ENC_KEY_OFFSET (1 + 27 + 4)
-/* Byte offset for Aux-1 in encryption security context */
-#define SC_ENC_AUX1_OFFSET (1 + 27 + 4 + 32)
+#define SC_ENC_MODESEL_OFFSET (0)
+#define SC_ENC_MODESEL_SIZE (1)
+
+#define SC_ENC_MCI_OFFSET (SC_ENC_MODESEL_SIZE)
+#define SC_ENC_MCI_SIZE (27)
+
+#define SC_ENC_KEY_OFFSET (SC_ENC_MCI_OFFSET + SC_ENC_MCI_SIZE + 4)
+#define SC_ENC_KEY_SIZE 32
+
+#define SC_ENC_AUX1_OFFSET (SC_ENC_KEY_OFFSET + SC_ENC_KEY_SIZE)
+#define SC_ENC_AUX1_SIZE 32
+
+#define SC_ENC_AUX2_OFFSET (SC_ENC_AUX1_OFFSET + SC_ENC_AUX1_SIZE)
+#define SC_ENC_AUX2_SIZE 16
+
+#define SC_ENC_AUX3_OFFSET (SC_ENC_AUX2_OFFSET + SC_ENC_AUX2_SIZE)
+#define SC_ENC_AUX3_SIZE 16
 
 #define SA_CMDL_UPD_ENC         0x0001
 #define SA_CMDL_UPD_AUTH        0x0002
@@ -45,7 +58,6 @@
 #define SA_CMDL_PAYLOAD_LENGTH_MASK	0xFFFF
 #define SA_CMDL_SOP_BYPASS_LEN_MASK	0xFF000000
 
-#define MODE_CONTROL_BYTES	27
 #define SA_HASH_PROCESSING	0
 #define SA_CRYPTO_PROCESSING	0
 #define SA_UPLOAD_HASH_TO_TLR	BIT(6)
@@ -229,7 +241,7 @@ struct sa_req {
  * Mode Control Instructions for various Key lengths 128, 192, 256
  * For CBC (Cipher Block Chaining) mode for encryption
  */
-static u8 mci_cbc_enc_array[3][MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_enc_array[3][SC_ENC_MCI_SIZE] = {
 	{	0x61, 0x00, 0x00, 0x18, 0x88, 0x0a, 0xaa, 0x4b, 0x7e, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
@@ -245,7 +257,7 @@ static u8 mci_cbc_enc_array[3][MODE_CONTROL_BYTES] = {
  * Mode Control Instructions for various Key lengths 128, 192, 256
  * For CBC (Cipher Block Chaining) mode for decryption
  */
-static u8 mci_cbc_dec_array[3][MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_dec_array[3][SC_ENC_MCI_SIZE] = {
 	{	0x71, 0x00, 0x00, 0x80, 0x8a, 0xca, 0x98, 0xf4, 0x40, 0xc0,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
@@ -261,7 +273,7 @@ static u8 mci_cbc_dec_array[3][MODE_CONTROL_BYTES] = {
  * Mode Control Instructions for various Key lengths 128, 192, 256
  * For CBC (Cipher Block Chaining) mode for encryption
  */
-static u8 mci_cbc_enc_no_iv_array[3][MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_enc_no_iv_array[3][SC_ENC_MCI_SIZE] = {
 	{	0x21, 0x00, 0x00, 0x18, 0x88, 0x0a, 0xaa, 0x4b, 0x7e, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
@@ -277,7 +289,7 @@ static u8 mci_cbc_enc_no_iv_array[3][MODE_CONTROL_BYTES] = {
  * Mode Control Instructions for various Key lengths 128, 192, 256
  * For CBC (Cipher Block Chaining) mode for decryption
  */
-static u8 mci_cbc_dec_no_iv_array[3][MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_dec_no_iv_array[3][SC_ENC_MCI_SIZE] = {
 	{	0x31, 0x00, 0x00, 0x80, 0x8a, 0xca, 0x98, 0xf4, 0x40, 0xc0,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	},
@@ -326,25 +338,25 @@ static u8 mci_ecb_dec_array[3][27] = {
  * For CBC (Cipher Block Chaining) mode and ECB mode
  * encryption and for decryption respectively
  */
-static u8 mci_cbc_3des_enc_array[MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_3des_enc_array[SC_ENC_MCI_SIZE] = {
 	0x60, 0x00, 0x00, 0x18, 0x88, 0x52, 0xaa, 0x4b, 0x7e, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00,
 };
 
-static u8 mci_cbc_3des_dec_array[MODE_CONTROL_BYTES] = {
+static u8 mci_cbc_3des_dec_array[SC_ENC_MCI_SIZE] = {
 	0x70, 0x00, 0x00, 0x85, 0x0a, 0xca, 0x98, 0xf4, 0x40, 0xc0, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00,
 };
 
-static u8 mci_ecb_3des_enc_array[MODE_CONTROL_BYTES] = {
+static u8 mci_ecb_3des_enc_array[SC_ENC_MCI_SIZE] = {
 	0x20, 0x00, 0x00, 0x85, 0x0a, 0x04, 0xb7, 0x90, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00,
 };
 
-static u8 mci_ecb_3des_dec_array[MODE_CONTROL_BYTES] = {
+static u8 mci_ecb_3des_dec_array[SC_ENC_MCI_SIZE] = {
 	0x30, 0x00, 0x00, 0x85, 0x0a, 0x04, 0xb7, 0x90, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 	0x00, 0x00, 0x00,
@@ -494,7 +506,7 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 	const u8 *mci = NULL;
 
 	/* Set Encryption mode selector to crypto processing */
-	sc_buf[0] = SA_CRYPTO_PROCESSING;
+	sc_buf[SC_ENC_MODESEL_OFFSET] = SA_CRYPTO_PROCESSING;
 
 	if (enc)
 		mci = ad->mci_enc;
@@ -502,7 +514,7 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 		mci = ad->mci_dec;
 	/* Set the mode control instructions in security context */
 	if (mci)
-		memcpy(&sc_buf[1], mci, MODE_CONTROL_BYTES);
+		memcpy(&sc_buf[SC_ENC_MCI_OFFSET], mci, SC_ENC_MCI_SIZE);
 
 	/* For AES-CBC decryption get the inverse key */
 	if (ad->inv_key && !enc) {
@@ -585,7 +597,7 @@ static int sa_format_cmdl_gen(struct sa_cmdl_cfg *cfg, u8 *cmdl,
 				SA_CMDL_HEADER_SIZE_BYTES + cfg->iv_size;
 
 			cmdl[enc_offset + SA_CMDL_OFFSET_OPTION_CTRL1] =
-				(SA_CTX_ENC_AUX2_OFFSET | (cfg->iv_size >> 3));
+				(SC_ENC_AUX2_OFFSET | (cfg->iv_size >> 3));
 			total += SA_CMDL_HEADER_SIZE_BYTES + cfg->iv_size;
 		} else {
 			cmdl[enc_offset + SA_CMDL_OFFSET_LABEL_LEN] =
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 0aa6a36c0f20..94101300736c 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -46,7 +46,6 @@ struct sa_tfm_ctx;
 
 /* Number of 32 bit words in PS data  */
 #define SA_DMA_NUM_PS_WORDS     16
-#define MCI_SZ			27
 
 /*
  * Maximum number of simultaeneous security contexts
@@ -60,12 +59,6 @@ struct sa_tfm_ctx;
 #define SA_CTX_SIZE_TO_DMA_SIZE(ctx_sz) \
 		((ctx_sz) ? ((ctx_sz) / 32 - 1) : 0)
 
-#define SA_CTX_ENC_KEY_OFFSET   32
-#define SA_CTX_ENC_AUX1_OFFSET  64
-#define SA_CTX_ENC_AUX2_OFFSET  96
-#define SA_CTX_ENC_AUX3_OFFSET  112
-#define SA_CTX_ENC_AUX4_OFFSET  128
-
 /* Next Engine Select code in CP_ACE */
 #define SA_ENG_ID_EM1   2       /* Enc/Dec engine with AES/DEC core */
 #define SA_ENG_ID_EM2   3       /* Encryption/Decryption enginefor pass 2 */
@@ -142,12 +135,6 @@ struct sa_tfm_ctx;
  */
 #define SA_CTX_SCCTL_OWNER_OFFSET 0
 
-#define SA_CTX_ENC_KEY_OFFSET   32
-#define SA_CTX_ENC_AUX1_OFFSET  64
-#define SA_CTX_ENC_AUX2_OFFSET  96
-#define SA_CTX_ENC_AUX3_OFFSET  112
-#define SA_CTX_ENC_AUX4_OFFSET  128
-
 #define SA_SCCTL_FE_AUTH_ENC	0x65
 #define SA_SCCTL_FE_ENC		0x8D
 

-- 
2.43.0

