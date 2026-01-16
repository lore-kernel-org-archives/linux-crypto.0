Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8131E5B9E;
	Fri, 16 Jan 2026 10:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.166.238
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768558511; cv=fail; b=gYY4LCbewEcyg4SXlvedWyAjqYqPXkYSzKY10CTO3THkr2sKVuaGRbTZR8mXKqy1l4xqN32OovHQq8I8afQJix5Ad8B468lcs2rI1xHRP1XL+2FPhIRL0MCU5jpjyU96wU9vWGS5uN+JNqvUG/4DG1N9xhFTpMdYDpgONRIF9lU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768558511; c=relaxed/simple;
	bh=WZ3Y39nmD3ycuzsuEJSmPQPPz/j+DERhdwBjoKL6HCc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RknpqXfRl1wHc7sKRue46fnk5CatH0CnJgAO3brWiltria5I/EEzxgYmz351dpGhn2mb1Qv6oA3EmVxRYw+Dg8II9aEYmuRWQZApdaIuYVTeb8Zbw1URdNF+V3+1ua5Y7iU71iwnvUU2P05AUdgtZuR0PZ6Qr3ZjSqWSDxh2EaI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com; spf=pass smtp.mailfrom=windriver.com; dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b=cfZCriQt; arc=fail smtp.client-ip=205.220.166.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=windriver.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=windriver.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=windriver.com header.i=@windriver.com header.b="cfZCriQt"
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60G3RdIv2086258;
	Fri, 16 Jan 2026 02:14:48 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=ogbbVd4UrjXmmaNHMDwHzUU3bTJgtwxHfc7yB+oYsGg=; b=
	cfZCriQt7MMADbRxKQeZOiR3Nse7bnsXSLY0l6kZ0sjQEBA9HLpeVX2RxppVutOw
	ro+f3wk9nUj1XGrqb/R/u+eMVR7uO8kyJHiPPn8ahe6tayTFN8tNrEx+NjJgDyqj
	ApGErABhUls19BPRzOkgvVWujleQoM8c1KiYeonwEF8OT6Mqqj49IBVGEVA0MS1P
	XFgb/OBGUpIoI3xtaGOMHS8ef2Ot0Do5JAbpylGN3Y2aVA2RS7y9C1gDnjO8JTiV
	MpSIxgG1rcsraTEscofF9UpKaFk316nJo7bhbv0CqsBJRiWXPJqud7QVGo75wT25
	byOBvIvj0yQ7SngkWqMdsQ==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011016.outbound.protection.outlook.com [52.101.52.16])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4bqde48a0c-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 02:14:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xnt6wc0GLIxvG8+TNmLb10rXFFf7XVlfv7/il1UDz7Flb1fWSOadAeAFQEtY+uD7oHU9xDgU0Plph9sGeTnZ01buW4MrWIIUYWgyCL22vd8D7DrqHWQwZRmiaRXrwyAZoa3kHY1oQVnINLVrAPaxW8age8yIVd3Jk1rsMMNPUPXMS7EORRVTKwUMKpqlygrukwsMBt7v1duEtVvPcDPXXAh5jL6quHgmDwN2jcNl1s4OG+6jAp6ljIWzlvxpghAvmZxYSSlosyffwzZF7N7WpJ0ggkYGWIxB7016WN4fpftjvjXf1QxhLBHLLoPG/imcM4bWmYvp6KBYuS2rRKixcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogbbVd4UrjXmmaNHMDwHzUU3bTJgtwxHfc7yB+oYsGg=;
 b=cTgmTjncE0iqv9kHkgA9JxTa5s25u/6yp84upjwTERgaykVHPnpIrOOc41Cu8DEF+MYIRO5DEAeKwlAX7N73N7Me6GYrhPGmbKncYoiRUDDJY8T8XyL0krwRggsUIUNyIoxizqq3UZ4tAEhhAbIZZGJq8VnvR5LvzX0455AIJqCj8G+ogScu5SIOgrums1zU7q9eGUZ44AJJBaJnxsyrZpfPVP6eRhS7CQadKPtybHTmZbUJRwL+AyYry74t4twu5pxTIm5txQI0QRAARb1LxsMV/UpZZr+eY75RImdHzTr7/iJhDBhaDNmnuka6gXn5ZOjmEH53aqWG2i8cc9N9Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DS0PR11MB7736.namprd11.prod.outlook.com (2603:10b6:8:f1::17) by
 SA2PR11MB4938.namprd11.prod.outlook.com (2603:10b6:806:fb::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.6; Fri, 16 Jan 2026 10:14:45 +0000
Received: from DS0PR11MB7736.namprd11.prod.outlook.com
 ([fe80::f7c7:f271:a7b:7a68]) by DS0PR11MB7736.namprd11.prod.outlook.com
 ([fe80::f7c7:f271:a7b:7a68%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 10:14:45 +0000
Message-ID: <4a5b1ada-0602-4f43-b09b-ba1a8da26f21@windriver.com>
Date: Fri, 16 Jan 2026 18:14:37 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: caam: fix netdev memory leak in dpaa2_caam_probe
To: Breno Leitao <leitao@debian.org>
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, kuba@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260116014455.2575351-1-jianpeng.chang.cn@windriver.com>
 <4h7joiwvamq3sgrkhyemtug4lucyicnx7beuik3i5foydwb256@iemjvkrs7h2d>
Content-Language: en-US
From: "Chang, Jianpeng (CN)" <Jianpeng.Chang.CN@windriver.com>
In-Reply-To: <4h7joiwvamq3sgrkhyemtug4lucyicnx7beuik3i5foydwb256@iemjvkrs7h2d>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY4PR01CA0032.jpnprd01.prod.outlook.com
 (2603:1096:405:2bd::13) To DS0PR11MB7736.namprd11.prod.outlook.com
 (2603:10b6:8:f1::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7736:EE_|SA2PR11MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: 66cdac7f-6434-4010-5995-08de54e81290
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|52116014|366016|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?K2wwaFlWcWRqbFlWZlRIb2lyUlJvV3hVNUxZMUo3RTF1Zk1SOVpGbHI2T1RY?=
 =?utf-8?B?V01wQ2tUcHJFeVphYy8wZEcyOGYvdytJZlllWVkzajFieWxTTGtjTWFwWXBR?=
 =?utf-8?B?cEpFUlR5WU9OVWtIaFhJbW1WaUdITXl5dDd6N3Rjd3d0MnZFOXBBOU5HYjQw?=
 =?utf-8?B?WnJhZTNnWjdMRE12TFYwcndoa1R6NmZMSHp6MGJJbFl3bVVTb3l5RUZWb3dZ?=
 =?utf-8?B?aWZvM2E3UU82VDczUDJkeXVrVjdRNURVVW1zbzJ2UC91bVVOR2dxeGdGd3Ru?=
 =?utf-8?B?amxMNVlQTlg2Q1pFRmh3emQvc1Z6YW5hTDBxWEJXNnlWUTNGNHhBNk1VWmsr?=
 =?utf-8?B?RzR6RUtXMUZoenViT3laVzZzNzJ0T2ZENGhvZ2dIaHF4c0lkRk9ma1IwSWxq?=
 =?utf-8?B?MWkySG5Xb082bUFMb2Z3Z0JrRFZXM2xsTnU4Z09CdlBRMWplTkwzUUJKN1VJ?=
 =?utf-8?B?U0phMWJSaDVqeTRvTkFQTXRsY3NIclVjUWIzVWNsdzllVjJrK0F2em0yVktJ?=
 =?utf-8?B?TWRCTEZmN2hScnZYa3pQdDZGTjQvMVdMZXVjaUpQM1ZsaXo0azFCSlpDbTlI?=
 =?utf-8?B?ZmgyTXJmdkhtdWlZZTFWZnI0V2dvQlQ3REJmSUpiQWlYQ281SVZrWm9ZbXlC?=
 =?utf-8?B?RHY2TmJtbXg3ZU9aaURsWDBuQVYyeUx1NHEyeWR1ZG94c2Y0NFRmTENUSU51?=
 =?utf-8?B?b1NYK0ZvMlhra2NxVlh1N2FHT1IyUGg0d0hobUhjeXRKcWRmekZVUW9TQ1B0?=
 =?utf-8?B?NHVkUXJ6bjVVSWl4eFBoSFEwS21lYm5YWWxVYzcvM3BETzZISWo1bUNIQnFR?=
 =?utf-8?B?UENERFJ4SXd5bHBLWXdtdmRUcUxiYUltdy80aHNtUGNURE9iTzRwNU45RHo1?=
 =?utf-8?B?eS8wVWNtdklndVJZcXZiRWx3VVZYZjdZalZ2b2QyVFA2SWVTdzJlS2pqQTEx?=
 =?utf-8?B?WTJvZUV5TElUMDR3S3lNaENZUVUyZWN4OG5CSnUwbVRSUkFWVndYbE80ZjM0?=
 =?utf-8?B?ZlVSMTBEVWlqNG53SGtvbzNhK1NCTURrcXVZdS8vQi8wQ2NjT2kvTEZhamEv?=
 =?utf-8?B?N3NVaDBhVGNGQXlMZ1AyUGZxeTkxVitVUzVDUHBJVXd4VlEzR3Fhd2ttU1RW?=
 =?utf-8?B?QStGbW8xcFp2ZVI0Yjc3QkRPQlBlUEJ4NldaZGYzWjRsdEdNYkIya3pSTGcz?=
 =?utf-8?B?UXJzamFQWU9IaDdITXYyZXpnS2djTmlaSjlHZXA0V29hRzBRK3d5YmpnNEhS?=
 =?utf-8?B?THhnRUVMMlZxNTZIVHQ0enlOVHg2cHc1b3Vvay9WTkVnUlNEbHF2WW9QN1gr?=
 =?utf-8?B?Y0JBRng2NmhtQzFKdUFwREkxQ0FwMXdXUkxRNWYrNWpRMFJJaFlNM2Y1SVQy?=
 =?utf-8?B?ZjUyclpHYkEwdWtsdEI4c3MvOWM5a1Nrc1Z1QWliTjU5YWxWQjRaaTNFazNi?=
 =?utf-8?B?WW15TXFqbWRkUkt4UGdZZnFYNmxzUDg1ZVJsbitoTWlydXMwRUtmcVFLZ1lJ?=
 =?utf-8?B?bGNKVGppcWZTM0IrYkVlZEhxOWxVVDZBa2lEMzBlTmRQcVBBalFCYUMwYnZV?=
 =?utf-8?B?OW54VFphK3N2emhVOHNZWG1iajdFTDhKOUttNHgvZ0g1MWN1T3NTR2owdllJ?=
 =?utf-8?B?SjNNRFFHc1NWVUlqRDFVZytjbXMwYmJuUUJ2YklhMHdrZzljdHZvMndqaUZN?=
 =?utf-8?B?ZTZMU25lcEI4NCthTWNJUVJycjBOUjVVMkRZc1BKczFiNmFFblZ1UzJhUk5r?=
 =?utf-8?B?M3ozRUwrRTc1QXl2V0dQUkRRZVlFLzI3dEQ0aGVrMmxYa2Jmd0lneFFHWGpG?=
 =?utf-8?B?TmFxSHc0L0RtcGozb1RQMEJIY2poL1hWejYxZGY2SlFUS0tkUzUrQStnVElJ?=
 =?utf-8?B?ZlI3QW1WaTdCeVVzMlZMTzFJbjZkRXJOVFZYR01IQnRRNG9oUkpPL2cyWXQx?=
 =?utf-8?B?MnYzNGErM2Y0dFplZC9DdTFoc0ZmcHZ6bVJTWkJJNWs3L3F4OGdSa0crWnJ0?=
 =?utf-8?B?WEh0Nng3OWp5eStzYzhXdHlKcWRUTW9WL1MxZHRUeDVpQkZwSTNvYUc4Sk5y?=
 =?utf-8?B?ZWxLYzRmWlBGTHI4RDgwSE9tYUZjTFhxZWQ5Q1hQcmlON2tUQ1JpS1Y5NXI4?=
 =?utf-8?B?WXRYckNtNEdxZzFjZ3dONDA1MkRhTGk0ck5rTjVEUEJkNEkrbEwxRlhyeStE?=
 =?utf-8?Q?f1rk0xI1wpvE5hVRvcx8OOw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7736.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(52116014)(366016)(376014)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SUVQbVJZcjF3RURmUHRQSExHYmdTRTdmUnZVYXhuSHhXYkNEWWptOFBKeFda?=
 =?utf-8?B?UVZORHZYa2ZKeGROUkJmcDNhZk9ZVEpHMmpoYjNrQTRmNkxWR1ZkTU02MWNp?=
 =?utf-8?B?VUZBTU80RmpOL096aGpEaFY5T2ltdmN5SDYrQ21leHhsN2doZnViV3Ira3RD?=
 =?utf-8?B?WXBYQk5KQ0ZVdVNRMDVPMnpVTW9zVk8xTERBNnZCd2pHSXJpVSsrMFVuRXRl?=
 =?utf-8?B?aWlLMnhyTlBuUWVGbTQyaHdMMUhuUmNZMllTNk02S00vMFFNZmhJM2FkZTBL?=
 =?utf-8?B?QjNNTDFSdDZqU0FSYVpzT0RteHNDV3VzN3U3VDlFODRSWjlTbjhHclNub3Iy?=
 =?utf-8?B?em1oVVV5M1RYT2t0eTFFaDZUTHBuTUkzTHFRTXpuQnVWcVp6RG9sbm9UZ2ZM?=
 =?utf-8?B?ekF2YWhqdlA1dHpaQ21JOWN6RkNjWnhTZ0F3ZmZ2Smh5Tlc5V3ZpRStsTDNB?=
 =?utf-8?B?YVFJbm5qVGxMK0FqNEdHQ2E5b001cng2a3gySTBYWVlmSUZHdndRZ090QklN?=
 =?utf-8?B?OFg3L01SMmRVWEhzNXB3VSttYnl5STNvRWs5MHIvaGVpVWpSbVAzbHR2SkVU?=
 =?utf-8?B?bFp1Nng5ZVFDYTFwZlZMdk9oWmZyQnFCOW5FVWJ2UnVNVWlLMUxrU3hoZjZz?=
 =?utf-8?B?L2djeFZUelJOYkxrY3RqcXgwNmNrY3B3cFEvbWVlcHdKeDNLelBjVlZNR0x3?=
 =?utf-8?B?cjZvTVBRWUxEelp1cy9EbmJXNUxKWUFEWi9uWnlSR0c1UE04NkVDMXZxb2hx?=
 =?utf-8?B?MW9ucThuSER2MTZpckJpUWZRa0hLTkdWNVJFM2lRK25XY0NyNXVKV3dQVktw?=
 =?utf-8?B?dXAvQTh6dmZldXpBSjgzb1dsaVRoVzlEb1FJTGtDcHlWNHhjOGlLQVpsNXdo?=
 =?utf-8?B?VVp4bEE1UENzdVROZ2ozT1dCNXNNb05lU29LRUlIUkduTy92R0hBWXZtYW9n?=
 =?utf-8?B?Vk56YmRaUHlDSE5adkdLSlJvdDdxZFhQcC8reTV4aXltdnpPUzRDWXd1Mk5S?=
 =?utf-8?B?SVczRnc4Vm1qc1VCWlhnU01MQWZaSUtXQ2E2ckEvSFBLRXRTYzZKRjJIWkxz?=
 =?utf-8?B?cUtVZHRlN2pBdlRhU3M4bExtdlllMFdCeGVsZytkUzBWa3dyQVRDOC94WWwv?=
 =?utf-8?B?L3VyaU1JS0xjdHFWL21RV0dRa2F3TnYwOStuSjB2OFBsNUNkWnBGaDFBam94?=
 =?utf-8?B?RU43M0FjbWcyekY2eTdhbDBvY200STYvV3FYNmVWUG1Sa3FRVnhETkRnbFNV?=
 =?utf-8?B?UUQwQUNhZ1BodU4rRElBZ01ZOFJrUHFjeGMwYy9aRFhxMUYyWnRvNEp0ektr?=
 =?utf-8?B?RHBKcXpwWUhFd3VLeDN1MTRqWDdPRmE5SDBaMXp0bWVTZzFUMDV4VEFFOVdw?=
 =?utf-8?B?SW5sdEpwZjB3cHlTZTJTZWlzbm1qNUp5R0Y0N2lxdjh6VjJjYXhhUHRNZTZa?=
 =?utf-8?B?bzNMbGpRNnlRRGVyUnNyb3RUZnB6YWJOMXlFQTNnYnB6MlJRbXFHN3pCSlcz?=
 =?utf-8?B?V3R1WkpCcnMxQzdJLzY2QmpOK1Z3V1RRL3RsaXcrbWFiVW9qR01zbFl3V3Ns?=
 =?utf-8?B?dkVJTk9VVjh5MjJTWGRHaVhZOTEyTVNzTzdxbUNnRFdWSC9hbHdKV1E2ano2?=
 =?utf-8?B?NEFlTjg3aGppVUpGUlVPMDlYZkZScWVHeksvWk10WjJOWXJlQ3BhSmYzeVAy?=
 =?utf-8?B?aXQ4OTY1ejFCUEE3SUY1ektJK2ZVa0pOL3NPK0hTcitTMWpCUEM5bkJmMlMv?=
 =?utf-8?B?UUxub2YxclB5eHhBRTNyaHNpSTA3Y1lIVHp5TCtTVVl5Nkdna3ZtZ1dFWklC?=
 =?utf-8?B?M2RISUN5MWpvMkUwZ1k5c0VGY2NrOTZpMlhLSlo2cldsdksxOUEvdFNuSzAx?=
 =?utf-8?B?OFFvMFRKM2JRNEljSHViK2JzWHV0cG1PN2FaRnQxZWFrakJUVmx1RDRSQWRw?=
 =?utf-8?B?T2tiVlVXbGFiWXJkN0hhaW1LUElXZnJSUjU5dG1DM21JUlRhRENreFhCSnlY?=
 =?utf-8?B?M3pCYjgzdmcvRE5KRXZPaVFnY3dONWNXUFBTZnMwZDlPTXM0VEhKQU13S3Vu?=
 =?utf-8?B?SldIOUZaWWF3cUdxZ0xYYkFBVzhTTmdGU2QrUW1hTDM3ZDkwUGFJQko5QVBJ?=
 =?utf-8?B?d09pOXpGd3AxTGMzanJacFlTeEVjaUI3ejBJOHB5azR0ZDNyc2krdGg3WHQv?=
 =?utf-8?B?YUk5MEE5V0RwSGxyWklDRGlPMzh6MCtpR05hSEViUWtwUEczSnAyMVZsYWNs?=
 =?utf-8?B?bjhFNXkyVVNJalFIREpaUi9pQzZkRlpxYU52b2UzTXRxK3UyK0R6REg3WjNZ?=
 =?utf-8?B?QUZlQlRxZGJWeVpCMmJlbnYvY2FDY0pOdElPVGNOdWtzWnBzbmYvY0NLWDRK?=
 =?utf-8?Q?dhTgXGJ4cizQCdRM=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66cdac7f-6434-4010-5995-08de54e81290
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7736.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:14:45.5227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JgR/aRmrgU41ULvvePHB3ozoaVYzhSmIrSHfRxAgbtTSjZljHbtVlcFHBJaaiXUaTSC/g4NzpwtJsIQvoTo7SVhNtIbV0MwSG1l0nfbe5jY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4938
X-Authority-Analysis: v=2.4 cv=XoP3+FF9 c=1 sm=1 tr=0 ts=696a0f98 cx=c_pps
 a=Nwoz+Mp4en+GxkTyGjE1QQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=t7CeM3EgAAAA:8 a=jR4bhtfo8VARWxY-4XoA:9
 a=QEXdDO2ut3YA:10 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-GUID: V5jeiSRAibSbh9ATD6o-qLsUGSDIz_tu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA3NiBTYWx0ZWRfX7I2t58pXSsVx
 jFOWxEc/TGoXmPnTBPPr/0qa9CcACsDJzxDIkuW9JRLo5rZMbnGE4uIObot+MXtHZCog8+UPdwX
 SMqLKL3EM2Yc5iZ4HcYj14QLDBEke12KQM6bPsv1m0KdmqxLLerwwRNik4APH4/h6sgAXAD4DjV
 cMNb6emUN2nCAb6u8OfVnZdRFV2PxQMYF4F7Mm0HhCo0psAp72lXjyn9qlGcN9t2QmnxwnVQG//
 1j3i2MVyx/njTwUY06FbFTp8/oWDmWjAH5WPOjMqKeMtImr8T0+aBzDPdEY7g0z89sUuDb527Zb
 8/F6W1LBpy+n47SzlKM40ekcH6otrNfQgu8ZvT90ZHj/FcnxEJRK8aW085AGYW2L0Cj3e6iiPWJ
 lGd3S8NZHbU1AOyc6f3UoH2PEd6OGdlO+6GYK8WEohWB+jbVvqNu63jebTFwobSLZTnr0ime0Iq
 Asn9xcZONdRrbk8P9pQ==
X-Proofpoint-ORIG-GUID: V5jeiSRAibSbh9ATD6o-qLsUGSDIz_tu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2512120000 definitions=main-2601160076



On 1/16/2026 5:46 PM, Breno Leitao wrote:
> CAUTION: This email comes from a non Wind River email account!
> Do not click links or open attachments unless you recognize the sender and know the content is safe.
> 
> On Fri, Jan 16, 2026 at 09:44:55AM +0800, Jianpeng Chang wrote:
>> When commit 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in
>> dpaa2") converted embedded net_device to dynamically allocated pointers,
>> it added cleanup in dpaa2_dpseci_disable() but missed adding cleanup in
>> dpaa2_dpseci_free() for error paths.
>>
>> This causes memory leaks when dpaa2_dpseci_dpio_setup() fails during probe
>> due to DPIO devices not being ready yet. The kernel's deferred probe
>> mechanism handles the retry successfully, but the netdevs allocated during
>> the failed probe attempt are never freed, resulting in kmemleak reports
>> showing multiple leaked netdev-related allocations all traced back to
>> dpaa2_caam_probe().
>>
>> Fix this by preserving the CPU mask of allocated netdevs during setup and
>> using it for cleanup in dpaa2_dpseci_free(). This approach ensures that
>> only the CPUs that actually had netdevs allocated will be cleaned up,
>> avoiding potential issues with CPU hotplug scenarios.
>>
>> Fixes: 0e1a4d427f58 ("crypto: caam: Unembed net_dev structure in dpaa2")
>> Signed-off-by: Jianpeng Chang <jianpeng.chang.cn@windriver.com>
>> ---
>>   drivers/crypto/caam/caamalg_qi2.c | 31 ++++++++++++++++---------------
>>   drivers/crypto/caam/caamalg_qi2.h |  2 ++
>>   2 files changed, 18 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
>> index 107ccb2ade42..a66c62174a0f 100644
>> --- a/drivers/crypto/caam/caamalg_qi2.c
>> +++ b/drivers/crypto/caam/caamalg_qi2.c
>> @@ -4810,6 +4810,17 @@ static void dpaa2_dpseci_congestion_free(struct dpaa2_caam_priv *priv)
>>        kfree(priv->cscn_mem);
>>   }
>>
>> +static void free_dpaa2_pcpu_netdev(struct dpaa2_caam_priv *priv, const cpumask_t *cpus)
>> +{
>> +     struct dpaa2_caam_priv_per_cpu *ppriv;
>> +     int i;
>> +
>> +     for_each_cpu(i, cpus) {
>> +             ppriv = per_cpu_ptr(priv->ppriv, i);
>> +             free_netdev(ppriv->net_dev);
>> +     }
>> +}
> 
> Why is the function being moved here? Please keep code movement separate
> from functional changes, or at minimum explain why the move is necessary
> in the commit message.
Thank you for the feedback.

I moved the function because I thought reusing existing code would be 
cleaner in dpaa2_dpseci_free. I will add the explain in commit message.

For future reference, what's the preferred approach when needing to 
reuse a simple function (4-line loop) defined later in the file - 
forward declaration, move it with a separate change or just implement 
directly?
Thanks for the guidance.

Regards,
Jianpeng

