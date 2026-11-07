Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794067660;
	b=G4dsHC4rNT0ijPD5CXIqTe5dhfO69wPuO4xJO4IZWWZ3CNODn2j4FMw9+7lh3JXfl9WP
	 ENgJeYD9PwMgmi72JLZWUaPlpuHSXPCWywT9mLiqVs8rXy0F7eV+4k3nFQWGedo3/jJHw
	 8hFwL9U0eCSzJuK8Gbe0ZmWIJSLnRqcCb6qUUnPTLG18X9D3leQCfghBkYPHx2ixhYgod
	 U+H5kJTrxdV+Qlw9wFYlk9BCjsisdpy8rJPG92ejRhMIUDI8cpwsUaRO9m+zsTxweBm2Y
	 yeoXP7V+b5j1BS8jARkwjCxkXlpfJHzAiQQETHqvCaX78jrDMKpTx277mTPgy0jsGHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794067660;
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
	bh=NaeBV8iTV1y4BiMweDSyNmRbhNP9C3jw29TT+bjUORo=;
	b=1uA+gi2zgGlNT4Mig3q3nPzpNSdOsqzyMGw1QA0/55QkpJJyVs+1sZ+3gRDSfZGGqGDU
	 KqOL5dQ4PWky7fmpjCWNC27qbXv2iLYED3WCh2OW89v9k0hg0VcpDnyBpxP5oMid6G1uR
	 Q+032+H9AkHPApkzeDipfaWNQQMYylh+Jdttm3zExx3MqoadA8dE1UTvSa6fwA1DzLJoZ
	 dZef5DwYZ9WJcVuLIJl0hBPfmMPTrP2EaxphpgevRbnw9KBAlDe/Os6x4j9CjjY5DmJkX
	 MRTfV/I8YctzpQ1hophIqZRSSGIO3+sOwISjhx8+H02Xbt+teRqPY6cxT5CbTVuCgbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=UdOGmvRI;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=huJNNzSi;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C79606A331;
	Sat,  7 Nov 2026 16:07:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27C79606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=UdOGmvRI;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=huJNNzSi
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6A7ExqOg3866418;
	Sat, 7 Nov 2026 10:07:38 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=NaeBV8iTV1y4BiMweDSyNmRbhNP9C3jw29TT+bjUO
	Ro=; b=UdOGmvRIWJ/bg7FfoRDrLwseWFzqfp8Vz2q7QL/a6rov/iO//Z4Z0bYrE
	VKHWXD96ew6J8XakAaZfrHWYZoiu5uyDbhcZ+OeIRHNXW1GFXlVOqBshvPMPUjpY
	pvtqZFm3W6v6nmpBOvaG2yoV3Bynun8fb+CrUNJ/BEjAwM7HecgXYVPfEqUNUn76
	Ge+ucwOGKSlLuX/hVoMuzkwYm+qUImvDU0UyuIwMiruR2VNEcglk3N0fKTgt/IO0
	IvrDKGDmSGu8ixwHXiYxdXvKwAkAV8LH7YobZE7ExpukkUgKz2zFwoPLMaIJ5e2V
	FVwxGcZNPOQyXBygGfvxraYAjxw4A==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011044.outbound.protection.outlook.com [40.93.194.44])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hs3qmj07e-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sat, 07 Nov 2026 10:07:37 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yCQrjCCe2FFoWEHJnvV1vAxM03zOtplKAqFyrPFI6hHDYDFUXnFWT7TPoGgLHhULvG4A5uVuFN8XstLF1WporrK5ar47yJCssCAGsOcSBLOCGL2NqHTy5mgcZRXaWdcz/wHsT9e2SMkaB+DVXcwOxNj+3BMG0Ti9db5dOoE35HsDhWSzfe9mqdn07xQ+VIlwW0GR2tXozq8rbDfEk3kVTEKsp9PunmARXMibG54Z1CeCNHUs9B7LcHfNp5JTB5Fk+lRJtt0TgaVHH/F9kngaU1qPuYjt3Ob3KgvT6YHovUujfi06WiplanM/Xa9ntLd+RgXzbKAOM0ZyfJ4+uLCSCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NaeBV8iTV1y4BiMweDSyNmRbhNP9C3jw29TT+bjUORo=;
 b=jqamYeKr6D8FKC+7I2aXar8xuJbxEp6Hrg1fGCe/mLtBtAe4lbA+L8+0Z9zUDSuyK9PMQzTdCqt7degQNwhZkdPQs6T3eVcraaxhJthQb+QmDmgNBrAtyrJ1Z6F3SSB2WV3lDI79FJNtP1g8fMtZViKGWzba6FSCRHl3b2MZK446fQgCS4iWD8ksi0/MjEoZea99Tg7DzKW372VEdgbxOkOUvvGOJbuQc0yFZBOyOrvaMEOCTzNaCmhPGPVAdT/TOxwoT3OnAm/mmc7seI6tA3vl8yX6p/E33x2K/PZhhjmlldcJrEY0olqS4fCFvteTQSt0qeVfv6f0Kj1ZrekYuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NaeBV8iTV1y4BiMweDSyNmRbhNP9C3jw29TT+bjUORo=;
 b=huJNNzSiIsG+op19Rx36xYi0fEEF9+mZoZHgcIK8I+MZYCKUI586ylZaurTtFcr6lTulyAGd6MJmm6yGwQD6Y8KogaFvKUw5f1zZyoXEdfWav0wsHUBHJ4A2afo720ogq0asWwgNSxqBC+wBmfAYZaYGHFtAXX93mJyeFMGNBL0=
