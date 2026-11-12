Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794471183;
	b=WRPcaNQv0bJ+WRu5SWd7T0RW3CAutWFH6G9c+lG0FEVFjSWqIdlBFBKNG+2yvAMUu9eH
	 7AaSOQf9YYUaatXLlD8yKo4E7RA4OZhOoNEmJkES6iVsMENAwoi+q27ODYUmjigcTQh7w
	 mRJVbJqVxWxFtan+YdJU1PKMD8ZunirzLtodAkg19Ge6MBIL7bghBbq3yTPPx9At2Ge/R
	 NtNZC+r9qLVdKixbI9OJ7htIrKN3aNsG9dGVFSxz+CjDKoBvnDsGpN2TaMkVbbS8uFish
	 yiuq5z4OUoenvM41DXR8zzPxUwV5vbXZoAWXVCU0Ded+7SwHLcnGgrUNu00qW/hRKPA==
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
	 X-Proofpoint-Spam-Info:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=9OrI+pjQR3Sg4d7As/pFtcaxFPnK+ARuetgIV8PKfxE=;
	b=gXNQGH7hfE5KGWPjR+WCilF+XEeZh5UVV5GyzYjftLZrzpBT3tPoIkwpCtefgnWpzsIW
	 hiHlDDdGOFLWc75NiDfHoQ+y89AUFO/C8TmVF4NTskYr3u49vuwTfzVDL2NXzVN/EEUrk
	 wK5WlbdhRAYz7zbs7AGwLyqapqU0l4Loq0RCsxkrPHxoMXgmvCe+fs0ARd1AYXfQAuo9l
	 y+yp9fm3K9vxswVtS23q3fFh5Ug8NAtxWr3O77tg0Q+htnhns0zYBuDDyfVJdrwoodDS9
	 VIKbJTML2132ZWv94XTSK1Gx8bOTJ2WfyPoN4jXZPpJ32/w5K0zoBzSKr8ejbNFT7Rg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ti.com;
	spf=pass smtp.mailfrom=ti.com;
	dkim=pass header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b="c/X494pO";
	dkim=pass header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=oONbUbaX;
	arc=pass header.oldest-pass=0 smtp.remote-ip=148.163.150.75
Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1449606A32D;
	Thu, 12 Nov 2026 08:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1449606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.a=rsa-sha256 header.s=proofpoint-05-2026 header.b=c/X494pO;
	dkim=pass (1024-bit key) header.d=ticloud.onmicrosoft.com header.i=@ticloud.onmicrosoft.com header.a=rsa-sha256 header.s=selector1-ticloud-onmicrosoft-com header.b=oONbUbaX
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 6AC5iqIS2297462;
	Thu, 12 Nov 2026 02:13:00 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint-05-2026; bh=9OrI+pjQR3Sg4d7As/pFtcaxFPnK+ARuetgIV8PKf
	xE=; b=c/X494pOFnAruRpr1AVfyE8uraPWnl1oTP8Q+ca5ffj/NBkI7sPElbKgv
	eeRJ8VwQ/SxxRhP9QgDCKHvjbXv5o308jC3hWM1CI5byKzNp8R1g3gLMZF1k8Uld
	0B5X14+aO1UHbVQRPBm9Y6gZaVSTbaU2XVUW22EXl0owelbvJ7y2fmAVT25D7T0n
	pdn6EHvRW7/2QuEYiztOTt7umlkyuK2fP646znMCfKvEhGhbhRkb05aibxvh+lJo
	3vwMmlECK/pXqA86rA3RiThJboeg/VhIKS+gLaasIhWfDHtOVNgVXKTk3RjbqW8B
	pUAlxhIgyAxzuBjw69+Z42p7shg2A==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010016.outbound.protection.outlook.com [52.101.193.16])
	by m0380145.ppops.net (PPS) with ESMTPS id 4hw7k48w2q-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Nov 2026 02:13:00 -0600 (CST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KzP8IcgBzJUGJ0PqQJY8Td+hqjk9B8G59cMzMApZvvrUw+NaKacO1Cu88gynDD85r02jhEyQ7wWeO1kUjQSEh/4DgZTvqlbikz9Y1//lm2+TUT6x588iCefG84kxBM6i3VHVbC+1nH1jzRqLw+gdlMVfGEnaSvjObbr0AbdAQLGK9ZZf8MCd/Ru4KY6jJgYySt18YtY92o0I2nmA0BwCJakltrpeg9eTaKZw7YKjYFQ3crhC5BgO5/k61uDqmajfj/33PyI5BOihQxFuO8fnRg17ic7jSU/CTIQCNa5Sjzq5k6bmUl0hrgaz5T4e1WAz5f0lqrEguH8Yl+mhgjA8FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9OrI+pjQR3Sg4d7As/pFtcaxFPnK+ARuetgIV8PKfxE=;
 b=htUuPT8FltrHpaBENcOrsalzR+1AY3ShlII7xxbT9JQaAi7Rm2JldmK4Grz0MAJwlBefD0Vh+pq6E27bqhoV+JmG/kL4InjQnfvA0hs6Il5+6kc67mZEOEWKvYk8zrZz5HNdFq1l+1JvQzba91rKiJ2G2rXyewZkDTFBYPt98JuZ9d/qTxRDPmslwfxNe9SJBSbQD2NjAm6Z6HOW02XXIiokAgPrfNkWWVBN4r8VCLdMST9eNKqHP0RkNT89gsvitq8FpC4mBLCDb6+3SF/9devWLvvDmQiHPatiFZSW/9bitO4syK2Hz+s0Vc+3yxSu6sMj9vcztNoyxRRBr1b4Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.23.195) smtp.rcpttodomain=gondor.apana.org.au smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=ticloud.onmicrosoft.com; s=selector1-ticloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9OrI+pjQR3Sg4d7As/pFtcaxFPnK+ARuetgIV8PKfxE=;
 b=oONbUbaXH+zUEbDC/rfTJI3ZSzVdNg1CRNVA3tNjKK2wu8t87HwRbPGDv5xZG4fT4bk/s7LL+xR7TpU6OnUP8L47nWVgqkuVdIdx7SIi8diz8JxxjXErKAGNygNQRydw447+BBT2cjzqILp95T9vQpHWKZt6p/OCyD2bF5Yi9NQ=
