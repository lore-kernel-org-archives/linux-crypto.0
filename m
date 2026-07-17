Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931D2384235;
	Fri, 17 Jul 2026 20:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784320542; cv=fail; b=CXBsPvBww8Mulltue4EtIJKzTSbRI7jFpo0JGUx+xE+MN5A41os7Azkyb8CXgd95X2YVUQ8x40pj1fqYfwDteIWfR1EJSrG8iiFOUzGCTzQn5mwl+rrLuqnmckdLh8mTEBs/S3j1hq0Qf65Syh4nrPO+yU9UeYcSgO3Dgf4NYZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784320542; c=relaxed/simple;
	bh=HkeiFpgN7Yr/GETEw+5c80IFrzSHhz4uvLLscWq52VM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MQginPooqTMjWWWQnrjKsshKIjG8YeNIIGvACiYgK460YW2R29BP67JdbFioHAsOH22LeaZRuvZ1OlhOIGdTvjb7Drz5LJOmr+lNDnSK2brzaMqYiwIktNk3h3wFDET7pPXjHrDhvlf+/puBg6KHhx6bqStMvsGy071brc52agg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YTeiH2rV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AUYXWy6h; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YTeiH2rV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AUYXWy6h"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HKNEDR3874469;
	Fri, 17 Jul 2026 20:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2feJqiIxf/dDE2Kjj4
	5HxUmuvO6KjA7jPeexj+ygbng=; b=YTeiH2rV2OsJWN2um1eD4pTrdsSYA0UWX1
	VZyGr3qSfP1wPlBL7Rz+2YkVsf4OXZRCzKcQiw4uJylS/0JA9cwLTz8vcIjm0RKg
	ed/u73xm2oAMrn8rufbEmTbRibRjlKxNlTBD5MOY7/ox10Qlz8ZEO8i8eLUL7qB2
	jkOFPFelf/tO3G78Z37M5WiMc/K9e/WHO0ggmmUbCBkjgeaVf8OUGpUWIih9CBNv
	VHiFcG3ZAVjyZH7CRq0huyLb1M3z4RRhVhLYpR9iAkzMdqJHQr4fHGXtkY5N99Xq
	omGvNoLwWTT+WzZUiBFKVsChmK1FZ5y2XHU4e/pZrKn4fpmQcCPA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fbed8aypa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Jul 2026 20:35:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66HKWwJY033190;
	Fri, 17 Jul 2026 20:35:32 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011040.outbound.protection.outlook.com [40.93.194.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fbc9j1aba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 20:35:32 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P07wxYiRDT7ByyM4+MU6XvN+iqLGwAj5ZVcx6x8UcLScn9sv2/n3QJNic+dTcVvJ3OEn1Y1fbtLJaHKX3sS2VWkdNIoTcbCPkqqOA+1IuXIDiVCaixnYuZwFjdYoKBO05H4R0ny+JOJ0kUthKRaAxDax+zBW5EwdaKksvWY95/gBs/FXK0Nv9pTS4vgf3Kh8T5qNoTC8WILB5gP2aAR0AQac1+bPmyMp2VdW8AMiPmmRaFHTwlaP8uM/PcCsHb8SexpnitoMK3w0SuilR892AxYS+sWDEROMSwWQgSXIMqym3yRbf7AKkx8J2mPw6zbSZ22HSkfM7HUv8PHmeLtpUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2feJqiIxf/dDE2Kjj45HxUmuvO6KjA7jPeexj+ygbng=;
 b=QpW+59uxBrZp4XbHyJ0yCOaXSzZ3OeLbEcKzaVb/k9mtWOwJgq8Bf6E/4ha/mORzuQQrU2Ba9WjsUftiPXWCX9OjzVBhoPTGrLLRnphfydNox4eAPK1Xbi17h+1n0YNnsUR+PK8R2YhJ8glZPD9jiUMJUCy6fnoxEVatfnAqQs1EnC62k2yi+xTWEu0MBx5LTMvLz6oDRL5kkTpy9KzucU9PvI9bPsTUkr3diqg6tInI8LX3cJ5wgZJgWYe12lMoLl6+mbJ61zMVRwwsqK82yLNey52s25iKoxcKA+tU3nUoj+cDZimtnArk0o07tSkkt5ib/9DHQJeURpSlf8rcUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2feJqiIxf/dDE2Kjj45HxUmuvO6KjA7jPeexj+ygbng=;
 b=AUYXWy6hYt8b2o9HwnQlTCw4bVtKH2IRO0m4EobO6Ubib+8xf9mSLUYSp0lbKmHPMpFAzgI00GCKanEWWaWrkwvk0zoAcWsMEfpripunZEXgN6bJvOuyEA4yhTHCfrrdnawrz837MbbYIdRdcz5UYXlZVwgUpI+/k5/nQTCQxoQ=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by PH7PR10MB6649.namprd10.prod.outlook.com (2603:10b6:510:208::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Fri, 17 Jul
 2026 20:35:26 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::854c:c282:c889:45a2%3]) with mapi id 15.21.0223.008; Fri, 17 Jul 2026
 20:35:26 +0000
