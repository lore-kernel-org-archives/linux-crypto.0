Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA2F23ED63;
	Tue, 10 Dec 2024 19:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733858208; cv=fail; b=pVbkte7oSXknnEaQ983yCDhawpUctpWhN8Lw3OItFQ2mMPvdE1maBBg9H3WBI9ddcV4j/oIH8M79BbPPAmDE51hjnrZK61uiH1AwuEnbtMLqxb7h+F1AJsvjtfkX3ya5IH9xsycs/bQ2jUT4lukwI2Az6HCtEELnx/26l6UJbX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733858208; c=relaxed/simple;
	bh=jGkzaNeDuHMWqF5YG0FlSk6v96mp3xXfpzTCoylgsts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Hm6WC/l7PsV5+46vscVCLwhqSHuVSm7DZpn074UHMfZVINjXbimTjlQdtc9qhfXE4WCA+W9nxa7H+ZM9YCRvYWJBciJ+Rp8pFEJ0knWwCzR2blwhi11HXR0xBsDyLYh1x304gA1Pxnum8wmErJqb9z8Sfu7F9+B8uTjN9hn+Rxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E2Fl/w9x; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tl2imIX5; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E2Fl/w9x";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tl2imIX5"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAGQmpe028918;
	Tue, 10 Dec 2024 19:16:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=gksmO/F3jBtuzse7DQ5CdknhLzeIL9uAdu38R3YDb3Q=; b=
	E2Fl/w9xmY0jIhgOQv+PQ9zvLpv+iiX8FnkIyjvI0ni/w0dWK1BJkIsbmEuec7dZ
	+sq9lwVgKPhIEgDVeOr+YetlfTq91Ewa7k23LuZKzYwoJvQ9x0FTDkh0IuvukMmG
	gCC0H2ykVwWR9V1K6hl4yXe+aUJo4sUf7fD8x+ONIfhInaI3Pdzzr/NDqF2kGq+X
	wW/woXbc/9SiCeLklCF++1mGYpICG/99ByuqUEj/C3eWk5Wz3CbeRYfqdwQcPb6Z
	u7sjao2Lp7E5jqp1REhNxypYacBl7ddh6ErnI39BGC9ax83Ig1wkK4/Q0bdRSpwr
	N0owoOT/tH0nXNEDRatSmQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43ce896hhx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 19:16:14 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BAI4e3H038180;
	Tue, 10 Dec 2024 19:16:13 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2044.outbound.protection.outlook.com [104.47.55.44])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctfas79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 19:16:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nvROJCgND+ng/hszcpQCKSKtbM/rCHMg34mivd+eXMECyeS28G2H6tLM0p8qDqePoxhxaujqapwtHdU26h4HPzmLzUeQfAcGOMwrS3q1Py4UiMaDi5JbnlwnowJ8wOC/YF2ZD9w0kRqUBbLprxfR1rRj5MSNwj23yBDbc6nzOxbCQcVaoD2WIhJRAETSOk9CYQDEDdadldybEOHNGeAaJsQW9imj9poUCZY0qsGcnjTqZA7LrN8BnXhmJ2E6wPw6tDZmo9ytmsY8ZB45hzgO3nsdFErL349tlPF+qGwXTipYzFN01TDKzzwYY91C6qZ1+cekomgP4cIWuuf1pXMl1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gksmO/F3jBtuzse7DQ5CdknhLzeIL9uAdu38R3YDb3Q=;
 b=KJIparbS8wfUvrzWcbbrJpxQGdpgjMERrBZ4rqSAFSEKznJQD+04FY0thghYaDGxEh24xtWmyAZRuZDjIJCDcc7onZqIrygy0l0EY+G7kTKqW08laSrsjJ32Rn3KvTYZ4i9iZE9nd5xuNRGCA/CwtaHvN4ZzxHtAZnLBttjAcd+JxLdoyor0lev6IRApwqXV9dwduIXDZO3EQmBsNRrcf8q63kiP0Lzm6DYnMwM5ne3U6a8oa3Rio/zUAaTApcjvHkoktMICCFXIWZd3pYuoJBpbAlwz0MnudahXJKaYh3JQYuu48mgJcz8/AtYkHeB70SsryYGHOILnOERwMTFW0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gksmO/F3jBtuzse7DQ5CdknhLzeIL9uAdu38R3YDb3Q=;
 b=Tl2imIX5/BWwuD66IG73qKfY5J7mxBFiPGBBXmOZyQVGHu7IFet/m6KyFmgnZyyKDThmlZWs8EojFEWU82CwXtl0M3WONvsYUoOKkiXkGJZnTY04RcctItLfiW12vv8wIJgZagyamQeCtKHeyBXEAQVcEpLq1xVUVOP+TszP78E=
