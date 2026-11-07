Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063448;
	b=e+pib1IkxCW4qIsWVuWaUnFKN2U5q+lU5k1hS0CwyP3iww2ZdSmy7yJokwqC+Maaxyj/
	 /T3OHghagr/XkA43Jz6oXZTmggXoirx2O6NcUeBCvybBx6ITwHFDXZUSQsz5MdTgS6vkq
	 Um5YhuCwXskYM7KQvSzsWEEQSHVpzMBOily9AQqbl66e8rAwb96LP0NIqg0sha0HViksI
	 oX2o52wTVU+bl8LTIc9ZvOzdfLjpP4qWUeUX5wTgNDTtwUiJLeaPGIWo6qe1hRdQaON9l
	 rvbWYVY0nwGcL2x8QePNpBReAc7CZyczacyXV0NlYhjzyojuvAUleAaVNElAxIKmTeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063448;
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
	bh=GgvVrRV2Iyqaj9/GGXypEoyQSNl6IcLR0LhkmGb5/cQ=;
	b=cebtJCxBD3or/UXKaT75JzvBTvKLDVLVzOQln6SXZGewKhENaEeVrZog1//sZol5FC0Q
	 MxlvNsoafU8cF/FzmAjBxvuGolLN70Hpp6fT5OuE8Sd9Dnp9dpVyn1MxdEXHiNgUdm/lM
	 7iYrAYH3ShVOrz1lE8o34cUNft3AxDOkKKuX7BVYIy6Rva+jJhufS091bjSBDMHAAMr28
	 oYBr/fB5jkRxVZ41mewoSWnHBEdKMnzcyRKM7qOc7jHG0JB5Gi2QvFq77CI6D1Iawn0Hb
	 kSwfYoeLKpTnlYss7Ij1Apwn1OB4tupVnMTqwqFbJabjaVuknTT/TfPBuj8NZmvTtMQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=LBA+TxYa;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=lHrzRMoM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A377260A262B;
	Sat,  7 Nov 2026 14:57:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A377260A262B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=LBA+TxYa;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=lHrzRMoM
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BvvaT3543981;
	Sat, 7 Nov 2026 08:57:25 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=GgvVrRV2Iyqaj9/GGXypEoyQSNl6IcLR0LhkmGb5/
	cQ=; b=LBA+TxYacf3lBUXMVAdfww8qbvUUtFSs0WrqVrGcFCkvbWtg+xKXectIG
	cSm43ccUCgUW8R1bVz6+7tUL9amOZiIQRvQBaEyFdnPyiS4x6XjTu3P1Vi4psa9R
	6ADyySLpE81uKibgoMEY00Zoh/6jUsDfHxQKy4ZZnawF7jN5HcSeyGlBK0b7Z4Pa
	zJ7ZD76KT8tALLQ+TstuBd2mGcKTUBqQ1WeGym73APbcuYG4rudL9eE0mNKxqrXN
	h4fimbB3OH+LeljqKygzaCNxVJgOnUeNjRi7kzBHfWO4LW3iEO44fwmvSV3qS79d
	FSNOssVjNzDuFYI6B4FtDRHZQ7lzQ==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010056.outbound.protection.outlook.com [40.93.198.56])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmhpn7-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:25 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pr3nb8qXCDwpLgUsp63OJPXBfQakGhDh9W5Dmn2BMU6ZA31PxZnUjd+iXs5yDS3hrbOeRQzLKwLOlC1U+tlFjTRpNHeuTUUz6HsX0u4zvkJTirMoYMtjVsRX1kCLRbtjS5VbsaxAfjUsVaGNb8G5J5bWI5LpeTp4ePsfLYJToHdHzA6fDzBI9Lo7Oy6MCw52/HOMWD/YObmdoqi57pvzS2X6BSHho8tAibgYxw3ALiQGWEJtpWLBvozieUiLpQjJAz0xDBCZE/oELt3cRjwDIJ+bGQED2sgaBeyfrkdKUJQNQ6S25BbB8r1ZaAG8pWO/7mEhlta/CjX3g6fMGWvKkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GgvVrRV2Iyqaj9/GGXypEoyQSNl6IcLR0LhkmGb5/cQ=;
 b=WU8Luek3FZDxDiWZ2FK10aTmrQuayBHxUb48k/heqvjnS8V0jJ7qrYCws+sOSjeiC6Krnttco/G7A2TLjyfJA4C5PszZ5wCw++0wL5kt2wrjze1RTg8ozFSH2mWhE/VxR2PE3oPr2wzSPPrCVKKOhp68f9mid5o6/vUiLp+Wj2NNv6A6RqimmKWAdNABkM940U1fbNU4q2EArwG3mU72JXh5Y2RkjbNpHAhFjULIKAK0fY97GyhUbgzmQ3JgZ4UEhIc4Y/lxfMBmskF0RsViGc+kO0GliOEhIEm5oWueE/fiXGpsRbCeNtqgZsKnrZSw4nsC6mCrzO76dJYuWXfO2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GgvVrRV2Iyqaj9/GGXypEoyQSNl6IcLR0LhkmGb5/cQ=;
 b=lHrzRMoMY44deLDc7nRwLmgAioHV+2gWAnU9qxh6VoVWnMf9vjOZJuffGEIUCyJcA3ST6erwQM0rNhNV+1+23fcISukDCr2fyxMNIFXM8SoRKv0SWTHk36VUO8VuYrH4DiTXt6GnsLv8NPbt0wSKO5E6dV+Us4G9yWrphb7BYEw=