Received: from BN9PR03CA0913.namprd03.prod.outlook.com (2603:10b6:408:107::18)
 by IA3PR10MB8321.namprd10.prod.outlook.com (2603:10b6:208:575::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Sat, 7 Nov
 2026 16:07:29 +0000
Received: from BL2PEPF000352CC.namprd02.prod.outlook.com
 (2603:10b6:408:107:cafe::26) by BN9PR03CA0913.outlook.office365.com
 (2603:10b6:408:107::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.11 via Frontend Transport; Sat, 7
 Nov 2026 16:07:29 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 BL2PEPF000352CC.mail.protection.outlook.com (10.167.249.134) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Sat, 7 Nov 2026 16:07:28 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:01 -0600
Received: from DFLE209.ent.ti.com (10.64.6.67) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Sat, 7 Nov
 2026 10:07:00 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE209.ent.ti.com
 (10.64.6.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Sat, 7 Nov 2026 10:07:00 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6A7G6xdc276997;
	Sat, 7 Nov 2026 10:07:00 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 05/15] crypto: ti - Trim scatterlists to correct length in AES
Date: Sat, 7 Nov 2026 21:36:20 +0530
Message-ID: <20261107160631.2592763-6-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: BL2PEPF000352CC:EE_|IA3PR10MB8321:EE_
X-MS-Office365-Filtering-Correlation-Id: 0773a6d4-b4be-4649-924b-08df3ce938c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|82310400026|23010399003|1800799024|261026135527099003|56012099006|6133799003|261026140227099003|261026130827099003|18002099003|22082099003|261028144727099003|261102123227099003|10067099003|261021133027099003|261021130227099003|261021121427099003|261009223027099003|261022113327099003|261021135927099003|261022105027099003|261022115727099003|261022075727099003|261026121527099003|261021123027099003;
X-Microsoft-Antispam-Message-Info:
	iQSLgsHw0aYclNUmsQsf/BDe3eJJzapjqNJPvl5O4m891Z4+6JiV7A8kZLSNRTkMDAx0Intsz6b6hNxv9vvgQHytPapLwHdzV2qC8RAb6R2bV1RXS9fFw2fLVTAuF2DWJvCstLyX4mMPAToYnR3bwNRxAyMnZkr4ilxrjI9bqHrJnpprqCWbwMmNwDo358Mfm3P6dBZ5F/GwlmnlyKacwhRQXDo1bztqwHgl6OEMp86RwvOsuQzxfcWKHrSQ3XlJuYa2zEKwQGNCjguFiQJ/F6xQ8QXMBOSUYE4jlhJk32VHMK9M6UJXAo1QJaeCnMZ8Fe71aNKmZ4qxrUpJdOi0pQ+Qi7WqLRzVqAdoba9hh9rMDrCnNKk+E7MAmHhFCl3S9Y9iomLD0p5kUs2Yfmd+AFwsuBIw1W5HzdVlyec8ufAY3v5rLFS92CMcvcqrmE7DdUKyBrJnvpWP3yNEmIAT1MlD3OPVyVvYrMsAHkc8cm/C4ZVncuZ2tu4ZVbtuDalESm53PZP7yYkmLyNFasq6xaCVZvXaN1iKKtFS+xpJNTPSM9emR6r/bmLJLj7S3o9q3NjUqG3gyuyDOcj7oB+ho5ZF7i8DEKRYhOE8pi5q9jdJj6kLFtQjLrGX9nc6iovJEFU5rochYK9gRdBjlOmiI2wfJWHRru89VA2DFTsxpuNdMU6uRpNzEbXEJrZM8Vq/N8Uz8lJT5EhMZ45pbEOxRg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(36860700016)(82310400026)(23010399003)(1800799024)(261026135527099003)(56012099006)(6133799003)(261026140227099003)(261026130827099003)(18002099003)(22082099003)(261028144727099003)(261102123227099003)(10067099003)(261021133027099003)(261021130227099003)(261021121427099003)(261009223027099003)(261022113327099003)(261021135927099003)(261022105027099003)(261022115727099003)(261022075727099003)(261026121527099003)(261021123027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mAryYsY0vM9OzAm0ab3Y1VgJWwwYo1qC0mXQR5vfdCxhPUrApFYdmqCWlclFTOOEsbo6NwZF+DnVApNPMRetywU4pF7BQKcQhbFugwo//vWtdU3dFd7KH/qBqHw+lLi44RyQ8q1q024zBQEevBGs7Fp1loiLiT+ijPFKvJuIqOXdHC51LYKSonTxZZVw3mpyfsQ6HyXXFMy2Ib+qgJJ3rORfYJj5v+KFbzXLtl22UlmxAMMj/4e06j9OfV4mmtCxcbU4CsSo1vBOJ1CwUQeA+OqDVefiBr2fLdN5CXcT3/Zel543o6sSQjPzziS45uNsXX8Y9Kg2XI9pucwsZXIRJYumYSVsaukthDBfCuAATldDpKHQfRd//OaOu5AWtIcBHEWGVZKBrqCasmAfhoFHP4muqo+I9BC6s1frOxjTwxTru1hBHUznmLSMm6O4hsnT
X-Exchange-RoutingPolicyChecked:
	yG/zNUuRm2FcPk6n8g+sI1cmGIJbJ3sYKL6iG4xQ7wRSIiGMPjCAOWMbll9OIuxtlJFedKX/PY973EnkLKCpTG2Vj0XCvofP3vzVd5OtTZMSH6Rl3ir9YvZNWRT3tWeVEBK5UXoGwIIMSWpRdR0S/tduLtdDdxuc1azZL50aOE7u130zC8wPhUQsybZtXdoH+ZPbLVnzMAXWO6Oo9qhqN5rWDJ7FwKf+rSpsAr8v+vKJFETetdkTv2RzZ+V3VME1O4pntlKw3ROJXXcOTtFkZCX7qhBExepa9rUmRP7hV5G7/2aSLbKKbbtqx70EvJi54SFS0IBHOnQtL5tCe9bbug==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2026 16:07:28.6945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0773a6d4-b4be-4649-924b-08df3ce938c8
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL2PEPF000352CC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8321
X-Authority-Analysis: v=2.4 cv=F63C5ahN c=1 sm=1 tr=0 ts=6aef4cc9 cx=c_pps
 a=IGlUesXJXvI2YQKUC5af4g==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=sozttTNsAAAA:8 a=J8wK4BBRFcl5aWuvIT0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfX0doKX2GnosRR
 YBflnjQONHxdzGfzy/TpTuSsHO3mTWq5zEIdcc74zylVHu5nHttDhadlkBW8kfoi8n19MXUiOar
 BkdQcPWi7u6uBglpchbPPoX+sl+NJWA5AH16gnSzwbAuLlkvsPqu9fl8f7aZP/FkhCiCdek4+Nq
 N26mn8N8QbhRcMnAfZVUapw8v1wKL2N/CJUPCm0II662ueVptLp2xeW7tZH6EC7dzXSfSkC2RRX
 5i8nRYNbK0g4RXSeoOGxFFzx6lgQpc/Ektebepuy0RGncQjMBZYJcjsLAw4DcJJ2xjEA2Co2TMO
 hrYLOK72RG8HV3aMGNV2yrzgbfyI4/SXWhT/uThkSYYT5vMDzEQHW+pb+NvfTekhudxn+66Y0wF
 hR9KapDKwc+KimjvYUDNl/+u6c2aNlKvuYwSO7C8Q00pvGvkTCDD4PxtjxRTkA+B7lBIe1GglKt
 Yc72g+3SUicv62Gb5JA==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA3MDA2NCBTYWx0ZWRfXwTVhkp9GGF+k
 9Um1C7sJXOAgjtzYvhXOranV6dyONxIhCOSoySJZFFP3Qtq7q3+VRMUWf/F/oOcSsXqx7ZxiExX
 DiMFBBHyibSiuo6tweWZTtR3T49tfB8=
X-Proofpoint-ORIG-GUID: wuS80tgd5APJ-eFDBmxmoLRsQ1UmOWF_
X-Proofpoint-GUID: wuS80tgd5APJ-eFDBmxmoLRsQ1UmOWF_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-07_05,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0
 spamscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611070064

AES functions were using src and dst scatterlists directly provided by
the request. This is problematic as it is not guaranteed that the input
scatterlist is exactly the length reqired. This problem was seen in
IPSec use case when the kernel provides the scatterlist which contains
space for plaintext/ciphertext and TAG.

The problem comes when the scatterlist is mapped and sent via DMA. The
K3 UDMA sends/waits for the amount of data equal to the length of
scatterlist mapped. So when the last mapped nent contains some extra
length, the DMA keeps waiting for the extra data and eventually times
out and crashes.

Mitigate this by copying the nents to a local scatterlist, copying only
exactly cryptlen of data. Note that this does not copy the whole data,
but rather only the scatterlist mapping. So it is not as penalising on
performance.

Fixes: 52f641bc63a4 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
Reviewed-by: Kamlesh Gurudasani <kamlesh@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 147 +++++++++++++++------------------
 1 file changed, 68 insertions(+), 79 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index 75361afa1b3f3..b801f9fdcb87b 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -108,20 +108,6 @@ enum aes_ctrl_mode_masks {
 #define POLL_TIMEOUT_INTERVAL			HZ
 
 static int dthe_cipher_init_tfm(struct crypto_skcipher *tfm)
-{
-	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	ctx->dev = dthe_get_dev();
-	if (!ctx->dev)
-		return -ENODEV;
-
-	ctx->keylen = 0;
-	ctx->skcipher_fb = NULL;
-
-	return 0;
-}
-
-static int dthe_cipher_init_tfm_fallback(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(tfm));
@@ -147,8 +133,7 @@ static void dthe_cipher_exit_tfm(struct crypto_skcipher *tfm)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (ctx->skcipher_fb)
-		crypto_free_sync_skcipher(ctx->skcipher_fb);
+	crypto_free_sync_skcipher(ctx->skcipher_fb);
 	dthe_put_dev(ctx->dev);
 }
 
@@ -156,19 +141,24 @@ static int dthe_aes_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
-	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
-		return -EINVAL;
-
 	ctx->keylen = keylen;
 	memcpy(ctx->key, key, keylen);
 
-	return 0;
+	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
+	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
+				       crypto_skcipher_get_flags(tfm) &
+				       CRYPTO_TFM_REQ_MASK);
+
+	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
 }
 
 static int dthe_aes_ecb_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_ECB;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -178,6 +168,9 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
+
 	ctx->aes_mode = DTHE_AES_CBC;
 
 	return dthe_aes_setkey(tfm, key, keylen);
@@ -186,24 +179,19 @@ static int dthe_aes_cbc_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 static int dthe_aes_ctr_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
-	int ret = dthe_aes_setkey(tfm, key, keylen);
 
-	if (ret)
-		return ret;
+	if (keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_192 && keylen != AES_KEYSIZE_256)
+		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_CTR;
 
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
-
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	return dthe_aes_setkey(tfm, key, keylen);
 }
 
 static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsigned int keylen)
 {
 	struct dthe_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	int ret;
 
 	if (keylen != 2 * AES_KEYSIZE_128 &&
 	    keylen != 2 * AES_KEYSIZE_192 &&
@@ -211,15 +199,12 @@ static int dthe_aes_xts_setkey(struct crypto_skcipher *tfm, const u8 *key, unsig
 		return -EINVAL;
 
 	ctx->aes_mode = DTHE_AES_XTS;
-	ctx->keylen = keylen / 2;
-	memcpy(ctx->key, key, keylen);
-
-	crypto_sync_skcipher_clear_flags(ctx->skcipher_fb, CRYPTO_TFM_REQ_MASK);
-	crypto_sync_skcipher_set_flags(ctx->skcipher_fb,
-				       crypto_skcipher_get_flags(tfm) &
-				       CRYPTO_TFM_REQ_MASK);
+	ret = dthe_aes_setkey(tfm, key, keylen);
+	if (ret)
+		return ret;
 
-	return crypto_sync_skcipher_setkey(ctx->skcipher_fb, key, keylen);
+	ctx->keylen = keylen / 2;
+	return 0;
 }
 
 static void dthe_aes_set_ctrl_key(struct dthe_tfm_ctx *ctx,
@@ -342,8 +327,10 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	struct dthe_data *dev_data = rctx->dev_data;
 
 	unsigned int len = req->cryptlen;
+	unsigned int pad_len = 0;
 	struct scatterlist *src = req->src;
 	struct scatterlist *dst = req->dst;
+	struct scatterlist *sg;
 
 	int src_nents = sg_nents_for_len(src, len);
 	int dst_nents = sg_nents_for_len(dst, len);
@@ -386,38 +373,38 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	 * We need to handle the padding in the driver.
 	 */
 	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
-		unsigned int pad_size = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
-		u8 *pad_buf = rctx->padding;
-		struct scatterlist *sg;
-
-		len += pad_size;
+		pad_len = AES_BLOCK_SIZE - (req->cryptlen % AES_BLOCK_SIZE);
+		len += pad_len;
 		src_nents++;
 		dst_nents++;
+	}
 
-		src = kmalloc_objs(*src, src_nents, GFP_ATOMIC);
-		if (!src) {
-			ret = -ENOMEM;
-			goto aes_ctr_src_alloc_err;
-		}
-
-		sg_init_table(src, src_nents);
-		sg = dthe_copy_sg(src, req->src, req->cryptlen);
-		memzero_explicit(pad_buf, AES_BLOCK_SIZE);
-		sg_set_buf(sg, pad_buf, pad_size);
+	src = kmalloc_objs(*src, src_nents, GFP_ATOMIC);
+	if (!src) {
+		ret = -ENOMEM;
+		goto aes_src_alloc_err;
+	}
 
-		if (diff_dst) {
-			dst = kmalloc_objs(*dst, dst_nents, GFP_ATOMIC);
-			if (!dst) {
-				ret = -ENOMEM;
-				goto aes_ctr_dst_alloc_err;
-			}
+	sg_init_table(src, src_nents);
+	sg = dthe_copy_sg(src, req->src, req->cryptlen);
+	if (pad_len > 0) {
+		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
+		sg_set_buf(sg, rctx->padding, pad_len);
+	}
 
-			sg_init_table(dst, dst_nents);
-			sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
-			sg_set_buf(sg, pad_buf, pad_size);
-		} else {
-			dst = src;
+	if (diff_dst) {
+		dst = kmalloc_objs(*dst, dst_nents, GFP_ATOMIC);
+		if (!dst) {
+			ret = -ENOMEM;
+			goto aes_dst_alloc_err;
 		}
+
+		sg_init_table(dst, dst_nents);
+		sg = dthe_copy_sg(dst, req->dst, req->cryptlen);
+		if (pad_len > 0)
+			sg_set_buf(sg, rctx->padding, pad_len);
+	} else {
+		dst = src;
 	}
 
 	tx_dev = dmaengine_get_dma_device(dev_data->dma_aes_tx);
@@ -504,19 +491,19 @@ static int dthe_aes_run(struct crypto_engine *engine, void *areq)
 	dma_unmap_sg(tx_dev, src, src_nents, src_dir);
 
 aes_map_src_err:
-	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE) {
+	if (ctx->aes_mode == DTHE_AES_CTR && req->cryptlen % AES_BLOCK_SIZE)
 		memzero_explicit(rctx->padding, AES_BLOCK_SIZE);
-		if (diff_dst)
-			kfree(dst);
-aes_ctr_dst_alloc_err:
-		kfree(src);
-aes_ctr_src_alloc_err:
-		/*
-		 * Fallback to software if ENOMEM
-		 */
-		if (ret == -ENOMEM)
-			ret = dthe_aes_do_fallback(req);
-	}
+	if (diff_dst)
+		kfree(dst);
+
+aes_dst_alloc_err:
+	kfree(src);
+aes_src_alloc_err:
+	/*
+	 * Fallback to software if ENOMEM
+	 */
+	if (ret == -ENOMEM)
+		ret = dthe_aes_do_fallback(req);
 
 	local_bh_disable();
 	crypto_finalize_skcipher_request(dev_data->engine, req, ret);
@@ -1254,7 +1241,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1278,7 +1266,8 @@ static struct skcipher_engine_alg cipher_algs[] = {
 			.cra_priority		= 299,
 			.cra_flags		= CRYPTO_ALG_TYPE_SKCIPHER |
 						  CRYPTO_ALG_ASYNC |
-						  CRYPTO_ALG_KERN_DRIVER_ONLY,
+						  CRYPTO_ALG_KERN_DRIVER_ONLY |
+						  CRYPTO_ALG_NEED_FALLBACK,
 			.cra_alignmask		= AES_BLOCK_SIZE - 1,
 			.cra_blocksize		= AES_BLOCK_SIZE,
 			.cra_ctxsize		= sizeof(struct dthe_tfm_ctx),
@@ -1288,7 +1277,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CBC AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_ctr_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
@@ -1313,7 +1302,7 @@ static struct skcipher_engine_alg cipher_algs[] = {
 		.op.do_one_request = dthe_aes_run,
 	}, /* CTR AES */
 	{
-		.base.init			= dthe_cipher_init_tfm_fallback,
+		.base.init			= dthe_cipher_init_tfm,
 		.base.exit			= dthe_cipher_exit_tfm,
 		.base.setkey			= dthe_aes_xts_setkey,
 		.base.encrypt			= dthe_aes_encrypt,
-- 
2.34.1

