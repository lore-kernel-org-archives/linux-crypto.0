Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.6
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795771697;
	b=IjwQiWuhKwspiwRseiSW0xazZfgk8YWg05vp6TSjC/y0pdjtNVxYNW4fBOabWHR5yfF/
	 sHhTTJicyHcbA4UPRUWl1KvQYWP5ZUetX09xCOJQetbIM/BZszXTBTrzeZCORwHHr6TaE
	 tMrEl0P3nffk0YhtWBWWxAHT2dR34RPZz+4ELqLW9qUXft5y8/vgB+9xjATDpv+nkOMg3
	 ZPHAeFUluQ36TBL4NGWS6YO8X2euWo8vmNeL0dKLw2z5YxsF9T0zByQNYRtDLT2bQPVtX
	 HWqKOUDPXp8Z5wt6gPOs0FwAKcbQYbHavmVBfqMRU3vXDM7scJJTAoZ2WrdoolemZ/g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771697;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:
	 Content-Transfer-Encoding:Content-Type:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-AtpMessageProperties:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=O8ZukeaVBZ7wxwlYs6HZ1FcANFpO1uvt09QT6183SHg=;
	b=D2HP8KCU619MsVvleDnDwF19LCGzuyxta7ZUmHDOPn8rVg6kaNjt5FGOHshjpNRUrH2/
	 m9L89JPQbVTNBF3uWL1XEC+m6AC6YeyJNtaMPW91HOPRLu0gnG8ppUql7takWE6j3lsaO
	 y0xMrrP2bNzPYmWbB5fXhn0fnLSLGqC6ZrrjnQw/PpfLamY9a0AySDCcHrqb1Sf1Q1iKD
	 7gLnssHuWMzXUS6gI660F7L1eDyuC8Rd/BmYyDAIsOtgn4j1Br34YhwRBPFTl1s9ZAhFT
	 Y6gHs9rSox5glIrtbFDkYYSjuwk0f2tu+hRP7Vznz4hytw2VR6GzjZmJhu72vqH+Abw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=altera.com;
	spf=pass smtp.mailfrom=altera.com;
	dkim=pass header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=CS1kNExG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.196.6
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013006.outbound.protection.outlook.com [40.93.196.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74F8606A324;
	Fri, 27 Nov 2026 09:28:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B74F8606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=CS1kNExG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qwOlvw228RtfWprCLyOhz511Jtjxl3JZ41RFvAuhCdaWitbpt5Q2j+DZ/Zyi1xB4gIGSq35/TKt/LZ5XS1WAvma65Tc6aLBdWgBfGRuSVj6cXtytbvYju6uzGt1oHarOLnWH9duqb347hYNSi1tqMG+7puyNIZa3lLO0LYUCr4+RKsVGgEAbLNqIF3LWZ+bo3lktgU9QBI06oJ2qk37ZUsYuJZRYyWups4XId4Ur0wjrjx1aLN1zztQ6VKprVVltAs8vYLYgcDdeYpEhnnXmU3LiqnwzhUYapgOypBjq2BxSt6mJjHROUkCs3D9TAPZ85skv+ewTBjfg/CMoCCL2Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8ZukeaVBZ7wxwlYs6HZ1FcANFpO1uvt09QT6183SHg=;
 b=t+SdKFJX21uei0C/i7ag53y6iImsJqDOMzEYFqZmTsljCUyX0ZI+SofxjvKl7QZnG1PjEM3n2UcfBGFLw36Ef93soGtC76d1meTmvxehxW4LNYMhprWXaAE/XgPp8g1Y5YAWtI3PF+wOqap01f1EOmZiir3SsW/TZhR06MtOx4bwMx7d2m/aP3DWZF0x987gW0Fyd4dojjGR2WsA/khv4HoJD77GGygdmuPp+p4nfIdTpYSgMkLCAn9sYIbDKi8YE3706KxqvcOCZoj2pprM3eff+kmYc6zKz24XSJNcrNPBLgJ3R2Qz/28OT99NAFmgJm3rFC7INYnJAPhkYgdHNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8ZukeaVBZ7wxwlYs6HZ1FcANFpO1uvt09QT6183SHg=;
 b=CS1kNExGODfjD1vjTR2zek5FEJWrquZh2t/23N45WwD1yz0wjFM2OdnoSDiQoqZTh1zk4+WM1LwDjc5V0u9A9f+zKMZPAx6nmQhwnd7GgzxxqI+ac+pSdmHQDbkfodi4TqKfI1v87B5DXbDSyEKTyNj70yEV+B7H/vX6QoReFZy07HM6Y08WzVNjneXmzVO+I1NPuazjzXC/VVxEZpz9wpjZ9NoF9Ozupc1b9t/ZO1EGjJLsesoes6AaRQMHILYVE77vyYDS1wg5AW8bwKJv/7uRd9zxM9fm9O/M80z4RieJ39SEFuaFWBXO/jltRhpgPFrVkRb+HMmrCg95rZfF3w==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from DS3PR03MB097838.namprd03.prod.outlook.com (2603:10b6:8:546::7)
 by SJ0PR03MB6675.namprd03.prod.outlook.com (2603:10b6:a03:38d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.7; Fri, 27 Nov
 2026 09:28:11 +0000
Received: from DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59]) by DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59%6]) with mapi id 15.21.0662.007; Fri, 27 Nov 2026
 09:28:11 +0000
