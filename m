Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471171;
	b=BZTjlKYkzB2VS2YdZzppBlGnResCVJMick6yqmdMyGbeQIJAWM3xE9aAwoPAAtGV4E8V
	 I3wFRWYcke4rWQVmhVPS/6Vbti2UmCTRHl01UV1l31M5cdr6+PkGFYzK4HiTKdqSOUJAl
	 j9JbfzlsOdmV2rvYwRGF1Y8vADNMJDpu0u1cTcqDv6PoBQES9hhPi3ru/VHdUL1LVanEN
	 LE/ltVR62a1BJ2dwiWg/yhdcA2tR4Po+06vKKAk3kQSroQgW2PoNorkO7Gs2sA2M6xX8v
	 rWt3UxifwHPIavwbAvnrP4jr3SthjklUZigMlL7jPTEGgxDvfBWtCS+tHgwo4aTeWhA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471171;
	h=DMARC-Filter:Received:DKIM-Signature:Received:DKIM-Signature:
	 Received:Received:X-MS-Exchange-Authentication-Results:Received-SPF:
	 Received:Received:Received:Received:Received:From:To:CC:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-EOPAttributedMessage:X-MS-PublicTrafficType:
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
	 X-Proofpoint-Spam-Info:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=/PU0i/XN7VmMuTdWkHCJaeBqdPqSqds4H1KbMIVIEoQ=;
	b=hdtrGln9jaNaE2GERE+g2tnSUvFOTJ64+OygoXSBiAVtQKq3R8fnH7SONeow8TGEOwRT
	 mtullQGfIog3vBL1u9Tp/asOvFq6skVVfNqek3eo0Kh/7KiVOeKEPGtbA3xlU3syStB4e
	 Zna0hKc3bEi6KzDhA30HNYPkfVyesQsIb3jyeABetCT0+MsCV4im1i5FFrCOLPnPcEyG0
	 ZwUlsWRyLXySyOryaGLjuUKJvX/5kb8j81gmgJW22fO2I4JiFfJuJ9Sf2O7vXDxxdi+ww
	 IereVqPemo06sk3pCq4iqA/j2Dcfjf5PKA/WugqkOQeWIohYKDWgQPMpB8jX6YYbCYQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=hzpticis;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=OMYXKP3e;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE6F606A32E;
	Thu, 12 Nov 2026 08:12:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6AE6F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=hzpticis;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=OMYXKP3e
Received: from pps.filterd (m0384305.ppops.net [127.0.0.1])
	by m0384305.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC7nup93094898;
	Thu, 12 Nov 2026 02:12:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=/PU0i/XN7VmMu
	TdWkHCJaeBqdPqSqds4H1KbMIVIEoQ=; b=hzpticisZUjrlPObOe488yc7QvnfO
	c1Ahtpw1CTpRJaql3HmTCoybSLnSm7DbVYrMAWvL79c/InVSyopiHvN5PSwMlgdh
	E5952b0PcM+5wMxQ2fIlZSDqf2WbnreyAxNznG2/nycsdUHDG1/WNVrJ79aLGwm6
	r47Gq4pcno93UdXZZoxCqiPu2ampLJ2AlUEszeiaVr15UO+UAVqV/ucD4AQhig17
	o3IEbTkCqzO5WCSh+9mPLCdc/+iR5kWnBS7cGKVSkbUagOpx/eKJfd/RmJl9Aosa
	jNamhXnO1RdBkWP6DMS4fsJcrw/Xa0/QslQWMTAoi0xSXau/PK/lEN9ng==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	by m0384305.ppops.net (PPS) with ESMTPS id 4hw4cy1vat-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:12:46 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbOHbQIRjtDEXFDqNX00JOQFc0CkdDE1gwOFGecG2IyXYcFaWzuGgcGwJEd4FF49R4u9T2pxlbQtRvRA7O6RMHynSOat0VGgJXImxqoMyx1wlaHo+iYhps1xKat1gBs2Pxkm13R7Ntn834UOp3vfqV7FmEEwsZoNd+RBtzW8uxFUMN+OUFHyV9r8qz3Bqchd6HCWs1d66CKR56q85+ghLPRL84YdSArEPQj3DLguRkGtfJO3BNo5it2SU//BPdL0xxCd0GP+hmr0I/QBdHJQrLdhLUjR3ckgUxHZOipMFdghNC46l4QKTJb3NTMazDSH8hKr9On5plsker66OhOjNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/PU0i/XN7VmMuTdWkHCJaeBqdPqSqds4H1KbMIVIEoQ=;
 b=ho3r9MWuVoqtqYe2HjG5/WGPzY374Szjzw0Q6g+aCSN6WOn4B7TljSU2kNshiRTaLKtUI+EkXlnBrWkLGS59A/87avjZJpX9I5GEMjKx85s9b6mQsdRACDluetYY97OCWd6OfzOhPRl/MdmWu1P0iQnKvqJqWGKEzHp8TRpYAsyLBGUZL2xieNwjDDbOCvkTpm2djs3XwCgYU/ul58aw8eyVEhze08U2Zrptz9YLo7sM06yt6KrOTefQ5XqDy98ue5TtKWa4xPbnmnsYduHCYgmnM9dgDPXSLDkUI0FimAoHN+pQ4jr5x6elqnZGWc94pzm6h53FH8Tb01fxy837Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/PU0i/XN7VmMuTdWkHCJaeBqdPqSqds4H1KbMIVIEoQ=;
 b=OMYXKP3e3k5DsLxr3mBicBbA+fyWU+y5U4jL7JipF51b/HvrRRdjSWCNhbXQ5lknbMYEmQPjVDlDjYD9X9Jm6cszx+y2yxPF/7KPFnysN36hFVOSmsOzFV1bIUdL7IOvnTZbF/qwD/Dt4QFKKVnwZCEUDBMKy/8pmuAv7wEDEec=