Received: from CY8PR10MB7265.namprd10.prod.outlook.com (2603:10b6:930:79::6)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Tue, 10 Dec
 2024 19:16:10 +0000
Received: from CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc]) by CY8PR10MB7265.namprd10.prod.outlook.com
 ([fe80::d299:36f1:493b:33fc%5]) with mapi id 15.20.8251.008; Tue, 10 Dec 2024
 19:16:10 +0000
Date: Tue, 10 Dec 2024 14:16:07 -0500
From: Daniel Jordan <daniel.m.jordan@oracle.com>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: chenridong <chenridong@huawei.com>, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangweiyang2@huawei.com
Subject: Re: [PATCH 2/2] padata: fix UAF in padata_reorder
Message-ID: <pmskwoy7ieyb67kax5njl2kj7otfqucxyws6srtfqpnvv67dr5@d5rimw2x3eol>
References: <20241123080509.2573987-1-chenridong@huaweicloud.com>
 <20241123080509.2573987-3-chenridong@huaweicloud.com>
 <nihv732hsimy4lfnzspjur4ndal7n3nngrukvr5fx7emgp2jzl@mjz6q5zsswds>
 <2ba08cbe-ce27-4b83-acad-3845421c9bf6@huawei.com>
 <dc4a4fc1-2628-4e0c-8b8e-1e44193c440e@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dc4a4fc1-2628-4e0c-8b8e-1e44193c440e@huaweicloud.com>
