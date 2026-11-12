Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471183;
	b=Tr1e/pawt9qk1OJhemrwe4l9jtYPB+WGO/65rClQZDd9uD+8Iink4RJRa5se/QGYiJkb
	 FrXjoskMZFJBl7m/DU/mrvrX8N34VMgdNI9UyNo67qHj7LupsL67HJ2ZOCNtbHGB7yEZG
	 psQHibsTOt4SaK+3FH2SC2bTXn/VLIbrDSS3Tqu3k1Djea0jxeBIluiLjhDfq9QeKoOp2
	 lNz5PdrPwuq9irmkPsaP7dPIhOke14jh88PZIwvgfcxy6LqIEHjdB78kr+XesmrIjr9Ht
	 ao+WIVsUlWYUsZD/O6aoOM+dWbpj6hPvKh4Ijq6tBLITsHoD2Do6JBMyDfmds5t4L2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794471183;
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
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
	b=dwvvpDTx1yP9HzA60lTopLhWSwbrjVjAYssC3oluxIQEfLacaFZBm/Gw5oNw7Xlao6EF
	 COOXloYo7MM9lWvRjx9ReOuUSHgYsQhrvfRwciKS65Y2mr9GfqAdc0b8hTWsSlg0vz1MI
	 0gmY5F662eJ94Xl6qo3YTbeYKH6TnHePpm9UzUSnv3NoApdiuNK7VLvidIJPT38AXpUEJ
	 9j8hdiEhG1qCTYPQTNRl3E1M0r4FCfnNgvhQDmGLWXfykjTzp3ZzETkSXwhc+Rg/BKG8N
	 V5LJO7LLwpL/ODmTrcEdbFzjlE3zH15fTYk9qYReK0BaI0yxDtF5FyzrY5Bpw7s49qg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=qsnuV118;
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=H4kLbm4M;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.154.28
Received: from mx0b-0002e601.pphosted.com (mx0b-0002e601.pphosted.com [148.163.154.28])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B06BE606A31C;
	Thu, 12 Nov 2026 08:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B06BE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=qsnuV118;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=H4kLbm4M
Received: from pps.filterd (m0374955.ppops.net [127.0.0.1])
	by mx0b-0002e601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AC7guUI2308431;
	Thu, 12 Nov 2026 02:12:58 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdam
	Sw=; b=qsnuV118KiuGx5WnF1m0nIjFH7VKzA1VaUg3LeuYU23L7tcgk7f5hNsSY
	27CEHlwo3B1jGvwzaFG0QjlXPtJJNLWl0DDyDPf3WRWP94RTyGRmA84V7RqTi9av
	0qu6tLDlCFiimE7TJKWSCicMFAXqq5gIczPor9J9ePw41C9XQKjVqtXcE+WrUXiX
	C2xnIgOaqnBvB28wBX3ooRfvon0BWmat2T/UQ4XjUCxgDa8FZryE4u51FGPrltPT
	wUbO4mRiuWfDZODgGDxPcaUr0Gh3J6kH9BRBTYW5x25ihNZtfDqDUzx+AcpL0SqA
	SULc57HfDE9nUZohzo8coXUboPFkQ==
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011056.outbound.protection.outlook.com [52.101.57.56])
	by mx0b-0002e601.pphosted.com (PPS) with ESMTPS id 4hvvr6vfe3-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:12:58 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F3paF1xPZux+NnlUemd6MgzQrBPrv5I+VTL3fZaGlOoy068jBRb8TfjTxM+6Qsuv/VrN8tg0xfcf0a96zNdxMovUk6DZ1KzcXvtDPf6JtFU+069rEvRnqwaQFHAI3my+mNp+FbJSWs6OBMtSuCn9frgvvkQBExdTktc5/KkoqDmcKPKmaNynYLrbGG0cQ8vaOeR9/oEtRaCO5H1bBNHlxjig7GW0QfpN/IzR1ddjm9PCg1Sqtyd8LH3us82Uqiy43tHQkUsPF3c8CwnRnz2dQTaU39hiz2lncOYbIFAzlap2CsMK/0+YoZOi6rFeHCrjtPQIsIKKW1LOnwIGkT0xFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
 b=UcMtUHGVwEHzMMeS7IovyFVVaB/pRC4HLb497Yp7IT8QpMnhcrMSxzsf0VKw3saUS/Y0fwgeG9M/PdbM5qFglTmkpixzztiSyUK15vbi3wI+n0pJ257MVON/MoAaL5iNfJ+fjIuKkverZo8luH/XnHc8dmEMVzg/IsiZIQy5brkIouZV6suhVGAAThryUbf4dIi+yzkFeKB3ykvkisS/OaX4vbhY3z0Lur91cvw46NDClB4F5ICZHoBKjnnBuLmww2aeyvOJ7E14bEvtq82QSwyMAnsV0zQFJnogQjl41+vpF4OjL2jzsEAYnVvQKDAXlXANsgZ4L+kDMphp7UQ6Rw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.194) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbU753uW7zu3gHpaKZoEKv7LaA4I9IDJ5fr4ITdamSw=;
 b=H4kLbm4MMVV1tHvZ78xodCLlgcOMFEWARZLnXCnFsob24kVrJqLhO/pacGj15kc7F/tXSFjIQDRHSwkM5t0g3VG+YKmUtW5V231ueWCVfeF/8n/5D6R0SB9WR4UhGde91RvxkiJGP/8IbzL4VGtm/yM1YjyNO4u45TwV3HdkTLU=
