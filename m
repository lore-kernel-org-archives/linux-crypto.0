Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794063437;
	b=09u18mCS2Iw4p+AeDszsEFgjq6SVFsALRe1dJkLAaQik9BJogI9mXetu+VrlO2L2Xgko
	 /nnwfj11tc1RkxASFiPaq0LtC7JkFSjBu1u2q7kBqxI2cF+076/VUddWjGxz+8y0bLjn/
	 vqi+1gcnQUMcre24lUGeaNkaCBgdMHwoEHoojRcEuvtILdZL4eCFpsNQxZWedh/mF/nb0
	 v+d0+waawvEFVD/knr6vGfopXx7T9Zkbe3Pd90M+hNhgTRlal8f/HIeYGzsIQRfac1WAO
	 YARh8nvkXhHC5MgZtiaUQuLD2ymg/ia4z5xWKsp3djtVwr0Ur1CYdC43mIAq2yhvnIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063437;
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
	bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
	b=EnWtomj3oGFgYgdSFxx74ETsF3iqBTtvWXmYDr/fCYUHRjdZCnXesL259LlVu0hJBO7B
	 sSBC9cJuzo3pjAvvc7+IbNInD9/3BzpUDdwQkNYX73ugwuuPD26XEWGwLWb4XuDiYgCey
	 au0P9zDYAUKSC96XjGoeaomURKiHLP9cvzyhN8rhsLpIEuOmZPWGEbTwfKYFNUI6I9Lm0
	 3Sb9GqR0/wMgjNkT0FTa14K0A3i3oaU/YPS4aAl2eQf9ek4l+m9A3Nwxu+ldULgb10MFF
	 2/O3Zjs2GQGX0M2vudgN/N4j+zMGFHB/Vujcno/TrYlxLpi3aOHr6NRRi8HniJXtv9Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=dwWX5r3o;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=RuJnKxo7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3BD6083628;
	Sat,  7 Nov 2026 14:57:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C3BD6083628
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=dwWX5r3o;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=RuJnKxo7
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7BwDOI3545708;
	Sat, 7 Nov 2026 08:57:13 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367J
	Q0=; b=dwWX5r3oYHHvgLNRPm8t1TVHOqcH1/u4Mh+5qzU5uUkrsEpEFOfx7ZWWk
	UTIymtflnUKdK4fuypc5DXwthx9v2DL24peYjthJpALhkK5xwx7wywbF8mLVWeQV
	KWShOMrhaQHPsyjCTWRgWDBo85Ce/vuLi0WYM1FW7+JC/fbfxNrnj9WBaCzooNBF
	mP1WMXDtkXdkFmz/LvfvfhekJCHUAPnoyqCV2VXZ5Jpn717lWEmrwMKzebhgJtJ1
	2TtWGABeq7xj6HnAGzk++Vk7GdFyVhMYDFnPdY4B1csYc1N1fKlIMVGZwK8LOA89
	mJ2ftrfjaaD9Uy7X/jNwc4c22BilQ==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010065.outbound.protection.outlook.com [40.93.198.65])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmhpmd-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 08:57:13 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XAMBQ89ztUH2jXTJerHkUy2mCCyFrw+k0Qk08lOW+9lAFhJwp0meNEHQF+bNzaSHXPB5O6xq+kaxpliaTw3rYpShyqbBhiY+Sq3h9XgrKuBHTcZDtctFWzEjvAIKgi91Y6Bgh+n0UCzeX91q5O12LeAQv2SVNW2vEQktruisj2efvOgnuubJgq9nGhToRx1o8CYc7xsKgLAAcTbuiff2LcWh0WZSPD6f0eVegmvsTD0VCyMIMsuGtQqYowybJIV57cDSqBfb2Ti2aYtX3VIs/igapi7OH6KdwKPaNsFI/y6MK8yeKf1JUukjvL+8otOwc/7j3JG+iksFoOY2F2YqDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=f/b2vM4yzQlNvDCja79YzYwvx6Ja5Hu2gl9YeVPW8j9w8MXN/63ujiRrze85dCAX8USni7WH7yxa+FBFeYnCNO2eemFwu9ZWVtIuOKZrbr7IzVC2OlVtB0bftEaPXJpknrXrdImu2b0Dkwm5Nip14uGEznxgb67qLPYcTC1Vuv+gfR086UBVvbLOIkMuVPSyxxZLL/gIiepihsCHyBhBH0kgReTyOL+v2LBR2d7UcSHEM3ukIM/nKdsHQT/HE30Hz2rj86SQexBpZJoYfASAqx3K3KvJEYZIbcu1WMYIQxgsTMd5jhXKKl0nx5Dxem0M2siRP9VazkPXTpAVepjorw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0NmAorX5lMN6twOw6KKl2WtZgSmXV9LsQvUb9367JQ0=;
 b=RuJnKxo7NA0iEhXKSWLSvJ7u5kRTV5+SeHDK8weA1OXJelqyMvBhzN+k49EXZXoZ8+V95hq2cEn3C06msxJjeqGh4qL6JmIWqV8uKHDNCPXE23ntXjTIJ3w9L9kNnDQQfSIzyJSXlisJTbDAc9LKC+/bogy0l5t6HaGuOImZOA0=