Received: from PH7P220CA0151.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:33b::11)
 by LV1PR10MB161780.namprd10.prod.outlook.com (2603:10b6:408:513::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 14:57:19 +0000
Received: from BY1PEPF0002695D.namprd05.prod.outlook.com
 (2603:10b6:510:33b:cafe::6a) by PH7P220CA0151.outlook.office365.com
 (2603:10b6:510:33b::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:19 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BY1PEPF0002695D.mail.protection.outlook.com (10.167.244.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 14:57:17 +0000
Received: from DFLE202.ent.ti.com (10.64.6.60) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:50 -0600
Received: from DFLE212.ent.ti.com (10.64.6.70) by DFLE202.ent.ti.com
 (10.64.6.60) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:56:50 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:56:50 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7EumQ3190615;
	Sat, 7 Nov 2026 08:56:49 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 04/15] crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
Date: Sat, 7 Nov 2026 20:26:07 +0530
Message-ID: <20261107145618.2349562-5-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107145618.2349562-1-t-pratham@ti.com>
References: <20261107145618.2349562-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BY1PEPF0002695D:EE_|LV1PR10MB161780:EE_
X-MS-Office365-Filtering-Correlation-Id: 0415c2a0-736b-4828-49fb-08df3cdf6afc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|23010399003|18002099003|22082099003|261026121527099003|56012099006|261009223027099003|261102123227099003|261022105027099003|261021123027099003|261021121427099003|261028144727099003|261026140227099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	/gStjyhE3c/TnW0lhibq1AVW4+BrmZmxeSflav+GvvlJ1RqBTxE0KX+ukRnAXqvdf0VTilxMePy7bi2mWFG4jCJIGM+0zy+drOgFXJgS4kOCC/D9uSCioB+s0bdsbEyqtDWgRzsFkL+zyg1edz9pnKyOE63fC21Lyjn8j9FPBtFDQSGxZ1FW/ZBQSfjNxohyvhmDmH8SwoYAeRHZqnnMEe40NelZEe5J34yu1qvkzT5cF2DadS63M6LqdvdwgNh56zC7JpLAsHsqJDMHM3ycU24OZqG8H7a8RfhH0Sl/ydYDA+Hmb38QWaeHgNLg8KV6puPuWJGWcIpUN/Buy8QyNsKG2CPEKCcf4E2hbmH3XtGSPohG+dZs+unJYcKejvJE65wg0ddGL2hic1pSWFrjTtxQImOTd6g25FpmEJDZRvO9b2KNzsHNyrqnCnsuY+ShnMq+gyKGY+1FBhKqe6ZP2yLWNe81vlqsId3+auJIlOLKk0wxTRoN0A3vlE2vz45HEeT4MR7Qd4vmIztAhKkhn6mC3RMAA9fQJshLHse56WgSNUbAaSccxaJI+6CH/SsEWrikirN42WzO9vOiZuRnciHvbTB4i9zblGecwYsW7fRnl93sYS/D5682fMfeEtseexuRpezFRa8VfUId4SwTtueI+pucN1oaSjkumBO1sFd+JK1TkUCMgv28YIfiXhjz3EvMfTKSAjeurmXlk1S5DQ==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(23010399003)(18002099003)(22082099003)(261026121527099003)(56012099006)(261009223027099003)(261102123227099003)(261022105027099003)(261021123027099003)(261021121427099003)(261028144727099003)(261026140227099003)(10067099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	JFJ8MO30mnQCzHspqowpPPkZZZ+S1usX90yZ3j74Sv4gK0snjWHSJNvaTqmgI31jXQpJb7YI+oD9Se14GVtbxT2VY6x/tumM2mmompUNxuRPBGUII7qLUO34WeYA+Hwu3GIXEYEZREuejQjq9edajKKOI6y07TZQcFCvbxVyhGcqC8t7pKeol5iO7Mdqy8LgIcdE820Ebj+VSjtX0iuTQ5b5OHa+PLcbBfSwSXOHdYgRm+A+s6FXRacWeAwJm3sumdjMA6KzefOQ8TaI8ayNrcDros6VCPXyU8pYJDbOyOFdsOYJkqcI26eUnZfApiTagQDX044G0ojrcSiTfP/zUYYbIXkGVOSFQC/BPSbUPxVHsxv80laniMtG/T4loGsA29jVaCPyQ8uHLTWb9xh8gX/a0JLfXbpaWTL8FZCWcPgnyj+SyDDheBooh8ILiDwE
X-Exchange-RoutingPolicyChecked:
	UMFW/BxvO7U/os/kgbOhsLfm5o8W0fNjNfOorWlOw9Ay/Jc/G7hxd4BDmJm7b2EgE2vRn3upZkFGgbIcJtWDnlJR/ROJ2Dv4wJbwgP/SO+xm1SacJQZcC9iyA/3XAYop1EEfnQ5ixyvmwcjJk8SFbs5/i/6wPTLD12++M4BHfe+C+FAVeyGhwsKi72THjYuROKhUibKO9uL7NpHN+P23PyIhmDqKIDf2cLz13fxKBG/rlE2VhSudLNUxyV5K0wjWcchaQjOKXX//J2L3ffpMT3Cg/ZoiyjGaRU51CL1XPFo1J4C9/gn121ymI5mSoDwFZxNAAfSwI+SP8xnEqF4TOw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:17.8862
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0415c2a0-736b-4828-49fb-08df3cdf6afc
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BY1PEPF0002695D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR10MB161780
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef3c55 cx=c_pps
 a=8eopZEidgIdRxOfdJNpAuQ==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=0ECTI8PlQN0MObDprVQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX/+hO3CyD7+tl
 cyVwaoONraVcJv/L9xVUFjdp7rnw/8Oe+bM99JAAyETaWvY+Sj4jAe7PUUhlpial/rCAfcHDNON
 P2J9VTnqWIpdzWdndD1AhjivK3hhizsAKLsYfvT2I0HNBu7AG+Jj3P2IuErt305I2u9CbAkleX6
 KSpH+DcKh4JRcxH+bznya7Nt9oCUGnkSWhNTdTDPLdtmaxT2P0LigCewVFmWYGP1dj6rjacwl5C
 AZROT2z/B70Z/sElSeyb1a0opYcL11XJmyo/HC3MsRzp28eyeKTPc9rtyQRoieCH+ojUHpTdV+d
 tpF2ZnZP3anYsNHPlxaz3a8MpPMDEMLSQzfJ8/TmkvuRRruFJX8JhsqdaK0vZ39tXB9TYI9ltAS
 jNvFR5q02b1GuPi6ub5s836RBO30bEAYMVA51/P3q+FuQzcULgAMDyS4smFYCvjhTNY/OTT1mRe
 W4zteQZ3MCXOmgTGozg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX66JbuH/jefwh
 Htvy1w702Z8llu29Kj+nvmz8dP/z/RU4W3yaxE74NpHs6gxcANwQ2bQghbx1PLre+IcO3i1TUZ0
 h1D666d9p2HeSnN+ty4sC3IhPsoZYcI=
X-Proofpoint-ORIG-GUID: Q4Tw5g6Ch0XDVTcNQVuI-zkjG2BgFoQZ
X-Proofpoint-GUID: Q4Tw5g6Ch0XDVTcNQVuI-zkjG2BgFoQZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

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
 drivers/crypto/ti/dthev2-aes.c    | 80 +++++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.c | 50 +++++++++++++++++--
 drivers/crypto/ti/dthev2-common.h | 52 ++++++++++++++++++--
 3 files changed, 149 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 4fdd24ee91637..44b1cf431939b 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -110,13 +110,13 @@ enum aes_ctrl_mode_masks {
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 
-	if (!dev_data)
+	ctx->dev = dthe_get_dev();
+	if (!ctx->dev)
 		return -ENODEV;
 
-	ctx->dev_data = dev_data;
 	ctx->keylen = 0;
+	ctx->skcipher_fb = NULL;
 
 	return 0;
 }
@@ -124,20 +124,19 @@ static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
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
 
@@ -148,7 +147,9 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	crypto_free_sync_skcipher(ctx->skcipher_fb);
+	if (ctx->skcipher_fb)
+		crypto_free_sync_skcipher(ctx->skcipher_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
@@ -225,7 +226,7 @@ static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
 				  struct dthe_aes_req_ctx *rctx,
 				  u32 *iv_in)
 {
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 	void __iomem *aes_base_reg = dev_data->regs + DTHE_P_AES_BASE;
 	u32 ctrl_val = 0;
 
@@ -337,8 +338,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = container_of(areq, struct skcipher_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(crypto_skcipher_reqtfm(req));
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
 	struct dthe_aes_req_ctx *rctx = skcipher_request_ctx(req);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
 	struct scatterlist *src = req->src;
@@ -520,14 +521,17 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
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
@@ -553,8 +557,18 @@ static int dthe_aes_crypt(struct skcipher_request *req)
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
@@ -576,19 +590,18 @@ static int dthe_aes_decrypt(struct skcipher_request *req)
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
 
@@ -600,6 +613,7 @@ static void dthe_aead_exit_tfm(struct crypto_aead *tfm)
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 
 	crypto_free_sync_aead(ctx->aead_fb);
+	dthe_put_dev(ctx->dev);
 }
 
 /**
@@ -711,9 +725,9 @@ static struct scatterlist *dthe_aead_prep_crypt(struct scatterlist *sg,
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
@@ -734,11 +748,12 @@ static int dthe_aead_read_tag(struct dthe_tfm_ctx *ctx, u32 *tag)
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
 
@@ -753,12 +768,13 @@ static int dthe_aead_enc_get_tag(struct aead_request *req)
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
 
@@ -859,7 +875,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	struct aead_request *req = container_of(areq, struct aead_request, base);
 	struct dthe_tfm_ctx *ctx = crypto_aead_ctx(crypto_aead_reqtfm(req));
 	struct dthe_aes_req_ctx *rctx = aead_request_ctx(req);
-	struct dthe_data *dev_data = dthe_get_dev(ctx);
+	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int cryptlen = req->cryptlen;
 	unsigned int assoclen = req->assoclen;
@@ -1130,6 +1146,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	local_bh_disable();
 	crypto_finalize_aead_request(engine, req, ret);
 	local_bh_enable();
+	dthe_put_drvdata(dev_data);
 	return 0;
 }
 
@@ -1137,10 +1154,11 @@ static int dthe_aead_crypt(struct aead_request *req)
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
@@ -1191,8 +1209,18 @@ static int dthe_aead_crypt(struct aead_request *req)
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
@@ -1214,6 +1242,7 @@ static int dthe_aead_decrypt(struct aead_request *req)
 static struct skcipher_engine_alg cipher_algs[] = {
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ecb_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
@@ -1236,6 +1265,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 	}, /* ECB AES */
 	{
 		.base.init			= dthe_cipher_init_tfm,
+		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_cbc_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
 		.base.decrypt			= dthe_aes_decrypt,
diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index 911e6bbe4d241..cd4626ed4c39a 100644
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
 	ret = dthe_dma_init(dev_data);
 	if (ret)
 		return ret;
@@ -184,6 +219,7 @@ static int dthe_probe(struct platform_device *pdev)
 probe_register_algs_err:
 	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
+	platform_set_drvdata(pdev, NULL);
 	spin_unlock_bh(&dthe_dev_list.lock);
 probe_engine_start_err:
 	crypto_engine_exit(dev_data->engine);
@@ -201,10 +237,14 @@ static void dthe_remove(struct platform_device *pdev)
 
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