Received: from CY5PR15CA0040.namprd15.prod.outlook.com (2603:10b6:930:1b::35)
 by SA1PR10MB997739.namprd10.prod.outlook.com (2603:10b6:806:4bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 08:12:56 +0000
Received: from SN1PEPF000397B5.namprd05.prod.outlook.com
 (2603:10b6:930:1b:cafe::2a) by CY5PR15CA0040.outlook.office365.com
 (2603:10b6:930:1b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:12:55 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.21.194) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.194 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.194; helo=flwvzet200.ext.ti.com; pr=C
Received: from flwvzet200.ext.ti.com (198.47.21.194) by
 SN1PEPF000397B5.mail.protection.outlook.com (10.167.248.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:12:54 +0000
Received: from DFLE213.ent.ti.com (10.64.6.71) by flwvzet200.ext.ti.com
 (10.248.192.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:25 -0600
Received: from DFLE213.ent.ti.com (10.64.6.71) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:25 -0600
Received: from lelvem-mr05.itg.ti.com (10.180.75.9) by DFLE213.ent.ti.com
 (10.64.6.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:25 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr05.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CNfl1455686;
	Thu, 12 Nov 2026 02:12:24 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 02/15] crypto: ti - Fix spinlock inconsistency in DTHEv2
Date: Thu, 12 Nov 2026 13:41:50 +0530
Message-ID: <20261112081204.1146395-3-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B5:EE_|SA1PR10MB997739:EE_
X-MS-Office365-Filtering-Correlation-Id: ccc24599-241a-468a-f917-08df4094c0c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|23010399003|82310400026|36860700016|10067099003|56012099006|261022105027099003|261026121527099003|261021121427099003|261026140227099003|261021123027099003|261028144727099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	HJJsNz//q+WTmsd8i59M/pdnmC/jWE35OtQHvRB4BiB1HuGKULpGDPxsXbscpEXem4S7ruhq/ftVGIWv6ugzdjc2sutoZKlu4Yq7OGTTGTcdIlR+FCO6jxx6eP+zhs8r22ao5wOL2QiKRUGmR8UuVpab2bBrtEx33UGHsdFd3ORJy8ITo6pTukuNTRltSOkjiqTn5CbuQzOrc1TuigwE+97c345VLYkurubAAG+TblKqvqNBnsktBmnkJ+c+dBt/S5mzdO9BFprzb8fPi0vdl5pUhON5R7uK5MkaRsj/ukxGmFz+6wJ91zgrZa9esITZaDPW4TDvWdyXpdtSWDCLr3FbtjLNos3FTvlzvT3JAHAVOsqop/vUWAVa5yMeBkepPLAEgjUUYjXGgdXwvQf2243KWNzk/pP7Pz3nXRzCfs4mbXYj2XFwY6xAPy2md1RBrgxc2PFwqGOovw5zRWcBW6CWimSRsYJodGwG6ygnbd1eh+GN8xJKbN9mcGEdybAwXvFviEWPxrawE+75C77z85ZYJyEjY++x4uost+/FNM86S+I4cSX89Ga1kOXn+/N8jKpsXvrBLTUA/DNi7OUkY0herKvWo/gHIYnWRcRpSld17ShkQV45sGyCfxCLw8CyqrU/b3gGUvcvAhfLpjOBD8nFHdC44la4YqM7hp2W4FgvwLZw6WLy3aKWaNUFKdeJf9xd+E6bMXHgQ5EavXgh/A==
X-Forefront-Antispam-Report:
	CIP:198.47.21.194;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet200.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(82310400026)(36860700016)(10067099003)(56012099006)(261022105027099003)(261026121527099003)(261021121427099003)(261026140227099003)(261021123027099003)(261028144727099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BTP73FacdTrS1mFbLp+/TCnGHdsYTxRqsaxgYRRdHejxCE6zX0NmCrxF1rMfoyJse2bMcuvP429fLo6uGLcallq3dVfRRLQtoGwUfA3PaRuZeevqcNfi3s7UtJvWv8Od4OGa+bHoc4Mb0QPpynMrtISTBm3gBZ0M6HC7wVUlhzdjhku/TYJFllqczSbfegOIj/XLtBOdCpuF38yNECYMt6uPUoxmATjWN/3BzrkjkNYtlu6k9HZ1sf95fcPP7KFJ+nBx6Ls+kwwt6IVKVNq3GAtt8M8jSnkbdYFAcCkIWkeZCnuEasnXvBmDvOpgzBaMEBgsHmHyY70euft0dns5MH6T6NcvUMfZIElL9IPKvH8HzOCtd9jcEK/B4WewV6nBdo6pvE+4XjXfe3CUa8Fnex7qI9urZRcWUqn6gdnIH474DS3VdyTTUfb/sDHGvULn
X-Exchange-RoutingPolicyChecked:
	KXYXBMFOibGZML3/xGLhdiRiWAdxH+a8c7nfScm2xfzeA7Lj51jomHlIcnfgy9sXMZpq6gHAjPwb5E4kxXViYoY3eAshGoj0yCeuODl5wblNo9JJ52MHOmpNhRQm6RV0Eb0t0jMEDK9ItguRtPSJlEcxWt0UNJlEmIPv+wzL440kEPXK57+3ROkdJMjcCcreZaIba7+4TWmg68XQJQVOHqDKqeP5qRJGko4jo5ht0bD9nP3dwQKEq/ImFw5VGDtRqVJ8U13tiZ9fL3iiK10tIIND1qwUc/1vC1Z/+M2XPcpPQqptf+kVNyhhdwq9fmCef+FNRRvOPr4KQFWtYobYug==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:12:54.2658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc24599-241a-468a-f917-08df4094c0c4
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.194];Helo=[flwvzet200.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997739
X-Proofpoint-ORIG-GUID: 4LjnmTGfwjqi_yBPmCcTv0tDgE6zoO-U
X-Proofpoint-GUID: 4LjnmTGfwjqi_yBPmCcTv0tDgE6zoO-U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX0B/az1WBqkSZ
 l4BE5TyUW54Ed2gTxWvWaRrBMzuP4O58aaY2e+t54tir0Vxx7H07aEcDR3Q3kM/d2hvTosKdTGv
 fKoNZPr9J2BnTm5LfAp/qBH5BYhSdrXzOeisM7egcwowN4dGrF7qU9IRQHcMnAD466543gmwVeC
 TUATU3fQzevCldOgZOANQN5So+hGcpi2LYb41iCi6vClcTCV6RHhaX9gFqdBuJCxX9vbl4qIFj+
 XBizg0zQL10/lfeWdrbb1fPudPB1PRmE1YDcram0QfabqnaWXsLrhAtdZKHaERpN+AFvMczBkX6
 l0gcxlVNAQVXhz/QBqjJhjfv7veA1AlY7rNizGnGjdnpwEzjwFWJKr9quZfY5PcXRx0U+2gIgCt
 oMVwwIaQW045pEV2dqtmx9NEvrgwDp1e6PjYg3l+WwE0LPy0/LH2niObVALoPnKV+Zw4R4YAqkK
 SxxiiXSv5hvwsD4gjsQ==
X-Authority-Analysis: v=2.4 cv=MpLHeGae c=1 sm=1 tr=0 ts=6af5750a cx=c_pps
 a=P8hJoqhRnqo/cwUvmyxmUw==:117 a=iwqwCZQqcuTv3JOpYdM7/Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=AlMIdn_sM9wA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=fPAWb5peG099m5CrUpKH:22
 a=sozttTNsAAAA:8 a=XwTwKUqyhKWgmV1Ix0UA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX/DvOIiL0yH+U
 oC3duVBTDnWa67Vp+tDjCPJl3J29An7Xz8tBE8X/npstpJTLZIRxrxeX5KX3WBrqJHaBGTXiwJh
 SS5+UdH0+lbCwOzkLn01QxZPo+yLqIk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

Probe and remove functions use spin_(un)lock for acquiring the
dthe_dev_list.lock. But dthe_get_dev uses the bh variant. Change
spin_(un)lock to spin_(un)lock_bh to avoid potential deadlock when a
softIRQ process tries to acquire the already held lock.

While we're here, also change the order in probe to add device to the
global list after all the fields in the dev_data are initialized. So
that a concurrent TFM allocation does not occur and try to fetch
uninitialized fields.

Fixes: 52f641bc63a46 ("crypto: ti - Add driver for DTHE V2 AES Engine (ECB, CBC)")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-common.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ti/dthev2-common.c b/drivers/crypto/ti/dthev2-common.c
index cb4b8b38a5ec8..a7d3831f2f9cb 100644
--- a/drivers/crypto/ti/dthev2-common.c
+++ b/drivers/crypto/ti/dthev2-common.c
@@ -152,15 +152,9 @@ static int dthe_probe(struct platform_device *pdev)
 	if (IS_ERR(dev_data->regs))
 		return PTR_ERR(dev_data->regs);
 
-	platform_set_drvdata(pdev, dev_data);
-
-	spin_lock(&dthe_dev_list.lock);
-	list_add(&dev_data->list, &dthe_dev_list.dev_list);
-	spin_unlock(&dthe_dev_list.lock);
-
 	ret = dthe_dma_init(dev_data);
 	if (ret)
-		goto probe_dma_err;
+		return ret;
 
 	dev_data->engine = crypto_engine_alloc_init(dev, 1);
 	if (!dev_data->engine) {
@@ -174,24 +168,29 @@ static int dthe_probe(struct platform_device *pdev)
 		goto probe_engine_start_err;
 	}
 
+	spin_lock_bh(&dthe_dev_list.lock);
+	platform_set_drvdata(pdev, dev_data);
+	list_add(&dev_data->list, &dthe_dev_list.dev_list);
+	spin_unlock_bh(&dthe_dev_list.lock);
+
 	ret = dthe_register_algs();
 	if (ret) {
 		dev_err(dev, "Failed to register algs\n");
-		goto probe_engine_start_err;
+		goto probe_register_algs_err;
 	}
 
 	return 0;
 
+probe_register_algs_err:
+	spin_lock_bh(&dthe_dev_list.lock);
+	list_del(&dev_data->list);
+	spin_unlock_bh(&dthe_dev_list.lock);
 probe_engine_start_err:
 	crypto_engine_exit(dev_data->engine);
 probe_engine_err:
 	dma_release_channel(dev_data->dma_aes_rx);
 	dma_release_channel(dev_data->dma_aes_tx);
 	dma_release_channel(dev_data->dma_sha_tx);
-probe_dma_err:
-	spin_lock(&dthe_dev_list.lock);
-	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
 
 	return ret;
 }
@@ -200,9 +199,9 @@ static void dthe_remove(struct platform_device *pdev)
 {
 	struct dthe_data *dev_data = platform_get_drvdata(pdev);
 
-	spin_lock(&dthe_dev_list.lock);
+	spin_lock_bh(&dthe_dev_list.lock);
 	list_del(&dev_data->list);
-	spin_unlock(&dthe_dev_list.lock);
+	spin_unlock_bh(&dthe_dev_list.lock);
 
 	dthe_unregister_algs();
 
-- 
2.34.1

