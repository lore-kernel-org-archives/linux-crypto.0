Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392CD146D4B
	for <linux-crypto@vger.kernel.org>; Fri,  3 May 2024 09:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714727743; cv=fail; b=aJBAoScq3xZ5cWoshmRk7k0N+qWJaHGR9aYBgARSVKoTIfQ0rxgdFC4BQKkWRrKIUAkx5nXagnMv8/WcL1RIqeT8TD0xqGwu9RtyvjuR05Rw3dTTeAFgukKLoEyLEG69R6xFyQZR5/mDDuuYCoMJu7U0XQOIs2G3d9x3Y0XCJw8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714727743; c=relaxed/simple;
	bh=7QK+nkT5ZFU5xp2lzQR5D5il0QdgAXY+i0ia1zJYu6M=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=RCprmPNDAZFLN1JXlaXg1KhlyOgrJjNLGyWnfyRyhdZIqo+Ie5OwueLhZaLUL5KLwrnjmSCgWT01AW6X9dXNxJLLUEJ8t/DBQ5+m7QfnyaL8VVGD/907SKB7OmV3sbg/QV5QVbCf9BtMPxfWRduemJ2ftRhEkkWA9ANxlZGaWm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nNIyqVbL; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nNIyqVbL"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGv5AuVkiaHcZrbtP1HMl0dEjurh/pzJAaJcgGH9ArqG+a9JEXaF/b4fH0RC/hkPiwkvrF+/b1qSB7Karyk16GLYMXnbLZodMg90X7xK7aZj/ej1t6VilQ0jKcnrCpP3bVFxrisKdDNvsMTJ2kddxFKmpfiYA4zCL8AJs5BGuhIbpCcV52/MsH92GUNstN16I9jHEccsV5DfXSw8W+VSN7R9RBZ+gFb/35z8KbBvAQbHwohwsx+E4oCNzRjuIFILyqPygh0uZ3Uq990euCbVbc8bUS4+16yzLmaLMH2PDOUEuH7GhIQ9XlSz3lSqfpiO9dJPWNkc3nFg7u2GlOgUpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZdrsnSndb7OYvY7SZOcT4m5EM3LLY95ukvy94YyHRnc=;
 b=mxrd/gY5nizeUS2tbhJrdymRGijn2cTBK7ZsYrtzqzwvgrzsYKrs/lkHvfuqz9v3OHLoWUiUkAqooJg5A/pXgUTii0Lio5dggKSiuKtN7N5wK+b/14BTzpppjt9+wRNp8xmPUo1WBCMbch36wLrofoMisdVSwGmC9TKqfrRGo4U3/sGM2QaGey28YZbffnqWvq3/z2O9B5aeI1zbrQjnM4IjjrLo+T7+nEauZLFg72YuiahcHkVpMWszBSNaLxagKVvNzuvBMrf/aR9pmDmRwHaHQa8qiI6DoBAYOlzEJPVLRh/L2DCX0UiRuiRB2Tz7fVmW3re/SpMpcFinkyVt9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdrsnSndb7OYvY7SZOcT4m5EM3LLY95ukvy94YyHRnc=;
 b=nNIyqVbL7dLGMFHpwcR8i4OJQvh3eT+Fa6N6+fv4qBZ2VLV1nXu7hqcVHB/jdYxCFo0m9JEDlcIlLtmDyx7rBNDtM5GSYqBfFzLhYtbwPfZwar5ZT+6CZQJeFE4ODt2Wy8eIr2GMZr+zZHZgEc23QfQECDDlIBxVXnjaSNW5AGviJ31fL8DpcEHV9Xng6Z6UV4ZNVA/xMAMxQUDYrOfRCKON0wr7aGkNkXi5zhFc0eGr8R5aENVXxpBUVpUsGiD9F96lqrnk/+r93JskT2nC+1NhAuDtVGn8cIOSR6HZTPBoiTyxPoCemmxCGfjtJjxFWBrQjRPA4+AiIL2p+SxONw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 CY8PR12MB7609.namprd12.prod.outlook.com (2603:10b6:930:99::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.25; Fri, 3 May 2024 09:15:39 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::ae68:3461:c09b:e6e3%5]) with mapi id 15.20.7519.035; Fri, 3 May 2024
 09:15:39 +0000
