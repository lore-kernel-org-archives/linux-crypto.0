Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471185;
	b=pgSCQKE5D/qVGR6NPqpU2ue+Jhe6v+dgFmNWJFejTr8eFCZ+1FWeHWwQ0UcYB2iRXCqM
	 Y0SOVZmyjtqb2+ZWJVJy/0Nc5iojDgWjXuoqP4iZq/4RIdgP+w8D0YukevW2dwWD9rvy7
	 iUJ/D5BF+maf0fKLW0bdLlqgBU7C++quqCS5wKlEyB/yA9wKLKtHOr1BeCeEvBfZ3yPB2
	 1o5eK3E3/25nTwCfGwJw5T6Iv24Uxa2yTOY0WvwmqwygrWBEBZQU6MBLxjmyRqdJP4LQr
	 BMmY0EvT2d8yVqRaUEY5TWIel2Kwo8zSzVfhlmvTKM+CcfQl5p6NSgGz4tCcit/JaBQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471185;
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
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=YiV9YTIDdojlOtKNkA/+q17MvJnoCYKOPmsC5JbK7kc=;
	b=cnMmg+yG/nvIpDx+8CYrCJyQyvZPqTQcsEcfCYE63IHx/dZ/SirR7blQ3UUHpbrRlAXB
	 QYYmZieKwC7ABSmTLode27jS5rCQgXXGRXrYn3sprp+C3zph/67P1hBtX9HYzmLS+Gbbc
	 ayYLyz6k//WGKlY9WADO5OYzDjfIJVe4D0qVmYZfmGuyDuDOFBH4JoWTK2GrAIxRrNEAj
	 db2wGoFEHzyPo//OWRfSGH3v1pgzfkw4moRfM+1ziQXFTqvJvL/K60fjMPIyEyjCAXFVL
	 bbXFgz+QMV6OX/i2W/9PBRmii7JWetqQosTT/WoXyEnOkBqVKCJysL3j4RcpILMaDHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=nHlcmnou;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=We4C3EPl;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0876D60A2623;
	Thu, 12 Nov 2026 08:13:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0876D60A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=nHlcmnou;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=We4C3EPl
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC5ipkv2297457;
	Thu, 12 Nov 2026 02:13:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=YiV9YTIDdojlOtKNkA/+q17MvJnoCYKOPmsC5JbK7
	kc=; b=nHlcmnouH7EaWWxFCa+TwWMW8jaVkLsOzEt7irxlKvZLs1rN3jPgeSESx
	i0wOic7T6hVjNBLDnGCoXQN9nQ56XZczwML8anTqFQtLJQhNc8WtW9Om5XLZsHwA
	PXeef8XLJssWeV8mMy3CYGGmmfX36uy5FGxCkFoLejALFyCov9v7OfmBrlJ55O9r
	RsTQDjcUUDFZe5FZ5b8RGtGAsWDnlwkXGNkM0hKcJSL7e4FwCZCje9Qem1fG3uWb
	K/ByEX9VwN1xtsnew5iG8ZPwdyZ7BGpq7Jx7l5w39uW7vl6ufVNVZO5w0hnRi4IP
	TktGroipuIjSmWjzgO497aJE78pdQ==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012060.outbound.protection.outlook.com [52.101.43.60])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hw7k48w2v-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:02 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XYVhBKDf0pD6SDD+IWuG1teEeV5AK6NvpaDBlMPzWSjA1A1raONcgkA6k6XSReE3gIrjsmHrUdvUrYa0VTiT+TSb2j1xPEbjNAgHo3xKrTYdFMJ3tQTRQKT3rBZYSg5gaKtXaSCugajhb+BHB5LnEn6E+xL1kDsiwkHC9JrKGgKgzX7YxQ6yIRFAG2MZM++HDF2C1cJDMrQijsFES5DvGJsA3/9lzRtL6SggWWTofHmgmZkFAYQu7eERh14Y7EXGjrYNeM8IcVleObUV+KwlzNrRWLcojdjbIu15vySY3pEm0okTLguJLUGHScK3z3umjyDZFMHuv54Diyw8aG7JFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YiV9YTIDdojlOtKNkA/+q17MvJnoCYKOPmsC5JbK7kc=;
 b=LhrwmAJN502a8ylzDtM9HEIZLu4yEHi17jnwYT2E3sP9j5+4ODfAIME6aCv68qq0xHwihBbRGK8iFRSKAmFmlzSgdDKefEgrRnm1iF2FZgsFJQ5kwtqDD4TOsoVzfwB95q30nhEiU4l7vlo6unX3Kj862KbvpCJ8RvyVSv0z+0r4exwhfP+DouebhD3q8gty8bu/SepfXbuKcvg4d7nOkyMK5N0rFrVNwMSE+0AQ0GVM7NUcCOiWdXg69OQBpt5VErP+Qlbn4k8Vxsm95yfWFK7l14gy4zYVQSC8gIUyTXhHnEwHfScPKVRqrMdlgK1Ex2Krf5/6J/HgbJb4HaL31g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiV9YTIDdojlOtKNkA/+q17MvJnoCYKOPmsC5JbK7kc=;
 b=We4C3EPlsfJ673NgDZDg+easFOJ47RKbUCWSGR509PUY5sBZuzCQlWX204eGkySQJGTDRBvKu3FY06BnxfgNrBM8UjScwiUHL03ExSDbWfmR4KcqxHjtk2qp07xUuMAUsQct/5PneacXVczJjegv5YRnyF3BXPr5BjL+zeS7Awo=