Received: from BN9PR03CA0767.namprd03.prod.outlook.com (2603:10b6:408:13a::22)
 by BN0PR10MB5048.namprd10.prod.outlook.com (2603:10b6:408:117::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.11; Sat, 7 Nov
 2026 14:57:09 +0000
Received: from LV8PEPF00000069.namprd03.prod.outlook.com
 (2603:10b6:408:13a:cafe::2) by BN9PR03CA0767.outlook.office365.com
 (2603:10b6:408:13a::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 14:57:09 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 LV8PEPF00000069.mail.protection.outlook.com (10.167.248.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 14:57:08 +0000
Received: from DLEE210.ent.ti.com (157.170.170.112) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:08 -0600
Received: from DLEE207.ent.ti.com (157.170.170.95) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 08:57:08 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 08:57:08 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7Ev6Mu3374009;
	Sat, 7 Nov 2026 08:57:07 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v11 11/15] crypto: ti - Terminate DMA on all error paths in AEAD to clear descriptors
Date: Sat, 7 Nov 2026 20:26:14 +0530
Message-ID: <20261107145618.2349562-12-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000069:EE_|BN0PR10MB5048:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f548414-4b28-404d-cbe8-08df3cdf6595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|261026140227099003|261009223027099003|56012099006|261022105027099003|261021121427099003|261021123027099003|261102123227099003|261028144727099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ugg1DGNqLBXjJGqwCBAfZ+aoUGMBDvrg+ZzUKo8q81F0Co2517K0ceNuyqp2KlDnYVLJ5KQ5dapyLaoYL5blCi+np6+8AAR0lT3/5hQgJHXSBghgpKn4P5zM9eIxBucaJNOe2aFvlizrWTW0bKiZlRIg0fOCsAkvWwDZLmOU/Xer0i8G/W/oVYw47mRrXoVQ7cWMQINQABbjWFtTmNnYfMLXzun3F6HxFkCVfPMVI3LG7sBEoulj4YwrYplPZAAGiU15KnR5G+SJBHhKs0eP6mCvAbq7IM4SO9pLjAnPnX0RQNn9EwMun9FJEYmIYjgTcCoId9qzTCJErhTyFjhQYz3UtKP7yk5KB/oXQk9wfAQVWZtmS/+VjgRnuOv8JzhBXgsCCFpVyUyhJii5P6txxhgwsJj1n0U9/s+hVSFTBCVUrp4lgHwZz1aY7fz4bink4inCIMtuwG/IhZz1+s6pHDy46O3zkkhjjG3ar4wdiqsp+7uMiJAx4bmtL2oyXii9uQzPeqbnKU+0NhTJseWls73nbh8gbP0reKmilyTHT8fLc7ZEDy6QBbhQGcUjRpn2km6fcrzFm92SmovuPzsgjh9L03uRg3IUerrY5ET1BGZfxzTOII9ajRH1ZrG8P9hbE8k05XLyr4B7xasbY2iPeDnwvD/AEu8qPfS4kWMG2MCQlKKvRPw9xA5WN57mE5rCQnQJtuCkppRiyt19/Qrnmw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(261026140227099003)(261009223027099003)(56012099006)(261022105027099003)(261021121427099003)(261021123027099003)(261102123227099003)(261028144727099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BZvzPWhQCmgF7NQ9xjXcBFIT1T3xRBmzABlDKtGXSA9TY6UB3ousaDwAsurtHMZGOxoKLCSAnjluIZclJ7jepJy33nAF+VPs6FcjEx7fhJY9ysjDoE/r9EvABWvdZipL/ibFmeik2MEyIDB5IKEQcdGAkvXx9UBD5/nJ9Fht7+oqSQymHxO/M5Pg7ALYFPDeybkK4AL1lQXvJlbGMPT8AiZp0zbSE94ljZQ8iIO2nknqlgbW7G9J0bb5tE0WAXP7PioPFD+RY9P+P9bxLmuybzAPcJHnCRve52xYgfBHAJtWKmB4ngRudQmWhjhibPTo4/zSu8eZt3X0f6vaa82EpxeyLl0JxQW1WfhguoKhM98rpU14hz6d66PcQ1yfc7vgS+affzVDgHdDrVWyKM6KASIeFIqp/1h9HELhZRNphqArVqRQ/bUFhnnaRn5VRXw1
X-Exchange-RoutingPolicyChecked:
	ncLONkSUrSNJSaTTEW+fy1xJROl/jT5aV3ABLin7OIqHqJr8+vjgncNDqvli7wLbNe1IG0iwNOm9J/8EKtI2xOONs/aeqjJTgDAJfNDMApkM/jiuTi7CTlM9lA+gs28ff2sc75Tnd2SKfTx05JjoABnr0iPTXNYkQBF1Khw3rakUucIULJzbCMCSstey36wNd1f5maiQSQW6cT3XYNQl/o2y+qfwUf8quX34YujJAzFQB0oWugUWxQZmlAr1vkvSZo98Q6pUH7awJBHCSPAQVk0ZjOfGqBOVkuqjpoLgRiuc7VWMQ1n+yiYzxZuhqfKdrjKyIEcjO0xtcgGrBiLvAA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 14:57:08.8369
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f548414-4b28-404d-cbe8-08df3cdf6595
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000069.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5048
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef3c49 cx=c_pps
 a=zsOV+8tnETx+K6VwtxJO8A==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=noPYQ3j_lezN9luSq70A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfX0Epb2Vb7Ilop
 pZRSeyQ/GcsvpkWJYhhTVEpdUcoaUP7txEYndwjl2XcWQiJRLa7TWEzTt4cSiiwbH7aKaMh6qkA
 g6j6vwf7GKNWkp6+eQgBtGtjZ6c/UmxS7XL4c3ASsVnAqPp2ouEe/r8naMZ0vYjNPYg/2Mkra7x
 Ol02ARn/+5eZ3vHaGO9n0d88sjrr9xArFBUsekAz34HC77BcDrbGTskz8NkIfr3yqDjCWDS5m57
 6EUzZm8XXfk6Cvv9A7EXIrImOJT01L/MDIJMj/IkA0aeXNyStAHEY+J47ihxvYEwyUJPQMO9FPz
 Cyir/MaHihl0cwH9rDSkX5Tu5Onnci0sns0d/Py+26AhtdBsGpc4DoKpgP/gHiKejF+uZg4FB8J
 Wl+gfBS4nU8pwiyO5woG2mgNYsDdnvUyccYdUkbl7TZY3FZV58QPzsLbTwcHSszDhMz5Sx9PIFe
 24wdT87WRPIn6cE6dgQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA1OSBTYWx0ZWRfXzzG8VVGkVHMm
 WuxQky0qZACAB7zoFIxQLKK2nEBm0YdimMiWIqaKlrNZSjqjsQq6q/HJfkczoNfMioxESlYDO2V
 WBr2/JPZyvzov/Y9hZobgRXrLldXgVI=
X-Proofpoint-ORIG-GUID: UENokysxVAG8W2oWgTTpXqqCmm2_ieTB
X-Proofpoint-GUID: UENokysxVAG8W2oWgTTpXqqCmm2_ieTB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_04,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070059

dmaengine_prep_slave_sg() allocates a DMA descriptor which is freed on
either successful dmaengine_submit() or on dmaengine_terminate_sync().

The error paths after descriptor allocation was not clearing them,
leaving the descriptors orphaned and leaking memory in case of failure.
Add terminate calls in dthe_aead_run() to appropriately clean the DMA
descriptors.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index ccee60800a664..ea6e3b246ed1b 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -914,6 +914,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 
 	struct device *tx_dev, *rx_dev;
 	struct dma_async_tx_descriptor *desc_in, *desc_out, *desc_aad_out;
+	bool cleanup_tx_chan = false;
 
 	int ret;
 	int err;
@@ -1014,13 +1015,15 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		src_nents = sg_nents_for_len(src, cryptlen);
 		if (src_nents < 0) {
 			ret = src_nents;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 		src_mapped_nents = dma_map_sg(tx_dev, src, src_nents, src_dir);
 		if (src_mapped_nents == 0) {
 			dev_err(dev_data->dev, "Failed to map ciphertext src for TX\n");
 			ret = -EINVAL;
-			goto aead_dma_prep_aad_err;
+			cleanup_tx_chan = (assoclen != 0);
+			goto aead_dma_map_src_err;
 		}
 
 		/* Prepare DMA descriptors for ciphertext TX */
@@ -1030,6 +1033,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_out) {
 			dev_err(dev_data->dev, "Ciphertext TX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = (assoclen != 0);
 			goto aead_dma_prep_src_err;
 		}
 
@@ -1038,12 +1042,14 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 			dst_nents = sg_nents_for_len(dst, cryptlen);
 			if (dst_nents < 0) {
 				ret = dst_nents;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 			dst_mapped_nents = dma_map_sg(rx_dev, dst, dst_nents, dst_dir);
 			if (dst_mapped_nents == 0) {
 				dev_err(dev_data->dev, "Failed to map ciphertext dst for RX\n");
 				ret = -EINVAL;
+				cleanup_tx_chan = true;
 				goto aead_dma_prep_src_err;
 			}
 		} else {
@@ -1058,6 +1064,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		if (!desc_in) {
 			dev_err(dev_data->dev, "Ciphertext RX prep_slave_sg() failed\n");
 			ret = -EINVAL;
+			cleanup_tx_chan = true;
 			goto aead_dma_prep_dst_err;
 		}
 
@@ -1147,6 +1154,10 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 aead_dma_prep_src_err:
 	if (cryptlen != 0)
 		dma_unmap_sg(tx_dev, src, src_nents, src_dir);
+aead_dma_map_src_err:
+	/* Free any descriptor prepared on dma_aes_tx but never submitted */
+	if (cleanup_tx_chan)
+		dmaengine_terminate_sync(dev_data->dma_aes_tx);
 aead_dma_prep_aad_err:
 	if (assoclen != 0)
 		dma_unmap_sg(tx_dev, aad_sg, aad_nents, aad_dir);
-- 
2.34.1

