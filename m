Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793771295;
	b=L0yDkP4ZcBnwLfmAKbw+mE9ABJgXZjfyKHahvRplj3tDepi07LoqNyUhZxUW5apcokZd
	 jYhrNO5C96T0cv1cwoKJKSR8rR8GUAH5Vu75qdCLAcilm++7T/LEBYDwKgSR5Ke5aR87H
	 lyf/nudJXya2iqDbtq8gc1twnVO5fjXYhRW057yhjt2dFaHHHtPhOKn0fQ4yO4LoU3R6t
	 Lz+C3nEQwjCWsB/m2OEuCl0+D488JxqQmHMpaePpxSyyX72Yqi7RCYvus8SueA5QwmpMp
	 m2ty0F8v1OLHkIJ1WQgaSnikBSphdhcObWq4lDrNN2PsXhaW0sL/F2OY7J32h5AsyXA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793771295;
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
	bh=2Xifw6PEKdfy4LsL77yEmA8lH2RrDfgLI7ZwKUnMYsk=;
	b=4rq6x0MBlr7I0DIr5+aHxHmMZIrfeACWirDWF6hvm1OTe5D7D4R27M7wUql15C+iIBjh
	 GYoSOwwy3I1eeY3fsp0jKu6IcDOgZciK8Y778YExlHvK8AQyUP+SaSnarxQhCvKShFeL0
	 ADUxKjOcKBjB1JQWJOLngpd3OngoX+RzUHWibbkWsMTrXJKm8nfE+p37SS7iRZ2AzOXml
	 xurIzM+b1i8T2/0Vg89tLoI+LLK/ZdLRdA7KjtkNRYjY+Sfl/9KwEbPbEVY4SUJGS1Gd+
	 gNIWlsIJmQ6sHP6LBip6GPgOAiE+5UObGheCfI7Te+0WNLIpn74jxuzAer4MPPnQoSw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=RHe2sqz2;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=YITKPqWw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CD7606A31B;
	Wed,  4 Nov 2026 05:48:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 57CD7606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=RHe2sqz2;
	dkim=pass (1024-bit key, unprotected) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=YITKPqWw
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A40SCqR2589087;
	Tue, 3 Nov 2026 23:48:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=2Xifw6PEKdfy4LsL77yEmA8lH2RrDfgLI7ZwKUnMY
	sk=; b=RHe2sqz2aob4S9rMkx14xPL0SArAj41gpbE7C/rqqEfHql1HnjLKs22Lw
	1hJiQAXcZ6EjupIJutjf6ErMbmOyokb4A18IJZZTV7FrfITLNboeUctV2L87vA7E
	Fq6n9OWERpYE9hr2K49R+/mAWlDODaNd3TtNcLlrh01MYEeA+ZbGlAYpZOIe2q/M
	RffNPVe+t3wq3oFaoxgArqKhUpdPxhTEM64BmMNzXjx6w7q5twpp9yUAURfkUjP1
	7ChIRI7qj01ij2fiVjO5BDypKshrbrw6mSYfwA6oTW85ShiCkqDbEZPZmK16vvs3
	YbWa6ftAszDytgDzYyNwDP5p60nRg==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hqnf52xva-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 03 Nov 2026 23:48:09 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FxoNqOzfk0Z4CUPlgqRbGBes4kyPjJ9Tb1NtjPlOzjSiH//j4YLMQXSmSBWlCBT78+dml0vmeDksDr2qjs7KENopU/MMejcKgSl/AxmH7DgA1a1/7Ev9DnxQgy7C29WJyTsAwjeG+gKRh8YrCbOvtgRQGpapVLSDjmLD8nsRRthPj+h9JckSw8QF3CtrZBd72SG/IP0DzFU26JebPF9xhNvfH1+eQTGurD2gNg0eDCColPp1T73wEF+bFq4T/M+wTEU0jedIM21LlJrQBgtfBzxbsdoJhdWuBGgzv+qXwP2FWCuR26rZ+zX09nDjp85seaSJ0QYYigxjcisXxZ3jFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Xifw6PEKdfy4LsL77yEmA8lH2RrDfgLI7ZwKUnMYsk=;
 b=f32CKANak+E7COQJHgitiAEjDVW6yZUkhgwEBZXeDSPZmSETs0Uw06llewK4hkBD1h/ANx1Wf4GhU8z4mJMwXRtz3B/rn1c39VoM95RQm4/JNUUXr2NSJsSXKnj0NrciO638yaZ6kqPTJT3WxVxxfT5x3ac7YiQpts7yrrQfOaC8Q9kkqf92DX7BVt8+S9sdKhFw0sW5yApzcTO+mE3J6tUsff8Q+WkzVgAYRpSnhHtjeTHSajQ+CkI479zv4HTNbVSx95DOEtAPnwQ5fxkdh9yNMvpny8qT1lggYHunPOADFnSFdHHndGFGYCVaJgK7GO+nZrdq6ooxBuJgxDfBUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Xifw6PEKdfy4LsL77yEmA8lH2RrDfgLI7ZwKUnMYsk=;
 b=YITKPqWwMj+2x3u/nZDyf5dppmXMC2d/Wc1u5LORycn7zAxur0pBxKUtjYl1t6hjCye8L+3ieiS1L+xV8hHtfoprFfkvfMeNPjaqfkHFN/T2RbEYDSpkjxd/cBNxtb1tLGU2lol76bSc3psd7X4IoFlvBwMZivEdI4ek9dsuwlY=
