Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBBFF9D6;
	Tue, 28 May 2024 15:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716910099; cv=fail; b=jDzQZSj5QDeeKp1aEo32Ktg3iePqWw09y/l+5cuI2uqlMrpU4oPk3YyxUOHBcMvQGj2Ot4gF0Iy70lleXDwH3jA1Ezio5A2ntwtjVAAsYaIVMgaKO2dp52iFWHBKWCk5WXm0WDspohmhAspOBN22ICyr8JCW3vHj/kisFZbFuio=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716910099; c=relaxed/simple;
	bh=yxex6Jk9/h6DeWeYZElyOrbt4ltTcLFdmdJG63V/hCQ=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=HMad3Ytxmu/bXYskA1/wGfbZGSWzWusOGNjWSedN9CbTm0AHvHwd+HBtkI4o8XF/peKjHPbRjvlprIcpsqRM6OKCal1VMA+91FrKc2Y9qL7C7XVo4NxXoOmQDMwqhRPTaNOc4DdRwq9452uYbYoULZCit/CePoWLLne93YpzP/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bNloqMTB; arc=fail smtp.client-ip=40.107.243.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bNloqMTB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ibd7QHovMblfSsQzpDHqJrbTMk/TRdGhOzCSb1WXgTVt77X9NnqDg0BLvrt8We/cWqJNGExybJy/ur2MAmPh6xv27JWcpPIThil1BvducXdzGEZzc+h0IsodlffS+MrTkx+R8/CLQwiFLqGmCoU1exRJ4zrVZ0Yjzdket4+qvznEcriCxVKyLSPGo3XeHWrj1XPJtSWZQHhWnhH863wxaaZ2OpsEcamHALsKN65T7AbQG+S3Vall/t4EInVaElq2PibLzDO+B/zDCPaz1N1zJtdnK2dT+HytymzrFJjfXGksIIIlgMe5t1JcfT7Yk6MtJBwudU2hUoW+ZAAaRCtRPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnhUr+YlXI5INNWFlVv9rCCShuypi8oQ9Ld8fdkZAXQ=;
 b=RmwNhNPYS3ibuhKKzCSQ54LV3/GZd60IXDlEjaDYVU8klbwlTfGEJUjuuhzbQVvVtChiXMppJimYJvRL8xwFjmtTizMea0r4ftgBalUGl6JxxLRbawm1TwqwSB3vPLwtSxnH2slrQIT0Q5z7K9ICO5nAKNMC0E6zgXBmsyj1+3XkEM72LuQQj8JA+fU3UD0Oli6I5YznL6EP34hV00iUY3E0NARcQHYJ7oKSaAq67ug61aGpFBj/wJo0tpspnGYNLedPw533AA+4P7PPTYE/PJBFGH0IGryCmSfuNTMEo/LCNxhsp3BrQp8XNl7XNcCl4JzLqI/nrRNjuKOz47GAWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnhUr+YlXI5INNWFlVv9rCCShuypi8oQ9Ld8fdkZAXQ=;
 b=bNloqMTB7gRGQgU6x0m83rBwWE0hjYixiXs/MP9mZr6gLVf9ooHAgAfUNysG47uTJ3hxe/A21FGttasp0GzZ+w4haN76wxIiyMwgzE5TrtGTHDKE/n/HdynKzv7jBQPvRxqPAUm2oZNydVlMIRcjWg2rYEizu0+LNmCJ6IqI0BA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by SJ0PR12MB6902.namprd12.prod.outlook.com (2603:10b6:a03:484::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.28; Tue, 28 May
 2024 15:28:13 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Tue, 28 May 2024
 15:28:13 +0000
Message-ID: <946a0fed-a3a0-8d67-8620-b58ce413cd12@amd.com>
Date: Tue, 28 May 2024 10:28:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20240527152649.3722-1-mario.limonciello@amd.com>
 <20240527152649.3722-5-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 4/5] crypto: ccp: Add support for getting security
 attributes on some older systems
In-Reply-To: <20240527152649.3722-5-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0062.namprd07.prod.outlook.com
 (2603:10b6:5:74::39) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|SJ0PR12MB6902:EE_
