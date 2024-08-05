Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC6C1591F0;
	Mon,  5 Aug 2024 13:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.79
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722863508; cv=fail; b=sKDIdfOOc2XLs5E8FR6pFpTDwUy+8xUzo55jOg9zJoH1jxKNzNc0szcSRqcGvnN9HFXsnQL+2ZlkDXzFBpNHAvJRXua/wQaiJUN4I4pxQMVL0evf9Iba+7hS4peq71p90iw0NBkGH316xmcfzambU/fy/V7kPguA6rQCWbFPDLA=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722863508; c=relaxed/simple;
	bh=/jS2Ik+y5iA/oOeKZWvR58WrXtvNuCrvzPs6vlQiyas=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YNrAzmR9fxiPMGrwpQlmGJZK1VfeabthP9ti/dUKI5WVdKdTT3U+0y2FnHDzhwpoJRRa4C6VXhrzok5eCd14Twi04jKljS202il/aMBJbli0t2jh/nE/lvc9Wo8YO+fZ977wDbPt3zmhYtVcuGQYfVqeE5RWdqMuFrjARJwab4w=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NYpebpoM; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=NYpebpoM; arc=fail smtp.client-ip=40.107.22.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NYpebpoM";
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="NYpebpoM"
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=jy/C9aog+dg6zIpdCEPoACiNeMIt+6Y4cSLMG/CXSJIIgOf7baX8V48bZrMHssXCVeuoWAo+ZKjIY7MGo0++dbQ5HGYal47e0u165/T69eiT4/aT1KWUTMgIiJ5Av8Sr86sWP0IDCeBUhCAmOKogQJ6IE+q+v1oEf4R7e6Pc2P7zsDcUffwtZCkKnlnziBaVer2SFpWtr5SU+nmC+6VwyIubC5n6xDPtm+EdZ/t94bARxK+UmFedRD1ohBL8T/vs5eV79ndWA4iqtuXQvs7VVHAWjJwNvX03MaowY2f8AB/UBvJYIY0I9iGEyEeVXfXTLos5t+eXdZoYFUTdqdCGoA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jS2Ik+y5iA/oOeKZWvR58WrXtvNuCrvzPs6vlQiyas=;
 b=m1fi7331VIdapmH+c4/Uz0BmvgNYCL7WJorv/M/ogV1XZqYw6dsyl1NnvFxEnFO3TRg0tDT/F8OL165th55E2q10/0NjZ4FQ6aGdOOnqtk6FkScjiWvvrSttiWQ699J+b0Zkr6xPM2570SLSowCjIhVbWPFtQ4V1rBw1xp0P1VkYUauKDuOmqBBMXdMEKzq8Gl+1tBF7/Pne8+G/9qjzxQhWWxV5MfYX2injflgKj+h8Ra7Eek/iYYIad3nFbg2AdFk3cLbA7uhM55q1zU3VSwVFtBxodP8BaKy15HmvNnNTz1A/+tjAOmSM9DinQSSpEEKhgzY2pyfVHXTLJcB90A==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 63.35.35.123) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jS2Ik+y5iA/oOeKZWvR58WrXtvNuCrvzPs6vlQiyas=;
 b=NYpebpoMTxZJyIOtrj178EbBiXsJaWoIp7AL/TfLWn9nT2WjfTmxmuL4eEx9362FkBA52aEBJ4cYeLvUIN65WOLWF1BmHwlYPl8r69P/xEr+6dYxHS5Lhqp6Ez92lPKracgSCuOFZ8oI80FDf/Zygd4oR8gZJ//bkAAGpSUZb7I=
