Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311A948EC89;
	Tue, 15 Sep 2026 09:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.154.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466206; cv=fail; b=IYcJ9RcMx1LpVPZ2t5Q9+Fbzf34LhIBIXybwfwACzVWRv5SD2f6ZNyiFTK8Ba18YnYoWXtXQtYJPqewxXtsZrkJjHP0okmT8lEs7Z39IexVZ4Z1b+MxsfYJNY3e1aCeG+MHfRuDE+E7yGddGCHKdtlqqhJ/mWgcr/gpFeJjeRAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466206; c=relaxed/simple;
	bh=jJD122KvC2Ro1YSER8fKZ3D+NYvoM2oI/GA4yLGo0xA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:References:
	 In-Reply-To:To:CC; b=c42j7Mju9lVm7/uZp+OSPs7a5cT549yF+QPzWL5G+ZigIid3uxzkQ8CZe4nxnSNy92WCxdor12PxhHSLfWRQbyb8lQFfMWaHzjRuhfV+8Z8QyVZNBKa2mj6B7bFMiJsKM02RLqi0qb92JZG6Vs1L210Psm6P+r7XOOislypQKcc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=KueECvZ4; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=bJhJN6fJ; arc=fail smtp.client-ip=148.163.154.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="KueECvZ4";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="bJhJN6fJ"
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F9fBOJ3810849;
	Tue, 15 Sep 2026 04:56:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=CYe86O8SGcINloqMZIlqf1FLwKzbr6kv19C/xpokv
	e4=; b=KueECvZ45Fpzez0yLr1YYKai/RkJDzm04Pd8ijuRx26rLGQ3rfxTyu7XN
	DqMIShaaSCzgGvRVg11Na1W6xXmfKOolGzvtntGOj3qoLPtRlB0h83ozJP5wvlYj
	DFcp+V18m5rlGKueEzZFq2HioDAMFIZ1/TDcQVAztm7BAkIYs7APmc0IBXSfux30
	4aDmwFo66/acQMdGuI+g/v6HVufXbgHgYn24fBbMnRuaM4uOQfQWEamP+w4+mK3a
	mZrh+X9lHY8t13xlxfLw+OAK4TGbHNQVVW6iALh+XkW+EkQ7N6kEhc3tsR/sLi8D
	Ft0jVs/Kymdp83uRntHjCs71JkJFg==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012059.outbound.protection.outlook.com [40.107.209.59])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4gq362r9xv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 04:56:37 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YwiGgisQdMLm5ftyNbKMhXdx1ikQP7J2kxqUbTT+eNRNO+6wrdnxlFPUPEy0EVrcpbMc5PjZNkIARhq2EzWi801cbdCRrxQ3BP7rHzxwmKKMp8mz4oGhADTQPjq0qRpzs4D5nQyYVZQLU/KKLTdMtR9kT7MHAcG5kf9X/6Nzg+M/lgK+x7QiknykscV5yRhFGl6E67wrrgTnnEMdUZoWiMkwxShsvOWD9B6eoT+QlCYYV2g8QZQjHcoGME2cDyQw+7XARDtzZioc77vzYRtmVpUzs8FUYs6npfJdGMprdTfrGihRWrLCqupk/3h2CXYW/ig51lwoVuLAmLUWiCsr+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYe86O8SGcINloqMZIlqf1FLwKzbr6kv19C/xpokve4=;
 b=s4rqq+6keA8YoqfBfbISTJJ5nreO6xBmrDxrfRblQWBUVFQj+gdfQQIGKAdrhqYWWR1/lX80HhNadGGk7RjVSCQLv/CCM1xkOeMv7qVsXfIAeKZQiZvDY7w0PaQZSuWF3GKHzk8RcLnxtukqnLsicy3YbFKUrMQG5kfdbGTq7ATMZNqmkWEUpp5m3+eSgpcc4jFKif2yKC8s8Io7rpqnkORVBZDex0yakHzdNl2ZF3RRrL3HtNnT4qz+VmyLmuNiaqkL6CuOSuhCsJmF4tXtO3K1RgLz21eSZMprdUD/ZfNYm9p9s+cvwjypRit9egxZ/QA1DfM7Ujmxms5jHlEimw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYe86O8SGcINloqMZIlqf1FLwKzbr6kv19C/xpokve4=;
 b=bJhJN6fJ9jItle8K98Q0p9Mvmuc2At7saxLhfabnB5SzL6/NbfHMD37JRcr5FrU6NuJ11x3Y4WeVGVidz/oOKEYF5Uk/LYPp8DljRldYOMwu0g8fw43vMYqrxeGoXFLPHeB0IqrcyR1iRaO3Tr+AhzVtDsSh63Kr/v+dT4Ke6uo=