From: hang.suan.wang@altera.com
To: Dinh Nguyen <dinguyen@kernel.org>,
	linux-kernel@vger.kernel.org,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Jean-Michel Hautbois <jeanmichel.hautbois@yoseli.org>,
	linux-crypto@vger.kernel.org
Cc: muhammad.nazim.amirul.nazle.asmade@altera.com,
	tze.yee.ng@altera.com,
	chee.nouk.phoon@altera.com,
	genevieve.chan@altera.com,
	adrian.ho.yin.ng@altera.com
Subject: [PATCH v2 1/2] firmware: stratix10-svc: add FCS random-number command for Agilex 5
Date: Fri, 27 Nov 2026 01:28:07 -0800
Message-Id: <20261127092808.15537-2-hang.suan.wang@altera.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20261127092808.15537-1-hang.suan.wang@altera.com>
References: <20261127092808.15537-1-hang.suan.wang@altera.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0140.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::25) To DS3PR03MB097838.namprd03.prod.outlook.com
 (2603:10b6:8:546::7)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PR03MB097838:EE_|SJ0PR03MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c64319f-4407-47cf-b48f-08df4c68c131
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|55112099003|921020|10067099003|56012099006|11063799006|261022105027099003|261021121427099003|261028144727099003|261026121527099003|261026140227099003|261009223027099003|261102123227099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	G+hd1DlbDIITW7yjLp4BhGzXhrHhrCUtuX4cpxX5/zK5e61jj0Vir/kQhMJTlVFJBY0cO8XzmGB00ugrdnYdHhhZUOjuyLSolahKy+H0ur/sMsUjCNExcW36w9rPYAHZefhI3alQPkdB/Ifzk0Zsp07kaU/AQhdL1Vkntbjrvxs+5J0kKfVuoklushhCQu25FoDOqyercjrR7jQjftIOivSb5lElAuvicRGA+cDCRLKp6wL78xBtFoUyZffTzbZxarzrTq/3Bq5nAxJ6eVhccKR/oqgi9efAVpIpmkMcn5R8Gd4lcnohogEQD0sO2cxiGx38Aa9/wpdp17FQTy8gBCWRjk1e64UngkS84O4fNr0uSSdr1EfriKEoiGb49WbkmOr8Oz4eQjTGL5LFnAP7Y9IqUBok84PwXR6UDmr42GPEAZUEDlJV28p3Ot2Y+dQKnL+WSopTWnNVb/dhnp+7woVg5HUsh0JjZ6AvrOBy6+YDVO//OEi2Jb6PeI1vwRI6XN6ePetgwWN0ByUrrnj4XN1AP4rzCpvqOqLp/WAAhTt61CCb9ycN+Qg/j0fqrdnquME+zvfP6fMlgyLS/CFt9QtNuT42wAaQl9TAkyrn+E2F1VgMCem1SSRBfxG/s5ZvPjwDv3hTNHvvW/z0Gaj8mYSuTn3X/Zc3O7xrrbkfrQqVnFgyXUMN0OQW0D8kzQHkUbuYZ8crvoRx43wOp84JIg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR03MB097838.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(55112099003)(921020)(10067099003)(56012099006)(11063799006)(261022105027099003)(261021121427099003)(261028144727099003)(261026121527099003)(261026140227099003)(261009223027099003)(261102123227099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TkA6R/mzJ7k8Qridhq5KFCO2TQ73sfGOTv1HU491hmQhW1qRgdehz7oDp4Yr?=
 =?us-ascii?Q?4NP+DBg/pHDBrDF7058GROaZYjMTBC5wUglL8H/rnTUJeMqnnCmUwQRnkIDP?=
 =?us-ascii?Q?c6OUvNjst3vxxZR7dj/yaRGeyyJTSbCrp65MJBXqS08jsExJZuFiLd+MW7og?=
 =?us-ascii?Q?TGYfjhM/ZDZnzqGTFz/9Pz6XQSsUjeufpIrlSfJ4VYB0wqqt71Rf/hVGblQn?=
 =?us-ascii?Q?holRa6DUOeUU98ZdK3wT3Gesu9cfXdVzWtrPcZw5t4eufUHL2JphuMqFuirF?=
 =?us-ascii?Q?WE4OxSytLHaAD+8Ah5fZXdtBargCJl7nlr5UzFUjZDfGgQa/1CPMqW7CnsBP?=
 =?us-ascii?Q?DFRoE9WdAh8hSGMxNZ6AnFnCLMWGiYAKJvDBZ5jhUAZvyoOT/sjfmiA4sT2b?=
 =?us-ascii?Q?jvRVNpO815Ce51jWJEDfzdtSzDW7ijDCW6vKCkJstzvOy99kTvytBqud41Va?=
 =?us-ascii?Q?o7x9XIZeIj/YSwBjVlp6yMaKK5Lp/Cvxq0UL+UW3/ki6mhj2/Nndl8b4dUTs?=
 =?us-ascii?Q?uVaUtl/G5qbrj4Q7CLTHosy5Ni2o0bWLWkbF9xyvo8imQE+TSDJKuSqrxLw5?=
 =?us-ascii?Q?126LfSM0DWKJbVc3lMhP7jEPrcqjNpgXRGw4OMIwby5HrVjnS6k32K9c6BiR?=
 =?us-ascii?Q?0xUCZP2014kgTQKYV/2CgPK2a1bqqHLtSv7tF+7VDrm/9IJq6ewS/RYTihVY?=
 =?us-ascii?Q?aY7h0mM/UaGkVI8mm6Gn5JReYPeNFnFSvs+pxrK6HuT+u0CZkcWIYaiYb57V?=
 =?us-ascii?Q?pyk3GyHGq+crom2cnIN6elqxCPRH7AkSv8WejMnt6H73AKa5UHFOutXQ9JyI?=
 =?us-ascii?Q?NNAjBs1SwK7EwMFYkkw8+7mysTvTIudlnZoihKQgnXy1LP70DO66FSqN7KXA?=
 =?us-ascii?Q?mwE+R9J30HLLmOp93HWlO5V34HMMvM0FIqdYz6KuW/Z1mWfqdTqkkvtVc0gb?=
 =?us-ascii?Q?z1pz3fAUxwrQyxKFNyyYTk6y7GscVKNIZoR++AHgcN2c8iotXCOIz/Cda3JZ?=
 =?us-ascii?Q?RfgKsANVKBmt/iSZQmmBsiTQrKrxwCaTpCC0N8Uvurtr2XYO/t1cGWVxgLCD?=
 =?us-ascii?Q?D7VUpA8zclpVvggT7vAM7/b+xkGJGcSmqw9JamnQ6q+iNC5Iv2q3L5ZZUuOI?=
 =?us-ascii?Q?rSS4SrxRFRxiOO3q2QhupHVqX7FSYx1wrL35K67SGSI+wq799++josaocg1Z?=
 =?us-ascii?Q?BYb3glYz2QQMv/ZCYUHLDqmtszvVKvqrPaZKu5qYzDZN274I1ShjVMett3/z?=
 =?us-ascii?Q?b+gTGYsVT7sEEqkSf8iEr0D0Bw3vmhk1mA0dYTmpWN+RgQ6PJTTNg1UFO2MK?=
 =?us-ascii?Q?TPwaIxy1SxY0WEQZw0rk4AdOo6vWkoev7+a06k14c6ghXpNMCKjteAnuouVI?=
 =?us-ascii?Q?7BPob9JBla8JdFNk5tW7MnL7FYutSa6HqwdUe5jeawN2vDCmCgRUgtgRDkVC?=
 =?us-ascii?Q?dFVhTVHiueSW0dNRv3c3emb9rHqJatfu/BZ+22XyWgcTY24qc0C0/Tj8DWRo?=
 =?us-ascii?Q?pjvfDnr133Sj8hnuzURkV5kNE3uJdhmzh42Dc80NbY68zddOEI4nd1LHgz2z?=
 =?us-ascii?Q?vzLBr4lsK2XhmjpQJyZn9fJtwERrzJv3vY6FPsIGJ8mGL8gTGJjudvYK1C13?=
 =?us-ascii?Q?QKAHalY9oB+HOnqsUDnW57NuH0ScD6MfWtR9RGnpYmCDBa4siG3XXR1iMkSB?=
 =?us-ascii?Q?0ZwC+3mx4E8ZPjFfFHrXWkZtuEuW0jXdfZY/mX/AjbUSb5I0SapPSkMF9yoQ?=
 =?us-ascii?Q?aoafw85tQy1g1stm6d+oJr8qoQDwHxE=3D?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c64319f-4407-47cf-b48f-08df4c68c131