X-MS-Office365-Filtering-Correlation-Id: 93a26e6e-8be3-437e-7a72-08dc7f2aca00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YlJxN3ZNaG51cG05OE9KV0NrTHdIVlFhZG9NdG1HSEZRdTQ2RVQweEZKWjlW?=
 =?utf-8?B?QTl5U2JlUTRZVS9POXV1T0RGSVBNRVZjMVZ1T3RXT29tZmhyenFpTkZJcTJl?=
 =?utf-8?B?V2ZWVGh4aUJDWklYV09MNnBENmI3UDhUWHdBSzJpRVFCbXA2UHhRUlNjY28w?=
 =?utf-8?B?dVZNVDV4M2xDRUlNbUgrTzM1R2x3RFhiNHh0MXY3ays5NWJUWVdKTWNBdjZw?=
 =?utf-8?B?bUNVaFB5eUJrc2RPWHZ2ZnJTaEw2dEZwVnJvOGs2YkNCUFNjVGNyTGpBUVRE?=
 =?utf-8?B?NGdFZXhSS1o1UTE1Mk9uOWVRK2t2NDNDU0RiMmdQS2U1L3FjNWpHK2k4cHln?=
 =?utf-8?B?UFJWMjlvMFBzdjNVbGNyczYzQ1J3K3pQc0wwakxEVmd0ZDdGeWw0WWNOSWhq?=
 =?utf-8?B?bm1OUzBxMmw1VnZ3UzZ4ZDZJUkR5REpaUzYvL0xkK2xuNzQrQ1RYWENNVkhX?=
 =?utf-8?B?KzlaY1ZmVytvZDRoOWYzQkpoU2RTcnlibURtT3BscTZUKzJJMklNU3Q5S2R6?=
 =?utf-8?B?QzJSb2xGeG1oRXJMdk03aVU5dXNEcWNWSTZmTnNwazBFWmx2OXFja0JSUFdU?=
 =?utf-8?B?V0JFYmh5RXEyUC9jSXBPbHJXTTBvODdEOWVHenNETHhYRkpHWGJtSDZyaW1R?=
 =?utf-8?B?RU1jUm9QMDNQTlRUMVRVc3JKMFlTakRVL2h2L0VmREFwNXFFVHJyQVVVL1lk?=
 =?utf-8?B?dm1aQitGOUpFUlM4djVsQ3VSL2J4UlhKRHdYRytXZnhmZlZoZHFxZ29PRHJU?=
 =?utf-8?B?Q3NvRlgvcncxakptT2VQV0RxZmtJVHNBb3UzWmJnSytzMnJjaVQzamhXRHpl?=
 =?utf-8?B?UExURURsWHdtOUN3MllOVmdyUXNRU2crY3l3RkN4S04xNk56OGFicVdKMVVt?=
 =?utf-8?B?SXR4Z01qZnVEL3FHNVAzY1k3RWhwSjNjNDlsK0VSUm9QUFRJaFdiOGdXWUdV?=
 =?utf-8?B?MDgyNDBRNUh2eU0zZ2J2eTdmSDZEV3Ezakx0SEV6R1lSazEzZ2lFNDk0UUEr?=
 =?utf-8?B?U2h6Mlh3cDdhVjhhS01IaDE0K2Z5MXdPYjExWDBhSkxoQ2Y3NCtJN0c0eStH?=
 =?utf-8?B?UHNtdm45N1A0c2FnWGsrS3lVOWpsWm5rRnl6d0laUU5xUjd0aTZGdFdKNkxG?=
 =?utf-8?B?MTRzRnlPa2l6MUZCclBsdzVzaSs0UEx4UnFkVWMwTit5aXZ0bW5rek5QU3hs?=
 =?utf-8?B?UitnOFdCTkJDWTQ3aXd1MGZmaU5lNmdobXg0TlpwSExoK0NPSFA1c0ZLOTVs?=
 =?utf-8?B?SzJvTTJvNzJDUUk3ZnJ1OEg4Sk1VZlJnTldDR3VmeDhUQmJMNnhFNXRabkM5?=
 =?utf-8?B?MklYbmxrYTIzRkc1MzM2RUJKeDYyRzd5dU5KSEhlYmFPVnBndTlqeDVYUE5B?=
 =?utf-8?B?NHR1SytSRnFpQmc1U2xkdGxGNzhxT1JJUlBpZURKZk9LdGR5Z2tqaHJOZzg3?=
 =?utf-8?B?dUErbUZFWUdXTWVhc1haR1RZanpuWmRYV0xzTnhCS3lCb3QwQkczQ2IxSzd4?=
 =?utf-8?B?TkM5YWtwMS9uTUgwdDdRU1BzaE5lY0pNZDZVanhZZ21BWjVmN1RSeVUrSDQ3?=
 =?utf-8?B?dzh2MUg0UWR4OUZHK3JmWWNKdmx6bjRjRnlBNGtlWlUrZndYb2N2WU5FSGVF?=
 =?utf-8?Q?e7CVeGt493hSJUZjYKjawOkqkRS5ZtUldieZiX9Ujxoc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dmlPUGJMeE1PY3Z6K2MwcExZcmx3MDJkbW1TZitKSUpPS2J4eERaK0lXeUNQ?=
 =?utf-8?B?ZFB6eHNBZDNQMGJ3S2dBYlV1ZHI3MUpFWC9BSHdhNkpUa2FXdCtGTkRvOE5w?=
 =?utf-8?B?RUVPZTZVdERJNGM0TTVlRXpacXA2RmxrcXJJY1RKeG9sK2JYMmUzWGF2aWdp?=
 =?utf-8?B?Y2lzZ2tEQ09GcEJmRi9iMzdJdC9vZEo3T2pRbHlXSENOTzBBNVpmMnpIcEox?=
 =?utf-8?B?YzNBOWJOUFFXVjY0a2o0OHgvcE5RV1VsL2hScGZadlhiK0ZkWXZPb0J0M0Vi?=
 =?utf-8?B?YWhVVFBINmpGL0ZoSTZ0QVpxeWhyZllWbktUQnVxL0Yrb3hLU1ZrT3lJaXVq?=
 =?utf-8?B?MTNIclB4U1U3Zk01dmRWZnZRYk04UkxTYjczS3k0ODhRV3VHMTZld1hDdWdU?=
 =?utf-8?B?SVBReHVGMzBXWFhyc2hZZVoyZXFrK2pqM3lLdUNGVkVTWHQxeUdsNko3SU1V?=
 =?utf-8?B?U2ZaeHU2aDJJNTRhVUFhRlpsNzMrRDQ1a1UzVVhNbmJBclZzQnZDaTR5M3pz?=
 =?utf-8?B?VDBnSjhhaHRVVUNSUy9pZVZDUmhsWXhYZjFkTVlUSDA2TW5iOEVoM1FrMWth?=
 =?utf-8?B?QWVUUmdibG5IK0RUN3RveVRKQ3dFZS9JRHlSQUNUcDdaSXVsaWpROXBlT0pK?=
 =?utf-8?B?RXh2Yi9zaUl6SCtFM3BGNlo1SEpxajlTejJTMkRUV0xGcVhualVxLzN1REt1?=
 =?utf-8?B?Znp0R3RROFI3R0xmSXdDVEF2bW9uVnlBMTBNclVOcVZaV1pqcGZJQ0hIQUts?=
 =?utf-8?B?Z2IyY1ljQnZ0TjM1TmVUOVFnVDNsaVNCSWhFd2prOFpObFRvb0ZpK3UwcVZu?=
 =?utf-8?B?TUFtSjRrV051QUcxdVlabHRZVkszeGtFVmlRRkR1WXJ5UExBRGs0QjdPUTk1?=
 =?utf-8?B?SHdJN1ZKMjdZVDNUaGYvQ2tKUTZNbTZQMXYyZ0F2WHNHeXBhYWg2d2UxNDlG?=
 =?utf-8?B?NERXWXVKc2MxRW5ZNHhlWmdJSC9lSnhydk15SGJ4dXIrTFBLTHU1aGxCNXFI?=
 =?utf-8?B?Yi84TmNhcDkxMFdYWS9Mdm1GL09GRXY5WThjamhLT1FlUmNNaFlQK0hQUnho?=
 =?utf-8?B?VHl6YXhXTkNnT1RkdXg5SFRST25oZWVGNkRycUNxNHlSckVGblVkYnFZeWwx?=
 =?utf-8?B?MUVZUEw2NGc0VUk3T3JBYnozRUFINEFEcE1qQStGYnRrdjJ3Wk1icFhoVWZZ?=
 =?utf-8?B?UzY4elNJMDh4c0dIZldGb1RvNWxUa2NnU0gvODBnTnF0N1YzTjJlV1JzcTln?=
 =?utf-8?B?bVhWVGtkMHNFaDN1THIybUg5MzhjQnpqTllrUnlkb3U3WlhUakc1SVB4WVZU?=
 =?utf-8?B?WTFOUGhKQ1BXQTJYK2NEY2lHVzVFL1RBbkExOCtScU91d2duWlAwOFZWWENE?=
 =?utf-8?B?V0p1d3U5aUQ5Z0VxWXlSWXdRNUkybVA0OGFZOE94T2swQVUyd3BmY01DMWJL?=
 =?utf-8?B?TGZzOEFGWk4wdjMrWlhFQnMxeFJzckdoM0xqM01qaklaR0tMMWliMFJodUc2?=
 =?utf-8?B?VVl6OEh0dUQ3UFB6UDYzNWhBZjhKWkxzcXJaN1BvVzB0SXh3S1orRitBelBX?=
 =?utf-8?B?YjhLSXpxbElhekRHK1RLbHhRcURLUk9VSEM5MWpNTVZLdUR3eHY3aDF5cEpT?=
 =?utf-8?B?a1dBTGFOWHRqNkx0OVRkUis0M1lBVEpHOHZmTUtCZ25EbkRsemJISXhVQ0N3?=
 =?utf-8?B?YW94UDNCR1N1RUFqelZYYXdHcHQvMFRtZXRSREN3NEU2UmJkUlVHNFViMmFn?=
 =?utf-8?B?RGZTMWlOWDNDMU5XbFpVMUxwSUozYWFVS0Ixb3pvRzVrRnZuMmo5V2E3TFdu?=
 =?utf-8?B?QlZZelUwUGFvYkh3dmx0bEYxd1J2cGlSdjZTamlQNTY2OGdzNmNrRDhVWXJI?=
 =?utf-8?B?em9MOUV4aWtoWVgvajRtZ0NRMTdZRHRpQ0FlYk1aR2ZYdVlaOWpwTkdGd01N?=
 =?utf-8?B?cXF6NjJ6SklzYWJMcnF2YUFPNTBYNEJsM1ovN1Z2UldoZkxSdC83Y0NqU09F?=
 =?utf-8?B?ZDJmT3Y2ZzNPS2pvSnVKK3RUVjJzcXZiVHh3ZXN5SnFZUFlOQ2t0M1o1aUNl?=
 =?utf-8?B?TG1BRXVLOHZvOEdLc0ZsSUhEZDdMWS84ajEvZzFBOG1xeDNlSy8zNDl3OG9T?=
 =?utf-8?Q?q3Y4wfWaguXptyaBhdH6Y/L6e?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93a26e6e-8be3-437e-7a72-08dc7f2aca00
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 15:28:13.5779
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X5jS012fcDX/aYBmKoO94soomyvwx2cte43waSp2GZL8vTySSAoAGsjOLe1rJ6oWxzAi6Gwh8sfqqI6HR55nfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6902

