Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795093085;
	b=hmJ1ZI3CaI1nOEuuZU87CWwJDJRiaiyjYoknb0RIRfc/oQAA80wOLyC5x76rcFBximck
	 WvDlGKrjIQ/74OatMPStFpBTt4C66XRLbamM29bY+UnTWnKjYzoLNlSHWg/Lx/x7UN+ex
	 V0y7a8cxkhNEdfuWafoxKUdn00k7repzRlr62e3t216PCn6NKMKgMc3BcIokOJfPd3ZSw
	 Jx+SDsfpjiYbgiyeD15mbNPXiCxInH+LLOmkOUDXkUcHYP+2tmADzHiX+uM1gPYkMjxbj
	 20Bx6OWFlCl5W0EXu6Hja0X5WVTfnfIwq8UEcnPC4wgiD9dichgUlR4LcxRnNQI5iHQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795093085;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=q33YZcDEU0V3tq6KsAx3J4Ib9zemKArxokuwKWUSVJo=;
	b=cyrmcNz3Wk9m5CqJ4t7CFoei6wUkh5ws1f6jowDsMwUhKA73R4DZTBnYJUUfzATB6F+G
	 VLhRvgy9TGbgK6CY1WxsyFJs6Sr9q7cEHJD/rdfjazPc2RMlGLbNRx2lTuG1d+1CAreFy
	 wbgmFzntD0YuHEgc6AL1xfyFTaqgdML0KsCTMyZg5PJCpPKBW5ZuvczB08bHJUSIKW4Q2
	 rv2zy3Ax2RrM72oFBrQuK0KjkFx8u/eHvVgn2RQdGcwlE20x1ARR3V7827wBf4a0BRikk
	 v0X8MWL9eMtAfHywWabmoOOK5e8Kkgf/hsw/jGWfHlOiXz7+QwY4o4KRC75dARxBt/g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=BcbDSWer;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.64
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011064.outbound.protection.outlook.com [40.93.194.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88666606A320;
	Thu, 19 Nov 2026 12:58:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88666606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=BcbDSWer
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i4twmiPvI7BDeX7ylNAQ+UpHOkFC50gpeN0QZvzWf7l3Uz4Fk+1Ia1/Htyz1ZlPc7sZqcWQf2GmHqbqnM7zTMiDeiRNj8Yoxp1M5t4rfbZQdZp/aCsDyDchePXk7GQw8ysI6EzqJUbLuchqkYidgJa6DziqzUVv0VJZxn3m/VoJzq3Rpwx1xSG2AKxF83O/NIQJGYt6J+YKAIoPA3Ud7gRKWEhsbEieWv/fNd07qm3eEOFrM+YjsrGVBxQDVanDElIE2+8udsaoUJtQf6lOJzTx3Xdg2p0QGmGbphz1cfUnD20xLDi3DhDO5QGtSAvTWatjcTozK8syNFniE6hapMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q33YZcDEU0V3tq6KsAx3J4Ib9zemKArxokuwKWUSVJo=;
 b=aOrlJ8MQCusuP2GoYzOYzjk2HgAxLsmFjlm2/+gyNLdVbb15rGqFNr6p9O9KjRtog0MPHimBB8jw2hxHDOLzyav7eP+w7FXa/7HXa/9Hf3jSihByoLqycoOQLExzlXE0EiYWsjjtJLpTcf1rrcXLfXy+HshL3qBC8IhgPstiiBsj3gfaQ2KV4yjuziEobk4Si9nIrmC9n+JMZfCBxLIp4ktB06POVdXpBRX0G3ltMXFuVpmRdAl7C30GtWj4dcUom+I4d27uebsY1TnGM5aZmKZ6BK36t2ar/wjKuqOQEPOHT7R73edKTegEOAYUTsoUpflKxJ36y2LE5ufkQBLgZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q33YZcDEU0V3tq6KsAx3J4Ib9zemKArxokuwKWUSVJo=;
 b=BcbDSWer3VD+ibcQLBQEqVa2OrLQuQfrlJQ7cqHSWsR5+lJOvJbEhMX+x0yPI9u4rQ5CRlwbMMsxDPGjFu8U508Vg7HXnx4FwARSis1CiGKW2lUeZ3SkaklCWlhINa4Gsj/QRunmmIhz17+b3Rssgd0iDS5AsJ8VXnDfPPXEl2Q=
Received: from BN9PR03CA0126.namprd03.prod.outlook.com (2603:10b6:408:fe::11)
 by CH8PR12MB9840.namprd12.prod.outlook.com (2603:10b6:610:271::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Thu, 19 Nov
 2026 12:58:00 +0000
Received: from BN3PEPF00022BC0.namprd04.prod.outlook.com
 (2603:10b6:408:fe:cafe::11) by BN9PR03CA0126.outlook.office365.com
 (2603:10b6:408:fe::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.12 via Frontend Transport; Thu,
 19 Nov 2026 12:57:59 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN3PEPF00022BC0.mail.protection.outlook.com (10.167.248.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.639.5 via Frontend Transport; Thu, 19 Nov 2026 12:57:59 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Thu, 19 Nov
 2026 06:57:52 -0600
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	"Lukas Wunner" <lukas@wunner.de>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, Kuppuswamy Sathyanarayanan
	<sathyanarayanan.kuppuswamy@linux.intel.com>, Jonathan Cameron
	<jonathan.cameron@oss.qualcomm.com>, <linux-coco@lists.linux.dev>, "Santosh
 Shukla" <santosh.shukla@amd.com>, "Pratik R . Sampat" <prsampat@amd.com>,
	Scott Soule Cheloha <scott.cheloha@amd.com>, Ackerley Tng
	<ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>, Fuad Tabba
	<tabba@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, Alexey Kardashevskiy
	<aik@amd.com>, <aik@ozlabs.ru>
Subject: [PATCH kernel 0/4] PCI/TSM queue
Date: Thu, 19 Nov 2026 23:57:29 +1100
Message-ID: <20261119125733.1860288-1-aik@amd.com>
X-Mailer: git-send-email 2.55.0
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
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF00022BC0:EE_|CH8PR12MB9840:EE_
X-MS-Office365-Filtering-Correlation-Id: 64b51b46-5146-480e-19cf-08df463cbd35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700016|23010399003|82310400026|56012099006|261022105027099003|261021121427099003|261026121527099003|11063799006|10067099003|261026140227099003|261021123027099003|261028144727099003|261102123227099003|261009223027099003|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	JCt1bqa7ELl5kNIIcnb5u13viSav+FWHBrqP+Mho8dAQgu1iaUJy16bUPrlD71AxB030+8QS3xN3+HV1KgqzNwLJgPxkDEs1zNQp7R+4Qu4o1NHqAeL8zojf94lxsg/OK4H7DGKj9ovJxnDLUmX00Yv3ze3UzNeBibtQoBNyZd+7PMjckQLvKCUdvuGOaojo1saEMLuDK2soUSlanAn3+EKX0DaF1lZk/Q0vqpixyQIh9vSzg/JawUciMmcdyw00f6/2W4ALJXvkyDtYg5xbCfoCPlnbd7roJetz9bG7+CH8CiFXjkt2r+Haf9jJoKMEjNBGX4jRP3e5xNyXoptT9+yPRqnMWI2uWJ11Q2SQd8mmsVIoHhy44Xk/uTV8q7Kh7IHbzDmItooJSRSGG+TeHUeGbFyxINlZ+SyhFoNKJrSAZoQytTexpZK5O54DoubFMHafE+xkwfgOTGX3xFoxpymm0yab3Z6iOHvNGefuYhAqT84p4fm/PTKBYlTyvV95E5Xlv+GgL7P0UWcVdDZ2nDinpqxDkOhHWlAD5Mym4GZsaK2bVzvsF3nHnGc57csz44iBepcawM9duO0zfDHD8t9sQm7Td1ek0cJiW5HtPZx+VENntouhxw3er6wlEf158bx4KBKtH73FhFDvXEUE9XOXVnTjc55zYPmYq+Hr75g=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700016)(23010399003)(82310400026)(56012099006)(261022105027099003)(261021121427099003)(261026121527099003)(11063799006)(10067099003)(261026140227099003)(261021123027099003)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UqBLrY1bq1w5jOhmj1PVWDDQYFw80gVh1C8ITBvp795p9+CF9p9Od00KsdP1jXNSYR/aGIcVWz4ZED56VWVsoB3sy3yY/znLgfus/KdJArjuJ/T81egpsEH2m/bpvrYCHi8NHtXb3lp8G7NK93Zwe9kT5yBl6kKm2GlbgDmB1Rv3gRfDXa0+6T2a2pbchhR9QRwT/HOi0Y6T6Q2PMszjNm+UYtr4/ak3b1jMnE0cwIcTWElj99VEYuZYMvpjxN+lAofXHqME1p3jJjNM6AxTiybacOW5S+dMx5AK3eZuQMv0RU9ZJiLFyYg5vb/ctoPlS0j6Xb8Al3vSeSxDKsDtK7T4MetK3kKb8nazo1lyEWzWEJdgdAOJQav2RvoPYmHcLewJVh7Lhz2yd8HcNogkKfXwm+7Q0WmVKuUSzk/ookk4eqYQIXZT9DLBO7H/RVpv
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2026 12:57:59.5805
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 64b51b46-5146-480e-19cf-08df463cbd35
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF00022BC0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9840

There is a new git repo which is set up to track TSM work.

Establish the tree and start with a set of small fixes.

Previous attempt was here:
https://lore.kernel.org/r/20261116075420.76205-1-aneesh.kumar@kernel.org

This is based on sha1
7475ea8b58616 Linus Torvalds "Linux 7.4-rc2".

Please comment. Thanks.



Alexey Kardashevskiy (3):
  crypto/ccp/tsm: Fix potential size mismatch in releasing SPDM buffers
  crypto/ccp/tsm: Remove unused header
  crypto/ccp/tsm: Use TSM API for DOE

Aneesh Kumar K.V (Arm) (1):
  MAINTAINERS: Update TSM file coverage and repository

 drivers/crypto/ccp/sev-dev-tio.c | 14 ++++++--------
 drivers/crypto/ccp/sev-dev-tsm.c |  6 +++---
 MAINTAINERS                      |  4 ++++
 3 files changed, 13 insertions(+), 11 deletions(-)

-- 
2.55.0




