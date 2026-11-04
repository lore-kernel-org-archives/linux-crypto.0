Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771095;
	b=Bj7QhblXyzb/Z3HV0OKTpgAeSd3X8Z+lIpaNB9hYhsgmC8THDWyQvVmgEdlZ+/OGaHev
	 hmv7NWQlY2deesQUUKUH42uI5bwffV20ZxmcF7d7FwbsitzGuB1xpc2C25erkLAezys34
	 A6LF3SmFaXFCYxNqGfoxz0Z2DV+ylz+DkWdCnUn05Vysglqjp36Am6+qm5CQmwJPupp+R
	 25Q4B9Cq6i/TCyWe9GNlwPl06HO41SIu7p15JeMNwTjytEkpY2B0MttPWl+CaHRVuCuAB
	 cQfIkbbip8hPqNOtUXcXcnt/SUswPXohS6+DRa9NtG5+b0UvRByJ6Q1SlKoUm245KlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771095;
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
	bh=CWnUAF11ly3EYH52OEZTUP2Y35nfghO2/eDESlQb6Os=;
	b=i5uu3UNTicbQAkhO3Xo0f0Gc/1Yzu0aSf7C/IfIUxJfK+U24d4KJH+ueGe/MhFWAsrq3
	 lhdY+ws6hVjoca16eKijpWV0vaVqkqXRp7IK2Q/fyp7obuwKA2262qtGy6fmC65b1nuSH
	 KB1cnM6yw9Fx/xUscSgtu+GRPLdAu9VuwwA0kD3qyNiNkQvYykMwdWTZWhk5GH5xQo1WJ
	 L48YZ3XU+dn7my2p2Aodgzp16NOSxc0hSJZSQa8oZiN9uHC9UUNUR2OIA0udfXXedih1j
	 ggJ0mSa4Vo4jN8+kBvikc3GgrEyDWKB6yvwanwfqJev1LfViwL7xw87N2EmSW0yygug==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=ZGmobNeM;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ayGbCx58;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1EF4606A330;
	Wed,  4 Nov 2026 05:44:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1EF4606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=ZGmobNeM;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=ayGbCx58
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40S0MO2587506;
	Tue, 3 Nov 2026 23:44:50 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=CWnUAF11ly3EYH52OEZTUP2Y35nfghO2/eDESlQb6
	Os=; b=ZGmobNeM9P/Qiz96QwZBgdnoI1HvjKqSYXSu7FRLjJvNciXgH+GM3DmDd
	XgD5oJYGOWIxkeZeRkOrlFLW69X7XWlIUC4vs7VVLbnVq3ZOG+CkHat8cTpt7Tjo
	cMbatug2c5kXQuJQcIT6QukO8SCbDifRqPyEzNcG8+nkQtfJr5H9lcY6an/EVAoJ
	svQRp6j78o5jbz3Dxa7du76AnPCmiKFvtEM9mUv/fwQs6WhYLdjQcP6HRl6sGaYh
	911vtxgpdGULPpcv1bFSFj72x/oJjEmsS7TDJ6xmnwPbYnve8pqhDTamBF9oZvYf
	0Mrg5NFvKshb12mSuI+AfQLPssZSg==
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010026.outbound.protection.outlook.com [52.101.85.26])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hqnf52xe4-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:44:50 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kID8bm0aJ9fQHaPh5YYtWQvQntGbmgBIcbX8nwn0aPrUe3gUJdmjKl9XJsXbHfk5htorBbnK3ByKdJBjn5KOQ8VsESS5zpHaO7R2s2dJ7n8sjeLBd511MFy8gPMTkLILf1HHW60XlTQkLjxRTZSaOMskbXfc/v41gwdMxwnokDB/oTvpLzWB0uFrYpc99iU6ZqS/MqvEd2xMgHvKnAOSNGoaM39UBDPIjbb67Qz2ksTmP5ON3sDA69bFJDZjfrH6/AJJuR8YNlP/fvy7a/qSQRezAKDrC6aQ5kO1gkn6O9Bq4ySsq5+7DNl0Ur9ROjG7LZSakwutLa3oICLd5oceew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWnUAF11ly3EYH52OEZTUP2Y35nfghO2/eDESlQb6Os=;
 b=fCW+7vUYqYfQrPrr5lJseRT3B8UzcRTcK+asFcAauhduYeuD7IlkdWrJfxrDI6be5tKayj6cjG/3Gj1TuUZt7U9evHX8IVh3ZWC94Ia5NUSSRHv53rLJuwTgHrhhCWtY8jgRyrZilyW90Pml2Samt9WQOOxT/wsb3my9yyXoiehjSIhXK+xdo95w3r2E6YsaPRKS4py4p4vNhcbY38G1qohNKDkNn68KYzpwBm91M4kPaWaHLzytms+/SVBRA8xQ9ersQ6q0gYCry+nzaIZFyvFxNMpwWAlru0qPtLyG5tcYC7fCTePpy/2+TTpNp7ooZSChXfOJViJg0r4qU+RzIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWnUAF11ly3EYH52OEZTUP2Y35nfghO2/eDESlQb6Os=;
 b=ayGbCx58+J8vyrB/WmizC5O5PpT+ys+8h9H1ma032DmH3ZgAoeiw8jVWssL8PEynSLawy9NYLlMED0tIdTTdSZRo6A6gJgZzT4nEswOK1E1OVck2cPpb4oFW7IdtWEzpFrnHa3px1S89BQMpLxq2/s/IAeiHKA0lTklh4dvXqNg=
