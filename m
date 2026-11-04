Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771161;
	b=DN/ZPT+wvff3SaWBvd0ERIiImn88Q8zyjlhGXiPgstELC4Duwg6xElPJqPwKuK3KhCLp
	 m5+bVZdapaP6ISyiseSVyoc7dLa4PmicqJei28B3CG5HtkeFGFoEsVsAR0fv2Gt94Lhy3
	 4wxI+cpfasHXXIS6tGsIe4azUukxijSSziImitBGDzhyd8HZHYHXPaLD7znIt4zppyhkK
	 c+7FCnxThYC9Boqsjz6dvF8BtnYDKyZS1IA6+WWyqMNklMiQQXEbpKzWybug7/2GR5JMT
	 FhIgDugqYvljPV/unTdC0djYwuLnAO1mg5F8iZ65cWrw1goLdkxRWmLgidWZL47sNRw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771161;
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
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=4j82RSMv+MmC/EVjX1ulpUutBRqLJ86XZwmevABIkSk=;
	b=dFuqmI2sFSGV5ykhqn+DIHilFzMH864V4W/JsfwKw0iNHl7t777Hntp5pHlsqeasAI49
	 IoBMMSGGNh/m+CA/W2a1hCJma8mRZje2BB7kE+hXZJWGjTCgBBK0m3v8eY8SUcjOk80Hr
	 eADqiAtLXMw3JMoElQ3XoEP5Du7pIhh4gkDqcfUCny8Apmt7rKx0On0TsIZlAHHQTAZRK
	 A+1QgCdN/0Agbr+7NhKwsi+/sWso5YotsMjZGzf4uX44q1uF5di6QWnWVfxQYD4g5596/
	 Lfifm7uwGq32pkqj+ieJ/uCSup1aoMDL8Llk4gr/mr2MjPuJsl0SrBYwMYifA1lxMlQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b="cn/riSeb";
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=F+VfxFIX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9842606A32F;
	Wed,  4 Nov 2026 05:46:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9842606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=cn/riSeb;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=F+VfxFIX
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A42TKsE601412;
	Tue, 3 Nov 2026 23:45:56 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=4j82RSMv+MmC/EVjX1ulpUutBRqLJ86XZwmevABIk
	Sk=; b=cn/riSebL8fsARgX7cSipzoR8f6ONqEFHSnj3cE3IC4rF0r8EzHDor3FD
	ZsViEwotkZuZvkvO0J4l1sR/mCEUsBmfj6veGzucOSqzVlOt/gyZH80xUNIupxY+
	14rmsq5nVto0HI2wRX53Zi2gI1O5j3idvmoqbKzohqT2rsBz0Qy01WnOL3lnA/EW
	d/Wl6rlnRyB13yxlpfTMsn4KTL7RNlBgLUbSXlDh/gZZ09+pW8Y3LtMyR4WtilHc
	LuZj0ULLYijs76rHgSEzvPwx+oAUQ8UQHJxQf1nsxaM4AaY/y2HyrbPMk/HUd1J6
	DLKWObeQ5sVNDQDHeZ89buAhOeHKg==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hquyf0tqd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:45:56 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ncLD77IkN4Ij4IzOrENWOuciVzBrNP3sAzzbaxQCCV4jjwDcSvTRsLnJ7d6qebh+T65NX4si2M1eWiq7J5M5UCo6YlIBnwnuvn7MjRGviaie3/1f313Urat1x/Ajj7D8PgJMLBu+LBKzDoRDpWGKA1qPrSb74gk+0Lxc/w2BOkl3t1jgpoljU5zVUrOK6thfJ2hRzdPq6VfDrIexQKjNHOgqvsXac/7pnGjUTwXLHJxI+xNXh0sf5G5f715rK0cgkY1PTbHR46Sc7m3rjzoMEzCxC77b+WsLESV9b0/IRJY73V5cxuCPoxgfkKieAgQQDI3+zVNziLxqxHWEWODn2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4j82RSMv+MmC/EVjX1ulpUutBRqLJ86XZwmevABIkSk=;
 b=UPP97iQH10LjcaJASd88kdbzAbzPR+dPiBc0p0CLVh7rx1zg4Q1cfIgG7hD6T6oX5eMj6b/ApmIcblJCY7nlNc6oVnb4USUdNX6sqEZ5DcqNviScyt/bRoUW7DX84YYXfzbiZKUpc8tXwYDhaBQyJmPOHdN2zqADyuAfHASZrdOT1P/zeg6lOBbHhiOhzvUospf87VIBdl18ddCBYW6y4PePzirwnYQ2pqSFCfiKKHCtKRDteATmxxeg3t8cNRUyomIQa+Gbfuo/XiZc2H96rzgVHAPiYO/NrnTYDNnKzN7HOMnXi3hDZzElFfX+Rwj/VLuPvwqFaJh7dAznaooPEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4j82RSMv+MmC/EVjX1ulpUutBRqLJ86XZwmevABIkSk=;
 b=F+VfxFIX9Da9MJ7f0ILouNtzRdISzRponA1KOzZkQ6GEapVcaibh5BSto7VOE6oxycWAgnlXJ4FLozCVGUTnaWWAd+09evBw7tDcnzvdgRTnJji0a/O9yS+jpK82pWEHx9sLLRnhM8MlLoxYd0QIFrWNRiOCGsbxIXS2ZeuxvRw=
