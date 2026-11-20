Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795168305;
	b=RcsIsYv9j/9QOi34hM4UDBBUOkxHuW+WzvAUXLcoUlANsOcOkd5vlZP5rlAMKyaIcw9A
	 2cay7KsdqvyDz01DbK56qwaRuFm20luF71Y/sPADlneNDnQd9czJBAoCZWnb9W03oE+AL
	 3d0OeTLY2K10trwXpLTL8LaHdaLi67kt9jnUVOeM8I2omdGMYmclH3KcTF+Rgt6picAAE
	 g5afVY3tdukWUoDGi/K5H3VsQTy76qbLxrPa9DXjtFSeKHn6fQscQsGz9ggH0G/Er5TM/
	 JZWpRTulU5ATHvAC00rLyS5PMq2ElXPtAtBUpxp6SWnoopznlzFHaaOOcMwhv1qdGWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168305;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:
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
	bh=i4ElZwL2u81T0oV0tEQx8nZpBssmMjA/CBKYMEBIbqk=;
	b=H/+Oi+YsNTQDlfuppJJtujBB3lIqROmYjBclqO5ttuEQs3OArU7zTy9gBiy0B+sI07jz
	 7ma5YDYtuT0VyysrvqfpVvRML4UVz6iNWSbns5F131pN32LsRLD3CjlrWhmkx9ZvUdwwU
	 oAn0J55BigcwMPUVYOYKwfwAaOODr944MTGh+jeSfq1jWWGJBHc8L++xp473uxfIFi931
	 hc+yE3mFJoTdIuAtmrY2T5XE4xDlwc5acxbkPteBHVC3woqtPZFpJtFUcsuL1q+wK/ZLU
	 je7P/WVWNkDh/lj/JCzR7zx6I7I8HvAtt23Q9tZWk12tzbE78I82lD0LqZfUsyizmEw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=altera.com;
	spf=pass smtp.mailfrom=altera.com;
	dkim=pass header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=M3XZhIRa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.64
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011064.outbound.protection.outlook.com [40.107.208.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43E4606A33A;
	Fri, 20 Nov 2026 09:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B43E4606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=M3XZhIRa
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yzN9Uh4+vPDx81plIL6xgulazN07/vHwYQor9T9oz2s0lEThNKP76sHUYQrWsS422mnaUAHqnEBWxJX8l+ZBwx/YSVK+r9JFIddQy8yAM6l7ebyOBqd0iWQXH3tilWdupRpf9Zc1mdg6qcmEHcNkpOdXcAPBbSwWD4EpzUY9XF+7w76CAjrjc+EcswzM8Xj1QqGH4Q4XAy48CRBp7J9kuGHTHMB50yRzaelGpKnDVwPY34QRcXSq2kfFv9h9YXY80m/djjSDpt2A/eegdn2zj7jKFdO3DJlkPZ0DEZxhtl1um/HexH+U3uaszVohc00XMuNtVy9PigDrkmRiy028EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4ElZwL2u81T0oV0tEQx8nZpBssmMjA/CBKYMEBIbqk=;
 b=VJ7lsbQFSBglPkOLMsDz/EpZa+L60izkLzgo6h2dIiS0fAr/Tayrb8lqJtg56SvxESADWvTVrZi3OxRWdAJzHyGiAIZsdzT0Zp/XZ7uBBFqwKSxYgOZ3PV9ud4Ph4SdGJhg2TNZ7/W1vDwLEerl8M3BKcbnowZWupgZG+pIAhP9udFi5CS3zYa2iV5obUvisz83NTrQlbOIBexXHxZHzqVZ8+JDZ5AjsDOyYsYQccCH6/tK0HjsJTH7ZZsi/X77grnXqyqwHAEoat54dHlHcATn5S5uorpt/lRY6UDXGW4JYhrX6KwWyuUs7Gf1lM3k2VI8bYadpi1OEPnegCPFoCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4ElZwL2u81T0oV0tEQx8nZpBssmMjA/CBKYMEBIbqk=;
 b=M3XZhIRa2H94fTjaiKBnsusFTEPgGYOzC5igPcDN6I9jjP44eYBCzCF5R38bpjwa0UhYtNgBK1OO8FBuQ2IpKHxbi/7px7Yc/mwmK1PpLklQePF8fkgfA7g83PHv4rmcm4MfKjwZire1qakHXo7qDPMOuPxa80bqgNFEX/bC5GWPUmxjIUVi/CpT4RXYBVP4mLeNQszafCtyUdj1lM7NGcq0sSVa7WdLFZCgXEapx1pDeEG4cxuNPsx+Jr3OoWm1JlPv8pq6mJaT/wwgwMmstm0Sg6QmA5WqLfwnDvQ3ko40Dblbi+0YQ6ujygcBKY+KCyqAZwPIpdvzlPo5YbiGMw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from DS3PR03MB097838.namprd03.prod.outlook.com (2603:10b6:8:546::7)
 by BY1PR03MB7946.namprd03.prod.outlook.com (2603:10b6:a03:5b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Fri, 20 Nov
 2026 09:51:37 +0000
Received: from DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59]) by DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 09:51:37 +0000
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
Subject: [PATCH v1 1/2] firmware: stratix10-svc: add FCS random-number command for Agilex 5
Date: Fri, 20 Nov 2026 01:51:32 -0800
Message-ID: <85200a2c0f9bf3196f6bc2972d4b8808d072262e.1795167624.git.hang.suan.wang@altera.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1795167624.git.hang.suan.wang@altera.com>
References: <cover.1795167624.git.hang.suan.wang@altera.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY1P220CA0008.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:59d::16) To DS3PR03MB097838.namprd03.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: DS3PR03MB097838:EE_|BY1PR03MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e0583b9-3c4a-4d7e-69b8-08df46ebdea3
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|55112099003|6133799003|261009223027099003|22082099003|18002099003|3023799007|261026140227099003|261021121427099003|261102123227099003|921020|261028144727099003|261022105027099003|56012099006|10067099003|261026121527099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	2kaUECGFY/hE106Dmmn29KIE9EkZw3lKSP3jogUPxfftZRAiuKF1g8R//wpaOcF7BnKJqTp6TqQ0tpPs3rlbHv93Xf8HidZrraiQEWi+eBXYoJZqy1IUj26W98PoFJh0HnntVtsM+B09+TDOH1ETD6Hyeg+3R0uV1GldO1gacjDXZ7V8qCwgzKRZCHknAth+7WvAf0DFCmWWzHLg+r0aqBlRCm64dK1flCztzyj/xtNaQa3NEF6jxhpEfNavnQ7FShNIAzaB8rRGyhi6Vno8ZGEDL3UcDUaXrr86WarXT2bbAsJUFiRaBzmChuj4Kt4gncnlPRRgZhVypZUv4VUEiLxbxDCGbhBMpCS/4HbPOpdVGVrDVrLzq2qjzj/4wgTWJ49quhinKs/ZuS0B+qqKzCyIOumfBCpKFPhzUZMVqCgzpqrufIdOO6xZb1kSocD/BQTFaNE/x356naHLcqnaT7vecliG484JYEqTsr59fDswUafvVuJm6kv7GDBWbd5/hfMOJxwJ3gkvMNYaHaeFD0801Tm9FF/ERoynyNRh3jxiEO/X+H26XcztL1pknB7wCcnaePCGaPjGna8JA0nv853XZJujii4dFfFerPhtYj5W8UzhF9ejR3qfG4NXOZ1ZM8IgFgArfD0izi7DwoluKYJOmdjC/UkG33W4BGD1vr1KGXf3wRhrdPNRbdGkqeC0Zl+DYCZ7Wf8zR/e9/zDl7w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR03MB097838.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(55112099003)(6133799003)(261009223027099003)(22082099003)(18002099003)(3023799007)(261026140227099003)(261021121427099003)(261102123227099003)(921020)(261028144727099003)(261022105027099003)(56012099006)(10067099003)(261026121527099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8fM50ECYlaZTcByN03e4OuuVE6aUeZuPj9lS0kuk9cdzB0EujTVz2gHJEE2s?=
 =?us-ascii?Q?L/5kXeqitdi13sM0ZXxOzzcQnfafNkPwFNEQhotNKrQQnxaYpGzE+iAID223?=
 =?us-ascii?Q?M5JA7odKA/u0Aw3fzbhnOklYGoz1AK9OCEiz0ZxkixU2CHuwzmYk7GP36kop?=
 =?us-ascii?Q?Wrd6h7DOC0AwagHg50EQ2h7Eby3t/yCHceWHRXXT+HQO976N7iepwu8WKote?=
 =?us-ascii?Q?1Oo7JG2KgIaI5BuLaXMOmLP5aMjVf3xD0u4FNV3v924lUCztNbZrzNYxVDZV?=
 =?us-ascii?Q?e3lxMaIoPkcLX+cISsE7caFDyq7FeqcJ8A58aAoRIP9mhIjdTVdf20XJ8x8/?=
 =?us-ascii?Q?2dhdbBLGXTbL6Sd2/6VFVYy3ccXA9aRDCYIAAHHByD+s4SaPOLcd+v8aZB/P?=
 =?us-ascii?Q?Q5MRApEXYD+XdYkU3r+7Bqy8Vd8qtrePM38k3IccEeAmU+0PeeM0sr2NTbCo?=
 =?us-ascii?Q?tHTsM1PLmdglYw6D2OXG8nLcfFObDaJRI2fnJzrS5SM0RdsxCddfrc5jFJ70?=
 =?us-ascii?Q?4rFLUKBZaJqX5z77r3HYUN6rsYlhNhFvIbNdokx++0jJYGVD9mlE6xy2iNnu?=
 =?us-ascii?Q?MF3bMM/dpiUZJVpZtTxob8Wd1rY1ZAZmr5F7yE/zCOYjHfcaMPL3DNB9heCe?=
 =?us-ascii?Q?L211/AUSzJ1hnGnXe+2KXOK031eWUH6xk+0IOOaH4ivSnzWX14wPLrtCQCHi?=
 =?us-ascii?Q?5XdBsnD2zjtdiPP/tXbPaVuZWzZQBSm6ZRLu+Yxdqf60Ewne1OZEmhAR9bNz?=
 =?us-ascii?Q?eiYZUG+nVC3hWEdo00ca9FdNrsQxX9h8ZVT7bS78rSupGXbOGzUN0ZRbHGLq?=
 =?us-ascii?Q?+YDAFDn2xFO5ukvomQpOoMe+DLlyOkM79pk/DuOZUbPPGz7pgGG8LNwACPC7?=
 =?us-ascii?Q?iHIVoIzeS+WMfjq6wvBa6hS/GARJObZNHmUUWyf/O0IIi+i17dcOjk/FTH9N?=
 =?us-ascii?Q?Q15C31G9sRpm7NMWM7utlHkf0KMSp/uFh4VyTZnYsDd3hY8ru4RzfCLLkAWV?=
 =?us-ascii?Q?HKwLDbyAlDTBrBnzbOLyLDnOBJsbxWEby9ramb2EFWSQ9WnWPStv8WsymZT6?=
 =?us-ascii?Q?FccVpAMI8SiSP7MC/UIcIFJ1qhgBeRURMuTgfL9UC+Bl9JDF5Wp8f6G1k3mP?=
 =?us-ascii?Q?JZople9u+rjVOHjSLeJyRLafBDjNSZ7NSPSSlvG+1/Op/3PqTUdgDzFXiVuJ?=
 =?us-ascii?Q?+ggldNzJvKbDe5AsAkEss8+9nlRm2RTrMwWy5+/OAduO2JsT/pTSruoywDLG?=
 =?us-ascii?Q?NbwLYqowVwtmp27lPS0Wwzogu/KLGxT43i4EQDfzTnWD284A7nPMr9AGYAAm?=
 =?us-ascii?Q?9VsuVBagXFWuuyyUOAb8bR04JqEOb4kujFQvMiZzdxdJhdi9zaBq2dvMMNgA?=
 =?us-ascii?Q?JcZS5zsdn4a0zgwpGsK4rIV147ccpEOh/fcUI/fBHgxA6SGG+C/ta9LSVqd5?=
 =?us-ascii?Q?Ymo9pGAclCcPDiRTZ56phkTkCjV+qngcy6r+tLm++cKMOGuP3kRhwMgWxLrI?=
 =?us-ascii?Q?5Psu29eWTKh1qwER5B6jCZGooQTHXb/3cGIV8iUaaI0ldZzWzRLj3wpi+IxG?=
 =?us-ascii?Q?o8F8Escp/St0QVBHFn61aB7BPBWxtrqh9EH9IQhZUws/RCGjwhCm+F/HGxvG?=
 =?us-ascii?Q?PvWoRhSFiU+pDG03Ag7J3e1NW2G7H8g2mSQPBxeLbIvFOUjESIskxUFtJ3i5?=
 =?us-ascii?Q?T/8Z8JUUC4xDozcLziych46rDPvvoOpSIjvCfmb8eYYlrOqrP7UlBgZ0O7IL?=
 =?us-ascii?Q?YTwj+cvS4w=3D=3D?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e0583b9-3c4a-4d7e-69b8-08df46ebdea3
X-MS-Exchange-CrossTenant-AuthSource: DS3PR03MB097838.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 09:51:37.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zgto6h8uIQLPn1xkimtphDetFGw20iUXUnAEPYetenTz9ZMo6NgLfEEi72XbRRw/TWZu6deRzcZP2BcoSdYYlbVfo2dDkuTcvwoY/a2EhcU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR03MB7946

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
2.43.7