Received: from CH5P223CA0024.NAMP223.PROD.OUTLOOK.COM (2603:10b6:610:1f3::14)
 by SJ5PPFC41A007A8.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ca) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:44:48 +0000
Received: from CH1PEPF0005BD5B.namprd02.prod.outlook.com
 (2603:10b6:610:1f3:cafe::1f) by CH5P223CA0024.outlook.office365.com
 (2603:10b6:610:1f3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:44:48 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH1PEPF0005BD5B.mail.protection.outlook.com (10.167.244.244) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:44:48 +0000
Received: from DLEE204.ent.ti.com (157.170.170.84) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:47 -0600
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE204.ent.ti.com
 (157.170.170.84) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:44:47 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:44:47 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJxo521920;
	Tue, 3 Nov 2026 23:44:43 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:16 +0530
Subject: [PATCH v2 06/30] crypto: sa2ul - remove unused base register
 pointer
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-6-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1391;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=b/L1EigxHqeG91jwl0Gxfxs7khI63CitIlMKIoswcjk=;
 b=mCC4vz6/tW67HWX+NMtwJF1xYJly85an9QcWtSP/l9oZgCEyZVVhAUSoirrwdsjjw/zEeqbZj
 JBkbg55Wlr0BQCeCV/A5bcuttco4+Eft9xy3CgHkpq1+Z51kO4Hh8Ef
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0005BD5B:EE_|SJ5PPFC41A007A8:EE_
X-MS-Office365-Filtering-Correlation-Id: 691db259-adb3-4af1-9fe0-08df3a36bd0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|82310400026|36860700016|376014|56012099006|261021123027099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Ov6yqhpRahUajrdIgKMxxWrycvkH3cMxXak3nKWzHWykfkpgHaVeqhsiq5r27wNu0OQmpYBvSVrxLWokpri2/ltFL1/eyZLXhpbB9RuopB4NtHJAx9t463uBP8M5rfYF7oC3JuquruPV018UcspgSkKuf9V9XC1kcodvMOUNQkAjQL+F2ZS9WSZ/aBZakzLsPGqb9xlzRHXIKbSGARHMZTw8ehHRL/dPt1oLZ8k1EXfXx9ghc/2tsLRWLHGUpS2FnudbcibtAG5cuc5fRbA39DfJX67Hmb/WLRj3wH21Icp8hUbw5wIA42cArweU44YE0xcaPM2EFbGu1TpkyxHcY9g0387x9lcTqleg/OFY3z5XEuEdVTCTbCUDWIwP3fidY0OybEJVgNyGIe852RIUkNvaQZRg1oWF4xtBEisLdoH2sJjgKlskdzYbT4pvf3g/OytX8VsHU2Ut49Fp22yrD7LUzaO5uWXaYcbpMrp67hc2U+lKzqvNC2thBJavocpJzO79ndNNwyk3FSxNgd9r3yc8z7tZmYrdHnWL+6b5u6E6dj6UjcsScdbooIGvJ2WVCzMv5oKcHp6yLWQT+TcUvpXt9rUy1aLrPtm9U04Npru4usK5OEG33i8ueBq4sn/b8PosyD7xGxYUMFA0kJlfRTFIRUDxUXcslOMATycAj0r2X+jPjqW8/Lx2EVBdZzH+qNdtgg4xE6ipWl8NP+qBXQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(82310400026)(36860700016)(376014)(56012099006)(261021123027099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	p+xYrnMkRksAqDcL+39LNvW564nqeLyt8haq1IQkGQSSwh6ab23yVNRAt6V3TmAk1s6MpkAgMY/TwZULtOJVM2+Ps3JdA0IYbwSJ9LBlv5pR/T2cQqV66lEGMDqetCwFZ4Djq7JECauYrB8Z5bgswDVojujYzKjS026rqwEAN1HIhAcTb+sTL+J7WbDSrQau/g9XIAchfK1KHhdZGJhPbulRoBgOlI4S2eKTHbYBWJ7Aoobc8R5zTkSK+JJ2WervCL2UPeRKOMOsQyoCpemHuUQm1sQO0J3pCodj2KS5QH1RzOikR8q67qn3c2NsqQjEH4vBruTYUf/x9BxB1zM7ePc2yt/hFxpY5o2C99ay+2GdYySiqBeBnt+zSU0ToC1QCeZuHhkRgXZOvq4UA2UHasXh8eEUXZNCxUzDtnXrmURUV4HB0suNjVON7csa4892
X-Exchange-RoutingPolicyChecked:
	ausBcSH5KWUDdJXsECMk4844A6WD1pUVBO9JeCP6/ycMY5RG/hGFQdl9c7vBaFQhkrKUCA/Rvas8yiNBAgvpT15IHhEz8u9j83JYP1qjiYT+1b/fh2k3CKN0JiB5kqkkGMtG/TT+0g3VE42uTeOQQZiNic+DmZ1H69DurjLys2fouuc0cPWfc1KfZXOWAtMtUSYgQ+1ohdOCyzn77KGbLFa4hJu4LSvx1VkhaolDUWSWxOVkoyPDYUjbkVL+HQ6+QoFhuGNhNOQxh0s5atN96cldjrOqP3BWyYCRjaUBgq0gfyhAjTM8QlFdRppZh7NEBtkWT7z/OyFuuEvuzgRoqQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:44:48.3316
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 691db259-adb3-4af1-9fe0-08df3a36bd0c
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0005BD5B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC41A007A8
X-Proofpoint-GUID: AIH68I_0YALjZgR0pIvxXxzuJGSexYv4
X-Authority-Analysis: v=2.4 cv=XcYcX455 c=1 sm=1 tr=0 ts=6aeac652 cx=c_pps
 a=j8kfsx1CyBm2fJFf+vs0Eg==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8
 a=BT56tlt6Ecdp_ngW-zEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: AIH68I_0YALjZgR0pIvxXxzuJGSexYv4
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXwwQWfSG7+vxV
 FO5Q2Gt+JsVRsxi4SB2rFIAcWLyxycNrj67pXBh24aHLDNdfC+jMM9JpY+0lwgs1zzRxY/clVXM
 nwhoNC/iFSGQe4vcv6ze1UDG8qv32Ts=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfXzZYhboaCctqb
 7TonZAGw1DjEDsdwwlX00JgP66YBbdodUdG/8RonXa5Sd3HByGSxeqzd6De0vut5fATijsqXBxs
 2K3n6ZyldsxS+xquIV8fXYQQ5wly5sioH4twBEZ0wzE3KJamsACEn4TrPVG68Xae6ueiAgv24J3
 mjUWeeitOy5n9kfyK0FZKq+LuC3gWEiJwnUUwubdqBpPfyADOUe6hcRkRUA6SbKpmf2eQ5jFIpg
 Bi9SMDFzLqi+4oZ6rQy+V41BJJR8tqjfbQ5z1dpbUKj48xXiFm1CnLeCtCaNzpy8ZytmnGFLFJI
 l9tsCJO4wQI0JSa3615qQkdw4Z9BjmnT8F+477oFIfLYItPZp3sekVacEOzPuCYIB/ErAmmyaet
 PT/P2dco+yEnL47qjZaP4UEwThjnmbjPddUIzbm/ktQvUNB5gxk0A/vEFjqxbNnUsxlzFl5Mwwj
 J2IFY0W4EFhWkLPaqJg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

Probe accesses registers through saul_base. Remove the unused
device-context base member and its assignment.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 1 -
 drivers/crypto/sa2ul.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 3bf46a8b0621..98075f9ffeb2 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2275,7 +2275,6 @@ static int sa_ul_probe(struct platform_device *pdev)
 	sa_k3_dev = dev;
 	dev_data->dev = dev;
 	dev_data->pdev = pdev;
-	dev_data->base = saul_base;
 	platform_set_drvdata(pdev, dev_data);
 	dev_set_drvdata(sa_k3_dev, dev_data);
 
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 223ea5290fd2..6d5a3e65dae7 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -175,7 +175,6 @@ struct sa_match_data;
 
 /**
  * struct sa_crypto_data - Crypto driver instance data
- * @base: Base address of the register space
  * @soc_data: Pointer to SoC specific data
  * @pdev: Platform device pointer
  * @sc_pool: security context pool
@@ -191,7 +190,6 @@ struct sa_match_data;
  * @dma_tx: Pointer to DMA TX channel
  */
 struct sa_crypto_data {
-	void __iomem *base;
 	const struct sa_match_data *match_data;
 	struct platform_device	*pdev;
 	struct dma_pool		*sc_pool;

-- 
2.43.0