X-MS-Exchange-CrossTenant-AuthSource: DS3PR03MB097838.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2026 09:28:11.2387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpCWHwcnQXZr+cZ3vdnGNLpeRjUWiwq1rpuyFtk12em92Fkc4619ikGwB5yeLz+yms/DMY2V2q7jbBgNvcOAeXtKgvgqDhRvd+IUX3KhmGo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR03MB6675

From: Hang Suan Wang <hang.suan.wang@altera.com>

The Agilex 5 Secure Device Manager (SDM 1.5) exposes an FPGA Crypto
Service (FCS) random-number primitive over the existing SIP SMC
mailbox: a session-based interface, alongside SDOS encrypt/decrypt.
The service layer has no command to drive it yet.

Configure stratix10-svc about this interface so an in-kernel FCS client
can use it:

  - add the asynchronous client command code
    COMMAND_FCS_RANDOM_NUMBER_GEN_EXT

  - add the matching SIP SMC function IDs
    INTEL_SIP_SMC_FCS_RANDOM_NUMBER_EXT and
    INTEL_SIP_SMC_ASYNC_FCS_RANDOM_NUMBER_EXT, with their register-usage
    documentation

The transport is unchanged: Agilex 5 reuses the SIP SMC calling
convention and async mailbox ABI the driver already implements, so no
new transport mechanism is required.

