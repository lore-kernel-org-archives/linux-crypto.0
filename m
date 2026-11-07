Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067663;
	b=OGoKA2EJHlrUkFV+vX8IlDD7iBrcJ5EpL7KTNc+IeHnEE7iiYjLoNtNm2CKrAota489H
	 X+Q1Ii8GGpTF96uGYG57IlptdL3k2gwLSdSy0xThd/cbbOOsZlvHZ7s+wiycldocuQM0G
	 77BB1D6TnRckX9i3mHbKk9BejdWw1BcmAxsQeck0Rd4CE3/qx8XtOybv4KLdhb5e7P7VH
	 WfCdEcgcVUC5nfhry6PN42jy4sIg1MMbk2UuuZxL2m9Yf/l95ZGEG8csxu+denvkFXkrV
	 hqiUl7/1EAWhPJ/zdpViioy1Z2PZjQlSuaXj9gtrELrcxtYSxnC3HtZ3jnvIOUEflaw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067663;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-EOPAttributedMessage:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-OriginatorOrg:X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:
	 X-Authority-Analysis:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=UigGsBkFBMyYnY67XjdOcsG1WuPeMcR6RdZnuKckhoA=;
	b=J63FFuKP+32Uzyp2eOdMu2D5Sp9Snbz5WFXiM/Rx1bpBQdnGZD84I+9v04JQFkKJi4kW
	 FTo7kj1hvo09cdXUplYBuegbnK5ged6MReLZYLoEGejgZhty05vJPe1UOXZDTumJK0hRg
	 vtWKIB2NKqJzyl+TKP56QsC/icd1Nxw2TQ5IMSuM85BPkBJ1aBxFkgj6PydRdKyHlzHuK
	 0Jr6ad5o1OmVdQidAe8UOgRrDAF7EE3odhoIiY+aHfO5+bFkcM0CgRDByokVsxPYkDq1a
	 u7lasfSX2Akd2Smow4hAYF1pkC2kLVdZp0STZI/vGEcyxC+r6hPabaoD3zZeWJZHVGg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=dgQ7G9pH;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=W81gIneA;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75956606D831;
	Sat,  7 Nov 2026 16:07:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75956606D831
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=dgQ7G9pH;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=W81gIneA
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7F09pY3867284;
	Sat, 7 Nov 2026 10:07:39 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=UigGsBkFBMyYnY67XjdOcsG1WuPeMcR6RdZnuKckh
	oA=; b=dgQ7G9pHrw00YOXBFsGBGHxXdX639OvRlPhhGL87wbrdG18oqgrUJVQCV
	AD1ptAWw0jdX8UpyJFrm10yNnV40Q20D/A0GSo1MsHZQZAqkKW3IlTnAqm3ZYQkk
	cXuR+y7wrV/QbCoe+hsJBebgQeIag/zDNFtF4KXl3g7ZM0knV+1vVbtjK7gTZxrF
	C4Jugu+AYa7kcQsHyPUOdT4w7aY0b4UpAna6y7NM3TBv0zwNJlzg8g4CavHqiNc4
	a5T4T0zPAQgPT3cqV7qJyCwWZ6FuHX5o6MZ3h5qSG8RJKcW2IG3nwBvdfcP+IegH
	HZKVFvNYqCmbiivGKNS9sjmJ2jxnw==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012050.outbound.protection.outlook.com [52.101.43.50])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmj07h-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:39 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ktZbk6IesFk4YU7/1AVn08WM7xqHGMKV79KegwQPY3iJ5EtKXKEfDdGw2DLbOcCoJugYuXAy3R0Xj4k9LQsSQ3S8kO4slj2iCz9lR4fnzal/dDru1xArUxFmmrIU7BNKgO/Dz/sGBsy6j0qxyomSpggPV8KJ2jUBzKLFoh+/ZgxD5yhOGiwKoZ05FU+sQ3VRciLC7WQRiS2PgQ7zwN0rh2hpYIY8YACe0Tj5D280N7ymhB4aqb2KQTvX5JizfJXaBr2NdSQ9QsjHbVTUZ3dW+gBvWctqIZFMftBCGxNMSU/+tcwqUPzmkre7xkPXjIpLJgDD/fJJNgCLyON83bWz4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UigGsBkFBMyYnY67XjdOcsG1WuPeMcR6RdZnuKckhoA=;
 b=Tugn6YHZp7BF49g4SfXiBAjAvZm14ES6zpm/uglL/IP2RLQ/TRjBIKOU8ZMaWZjDqiMmYzxRkLZDRSF/oC46Rvw79/wKUFtDSH1VPhefmarpH1Ef/vkaVynZhIVRr+NGnsT5uaz9CPRD41ajvsODeyQJq3nDBebon/h0ZzYVF76/+ZesShK5/A4iAHW+IFrbsmelwE9BipKmD+vCaieWLhsxuObsgTY3YfElVKOcOcjyizVSvldIpFIsPGDeV/9moKe3G814AFMaM6gzbWujdazJyi1Q4t5fxIpolMuIkb3uvxUIeGg+QByEHH55sTXRgrMuj0+fuO5gPZSAEKbUyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UigGsBkFBMyYnY67XjdOcsG1WuPeMcR6RdZnuKckhoA=;
 b=W81gIneAcYAoSJdvEeAEKDjqXD6ZQGCGsLQFXAv9g8+WrCNZF81b3bPJLH826jIE7TVhsPj0+HWTpYhFzDo097fl0JNdwGQnbu+SDR2IQIUMmOF24luwkfFSLqkyqq76kZGigz6iESrYs4FXtvYbw+OzH+m3zQX9e97iRDD550M=
