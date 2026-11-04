Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771213;
	b=PqGe3685jPx4/CWClf9gFk6MFN8z7CeypFBHa4HdgTBBnDk/YLMcZIeQDidKt9xubzYZ
	 +r0oh7ZFhwYF781UM3YSiI2jhHLLRxTeLwdqX0/7U8zP97AbRtJSsDxCXexDO+sigpu2E
	 51O+ilO8gONbMqqdnCeAjIJZuTxXWC+Lu1h/NY4PJ6ZQoIVwxcmCUIfX4gOfsQi443UtT
	 4bYbInERGmtq4qFl5dklwTgJWot2jdHWzClFagylEP9jvJeqkV5LQeLLhooWEfTRMBxkG
	 3iDkUIDyjPVYbRqreOIfYZZzcEzwomEUV2t2rcWdBFTLiPpYGSI5rC7bILysLKbp0lg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771213;
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
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-Proofpoint-GUID:
	 X-Authority-Analysis:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=fekUCK+FPTvK9nQoTNqrjLc9pYMPQPt7T5F1Li7UEz0=;
	b=XhctkDiIKcL9I24hT3x9WMO3fDrJFFfpicNaLZluUsIpjDET6r/vzF2K7OEC/iwGLEJ8
	 UrbffAdzIOK2Zv8CoETe8gNMJZS8qxZRa8F5Ct5aRUjvxKB0RgL+o08try20VILeILxiy
	 q8JcDRkSVURo88AeY+ujEjQmW4JT54egh9RSTEdXv42bv+rFUTOFhIX7yHSVbITyN5yHd
	 8BV2lb1zhTo4pp3fWD0P/dCOB7VAE4q84HrrFwCGA9AE188kUhPObJz1uoK0tk2xNjTlo
	 7DT0C7POF+XH5+EaayqdvkVAERKBKdQ0WDyaY2qYkL/xBWjvOQozM7h7av3tNb+HQ5A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=WhPZbjFF;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ZQ5oWOfk;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17C6606D816;
	Wed,  4 Nov 2026 05:46:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C17C6606D816
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=WhPZbjFF;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ZQ5oWOfk
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40SCq82589087;
	Tue, 3 Nov 2026 23:46:49 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=fekUCK+FPTvK9nQoTNqrjLc9pYMPQPt7T5F1Li7UE
	z0=; b=WhPZbjFFFLq/rmgYiI236jfDsgqVsW5WFUqLmwUFymOwKevXXiGrnGz1S
	6bQCSaTpfxRLxV3nLEihFpETcozKc+ZK9RKMNH1qNRVJ4im/qg2JSrG6YCQMCy3h
	XLS2RmzWhfOrsFNd139FjbWwdcNO8IvqVCfaW7iLTLk6Be+nq+U03KvjAf/13AIw
	G8oBJHHN+tlDLuqSOX0LHx7NAWKFxjBHmp6UMzTVQ4UTm0VbEa3+PWwaGP2Sne75
	iG5uvXveQZyX1HpHqmM7Huss/WhTRHSw00UTohGyB5MTJAtBRi2BuzvwnGWYoJG+
	PYUOT+KtK6yODdHZ3LZ8AGMjSzURQ==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hqnf52xnm-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:49 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SKVvIULepa0ROAQPhcfi1ny7hgYlBhHsXgKFtWReHW3V932A+KraZ8gPqnxFpLJcqnHyEgm4GaabP4vTXN79YosqL/6bfV9PbqTxw7IC2w7h6K5B3pu9DOB92/TKxEbnXkDiJ0zUbftfTRCbaHL3M0MEWkF15MDfc6Iq3pUMO2Migz/SJOnxd8hqNdX3L84JeZmNIOFEeDS3lbcWYa1QiW7Oua8ilmCX354mOrvMFfgtMfsYHjMjFtHnWnzOppawPQxweZQfxpTBdWqHVSYcnNgSYRfRXRjzKnzDRhYAlSNkZYZ3M61PxhX9WNDMhkx5cg+AnM5wDgfixuZh1gkIfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fekUCK+FPTvK9nQoTNqrjLc9pYMPQPt7T5F1Li7UEz0=;
 b=yzEEHl9/kOMSb4wZlNS9o3zWVhYzMfl7zbkHopk+Bn2kZNntsF8cRW7PJSojEicIs566uSExwjqys7kpwIvr2Q4LrjPoB1ELuVK46KWkopFESgrnKO5zynQGkgoHSysz7SRPMRZUuCtE8ADVc/kTyteJu/jkNVaFElYjQ3cnnQdfwk80YbzVTUnTbtOLVhSWJI6PfgwjP32TRz874PJdp6WMJ6qmn2Uetgg5MPpmW084vMNn2hu5bFEkmwcpEWHo0INLxdj7nUF6TdCWX0rOxwJRUFP3HOPUcw7dnGLaZrEzglVzWkarLEAX19Pua44RIfAm0UAdODbQmcerG3tNDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fekUCK+FPTvK9nQoTNqrjLc9pYMPQPt7T5F1Li7UEz0=;
 b=ZQ5oWOfkoh5AL+V3JZ/Ot6SEOCBET2dfdSYqIA7RC5FWUAt3D4XIERovDS05qrkbyccVfLXmML0V2JIurecP7pNLE4v5/mkRyqUBi0gcPOOnK4Mn/FXBsVbbQUTGfelDJbBLzXVsHz/7ITCtRWczozLD1G1tYzrZWyiZ92RlRqY=
