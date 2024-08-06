Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2051.outbound.protection.outlook.com [40.107.22.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637CC1392
	for <linux-crypto@vger.kernel.org>; Tue,  6 Aug 2024 00:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.51
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722905211; cv=fail; b=JAQLBkfOnTEzfVoGVeicYqKJ6lNwXeRf54yHzJaVmI2DlYlIpxGTuuSBxx8PXKvvKjU/UAr/8CFiQ2wrfXk1N4l/4yLM9ubnYhRXQm9uOBsb38teT8g56S7RkDtEZ15kTYefdiVSAN9PlAW5MJeeIzxF2VLvsKCncY9HcEVAwQ8=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722905211; c=relaxed/simple;
	bh=itRRMdeBaJMC5Jowouaq/A8q8qFu8EsW4wwNMnxPors=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jEjZ+0u7ORq/VPRMW6mCxJnMShaR7Nz9BXi5E/O/8wySq8XyoLkfFuYolRR+Ef4hBJH3VATPQoyRdYXlz283UBVdr+amxLTmPABVlYd0k+2f8Af1U8IsC6KJ9Gc8lEzjqPi5oq6AMSYmGAFqhtugClkBILEggV7tPpyNQOAY2LA=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TCDyEle0; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TCDyEle0; arc=fail smtp.client-ip=40.107.22.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TCDyEle0";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TCDyEle0"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=arxk5hUyd9NMf2Uon/7Qcd9EO9X1JEGSVdhW+l18k2tRGPZvEr8MN5L80t2Po+iAHgiGGDVjBzIkXhWm/J2qFbFMaIH+PHZ15hNNosV0EUKGz0OX6Rixpd6B2SsZlJ8/D8ctzo+BgaRqHvxtb6eDB6/PbvaEuEwphCA5yK9nqldeL8ivr+EclgFYJOhUVXd3BAK1Dut7QxiI27HCjaTRTHkqns9k5TL4WeA3yrXTPuxtKRSHCm4YD7jin/W3t4/MHvfaw2ZRmh0R8AWpLNtzSycBlAbUpKyV4I8aSFdg6JovbjOV4iFCTL8FPWaAGuFEtm0b5qPBqmU7UV4SvGMRPA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itRRMdeBaJMC5Jowouaq/A8q8qFu8EsW4wwNMnxPors=;
 b=gxj6LNfbndPo9ABIkmm9M0PqL6Op38fS5IREo8DsDgBJQL5ec86zLgYCE95MOsKV8dFPdUBQi0FOQeInRDLHR3DRRP5kMzwRNMYJ9S/Px1jSOysNlWvDyATwwRhyp/A9KveWi1rWXznTgd4ot5GnXoofrY0VmmOmBVtYl/1P/9EUxD93sqjqkhKmxyqkdzV7Twz8MLDt/9B9bbuKg+ll4xiRvcH4dSvu9gFo6dc4K2Y2Vd1SJrRnDYtAkfZ7T6jW5ELwGNWobdO35m9IIL03JAaGJgjvauC2svyhYP74vxWT0Bbb/KiM6yErXA5d9LVHwkTzoUzeJEAkUp8eiPutcw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itRRMdeBaJMC5Jowouaq/A8q8qFu8EsW4wwNMnxPors=;
 b=TCDyEle0bsl4aVTKW7dafBnr9r/3VRgfw3O0xtImxsZdaZxNqP6CwWTEVJcyKRkbqzoEka7nKxSRB055vI77AdC2dlHShwU+tB4jdTWFpRSbGTNkXZ0CeRqeMqeTg8/lfyl1ZkejI0rTOXnZI63nUy2OBP0G9YmBiEv/e4OcHmA=
Received: from AM4PR07CA0002.eurprd07.prod.outlook.com (2603:10a6:205:1::15)
 by AM0PR08MB5362.eurprd08.prod.outlook.com (2603:10a6:208:180::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.27; Tue, 6 Aug
 2024 00:46:43 +0000
Received: from AM4PEPF00027A6A.eurprd04.prod.outlook.com
 (2603:10a6:205:1:cafe::4a) by AM4PR07CA0002.outlook.office365.com
 (2603:10a6:205:1::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.11 via Frontend
 Transport; Tue, 6 Aug 2024 00:46:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM4PEPF00027A6A.mail.protection.outlook.com (10.167.16.88) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7849.8
 via Frontend Transport; Tue, 6 Aug 2024 00:46:43 +0000
Received: ("Tessian outbound edeef5361dc2:v365"); Tue, 06 Aug 2024 00:46:43 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: be64b98c8eddb77c
X-CR-MTA-TID: 64aa7808
Received: from L4edc619290a3.1
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id B7E048D7-676B-4134-B889-E51DE5D831A1.1;
	Tue, 06 Aug 2024 00:46:37 +0000
Received: from EUR03-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L4edc619290a3.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 06 Aug 2024 00:46:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f/+Nv2QIbpgOvHvL/DZSl36cpYo5/jo+8kFTmCrUDv2XIaQKIuyR1BMAEceuOIsenJYKwfMNxMXxbfFYTO2JHaDuB3zqI5spBRgMzqlJpYikK6sQ4/7M2h7fie9edwFsNr4sRgUWZbeqln8YC9uD6y3wBS08mWSRV5Oa0PtlthY9oygTLy7dUgmp9+zlrTdO991rXUaGEtnwIeQp+5yGRcDFX02i4BfrkqqoAJuiGYv95TWlsGGt4X/FwkjWS20TEu939kMrYb1n5Xuxh+bvYrKhjBjPigxL5n8nYhUo916cdEqaERyCLMq28V/WPhqa51vNKqliAUu0jZd6r+pW6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itRRMdeBaJMC5Jowouaq/A8q8qFu8EsW4wwNMnxPors=;
 b=NGAktZJH1hp9R8KwiBuFfxmoVmfFh7xAA/OrKqCCf9rXadtNThLelSVezw92shu3jHgnEn0ubIJEqM0vmcnYtnOlr8MzZeeM8/JyIwnZkmO1ljMaHKxsVrCByH11NH/PEtqQGXfOzg4scCuNZDlx2L1gzNVTNVuRXOOSZotY5rtCIZ+ziN+TLm3Q7V6wWLMKWuCCGhhjmkpPAd4dC+Puc4LeRHbXD25txVjVpmTN752WFG3zdCLQc2tNCMHlYlbEpepnFrVxaKlJmuH1NwpbdAMG7mm723wGK0Firc9+Jr0S7yxbfcJmDiYgRFOxMt4cijl9sq4/MymJg5k8wY3iEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itRRMdeBaJMC5Jowouaq/A8q8qFu8EsW4wwNMnxPors=;
 b=TCDyEle0bsl4aVTKW7dafBnr9r/3VRgfw3O0xtImxsZdaZxNqP6CwWTEVJcyKRkbqzoEka7nKxSRB055vI77AdC2dlHShwU+tB4jdTWFpRSbGTNkXZ0CeRqeMqeTg8/lfyl1ZkejI0rTOXnZI63nUy2OBP0G9YmBiEv/e4OcHmA=
Received: from GV2PR08MB9206.eurprd08.prod.outlook.com (2603:10a6:150:d5::6)
 by AS8PR08MB5926.eurprd08.prod.outlook.com (2603:10a6:20b:29d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.25; Tue, 6 Aug
 2024 00:46:34 +0000
Received: from GV2PR08MB9206.eurprd08.prod.outlook.com
 ([fe80::d431:f1c3:a2b9:5162]) by GV2PR08MB9206.eurprd08.prod.outlook.com
 ([fe80::d431:f1c3:a2b9:5162%7]) with mapi id 15.20.7828.023; Tue, 6 Aug 2024
 00:46:34 +0000
From: Justin He <Justin.He@arm.com>
To: Thorsten Leemhuis <linux@leemhuis.info>
CC: "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, Herbert Xu
	<herbert@gondor.apana.org.au>, kernel test robot <lkp@intel.com>, nd
	<nd@arm.com>
Subject: RE: [herbert-cryptodev-2.6:master 2/9]
 arch/arm64/crypto/poly1305-core.S:415:(.text+0x3d4): relocation truncated to
 fit: R_AARCH64_ADR_PREL_LO21 against `.rodata'
Thread-Topic: [herbert-cryptodev-2.6:master 2/9]
 arch/arm64/crypto/poly1305-core.S:415:(.text+0x3d4): relocation truncated to
 fit: R_AARCH64_ADR_PREL_LO21 against `.rodata'
Thread-Index: AQHa5gRTG+0EzOOIxkimUsdk+rcvALIZA84AgABj1EA=
Date: Tue, 6 Aug 2024 00:46:33 +0000
Message-ID:
 <GV2PR08MB9206F98238936874A3A82D9AF7BF2@GV2PR08MB9206.eurprd08.prod.outlook.com>
References: <202408040817.OWKXtCv6-lkp@intel.com>
 <4bba778c-79b6-49a6-9839-5f492cc4251b@leemhuis.info>
In-Reply-To: <4bba778c-79b6-49a6-9839-5f492cc4251b@leemhuis.info>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV2PR08MB9206:EE_|AS8PR08MB5926:EE_|AM4PEPF00027A6A:EE_|AM0PR08MB5362:EE_
X-MS-Office365-Filtering-Correlation-Id: a0bd0f71-7d7f-40ca-5090-08dcb5b13e04
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?ajZyNVBhYmFFMDNjOWJpQno5amlHY0c3T25iSFdZZkNYYU1aVzJMNlV5Vm8r?=
 =?utf-8?B?d0RRaFNYcXNpbXJrWklzWUVjKzJnc0MzSHF0UmY0VVJuaWs4VmIwQzlKaWpL?=
 =?utf-8?B?QmdrcmVYZGRMelpYL28zcGZ5T1dhN3AwaWIvQkJSQUk0bXhtOGo1aThIWmlv?=
 =?utf-8?B?c0RwWUpzS1FpU3lGUFZYQndkZnc2MjZOdWFOOStKS2NNNEVrdmVXMHVPZjlF?=
 =?utf-8?B?WmMvQ2JnU2REbVYxeUJHNkJZZUs5YnRzN2tJTFFReW5nWHFLdVQ0bmNBMDJv?=
 =?utf-8?B?V2R1UXZ0UTJKM3J5dlJZbmpMSzEwL3lWQnpYVzhKR05hNXFwcWphNnNmNkk1?=
 =?utf-8?B?NnJsSVlrOHNqOVFYOXV3b085R0dnYTgxdGtxQ1FaSlg5TzNzQjRpUUR3SjZ1?=
 =?utf-8?B?N0d1LzNFcXhxMnpJZFU3Y1QxclNkOGFLVHNIdHV1Q1BuMnAzdzNVcGhzb0xh?=
 =?utf-8?B?U0h2Y2dJdkFWQzBRc1ZIdTJKOGZIek9xT3VtcWgxWXJEYlZMSEdxMHgzSkJk?=
 =?utf-8?B?SjNzQ1NVYlFPSm81UTFlUmFZZzd5ckVRd0lIckN6QWUrR1dobVkxUXB3eG9Y?=
 =?utf-8?B?UFQxS0JNL2FHSEZWbFVaZUZJcXRSRi9RRDJYUSt6QlJJOFQ4L2Q0bHp1YjNl?=
 =?utf-8?B?R0JnbnFGY2FuZWRubnRpVjU2c0N0R3BZTC9WanVDeThCTVRQL3N0RDVXZmJJ?=
 =?utf-8?B?bjRTRE03NmNRTXNoeVJDSlFwZjRzaW1ZeDVxZHdqZGEzSFI1djJGaVI2ckxt?=
 =?utf-8?B?Y3B4akp1c1RaV2RxTlBFU2twRXEyNHU0K1RIWmZsM3FQdm0zT3VVa0IrUkVp?=
 =?utf-8?B?QzBhaURXTk9kTlF1TkhsUHczZElNN1ZIL2tPTlZnN0VHSUFzMHU3MERSQ3Zy?=
 =?utf-8?B?SGdKSGkrek0rUGUyaVZZV3pmb290Y1Q1QkoyMUxTemw5STFhRm04elBrczBM?=
 =?utf-8?B?QTVBeFhoclJSdElla2JiTSs2TDE3MFlMb3dkR3BYZHB6R00vYktYVTZ6S2dC?=
 =?utf-8?B?ZDFXejFsRzhzS3NSaE00aUFOWGtWT2luS3I0WGNKbTFwZlpGNDV1NDV5Vk40?=
 =?utf-8?B?SzFxSkdsZGt3UFB1WXFkTmFxVjRUcEF2SjB4OVd0b1UxQVZ2M2k5elMwSDVQ?=
 =?utf-8?B?REpQSk5LMElqTTNYd1VIMHJkMWVSSVh1czRScWVrdnpzMW9LY1kwTzQ4bzha?=
 =?utf-8?B?aWNYRFpwY1F2U2U5RzcycWIyb2RseDE3VGFwVjgzRDBoZGN6OUVWbUlMeUpT?=
 =?utf-8?B?WWNuNTB2OHlVY2hiTzZWb2ZodDZnbVBiZGZSdC9BUk1XUnV2YjZLOUptc0N5?=
 =?utf-8?B?QzRnZGVuZXArNURmakR1R2NRejJnQTNxcmFwa21mVWpuZlFPRHdKTFVSTnEv?=
 =?utf-8?B?cTllS3h6U0VJanFYMjJTZld4bUtnNXh4UzRvdHdlMjFFNFczZEdMTzAyZUFa?=
 =?utf-8?B?TTdqeVUzTEdyTjZYSHNHbzR1L0JQWmhOZnpGMnkzdEYwam1ZN0UzUWRwbWE4?=
 =?utf-8?B?QlFHY3BWOFJrZDlaRzZqdlR0UHpQaWlRcllUYXlUdjhDRklYZTNoUFRRc1Yy?=
 =?utf-8?B?NUI2R2hMRzhkZ29DZC9LYWhwZ0VzTStYSjRucmxOVFQxb0dPVFFoZmtWUnVp?=
 =?utf-8?B?bzBCdlpzZjJoYXZYaDlXd1haRmwyc24rRXNER3dnd1lCMnN0ekZ2R0JrVWpR?=
 =?utf-8?B?OHJtbnRmL3lncTlqTG1BaWdhRFB3TXl6aTdyRzVETDZBNFVkVW9IblFuRGhB?=
 =?utf-8?B?ZWt3OHNubTA0TFRYNjZIYjBoRnkrOEcvVTFvRUJTM25TcDkvNko2cGd4Qmpi?=
 =?utf-8?Q?+RjtfAC7b/b9iHOP13D4VPTnar97JxG+FGd6Y=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB9206.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB5926
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:d5::6];domain=GV2PR08MB9206.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	e4e7ceba-31bb-432b-f8bb-08dcb5b13869
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|35042699022|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bzlZejB0UWpUODN0d0tUUi8vYWxqV0VQTXEzWG5VRWdNbE8rdFNqMGwyc3N2?=
 =?utf-8?B?OUtjN2RxVW5uSU5Gd2FIMlQ4R3hRQytuMkZFTVBhOFBhY1phMUNXNnV1dzBO?=
 =?utf-8?B?b0dWYkttcHF1ZDIzbmJiajlDMkJjaGJCMktscDlhVTU4cC92anozNnFvWmEz?=
 =?utf-8?B?SzMxRGtDR2ROazJnUjEvNmExNkNjQjJUTGY2RnZoOXRJNTVBampVbXYvWGFx?=
 =?utf-8?B?eXBRd2lMWFdvTU40dVczS2ZLb0NlRk5udXFqZ3FndlRJZ3ZFZVFlcmFEWWxG?=
 =?utf-8?B?bmVvbjJweUhFTmdPdzRiSzZpRXFGaW1vcjBWQU5NejZKLzh2dklQRDk4QVZE?=
 =?utf-8?B?MDN0MVlYY2xqUGszNFRSWXZoaHJqZXdkQWRJeW9sR1RCQXI2TE5QbDJPRlhV?=
 =?utf-8?B?VVNlUzBKdkpKM1BVL0R3d0J4bGg3L1c1U2ovWjdsOFFJSk9TYXpkRXljUk50?=
 =?utf-8?B?Ni9FUHlqZ004ekdoa3BkeEdKb3kzRXdpR1BxVWNYNEIzQWRyenhXQTk5bUdo?=
 =?utf-8?B?dmNNNEhXa2kzOHlIb2l5dG9valJYZEpsdnpkU2FEckFkWDhsL2tKUXFVYWdD?=
 =?utf-8?B?WGliTzF1VW9ydFpxWWF3ZFkxUHBIWkZKNGJlQ0EzamQxNFNSTWdrVGRSekZh?=
 =?utf-8?B?RmdOSGNFV0gxSDFHQWljWkZHK2xxcUovd3Q3RkRSTjF2N1VrWGsrQmxyMGxp?=
 =?utf-8?B?SFJzamR0bE51bjZBYUdya0RDZ0RMc091VmU0NTlsTmFFMGRIc2Y2Ykd2dURu?=
 =?utf-8?B?YVdzNGZ0b3hOeW15c1BKcm1tMk5xa3dhU0Fxb2c1K2NENUhDVTlIaE1oWGdM?=
 =?utf-8?B?Q1hNdzJtaVpKYm9OMXYwRVlXRHhyMll0ZGxTUUlTYWdJZVo4RTR6VnRnL0d0?=
 =?utf-8?B?Q1JiSmlhMk54blJUYjdYOUZhelg2bXhtTHJqR015ajhoRkNESGZpTmtCMkNI?=
 =?utf-8?B?aFNsbkZSSWVYOVg2dE5sYWJzNXcrdUlTS08vRkhBZUFUaFQ5SVFKQTNwZThK?=
 =?utf-8?B?OHRoQklrRjVid1pXMkRYQkFkUzIzTFYwZzJkQWl5WHhUSXlCY281R1JzUE5Y?=
 =?utf-8?B?d2N4ckVkVW5mVlpvOSswdnQxNDYvQ1Zka1NnMGlzc2hCWEIwZThHRHp5enEr?=
 =?utf-8?B?cCtUcTJ5NVVJajBJT1VCTG81bDJoNlVvbmdmRllHTnNVdUUyWGhBcWRQb1I2?=
 =?utf-8?B?bkxWZ0V4R3cvakVoOGFST21xNHRKYzRjZHd6ZmtwSEF1VlZnR25WeFl5YjRn?=
 =?utf-8?B?YjVGa0tyd3IvWHVvTmkza2ZZZkZraGdMMVUvVFkvU1hkRE0xcmc1YjBCMnNI?=
 =?utf-8?B?Kzk0MGJxaTI5endtZk1uU1hTaDNrSXRRSDFBWFVaRlgrVndEdlNZSUtMNE5C?=
 =?utf-8?B?NVliNFA5QmswSHcyeTBNQ1BHbVBQWE1TLzhCN1NxUktGdWxCaUdZQVBiU3N0?=
 =?utf-8?B?MU9lbWw4dVAxNm9XbXV0MDI0eitMTzcwZzJ5K2hVYkNBRjZPTFNFVHhTa2dj?=
 =?utf-8?B?QWRhczN1WXBkaytONEdRZWtMM0Zkb2kyZ3lSZnQ1dzFxYjZjRzhHdEJOOWFj?=
 =?utf-8?B?SklBelNpaDhUR2V1ajRoV2t6VXU0RlZlUVFnUzBDdnlUMXdXcmJtSUJUVFJE?=
 =?utf-8?B?YWl0TnhqbHJ6UHV6M3dmR3VpOE5QQjRjQnQ5d2hVVkx0MFpuU3JpaVRHZVZp?=
 =?utf-8?B?eFNOYzJReDBEU0ozQW1lTTMwOU02VHdRQnZiS3g4cVZBVFc3VXB1TlpIdUNX?=
 =?utf-8?B?NXFGQm9sSFFHUkxjU0g0S2s0c3JFOENNQ3doMGVnbGwzNUNsWWcyYk9ISTYv?=
 =?utf-8?B?bVZ3VGEyRDZ0aTgwbTA5eU1xRnVGU2NtRjR4Y2JWM3JISk1uKys4Ylo0bjJY?=
 =?utf-8?B?dlI5Vnd5aWRScXlqY01tek84MSswQUFjVDZ0ZjZRbWE0OXc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(82310400026)(35042699022)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 00:46:43.3451
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0bd0f71-7d7f-40ca-5090-08dcb5b13e04
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM4PEPF00027A6A.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5362

SGkgVGhvcnN0ZW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVGhv
cnN0ZW4gTGVlbWh1aXMgPGxpbnV4QGxlZW1odWlzLmluZm8+DQo+IFNlbnQ6IFR1ZXNkYXksIEF1
Z3VzdCA2LCAyMDI0IDI6NDcgQU0NCj4gVG86IEp1c3RpbiBIZSA8SnVzdGluLkhlQGFybS5jb20+
DQo+IENjOiBvZS1rYnVpbGQtYWxsQGxpc3RzLmxpbnV4LmRldjsgbGludXgtY3J5cHRvQHZnZXIu
a2VybmVsLm9yZzsgSGVyYmVydCBYdQ0KPiA8aGVyYmVydEBnb25kb3IuYXBhbmEub3JnLmF1Pjsg
a2VybmVsIHRlc3Qgcm9ib3QgPGxrcEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbaGVyYmVy
dC1jcnlwdG9kZXYtMi42Om1hc3RlciAyLzldDQo+IGFyY2gvYXJtNjQvY3J5cHRvL3BvbHkxMzA1
LWNvcmUuUzo0MTU6KC50ZXh0KzB4M2Q0KTogcmVsb2NhdGlvbiB0cnVuY2F0ZWQgdG8NCj4gZml0
OiBSX0FBUkNINjRfQURSX1BSRUxfTE8yMSBhZ2FpbnN0IGAucm9kYXRhJw0KPiANCj4gT24gMDQu
MDguMjQgMDI6MjAsIGtlcm5lbCB0ZXN0IHJvYm90IHdyb3RlOg0KPiA+IHRyZWU6DQo+IGh0dHBz
Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2hlcmJlcnQvY3J5cHRv
ZGV2LTIuNi5naXQNCj4gbWFzdGVyDQo+ID4gaGVhZDogICBlMGQzYjg0NWExYjEwYjdiNWFiZGFk
N2VjYzY5ZDQ1YjJhYWIzMjA5DQo+ID4gY29tbWl0OiA0N2Q5NjI1MjA5OWE3MTg0YjRiYWQ4NTJm
Y2ZhM2MyMzNjMWQyZjcxIFsyLzldIGNyeXB0bzoNCj4gPiBhcm02NC9wb2x5MTMwNSAtIG1vdmUg
ZGF0YSB0byByb2RhdGEgc2VjdGlvbg0KPiA+IGNvbmZpZzogYXJtNjQtcmFuZGNvbmZpZy0wMDIt
MjAyNDA4MDQNCj4gPg0KPiAoaHR0cHM6Ly9kb3dubG9hZC4wMS5vcmcvMGRheS1jaS9hcmNoaXZl
LzIwMjQwODA0LzIwMjQwODA0MDgxNy5PV0tYdEMNCj4gdg0KPiA+IDYtbGtwQGludGVsLmNvbS9j
b25maWcpDQo+ID4gY29tcGlsZXI6IGFhcmNoNjQtbGludXgtZ2NjIChHQ0MpIDE0LjEuMCByZXBy
b2R1Y2UgKHRoaXMgaXMgYSBXPTENCj4gPiBidWlsZCk6DQo+ID4NCj4gKGh0dHBzOi8vZG93bmxv
YWQuMDEub3JnLzBkYXktY2kvYXJjaGl2ZS8yMDI0MDgwNC8yMDI0MDgwNDA4MTcuT1dLWHRDDQo+
IHYNCj4gPiA2LWxrcEBpbnRlbC5jb20vcmVwcm9kdWNlKQ0KPiA+DQo+ID4gSWYgeW91IGZpeCB0
aGUgaXNzdWUgaW4gYSBzZXBhcmF0ZSBwYXRjaC9jb21taXQgKGkuZS4gbm90IGp1c3QgYSBuZXcN
Cj4gPiB2ZXJzaW9uIG9mIHRoZSBzYW1lIHBhdGNoL2NvbW1pdCksIGtpbmRseSBhZGQgZm9sbG93
aW5nIHRhZ3MNCj4gPiB8IFJlcG9ydGVkLWJ5OiBrZXJuZWwgdGVzdCByb2JvdCA8bGtwQGludGVs
LmNvbT4NCj4gPiB8IENsb3NlczoNCj4gPiB8IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL29lLWti
dWlsZC1hbGwvMjAyNDA4MDQwODE3Lk9XS1h0Q3Y2LWxrcEBpbnRlDQo+ID4gfCBsLmNvbS8NCj4g
Pg0KPiA+IEFsbCBlcnJvcnMgKG5ldyBvbmVzIHByZWZpeGVkIGJ5ID4+KToNCj4gPg0KPiA+ICAg
IGFyY2gvYXJtNjQvY3J5cHRvL3BvbHkxMzA1LWNvcmUubzogaW4gZnVuY3Rpb24NCj4gYHBvbHkx
MzA1X2Jsb2Nrc19uZW9uJzoNCj4gPj4+IGFyY2gvYXJtNjQvY3J5cHRvL3BvbHkxMzA1LWNvcmUu
Uzo0MTU6KC50ZXh0KzB4M2Q0KTogcmVsb2NhdGlvbg0KPiB0cnVuY2F0ZWQgdG8gZml0OiBSX0FB
UkNINjRfQURSX1BSRUxfTE8yMSBhZ2FpbnN0IGAucm9kYXRhJw0KPiANCj4gUmFuIGludG8gdGhl
IHNhbWUgcHJvYmxlbSB0b2RheSB3aXRoIG15IGtlcm5lbCB2YW5pbGxhIG5leHQgYnVpbGRzIGZv
ciBGZWRvcmEuDQo+IEJ1aWxkIGxvZzoNCj4gDQo+IGh0dHBzOi8vZG93bmxvYWQuY29wci5mZWRv
cmFpbmZyYWNsb3VkLm9yZy9yZXN1bHRzL0BrZXJuZWwtdmFuaWxsYS9uZXh0L2ZlZG9yDQo+IGEt
NDAtYWFyY2g2NC8wNzg1MjIwNS1uZXh0LW5leHQtYWxsL2J1aWxkZXItbGl2ZS5sb2cuZ3oNCj4g
DQo+IEhhcHBlbnMgd2l0aCBGZWRvcmEgMzkgYW5kIEZlZG9yYSByYXdoaWRlIGFzIHdlbGwuDQpU
aGFua3MsIEkndmUgcmVwcm9kdWNlIHRoaXMgaXNzdWUgd2l0aCB0aGUga2NvbmZpZyBwcm92aWRl
ZCBieSBrZXJuZWwgdGVzdCByb2JvdC4NClRlbmQgdG8gdGhpbmsgaXQgY2FuIGJlIHJlc29sdmVk
IGJ5IHJlcGxhY2luZyAiYWRyIiB3aXRoICJhZHJwIg0KDQoNCi0tDQpDaGVlcnMsDQpKdXN0aW4g
KEppYSBIZSkNCg0KDQo=