Received: from AS9PR06CA0459.eurprd06.prod.outlook.com (2603:10a6:20b:49a::8)
 by GV2PR08MB8485.eurprd08.prod.outlook.com (2603:10a6:150:c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.25; Mon, 5 Aug
 2024 13:11:37 +0000
Received: from AMS0EPF00000191.eurprd05.prod.outlook.com
 (2603:10a6:20b:49a:cafe::30) by AS9PR06CA0459.outlook.office365.com
 (2603:10a6:20b:49a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.32 via Frontend
 Transport; Mon, 5 Aug 2024 13:11:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
 pr=C
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AMS0EPF00000191.mail.protection.outlook.com (10.167.16.216) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.7849.8
 via Frontend Transport; Mon, 5 Aug 2024 13:11:36 +0000
Received: ("Tessian outbound 6ceac6be275b:v365"); Mon, 05 Aug 2024 13:11:35 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 3e4a04f567a5f6c8
X-CR-MTA-TID: 64aa7808
Received: from L4586ffbd72a4.2
	by 64aa7808-outbound-1.mta.getcheckrecipient.com id 3D90017D-8BA7-4F67-87EE-F2EFBCE9C067.1;
	Mon, 05 Aug 2024 13:11:29 +0000
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id L4586ffbd72a4.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 05 Aug 2024 13:11:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NipGnQ8z7VYzexK9eQNXMuGWgdz9ZGud6qyEMQOK5Ur5qR9kL4Uc2fgdCltOsjYnFNd6fCVI5dgA8a0nJe9EDM5E+c+icPiZr1oucDpl0wwHVPs1w5VxsCyRFII48+yaJZdz2Zcdu8E4KkWiCSIrTbhvW9JB8/04+FnqQuBS5sRsagiYxTVq4K601AbwMgWcc2zDWE63JGE0iB5hi43ZI2ERQ7d7YF6VrMxqt6H+aCIn4Gcv6+cG47nsatb7oLs0pRKOz7D1O5GI+XNKPiTGkzCgGH2+lfTG8IU0deuI+cmZqBR8Q5Nlhi5kSmXG+5I3VWl9eZeHMLAhdgoiFUpOag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/jS2Ik+y5iA/oOeKZWvR58WrXtvNuCrvzPs6vlQiyas=;
 b=JdBt4fONIBRyQaZWJbCdzdfzNB1PUV2eHjsvr6Rrz0QinYXrtpzEkwfZlMgRwKZPmx6UzWUUX9iWMzglZHb4/T+enjgh/aPiUPvzvl8RLLkZlyvhYECOjdpm1IEWmtBMekZV/4qiYdOo8naa0lbQMIZr3ArDXOnjvwcZS0t96PfIhp6mch9X1exmwOtw7MKFv7FKf1Jmv+q8Qfg/v+dRBxX+fSBhC1adZkd0AlqD7mum7fVJRH6oBu2uj82/9RD6W5oQZl4M01NhMQsjObWnlAaEq1GgbO/lYbJIpxoGme14LzbXVTH80EC6G7E0/+efsdxp71K0mcqw5YMdwCJeJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/jS2Ik+y5iA/oOeKZWvR58WrXtvNuCrvzPs6vlQiyas=;
 b=NYpebpoMTxZJyIOtrj178EbBiXsJaWoIp7AL/TfLWn9nT2WjfTmxmuL4eEx9362FkBA52aEBJ4cYeLvUIN65WOLWF1BmHwlYPl8r69P/xEr+6dYxHS5Lhqp6Ez92lPKracgSCuOFZ8oI80FDf/Zygd4oR8gZJ//bkAAGpSUZb7I=
Received: from GV2PR08MB9206.eurprd08.prod.outlook.com (2603:10a6:150:d5::6)
 by AS2PR08MB9074.eurprd08.prod.outlook.com (2603:10a6:20b:5fc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.25; Mon, 5 Aug
 2024 13:11:25 +0000
Received: from GV2PR08MB9206.eurprd08.prod.outlook.com
 ([fe80::d431:f1c3:a2b9:5162]) by GV2PR08MB9206.eurprd08.prod.outlook.com
 ([fe80::d431:f1c3:a2b9:5162%7]) with mapi id 15.20.7828.023; Mon, 5 Aug 2024
 13:11:25 +0000
From: Justin He <Justin.He@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Andy Polyakov
	<appro@cryptogams.org>, herbertx/cryptodev
	<reply+AAIFISMST74UQEQBJUWW7J6EXDLZNEVBMPHARJBRSY@reply.github.com>
CC: herbertx/cryptodev <cryptodev@noreply.github.com>, Author
	<author@noreply.github.com>, "David S. Miller" <davem@davemloft.net>, Catalin
 Marinas <Catalin.Marinas@arm.com>, "linux-crypto@vger.kernel.org"
	<linux-crypto@vger.kernel.org>, Will Deacon <will@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Subject: RE: [herbertx/cryptodev] crypto: arm64/poly1305 - move data to rodata
 section (47d9625)
Thread-Topic: [herbertx/cryptodev] crypto: arm64/poly1305 - move data to
 rodata section (47d9625)
Thread-Index: AQHa5T2zTygXPxQwWESJ+cR+xf4WfrIYpf0A
Date: Mon, 5 Aug 2024 13:11:25 +0000
Message-ID:
 <GV2PR08MB92062BC06FFCFD28B8707592F7BE2@GV2PR08MB9206.eurprd08.prod.outlook.com>
References:
 <herbertx/cryptodev/commit/47d96252099a7184b4bad852fcfa3c233c1d2f71@github.com>
 <herbertx/cryptodev/commit/47d96252099a7184b4bad852fcfa3c233c1d2f71/144978326@github.com>
 <Zq18V66ufraB_1-T@gondor.apana.org.au>
In-Reply-To: <Zq18V66ufraB_1-T@gondor.apana.org.au>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
x-ms-traffictypediagnostic:
	GV2PR08MB9206:EE_|AS2PR08MB9074:EE_|AMS0EPF00000191:EE_|GV2PR08MB8485:EE_
X-MS-Office365-Filtering-Correlation-Id: ef7f9eb3-1eb4-48d0-d819-08dcb55022b2
x-checkrecipientrouted: true
nodisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?9+tc21JMFAO9BTUHWyDqJyG1Gha/qsPaaIdHVPFsPaFm38AVQRpq1mCPR1Oi?=
 =?us-ascii?Q?OyPq/2QhK5c7TBdt19rzfYT7c2P1NJ+0g9JXhOeCB+fklOIlU8rAcDAvSS30?=
 =?us-ascii?Q?39ZANP/QlgaUuyn9hDAUUzMNt+1JumFMYhnt4VTfC32MtHurL9cfHsBttzSF?=
 =?us-ascii?Q?+okndT4GNrEq8eE5kVO+RDCrMsrRQUEoHfLBTk4q07nMHz2bDeZQNC5iP5ak?=
 =?us-ascii?Q?FjnZ3ljqqEOcWeCf2hympEXULTEltZhL7XEyV7K15CPwdP4JeIJpZeRmft9v?=
 =?us-ascii?Q?dYcpKpu/FYiaqRgr3gX9QONXn2DiatYtWdsRezj0WGNESggRR2K6zl/81TCk?=
 =?us-ascii?Q?5HveQpmlao0pA2EK1dP91XuLg2CaUpneM29N8PEaYZrIvA1DVDN4d16KCFod?=
 =?us-ascii?Q?H1kfzHXqknZAkrxKKyAajD5oouiH2TxwQMzDRAlS8wkRXyBLJzf1GzwujlyL?=
 =?us-ascii?Q?d2Qacdb+T0uR9LVgDkrVTTIeuqvOdlWanbOnsqVMPtu98MDz/x6+4DWzgEgC?=
 =?us-ascii?Q?SJiHQqPoM1Md9TKY1wckrqBuxg1xg065ZZsNjDniSSbUnndWPY4RoVyLFO6f?=
 =?us-ascii?Q?Por9gVGVgXCRCXhcSMVnNa4asJz1mY8ta/bewFFMFnUcLJmkutoJp1Lku/4Q?=
 =?us-ascii?Q?nDnjb6IL3/99CH5pFa7HJyqplupQY1miShYqKSI4Cr2P1Ls8FfJ9O98MYRY+?=
 =?us-ascii?Q?ngq9rywbtXzagurbpxxyFupNc4tb/0XVcpURHUKIP+GqUJx3Ee7gZ/QsJT/i?=
 =?us-ascii?Q?6fGKkvxK3N5au+jMIE7e5AzyWTzaCtVfwRCD4DzjnrpHE8hGNXswwigxIiNo?=
 =?us-ascii?Q?BvcSy6K+MhOiUh2krde4/vx1HmGFIjbobhk0MEi5iLoTm4FSr2PE95fyY09p?=
 =?us-ascii?Q?w+YwrUAMRWHgbs6mlErDxtAf3LczQnXXGbFE/TdwYKfAAeC+6eBDPxS9mFKr?=
 =?us-ascii?Q?ilfM8sql2tUWEGbvri6qyhQBTMCYUbg+mzhjw4SZH67DVpiPMbG0Um/6QgBI?=
 =?us-ascii?Q?VRzoA44Us1SNT3vMGAmNjvPH5GPSKqKOqt8kFRkUoHten81egm6NI7uXYByr?=
 =?us-ascii?Q?bIF2N0IndKDpdOcLiswqGSIlpFKChcqYtyEbCi7lKOdPInUX3UXH2Y4T6SfJ?=
 =?us-ascii?Q?Ph68FaTJHHYgeoznt8j8ywGtH63xriYOcfwhGR0ti7zFRHUPI9TsA9zb8j56?=
 =?us-ascii?Q?XnWeurH/84zIGOs7enSWbtZr62FOGEWwnPXBN7BqBshcdhGKlQTMT5Vf50/z?=
 =?us-ascii?Q?WwQ89cNYlDOOIZjMop9RPWc6J9wRYC1MYay0kx014NnbVRnRkMaIrg8txkzc?=
 =?us-ascii?Q?loEhGxBZT7IfC9e9LqgRKi+H8LdaZVNFJIjB5ikcDeF1P8Y5BC62/36rZKBt?=
 =?us-ascii?Q?AD3FeXCRKw86Z2V0bqi2fKwbdttBM4l3mn5vUnhv0wq6vSU8Ow=3D=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV2PR08MB9206.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR08MB9074
Original-Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-SkipListedInternetSender:
 ip=[2603:10a6:150:d5::6];domain=GV2PR08MB9206.eurprd08.prod.outlook.com
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	a8a8b2d4-a6c7-4fda-53a1-08dcb5501bf5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|35042699022|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KMfVMazzuqbfE2V2viTbFBWZ+GaK8BA1CCtBkMBdfeBt6ZcFrrge/Iqdtrky?=
 =?us-ascii?Q?qMAHrqFYUxBEiwGRGV0/vR5advZpqpKUGYSF/sYK8Dvxy2hZ6emikJt3gzhF?=
 =?us-ascii?Q?m+xSJWqYvWrhVMdypJ4OezcCOgZkQu1Gq0JKNWCF/L32JAupLg80GHdQ0O10?=
 =?us-ascii?Q?qqGzA1XHrRIXJvWqlY1lktRktTfsQVUV52mqLOgcRoWHzQncdVQA8cDmPG3D?=
 =?us-ascii?Q?L9Q1BDLqjVChbQDWnPznHkdDUalvbz8cdw3XY2BVOw8N25wtI2CZ7KAYhHNI?=
 =?us-ascii?Q?KI3ZRFIGThdw4XyZJ4/1n/7Wjg0iBeVet4QsN9jUBrt1hUGZpiYB5JlF+OOc?=
 =?us-ascii?Q?la3DHqdQSEVi9hsUX38iSXU9lpmjC2lHx7z7NFdN1WUTn0rxp+7Lk0hpFsDB?=
 =?us-ascii?Q?oxJSw/F6HI5ksCdnvnoCr2qx1TkCvsnsuX0r1Nuvva7rdeo3pY2GRqNExDiR?=
 =?us-ascii?Q?aGFtG+nhGcCaBKRUeFXpN2QeswDOMfejAIO6bMYF3dwurRxEo9E2lG2oms2a?=
 =?us-ascii?Q?T8N8XiZXoTApB6/40GBuuPaS9lxnYjuRxfJ5S3kbpI7XftVubdtjdpVW/81Q?=
 =?us-ascii?Q?eRXiHccT97PIRpIDYwVneN4jdGYWCPrYbjWihRbFgepTobD7iMgsRo4XnTDG?=
 =?us-ascii?Q?cJaLhUyOWJSIXCSb0oFQGDGcTOWJmscFlNQSHsp2hy/eFFeLyQ1S0aWUZBBm?=
 =?us-ascii?Q?ZqQ0Xz2ZKsjORWrAe2a/t0IveXNc8bIuM9XdVvi49/MO+UwMhOQerovnbvAP?=
 =?us-ascii?Q?Zvobd+gUNnVieBvHqTwEkTO7RGOk5zDEhHnz2nkeW3MFJSGvhuNsG2fzgzHL?=
 =?us-ascii?Q?GSpU/UppAW2XgrBqguDEl9I8O6wvCiFRRgF1sXbrVdtWs7Qbq13qXfFNWrym?=
 =?us-ascii?Q?yE0+lhMZYwv8TxsQDRuLKpNiwqxkVXqGobrAGx+A4HHKQnHZ58JNXC8uKW9d?=
 =?us-ascii?Q?YDDejsmXkmuKey6VJEGkCY1Xz0K9yadFC/+7qZ9s2IrLNV6mh9pebALfUrS0?=
 =?us-ascii?Q?jCLP39ePOl4KiloYiCXeZ7n1avlDae89SDlkKcdtEmzmCUckTmym1qwmDV7n?=
 =?us-ascii?Q?/40at+PSbe1O/pHGU51VqGmuh0K2wyzL2z14MxAE1KP3oEE+A9rjUfslVa7M?=
 =?us-ascii?Q?pf0bXATQMoFzsRL6j/KFkctgmF2rXDGyIVy61IWsCFUmcEhXnnCWpTKlfrQu?=
 =?us-ascii?Q?LfnCG0ntiusuJJhUqR05UK6VM0xkv/+9cM5G/XUu5NOQrrXp6hVA/pIC+rzM?=
 =?us-ascii?Q?jute0xBDkNDyNFM2kHwrI0QjJdvGWtvydiFBs8oW3dEf1Mns34v3w1ja86OO?=
 =?us-ascii?Q?9vHU4EqHAhhh84Y3ShbEfeCw1sRJaa1x1zUyESFlZvThYF7zijeS/RuWhrgU?=
 =?us-ascii?Q?S9M2g0HdO4d/aRpbuamh6bq4dTMF74aW0a//QzZO+D+1KngrdvkXDRLFsG98?=
 =?us-ascii?Q?HOyb6kcoEFyRJJmhfzx/1/jj5QT3WYHM?=
X-Forefront-Antispam-Report:
	CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(35042699022)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 13:11:36.3143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef7f9eb3-1eb4-48d0-d819-08dcb55022b2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS0EPF00000191.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8485

Hi Andy,

> -----Original Message-----
> From: Herbert Xu <herbert@gondor.apana.org.au>
> Sent: Saturday, August 3, 2024 8:40 AM
> To: herbertx/cryptodev
> <reply+AAIFISMST74UQEQBJUWW7J6EXDLZNEVBMPHARJBRSY@reply.github.c
> om>
> Cc: herbertx/cryptodev <cryptodev@noreply.github.com>; Author
> <author@noreply.github.com>; Justin He <Justin.He@arm.com>; David S. Mill=
er
> <davem@davemloft.net>; Catalin Marinas <Catalin.Marinas@arm.com>;
> linux-crypto@vger.kernel.org; Will Deacon <will@kernel.org>;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Ard
> Biesheuvel <ardb@kernel.org>; Andy Polyakov <appro@cryptogams.org>
> Subject: Re: [herbertx/cryptodev] crypto: arm64/poly1305 - move data to
> rodata section (47d9625)
>=20
> On Fri, Aug 02, 2024 at 08:09:10AM -0700, Andy Polyakov wrote:
> > Formally speaking this is error prone, because there is no guarantee th=
at linker
> will be able to resolve it as argument to `adr` instruction above. I mean=
 since the
> address is resolved with `adr` instruction alone, there is a limit on how=
 far the
> label can be from the instruction in question. On a practical level, if/s=
ince it's
> compiled as part of a kernel module, it won't be a problem, because the m=
odule
> won't be large enough to break the limit, but it **is** a problem in gene=
ral case.
Thanks,=20
Can this problem be resolved by changing "adr" to "adrp"?

> >
> > But why would objtool attempt to disassemble it? Does it actually attem=
pt to
> disassemble unreferenced spaces between functions? Note that the .Lzeros =
label
> doesn't make it into .o file, so there won't be anything in the symbol ta=
ble to
> discover as potential entry point..
There is a similar patch (1253cab8a352) for x86. I guess that objtool/stack=
tool can be improved in this regard.

--
Cheers,
Justin (Jia He)
