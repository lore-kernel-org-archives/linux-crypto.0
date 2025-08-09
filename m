Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F563125D6;
	Sat,  9 Aug 2025 18:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754763762; cv=fail; b=Nna2+Kq0VIz3vQkOCuppow/glaH6n7J1w/0fYhmMHRa7qUqBupyxIgrIW0UK1X7XR9mY7sDYrLDiBc39dIsIGLmEnJNl7i3kdLGt4R6FsLk4G95tkSlhQUrDUIpa/PgUWgKiB6vYFRqKebhHw66fFNnObtW18ScNX2yMsAjgT00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754763762; c=relaxed/simple;
	bh=ntjzmJdm5gzjLtePvdq/XcAP/UWRP4wF/z4w/WxcuGQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NXvgKvlspQIahadI4a+R3DFDvZ2tzU8UunGYhwHV3XlSxo2UY4z8lys6kIQa5d9hqx5dQ2sGX3aasDmmIEzKppWOMSKmD7cFAy1DpnV8HNSxfj6ucH2/pEBVbN+cz20tptyy+j47SNfqE1Aado4Cmf6pmfUMieVHrsnXARW70Yk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LYm51elp; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JInsz4Yv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LYm51elp";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JInsz4Yv"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 579I01lO018440;
	Sat, 9 Aug 2025 18:22:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=mMRvNgHFso8Bjspg5Fmwp01v0jlK9Gtp3BjPmSA44Qw=; b=
	LYm51elpUnBa10Jyk8LRmGavtRPXzduC+lyveVOFvoi9p0fXCD7pm7jDGMSjEg/K
	5oTYNsRMDOzoaThzA1SkH1J4aRzBT474C2A8UrpB5Q7rHV0t2ogi10jnWREJcSKq
	WDMI+tvXHKNJYi8g6/LpwOjb8nuPfGRCf9xd0UOkABbKDPPm+9JXjaa4zqZ/zTY5
	ouIY+w8ZIZqsmyDfEb+dRLw1/iw++dOPLy8s0U7p5kkdifXhZm9Kpihj9igXM50z
	ip+qRyDGr92n2lEId907tdVqbTs3ei5I+M2MJZDsq98ufl8z5FskoTrMKTjMJkLL
	Inf9vmpVABTRnL3w96LA6g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dw8e8gdd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 18:22:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 579HIjMY009664;
	Sat, 9 Aug 2025 18:22:31 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdfk20-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 09 Aug 2025 18:22:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nYG/ing3bj9hk6RwvTglZ6wDsJf+iwBqiZZxahY6XJRzD2Rw88qw3jHTMKdfVveAYZM9djCAAto89MRii0L84dmi8rG0BlF/aZhmIt/XupSKdRtGDuCyiW8L5GgKZP7vqxnIFsUiWVdRO/WD7ZfUM63qXPWYeHvYls2Wd0zgS6QDalaLIbSWVT36LMoSek196RdNFa+uPKCL0iYh4yGmHXocRhEGhsAP/dlI/hpQ8Xul7z4/1K7z06KAQ+bAZnz0tlvxEDJoVhE0GwtLzqEiXzwgLuxnEz9V+nEgva71g3FIJBWy59gBL2FRVEyyHJnfG6N0PjZbc8fvDq+aKj7eFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mMRvNgHFso8Bjspg5Fmwp01v0jlK9Gtp3BjPmSA44Qw=;
 b=ELjtyHT33QOofsQ15MduAPFy8mr6CBnSAxIFR0r/3R/c7AdJl3nBDkmMmzFpCC4l4lFriGakpUEUDvVOiZpqy+f4RqVADyQD2ecnTywKvxV195CC6qRhhmRw0G9uO6EAJAsw9Swdccvp8mjYhYCBZyav46ig17jsgVgTHKA263GF9gBhO8qQ+ndxLHT1NYWquaAJfrAvaX61dKx6rhp0zu0odXWaKKbY9RZWUT3M8JCR9DPA0g4bJ0Ldy1lNO9cBxqWT1+CrFPJIr/Qwq1HypeveO0M6t7P95cxvIb2vOiBC2+4tzVjf4Moy4CqUDrTbWi5exa0TaBSW0XEsGoKPtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mMRvNgHFso8Bjspg5Fmwp01v0jlK9Gtp3BjPmSA44Qw=;
 b=JInsz4YvAF88PMWBQ7lrxM9laim+v8BgtpkO01fbXKIEJW8Is8VBxapXe9WkkZdMJm6Pwv6hPa6UKC6o1tDcKqmxSJl08jKX70d1s6Kpw6mgR16mX0MycPOOlCqpRblR6SEARdELSfMy6lt25p0lghxeWDka2r9QM0SeERGaKlE=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by CY5PR10MB6189.namprd10.prod.outlook.com (2603:10b6:930:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.20; Sat, 9 Aug
 2025 18:22:29 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%6]) with mapi id 15.20.9009.013; Sat, 9 Aug 2025
 18:22:29 +0000
