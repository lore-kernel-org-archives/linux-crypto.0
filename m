Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.64
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795168303;
	b=srH+D4vQShJmIDfGKb2JIKZ4Tx6gkdn1+GbLQekhnRPp2DkFLSlYGpiLu0DYvKpuXgSx
	 QktDTRh4mSlqjX106f115KAGfJwmGgVK0ejKaaCsSpvgUMZLjDT04QnIMHgDRUrWciX1R
	 iEyHAXyVews6PoD/4h9X2wgLk8RF8hsBl+Dg6n8e4EFPDcTCvKOqMgbrQbIosca9GUUOV
	 aixbBZwihkCPYqmvOuzPzYm05opNsuhVVrJxO1O7EMkopyhsYtafIdcrHbMaH3QWYN8Ob
	 E+uVSfkYa2fdrDe8RWoi17g3HBmsy9FcAQW7UG3hiXv70kytyTfrIeZzBtzdhMUrVzg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168303;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:Content-Transfer-Encoding:Content-Type:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
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
	bh=v9ISMfK3FQG8qdMKpdPnjp1WPwKMlLrxiWEp2tmel7w=;
	b=I1uYeEcB6MvyUrtXglNt5OH78wxBLJONLyUIuTmEG19fiEcanm71cEd92pep/DStv3VY
	 Dap4LI5RSnxa0NcDhkb0j+peQac9H5QxMbTq/svKrryz2euQXL7HTOy+7f1Gl7LpsKgnH
	 CPaAfY7bEyJVnWxcSPBbpS+ZL+YJdqrasIz7mWatb7KxIympdvgSBakuSOC62hRwT9Ujh
	 1kxAIrAmdHXTxWvwAunyjSTcDtywt8/4f4mlN3zfGaGiY3XojSU6/xXJ1eT4V09WeUjRF
	 ziW1pPX/PLBBBqPaO9Regt8khDUnXcHaJKCZV1l/oC7wg6AZv1CqvVJBaIj4vOhECpQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=altera.com;
	spf=pass smtp.mailfrom=altera.com;
	dkim=pass header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=cFkncKkQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.64
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011064.outbound.protection.outlook.com [40.107.208.64])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D294B606A325;
	Fri, 20 Nov 2026 09:51:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D294B606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=altera.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altera.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=altera.com header.i=@altera.com header.a=rsa-sha256 header.s=selector2 header.b=cFkncKkQ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i9te5tnseEqqyft42tB1s1cpG+DqRfoSD+KazGvV+AHHYqFXP+sR250XFD+py9HefMOgAmQOsewrf9Xf7jzbQF0bvYgp6bfxfsor2bhOFtUZh1EBuMENlPZ5/5Ga3LKfQPKOr55THdxVAPSmU/6qtBs5d8PNltkGq1u+9dNRrjT9Xz2Qr6dUPeh80Y/3abJ5jFPM1UXFF3LcWuWHO10NMaE0eaf3udXFbJGZmDtrxGKnm0+OwlLyrcgaO8N9LEq0C+N+2v7H5DU3d7zIy+h7h1E/yy8FgQTNVVieFsKkkd3v2kq4D7DDCNiRdmVUw+xl2K8kA5pbq7NQi9k2DMxbCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9ISMfK3FQG8qdMKpdPnjp1WPwKMlLrxiWEp2tmel7w=;
 b=wwy0wqdkEVgeWAHqokG8zpJmNeA69jyYU+Ex4aMVhc6RpywCOldcdFo6mifnCCRrv1JKXp2FUahg1AI9Dkb/sMVds4wQAwje7bPFHS1O/tiyfN7c2Dfc2l6NTs75RTkHOdv/ShLpJuE0WAvGATw5rpBiYsLuYWQHpKvHYcpahziBSH6xool1wwfMUcioNETyK0mSITzNn82r216MhrO/Zv4uwnocL86IOU08ZYfnaiSQ2f/YEVekT31nu2dQ6qnJ5o6Fb7ujz9xPxSf7DFLd6JNE29NhBTcys77v9HNxyujd/vHkEy3GXqAcjLkYxdJO8j8nQ8srwa6eAzcwlCksNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=altera.com; dmarc=pass action=none header.from=altera.com;
 dkim=pass header.d=altera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=altera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9ISMfK3FQG8qdMKpdPnjp1WPwKMlLrxiWEp2tmel7w=;
 b=cFkncKkQa5znrhIouWfd0FJPeatwHgE3wVxcfnb+QIb4Sh55XX8w/cI/7MY/N8nitD/SGF2nGuHjToRe2N/djxozLiDTKUaw3VXu0PbYe6G9Qxd3P5kEU3FppRY19YfTG64/zc1YWNqFYX0Jrfte16o1eAO9g15cdlg7e23uqJtWGn2X22RpP/mGmT48wLF9WLeGnPpDiyZqfkmQ1eZ1nd6YYABnDJ4jOzkhhxl8dTycl3ztK8yarLDkjTJxiI5oU7kJptDUQVt7IpplCVsrw0FWq3wVs76bIvM2IPQdvHBzoViiFnUxg0DT7NHrqoUeBjdbMyyfQLMs366GPkcnhA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=altera.com;