Received: from BN0PR08CA0006.namprd08.prod.outlook.com (2603:10b6:408:142::26)
 by SA1PR10MB6415.namprd10.prod.outlook.com (2603:10b6:806:25a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.9; Wed, 4 Nov 2026
 05:46:47 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::a7) by BN0PR08CA0006.outlook.office365.com
 (2603:10b6:408:142::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:47 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:45 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:46:09 -0600
Received: from DFLE210.ent.ti.com (10.64.6.68) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:46:09 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE210.ent.ti.com
 (10.64.6.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:46:09 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ0D521920;
	Tue, 3 Nov 2026 23:46:06 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:39 +0530
Subject: [PATCH v2 29/30] crypto: sa2ul - report SA engine hardware
 revision
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-29-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=2356;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=uEFsFtB7Jg0jFvIV3MxmQQsthdIwrzygxhlWMg0HRgU=;
 b=2q+LMv7/d5QGeEm56ohaYj0oQ2v/BvLubHd1a1Kq/KbR1gyNpmhv/Jd+5pif79JhIRFwGtQvy
 2+jBwOh0dukCEGHbNwLsL7FDOiAk5jTIib4dR8hyGIraCvRvpjfY/C5
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|SA1PR10MB6415:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a506915-867c-48cf-3b58-08df3a370304
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|56012099006|261021123027099003|261021121427099003|261009223027099003|261102123227099003|261022075727099003|10067099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	Dm6G/QJPnW55xaiK3s/HyxA5/qku/s134ZNiMT92v8jBMYw+z5M9sLmP5emOuQZvax5qMFXueMBYRQTW1s7ktNlmeh41qrAWUOJKrMWFirHMh53uB7abAYxxM4TBE935FAPIDvMWoVFCuN/fd8iRJ9HWSnmkg6vZ/f78mLKOEVgcsuvRXDsCTGgvCjBHBz1vF1KFS+OW4JgAPDz+me6DsJB3lifNLbSJG5mW0CGxIrQxH6ED+dQdIF/1zQHvHezzsnIBaGITYSrpmOGLRARnbqX+UsEbSjxs6Abr4hFVZXtbiRUCwPC1/3FnSfftT0++m+wdl9W5LmBN0x/Tz6pREXS+yxzaznI7d5h6I8gwvg3Hc6EO5ooCxi6PSxy6ADzzLrEJwCzD3udylKDXdAAk7ylVvD8jo+Rzonz38TEjHYtk+rLMoxM31yZNU/1i6+45e2zO8P2y91OMlWHyFMEgjTVlKOpLa80RFmxPZUHoWv+WVVE8lq1o0JkUFGifXQ2W1BnyOJoZLJJrTzzAKBZJtbSGedfOJ6MHbkHTZanM7h8+vu0gN1WtUTUKORDrEDnolM2MqkiKXZ/bGXF44cTuEQpmndQ40DcvKqR6xArR1xOqynfRdQ9evPfeGNH7fjdzliR8KaOVrvjf6VpMDriZCHmGaKrZx+dXDkhm8y7S/+Cgh4XshRuI1mlsaNoQFOE6lypFxAdiErZAfvlg08kTzg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(56012099006)(261021123027099003)(261021121427099003)(261009223027099003)(261102123227099003)(261022075727099003)(10067099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	Fjb3s98D8mLsAJeivrYi/gwxuIHM8d/fpaOJDKl3UbYRYwncrKeLu2AiotXjUFBGtaMiUN71HeYxrsdpMnKxz9RE9184CZSqPtoOzhMUOsnJdqxp7lUEVv+YVPYTucvuCCeRvqUGrTlsaoRpsvrU7CX8BH/OEtuCdv083kWPG+Iyzarg0tGSX7t/6LSH5ypjhBlfPNE/7dgGzoYPZtESmfl9Q4AgqTfzHjHl17snIWsRSd66p+3sQWBruF+nqu7IjzLi4YOo5ZKgo83qyGdyh0n95u829KrbOdYp6jrjyA9Zwx40MhWNC1q5qdrWWpqLjJ4FqVO+wPtoUDk/E3rWMh/osM1EnFylMHbSluNtbwQcSVZLGGTKmxKey+JhtRUIHXDTwt4Cihcody49Yshi0/lkpgzSJYxJvV+cfZXLzuA0lW7SMk0qx20ZdrUS94re
X-Exchange-RoutingPolicyChecked:
	cmV16JAVURkXtD2Rz4wWmX/x3MxDG2TYU0XQiOWjVibAxe20VLXR1sjIqB2YBu+Evik0oMzLzNoREmknMxcmSOGxTYFZRmSfbb0g8HfUbOMe8i/u2ud3GfaytxhcmJUvrGlAzGx0VNuhfISZIWbPPGknc+NDt9sUn7J/Jh9rVLruvqOoKiwkrdwBRDY+sABFlUtp72+Pl712dkQM0cCbDaiR23v25kGi0W8cNOLbSqMq/ftDs2ZzBpgyyS/+j7mYWzM678sBhVk8m21ETfrOt6rOuEyuyW3PHu2XCcmyTDZDjeVi7bFAaTcAiCChg5s8m/KBgU+BoPbzqG5T/6mriw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:45.6964
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a506915-867c-48cf-3b58-08df3a370304
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6415
X-Proofpoint-GUID: Ba_LCtegwMXTqExR80DvbImfzEz5g6C0
X-Authority-Analysis: v=2.4 cv=XcYcX455 c=1 sm=1 tr=0 ts=6aeac6c9 cx=c_pps
 a=bw0VQspFR1l10E3Rz9sV8Q==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=LnI6Yo263kNF2zJdUusA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Ba_LCtegwMXTqExR80DvbImfzEz5g6C0
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX6hZwy+0zT7AA
 lkJWpB4DYEw5swo4R451z/Q54xvPhWqg6ykARlpyYrcHBfmJHB70rNJk7D59rRNXW+djh++r+fN
 gBmMlC2KJTiyLZayAWZIMpghjRchmlA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX0whBPHb9A6/+
 1xMxXC32rC3C8FIwduVo682e4rVBUuuxyyet6UTzpJQPqe/nkZYk/jfQz0GSnytsoQh3hpzNHRF
 BG/50nSurhStwzojNCaBvMgedlR2NHQtqgcgnN0yBsjCRGFxqBo6621nokvfyzOANnjv57p3T4P
 RJDhN42gT+5wQiDhTpDgRkvXDzH84S3CmKF7MSvUwHjDQQhyvI5UqZLSIXIw9fronVS4SbalVmg
 aWJJbiyFPF3+Ceqv/AQDOSbnMm4mjyIPkBXIefW4fT7ewoIbvV63SmyZNoC4jSq4E29Tv89foFw
 T1WJ57HlC8EQZE2XSPhuL3MfdU7SOxTIG0DesXcbqGYyR8HOVxXk6/heVX6GtxkrWm8mMI1l3UC
 aedDzDiBU8rzVo5mKFrxhR0pYGbnLJsHJPSWQmthCGFkXRTmvevxFJl2I297MDvWi5BF4/EzMnm
 jxgjCwTZC2AEgZ6bltQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

The SA2UL/SA3UL crypto engine exposes a REVISION register at offset
0x0 that encodes the major/minor hardware version (major == 2 for
SA2_UL, major == 3 and minor == 0 for SA3_UL, major == 3 and minor == 1
for SA3_UL_CM). This version information is needed to detect the AES-CM
(SA3UL_CM) variant so the driver can enable the extra TRNG-priming
and AES key-expansion workarounds it requires.

Add the SA_REVISION register offset and its major/minor field masks,
read the register during probe, and log the decoded version via
dev_info() for diagnostics.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 8 +++++++-
 drivers/crypto/sa2ul.h | 9 +++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 5716b44afaeb..d7ea61452577 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2480,7 +2480,8 @@ static int sa_ul_probe(struct platform_device *pdev)
 	struct device_node *node = dev->of_node;
 	void __iomem *saul_base;
 	struct sa_crypto_data *dev_data;
-	u32 status, val;
+	u32 status, val, rev;
+	unsigned int major, minor;
 	int ret;
 
 	dev_data = devm_kzalloc(dev, sizeof(*dev_data), GFP_KERNEL);
@@ -2509,6 +2510,11 @@ static int sa_ul_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	rev = readl_relaxed(saul_base + SA_REVISION);
+	major = FIELD_GET(SA_REVISION_MAJOR_MASK, rev);
+	minor = FIELD_GET(SA_REVISION_MINOR_MASK, rev);
+	dev_info(dev, "SAxUL_VERSION: %u.%u\n", major, minor);
+
 	ret = sa_init_mem(dev_data);
 	if (ret)
 		goto disable_pm;
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 510a9fc4ab62..ba3fb91daaa4 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -17,9 +17,18 @@
 #include <crypto/sha2.h>
 #include <linux/mutex.h>
 
+#define SA_REVISION			0x0000
 #define SA_ENGINE_STATUS		0x0008
 #define SA_ENGINE_ENABLE_CONTROL	0x1000
 
+/*
+ * SA_REVISION register fields (see REVISION Register, offset 0x0)
+ * major == 2: SA2_UL, major == 3: SA3_UL (minor 0 == SA3_UL, minor 1 ==
+ * SA3_UL_CM aka SA3_UL v3.1)
+ */
+#define SA_REVISION_MAJOR_MASK		GENMASK(10, 8)
+#define SA_REVISION_MINOR_MASK		GENMASK(5, 0)
+
 struct sa_tfm_ctx;
 /*
  * SA_ENGINE_ENABLE_CONTROL register bits

-- 
2.43.0