Message-ID: <72186af9-50c4-461a-bf61-f659935106cc@oracle.com>
Date: Sat, 9 Aug 2025 20:22:25 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] Crypto Fixes for 6.17
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <aJWOH9GgXhoJsHp6@gondor.apana.org.au>
 <CAHk-=wgE=tX+Bv5y0nWwLKLjrmUTx4NrMs4Qx84Y78YpNqFGBA@mail.gmail.com>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <CAHk-=wgE=tX+Bv5y0nWwLKLjrmUTx4NrMs4Qx84Y78YpNqFGBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0013.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::8) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|CY5PR10MB6189:EE_
X-MS-Office365-Filtering-Correlation-Id: 36a06feb-dbec-4346-6afc-08ddd771b2ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TkJDZDVIY2QrR0RBQVJiWWc0ZC9XZFhKQ3F3Uy8xdlBjRlZLYjVVRzRRQmlW?=
 =?utf-8?B?c3NDNS8zWG85bGEwTkRSWjc2SzZCTmJ5Zy9XMmdUTEhnYnViRXhkYXF5SzE4?=
 =?utf-8?B?a3dVQ1F3OGJWYWI0T3VHOUIybjd3bGNlcDdxSHI2cjFRQVlqcFlnUzczdVV4?=
 =?utf-8?B?Yldyd2lsYlNRNEMrRVNLa1I2UjVZT003UlNVRkc5RU4zS2tOSDRuNFBaRm9E?=
 =?utf-8?B?bHFHSFkwMXo1REZONjRyWkJja3duL1JibU1QdmpTSG53RkUwMnppMzYreVE4?=
 =?utf-8?B?bnUycFNuekU5eFg5bUp0cTlENm0vZHA0SWdZUnpyZmZzWFJ1V1Mwd0M0ZFFx?=
 =?utf-8?B?VGUvYUd2NXpoblR5czk0SElFbXV4ZnMxeUhHSWtid0d3RWNLUU93OFN1YkVG?=
 =?utf-8?B?OFFNUTh4eGJtQ095WUpQWGNocFkzam4wYzBIWEFQL1RLWFRTQlhoWmlJUVBH?=
 =?utf-8?B?QXdSempNN2o2VEw4ZU5TWlJJTW1UK2JmU24xaFZVQU9rS1NEYXlMck42K21z?=
 =?utf-8?B?MVJVaHdFTUE5NlNkTDVrM3p4TnlsdGpYNll3N0tDS0JNZmZyWDhxYnJaNEdq?=
 =?utf-8?B?b1Z0NGJZRDlqM0NSU0grZlI1Qk9XdFdtM3Q4RVBRSFVMVUJOcldudFNicDVD?=
 =?utf-8?B?eTFFSnpDbzRzR2FsWFhPcEZUUUprQ2NsUHB4eTdEc0xEd3gwOGVLd052UkFY?=
 =?utf-8?B?bEFXVFdRcFpoUVpCTFpKN1FjazJhTCs0U0o4WHVTTHpSVVFIdnFHU2NxMnM1?=
 =?utf-8?B?MmFPWEFBSVo2T1pEV1d6bERLclZLUFFsdXpNaGIrOTU3eTRCZTlTSE1Ud1Fi?=
 =?utf-8?B?Z0p1WUcrb3A4U1ZlbXJ3TmVSV0c4aEk1eUV5VlIvaEJnelpocnF3dTRieUxm?=
 =?utf-8?B?QVpieEd0TDgrdlhWU1dzcWFRaUd5ZUx5MjNIcnUxT2x3R3l3bzg4V2Vxamw3?=
 =?utf-8?B?REU5NDBCV0FTdGZtUExHNFlhakc1YjljU1k5bExJbHcyZ21JN1BlWlpaek9N?=
 =?utf-8?B?NDhyeDYwOWFBQVMyVTIycW9IellSeWsrd28reEhwM1ZJeWRVK2tvbXNCL1dF?=
 =?utf-8?B?NFJIT3VlUHFGelBpRGU5RUFSVmhlSnZBeS9wTloraGl4dTJrWitkYUxiMks3?=
 =?utf-8?B?c2NDL2VOMWFrYjBzWGs4cUVwWjd2N01pb0hBam1wcGtUM0Urb2orOUpjMXNX?=
 =?utf-8?B?aUxwWk1zS3dVZkhRdGQ5YjNMbTkyN3RCN1RNSzNxclJDelZYbUxIZzJmc3dH?=
 =?utf-8?B?cU1wZllNV1dCdkdVWGo5b05UMVlHNXplV1JCZmt6QjZhQU5CZW9XaVIxa3R6?=
 =?utf-8?B?eC9VZHhTRmk1VVA5R0FFR2dTNklSQ1pJWkI5RnlXckdOTXhRZUVOYlBZWHdy?=
 =?utf-8?B?RlBkcTFqYWxHSGphbjFabGZvZXkzeFBoTVFwRitBK1lBM3ptb2grWmQzdVFD?=
 =?utf-8?B?NEVtTitFNk1DRUwreDFEL1dXZ2NTQmxyUVMzQkVOb0s2TUxnRE9CYXdjVldm?=
 =?utf-8?B?Q3E0UUNzVVN3L3V5bVNkdVhKeldYOWNFc29HOWhXRTlZYVVvcEdKMU9oU0Ra?=
 =?utf-8?B?Q2JRMUhNWnpES1VQbDFHVjk4S29nUlhXMXJLVXRHWkpxUGliMDFEUDJFZ2Y0?=
 =?utf-8?B?ZHJKZ2R3KzhKMk1YN2tFcS9XZnFKclZjM1huSDRrcWQxeVdONU5odXpVUjIy?=
 =?utf-8?B?SllyUWxkaEVIcllpZkxNMStaNEl5NDJnakRKTkJLanF2Zi9wZU5UNjVub1pI?=
 =?utf-8?B?Tmt6WTI4TC9FWkhlbG1DQ25WNjY0TGg0dmdmTmZrSXNLWUhpZWc4VWQyem5O?=
 =?utf-8?B?NWFodEh4TFNYbll1QVVPZUx3MXpmalRrdmRFaHFEcHd4VjdTTDJYeWs5Q1Ji?=
 =?utf-8?B?QTdQYkNWMWtOcGFFTzRJOFVBY0UxS3drazRwNFFkSVlrZ1lHUk5QSjVEM1d0?=
 =?utf-8?Q?OVTWeL/YklY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTBYZ21raFZIdlhjb3l0NlNjWHVNYUU5YVBZTXoyOTBJT3hWcmhUd0NVL0tz?=
 =?utf-8?B?UzZiTTd0YjNERzVFRDFCK1VkRE1kR2t1Ny9BMHcrd1Bnc2lhVXhkSFY1RTVB?=
 =?utf-8?B?SlNDNXhBQTlJOXN1eStaRHpqd2gzWHFZMElCdkhrb3RZZEdHQy95RjUxdVhP?=
 =?utf-8?B?VVVZelVHTW9rVWlBMDltTy9TQVJMNlVuYUd3T1BHd2pRQU9vRUxNbWQ1YmZj?=
 =?utf-8?B?L1dNd1pvbFNZL0ZCSk5BbVV5Z21kMWNEN3lBYVlONjMrZXFEd2F1QzlmOUtL?=
 =?utf-8?B?dms5aGVTa3dzaTRlK3BGbE9FTzlWTjRweWtqMDlTN0FwYkRUb2NlYUFTV3NX?=
 =?utf-8?B?elAyZTdNa2FXbCs3V0lMK040MVZXMFhiUkozL1ZETjdrMDF0VEVUbTdicUoz?=
 =?utf-8?B?U2pZMVBWTjJOYkJNalVCQXZBNjhSOEljL3lyV20rd1Jnd0FmczArdUFGbnRT?=
 =?utf-8?B?Q2hDdnNpNGI2ckdoMVZVc1ZONWJSZVBOdU9TWTZyNUlpaTh5MHhJcnJsNHkr?=
 =?utf-8?B?QUY2ZENZMjVpY2xlMU15M0o1cWo2VGlJK1RpUDJxbUh6MnMzRTl0RFpBeWE2?=
 =?utf-8?B?NXpNaVJRNGlqamFjcllETkdNelJ6VEVvemRXR0pmVGZ2ZS8rcGJxSE9pRWd0?=
 =?utf-8?B?TjltSTFXN2I0RlYzc2w3MCtIdkJIcHFITG9XYWREemdleDN1bUFDOEd0V21w?=
 =?utf-8?B?am9uTDRXUkUyQXFNV2UzSVFOYkJqWVltVGkvdmdnRnVVdmhGLzJvMUxFZHF5?=
 =?utf-8?B?aERVUVh2UWErMHZORGV0Z3M4a1EwUmx0cVU5elhuMlBVNHVyakNPT0JuMS94?=
 =?utf-8?B?ZC9vSW9GcWhQZXlZdUNNajZGcXhzR3Axb0t0STBwZ04yS0ZBZWNPVFFJb0hX?=
 =?utf-8?B?Rmo1VHgyUi9vMW5MSEVuUTJobmg2TVVaSkZNM2F0UUhGdktGL2I0VW1odTBX?=
 =?utf-8?B?NEVUbGhiY243K2RkS3JUS1Rnd0lFSTNQa2t1UXRMdnhmSFdWWkV1NENiV2R6?=
 =?utf-8?B?ZGVvQWRHbjExZXFuZ2t4bGdpSzJGa3c3VjJsOWRWRHg0U1BhUzNEL1ZQQzlB?=
 =?utf-8?B?cTByaHhNbXVTYi9WTVF4SFhCWUdPbXdRaVZBQTluajFuSU96T1ZqZk1yUmJs?=
 =?utf-8?B?WWVDL3I3MmxreUhMTWcwMFJDZ0hPVU9VNmE5YlVzVHFyeU1GcHdGaE9sb2l2?=
 =?utf-8?B?bU8wYjdSTXJLOTRrVFE3M0loRWNTZ0NNNnhQcUFieFhQcUhPbDJVZGxxZ3o2?=
 =?utf-8?B?dnFnVW5aTEpzSE9CVi9CS0Q2RG11cjZ5Ry9xZzRVY0FZK3p4RXAzUWtkWEdO?=
 =?utf-8?B?dXo3cDErb3ZJcGZRbXlGQkI1eU9rYjduYWE2c0ozQ2lZZ3B3blppK1Z1Q3Zs?=
 =?utf-8?B?aFFQYndiVzR2RXVSV2R0eUk5eE5Ea2x6U0M3S1hzVitLd1lGTWg5eTRzNzAy?=
 =?utf-8?B?T3JtbWt5OS9Ob1l5a0hSSDFtUUFOTGpBS1h6bEdoOXFhRm91VzZ0TkE3SE13?=
 =?utf-8?B?bjZ3QXpTb1hlbDBXZTVDR1JhRjhBNDlXTnBlZWw4bE8yUXNZcS93NWg3akV1?=
 =?utf-8?B?cERscGFBZjFreEx2OVhFZnFZTENYOUpxdnl3a2VsL2RQMnZ5anBTeVlrWkh1?=
 =?utf-8?B?emVQVTlWeURjdEJxbUlJd09jYkxUWDZQWkNwM0pkd0VTakdjOUxKVE9HZjVW?=
 =?utf-8?B?N0EvYktHbERtSElmQSswNnYrWUVjNFU3T2ZBU0NMdEwyQTZ3ZVpaTUV0NW9k?=
 =?utf-8?B?WjM1T2U4UDJhMkY1SjhyemJpQS9PUkE1VCtGRjQ3Z0ZqMEJmaVJKdHdJUURT?=
 =?utf-8?B?TGJGQ3lHYnhxbHZnVHIyZGdINE1sVHFpNnFwTmlwSGdpUmlOT0FUUHhvT1lj?=
 =?utf-8?B?dUtYVS92Y3c0V1hFQjJsNUVQWkw2MW94cXl2KzNmTVBNU2dDcnJsaWRkUGdU?=
 =?utf-8?B?bVI0ZThJeTllRWlvUi9xNEdwaVVnYitwUW9hSlcyMVhIRVdSS0E0eDUreXBj?=
 =?utf-8?B?cDN4TjduM2hTbWRkSU5wVHdpY0JOTFh5Y21DeTYzZUJDQVZZTU16eUovWDFB?=
 =?utf-8?B?SnlGaUt2b1R5ZWdXQ0lrRXE5TnZieldqOTVpcDF4N2ptRElVYkZQUkJRZkh5?=
 =?utf-8?B?OGc5RC9MTFVWRFBEWnMyTThCbGNjTWNqdzd5NDV6ekhJbzl6RGRqMkU1WC9r?=
 =?utf-8?B?RkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dobq0RRR/Yxw/NFt+SI0bP56MAtMpEeKqUuBCHKtsHaiU80MQxq9zGBeolKI8kesBONtbsKYOEOVWQsCVvhQhZQEIGr/83F9DD371wBW0xGLwyfmYc9UAWh3sbFQ8y1FmaocAiLIadMcat2qeNu3ip+BdgPCoClNipolVBrVjPO8Wi9fcT9SHeIeKizPCR0WPqevQG1kh2K0Ot/ErZWcjM1XWT6PZKyl3d23xISXr97+lFA9RdH5RhykOptD19vJo6WpgDpOttlLYfoyLcwkdCnGwzlFZklvJ69/YhXcERK/RD+dxkzmc2nHAowxhNukdHywvMxMSQ7AWHS5INCtZp9Ee86euz0FzrgyVn5W5065tE8V8ZvzbGnJiw/weT7jKiyecnSixYkAAd7s3Wquy3OKMNhkYrFcXO6GxgC6+5p6FCnaZRdln/lFUbUx0loeN1F8MQtjr6swkXgpywWSvuek3TpHDR/TmKaiDRfk69UGfPA7T2FD6VK7Rc0IbKWRnbxeqxMsts5p5vRGPfcD2O0qri28WtI1VvCShbhkTgLGSWkD07Y0awNuxthAWymo+0rC5RBue49ewUX75YTAje43Qx50JzzLZqv22MBQ8+4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36a06feb-dbec-4346-6afc-08ddd771b2ca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2025 18:22:29.0613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yKcLnPou3UpYaFwWC9XpssCvtlNAHPkuL8U5FROnxMEjvEpLN/N/6t9AbrAoxS0M65qPLVP52DNFlDqBlONdzVKG1JgpY6nVVTaxRmsUYzk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-09_06,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508090146