Received: from DS3PR03MB097838.namprd03.prod.outlook.com (2603:10b6:8:546::7)
 by BY1PR03MB7946.namprd03.prod.outlook.com (2603:10b6:a03:5b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.13; Fri, 20 Nov
 2026 09:51:36 +0000
Received: from DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59]) by DS3PR03MB097838.namprd03.prod.outlook.com
 ([fe80::fa39:2c18:c265:1d59%6]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 09:51:36 +0000
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
Subject: [PATCH v1 0/2] Add FCS Random Number Generator (RNG) driver
Date: Fri, 20 Nov 2026 01:51:31 -0800
Message-ID: <cover.1795167624.git.hang.suan.wang@altera.com>
X-Mailer: git-send-email 2.43.7
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
X-MS-Office365-Filtering-Correlation-Id: 0fee9c34-acc1-4fb2-5b84-08df46ebde01
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|55112099003|6133799003|261009223027099003|260925021911599003|260925021311599003|18002099003|260925022911599003|261026140227099003|261021121427099003|261021123027099003|261102123227099003|921020|261028144727099003|261022075727099003|261022105027099003|56012099006|10067099003|261026121527099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	JiR87shBJeIedD0Zjds0H+SeFzX1RUinzJhBo4tnVqF/8xUsI+KsKPD1AJCagUxbQRIRAkIUM3EHGCEVk743FODsLqhgVy0OYqnCNElkPk+0UpSaPpFwZ0MvPoiEdTtgfH0LWnQHnDufl+mrULz1LAobtCwmUBkAefwf5snKrg7GKuT/eglFTY1BnRyb+Yw6APDWKQhnbyMgZcCoyTe4s5iPrgBToXvS6Id+iqZlrOTD+ulyLXekM4O3Y0kJx4TrcHePo97ISTDRMRju0KVcNct9ClD/0DSfVZe5YbIdH049HXf8/PusgLQ3W40lG9AqYVbOMG00KVtDvKhuNnZykOYthyuNQoNTgd5LFKj6QMXpiD88R3TqZmpgPefizZQ9NQ8SI17VXrGG3E1jffFxdPXIDVHYSta5YssHOOM9ESzHmZN44MdIdCTvh1WlKkbn+2Vc8mt07LRG53XymYi9OHi28zbUAKt/Pzmb+yayemyHeQ+X9V2Au+26jeeR/FfT7NZJHC9UnHHLX4ddMdWNsm5HIBrdCWrgnTbMWYabgb70Dg9/k1YwQVZsUQcHy0r5ErA3G7/1srQbi3xus5U3zimcvLlE/USziaLWQNos0Au3gMuRt3S3eNcZ2+Dmn6yqeRLRmjUWSjF71FjA5r5/6JXx01mbr0LXhfD6EThPlYQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS3PR03MB097838.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(55112099003)(6133799003)(261009223027099003)(260925021911599003)(260925021311599003)(18002099003)(260925022911599003)(261026140227099003)(261021121427099003)(261021123027099003)(261102123227099003)(921020)(261028144727099003)(261022075727099003)(261022105027099003)(56012099006)(10067099003)(261026121527099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ouaXmzjI7dxutofDenTc69uhEY0i6Z3CxkxVZ1xjQLrrikfOhNYDD0JeMPna?=
 =?us-ascii?Q?WWkY+fz5r6jlCIN8XWDXrwr8gDz0c4OrrFGWythvpwh+DU69Pn09vKO2lqk5?=
 =?us-ascii?Q?8z+Vvadk0BUNdKAjM3cd5JvvYkvi0CwkxhlyYccOzjCk54Ph8GKxglQ9zBtU?=
 =?us-ascii?Q?ZxsKFsIZ7nmxBuainvk/5yXOBooseiV6XvdlHGyUz44fMO/AsP0ObyHzGO7e?=
 =?us-ascii?Q?Xjjm57hcaxKOZT5URhOTftskDTwlnic9P95JLrPTn54UXki8ktNknmh6NKlX?=
 =?us-ascii?Q?JLRH0htzpJmKT74zLArvx6yYFvk8INujOheG2sKB4zSIZSEclGSaaJ/D1X5G?=
 =?us-ascii?Q?C9iQQ2pLEd/dbk9bhZ2dOshvGzdr+60yEto2BqvT9W0nlX3r+nA9cLknAsq/?=
 =?us-ascii?Q?miA4roUHXrWLk+8ZoUgFtkkAP0kOLQ2WG/lJ0F9eJVWo+xApEBAOajOI1Pov?=
 =?us-ascii?Q?NG95o4qeYH4QbFXE64NopXNNS2FhkVf4C3pVRnkuZlFZkHtDY/s6y29X1b3c?=
 =?us-ascii?Q?+p1KDUQfwW+q9OUHQwaKIVGyaOxm2s+TVezxp3KgzyJXMCPcwSyocpNRHOKd?=
 =?us-ascii?Q?S7zW6LxBtZKxghSo2N6+8MzyvB6LRJoo3RxldiWznE9Q5oX1b4cNil+Z2UXG?=
 =?us-ascii?Q?W0ExXmBf5z3sa2qCFHvca/YQILNEOwzmWhY6Cb7TZn6my7oc21LptEagjWdF?=
 =?us-ascii?Q?LlaESVTcRVRu/D7BhIbG+oUeT6CHd+lG2UOokfpJKyc8vs3j0uBbccL/nxQ2?=
 =?us-ascii?Q?AetlmWoPd3MaX72vCgI5FCb0LWxaAPVOvSF63HI+xG8PtmNke9j/6H38UZ2w?=
 =?us-ascii?Q?n1VzNIkdkb20kX+MfQHut+Fw1tgv5AG5OI6MIpJoCkAicRuTQVXbMn6OV4nz?=
 =?us-ascii?Q?1etEVwjrhWLlmAFAbXyVxt7CyHEkuRMOB4RQSZjnriFqtEdbrHsnL/H3qi84?=
 =?us-ascii?Q?ypR+4h7/ZENOdB8/0K1+HkO0SGpiK8nur64MARrN34RiwyqnAAYS7Ou954Jq?=
 =?us-ascii?Q?8GYvd8cEy4utrRYqChWFwWpyKxR7U7I2mQzq7XtQ5BpNKJU1LOjb2KzchG1U?=
 =?us-ascii?Q?FfyhZevZ93G7k5SeDafPvkM1jfJqV2GPOV4NeeQlS960sXi4Q88EOU4w4SFw?=
 =?us-ascii?Q?CTKZ6gKlCsA6z7SdAoP3EVaZDgC/ZL27u/vRzAOyE1keFa7MxeiS2WBvjQxq?=
 =?us-ascii?Q?NfYXzEL05GXn8d6iRwC1YEf9TBbOfhBTCZi2dVyonkK7Yn0hOuEjOxzN8rAR?=
 =?us-ascii?Q?TUK5rM/dHZO/jXk/8eD0jziZYhtUg76v27naYdUxSk1c69yzV0vqSRyi/zLk?=
 =?us-ascii?Q?2D8N3nubS1pgn1RY4R6otLBo+rtgFMZg07ie59V76VRUholElWHkM6Ee3lBC?=
 =?us-ascii?Q?xWwj1AZ05OyIiOozVP7jcujTvpIG3zWVo2RgiH7qS1BUqHl2Etz45ACyvJMA?=
 =?us-ascii?Q?WYAr2T96ecr73L6zSfGhkRCsgTbTHkUmw9XW2fHOq0l/eEjSmfgnslxWX+da?=
 =?us-ascii?Q?B3d82EfIOBUi5iHOXbOpLKxsV2a2OklRs3JMyLvr5NApW/OsFBOsjEDPquU5?=
 =?us-ascii?Q?4B/6SeV6lzSCpLmcK6ueOA6zyehjDeJB/MYkugItPqaSHn5zwb90z0TT7eFI?=
 =?us-ascii?Q?w6T5g5bEd1F6tO7Bq3DxWAgQ+c8i2uqJuM0r7AfOGnOLpJ0j5Y8OS4bKLtaE?=
 =?us-ascii?Q?ujyyyOdI6oFPa+P2XiUwJ+dx3X4uUX001ntP0Nj7i7xc/YkOhOycbXYv7xxk?=
 =?us-ascii?Q?FmUkim5bjQoc01dzp6pO00CCUeVt0w8=3D?=
X-OriginatorOrg: altera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fee9c34-acc1-4fb2-5b84-08df46ebde01
X-MS-Exchange-CrossTenant-AuthSource: DS3PR03MB097838.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2026 09:51:36.6712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fbd72e03-d4a5-4110-adce-614d51f2077a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uGoZ6cRq7jsCeqTSoK0bi4/yV4Zb5ajadmqowO+M598essTOXYBNYcB2osAFnXruHIq5aDCY5lGYLSBPsM7aDJ7mOfAITlWTq+tBut/uic8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR03MB7946

From: Hang Suan Wang <hang.suan.wang@altera.com>

This series adds a hw_random front-end for the random-number service of
the Altera SoCFPGA Crypto Service (FCS).

The driver owns no session or service-layer state: every request goes
through the FCS core, which serializes access to the SDM crypto session
and forwards it to the SDM through ATF.

The SDM is the hardware security controller in Altera SoCFPGA devices. Host
software reaches it through the existing stratix10-svc mailbox, which uses
Arm Trusted Firmware SIP SMC calls.

The Agilex FPGA series generator is an SP 800-90A compliant DRNG hardware
block in the SDM, in particular, Agilex 7 is SP 800-90A compliant DRBG
generation flow and is seeded with the TRNG hardware block.

Unlike existing hw_random drivers, this RNG produces data only while an
SDM crypto session is open (for example, via FCS_IOC_OPEN_SESSION on
/dev/socfpga-fcs). The session belongs to the file that opened it, not
to this driver. With no session open, socfpga_fcs_core_engine() returns
-ENOTCONN and the error is passed through unchanged: read() on
/dev/hwrng fails with that error, and the hw_random entropy thread treats
it as a transient failure and retries. The open and close session ioctl
was added in the previous series:
https://lore.kernel.org/all/179492434088.3111216.6016447945055810112.b4-ty@kernel.org/

The ATF accepts only a non-zero, 4-byte-aligned length, from 4 bytes up
to 4080 bytes per request.

hwrng.quality is left at 0. The hw_random core documents 0 as the maximum
(1024 bits of entropy per 1024 bits of input), and with the default
quality of 1024 that is the value applied at registration. That matches
a conditioned SP 800-90A DRNG, so the driver does not publish a separate
estimate.

The series is organized as follows:
Patch 1 (prerequisite) extends the stratix10-svc service layer with the
FCS command codes and matching SIP SMC function IDs.

Patch 2 adds the RNG driver: socfpga-fcs-rng hw_random driver. Add
FCS_DEV_RANDOM_NUMBER_GEN_EXT in the FCS core. The socfpga-fcs-rng child
device registered by the FCS driver. Also, add MAINTAINERS entry for
this new driver.

Testing:
Built for arm64 (defconfig + CONFIG_HW_RANDOM_SOCFPGA_FCS=m).
Tested on an Agilex 5 SoC FPGA board
root@testsocfpga# ./fcs_client -R dbg.bin -j 64 && hexdump -C dbg.bin
00000000 15 fc 77 a9 86 17 0b b5 91 b3 db ce a9 39 48 f1 |..w..........9H.|
00000010 65 00 80 9a 63 b8 1e 99 df 56 6f b4 ef 66 73 f9 |e...c....Vo..fs.|
00000020 91 66 c6 94 94 38 f1 9f cd 3a c7 6e b1 63 1d e2 |.f...8...:.n.c..|
00000030 03 ec 29 01 4f 27 4a de e7 7e 67 95 c2 44 e7 04 |..).O'J..~g..D..|
00000040

Set timeout to 1000s for operation: rngtest
cat /dev/hwrng | rngtest -c 2000 2>&1
rngtest 6.17
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions. There is NO 
warranty;
not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

	rngtest: starting FIPS tests...
	rngtest: bits received from input: 40000032
	rngtest: FIPS 140-2 successes: 1998
	rngtest: FIPS 140-2 failures: 2
	rngtest: FIPS 140-2(2001-10-10) Monobit: 0
	rngtest: FIPS 140-2(2001-10-10) Poker: 0
	rngtest: FIPS 140-2(2001-10-10) Runs: 1
	rngtest: FIPS 140-2(2001-10-10) Long run: 1
	rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
	rngtest: input channel speed: (min=495.429; avg=52178.721; 
								   max=10000000000.000)bits/s
	rngtest: FIPS tests speed: (min=47.329; avg=70.926; max=91.699)Mibits/s
	rngtest: Program run time: 807497698 microseconds

---
Hang Suan Wang (2):
  firmware: stratix10-svc: add FCS random-number command for Agilex 5
  hwrng: socfpga-fcs - Add FCS random number generator driver

 MAINTAINERS                                   |   1 +
 drivers/char/hw_random/Kconfig                |  12 ++
 drivers/char/hw_random/Makefile               |   1 +
 drivers/char/hw_random/socfpga-fcs-rng.c      | 133 ++++++++++++++++++
 drivers/firmware/socfpga-fcs-core.c           |  71 +++++++---
 drivers/firmware/socfpga-fcs.c                |  33 +++++
 drivers/firmware/stratix10-svc.c              |   8 ++
 include/linux/firmware/intel/socfpga-fcs.h    |  23 ++-
 include/linux/firmware/intel/stratix10-smc.h  |  46 ++++++
 .../firmware/intel/stratix10-svc-client.h     |   1 +
 10 files changed, 300 insertions(+), 29 deletions(-)
 create mode 100644 drivers/char/hw_random/socfpga-fcs-rng.c

-- 
2.43.7