Date: Fri, 17 Jul 2026 16:35:23 -0400
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH 2/2] padata: Free the padata_works when they're no longer
 needed
Message-ID: <alqR8IyJqW3cRjw6@dmjordan-vm1.corpdevsubnet.oravirtteamphx.oraclevcn.com>
References: <20260717171831.27994-1-ebiggers@kernel.org>
 <20260717171831.27994-3-ebiggers@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717171831.27994-3-ebiggers@kernel.org>
X-ClientProxiedBy: DS7P220CA0075.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:259::17) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|PH7PR10MB6649:EE_
X-MS-Office365-Filtering-Correlation-Id: 88027c42-8175-46fe-23bc-08dee442eee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|4143699003|22082099003|56012099006|18002099003|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	nFJt+2S9l/VIh1Ou7dSPeBMxS/uVDZQyBWPyDXf+YraRZvVBdQ6vpDNk+G2m9ld6Woony3Rwa1k5fQ6Zf9uZdgh8AA69pY+adQCe6Mm7SPXHLErKhlsPxhPiXtDJq9Anjd7e1YI70d3tybpN17hFqBoPWjathip2bXUnO0xCZAY9csXozk0yXtFAH/xBAiTRfUVxzbUcjC7kMUPejxMUoiK9ARi3jRfBQX0hEIwXSvwK6o9ioRZny9ptmBYh97czCt4fCZGKbB3AMsCEelTdb2LIIFFDBBhl5dBtCQ+4eymx9VQQUtUUWOi3P2LTXuDIN5yBfrdYMlwPJ2cm+mdLum2GZW8HIdyYuXCZATh3EzTVnMsysUyq1e5T+fOpcOZp/l+n8cBkfV8kfuw3ff8ntJOJcQ5CprUVOFYvBGUKjrmMVglIVvevy3MQ++Ps5vTl3r5gkR+lbLijKmtCMmrk6NUo+gL+OuPdsaXToVUk1W/fqf7GhDa8shtMHEuyCbKSbG8Pcr4HVKweikSr0T21qeSG4fBHacEhWzTzS1E2+wMTHwbgPSos+SrkfMsqTn3fzaYPrCpKYw4Cu+2KpfGVMx9keSECHwkIEdE6vp6ptf8it+iEnrCz2gjSGtA5V2pxu9eOgZCtqzhyKHcPmTugd+MYJwV9Q6SYcb9xUbsV6iM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(4143699003)(22082099003)(56012099006)(18002099003)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Faxy1twhCi4vaWgvqIH8URMJOp9xhXA4YOl+iIpW9NlLjKjZ7SpNJ0qt5vhw?=
 =?us-ascii?Q?oDfHMiQpUqUtyIk7Jot0Ee23q9LOVaWFZRV31ddvbfNRhJZJcgfDYEl0lsLa?=
 =?us-ascii?Q?6GJ5T/gjTmYThCxFvoON2YdnwaRd14OY/+KEaRAdYPt5X1jWNnLhARczqD3W?=
 =?us-ascii?Q?6P97BvzKauOL5n0sPTVpr3y76UwYbhjqbrO8tXb8/sP/QoKtibpKMLrk2nhv?=
 =?us-ascii?Q?f4kT6eGwiiHJS1xPF5H9q7oinbuyOK1h76WG3TsXfIIjTzY88oyeSH+P9VSh?=
 =?us-ascii?Q?7apNK2NorMGdmCg368wAMKoqC9NEuY9702P+xQLtpwfMNerVuCdCpEnk4AoM?=
 =?us-ascii?Q?ldmOpIccjhie9gLK76v0++VS2DzO71paXO7SbLCLFlCdntGMEwOODEMbXa/B?=
 =?us-ascii?Q?j4ca11Dw1zx8GKjspYzX60l78/RtFleLSVCPKcjlqpQ7FzQNwwVhgOmD+nIL?=
 =?us-ascii?Q?0BD2PmycSdPVrGKBAzXTK2LWlmh54G8k9/F36mACs/hqzNeaJTd+vX4UQdP/?=
 =?us-ascii?Q?Gd63LAIz1+VTjTqEY+vRpNDHC+wc922+t/EIuxcgv9r+9pl7HeA4Ff/UzeH1?=
 =?us-ascii?Q?xAFHYh7ZQFKXr/6xGLL9JyT91GJpeh4AtTmUa5RuYe9ceYSIVirlwkfkNgI9?=
 =?us-ascii?Q?DOUv50bySPqHo2QVp2+gexjpi5Nn2y+XMvB/5n2CmlxIVMISx6GL3biobrmQ?=
 =?us-ascii?Q?0B92hKPVem5gw5AeUsaLEdPA9Q+V4IgTws2tWEZICGX/VM2Rv/Cs0UMUn9iL?=
 =?us-ascii?Q?pyOJi/DrPiiV9Qofpd90y6lG+Lh9Zjn18Ef7yrQrvx6DL9CFwT0Uk1VLNq56?=
 =?us-ascii?Q?Z34TqhoHbFVPo6Xq+9gTegWpdWae5gwiEiXE7iI7ljoW8+/gW1C4fiFnNNxz?=
 =?us-ascii?Q?G0uiz3qw9RhsVU9Z1Z4n6FgomDqmhEsEjiptvld7BDnzYNzBw4FuqWB5b12o?=
 =?us-ascii?Q?ePwQ936MhcfHjdDKT8tIanUKo5FNeYmIll49AoMzB0XFhJjINhQgVvbRu/8Z?=
 =?us-ascii?Q?6KXetQqeanCQAfJMHJVQbhczo+JIUNJrX14ErhregKIBoDk2Jk+IRTviPmId?=
 =?us-ascii?Q?gq7nqa7+c328Ab2RWkNNNrgiaj/99vYkMq0AILBDOJTat7TYoDQrT2WUd1B5?=
 =?us-ascii?Q?UfEZZxHmokECEaWKdBivW8Q2ZDVZJJuMjb/juJZ9zA0C0+/MeQs2kBE8gEfR?=
 =?us-ascii?Q?lOXM5tJEZclMIrb0pT4Vnbf9ODCiIUa6hcHPzVIk/bW110OI9jXZe+6umkqS?=
 =?us-ascii?Q?esz/hCeBPbAndJmZsotYIF9wHw035S9xVxlTzX6LQps05e1UrLKw3KzJMSLb?=
 =?us-ascii?Q?xdpTu723JOkosJSvYGHx3Seor0Tf7xWyuXrgBnVdZoEhm6DHvYgJxOFjnr5O?=
 =?us-ascii?Q?DPl/EkrQY/SbdeiVGGA00JOYTw50iafIJNuvQ6SLmQYKrpLJ92fggpaH9R8g?=
 =?us-ascii?Q?5HB/95HCcR75QtECwUklzZgzK256tu5tSxVIagKCMASw12EneLurM/2RrHj+?=
 =?us-ascii?Q?ngwmkSas+sPy7LeWUn7ditJGbeVdAzTuFUYvA+zFUbcNWutLU6cXTYPJ/r7O?=
 =?us-ascii?Q?WZfu/2KVqyIyHVS6dtKmKpsTvcldoCbgJXwEG633Pqgpi/DRD70wlKSwIYjs?=
 =?us-ascii?Q?pnb214+DOEQlWGsaIXlLZtW+68pS6bsRG/3xryXxz44dzZULVIpBQeM7o/Px?=
 =?us-ascii?Q?LCe92LF4r7ZOPIsSR49jW+UdIPKtzUBqNWTdHmm8uml3Kqal3eH9Fe+NY8Lg?=
 =?us-ascii?Q?cSqsdUmM3cPciLvRWEdhbXpSh+FW3Hs=3D?=