Received: from BN0PR08CA0024.namprd08.prod.outlook.com (2603:10b6:408:142::14)
 by SA1PR10MB6448.namprd10.prod.outlook.com (2603:10b6:806:29e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Wed, 4 Nov
 2026 05:45:53 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:142:cafe::4d) by BN0PR08CA0024.outlook.office365.com
 (2603:10b6:408:142::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:45:52 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:45:51 +0000
Received: from DFLE201.ent.ti.com (10.64.6.59) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:16 -0600
Received: from DFLE215.ent.ti.com (10.64.6.73) by DFLE201.ent.ti.com
 (10.64.6.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:15 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE215.ent.ti.com
 (10.64.6.73) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:15 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxw521920;
	Tue, 3 Nov 2026 23:45:12 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:24 +0530
Subject: [PATCH v2 14/30] crypto: sa2ul - validate AES key sizes before
 indexing
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-14-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1925;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=rBVv03BF85nJB0As6YkFZ697MTgVa2jF9eNoPq8mJMs=;
 b=Fe1W0wMwgxZtvYb3y/DnQvf+MNZuXv5Ifxk3+h0iHf7+sfftfnnDtQlk3cuen3gD4t/NdAiWf
 16G57jpX6ceAM57wE3q8xmPSTKuDJZlVGvN/rbuEnuzdrTv+Peezmam
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|SA1PR10MB6448:EE_
X-MS-Office365-Filtering-Correlation-Id: 02cdafd9-5217-4016-7812-08df3a36e299
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|82310400026|36860700016|56012099006|261021123027099003|261021121427099003|261102123227099003|261022075727099003|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	wN3ezMDUt0z9tW9U705t8g+qa/kRY2la/u5WELkEJIjd4GlU8mQ5JtzvG37rBfXZQcYGOVJlfjOXr0qqnLGgRnvutaB38ryd/FmifgWWw2RcFl+NVHbX+8z7KAkhnvwM+88I3TSfK0IKgwlCT9D4t+eevbIFK1A73Y9Ekle0CkKY54CJCjcjGdwDaOmzy1gaQtPpN8QS9BeV6d6OBx3CnVxcWbZiqfYYA80pEqB8Z27x4hPxuHtPzPthH9zsBFYm1MWWo3HlQ2FARguFt0QVscrcwwQo75XmEeFmmTN+pS8ZK3F2qwBSNQaV9piB6KqQC/7WteBWYWaWcCZYDKP8+Y3ChCZb+q34yXjMOsIB0ECeSBCfC+ADFsfmdio1LeUkXtUwiJr4BX6hgE3STuUTklbE05RkkkeWhWsZVPYJhky/CO0LGxTU8h+03Sa4GuOjEPBXLivBFeMCx+9QqEVccim+P6RakGDWREGoq17Uqg3Z8MVHTY7hAgMbHu8LfTXoNJNtPZ8tzorRom3+8hwtSmfgX4JWW7BtJLidVecN0aztGXfBnhbbSYB13iKwDl42gAM6j5EEDroJEfPQi0Dw7cFrUOUHGvvMCcZznwJs6QChOtugmj2zwukRHB8j0yJlXe6kXgeMxNdlmlk9OOrjMk3oPFWmz0WRQ9SEZsNIGw1kIkYppFqkXOHkdbzGH/XmgbA8SsHgmrVKoIVvfHTgpA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(82310400026)(36860700016)(56012099006)(261021123027099003)(261021121427099003)(261102123227099003)(261022075727099003)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ETclregW7u4B/QNvya9jZdJUw23pyg8+9PfR9B9HUk3bVRw5TU+97IUiH0nGGSgvKagy79zdFJKc3+eDQ07s0N9yPn/S7UqU2JX/0xz9i+ELSwLm7l8oqyqg4vvMIdoaqfEt/8E2EpYut9LpNjDj+QZqiIERbe90+N9f3lXEoIdatREvidBIuzL1PHgAR+1G7GV+Z/wEXfYdd87R9R8TOgZwjCKMd/y5oTLnqzCirm3EswQGv8QTSiTJzavZbQQrbmAZCBtMlHfeotDW1UFC1J4PtKSWC8gyr8T8tI5HWIkFNBghvW7pzien6ZJhKz4ENfxQgalsky2YyGSrM5koOZMrlFxXmil3auiEJ/HxZWXZJbYbbZ9/nDzsUoiibqFCj5ijuwIRw7aUBEJIZJxYHf5aJCEww6q+yTQ/12beNm4FI+feYaxENxPLE6cK9k3p
X-Exchange-RoutingPolicyChecked:
	ckt14gmbJoFunaBW+N/DdzUsV3NWW4mmO/sZ4qDHHJDB68u8Mzq93EbfQdm4rtctqhTUhxQHDcFRxtcfRJdIeubZN801T2iJUsVSeUB2/JAwwY32V5hDYmrpgABt/bSSf3KbrVOV6OZmlXiwYLhH87t2He1tbiFUzF876mOsX1kaqvVgeSvpReW9eiFSalM7t5aFBEFKlYAhTuUbEOP/xXuhcmg0jvLi15hIaRzE+7M8wHr7mwaUBf+AvWPu9jcojddwGYChXbsousdWAhoBpU9CFTZyNIBnr2BdiOimroZYVIriqzVrqB+jh3jKt3N7kBqid+87UlxcmcFwWOVghw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:45:51.2981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02cdafd9-5217-4016-7812-08df3a36e299
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6448
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXw5AxeqGgOmVr
 mrh6CpARS0FFtfMuelEYxzb0+KojTMcWRyTsMYl5paxkbQv8bNLsnxle1fuwAVxpDEJdFIEhVtg
 5pc2EnCjeeBI0tlVdmEIfy5Pf9RKSom4bniz91MqaQhlhRKsWPTaTCNCjgG73pgoBIS6Rravsy2
 CU6+1C+DIMLWm4k8cgib4YVwhqmfd2llsbrq7jk+xs1/2Fsh6xfXinKIN0au2ZxEZci5AjB+qPw
 2u7vUKMrDg8jcpPhJYeQt05LZrAnMggIn0Ws2pkZR+wZtAoOeGcrJ5IBfmLWyk/Ui8WjQHvXaHD
 upxgScBekobHS5kAG6gCdY3Zhd7gYCmGMDIqLIe96RRDE9CC0cfJlKY/zoQktK1VHbF4Fc0154n
 h6nazJGtw3qydO3P6ufZ8dmLm+6rRT5JoyUx84ozavHdrUaqtMAt73JbsoQhsWmFMSEr8+9Cyz2
 +dvibsqXq1ADddZm05g==
X-Proofpoint-GUID: rgzT5NNkKxZFOUOMrps0-GBYnTqzWHkL
X-Proofpoint-ORIG-GUID: rgzT5NNkKxZFOUOMrps0-GBYnTqzWHkL
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6aeac694 cx=c_pps
 a=OocfSUbDEXyHRS7ToLrH+Q==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8 a=Nig8YUdoIBuN8KjuR4oA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX3dsaffXk+NE1
 hxJAwLaaUH63AukAqsP3hyxAe7goN398G0Ufrk5FZo/qgu7zjZNeL+NBbGtagiBR3t+DkzsMVsZ
 6vnhJFQsoLQ8Q9xBrDC6JDXq5PzHlFI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

Short or malformed AES keys can produce a negative MCI table index. In
the AEAD path this access happens before the common late AES-key check,
so reject anything other than the supported AES key lengths before
selecting the mode-control instruction.

Fixes: 7694b6ca649f ("crypto: sa2ul - Add crypto driver")
Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 3c25c98e3e92..30ddefd4c0b5 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -856,7 +856,7 @@ static int sa_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
 	int key_idx = (keylen >> 3) - 2;
 
-	if (key_idx >= 3)
+	if (key_idx < 0 || key_idx >= 3)
 		return -EINVAL;
 
 	ad.mci_enc = mci_cbc_enc_array[key_idx];
@@ -876,7 +876,7 @@ static int sa_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
 	int key_idx = (keylen >> 3) - 2;
 
-	if (key_idx >= 3)
+	if (key_idx < 0 || key_idx >= 3)
 		return -EINVAL;
 
 	ad.mci_enc = mci_ecb_enc_array[key_idx];
@@ -1658,10 +1658,13 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
 		return -EINVAL;
 
 	/* Convert the key size (16/24/32) to the key size index (0/1/2) */
-	key_idx = (keys.enckeylen >> 3) - 2;
-	if (key_idx >= 3)
+	if (keys.enckeylen != AES_KEYSIZE_128 &&
+	    keys.enckeylen != AES_KEYSIZE_192 &&
+	    keys.enckeylen != AES_KEYSIZE_256)
 		return -EINVAL;
 
+	key_idx = (keys.enckeylen >> 3) - 2;
+
 	ad->enc_eng.eng_id = SA_ENG_ID_EM1;
 	ad->enc_eng.sc_size = SA_CTX_ENC_TYPE1_SZ;
 	ad->auth_eng.eng_id = SA_ENG_ID_AM1;

-- 
2.43.0