Received: from CH5PR03CA0003.namprd03.prod.outlook.com (2603:10b6:610:1f1::19)
 by SA1PR10MB998137.namprd10.prod.outlook.com (2603:10b6:806:4f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Thu, 12 Nov
 2026 08:12:57 +0000
Received: from CH2PEPF000166BA.namprd04.prod.outlook.com
 (2603:10b6:610:1f1:cafe::73) by CH5PR03CA0003.outlook.office365.com
 (2603:10b6:610:1f1::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.615.9 via Frontend Transport; Thu, 12
 Nov 2026 08:12:57 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 198.47.23.195) smtp.mailfrom=ti.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.23.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.23.195; helo=lewvzet201.ext.ti.com; pr=C
Received: from lewvzet201.ext.ti.com (198.47.23.195) by
 CH2PEPF000166BA.mail.protection.outlook.com (10.167.252.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.615.4 via Frontend Transport; Thu, 12 Nov 2026 08:12:57 +0000
Received: from DLEE202.ent.ti.com (157.170.170.77) by lewvzet201.ext.ti.com
 (10.4.14.104) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:52 -0600
Received: from DLEE200.ent.ti.com (157.170.170.75) by DLEE202.ent.ti.com
 (157.170.170.77) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 12 Nov
 2026 02:12:52 -0600
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DLEE200.ent.ti.com
 (157.170.170.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Thu, 12 Nov 2026 02:12:52 -0600
Received: from pratham-Workstation-PC (pratham-workstation-pc.dhcp.ti.com [10.24.53.205])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 6AC8CpK7472651;
	Thu, 12 Nov 2026 02:12:51 -0600
From: T Pratham <t-pratham@ti.com>
To: T Pratham <t-pratham@ti.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC: Sebin Francis <sebin.francis@ti.com>,
        Manorit Chawdhry
	<m-chawdhry@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>, Vishal Mahaveer
	<vishalm@ti.com>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 12/15] crypto: ti - Do AEAD software fallback on only ENOMEM
Date: Thu, 12 Nov 2026 13:42:00 +0530
Message-ID: <20261112081204.1146395-13-t-pratham@ti.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF000166BA:EE_|SA1PR10MB998137:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a6a31b7-9019-4508-3579-08df4094c2ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|36860700016|82310400026|1800799024|18002099003|22082099003|56012099006|261021123027099003|261022075727099003|10067099003|261102123227099003|261009223027099003|261026121527099003|261022105027099003|261021121427099003|261026140227099003|261028144727099003;
X-Microsoft-Antispam-Message-Info:
	ceBg1uF4m3ylK10DO8ChfI14PKMfOzi6AFZTqHqiB0DB3ZdUiUteOP7rg5espxh6v/jArcFBVKnqYY5aAUBfWIrHpsVva0zb28KnkZ2ULacMSuHd1iOmBQCe18g31KzLyID/HSI7ILygJc/8UPn/Xuruw+ia4XUP/4s5oKfny7aLUpozQlONAViZoSEuk8PkraC0/mA/jqf7bPlIgcpN2R13HUI4wyjA8C72ufVyzs6KXJ6EFLx9pKJLJgAXKECtlyMr8d/P31a/izrs3lmTc/Lp1NQdqr8uf6qW4iYkDRkDuwG4RjI8nZCkiwnB/OfnTaElndWHBMH2Pf8/a4RT0znCec3lACYn/D3yTOENpyKdBpReSZ7WDOlHNAlDOS2W96x90UeRIaH6V7dBEtIgIiyhdXUt1y0tB/iUZsXio4SbBr1ynHyWETnTWuoO24FZenHPA3Z5FBjc1m0TXkB14bOfo0Z/l+W3ItA6bjOcnjCPt7JqYKcqEhbA+E/srK06WHAT2WVfElx0t6S3AB77ffE+OPX9Mc7lkFanWX+c9Gfje5EN4vyk2W0PY8uTSkC4I3EbIGNvCEZtpz8YnECHqqpqOisEQ7A/tfoX8U8J8UWh0g07Kan61Rrtr216ggTxy2CqXiNRqeTn5CpjnQGjzaQCmmF3w+xIPkXZtqN7XVjkjVeMFqJ80Laj2a/UkGtpgToalLj8YA3d8zmGqOwqEQ==
X-Forefront-Antispam-Report:
	CIP:198.47.23.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:lewvzet201.ext.ti.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(23010399003)(36860700016)(82310400026)(1800799024)(18002099003)(22082099003)(56012099006)(261021123027099003)(261022075727099003)(10067099003)(261102123227099003)(261009223027099003)(261026121527099003)(261022105027099003)(261021121427099003)(261026140227099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KxNjtCJCc4niGrqfmdSDg0/R6TGuKp66UzV4WsrH7HdwZcF7qLNUsWINc+D+Wiev8FsT+vzeqZszFO0cvsK/ZP0uprxJ2zLtJwRD+BOJOM8aCgkV3L0v5KGh/beeXxMjev+0z7c+hl5ONphK4LyA+3Lq78g/2YJzvOYZhSMKEScVeemXKeidmdjIgGv3xoicgdN+CV4Rwu3v0iDjaYKVHEI1gWrXZ2nCVwDFIIk/WptMznrMgcPAfHk070+8U2rsBbEnvku0OBl3rv0+yUe9M//zk6qvY5RdZQLCa5ugicBkes+xIXbs04/+K/1AzuK7s73PDi3UeBTtrbjDCfxWqumrtl4Gxezo8NrDxwSyJZanMgxcWoFn5CaMdn4gdUzpNYM4laH+drgIZwIO/qTeScWq1BFPkU5+HTdZLqbqHpjprm/ek7akkDUYaZ2h7ADS
X-Exchange-RoutingPolicyChecked:
	vko1KTP1ETohFNK8gSnCZZnM5/jJYOaM3gI+ZIQ9SF2Ghr41imMwtnRSS2DzygmnDCUSypgR+460gn9xvBAoXy9DxLj1AN+uqtNpklMYuLxml34ANzFP3BIXVF2lnI9/V17d0k3NZqGtjfkNC/2Dt9ToOsup8+tmExaMKEzMwv0DVkJyGikzQsABBpCWMQ3wgcWoTmPYAdpRDqI8akqJr5645BYoqCKF5n2rew8PqoSnT71chk8kgg3da5JfTYOYK06WoTS+Crebzv0SZz7JNJpKlTDHONn+qeBGtlzGU+Z3GmV4Gkve8NvDqxK5SOq15jSwElURnIwZ1ScXopsBNA==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2026 08:12:57.6356
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6a31b7-9019-4508-3579-08df4094c2ca
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.23.195];Helo=[lewvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166BA.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB998137
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX/CFG20rhGDYG
 JRhffZuHSlbdVuzyRJsbM+WuCF6xuNej4BUas0ntv/FTG8IdSynzgN6VjioloalKPyIDSvExWA0
 ZXPzuH2YxX2uOnjyIJaFAEbFvCM2l18=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6af5750c cx=c_pps
 a=To5YXH8t/p3KPg3XNsFgJw==:117 a=f+v6EHfkeJbVwR46tk4DMg==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=zJRp6_cAMcgA:10 a=s63m1ICgrNkA:10
 a=AlMIdn_sM9wA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22
 a=gO1vWkAQAl3rybz1DQOp:22 a=sozttTNsAAAA:8 a=4oUWx8CZaJwu3DmIChQA:9
X-Proofpoint-GUID: BVJN4FwTuWg4SJnJTEQkbzkIMCUfdoel
X-Proofpoint-ORIG-GUID: BVJN4FwTuWg4SJnJTEQkbzkIMCUfdoel
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEyMDAzMiBTYWx0ZWRfX5MiwhqAeCMQG
 f7osJRv45l/7xZpdAULH1w4WhxyCXrcyJWaZJzG3By1CMeP1gnMWm3JFKrEsOiBhx9GkPjXdLHd
 wQNKbSwhraTACVtpQNbYv9GPbL9fMUeGZqFoDhxp52gpPcPR7t0qnR/5EfA3JbNuqfHl05kHFJt
 eo4mnONXdzGD86AcFKZW47pD2YflpdHCCod2SRt1cdSvZd6XJrQUl+JqNZo/eZNGwjk0rURo6Fk
 eB8RaRDmPNslcJJ6nfHHfHocUeQvvu6K69uDxjZFp7LEauiOSa9iM4gZYaD6rETWfFF/xH7u/Rz
 0HgmCNzNdVihCt6bUzehmNLjDIikK72MJcWyAWuPVZ1FFZHXXlXu70cpf8ONwREQ71wJ9q+jzlO
 87Afl3ND6z9cv5PJCocE0k2Hkm8Q6IRd+fkE/yeI88LD6WOjQtaD3wcInvM91L7MDsCPmdsdv3x
 u4td9rZiwAz66A06NXg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-12_01,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 clxscore=1015 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611120032

Similarly in how AES part of this driver, we are falling back to
software when memory allocation fails (we get -ENOMEM), fix the AEAD
part also to only do fallback when we fail only due to -ENOMEM. This is
because we are doing memory allocations with GFP_ATOMIC in the beginning
which might fail. Any other failure paths might have modified the data
or buffers already. Doing a software fallback on them might give
incorrect or corrupt results.

Fixes: 37b902c603042 ("crypto: ti - Add support for AES-GCM in DTHEv2 driver")
Signed-off-by: T Pratham <t-pratham@ti.com>
---
 drivers/crypto/ti/dthev2-aes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ti/dthev2-aes.c b/drivers/crypto/ti/dthev2-aes.c
index f1f12126382aa..e7a7024f19cbd 100644
--- a/drivers/crypto/ti/dthev2-aes.c
+++ b/drivers/crypto/ti/dthev2-aes.c
@@ -1177,7 +1177,7 @@ static int dthe_aead_run(struct crypto_engine *engine, void *areq)
 	memzero_explicit(rctx->src_padding, AES_BLOCK_SIZE);
 	memzero_explicit(rctx->dst_padding, AES_BLOCK_SIZE);
 
-	if (ret)
+	if (ret == -ENOMEM)
 		ret = dthe_aead_do_fallback(req);
 
 	local_bh_disable();
-- 
2.34.1

