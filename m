Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771188;
	b=q0xbKnR+aUqh40LxuyQER0dcLVxg1qVWLMeoTtjJmxR+B7JB4O60RuIyghXnA3VfMiVw
	 BlEwR33ufQ/43sqWfNJJK9t9l+DEaJIrkSs9gunQHapUlm7XODOd3p0sid+ZI+LiNezkS
	 zE+7TCeKm8HSoFOnYChhwxvWv+5kt9yeBjlk+xsWFNr7LgZDltqHmYHq7tpWRKZj7Sb/U
	 0Cry6hoVRwHaKGSHBjWlpO1r3s3FcRYT8Ti25W1ooiPWLQoP+BawW0+Yx11hyYeMcPKOI
	 zNX1mLO01nLCU9ViiQgHJzdRE54PqRL6dQsAsBPu53GWaB88p/yygXAkCy9zNGicq/w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771188;
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
	bh=BfpmqYZyydoBRx4HzfTSMdsfsZAGPQCLJ5kLWjMMVPY=;
	b=rSM6JCSSA3QGbURoPmqzTLykAvCCLcYM3WdXF/DvLNuZ/0AGomk+Rgy1vdvUIWzjyjTa
	 SK+tPf1u6zZP4lJY5zKclyNt1zNKJg/rw8pvHdzQQ3epwLNrMdp9/09K+G0QRgD4b1wvL
	 A2I0N08XyeqfbV0KEbAHRD1U9q2wNF6xf+47cUgB68i45u8GKWZ5wD2KyuIUBuwcCw3De
	 drtnD/NFpFwbfRkOVl2LKF2Ge9HaS3/HwwYE3fc8Eld+LW6cKlpmcb2shh62ezShOfwQS
	 JFhEIsTWmgG62BTFqkO5aW/vTSAkz5/UW+WlEKLVWfEJqa/HZ9+p3uJBX7o24KXG0fQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=QD6yqQgL;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Q9KSVrbS;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993FA606D83B;
	Wed,  4 Nov 2026 05:46:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 993FA606D83B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=QD6yqQgL;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=Q9KSVrbS
Received: from pps.filterd (m0374956.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A42TLRd601416;
	Tue, 3 Nov 2026 23:46:24 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=BfpmqYZyydoBRx4HzfTSMdsfsZAGPQCLJ5kLWjMMV
	PY=; b=QD6yqQgLXvpIEXKzzJSBmoaazjyeNkVtDpy1ukgKjxzw00yAd0akbcSNi
	tBhoMzlYuaQktG16haVbFATJu24Ga7jcUvwzhXMgPc51gnO6xc9cVC50AjBQLdk2
	W3XUcZWJs231pOUCOnyrK5cUjYngEmxtalVbf7OlBlJZaLVjALszUi9lu1+KVFXU
	G8AOSaJvN42AVO2xF4orpDR8cpzHjHcupMQn/B2s0g60vClDCD3J2bnpR4DZJDDn
	79g+0h+cTDojP1cRCLTDTvMMc7TcA/fxcOD6DTEXssZVuk36LAOJ4gGLdVu4u5pl
	yqfE61WMAKuvh78xLi8Y4TePHfOaA==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012062.outbound.protection.outlook.com [52.101.43.62])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hquyf0tt8-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:46:23 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h2/GEM85uGce3dJorzBfy27G7/TfQevS+joiN9OzUNe0SMotycHMbkr6Y6c5Y0fxXcnvRtaOkeMI3Rdf5Z1obVInxb1jOWYuLu6iMiuFdXkQO0jk7AKqbP9um1y8KZqOUCj5yvI/iWmgjm2dtRSo3mEoRmyWgSfUmBnUYcyR0veEMDBcJlz4RqLkX23LFiOiI72nLBkW3fJOYMFCT7rbUj0r68WyWtCS6uLLSlXH0EwrA2dUc7bDjCuRkkDvmHLq7JugsUqkmYUe3gpeGIQy2pl3p49lqZANIfapt7AYWaS8W2ahp8KoOspKm33Ds1liOTU6q7ecTRw06mBPhkASHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfpmqYZyydoBRx4HzfTSMdsfsZAGPQCLJ5kLWjMMVPY=;
 b=tz4juqCqkUlbCjVYmUvMLQ7c1hIlU0nv/nQvPpfnChPrMgB/zgZlIe4mPqPLMzjnEtcZ8MvyGYnmnnDkFHjtRopoxd2+vdtQWXdaHTT4TWbPW7GjY1K+hgsh4N0Ww3nWS+TYy3ZikJU1kfoGt/amtY4nTLHxxiyCPtnipUNwHSk6sGIzGCRD5PeltjLoB3wHMqwG0Ak+Rsm5WqJX5tqtePwMHwtsjrhLosFJpEFHxns2otpB7f3aZDXh0U75Vmbq0ODN0fnVA1i1uE+YHfjJBoMPT8PEy0fHHCzXEsZxZHkERsx/FHhNQAX2RvdlczOFdIxRZNqVbFiM0deTAUZYBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BfpmqYZyydoBRx4HzfTSMdsfsZAGPQCLJ5kLWjMMVPY=;
 b=Q9KSVrbS1cDpeEeu0kChIC3cLWq5v/qjgczO0ZRCR4oESzOsBm2F4oBzp4CXA+/1wkGuOJGAxjckhNA1HSDEx6ADBH6kZt0/AKwtrwyz1aKiUkAcC/DV9Ehl9CRVBioFzNVYEhRJX6DDpQI8JZn17ooHlUXmPiY0rBuQiaxOsrY=