X-Exchange-RoutingPolicyChecked:
	oaKs5Y6QwENFCF/5HtY4CzNIJz7IbN/ffRS4AZMLlSw8+nuP+9egoN3WhIMGxlF6vwPbHMcVcYiq648/TgXgLdKAc0KLis2hJyg3wDcLPum4su2OcX08PBxIfWGenJhWBdhuxky1A/325gGBVurxA+SdShE6neFqElyL/FrnsCjvPgkb2Xi0iwoZEC9r6+inPSVlHaLSrsFmNkmtV1H11Llmcjq8o3TW0rQWskNLxd+Sp7f4bQ4frYgyV9f3ezAYOmGwsGvWkwZFUezFE8C0uC2IGCLR9/9K7YYKtJEGcQRFyCBK6d4mNghjubTWLHSrNJ/whOeSv0JsUxe77QBWIQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YparnLTXc3x7bAYcAWmyClUZ3KseYAfA72bs7NKSQFc04eYiHburMPsYASJHHL1RUZhNWAV2ngFFUaftTv0B5whWpixLl9VjsilMonCmNcBZ6ZZ51e5LoxY41ixteJmDZASOJtlyASBojOHkTiwDqRWWDwVuWDk9KUqyjVP4uhDvSq4RMHJmHnbUnihEt1L2OJwQpHOL5O8mSnIhkwAHSrwxwqnWVxCCLwR2elHPTNEbPPOfp9Y1pSX7YIHwPp/KMUTU9h8/TDgcp1O0FqwRrVxl17kv0dnQeqBcY9YR946D8PVxHqiK6f8mDPF48aFnfkdr/FJVmEa/zxMJrQ+2NEh7lG3FksxeJbeNVZznfUp2PoBHL37JlglNqZeW51DZuGzWEt5ICUKEAjAyg1XRqGJH8A6RSP19QUl/KCDxHZ7XwFk2xPimPx+mY0JII0jLKv8lINKlr7MplH23RrUqOCQj6pQ5jIdbIAP1DNOUHrldQHEQEDi14/SCRgQbC5Upa/A2875lW/wyxsX0HAtA4vafHZombWTd/h6bwg4u9UbIxFQqAkE2397q+J4N7d9K1EQU1G/ZLf72v130r2M9AOo1NV8NTBpNbkJnMA40HIE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88027c42-8175-46fe-23bc-08dee442eee1
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2026 20:35:26.1597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QymoRbK0YpvqnLtQ1J58x82fkn9PYQi4PbjU8FSmCdE1NU7aA2P27/sjvW70J8pqK9DNuDJCRLsnogmhZFqxG9pb4XXnaLelW9cZC8BwkEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6649
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_06,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxlogscore=976 lowpriorityscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607170211
X-Proofpoint-GUID: TRJDntx0Gp8HbSc2iZFv_4aRdXwrre0U
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDIxMSBTYWx0ZWRfXx2G6tOSG1NQ4
 y0NVQjxsQBO790FzvXIaGJgzsp3Fn508XiCpzkUBoeThsfqTI/dW+CtrVus32XZeWUXi7KNJIVd
 lyWJ/HT6ArjkSg9BE/yqLOQU6RX6H4JYVOYoaLHVh4qJh2EBII40