Received: from BN1PR12CA0005.namprd12.prod.outlook.com (2603:10b6:408:e1::10)
 by SN4PR10MB998060.namprd10.prod.outlook.com (2603:10b6:806:218::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 05:46:06 +0000
Received: from BN2PEPF000044AC.namprd04.prod.outlook.com
 (2603:10b6:408:e1:cafe::72) by BN1PR12CA0005.outlook.office365.com
 (2603:10b6:408:e1::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.9 via Frontend Transport; Wed, 4
 Nov 2026 05:46:05 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 BN2PEPF000044AC.mail.protection.outlook.com (10.167.243.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Wed, 4 Nov 2026 05:46:03 +0000
Received: from DFLE204.ent.ti.com (10.64.6.62) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:23 -0600
Received: from DFLE211.ent.ti.com (10.64.6.69) by DFLE204.ent.ti.com
 (10.64.6.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 3 Nov
 2026 23:45:23 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE211.ent.ti.com
 (10.64.6.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Tue, 3 Nov 2026 23:45:23 -0600
Received: from uda0497581-ant.dhcp.ti.com (uda0497581-ant.dhcp.ti.com [10.24.51.159])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A45iJ00521920;
	Tue, 3 Nov 2026 23:45:19 -0600
From: Manorit Chawdhry <m-chawdhry@ti.com>
Date: Wed, 4 Nov 2026 11:14:26 +0530
Subject: [PATCH v2 16/30] crypto: sa2ul - copy command-label inputs locally
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
Message-ID: <20261104-b4-upstream-sa2ul-cleanup-v2-16-15ab90b3f9c2@ti.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793771059; l=1643;
 i=m-chawdhry@ti.com; s=20231127; h=from:subject:message-id;
 bh=lFl+KKJfeA5NSt4wjbI166YAKJEky5I8vUdA8EFJVso=;
 b=7Uf2PZf5GORmTqQAY07ty4QaGhnO3tM4khHXkdA3sBWSxYW3I+SvPLxvT+X9MWr23Z8uJNLYk
 AfyzfybAF8mBSNA9cPdJ1a1UaeYkTg4HzadtTn31ZfDYMnawcIT/UJW
X-Developer-Key: i=m-chawdhry@ti.com; a=ed25519;
 pk=fsr6Tm39TvsTgfyfFQLk+nnqIz2sBA1PthfqqfiiYSs=
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AC:EE_|SN4PR10MB998060:EE_
X-MS-Office365-Filtering-Correlation-Id: 08aa48ae-2cd0-4464-b7b8-08df3a36ea02
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|82310400026|36860700016|261009223027099003|261021123027099003|261022115727099003|261021130227099003|261021121427099003|261021135927099003|56012099006|261028144727099003|261026130827099003|261022105027099003|261022075727099003|261026121527099003|261021133027099003|261022113327099003|261026135527099003|261026140227099003|10067099003|18002099003|261102123227099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	eSX/ALYUUCTeGOzjguxdsz0DwL7Q+WK/wCcMnrZvddrxFYpvZbjc2N+zUovGXf93pkGC+s/1ABEXgHhThOBrGxLlUoliNOdiv54jhDkeFNL/BxxeJJ4hl/cq+t0icGPs56cr8bwBHTHTVB7UF3yXOAQq/se5W/ylR4pyaliXhMgnHF8RL36jZYl01zzq9p8Gg9SZIqF18EaxQOx3cTJ9OC1xLwGrOk0XCOUhTYh7kbMKuRbcOD4kYjsXaLdhWd2eieaVMww5mS/aJznjMlQrkm2r4KGBryArkdbKLD/c6u6ae9a6ir6uaRCVNj0lcr9caUeAI9eWiXdQNYjEgs11GjWpFQDm1C07gd0amM/f1fpQof4YruludV63yWxe1aS4GUzdb1+TzIiZpYEV8etFWd0knFRUqyRInRvBb6fIzWQfcDTq/waHIqFUSOADpTELrAILYsr0spbJOwVyiwbhsEVsIvTCNrMrmsB01jUZ1HUntGo0Qv2IOxAbjsKNZq/jo2cdHog0zo22umGYfj/e8sD+mJJyXeZ/uwAGRPielFL55vBh2IakQ93NnknDpreExVeEA23GDJLN1GAP5EVDm/lRtOXJDiSLNJ2cdpxo4cn//vvYfruPYSlR8y8xCAjFVqQ30SvMyOg6u7GJjMYWyzqd2gs6oVPMy5R+oIn/t+NoTK0vkjASHB0TZ9RUx1kmgbnnthjNzR3B/pNLthv72A==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(82310400026)(36860700016)(261009223027099003)(261021123027099003)(261022115727099003)(261021130227099003)(261021121427099003)(261021135927099003)(56012099006)(261028144727099003)(261026130827099003)(261022105027099003)(261022075727099003)(261026121527099003)(261021133027099003)(261022113327099003)(261026135527099003)(261026140227099003)(10067099003)(18002099003)(261102123227099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	f0elsm2vpZFug+PwKZLcBno7p6rSdwciPbb2ksIEx9fOPeIIT579tv6TaJiRjxoZxQuxjH8t2yHD9Kilpj07Y9CevznCcaOqWIwuQRK1G3uAfo4DLvO/gpOmTshRdBa4IfSdlK9kEPsvXy7JnP0BolBW8gg3ntithqok+eF5C5sOFVz2Hkdt7x6nq4YIdeBwEBTMEim1IMDeWj1C03i3PMv3hVcdFfa+Ixb8eKPyYQ35K6IYIc75X8nLABSZj4F7PnqEGufMKZ8K1m70d+zlxdCXQYJK9sXE15vf5bhDozgyICr/Ys7JuH531gwIzlCEbEwurfgYJ/6hQpefbKueqTUlv8yQhckoBWwL23aE5E4ZvLkGYlxYAKZcjSKiGTP+Xcc1T6sap1WONGaPjMd0PnxdALltOznmVpF8V+Yb/nmZsArkR7Q6s0S9vQSz+aTq
X-Exchange-RoutingPolicyChecked:
	cietGJ0lz8ihBh6nZqI4lts1BXPq/Anqe0JUqVBuaYj630XLGHQJuRFnW6oxioOkncEQ9MGJgq/BFU77LdqMVMEDrJ7iw6k8qw73EY05po/f92YnWeI1XuimgCuIK6aXkWKCuKcuoExiChSw5WQT1hYPKKOkkas077BuDlQDf5BiU3e8Cuz/LXFoLCNYihvTPGOt7CIoCafpBrw22gPVSA2YbDUxQvuAkODOtjH/tkGI9OGitbla+uJGCV2lEh2i01I5dZscn0KU44tZahSfC2wTeNTcqjrLKbLspmIQ+AfZxoq6Yep3hBsZ9I0wUMQEaToUjwx2j3hNWds148q/RA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 05:46:03.7495
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 08aa48ae-2cd0-4464-b7b8-08df3a36ea02
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB998060
X-Proofpoint-GUID: i4D8R4yBnt8T02Yq5Xf01FFwGLASo125
X-Authority-Analysis: v=2.4 cv=XcYcX455 c=1 sm=1 tr=0 ts=6aeac719 cx=c_pps
 a=0Wok1Aa8RnZXRT++mDYMDg==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=taLDd7a_hP9WKsMzeGRc:22 a=sozttTNsAAAA:8 a=KAkdBlQi1t1qdpQly1EA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: i4D8R4yBnt8T02Yq5Xf01FFwGLASo125
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX3rSEcRocjbu3
 jrkqY+dSgxbyPNbdHPEb+go9Y+X/28+2300ChUyUrFqqT50cxwCvODDfovV2oqqG6c8vH9/p8Lk
 C1FbjnyBKj/a76omcPfXpdSVG/iwcN4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAyMiBTYWx0ZWRfX/evx+y8E24pX
 N1yz4ZJ4vXD+TS0fnmEI58A3331HXuuqCQx/K9qHX5uOMBCVKxRDjX8FCfuvetIy3pihOAHkH8K
 CL4G7LMnyKsc+exofQzjsYZushgdNBHpBi+ViDTym93HMfQEunBvnBxcYR7QlvM6tIFO0b3HUX+
 nyKlYjovEKS3x6pJMXBiycdvKyiXxjBecELXpbC8HN9xXZ198XVX1BKNS0ACMlzTXLDuFenAFxS
 yLjgl5JSZ+e6YtTnS5RxAiJMBFj2HnVUXMCWG0Pv4v+FzAJI6XVISY7uc6RSiIX+B5A7TahzDu9
 diW1Ri8dvR6Wy83Gzb4H7IkdHScAjWG76yP7KNp7nBBzROqNuNRdd/WyExbAMihXprTGEXM+8Hf
 9MRSCqbxRYzUtJnvCdMqzKC6lp5bsMEv0+WHXnZxd21MiW7bTffTEUOmO4Xq35h3p7tjFBr7GPA
 MgQffVCTdOWFuvIktlg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611040022

Keep the command-label size and update information alongside the
request-local template while formatting DMA metadata.

Signed-off-by: Manorit Chawdhry <m-chawdhry@ti.com>
---
 drivers/crypto/sa2ul.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 022a95e40698..f5174dccc32b 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -987,6 +987,8 @@ static int sa_run(struct sa_req *req)
 	struct sa_rx_data *rxd;
 	gfp_t gfp_flags;
 	u32 cmdl[SA_MAX_CMDL_WORDS];
+	u16 cmdl_size;
+	struct sa_cmdl_upd_info cmdl_upd_info;
 	struct sa_crypto_data *pdata = dev_get_drvdata(sa_k3_dev);
 	struct device *ddev;
 	struct dma_chan *dma_rx;
@@ -1032,9 +1034,12 @@ static int sa_run(struct sa_req *req)
 	ddev = dmaengine_get_dma_device(pdata->dma_tx);
 	rxd->ddev = ddev;
 
-	memcpy(cmdl, sa_ctx->cmdl, sa_ctx->cmdl_size);
+	/* Keep command-label formatting inputs in local storage. */
+	cmdl_size = sa_ctx->cmdl_size;
+	cmdl_upd_info = sa_ctx->cmdl_upd_info;
+	memcpy(cmdl, sa_ctx->cmdl, cmdl_size);
 
-	sa_update_cmdl(req, cmdl, &sa_ctx->cmdl_upd_info);
+	sa_update_cmdl(req, cmdl, &cmdl_upd_info);
 
 	if (req->type != CRYPTO_ALG_TYPE_AHASH) {
 		if (req->enc)
@@ -1158,7 +1163,7 @@ static int sa_run(struct sa_req *req)
 	rxd->req = (void *)req->base;
 	rxd->enc = req->enc;
 	rxd->iv_idx = req->ctx->iv_idx;
-	rxd->enc_iv_size = sa_ctx->cmdl_upd_info.enc_iv.size;
+	rxd->enc_iv_size = cmdl_upd_info.enc_iv.size;
 	rxd->tx_in->callback = req->callback;
 	rxd->tx_in->callback_param = rxd;
 

-- 
2.43.0