Received: from BY3PR03CA0015.namprd03.prod.outlook.com (2603:10b6:a03:39a::20)
 by PH3PPF7E48920CA.namprd10.prod.outlook.com (2603:10b6:518:1::7af) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:46:17 +0000
Received: from MWH0EPF000A6733.namprd04.prod.outlook.com
 (2603:10b6:a03:39a:cafe::81) by BY3PR03CA0015.outlook.office365.com
 (2603:10b6:a03:39a::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:17 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 MWH0EPF000A6733.mail.protection.outlook.com (10.167.249.25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:17 +0000
Received: from DLEE205.ent.ti.com (157.170.170.85) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:46:01 -0600
Received: from DLEE214.ent.ti.com (157.170.170.117) by DLEE205.ent.ti.com
 (157.170.170.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:46:01 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE214.ent.ti.com
 (157.170.170.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:46:01 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ0B521920;
	Tue, 3 Nov 2026 23:45:57 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:37 +0530
Subject: [PATCH v2 27/30] crypto: sa2ul - use synchronous fallbacks and
 fixed request sizes
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-27-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=14833;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=K8c+iyqM+Tc7nkiWqzQWRyvahNP6R9vFv2BzD91GkEQ=;
 b=uboeVVGP52sCjpyJER58gE6yJQ1clZfJPLlND0ar/N5IXqXQ0MGpCpT6qfED7V6XvGwoGCbMe
 NgMjhDAMWSUDUqGTIBptzgSkK2ituj1MZLFPahMnnJBMkt0C2GVLAtx
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6733:EE_|PH3PPF7E48920CA:EE_
X-MS-Office365-Filtering-Correlation-Id: d6c9b14b-4650-4f5c-f2f3-08df3a36f236
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|376014|82310400026|36860700016|56012099006|261021121427099003|261021123027099003|261102130727099003|261009223027099003|261102123227099003|261022075727099003|261026121527099003|10067099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	OgpwETGoH5CUYKw4supbb9AVlwIOY7a5x1AaRirQ9IcuAwoWpvSUXdPflNh6FSwfW888aAdstFyheR+z4WCq1DKMv30MXxbEcaaHafeCxXreQvpqwGeTVGvOkSRVjCglnmBjfj1/VyJdjpsIqRVJE840+6glKm/7fzRHXzdNmegdS5v6+1J8ZdGM/GM246fmRIvTS7tUi7TlMac7fIfl5h05gFdbsojCfd43FA7nyCdbeQzq99h21UtcSr5OjHXTjC5va2v3FrSDYNHtwKwadfjZle1S9DQaX1V337xwcMK9JUIyoH3YSu32oVAIdbwPLjOJyb5rR3b3mvnHj+ePbbHsO6vbyuqied42hXO8Ruuh1rKqmpmhAe3IPy7aKDya6tVtUuDOFLkR4ZCYDjyN/GGmQByMw9UbOLDU9Easw3orvnCqddCksqOAOY+Rb1p/HH7Qv3i3FtDeU30+QoQeAg4Uhht597IjtzXxf0Z+CYlkfZ6FOg8hzzWSo6FEtVTFd36W8uvaSzRJt3ceAANX/k7pb9cdkB0RqzX/3zhuzkonEbZInlFDncGC1eAEnM+S2eOW8eu5Y1CldGVEHzPsvIcdg9oDK6rra37wTyeEC56O7lSd0n9P+IXMVLBuVyTWg9UswWRmecY8upg3sXZzt8qfUIcStuz4nItnBG+v9dAZePLB6csIAOFrmGVgFjd3O2iXfebZiswt8Yr3IsgqvQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(82310400026)(36860700016)(56012099006)(261021121427099003)(261021123027099003)(261102130727099003)(261009223027099003)(261102123227099003)(261022075727099003)(261026121527099003)(10067099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	FdcE8yPBDPaFLsDj2vnr931wq45tfRrciLCHGWMAYVEjJ8dTFHHmYPkFCVE+UROljDL6vm5FcKyKWzbO8SxQPp76yrC4cs+IUx7JC87HShyUoZoRbzhmREzlczvs6QiuxSHFLz50p4Lljh5THdNGm02P+cMJQ3yR7D5nqBN34rRdE6tfj09eWTCrwWmuQYMdYru+cCslwgCsnzzGkj9YAwj5Cs9kkeTpqK/eszD/Ou5KjmP+mgPgzxl6PlELP9R7s4yPjA+z+Ql5wlklOM1nkUWnB2tvv1cuvB7mGAEAbb8ZOyXwcv+QBTeUTD71V3QH2KG0ZIZE9W/UxlM19X1gfjcteJysf4NLWAEfKUlwGb/hK5G8TL51CUJkoUsfUf2dQTXYn+We3sP62fmepuI/1DpBQtk8xat9z6K2o8+2zopTBYT6AIjAzrdXVFOzv8rX
X-Exchange-RoutingPolicyChecked:
	oiKSKY5cpUyrgKfiQkzA0dCNZpeRIJt0N3Oz9Od0SHU6frvavVql9ggvOfg+pz0jdQlQgmKZ0zRjlxOoWuE6XO1aMZyTqM+ilqk0oJuy+VTMoMxlGdrOpUhPAO9HHIIowoh23DacE5TmX2Zs0/WwxDZr89G0p3HajIfqXuPu+dzFGHBS48T84DtP8aMx6XUuG7nbojYfarw6g1Ey5Y0Ht8nIOOI4tRvFDsLPpIoQ0mYYI2ugQKKdbxH90Hj1WbDM6aKyQNL9nFEkTqbDW1yrfg5D5YrGe1tKrFKF22rvzsCqKwlmAP03PSkR6x79uJy1IwrsvohVgf7zky3Z0Cxm4Q==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:17.4948
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c9b14b-4650-4f5c-f2f3-08df3a36f236
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6733.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF7E48920CA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX7ajlIjtdA5x8
 hh5TQiUBLMxa4au1kqepLU1VGPs5VPh1wS5k9kTgNa6Su2+yiXicp6zGWu2Zeqq64vbZUNDnqF1
 ghz1uYLh/Zv1jfYNtESVPPd54Mwho2pheYVHsMblV2JF8itNFzIMHAftXLngLr3sa1tj0fyfsbw
 edH5ggOwRojuJyGfh5oWI0DJkWEvdBaW0XNw1meCB3OHeRVLDvve0+NeBVou/BMdOM0q+Cmih0v
 Jd8tzDgnK4E0inNylx1vSuOgogypFD3kXB/WVGdDZGhaQ1CD2eY+I2WzDWVb/Wk1A+kU0nG67p6
 QroxQyMUb4hAi01WSSfw81bG36NeHZSiV2Bw11cu3j8ahyxPj3/F/LEgZ3BWQsRnJrihu7WPyMA
 bokG+2zfIUfs8M+orY5TwBH3MUuxmLlXIiyActop/aCKiak1Vw+KO31jCKQuQl3AqtElGa/hU80
 V/lZLSXMPb8aNz/OyzA==
X-Proofpoint-GUID: HLcT6Va3noTw4nH9boo2J9WHb7REH5UP
X-Proofpoint-ORIG-GUID: HLcT6Va3noTw4nH9boo2J9WHb7REH5UP
X-Authority-Analysis: v=2.4 cv=MpzHeGae c=1 sm=1 tr=0 ts=6aeac6af cx=c_pps
 a=qMfGPIaByV4ZnHoTJsbowg==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s63m1ICgrNkA:10 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z8NIEmU8O1QQgoT56wFK:22 a=jwouBfj2j3NM8CExmVVE:22 a=sozttTNsAAAA:8
 a=nRq_4veAmY2V1hAKaIIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX4EcgUPOF/HNm
 Y7XFWM1fI9FAzgLnEW7VGJ3Y5peYgzG+yENJUHkA83lnW9MwiQQAc2yMp+lMAQ1CZSpOxjatmgs
 /6kIVrc9fqxNHTAkAvb2s95Ihp2qLWE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

To move away from crypto_*_set_reqsize(), use synchronous skcipher
fallbacks with stack requests to avoid reserving fallback storage in
each hardware request.

On arm64, native HMAC authenc requests need 448 bytes for SHA1 and 488
bytes for SHA256, exceeding crypto_alloc_sync_aead()'s 384-byte limit.
Since the sa2ul driver registers these authenc requests, keep ordinary
AEAD fallbacks with dynamically sized request storage.

For the other requests, start using cra_reqsize, keeping its embedded
fallback request for incremental hashing.

Also, while at it, switch hash transform callbacks to init_tfm and
exit_tfm.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 131 ++++++++++++++++++++++++-------------------------
 drivers/crypto/sa2ul.h |   2 +-
 2 files changed, 65 insertions(+), 68 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index ae3889695dfe..19caaa41ba03 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -760,7 +760,7 @@ static int sa_init_ctx_info(struct sa_ctx_info *ctx,
 	return err;
 }
 
-static void sa_cipher_cra_exit(struct crypto_skcipher *tfm)
+static void sa_cipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct sa_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
@@ -772,15 +772,15 @@ static void sa_cipher_cra_exit(struct crypto_skcipher *tfm)
 	sa_free_ctx_info(&ctx->enc, data);
 	sa_free_ctx_info(&ctx->dec, data);
 
-	crypto_free_skcipher(ctx->fallback.skcipher);
+	crypto_free_sync_skcipher(ctx->fallback.skcipher);
 }
 
-static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
+static int sa_cipher_init_tfm(struct crypto_skcipher *tfm)
 {
 	struct sa_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
 	const char *name = crypto_tfm_alg_name(&tfm->base);
-	struct crypto_skcipher *child;
+	struct crypto_sync_skcipher *child;
 	int ret;
 
 	memzero_explicit(ctx, sizeof(*ctx));
@@ -793,7 +793,7 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 	if (ret)
 		goto ctx_dec_err;
 
-	child = crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
+	child = crypto_alloc_sync_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK);
 	if (IS_ERR(child)) {
 		dev_err(sa_k3_dev, "Error allocating fallback algo %s\n", name);
 		ret = PTR_ERR(child);
@@ -801,8 +801,6 @@ static int sa_cipher_cra_init(struct crypto_skcipher *tfm)
 	}
 
 	ctx->fallback.skcipher = child;
-	crypto_skcipher_set_reqsize(tfm, crypto_skcipher_reqsize(child) +
-					 sizeof(struct skcipher_request));
 
 	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
@@ -819,7 +817,7 @@ static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen, struct algo_data *ad)
 {
 	struct sa_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	struct crypto_skcipher *child = ctx->fallback.skcipher;
+	struct crypto_sync_skcipher *child = ctx->fallback.skcipher;
 	int cmdl_len;
 	struct sa_cmdl_cfg cfg;
 	int ret;
@@ -835,10 +833,10 @@ static int sa_cipher_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	cfg.enc_eng_id = ad->enc_eng.eng_id;
 	cfg.iv_size = crypto_skcipher_ivsize(tfm);
 
-	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
-	crypto_skcipher_set_flags(child, tfm->base.crt_flags &
+	crypto_sync_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(child, tfm->base.crt_flags &
 					 CRYPTO_TFM_REQ_MASK);
-	ret = crypto_skcipher_setkey(child, key, keylen);
+	ret = crypto_sync_skcipher_setkey(child, key, keylen);
 	if (ret)
 		return ret;
 
@@ -1248,18 +1246,16 @@ static int sa_cipher_run(struct skcipher_request *req, u8 *iv, int enc)
 	if (req->cryptlen > SA_MAX_DATA_SZ ||
 	    (req->cryptlen >= SA_UNSAFE_DATA_SZ_MIN &&
 	     req->cryptlen <= SA_UNSAFE_DATA_SZ_MAX)) {
-		struct skcipher_request *subreq = skcipher_request_ctx(req);
+		SYNC_SKCIPHER_REQUEST_ON_STACK(subreq, ctx->fallback.skcipher);
+		int ret;
 
-		skcipher_request_set_tfm(subreq, ctx->fallback.skcipher);
-		skcipher_request_set_callback(subreq, req->base.flags,
-					      req->base.complete,
-					      req->base.data);
+		skcipher_request_set_callback(subreq, req->base.flags, NULL, NULL);
 		skcipher_request_set_crypt(subreq, req->src, req->dst,
 					   req->cryptlen, req->iv);
-		if (enc)
-			return crypto_skcipher_encrypt(subreq);
-		else
-			return crypto_skcipher_decrypt(subreq);
+		ret = enc ? crypto_skcipher_encrypt(subreq) :
+			    crypto_skcipher_decrypt(subreq);
+		skcipher_request_zero(subreq);
+		return ret;
 	}
 
 	sa_req.size = req->cryptlen;
@@ -1415,9 +1411,9 @@ static int sa_sha_setup(struct sa_tfm_ctx *ctx, struct  algo_data *ad)
 	return -EINVAL;
 }
 
-static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
+static int sa_sha_init_tfm(struct crypto_ahash *tfm, const char *alg_base)
 {
-	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
 	int ret;
 
@@ -1444,10 +1440,6 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 		__func__, tfm, ctx->enc.sc_id, &ctx->enc.sc_phys,
 		ctx->dec.sc_id, &ctx->dec.sc_phys);
 
-	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
-				 sizeof(struct sa_sha_req_ctx) +
-				 crypto_ahash_reqsize(ctx->fallback.ahash));
-
 	return 0;
 
 err_free_ctx:
@@ -1455,7 +1447,7 @@ static int sa_sha_cra_init_alg(struct crypto_tfm *tfm, const char *alg_base)
 	return ret;
 }
 
-static void sa_sha_cra_exit(struct crypto_tfm *tfm);
+static void sa_sha_exit_tfm(struct crypto_ahash *tfm);
 
 static int sa_sha_init(struct ahash_request *req)
 {
@@ -1525,13 +1517,13 @@ static int sa_sha_export(struct ahash_request *req, void *out)
 	return crypto_ahash_export(subreq, out);
 }
 
-static int sa_sha1_cra_init(struct crypto_tfm *tfm)
+static int sa_sha1_init_tfm(struct crypto_ahash *tfm)
 {
 	struct algo_data ad = { 0 };
-	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 	int ret = 0;
 
-	ret = sa_sha_cra_init_alg(tfm, "sha1");
+	ret = sa_sha_init_tfm(tfm, "sha1");
 	if (ret)
 		return ret;
 
@@ -1540,18 +1532,18 @@ static int sa_sha1_cra_init(struct crypto_tfm *tfm)
 
 	ret = sa_sha_setup(ctx, &ad);
 	if (ret)
-		sa_sha_cra_exit(tfm);
+		sa_sha_exit_tfm(tfm);
 
 	return ret;
 }
 
-static int sa_sha256_cra_init(struct crypto_tfm *tfm)
+static int sa_sha256_init_tfm(struct crypto_ahash *tfm)
 {
 	struct algo_data ad = { 0 };
-	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 	int ret = 0;
 
-	ret = sa_sha_cra_init_alg(tfm, "sha256");
+	ret = sa_sha_init_tfm(tfm, "sha256");
 	if (ret)
 		return ret;
 
@@ -1560,18 +1552,18 @@ static int sa_sha256_cra_init(struct crypto_tfm *tfm)
 
 	ret = sa_sha_setup(ctx, &ad);
 	if (ret)
-		sa_sha_cra_exit(tfm);
+		sa_sha_exit_tfm(tfm);
 
 	return ret;
 }
 
-static int sa_sha512_cra_init(struct crypto_tfm *tfm)
+static int sa_sha512_init_tfm(struct crypto_ahash *tfm)
 {
 	struct algo_data ad = { 0 };
-	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 	int ret = 0;
 
-	ret = sa_sha_cra_init_alg(tfm, "sha512");
+	ret = sa_sha_init_tfm(tfm, "sha512");
 	if (ret)
 		return ret;
 
@@ -1580,14 +1572,14 @@ static int sa_sha512_cra_init(struct crypto_tfm *tfm)
 
 	ret = sa_sha_setup(ctx, &ad);
 	if (ret)
-		sa_sha_cra_exit(tfm);
+		sa_sha_exit_tfm(tfm);
 
 	return ret;
 }
 
-static void sa_sha_cra_exit(struct crypto_tfm *tfm)
+static void sa_sha_exit_tfm(struct crypto_ahash *tfm)
 {
-	struct sa_tfm_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct sa_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
 
 	dev_dbg(sa_k3_dev, "%s(0x%p) sc-ids(0x%x(0x%pad), 0x%x(0x%pad))\n",
@@ -1596,8 +1588,7 @@ static void sa_sha_cra_exit(struct crypto_tfm *tfm)
 
 	crypto_free_ahash(ctx->fallback.ahash);
 
-	if (crypto_tfm_alg_type(tfm) == CRYPTO_ALG_TYPE_AHASH)
-		sa_free_ctx_info(&ctx->enc, data);
+	sa_free_ctx_info(&ctx->enc, data);
 }
 
 static void sa_aead_dma_in_callback(void *data,
@@ -1643,7 +1634,7 @@ static void sa_aead_dma_in_callback(void *data,
 	aead_request_complete(req, err);
 }
 
-static int sa_cra_init_aead(struct crypto_aead *tfm, const char *fallback)
+static int sa_aead_init_tfm(struct crypto_aead *tfm, const char *fallback)
 {
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
@@ -1685,17 +1676,17 @@ static int sa_cra_init_aead(struct crypto_aead *tfm, const char *fallback)
 	return ret;
 }
 
-static int sa_cra_init_aead_sha1(struct crypto_aead *tfm)
+static int sa_aead_sha1_init_tfm(struct crypto_aead *tfm)
 {
-	return sa_cra_init_aead(tfm, "authenc(hmac(sha1),cbc(aes))");
+	return sa_aead_init_tfm(tfm, "authenc(hmac(sha1),cbc(aes))");
 }
 
-static int sa_cra_init_aead_sha256(struct crypto_aead *tfm)
+static int sa_aead_sha256_init_tfm(struct crypto_aead *tfm)
 {
-	return sa_cra_init_aead(tfm, "authenc(hmac(sha256),cbc(aes))");
+	return sa_aead_init_tfm(tfm, "authenc(hmac(sha256),cbc(aes))");
 }
 
-static void sa_exit_tfm_aead(struct crypto_aead *tfm)
+static void sa_aead_exit_tfm(struct crypto_aead *tfm)
 {
 	struct sa_tfm_ctx *ctx = crypto_aead_ctx(tfm);
 	struct sa_crypto_data *data = dev_get_drvdata(sa_k3_dev);
@@ -1884,8 +1875,8 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
 			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_cra_init,
-			.exit			= sa_cipher_cra_exit,
+			.init			= sa_cipher_init_tfm,
+			.exit			= sa_cipher_exit_tfm,
 			.min_keysize		= AES_MIN_KEY_SIZE,
 			.max_keysize		= AES_MAX_KEY_SIZE,
 			.ivsize			= AES_BLOCK_SIZE,
@@ -1907,8 +1898,8 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.base.cra_blocksize	= AES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
 			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_cra_init,
-			.exit			= sa_cipher_cra_exit,
+			.init			= sa_cipher_init_tfm,
+			.exit			= sa_cipher_exit_tfm,
 			.min_keysize		= AES_MIN_KEY_SIZE,
 			.max_keysize		= AES_MAX_KEY_SIZE,
 			.setkey			= sa_aes_ecb_setkey,
@@ -1929,8 +1920,8 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
 			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_cra_init,
-			.exit			= sa_cipher_cra_exit,
+			.init			= sa_cipher_init_tfm,
+			.exit			= sa_cipher_exit_tfm,
 			.min_keysize		= 3 * DES_KEY_SIZE,
 			.max_keysize		= 3 * DES_KEY_SIZE,
 			.ivsize			= DES_BLOCK_SIZE,
@@ -1952,8 +1943,8 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.base.cra_blocksize	= DES_BLOCK_SIZE,
 			.base.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
 			.base.cra_module	= THIS_MODULE,
-			.init			= sa_cipher_cra_init,
-			.exit			= sa_cipher_cra_exit,
+			.init			= sa_cipher_init_tfm,
+			.exit			= sa_cipher_exit_tfm,
 			.min_keysize		= 3 * DES_KEY_SIZE,
 			.max_keysize		= 3 * DES_KEY_SIZE,
 			.setkey			= sa_3des_ecb_setkey,
@@ -1974,13 +1965,15 @@ static struct sa_alg_tmpl sa_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize	= SHA1_BLOCK_SIZE,
 				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
+						  MAX_SYNC_HASH_REQSIZE,
 				.cra_module	= THIS_MODULE,
-				.cra_init	= sa_sha1_cra_init,
-				.cra_exit	= sa_sha_cra_exit,
 			},
 			.halg.digestsize	= SHA1_DIGEST_SIZE,
 			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
 						  sizeof(struct sha1_state),
+			.init_tfm		= sa_sha1_init_tfm,
+			.exit_tfm		= sa_sha_exit_tfm,
 			.init			= sa_sha_init,
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
@@ -2003,13 +1996,15 @@ static struct sa_alg_tmpl sa_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize	= SHA256_BLOCK_SIZE,
 				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
+						  MAX_SYNC_HASH_REQSIZE,
 				.cra_module	= THIS_MODULE,
-				.cra_init	= sa_sha256_cra_init,
-				.cra_exit	= sa_sha_cra_exit,
 			},
 			.halg.digestsize	= SHA256_DIGEST_SIZE,
 			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
 						  sizeof(struct sha256_state),
+			.init_tfm		= sa_sha256_init_tfm,
+			.exit_tfm		= sa_sha_exit_tfm,
 			.init			= sa_sha_init,
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
@@ -2032,13 +2027,15 @@ static struct sa_alg_tmpl sa_algs[] = {
 						  CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize	= SHA512_BLOCK_SIZE,
 				.cra_ctxsize	= sizeof(struct sa_tfm_ctx),
+				.cra_reqsize	= sizeof(struct sa_sha_req_ctx) +
+						  MAX_SYNC_HASH_REQSIZE,
 				.cra_module	= THIS_MODULE,
-				.cra_init	= sa_sha512_cra_init,
-				.cra_exit	= sa_sha_cra_exit,
 			},
 			.halg.digestsize	= SHA512_DIGEST_SIZE,
 			.halg.statesize		= sizeof(struct sa_sha_req_ctx) +
 						  sizeof(struct sha512_state),
+			.init_tfm		= sa_sha512_init_tfm,
+			.exit_tfm		= sa_sha_exit_tfm,
 			.init			= sa_sha_init,
 			.update			= sa_sha_update,
 			.final			= sa_sha_final,
@@ -2067,8 +2064,8 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA1_DIGEST_SIZE,
 
-			.init = sa_cra_init_aead_sha1,
-			.exit = sa_exit_tfm_aead,
+			.init = sa_aead_sha1_init_tfm,
+			.exit = sa_aead_exit_tfm,
 			.setkey = sa_aead_cbc_sha1_setkey,
 			.setauthsize = sa_aead_setauthsize,
 			.encrypt = sa_aead_encrypt,
@@ -2095,8 +2092,8 @@ static struct sa_alg_tmpl sa_algs[] = {
 			.ivsize = AES_BLOCK_SIZE,
 			.maxauthsize = SHA256_DIGEST_SIZE,
 
-			.init = sa_cra_init_aead_sha256,
-			.exit = sa_exit_tfm_aead,
+			.init = sa_aead_sha256_init_tfm,
+			.exit = sa_aead_exit_tfm,
 			.setkey = sa_aead_cbc_sha256_setkey,
 			.setauthsize = sa_aead_setauthsize,
 			.encrypt = sa_aead_encrypt,
diff --git a/drivers/crypto/sa2ul.h b/drivers/crypto/sa2ul.h
index 775f3939be68..5152c497858f 100644
--- a/drivers/crypto/sa2ul.h
+++ b/drivers/crypto/sa2ul.h
@@ -242,7 +242,7 @@ struct sa_tfm_ctx {
 	int iv_idx;
 	/* for fallback */
 	union {
-		struct crypto_skcipher		*skcipher;
+		struct crypto_sync_skcipher	*skcipher;
 		struct crypto_ahash		*ahash;
 		struct crypto_aead		*aead;
 	} fallback;

-- 
2.43.0