COMMAND_FCS_RANDOM_NUMBER_GEN_EXT is dispatched as
INTEL_SIP_SMC_ASYNC_FCS_RANDOM_NUMBER_EXT. The session ID and context
ID are taken from the client message. The destination buffer is the
physical address of the service-layer payload, and the payload length is
the number of random bytes requested (4080 bytes at most). On completion
the value returned in a2 is passed back to the client, as for the other
asynchronous FCS commands.

This is a prerequisite for the SoCFPGA FCS hw_random driver, the in-tree
consumer of this command.

Signed-off-by: Hang Suan Wang <hang.suan.wang@altera.com>
---
 drivers/firmware/stratix10-svc.c              |  8 ++++
 include/linux/firmware/intel/stratix10-smc.h  | 46 +++++++++++++++++++
 .../firmware/intel/stratix10-svc-client.h     |  1 +
 3 files changed, 55 insertions(+)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 386673bc093f..d6d1cf19d5a5 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1643,6 +1643,13 @@ int stratix10_svc_async_send(struct stratix10_svc_chan *chan, void *msg,
 		args.a0 = INTEL_SIP_SMC_ASYNC_FCS_CLOSE_CS_SESSION;
 		args.a2 = p_msg->arg[0];
 		break;
+	case COMMAND_FCS_RANDOM_NUMBER_GEN_EXT:
+		args.a0 = INTEL_SIP_SMC_ASYNC_FCS_RANDOM_NUMBER_EXT;
+		args.a2 = p_msg->arg[0];
+		args.a3 = p_msg->arg[1];
+		args.a4 = svc_va_to_pa(ctrl, p_msg->payload);
+		args.a5 = p_msg->payload_length;
+		break;
 	case COMMAND_FCS_SDOS_DATA_EXT:
 		args.a0 = INTEL_SIP_SMC_ASYNC_FCS_CRYPTION_EXT;
 		args.a2 = p_msg->arg[0];
@@ -1757,6 +1764,7 @@ static int stratix10_svc_async_prepare_response(struct stratix10_svc_chan *chan,
 	case COMMAND_RSU_NOTIFY:
 		break;
 	case COMMAND_FCS_CRYPTO_OPEN_SESSION:
+	case COMMAND_FCS_RANDOM_NUMBER_GEN_EXT:
 	case COMMAND_FCS_SDOS_DATA_EXT:
 		data->kaddr1 = (void *)&handle->res.a2;
 		break;
diff --git a/include/linux/firmware/intel/stratix10-smc.h b/include/linux/firmware/intel/stratix10-smc.h
index fb01116c1cb9..601f14bc8e29 100644
--- a/include/linux/firmware/intel/stratix10-smc.h
+++ b/include/linux/firmware/intel/stratix10-smc.h
@@ -669,6 +669,52 @@ INTEL_SIP_SMC_FAST_CALL_VAL(INTEL_SIP_SMC_FUNCID_FPGA_CONFIG_COMPLETED_WRITE)
 #define INTEL_SIP_SMC_FCS_GET_PROVISION_DATA \
 	INTEL_SIP_SMC_STD_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_GET_PROVISION_DATA)
 
+/**
+ * Request INTEL_SIP_SMC_FCS_RANDOM_NUMBER_EXT
+ *
+ * Call used to query the random number generated by the firmware.
+ * The maximum random number is 4080 bytes.
+ *
+ * Call register usage:
+ * a0 INTEL_SIP_SMC_FCS_RANDOM_NUMBER_EXT
+ * a1 session ID
+ * a2 context ID
+ * a3 size of the requested random data
+ * a4-a7 not used
+ *
+ * Return status:
+ * a0 INTEL_SIP_SMC_STATUS_OK, INTEL_SIP_SMC_STATUS_NOT_SUPPORTED or
+ *    INTEL_SIP_SMC_STATUS_ERROR
+ * a1-a3 not used
+ */
+#define INTEL_SIP_SMC_FUNCID_FCS_RANDOM_NUMBER_EXT 143
+#define INTEL_SIP_SMC_FCS_RANDOM_NUMBER_EXT \
+	INTEL_SIP_SMC_STD_CALL_VAL(INTEL_SIP_SMC_FUNCID_FCS_RANDOM_NUMBER_EXT)
+
+/**
+ * Request INTEL_SIP_SMC_ASYNC_FCS_RANDOM_NUMBER_EXT
+ *
+ * Async call used to query the random number generated by the firmware.
+ * The maximum random number is 4080 bytes.
+ *
+ * Call register usage:
+ * a0 INTEL_SIP_SMC_ASYNC_FCS_RANDOM_NUMBER_EXT
+ * a1 transaction job id
+ * a2 session ID
+ * a3 context ID
+ * a4 buffer pointer for random data
+ * a5 size of the requested random data
+ * a6-a17 not used
+ *
+ * Return status:
+ * a0 INTEL_SIP_SMC_STATUS_OK ,INTEL_SIP_SMC_STATUS_REJECTED
+ * or INTEL_SIP_SMC_STATUS_BUSY
+ * a1-a17 not used
+ */
+#define INTEL_SIP_SMC_ASYNC_FUNC_ID_FCS_RANDOM_NUMBER_EXT (0x12D)
+#define INTEL_SIP_SMC_ASYNC_FCS_RANDOM_NUMBER_EXT \
+	INTEL_SIP_SMC_ASYNC_VAL(INTEL_SIP_SMC_ASYNC_FUNC_ID_FCS_RANDOM_NUMBER_EXT)
+
 /**
  * Request INTEL_SIP_SMC_ASYNC_FCS_CRYPTION_EXT
  * Async call to perform encryption/decryption
diff --git a/include/linux/firmware/intel/stratix10-svc-client.h b/include/linux/firmware/intel/stratix10-svc-client.h
index edd7953d5d08..c924dc9a6ef2 100644
--- a/include/linux/firmware/intel/stratix10-svc-client.h
+++ b/include/linux/firmware/intel/stratix10-svc-client.h
@@ -202,6 +202,7 @@ enum stratix10_svc_command_code {
 	/* for crypto service */
 	COMMAND_FCS_CRYPTO_OPEN_SESSION = 50,
 	COMMAND_FCS_CRYPTO_CLOSE_SESSION,
+	COMMAND_FCS_RANDOM_NUMBER_GEN_EXT = 81,
 	/* for extended SDOS encrypt/decrypt */
 	COMMAND_FCS_SDOS_DATA_EXT = 82,
 	/* for generic mailbox send command */
-- 
2.32.0