Message-ID: <fb10f878-fced-4e2d-9491-c3555e50b822@nvidia.com>
Date: Fri, 3 May 2024 10:15:34 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/5] Add Tegra Security Engine driver
To: Akhil R <akhilrajeev@nvidia.com>, Herbert Xu <herbert@gondor.apana.org.au>
Cc: "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <20240403100039.33146-1-akhilrajeev@nvidia.com>
 <ZhjjNWKexg8p8cJp@gondor.apana.org.au>
 <SJ1PR12MB63391878683E395E6A3641FAC0192@SJ1PR12MB6339.namprd12.prod.outlook.com>
 <ZjH3zzInVjY+qOH4@gondor.apana.org.au>
 <SJ1PR12MB6339E3A141B161F28E5C76B4C0182@SJ1PR12MB6339.namprd12.prod.outlook.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <SJ1PR12MB6339E3A141B161F28E5C76B4C0182@SJ1PR12MB6339.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P302CA0039.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::12) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|CY8PR12MB7609:EE_
X-MS-Office365-Filtering-Correlation-Id: 47f78ae3-ba75-4d8f-4fc2-08dc6b519980
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UHl4SDR4eDNjcDVpd21OTzJJQ1lWR2lXMHVKNjBWcm5pckJRK21FRHFNNDVJ?=
 =?utf-8?B?VUVPd3ZnTmwwRUtBclhWWGhGRFBheFNUb0FMVHhSTWNWMWJhdU5xcGphdlo4?=
 =?utf-8?B?c3d3cXI2T0xlS1l2NEFTdHZveWY5Z01McUkwT2tKamhkZkZ1ME9nUUhSOGFQ?=
 =?utf-8?B?My8ybnRYSm84WTVGSXZrOWFBQ3FzVjU5SVVKYzZDT3dtNmxuVXFUbDVOQU9T?=
 =?utf-8?B?S09Tb25WK25ncVRRNGIrMlcyWHo3bWkxU24xOThTamhtTHRJUVlXejhIcEt5?=
 =?utf-8?B?aisyTUgwNmVRMXgvUlNVTG9xQk8zZSt2M1ZCelo2VEdoZUdJNjdTQmpxTDNj?=
 =?utf-8?B?aTVMN3JMRVZycnhuUUVBTGVBODFRZ29ncnJ1Sm5hT3piWFU2Lzd2dHVrTGIy?=
 =?utf-8?B?K09rREdsRUIybmp1WW12THlaRGVTUmladWNwY2tSQitKa1JYQk9oak5Yb1RU?=
 =?utf-8?B?QkQ3TVBOQmFCbERqQmQyRmFqN3M5SkVhcmVBeFhrc2RHUmpZRzhIUzQ1Y1F5?=
 =?utf-8?B?SkppdXpLQU1nNENqUXpVajhoQUZmT3lHTVcwd281YmU4ZWlxRVl4cDNFSlcx?=
 =?utf-8?B?WHVzajdPdkZBM3g1TzJkRWlwUFZTQ2cvUDE5UllJVFM0STJ0UjBQOWFZMTRy?=
 =?utf-8?B?RDhic1ZZeGYveHhLNC96SEF0Y0NyRGFZaE1GUkxCaHVEaEV0aEJYKzNkY3BI?=
 =?utf-8?B?dUlQNXBzMkhQTVpaL1JhSXpCd1hoOTNnVm5HUGplam95TnBoc2xsRUI5dm9S?=
 =?utf-8?B?S1dSZExZWUxlL2tKMGdsanBOK0dnUlFzdGFsb1drb0dGcE9hTml0aU9Ia1FU?=
 =?utf-8?B?YngyTzVSSEVmVW5UdGpHbjFGZFF4QnFacHk1V1JucG1uODY2SkdRNTV4OGtt?=
 =?utf-8?B?N1U0eEdGRkIrT24wQWI1VGlrM2tva29tSmNvcEFsNzQ5WUpMTTVKbGZlcFFS?=
 =?utf-8?B?bDMrSUpGVjFzQUprbCtkdFBuSEk3U3J1aVNyeTBDaElmTTJOT2NJenJJUkF6?=
 =?utf-8?B?cXlvSGpGSWJ0c3AyVVEzVERQYlN2QUptbXhvWm9OczE2eHV1VVBFVHRKMnEr?=
 =?utf-8?B?TERsdkExbHlwbTEyTk54eEhIT0dEQy82Z1BBdktXeW1ZTldTbkRzb3ZlYVJD?=
 =?utf-8?B?aDNSVkxsc0RtSGZGUFZldVJDaGVjV2NyYmNLZUVEZjhYSlllSlZUUGl1cTA2?=
 =?utf-8?B?aEVMeGYzSEh2Z292ckd2Znk2eFpFbUZ4WXVwM2FzQm1pNTRXeURXM3NBK2U3?=
 =?utf-8?B?ampMeGxacFY2bkhvWERsY25UekFsNFBmb1FNZ2VUMTl2OGQ4MVZsMkoyTlcy?=
 =?utf-8?B?ekRxS1A1UVF4QlVwVU5OVFJidVdSU3JNNW5RZzZyNHhxZitlRW9CQXVyYktk?=
 =?utf-8?B?NnM2eEgybEhJaVdlVm1nMXN2dEJjQ0NvMjl0Y1pjMnhNK05vdDhXVW16VXN6?=
 =?utf-8?B?SldVUFFHakF0UTJRejJDSmtWY256REljZ2Q2TkIxR055VmVrZWxGSEFQdmZm?=
 =?utf-8?B?bGFydkhjZ3hKZHVER2Z6SkQ5bDJvd0VTNCt6cFZoZTNpd3REN29oU0dqZGFk?=
 =?utf-8?B?TVJlU09CVWxlQUp2MFI2YWQ5K3NDdlprck1pbmJ3RFFUemJXTkk4UXduUGY1?=
 =?utf-8?B?bjc5MXg3MWsvQ1BlMm1TcXNGdHhiWkg5cWRrUGN2dFNkaTBiakEwYkNPT2o1?=
 =?utf-8?B?ZmsvZjhhZkgrajJ6aGpXWHJnTDNNS1ByK1NkOW94Szg0amtwK256SW13PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cE85S2Y5anlWTVJRMnhuekRUNUdsKzVtOTA5bUJ0M05HT0dKeWlKTXE3L3ND?=
 =?utf-8?B?UWdvajBRM08rWVplMkI1cm9rQzhrek5xd3c4YUp5RWNwTUN3K1gveHNHU0kr?=
 =?utf-8?B?SmNTejhpVmVSZkQrM3pyWUdWR2NnSDdVWGtwTUV5ampMeXpHeWFTczJjTkts?=
 =?utf-8?B?dHpTaG1ycElHVjZHVy9rWFBjS0JSbGFIQTIwOFhSMHJBSFZEeFdFTzI3dmM0?=
 =?utf-8?B?b0NXUHdCWjZGZlJ0MnBRUzhkMHgxdy9WRmxUT1dTdjJXRWVXUW5jOTdhSVZx?=
 =?utf-8?B?NWxnTEFzTit4ZjFDYW9UY2lMbUxDSnJNK0VVdFVvdHlIbzBHSnc4TnVGanhi?=
 =?utf-8?B?Z1NvYThPbDc0bWVEZjJ0dEozczBVd29xRVhjNzVHd1ZtWEQwZjF6WTBHT093?=
 =?utf-8?B?OHBKb2U5TUd1b2hqUGo2WjcyaEhTSy9Jc2ltOU5lejd0MjROL3JUR0xzRGYr?=
 =?utf-8?B?TVF4WjV6cm15OHhNRGkwU0tQV21xV3RaN2xyTGE3ekxvay9xK3paOVY0YXRL?=
 =?utf-8?B?SWdDMkUrUElzVENZd1ZaMmtFMVdQVTJTNjMwTmhGcCtkUENUOUlYZXJheFpz?=
 =?utf-8?B?UUxieHhlVnNJWlo4azZ1WHg5U0QyK3RFV0RpK3Q5TkF4RU5aYmVnYWxmS1Jy?=
 =?utf-8?B?ek5ZNDZIOUl0Wm56T2RYOG1pb1EzZ3ZtVlhLTXZQb21ITlhvaFM1Y0s5SDJV?=
 =?utf-8?B?VmRtTm1WSzR6UzMxaXlpYlVEL29HbTZKZFBwRWFZRUg5YzBBVyt0ckhsRFVH?=
 =?utf-8?B?UE82azJjTlpWZ0hhUG1QY0pZams4OGtnUHNkNFh1YTl0b0t3ZVN5TTU3aDlr?=
 =?utf-8?B?ejZidmI0K1ljcUtrQ1VIVnQrd3hqMHM5SWkrQ2xXak5HZGEwaEdyemc5WGMr?=
 =?utf-8?B?K3Q2cEswOS8yQnR5WVVEL3A3NDE0VG5rWUJ1eFdVRmpaWmR6TnRiWTZ1Nk95?=
 =?utf-8?B?QXBuQXE4a2tDUXB2aFZER21VUHR1Y08vN3BaeURuQy83Z2pWNWplbk9UQWw2?=
 =?utf-8?B?eWZaOGt0RnQrTWU2SjdCYzYreW5QRk5mbjhiOVFVV1luTUh1dEhvdzF5RnR6?=
 =?utf-8?B?SVRKQXVQN3M2cjJNRSt1K3Q4UjZWT1RFNFU1T1VlWGZQZ01XRmhyaG80ZE5h?=
 =?utf-8?B?bXZvNUdMcXJYQmtyV1I2eW1xSkRmaUZwTnFNL0F5Lzg0VWRDWWQ0dnZHRjZO?=
 =?utf-8?B?YXNZQUhtNTNQcDNLbFBrc3NpeGpVWUljK2FSNFFkODN2dG92U1M2cDRBMURB?=
 =?utf-8?B?VVhXcEpWeWNncFpLRXozRXlPLzl4L004QStBYnRDVmI3K05YNXExdjhnWWJr?=
 =?utf-8?B?TllYbkRyZjNYQTk5NlBLcXlBMENjMGxad1o5UDNpOHV2cFczaTg3allkU1J3?=
 =?utf-8?B?QmpsL25aNWVKMGVjczhsMFd0RUdlNDNEeVkyY3NsTlpQaWNJNjRNUEduV0s1?=
 =?utf-8?B?SnVzV0NwNm9aZFliK2drSFVRTDBsb25mZ0N5SVA0SE56eU1LQ1Z3VUNDbHl1?=
 =?utf-8?B?dDB4KzRTNG5WQ0dqOTVRTUlFRURTbzBTK3dYVFZucjdtd2tVajUreUVWR3RM?=
 =?utf-8?B?TjVod1RISDE5K2FaTlduQjAvWXpuZDdaNm1nV1VNbFRzZTQxMVl5ZnVkSm1a?=
 =?utf-8?B?a3B6TndRWE52Q0d6YUx0djJvT3dZc0VndU1ReEMrbkZ2aVpBZlZTK0tncXIx?=
 =?utf-8?B?V0NmYVA4ODY1M0pMbkFjL0UvRVdsYmF4NjVHNVl0RlgvOHlCcGpoY0JvQ0I2?=
 =?utf-8?B?Qmt1bWpsTEM0a3RFMXZkcER2NWVKZEp5djF3SE1HUVFoTHpoU3hVMDJIWjZy?=
 =?utf-8?B?ZUdXalZSUDEzUzFTQ2VsZTEwd2xNVFMyOER3S3laRVJNSmxSNERFQWJLVmFn?=
 =?utf-8?B?dWcxTng3ZUVKeDRaMXZWRW5RSG13dk53b1hqV2N1cUtpQVpyNzQ1TGM1Zk94?=
 =?utf-8?B?eXRBbkpMeDdsZXBFL2dkaU1TdDRwaDVoYnRrWjU2TzdOamRHV3IxUEhNTW1y?=
 =?utf-8?B?QWY5ZFhyUzh1dnFJNkVtNEVLSGZpYk9LcUlrN0IwU3ZNVXA5clVzL1NQY1Vo?=
 =?utf-8?B?bThjYXpab3NxNG9lNnJjWDBKT1NPNUtRRmVxa0VURHZtUVQ5Ujd6ekZMWTI5?=
 =?utf-8?B?cHh6OEVtS0Q1dVVIMmRJMFcwaEpodnVJTDVQamFHSHRkMmdaMGYzWEVWTVU0?=
 =?utf-8?B?Qjc3YUpOTmdVV0J2ZnZMblBQOHNyMWhwRitibTVVcmNzZ01vSGwrUStsSHl2?=
 =?utf-8?B?N1kxZkFISFBtMFgyNTA4b1hObUFRPT0=?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47f78ae3-ba75-4d8f-4fc2-08dc6b519980
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2024 09:15:39.4014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cLP2a05KvfOrXofJJ4Uy8f1WG5BCY43AKJ3od5MYABAlGjtuSBcnTtL3r/iHHMirsgHll7po9ecCKD1Wa0Oueg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7609


On 02/05/2024 15:56, Akhil R wrote:
>> On Wed, May 01, 2024 at 04:52:05AM +0000, Akhil R wrote:
>>>
>>> I had a question based on some of our customer feedback with this driver.
>>> While running tcrypt mode=10 with Tegra SE driver, it shows errors for lrw(aes),
>>> rfc3686(ctr(aes)) etc. which it does not support.
>>
>> Algorithms that are not supported by your driver should automatically
>> be routed to software implementations.  What errors are you getting?
> I get the below error. But this is because we don't have CONFIG_LRW
> enabled in our defconfig.
> 
> [ 1240.771301] alg: skcipher: failed to allocate transform for lrw(aes): -2
> [ 1240.778308] alg: self-tests for lrw(aes) using lrw(aes) failed (rc=-2)
> 
> So, I suppose enabling the defconfig is the right and only fix here?

Should we be selecting for option for Tegra so there is a clear dependency?

Jon

-- 
nvpublic