Received: from BN9PR03CA0470.namprd03.prod.outlook.com (2603:10b6:408:139::25)
 by DS4PPFEAFA21C69.namprd10.prod.outlook.com (2603:10b6:f:fc00::d54) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 08:12:58 +0000
Received: from LV8PEPF00000059.namprd02.prod.outlook.com
 (2603:10b6:408:139:cafe::4f) by BN9PR03CA0470.outlook.office365.com
 (2603:10b6:408:139::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:12:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.194; helo=lewvzet200.ext.ti.com; pr=C
Received: from lewvzet200.ext.ti.com (198.47.23.194) by
 LV8PEPF00000059.mail.protection.outlook.com (10.167.245.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:12:57 +0000
Received: from DLEE207.ent.ti.com (157.170.170.95) by lewvzet200.ext.ti.com
 (10.4.14.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:40 -0600
Received: from DLEE210.ent.ti.com (157.170.170.112) by DLEE207.ent.ti.com
 (157.170.170.95) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:39 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DLEE210.ent.ti.com
 (157.170.170.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:39 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8Cc2Q1455931;
	Thu, 12 Nov 2026 02:12:38 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 07/15] crypto: ti - Separate padding buffer for src and dst
Date: Thu, 12 Nov 2026 13:41:55 +0530
Message-ID: <20261112081204.1146395-8-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261112081204.1146395-1-t-pratham@ti.com>
References: <20261112081204.1146395-1-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: LV8PEPF00000059:EE_|DS4PPFEAFA21C69:EE_
X-MS-Office365-Filtering-Correlation-Id: bd19f444-bbbf-44c1-b9df-08df4094c2c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|376014|22082099003|18002099003|261009223027099003|56012099006|261028144727099003|261021121427099003|261102123227099003|261026140227099003|261026121527099003|261021123027099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	MCz0fmLx2N2VP+53Nf5RTKVmlKrroaYNAh13m+Ex+mXS82cxrWa4Wsz9IKnPS+Oa8QSN3a3laqyS4roJh/n7Tu46xDh8SEUn3R/jDRcfIIqiV3Zk2C7IQjinsZmHffEdgIMtibSbw3u0ZuYzphwzPP7Xo2moceTRWDUoP17Lr47b63CZ8OdkGcPah/Jnv3oUZukkVW7ujJRUqW5WPt0+OrpoO9QfZmZQKafcTyFK37fG6rhkyxXUjitZovai1cm8aYXOXOP7/C4Kx1pd/2DXqg1LxsK20o+bmxsHJ2n2vHs7JIoZZgsn22pDAeuPCSv8LLV/lS9NbmGJ7WV5qn9eGt0gxBNcRm1fH+SNM/m5UHgDT8oRydVwRfTPS93UcpNUnDBYQENaR3XhGS/9/OyEzc7SyCS8fFE9Xge4FUmoSmFNWKWcdAaIPrXBF4PklsCH9JVAeThrtHcASRRI1xL4t2tAD9pkJLRH9cMlIvgTOUsnnGhDjr8ELwejHdb+d5PDc5XTUJZ0InSdZztnmuY5AfXuHeG0nOhF/VOx64Z+98kOZ8acy0oiIJbOrl5oYeHSjV5T8Xd1sZTaze6oxYMzHFgIderrE8IZe9ahKcqjRBnipWI24Ww1hdJUyGNTtBTSVaJF1XZAehn0TcNyKaAS0D/L2b4KSzxJ+y+sLcd/DFPl1auAlBc29/KajwZ2ZwR/elK3z94CIEda00TAkNPqWw==
X-Forefront-Antispam-Report:
	CIP:198.47.23.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet200.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(376014)(22082099003)(18002099003)(261009223027099003)(56012099006)(261028144727099003)(261021121427099003)(261102123227099003)(261026140227099003)(261026121527099003)(261021123027099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	uwnsj/dV/71Bf/oVoVsResBsPqsIaxfKV7J/juNrqaPqLeZUSLOJCgQVUMPlT3EpkQaC38VQxwRJHSiPbZhide0gj9Fsz7tNnc4DvfObek9wCV8IgDLs+ffs8bcfG5iZrmeZjcFga8j9jC9Lqlimjh8WCDQePVZ56+ZNt8SRGTBl/7JTp7DUe/EzCxU2ZxZSZEBgljFJvD8Ovh4qejwtlnA8XGvBDQvjDgDPwz9ESssFMb53JL66g5DQ/fUQx7snoPoXRCPJ8cTyrFq4y5i0Xbz5hhF5QlD2YURMjJS34KhN3EFAhvt5TQPjIHkT3CkbghlKGgIjoP23KipYg70HdNb1+XuI85kZRQiL8Yvi/FwJEl5vN3buYzTYPCcNHovjIqcrGvfxXuKNRFC8lo6rInWz7SDKwjjHDshoqJ0C86PWRGx+z3JDSFzvO37EjGf4
X-Exchange-RoutingPolicyChecked:
	wljci3RveN6lg4uhqdm8mEZpPFOTV44RVa9Y6h8Bd4oW2jO9m1Ksk9NbEOOayfmtaOkzjfi4/0jAI5mYLMiwBYRwvqOtTSYsdtqKJDKPUrhheGugkehVN41vTs+Sgh5NJYfwrnwrInZHNQHi/kSd4X6fGGOlFnVrWLY+3EntgI3Elybb5nfNUaIOZim549wW/PuIdXDdVO3g/duZ8RwiniF+Jz0VVr/OU4YA5c8YiD1fhKyehKwRlmWYlpilXb7a0LF5/Z3DYcLAs9Jh7X6x3P2vpPUaB8WmSQYy4TMI9QxkXBHR/wNrvHAUm6iA8jRYxODVxx6t/4hBYiGQIn1quw==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:12:57.5755
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bd19f444-bbbf-44c1-b9df-08df4094c2c5
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.194];Helo=[lewvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	LV8PEPF00000059.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFEAFA21C69
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX+ZYVCH20vUeX
 ip75uF7Zp6xV8i40Q9mHLb6XKuWUsQ6oKcW1/F7UrIukdrwL0+DIfA1xn0KI6fY/eFBZWV6SQNf
 jW0K0cu/YWVULMYaAeThjp6eS/TUHTQ=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6af5750e cx=c_pps
 a=Ie8oki5xhBv/1/1SVvCQdA==:117 a=WotqVVQAdb04rnGuttW3Kw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=cnFjqbEhF75hnMYoCLMA:9
X-Proofpoint-GUID: bY96oFS9ys5HgnYtQKLnikZDCBJ3Mgho
X-Proofpoint-ORIG-GUID: bY96oFS9ys5HgnYtQKLnikZDCBJ3Mgho
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfXyJLzTCbNAOfS
 wWaoyutivd0xzJ6qJ8a0pvK4SqHNpG4ka7s0Xmo6Y+rCEGgjee4TCmu9RNpG+x3VOvhnBuTW3Mq
 Er42OnjTCdwoyNWv76B8i4d3bpU0VBj10TMexGx3mz4Mhx8g5mfVvGBjFBSX3KIJTEEaWRZYSzv
 7OjUxaiJhOJRUtbD6dZE7yPqnRYgtmjqHxWiRPOn8fU/3Bp1muzS/VO4mIEENoKpY2n8fsDKnCV
 P7Zu+ky7dLJCyNEJxCVMBIZYK4ubaSSBC4zsw3Vgfcz1Ywmxp+NBlF7r6vHtSz9GZVWtVjEA3O7
 gPpzX3I40k40z3Izm2taraFZGsfa/dknSDulHTcJ52idqU43sMhOiwvrn+VZ3M/c9BurAPHzemm
 w1RryubaWkcFjVPKpGy8f1g5lqOlWKH0S0ibC0bnFrBvj/NeJhPhOOzEonCn2QZVrOVGAsWmSex
 ptAxzF7a5XT0CN5oQnQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

Separate the padding buffer, which is allocated in the req ctx, for src
and dst scatterlist to avoid any DMA mapping issues when not doing
inline operations. In such cases, the current code was mapping the same
padding buffer twice which might cause issues. Also move them into
differnt groups in __dma_from_device_group_begin/end() to separate the
cache lines for transports of different directions.

Fixes: 35645ca63caa1 ("crypto: ti - Add support for AES-CTR in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c    | 29 +++++++++++++++++++----------
 drivers/crypto/ti/dthev2-common.h | 14 ++++++++++----
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 1a37150496ae8..ef053264a5541 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -338,6 +338,9 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents;
 	int dst_mapped_nents;
 
+	u8 *src_padding = rctx->src_padding;
+	u8 *dst_padding = rctx->dst_padding;
+
 	bool diff_dst;
 	enum dma_data_direction src_dir, dst_dir;
 
@@ -388,8 +391,8 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	sg_init_table(src, src_nents);
 	sg = dthe_copy_sg(src, req->src, req->cryptlen);
 	if (pad_len > 0) {
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		sg_set_buf(sg, rctx->padding, pad_len);
+		memzero_explicit(src_padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, src_padding, pad_len);
 	}
 
 	if (diff_dst) {
@@ -401,8 +404,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 
 		sg_init_table(dst, dst_nents);
 		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-		if (pad_len > 0)
-			sg_set_buf(sg, rctx->padding, pad_len);
+		if (pad_len > 0) {
+			memzero_explicit(dst_padding, AES_BLOCK_SIZE);
+			sg_set_buf(sg, dst_padding, pad_len);
+		}
 	} else {
 		dst = src;
 	}
@@ -491,8 +496,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
-		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+		memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+		memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
+	}
 	if (diff_dst)
 		kfree(dst);
 
@@ -880,9 +887,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	int src_mapped_nents = 0;
 	int dst_mapped_nents = 0;
 
-	u8 *src_assoc_padbuf = rctx->padding;
-	u8 *src_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
-	u8 *dst_crypt_padbuf = rctx->padding + AES_BLOCK_SIZE;
+	u8 *src_assoc_padbuf = rctx->aad_padding;
+	u8 *src_crypt_padbuf = rctx->src_padding;
+	u8 *dst_crypt_padbuf = rctx->dst_padding;
 
 	bool diff_dst;
 	enum dma_data_direction aad_dir, src_dir, dst_dir;
@@ -1125,7 +1132,9 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 		kfree(aad_sg);
 
 aead_prep_aad_err:
-	memzero_explicit(rctx->padding, 2 * AES_BLOCK_SIZE);
+	memzero_explicit(rctx->aad_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
+	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
 	if (ret)
 		ret = dthe_aead_do_fallback(req);
diff --git a/drivers/crypto/ti/dthev2-common.h b/drivers/crypto/ti/dthev2-common.h
index cc20538ad6f36..f1b0396b322a0 100644
--- a/drivers/crypto/ti/dthev2-common.h
+++ b/drivers/crypto/ti/dthev2-common.h
@@ -108,15 +108,21 @@ struct dthe_tfm_ctx {
 /**
  * struct dthe_aes_req_ctx - AES engine req ctx struct
  * @enc: flag indicating encryption or decryption operation
- * @padding: padding buffer for handling unaligned data
+ * @src_padding: padding buffer for handling unaligned data in src
+ * @aad_padding: padding buffer for handling unaligned data in aad
+ * @dst_padding: padding buffer for handling unaligned data in dst
  * @aes_compl: Completion variable for use in manual completion in case of DMA callback failure
  * @dev_data: Device data struct pointer
  */
 struct dthe_aes_req_ctx {
 	int enc;
-	__dma_from_device_group_begin();
-	u8 padding[2 * AES_BLOCK_SIZE];
-	__dma_from_device_group_end();
+	__dma_from_device_group_begin(to_device);
+	u8 src_padding[AES_BLOCK_SIZE];
+	u8 aad_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(to_device);
+	__dma_from_device_group_begin(from_device);
+	u8 dst_padding[AES_BLOCK_SIZE];
+	__dma_from_device_group_end(from_device);
 	struct completion aes_compl;
 	struct dthe_data *dev_data;
 };
-- 
2.34.1