Received: from CH0PR03CA0215.namprd03.prod.outlook.com (2603:10b6:610:e7::10)
 by LV8PR10MB7847.namprd10.prod.outlook.com (2603:10b6:408:1ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Sat, 7 Nov
 2026 16:07:36 +0000
Received: from BL2PEPF000352CD.namprd02.prod.outlook.com
 (2603:10b6:610:e7:cafe::18) by CH0PR03CA0215.outlook.office365.com
 (2603:10b6:610:e7::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:35 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL2PEPF000352CD.mail.protection.outlook.com (10.167.249.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:33 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:03 -0600
Received: from DFLE213.ent.ti.com (10.64.6.71) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:03 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:03 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G72Ht277066;
	Sat, 7 Nov 2026 10:07:02 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 06/15] crypto: ti - Align buffers to cacheline for DMA
Date: Sat, 7 Nov 2026 21:36:21 +0530
Message-ID: <20261107160631.2592763-7-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107160631.2592763-1-t-pratham@ti.com>
References: <20261107160631.2592763-1-t-pratham@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CD:EE_|LV8PR10MB7847:EE_
X-MS-Office365-Filtering-Correlation-Id: 992970e4-b539-460e-6330-08df3ce93be0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|36860700016|82310400026|261026121527099003|261026140227099003|261009223027099003|261022075727099003|261022105027099003|56012099006|261021123027099003|261021121427099003|261102123227099003|261028144727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	PHO4Tl2dQOVIPhFZg0FFO92lkNTQ49Az8dZuL3R5K7fS7jqAYWgocXNwhqD4WYbX/+DJqSUj9BZLTd/Mfgh9wfTa92ey7w5+P78ZeJe4d6eLWbf9QfrbkPLg1WYyw+uba6tDeHcXqTbChQ5LFxhGCn3rHYmvbXnQBfneUaKuPV1w+k4EVPAuoHsiOGlhr2sZwNi0848DJdbVJ56IQKp6NieOoLng9oUfQJvMCCY8juEHW5A/W/93dxxK38yuH2SUQp705W1sCF0cnOpxKjq9lrJ5n3tZnH2MVsFWFZZ1PgaE72+FqKBx+yrSqrlyToWEA6xgc0vwBES56gSFI8PJffEaVFuR38GutF+yfhCmZo+NFifIAZM8XMXGgNTPd5ddeqdA7BBc2M0BOO8P4Y4pB2Tbd5wsAQgA/e9kuqI1BwavXZL5hGAyqhmS4Z6aeLa0f7tu84kol03wEs6mUN9e/pOxRQ1A7hb3fPMHCUgkeJKL1FrvCbU7Vl9WZzfr1u5evgIIptblDpS6QuhSpnam1KGV62OSou1G/OtVW/iD8e6ocPNFQ/PcAp+itHs5QoMzAGmeWNZo0F6Zx+7/PIu6huuB5LIp3ZoTygPg7Gmsu3flTN416Bw8c3pn0c6FbIp81KXn+IuHeXP5MH2LiXDlNNXRFwFZTEajEmaUV7BK8cILgB77sShw0JB+qrZZgb+QbFRllBNXACzD6jTJUs+S/Q==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(36860700016)(82310400026)(261026121527099003)(261026140227099003)(261009223027099003)(261022075727099003)(261022105027099003)(56012099006)(261021123027099003)(261021121427099003)(261102123227099003)(261028144727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PNAJM5w2gQFDlB4zackkWw0zwFYm4iK03zVIdvRhU/3ANdhClKokIvCS3rJilihh53VVbMd2fsoXM/eHMGnyAvZEgtQHFKMSZnrdPiYoHnODYTbo1OFs1p6mPxJwqTi1Zmvt2b6e05tOeaIm2dRc/yfOKYl3rO75hbfh4MbAGUpz/y28F9oHj3LU2TxqG3EirHfMF+RE/90DyIYpW7kmWuPfPcP/LZhFvYWKrTntHjfyjfLXbgl62Fo3ztzJ30Vhgr0pK8I94FpsG9nCOKddqde+5WzjXiiMD9A6WcHH+Q16zE8VJyj+iVLt3AmNXXTDlZZenIUeWeLCfT6JlxIxCq9pW0ehPmN25NwMGwJCsvGQh4p7MBvqoS7UZ1dnxvFA/MpovgYXtVDy0S3cTaYprRGeLb6UCVNNnHfHsIFEy8GxPtggi4FwtEIbP6Yjhkau
X-Exchange-RoutingPolicyChecked:
	I6vXHk7iVMUFMyRazGdQkd6sk0t18nqFphyhdIZLx5vI/C8ABJFuo0KpbInxYDPuKlXQIaWq6zsNNmLwGGfkgN09SrE5EQTpv1oNGoRb1SBLP21oTr4wBRh0DHuceteF8CrTvSOJR91fxGlcLJfRSV9vccnGR3AbjfsE2UYPEnpm8KP4ic2RaqZynqUBQ0r+Wc159PNn7YynQ2eCCPNpja5tZf6b8sb8/yPgN3pAN4XWTyoS/X2ZSj6a93c/Z8EcrLosa6CxIJZUkdwl105r82lf1E5uYBW2AuqP/kQrLQFul2A6+C/b3HB82fo4hzk0OQpmDbmrLFK/7Bly/p+B5A==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:33.8378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 992970e4-b539-460e-6330-08df3ce93be0
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CD.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7847
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef4ccb cx=c_pps
 a=QL/sESuk+SKO76CEZ3+3jA==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=dBz7rOeTUn-ILHDwuGIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfX7uZYbq9pEKgt
 Hhw/GEjTWBvs6pUoqjA2FHn1pVUqUP0XsXqJz673tst5zXoXnjJc4jrGEaPp60sukuH2jBYIZPw
 weXC27xmIfas0xe3VrxYJLqa8g8B1RfeNGO5+lmgKz60LrEE0Ka8iapLmgJBCGPh8bHyZeQHpZj
 pvm6dtf7YLUqMhzgD1NE/vazF+ZLkCIrL0+q+/xLhGOLulykiSQQt65l8CymSw5bGZvIkR8lQvv
 9iUgsAi7xcpnMr2xGAsOj3LEg7fxIYcpEwA2246c0pLyi/TMJeLjnU4nhwi7iElw6RZ2/eegtpx
 eCtbzg5nENLBmIIhWJy4bhOTpYuetjw82Jbvzk0/a0dxxD60JLw7BRx+42kX0dr0grDWL4NccXw
 Cj1nIZNbFKECUUQBVJwm1tynhvSk4RhMtdS0XbBGLMVXVWzT33hRqoEG7D7iwlox7/JwFaDWkCD
 eSaqsOh/MD1uz4nCjOQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfX7YHpJEd8fuzV
 eSdObmSF86ElpuS2l3fzjlmz/xSUI5el3nBV4psmsCgznSj9slSAey+zNLmqlOKGqj9lhKwyF0w
 LxWN3wtxHv9xqE20qxUSmqzmX0TQkEw=
X-Proofpoint-ORIG-GUID: Q56-83BVqmX0I8_8abYxnHqtJKLs4hO4
X-Proofpoint-GUID: Q56-83BVqmX0I8_8abYxnHqtJKLs4hO4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070064

Align padding buffer which are DMA mapped to cache line to avoid any
potential cache coherence problem. Add DMA padding to reqctx and use
req_ctx_dma helpers instead of req_ctx.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 46 +++++++++++++++++--------------
 drivers/crypto/ti/dthev2-common.h |  2 ++
 2 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index b801f9fdcb87b..1a37150496ae8 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -298,7 +298,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 static int dthe_aes_do_fallback(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->skcipher_fb);
 
@@ -314,7 +314,7 @@ static int dthe_aes_do_fallback(struct skcipher_request *req)
 static void dthe_aes_dma_in_callback(void *data)
 {
 	struct skcipher_request *req = (struct skcipher_request *)data;
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	complete(&rctx->aes_compl);
 }
@@ -323,7 +323,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
@@ -515,7 +515,7 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 static int dthe_aes_crypt(struct skcipher_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	int ret;
@@ -560,7 +560,7 @@ static int dthe_aes_crypt(struct skcipher_request *req)
 
 static int dthe_aes_encrypt(struct skcipher_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	rctx->enc = 1;
 	return dthe_aes_crypt(req);
@@ -568,7 +568,7 @@ static int dthe_aes_encrypt(struct skcipher_request *req)
 
 static int dthe_aes_decrypt(struct skcipher_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx_dma(req);
 
 	rctx->enc = 0;
 	return dthe_aes_crypt(req);
@@ -735,7 +735,7 @@ static int dthe_aead_read_tag(struct dthe_aes_req_ctx *rctx, u32 *tag)
 static int dthe_aead_enc_get_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag[AES_BLOCK_WORDS];
 	int nents;
 	int ret;
@@ -755,7 +755,7 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
 static int dthe_aead_dec_verify_tag(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	u32 tag_out[AES_BLOCK_WORDS];
 	u32 tag_in[AES_BLOCK_WORDS];
 	int nents;
@@ -836,7 +836,7 @@ static int dthe_aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 static int dthe_aead_do_fallback(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	SYNC_AEAD_REQUEST_ON_STACK(subreq, ctx->aead_fb);
 
@@ -852,7 +852,7 @@ static int dthe_aead_do_fallback(struct aead_request *req)
 static void dthe_aead_dma_in_callback(void *data)
 {
 	struct aead_request *req = (struct aead_request *)data;
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	complete(&rctx->aes_compl);
 }
@@ -861,7 +861,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 {
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
@@ -1140,7 +1140,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 static int dthe_aead_crypt(struct aead_request *req)
 {
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 	struct dthe_data *dev_data;
 	struct crypto_engine *engine;
 	unsigned int cryptlen = req->cryptlen;
@@ -1212,7 +1212,7 @@ static int dthe_aead_crypt(struct aead_request *req)
 
 static int dthe_aead_encrypt(struct aead_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	rctx->enc = 1;
 	return dthe_aead_crypt(req);
@@ -1220,7 +1220,7 @@ static int dthe_aead_encrypt(struct aead_request *req)
 
 static int dthe_aead_decrypt(struct aead_request *req)
 {
-	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
+	struct dthe_aes_req_ctx *rctx = aead_request_ctx_dma(req);
 
 	rctx->enc = 0;
 	return dthe_aead_crypt(req);
@@ -1246,7 +1246,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1271,7 +1272,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1296,7 +1298,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1321,7 +1324,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aes_run,
@@ -1349,7 +1353,8 @@ static struct aead_engine_alg aead_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aead_run,
@@ -1374,7 +1379,8 @@ static struct aead_engine_alg aead_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_blocksize		= 1,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
-			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx),
+			.cra_reqsize		= sizeof(struct dthe_aes_req_ctx) +
+						  CRYPTO_DMA_PADDING,
 			.cra_module		= THIS_MODULE,
 		},
 		.op.do_one_request = dthe_aead_run,
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index 03a0b426041ac..cc20538ad6f36 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -114,7 +114,9 @@ struct dthe_tfm_ctx {
  */
 struct dthe_aes_req_ctx {
 	int enc;
+	__dma_from_device_group_begin();
 	u8 padding[2 * AES_BLOCK_SIZE];
+	__dma_from_device_group_end();
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