Received: from CY5PR15CA0052.namprd15.prod.outlook.com (2603:10b6:930:1b::9)
 by CH0PR10MB4971.namprd10.prod.outlook.com (2603:10b6:610:c3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 08:12:43 +0000
Received: from SN1PEPF000397B5.namprd05.prod.outlook.com
 (2603:10b6:930:1b:cafe::2) by CY5PR15CA0052.outlook.office365.com
 (2603:10b6:930:1b::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:12:43 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SN1PEPF000397B5.mail.protection.outlook.com (10.167.248.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:12:42 +0000
Received: from DFLE212.ent.ti.com (10.64.6.70) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:12 -0600
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE212.ent.ti.com
 (10.64.6.70) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:12 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:12 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CAM8471778;
	Thu, 12 Nov 2026 02:12:11 -0600
From: T Pratham <t-pratham@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: T Pratham <t-pratham@ti.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sebin Francis <sebin.francis@ti.com>,
        "Manorit Chawdhry" <m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, "Vishal Mahaveer" <vishalm@ti.com>
Subject: [PATCH v13 00/15] Fix several issues in DTHEv2 driver
Date: Thu, 12 Nov 2026 13:41:48 +0530
Message-ID: <20261112081204.1146395-1-t-pratham@ti.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B5:EE_|CH0PR10MB4971:EE_
X-MS-Office365-Filtering-Correlation-Id: 881aca9a-eadc-48dd-5fdc-08df4094b990
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|82310400026|23010399003|56012099006|18002099003|6133799003|10067099003|261009223027099003|261026140227099003|261022105027099003|261021123027099003|261021121427099003|261102123227099003|261028144727099003|261026121527099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	cAh4YemcjpHYRovJll+d7NL5zab0SyzPq5vtwxJ6Ji6Hn6dNvPhFDX77UtX2+5rvjwXu63x0PLYhbF9Sl20mwPxkRctev8C4wMBWRS+DzPHpI7Km/lXMC+Vn2N20Xjte0c9GjyZ1M2ZEaoobnrc6E84q63hBFMHbz0YSbJfSrjwtw/947n0jlo8pYaZ5V7RKU5RZu85PbTcg6ExwSi7xOvdaR+VgfRevy4uscY61YHYT8UYHl81RGuo0cPKma/iNcH5WJ5R1ZWCw7gqnOiODZr9cPQ8ffs14ANhB6YcMd2nOfd8Tl6NwJTxyqSRQJktJNAEqvd+KxIAmxqrImp57TXt3GgjF1EV8CnHUqRqADF1WPSO2aqLDqVSSbLSuhdLBItNrhcDxQDqvDYq1suwuSBQ6BA1Um1rJCG7c1uJBVFZ2sJ5Xc9RK9s9sEsCD0oq6Has0RT1m+HRlqRciDpK3lygfUnXpfsBewbs78mdtv2gCzlJWt8wEBxEXZ+qnEDKwhORd63kviPYgycYncE6a3+SlRutC6OXLLKsDnN2eErzy1zKMBWXFFPH5zC0oLR767U3uzFvCWs+8BO3NfuPKNWW+OJgjJGsCkRWeaDUGw6BCSbQqyH76umET2wWdRGLyNnWIuyje8T73ZMYkNyWWZg==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(82310400026)(23010399003)(56012099006)(18002099003)(6133799003)(10067099003)(261009223027099003)(261026140227099003)(261022105027099003)(261021123027099003)(261021121427099003)(261102123227099003)(261028144727099003)(261026121527099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	PgagE9XGZ5DOtMMoY9mliRsP2j7Fn/Ytj/1WuLeeKKRP/dyHfDQmSJ08Hj6mWoECCnaAxd99cchPydtJWwcJx9IvdA3YfIK4JdAbkeN2GNcApgFAF3ZIwjYAnH0ijKo7k32t43cEh8gu//GZluy6vNQF7dwQtsTckiUErIsCKlNSdvbfud+4uGw0uonPo4yEcvXHTETffESTYNggBGgBgEhwwDMWo9i+Dm5wFECXuJAROpBtDrKwAwQHgAXxGX1baR/fs8FcqH7pgObSVRh7e4D7H26LCqrmEpLylBFuBYF/HdVjK7QaDNuX+9TzRgGIjR4hoOYQ1ElHDCaquM8RtLA3XgRJd78CO30ZtIDCvZHWBU5hN++V7c4fMfpnsED0EXwrIOhwpqzFi0eKFq/D7ojGyQ2sBpsI0mZunAEwddQUpkD6VFQct9tgrdt0M6cn
X-Exchange-RoutingPolicyChecked:
	pHd8JM50+aaCU12O7Mj+EJGNgkBUIZvYUQ9FrUqpd/eZDIpQIOh5Hr2HPIRjTUC0ZzIyBqMKB1h3hBvZkqSflJZv7VrPTOMP68SNOXxKBmD2/bN/vmp2Ymqccw17Scjxbh8AX55F1rhxD8xhlVgDK3XQyCDQku+bYlVez+pSAR5E3qEizTkdRLwF9kPS9AxKWll1KKupGEFESggH5ADcMhtrWFODYmOZK2BdVE21nOKuaKa7a3/zfPbFLt3nULcW4K+TSQk1bkIYfTeuNs7Rohdds0uOksUssWoAgrop7mRn4Iv/Yc3Dyk0zFCAAWvgrJfv/V1JscLxoorGmoLTL2g==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:12:42.1722
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 881aca9a-eadc-48dd-5fdc-08df4094b990
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4971
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX/l74X2I7xW57
 0WQg9VBKSnAjJnp8+H9af82585t/3cfNAOCQGKXONPm+hHaCoPzA6OdTAjopbs25P/7NLkzzOjc
 Eq8am3QHL5jM3bPii21no4TUVWpZ1SU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX+7Hx5E8oT2f6
 FWhWYl/R5+2FYbDAdcr9ywVeRFF1znFoh36iXIIW6ynvNJoMtdinjIkahhZ4pyDXbX30UnNeyt2
 cp9LUq0fbpK2nqc1HnNxnVT+hOXjSg3kvoitHNtZYDCcxO7pmdcB3IeKGCOTbNz4KnclF/Fo7dx
 G/BpaSAaJ3uuKny9zigFGJSZlwuLCDPMR+h65WPIhLqY4toXwHOkQhVZHqBBwE3DOKWp+YMEb+a
 75Bqw/WSux5gufSJhAKYA6JDpRZ2QU1fRJDxuHdOTOnoPQpe7q0wPY8VIGZK1WsyiNXp55Ya6uJ
 saJ1ho/cyDs7jQfv8uoC5E+AKOTi/TTk73m9ZvcD29EeR3H/nTM1JUm6iwdTHnsF/1oir25pWEL
 1vOAriuvFnAwsfOkONrwlpKWW6sStUjFU+hMSyPtR19qUKJ9afK+TgUhvwAiihErJS/uXk48T79
 LdNl8sPl3ZBksX4pf0Q==
X-Proofpoint-ORIG-GUID: lRptyWY8eVyQD2yTLkD3EmbnSuP66WvW
X-Proofpoint-GUID: lRptyWY8eVyQD2yTLkD3EmbnSuP66WvW
X-Authority-Analysis: v=2.4 cv=asYnmiZV c=1 sm=1 tr=0 ts=6af574fe cx=c_pps
 a=h0MEFlbiS7SWjyAGc8mu+A==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=taLDd7a_hP9WKsMzeGRc:22
 a=c92rfblmAAAA:8 a=sozttTNsAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=_ATdgqTP6xyhrPmE5SsA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 spamscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

This series fixes a handful of independent and mostly benign till now
issues in the DTHEv2 driver which were flagged by bots and AI agents.
Except for the fifth patch in this series which was found in an internal
testing.

The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
some pre-existing issues which needed to be fixed [1].

One of the issues had already been flagged by kernel test bot and a fix
sent on the list by Mert [2].

I included this patch in this series with minor edits. Then the Sashiko
review page for [2] had more comments [3]

Overall this resulted in a bunch of fixes patches which would have
deviated the DTHEv2 hashing driver series had they been included with
it. So I clubbed them together in a new patch series which is this.

Signed-off-by: T Pratham <t-pratham@ti.com>
---
Links:
[1]: https://sashiko.dev/#/patchset/20260807110501.975130-1-t-pratham%40ti.com
[2]: https://lore.kernel.org/all/20260613085858.32580-1-mertsftl@gmail.com/
[3]: https://sashiko.dev/#/patchset/20260613085858.32580-1-mertsftl%40gmail.com

Changelog:
v13:
 - Put kref in probe error path (regression reported by Sashiko).
v12:
 - Rebased and resolved merge conflicts. No functional changes.
v11:
 - Changed order of operations in probe.
 - Added comments in AEAD Tag helper functions.
v10:
 - Corrected typo (dev --> ctx->dev)
v9:
 - Changed extensive completion re-init based wait to using kref in
   patch 04/15
v8:
 - Minor fix based on Sashiko comment (corrected spinlock)
v7:
 - Fixes based on Sashiko comments (added locking around
   dthe_put_drvdata)
v6:
 - Fixes based on Sashiko comments (waitqueue -> completion; DMA
   alignment for cache coherency)
v5:
 - Fix spinlock inconsistency patch
v4:
 - Fixes based on Sashiko comments
v3:
 - Fixes based on Sashiko comments
 - Some reordering of patches
v2:
 - Fixes based on Sashiko comments

Link to previous versions:
v12: https://lore.kernel.org/all/20261107160631.2592763-1-t-pratham@ti.com/
v11: https://lore.kernel.org/all/20261107145618.2349562-1-t-pratham@ti.com/
v10: https://lore.kernel.org/all/20261016124456.1802080-1-t-pratham@ti.com/
v9: https://lore.kernel.org/all/20261016114806.1749515-1-t-pratham@ti.com/
v8: https://lore.kernel.org/all/20261001085245.2922974-1-t-pratham@ti.com/
v7: https://lore.kernel.org/all/20260930125859.1749849-1-t-pratham@ti.com/
v6: https://lore.kernel.org/all/20260930112533.1593952-1-t-pratham@ti.com/
v5: https://lore.kernel.org/all/20260918102245.2784000-1-t-pratham@ti.com/
v4: https://lore.kernel.org/all/20260910175619.2122149-1-t-pratham@ti.com/
v3: https://lore.kernel.org/all/20260910104202.1537226-1-t-pratham@ti.com/
v2: https://lore.kernel.org/all/20260827132318.613876-1-t-pratham@ti.com/
v1: https://lore.kernel.org/all/20260827105711.527182-1-t-pratham@ti.com/
---

Mert Seftali (1):
  crypto: ti - Use list_first_entry_or_null() in dthe_get_dev()

T Pratham (14):
  crypto: ti - Fix spinlock inconsistency in DTHEv2
  crypto: ti - Fix potential memory corruption on highmem pages
  crypto: ti - Fix use-after-free of dev_data on DTHEv2 driver removal
  crypto: ti - Trim scatterlists to correct length in AES
  crypto: ti - Align buffers to cacheline for DMA
  crypto: ti - Separate padding buffer for src and dst
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AES
  crypto: ti - Validate sg_nents_for_len() return value in DTHEv2 AEAD
  crypto: ti - Terminate DMA on all error paths in AES to clear
    descriptors
  crypto: ti - Terminate DMA on all error paths in AEAD to clear
    descriptors
  crypto: ti - Do AEAD software fallback on only ENOMEM
  crypto: ti - Correct AEAD tag operations against dma cache
    invalidation
  crypto: ti - Change lengths in AES to u64 to avoid potential overflows
  crypto: ti - Change lengths in AEAD to u64 to avoid potential
    overflows

 drivers/crypto/ti/dthev2-aes.c    | 378 +++++++++++++++++++-----------
 drivers/crypto/ti/dthev2-common.c |  84 +++++--
 drivers/crypto/ti/dthev2-common.h |  66 +++++-
 3 files changed, 365 insertions(+), 163 deletions(-)


base-commit: 99f506c86bf8b6909564fff64eeaa64dec5996b9
-- 
2.34.1