On 5/27/24 10:26, Mario Limonciello wrote:
> Older systems will not populate the security attributes in the
> capabilities register. The PSP on these systems, however, does have a
> command to get the security attributes. Use this command during ccp
> startup to populate the attributes if they're missing.
> 
> Closes: https://github.com/fwupd/fwupd/issues/5284
> Closes: https://github.com/fwupd/fwupd/issues/5675
> Closes: https://github.com/fwupd/fwupd/issues/6253
> Closes: https://github.com/fwupd/fwupd/issues/7280
> Closes: https://github.com/fwupd/fwupd/issues/6323
> Closes: https://github.com/fwupd/fwupd/discussions/5433
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
>   drivers/crypto/ccp/hsti.c           | 63 +++++++++++++++++++++++++++++
>   drivers/crypto/ccp/hsti.h           |  2 +
>   drivers/crypto/ccp/psp-dev.c        |  5 +++
>   drivers/crypto/ccp/psp-dev.h        |  2 -
>   drivers/crypto/ccp/sp-dev.h         |  1 +
>   drivers/crypto/ccp/sp-pci.c         |  5 ++-
>   include/linux/psp-platform-access.h |  1 +
>   7 files changed, 76 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
> index 076c1d175b2b..8f583902d786 100644
> --- a/drivers/crypto/ccp/hsti.c
> +++ b/drivers/crypto/ccp/hsti.c

> +int psp_init_hsti(struct psp_device *psp)
> +{
> +	int ret;
> +
> +	if (PSP_FEATURE(psp, HSTI)) {
> +		ret = psp_poulate_hsti(psp);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/*
> +	 * At this stage, if security information hasn't been populated by
> +	 * either the PSP or by the driver through the platform command,
> +	 * then there is nothing more to do.
> +	 */
> +	if (!psp->capability.security_reporting)
> +		return 0;

This should really be part of patch #5, since it doesn't make a lot of 
sense at this stage.

Thanks,
Tom

> +
> +	return 0;
> +}