X-Proofpoint-GUID: Y8BaH__ZbBkxMscIdn1msCAbod8HjdMC
X-Proofpoint-ORIG-GUID: Y8BaH__ZbBkxMscIdn1msCAbod8HjdMC
X-Authority-Analysis: v=2.4 cv=ePQTjGp1 c=1 sm=1 tr=0 ts=689791e9 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=FNyBlpCuAAAA:8
 a=bfyhL808tvPq0BzXQ68A:9 a=QEXdDO2ut3YA:10 a=RlW-AWeGUCXs_Nkyno-6:22 cc=ntf
 awl=host:12069
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA5MDE0NyBTYWx0ZWRfX5FDZplQsPA2O
 iMOenoL+vk+9cA+36+yCkGkU1pHmvw+zs48ZqKI4gHAb8S0Z9rw9ncwVgKK5XYDe8emmxZtyxZc
 A2KD1CrxdsG7diKDqDJ/tusyccgiY4GhhylQ6qW+fGaZ9WLUPqyaeqmXNyXG1Vyf9fR34NEPSG8
 c0p1+QxZjbxcF5nG0VtPKSRt35oikjvG7zKgTBEF4FXV2zy7b7weRdua0L5gLyGyhCrCaQLzNkr
 HRqopZZEdg0NNqXahuxxEkzetqjQXtTmNPlwK7CRs44fS3P06UkYQTgj1zPfOiDPMQNBoiFuQpm
 eCQb7ZeHKLt4v/JfijxroAVS+QqK35l70OAqszGSzg9qB6R2scxN6R1ene6ZUMnJ7h14sxNfuSM
 x+cxmbRsP6ooUE0bZRF0P9cR33TP3olETVljgqy2wMy9H0lHWiCLBy3aud9Olwt7bP0MJvbK