X-Authority-Analysis: v=2.4 cv=JKALdcKb c=1 sm=1 tr=0 ts=6a5a9216 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=RAioF0-LDSMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=GO4yCByCEMMD-rrKpGAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: TRJDntx0Gp8HbSc2iZFv_4aRdXwrre0U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDIxMSBTYWx0ZWRfX9QCTKywS7oh+
 bwwz3Cnf9AAgTrj6HFo3O3RBw8VlLYWlGdixm3qR4pJMeqXROcNX8QptoCM7p1crZv8LceIcxsX
 QSQqYDuvlFgjB2sVM9coZtteYVAGmeh5TmtAIIPmhuxZ4xgkcchi7pYGL5NoSGmIUyTj1bjoUeD
 QF1QIYaVgAeSItMf2pScuxxD3GfIWssdyN+g25eV62erpAscLAktIHwjaNUQv2LxFsHDc2FUgOV
 Bolsiy8Ny+pJSs3muu/A51RtnScePC9/guUmFg5vZxfEkDaWBDtWAroUzzVpyDvIZsMpimDfJiL
 R3f03b1F+Z9aERxlSLaM1N8io7hKVmD1X3i8cLklyMoqlMmKpU/Rrhp9StkBMnirlh/9tyLo/Jk
 I1GV1kP36CaWCToYcOsqx5dka+DLSJDSNXsSexeA19DvkDuc4rQ8ezWsf1AGYXLWnc/icnSyseV
 isgRDJo8Cc4tMNppgBQ==

On Fri, Jul 17, 2026 at 10:18:31AM -0700, Eric Biggers wrote:
> The memory pointed to by 'padata_works' is never freed.
> 
> Originally this was necessary because it was used to support the
> serialized job APIs used by pcrypt, which can be used long after boot.
> 
> However, now that's been removed, and the remaining code in padata.c is
> used only at boot time.  The pointer 'padata_works' is now __initdata.
> 
> The result is that this essentially turned into a memory leak.  Fix it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>

Thanks!