X-ClientProxiedBy: BL0PR0102CA0040.prod.exchangelabs.com
 (2603:10b6:208:25::17) To CY8PR10MB7265.namprd10.prod.outlook.com
 (2603:10b6:930:79::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7265:EE_|SJ0PR10MB4480:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd2f993-a1fe-455f-9d6e-08dd194f1b33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eUNxSXJBYjJiemRCODRsSVNpQmIxc3BlZFVBNUZ0MVQzSTU1dC9qcWt1Tlpw?=
 =?utf-8?B?cWVnWks4WHg5Y2kyS0hMajFoeEdOa1E4WlRsR0N5U3g4dWhrWVlzSVdQNnZQ?=
 =?utf-8?B?cS94MlBPQXVKc0lGSGdvWGdCc29RZzcvK3dHZzV5eXhvdVlNTTBOT1FERXR0?=
 =?utf-8?B?clg3VFcrS3JtZHhDcDBaQXRPazFBeUY3cHI5UlFJdlFNQm1ybVhPWnlKRjV5?=
 =?utf-8?B?M3p0bWd6aW81dklZblpzelRmSTFNc3lmODZGNk9ZbXlqS0daaVV5ZFlxOWZQ?=
 =?utf-8?B?Z1dMaXRFR0ZtWlpmUXdHaWViUFlSS3k5dmRZQ3NQRUZoOFo4Snp5MDBidDBp?=
 =?utf-8?B?NXBiVFhTNVMxYzZIV0lkcTRPUjRISXJ6RFp1eHRlWjc1YVIwTHJ4Z0hDOXZW?=
 =?utf-8?B?a2RGcGJGckZ5ZGNzeDlCbGFPMnhoNTl2dHlwUjdyQ29yakJ3SnlpQ0ZxL1Ji?=
 =?utf-8?B?cXBBYVRycmx4dnhtckhuTDZNME1uUytBWHpMeWZRUkhPNm8zTHJSWlNXTXQz?=
 =?utf-8?B?RHBuakl0RC9WR00vMlhaellIYlExVGxLNnhpaE4zdkhRYzdXOEpWbklCSVVV?=
 =?utf-8?B?bjMrOWxFMmpLK293NUtHeWpqQkdLSGZsRC9qNDZCWFo4dllOdnl6RTNTeHRH?=
 =?utf-8?B?dVpMei9yQTJTR2cvTWNYdlY4R0dXNVh6WUEyZms5Wm9aMEVMdE1LaWlubldE?=
 =?utf-8?B?VG9pelNTeTZ1T2tnS3dQTzN3SjFZSlJ5Z0tnRVhOK1Z5VGJESTRMUjI5bGVT?=
 =?utf-8?B?MlFMbzVkTktUYkdoRFh6bHpBODZqNTlvRFl2VlVBSGRDc0tDdGRvVGU3amxJ?=
 =?utf-8?B?N29TQnoxNmVGNWQ2NWd3eWxZdmdSME02QjZKSzA2cFFaR2lhT2V3aVZmQ0NC?=
 =?utf-8?B?NnlLS2xySmlONk1nZktYSnYxVHE2QmJSUmFkK215YjQyN1JZVGloSHJ3ZmZB?=
 =?utf-8?B?ZW90dms4QklGUmpLMnRwbnlVQzJZNkw3NThMTVF2WitlS013Z1VHb3d4SkVU?=
 =?utf-8?B?YmE3cUpsZEFYZklGRXh6L2t1b3pJd2VZc3pTMlVZeUFWYmpIMFEwOGVUYzQw?=
 =?utf-8?B?UENFNVVYWDZieHBkNW93cktTU3JZOGdvQzBVUFBPemk3T3ljenl2S1BPRExQ?=
 =?utf-8?B?dGN1U29BemU2ZnRVdkJjaFg0bzJRSi9nUy94dThNeU5zaS9TRDZ2QTE0bHl0?=
 =?utf-8?B?Q0dwOFBmMlNZQ0FYbXRqM25QaXBoa01hTkZXZHpSa2RTR0pqK1h4ZzZ5RXI4?=
 =?utf-8?B?U2Q0ZEtEK0FmWEZCZllybWM5dFVTUHllR3pQUnlrS0xGTjZBcFpPdVZnUWRm?=
 =?utf-8?B?T2Y3SFFQRExpSzltMHQ5VitwSEpnaUhkci95UndXS1ZHY2hOVlRQWUpsczlp?=
 =?utf-8?B?cFU0UUlsditSREsyeFFQT2YvSU5OQ2htR1lCQWdpcURrSGZURzNuZ1UwaEph?=
 =?utf-8?B?SmIyWDFkRDRnQUk0d2JNNm1WRStseG5UWGUrYWMyZG9McEJxcFFhVG5Ca2N4?=
 =?utf-8?B?R01HV3hwTTRiZmVyMXJ2M2VvdHZUdGtacVhSQ1I3bkJVU1MzK2lzbWcyOXlN?=
 =?utf-8?B?N1p0eUxtTVlBTm0vMURCMy9Jc2FnQStyRXduMEUxeTVBNzJsQnBsR0hjRlUz?=
 =?utf-8?B?LzFOSzAvQk91T29GYUloOUJ4Rm90TTBZY21LdG0rdlpQSy85KzRvSGw3akl3?=
 =?utf-8?B?bmk0aXhKeUNvazJHdFJGSkxSS3dOM3FxZUY3WmVBdlBxTFAyT3NaWncwTThI?=
 =?utf-8?B?WHltTWExajZWTU9kblRtR1I3MXlUTUwrNVpoZTJubytjNjNjM2FYbGtGR3hE?=
 =?utf-8?B?eDV1NVhBZ3kzaXJOYnVDUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7265.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFZYekRncXozTzdBQnF0UmJDUVZSTFZGRWdId2VwZXZDRG1TeW4zWVA0ZkNT?=
 =?utf-8?B?R1owVjhHdzNFYS9Zc1dNZ3lwVFZRZnF4aGhmeVEzSVBaUDdGK0IrOHNXaHJM?=
 =?utf-8?B?RG9BZ2JzZ2pITXFXekxQMnlUaTFwYjJEK2FReThkWWY5MkxRRDhJVDBrdzVo?=
 =?utf-8?B?aDhTUXBRajIvSFZQTjZmSHkzZnBURmZPZUFZWkFObnZGK1VqOUt6a2N5VzZV?=
 =?utf-8?B?SjkrZUlSK3hGUUxQbVZacmk0d05YRWp0NVJHZ1pkSndKWDMvSFIwaVNRRmxr?=
 =?utf-8?B?d3RRcUh5bUI5RUVlUTdRTVFTVE5qNTdxa0lJUlE5dU14N2owM0NpTE1tYTdT?=
 =?utf-8?B?U0lMYU0wOXZSZnpGNlNUVTk3NEROdVhKaVA5MFBBODc2NlVSb1BHZ3ZvTkkv?=
 =?utf-8?B?U1MzcGxBUkVUYzVXSFM2ZzJabGE5U0U4WlN2eFNpMm1YVitpbU04NUw1dXpK?=
 =?utf-8?B?YVQvSzhQVndBUm45bmJjWkVPd2dPVWZGL3gya3dpQUhnTGx2a0VSdGRzZXRz?=
 =?utf-8?B?TGhvU2x2RmJrRWF1YzR1STlKVjlLbkpDRnhQWWQ3UzY1NjZXT3NiZ0tGaS9L?=
 =?utf-8?B?TTdtWXd4QWx2TlduODhoMjJZZktqL3JpT3BuV2VUSU5Oc25xOE8yb1FQY052?=
 =?utf-8?B?MnNTdkVQbXdzQ0hLUEZEWW5hdHFkM2ViR3oxSEFrdE92WkFaRlJSZkc4Tk9D?=
 =?utf-8?B?ZDRtc05udU12SERLTS9mRFR3bGFRQTVnekl5eHNJNmoyTDZ6YitiOXNYWnZp?=
 =?utf-8?B?MjlmeFJkaUJHNlJUdEZuaTZEbEhoS2ZJWGtva2ZuTDlpMzB2U1BFQlU1NktP?=
 =?utf-8?B?QldNcElwblpOaDNnSVNjc3VmdXNzYWkyWU1JMytDVHpYZDhGMWN4YTZzb2lG?=
 =?utf-8?B?SVdLM1NNYXJ3TW1mMFFPYm9ZVFJQN2VwWFArQ1gvalE1Mkc0Mi9jVVduV2RV?=
 =?utf-8?B?aU5NWTNJSVp0eFdTcVhMTkxyNkhodk42U3BPRVVaVjAvSHdEbzhCaDJVNitz?=
 =?utf-8?B?QkRXRWg5WkR4WDJmUVo3MnRuVURQMU04Q0hyVUN6WVZvMitNNy8rMHZDTldv?=
 =?utf-8?B?YWQ5V1ZFUitFempOY2RTaDg1cUJqeGRsTCtrYm5XTnBwSDZnN0M5cWwvM2d0?=
 =?utf-8?B?UnJJUlA0SzBhT0h1eGFBS3VBcVJlOEQzM0ZnNGdCWmpHMXFvQ292cHpuSUVO?=
 =?utf-8?B?NTV5Qk9pK1NUZG4vZTZ5NW5aUFRyZ3NpeXNyaitCZXo3Q0Q5RTI5cjN2dTRl?=
 =?utf-8?B?MVFjYzBHRkZHMCtaYytpRjlMLzBTUVd1OGlDZVFpR21iSWFTZFdOa1QwOW9C?=
 =?utf-8?B?Tk03dHVydnM4eExNckxqek1HcHBHeDB1RjZ3c3FXZnRYV3FITWVDaUFmMGYw?=
 =?utf-8?B?TXFDYnJhMkY3Yi96R2l0VDhrL1huR3E3Y2NOVEVDMys4Rm5hRkJsbzVUdXc2?=
 =?utf-8?B?Q09vcXF6VmoyeGg3ZWdHRW1CbWJFQnJwWkpENFB1L2N2MDVscjNidll5cTJm?=
 =?utf-8?B?b1VkRTg2akk0ekh1WXdiTTZFTUREZGtaeUlNWkhLNk13ZTQzK0xOVlYyVEVS?=
 =?utf-8?B?eXUwajc4aE9QamNvSW9PZmU1YmcvSUxpTWhpREJrV0hMK3FkR1YrWkpuRk0y?=
 =?utf-8?B?UXBJTkpNTGgvVTZWRGRzMkxLblRsMFZrTkVIM1c1SWU5Mms4SnNiMXZHT2ZY?=
 =?utf-8?B?cUlLY3NReThTN2FyT2p6SHlVeDMvVmpoNjgzb01MMXR2cTI3eDdZTkZ3Z0c3?=
 =?utf-8?B?bHZyYWp4V2J1OExCaUhKakhmVWh6cGN5djQ0Y1VxM3dpUDdoTDZkSTgzd1lL?=
 =?utf-8?B?djJBUEZMSnNoVlhqaE4ycGhXdkVYajlEMU5vRFN2Yy9CVGZuTW1GOXl1bjRk?=
 =?utf-8?B?dmdjc1ZabExubXQ0a29HTjFROURKODVBdmpZUkUzMnVGNE0ralpiZURHbURj?=
 =?utf-8?B?LzRkQUxvc1FSSDdZWnFVeG85R1FYWkFtYXFwcmluSzZhYUdMdFpFR3ROVlFr?=
 =?utf-8?B?dVgrdkxLckpmVnJHcksxQXg0Ri9HUit4dEpZTFVkbUllVGtmcEVNVVpvZ3F5?=
 =?utf-8?B?OW11cExxUXZPb0JiYk56bng1OWJPTmtIc0J3ZHJpaVJ5MmxSYyswNVB2cnV2?=
 =?utf-8?B?NjcreVNvOTdiTThpSWpPSWtoOStXWFdpSzVsMWNHRmFLK3gwTGc1eTh3bEpO?=
 =?utf-8?B?NkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	64c+wQH63+XVJCi2WLXEKPZxYlvnfJu1Avn+xvixPUnjRxp1dcYj3v0ZkEUfXUMBdzktt2JAr+yvEF8yeXtjbPB1chUytJHGVx/QNc7WxRQmZUYeLNb7TjaywDprZ8LYmdM1CHdaOnbTEq07TAr6t6GajpaKhOaD3kfScsgFgeFH5vj2W0ZPOTBo6OrDFBxym9iXaMT2KuhosUNQAqJYqRRlWVc7DKL5j6zNTu7O+f3OR+eR6oAaHC4/GEJOxZi48lMBwPEEjq1qZzz3UH/BoKF7nxrz2EhT9guSRHUma5uRAWa5nj8mXjhRNP50LzhMyZpcTqY5iT7jrrLk/3LnlL3e0h4OBf1dBv+65y/po+NvLCvu7p7M4a20iRnmdbrJzYMgThAAmI1QJdFvRtlE1kJ/QiGmmL7oPtrvTnh6/M/HAAg6HHWvl8eDSN0BVtJ4BzKpmzkr4GoTTmPb0Ek42r1GhpFYqGwqWHCdYFEZdb092d/7SJtsxM/JxjBFuA50eqtl4OmL3GSo+HNT27Jc+npTVAMXj3+D/r3Z8eAdhVia61XmC8z15pC53FDmJPqoc7JiFqUEPUgYz2ubHq7dD9uyQOs8X60n0pm5C2z6aOM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd2f993-a1fe-455f-9d6e-08dd194f1b33
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7265.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2024 19:16:10.7667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iEXZPdIccCU/Gk81lFOoxP0kM0n1Cywp31BWvlUHSBJfZ8PfeVhMAed69XClwVldlt7EzoL/AiUY5ACXu1eUJFnh287k1Ml7fP25Antvm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-10_11,2024-12-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=595 mlxscore=0 adultscore=0
 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412100140
X-Proofpoint-GUID: 1O-SMe4API4V5Ild2Q1DlMaa_9RghlLj
X-Proofpoint-ORIG-GUID: 1O-SMe4API4V5Ild2Q1DlMaa_9RghlLj

On Tue, Dec 10, 2024 at 05:38:51PM +0800, Chen Ridong wrote:
> On 2024/12/6 11:48, chenridong wrote:
> > On 2024/12/6 7:01, Daniel Jordan wrote:
> >> On Sat, Nov 23, 2024 at 08:05:09AM +0000, Chen Ridong wrote:
> > IIUC, patches 3-5 from this series aim to fix two issue.
> > 1. Avoid UAF for pd(the patch 3).
> > 2. Avoid UAF for ps(the patch 4-5).
> > What my patch 2 intends to fix is the issue 1.
...
> Hi, Daniel, I am trying to produce the issue 2. However，I failed.

Thanks for trying!

> I added 'mdelay' as helper.
> 
>  static void padata_reorder(struct parallel_data *pd)
>  {
> +       mdelay(10);
>         struct padata_instance *pinst = pd->ps->pinst;
>         int cb_cpu;
>         struct padata_priv *padata;
> 
> I believe this can increase the probability of issue 2. But after
> testing with pcrypt_aead01, issue 2 cannot be reproduced.
> And I don't know whether it exists now.

Yeah, no reports of issue 2 that I've seen.