On 09/08/2025 06:32, Linus Torvalds wrote:
> On Fri, 8 Aug 2025 at 08:42, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>
>> This push fixes a regression that breaks hmac(sha3-224-s390).
> 
> _Please_ describe the completely random strange constants, and why they changed.
> 
> What is "361", and why did 360 use to work but no longer does?
> 
> I've pulled this, because I'm sure it fixes a bug, but neither the
> pull message nor the commit have acceptable explanations.
> 
> And honestly, the code should be fixed too. Having a random constant
> like that with no explanation for the completely random value is not
> ok.

The actual explanation is given in the email here:

On Wed, Jul 30, 2025 at 09:11:49AM -0700, Eric Biggers wrote:
> 
> I haven't touched SHA-3 yet.  This is a bug from the following
> commit:
> 
> commit 6f90ba7065515d69b24729cf85c45b2add99e638 Author: Herbert Xu
> <herbert@gondor.apana.org.au> Date:   Fri Apr 18 11:00:13 2025 +0800
> 
> crypto: s390/sha3 - Use API partial block handling
> 
> Use the Crypto API partial block handling.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> That increased the descsize of hmac(sha3-224-s390) from 368 to 369, 
> which made it exceed HASH_MAX_DESCSIZE, causing it to fail to
> register.
(https://lore.kernel.org/all/20250730161149.GA1162@sol/)

This is an anti-pattern of the crypto code that AFAICT ultimately stems
from the removal of VLAs:

commit b68a7ec1e9a3efac53ae26a1658a553825a2375c
Date:   Tue Aug 7 14:18:38 2018 -0700

     crypto: hash - Remove VLA usage

which replaced e.g. crypto_shash_descsize(ctx) by HASH_MAX_DESCSIZE, a
hard coded limit that's supposed to capture the biggest struct you can
possibly put on the stack (SHASH_DESC_ON_STACK() etc.) -- since the
crypto API is stringly typed you cannot know the exact size of the
thing you are requesting ahead of time (the sizes could vary depending
on which implementation the crypto API decides to use).

I call it an anti-pattern because it's not the first time this has had
bugs either:

commit e1354400b25da645c4764ed6844d12f1582c3b66
Date:   Tue May 14 16:13:15 2019 -0700

     crypto: hash - fix incorrect HASH_MAX_DESCSIZE

As a minimal future-proofing fix, maybe we could add something like

BUILD_BUG_ON(sizeof(struct md5_state) <= HASH_MAX_DESCSIZE);

to every hashing algorithm, and/or a dynamic check in the crypto API
(completely untested):

--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -361,6 +361,8 @@ int crypto_register_shash(struct shash_alg *alg)
         struct crypto_alg *base = &alg->base;
         int err;

+       WARN_ON(alg->descsize > HASH_MAX_DESCSIZE);
+
         err = shash_prepare_alg(alg);
         if (err)
                 return err;

...or maybe those on-stack users should just do the kmalloc and be done
with it.


Vegard