Received: from BN9PR03CA0804.namprd03.prod.outlook.com (2603:10b6:408:13f::29)
 by SA1PR10MB7832.namprd10.prod.outlook.com (2603:10b6:806:3a9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.7; Tue, 15 Sep
 2026 09:56:33 +0000
Received: from LV8PEPF00000067.namprd03.prod.outlook.com
 (2603:10b6:408:13f:cafe::2) by BN9PR03CA0804.outlook.office365.com
 (2603:10b6:408:13f::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.406.12 via Frontend Transport; Tue,
 15 Sep 2026 09:56:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.23.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 LV8PEPF00000067.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Tue, 15 Sep 2026 09:56:32 +0000
Received: from DLEE212.ent.ti.com (157.170.170.114) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:24 -0500
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE212.ent.ti.com
 (157.170.170.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 04:56:24 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 15 Sep 2026 04:56:24 -0500
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 68F9tB8B3000901;
	Tue, 15 Sep 2026 04:56:21 -0500
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Tue, 15 Sep 2026 15:25:27 +0530
Subject: [PATCH 21/30] crypto: sa2ul - fix error handling in
 sa_prepare_iopad
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260915-b4-upstream-sa2ul-cleanup-v1-21-57ab34e97162@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789466112; l=6265;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=jJD122KvC2Ro1YSER8fKZ3D+NYvoM2oI/GA4yLGo0xA=;
 b=DcPTZpPSnB3+SZNV8AqA1M4S6jUWE7T/QUndjyrbkWaFEamapqBhV7WZYHAsLhHSnL0agWy5j
 0YL7x+muc5SBNLXSKzkNk2rrVro3E0IEwGrBYNpTxySAHDxupXEf+pd
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PEPF00000067:EE_|SA1PR10MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: aab09aca-4677-464d-50dd-08df130f9f45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|18092099006|18002099003|22082099003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	mWwC7ZvN5JWcA2crRkJb/LWS7xmpXDxrrMzZcqUNJQX1CJN96tUo45FgsMuYxVjKn3Xe/w+q/We/Vs2QYtg+AJJztGkro6mf1EmDhYlSmon97kqq4Rn9fzYga3DJf3rhsX8fLStKxWBS0dW8G9zwFZlh5esxljHYtvQ0VHRd4KtTObnpuEu7H+Ub1MWxom6yazg5jm/7l2qBNk7Rw1gGcXIskFVTkFTK066ZEcBHel5Ys4XHJCeBXZ6WEMJ47Xg98a/fGTJv+LjKfUkSze2UWyYUcRd/oUyoM6srI/e2p94Fs4JeVUXJYEqyUmv5REhX50+nOEQorfEAr4sxoVsY6UnFLvp0xyUJOWTSw/U3qXVKBPumo1JwHA5q01kf4315GFgQSmJLEGHbefSqufOWiqr2IDKJPCfP3mNCteLxKiACn/ZMCfWQYdXberCKspmXzV/DAxrQnB5wKH0ibBx/O4aGDTfx/J1UyJLwf/1mY57GnY7he37+yR6DATorcb61zPjnG2DlThc7MlmZHR2wjNYcMIca1Zb4vPMUyhVNLn0Evaha7beGqo/XkBVw67TPUpjuJj7+rJK7TA8Baw1W5t36EGYa//oO3ajE2LRU/sIPVTWBu365eCrgd4U7f5IBmBH4FrJ8j3Y6LmHsMfmbLzadhMtsLhZ60f+WaYAiQYNrmGDha4qGDDVpBNMMT/eY0dXgJwzgoOr1TxaF3/Da9w==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(18092099006)(18002099003)(22082099003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	y7PVDMZVGF9YJDlZm+rsQl1r8n3SR1MQn1XpyhY4zDsBWfpj15uPESVu7o14OHPyhCsYb9IIdfTeAs8mObOIxQ5v6HUnfpIrRo3bz8cJ6DEcy3vI4XpqciqWUEo+9gnOX5bqNaqbkDpjRSCovQDK2fN9k5zqU30bxySktNP3lS5GOJHbqdH0CzB6lFtDyjw0Fb4B37NBS98E4TvKJLPR4it/xOlnwCMXYk7zmpoDJxC9wUDt6/HRT6CiJLmJIw89Qajdm6SH9C+f/8tyOouUx4ZOTRCpVQTZfJ/3HG2MNJ3fNQqwZ4fIIvkldNL/hIrvrkBl7uMJKWwZk9GMcYIzKApDGiRBRVb6EvqMYUxX80C1AnvfRf648oMqmMnJ2iD7xXmP18zD4JqtaDHKmQOxGqBA1ZyDAAuSg7Kef7cMTXmkwqxH91N51EzVW1jIwT5D
X-Exchange-RoutingPolicyChecked:
	YUvvSWW7F5yJNN7YNt85HWzzMBEqz6RnGIdamZZYzmCAs0T5yxjXR3DsfLjvmtUARoGCPacf2OPaZevp8Q8TyVntpMNZTOLSbn+Ag5r6MVOhUIGNBN3Y7mppOFizps1nhLvmLOt4+Kr7e+svzsA9LVHD8Z1mZD70Gb9aVUsN1Do/0h1hYx9nJHwtBC2fQujvhfYdNno3xaAVNXikgcX+wXIhx8lNr0xF7Lbom+DNtzLsFsohs7WUFbDd3kRX2wozGNqc+zTtegIRSsuqJ/5N32vFER15J6MrwEb9bxwIigGgU8cLg541tb9NVre1h2s1mAOMxX4x2GRryUYJe3KoYA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 09:56:32.6254
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aab09aca-4677-464d-50dd-08df130f9f45
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000067.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7832
X-Authority-Analysis: v=2.4 cv=P9yvFSAu c=1 sm=1 tr=0 ts=6aa91655 cx=c_pps
 a=e24IK3jsPB00aLvKg+wNHQ==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=s63m1ICgrNkA:10 a=V5UXEbMT0ywA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8
 a=AnTYPz4I4B_XLNGOx7IA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: S9uYek_Q7k90oZ3ePrEsqjbdJf8gy6eW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfXw67vVeFpnk8A
 eQ5KLWwU9AZCvF8iy4FU+kd4VkISOAInre7a05pAjpfRPJ9er6wjKJylcDhFIN70GDXf8Z1kFz6
 vnkzZdol5xxII4vjbbeHQSgd7y1W377Z1jvkL2jBbFRmmL3gZojvU3zrKFRnBdbsO9OmsjLSR73
 hPQZgoj7/lOADoYK6Oxt2N3xJop0iFyw40nOCavFBsykbfPGYcAuDYcBOzk8rSb1kE6aWL0HQaM
 0gHXVm0k9Kj+/iWqYO0uANOg6FJRQ+IvNceADOInmZ2Y8BmZRS+ssKSszsYx58gcoNN5gtt6kTi
 aB5ikg5xCmCHDz10LJoKcvrgHhYwJvSPoPuw03JF9v64LxN5pn66me5y/9WrHR8rxzGPo9YKHFX
 gz6Som8tnv7ExfyaEZpzgimtM4q4iVMbvKzva6aK2mHbqzrGwsRH86dYOrC5929UFN+gsaYj37U
 qwwr3altKFDOtlu/FfQ==
X-Proofpoint-ORIG-GUID: S9uYek_Q7k90oZ3ePrEsqjbdJf8gy6eW
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDE0MyBTYWx0ZWRfX+Xaco1mRWbp4
 gjp6D9B67q7GOLEi0nKOuXCXkJQzlR3RUfEA1lE9E0ZvqvXDXoWLNA5vsMOAQ3GFisbrINQfpll
 mH+1YtCdIj5I7D98oR04xmqsuEhGa0A=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_03,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150143

Fixes the call stack for sa_prepare_iopad to start returning errors
incase of failures. Also fix sa_export_hash to propagate the errors as
well as it comes in the same call chain.

Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Assisted-by: Sisyphus:claude-sonnet-4-6
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 101 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 79 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 9e86b9531366..f89e84c5529b 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -133,8 +133,8 @@ struct algo_data {
 	bool inv_key;
 	struct sa_tfm_ctx *ctx;
 	bool keyed_mac;
-	void (*prep_iopad)(struct algo_data *algo, const u8 *key,
-			   u16 key_sz, __be32 *ipad, __be32 *opad);
+	int (*prep_iopad)(struct algo_data *algo, const u8 *key,
+			  u16 key_sz, __be32 *ipad, __be32 *opad);
 };
 
 /**
@@ -392,12 +392,13 @@ static void prepare_kopad(u8 *k_opad, const u8 *key, u16 key_sz)
 		k_opad[i] = 0x5c;
 }
 
-static void sa_export_shash(void *state, struct shash_desc *hash,
-			    int digest_size, __be32 *out)
+static int sa_export_shash(void *state, struct shash_desc *hash,
+			   int digest_size, __be32 *out)
 {
 	struct sha1_state *sha1;
 	struct sha256_state *sha256;
 	u32 *result;
+	int ret = 0;
 
 	switch (digest_size) {
 	case SHA1_DIGEST_SIZE:
@@ -411,20 +412,29 @@ static void sa_export_shash(void *state, struct shash_desc *hash,
 	default:
 		dev_err(sa_k3_dev, "%s: bad digest_size=%d\n", __func__,
 			digest_size);
-		return;
+		return -EINVAL;
 	}
 
-	crypto_shash_export(hash, state);
+	ret = crypto_shash_export(hash, state);
+	if (ret) {
+		dev_err(sa_k3_dev, "%s: crypto_shash_export failed\n",
+			__func__);
+		return ret;
+	}
 
 	cpu_to_be32_array(out, result, digest_size / 4);
+
+	return ret;
 }
 
-static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
-			      u16 key_sz, __be32 *ipad, __be32 *opad)
+static int sa_prepare_iopads(struct algo_data *data, const u8 *key,
+			     u16 key_sz, __be32 *ipad, __be32 *opad)
 {
 	SHASH_DESC_ON_STACK(shash, data->ctx->shash);
 	int block_size = crypto_shash_blocksize(data->ctx->shash);
 	int digest_size = crypto_shash_digestsize(data->ctx->shash);
+	int ret = 0;
+
 	union {
 		struct sha1_state sha1;
 		struct sha256_state sha256;
@@ -435,18 +445,49 @@ static void sa_prepare_iopads(struct algo_data *data, const u8 *key,
 
 	prepare_kipad(sha.k_pad, key, key_sz);
 
-	crypto_shash_init(shash);
-	crypto_shash_update(shash, sha.k_pad, block_size);
-	sa_export_shash(&sha, shash, digest_size, ipad);
+	ret = crypto_shash_init(shash);
+	if (ret) {
+		dev_err(sa_k3_dev, "%s: %d: crypto_shash_init for ipad failed, ret=%d\n",
+			__func__, __LINE__, ret);
+		return ret;
+	}
+	ret = crypto_shash_update(shash, sha.k_pad, block_size);
+	if (ret) {
+		dev_err(sa_k3_dev, "%s: %d: crypto_shash_update for ipad failed, ret=%d\n",
+			__func__, __LINE__, ret);
+		return ret;
+	}
+	ret = sa_export_shash(&sha, shash, digest_size, ipad);
+	if (ret) {
+		dev_err(sa_k3_dev, "%s: %d: sa_export_shash for ipad failed, ret=%d\n",
+			__func__, __LINE__, ret);
+		return ret;
+	}
 
 	prepare_kopad(sha.k_pad, key, key_sz);
 
-	crypto_shash_init(shash);
-	crypto_shash_update(shash, sha.k_pad, block_size);
-
-	sa_export_shash(&sha, shash, digest_size, opad);
+	ret = crypto_shash_init(shash);
+	if (ret) {
+		dev_err(sa_k3_dev, "%s: %d: crypto_shash_init for opad failed, ret=%d\n",
+			__func__, __LINE__, ret);
+		return ret;
+	}
+	ret = crypto_shash_update(shash, sha.k_pad, block_size);
+	if (ret) {
+		dev_err(sa_k3_dev, "%s: %d: crypto_shash_update for opad failed, ret=%d\n",
+			__func__, __LINE__, ret);
+		return ret;
+	}
+	ret = sa_export_shash(&sha, shash, digest_size, opad);
+	if (ret) {
+		dev_err(sa_k3_dev, "%s: %d: sa_export_shash for opad failed, ret=%d\n",
+			__func__, __LINE__, ret);
+		return ret;
+	}
 
 	memzero_explicit(&sha, sizeof(sha));
+
+	return ret;
 }
 
 /* Derive the inverse key used in AES-CBC decryption operation */
@@ -516,11 +557,12 @@ static int sa_set_sc_enc(struct algo_data *ad, const u8 *key, u16 key_sz,
 }
 
 /* Set Security context for the authentication engine */
-static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
-			   u8 *sc_buf)
+static int sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
+			  u8 *sc_buf)
 {
 	__be32 *ipad = (void *)(sc_buf + 32);
 	__be32 *opad = (void *)(sc_buf + 64);
+	int ret = 0;
 
 	/* Set Authentication mode selector to hash processing */
 	sc_buf[0] = SA_HASH_PROCESSING;
@@ -529,12 +571,20 @@ static void sa_set_sc_auth(struct algo_data *ad, const u8 *key, u16 key_sz,
 	sc_buf[1] |= ad->auth_ctrl;
 
 	/* Copy the keys or ipad/opad */
-	if (ad->keyed_mac)
-		ad->prep_iopad(ad, key, key_sz, ipad, opad);
+	if (ad->keyed_mac) {
+		ret = ad->prep_iopad(ad, key, key_sz, ipad, opad);
+		if (ret) {
+			dev_err(sa_k3_dev, "%s: %d: sa_prepare_iopads failed, ret=%d\n",
+				__func__, __LINE__, ret);
+			return ret;
+		}
+	}
 	else {
 		/* basic hash */
 		sc_buf[1] |= SA_BASIC_HASH;
 	}
+
+	return 0;
 }
 
 /* Format general command label */
@@ -688,6 +738,7 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	u8 *sc_buf = ctx->sc;
 	u16 sc_id = ctx->sc_id;
 	u8 first_engine = 0;
+	int ret = 0;
 
 	memzero_explicit(sc_buf, SA_CTX_MAX_SZ);
 
@@ -727,9 +778,15 @@ int sa_init_sc(struct sa_ctx_info *ctx, const struct sa_match_data *match_data,
 	}
 
 	/* Prepare context for authentication engine */
-	if (ad->auth_eng.sc_size)
-		sa_set_sc_auth(ad, auth_key, auth_key_sz,
-			       &sc_buf[auth_sc_offset]);
+	if (ad->auth_eng.sc_size) {
+		ret = sa_set_sc_auth(ad, auth_key, auth_key_sz,
+				     &sc_buf[auth_sc_offset]);
+		if (ret) {
+			dev_err(sa_k3_dev, "%s: Error in setting authentication context\n",
+				__func__);
+			return ret;
+		}
+	}
 
 	/* Set the ownership of context to CP_ACE */
 	sc_buf[SA_CTX_SCCTL_OWNER_OFFSET] = 0x80;

-- 
2.43.0

