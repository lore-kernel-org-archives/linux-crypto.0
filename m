Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2086.outbound.protection.outlook.com [40.107.102.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC04513D278;
	Wed, 29 May 2024 16:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717001431; cv=fail; b=XpJyUYkSnMEyK1Dg8izdQ/0GDkB6Urisqyw8Jb446tn3qDFzUBN8+KwSmuwqxBsLAYGRria7fKJhBwmMheupvRc1fOJmnE8sKzIy1O+RPC3xdPLZaPLNu4927AX2cJauQTHQGgBXHKQziyX7twcWfEmUSPJ8c10LOHvO8SjW1l4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717001431; c=relaxed/simple;
	bh=zAjNJ838MM1D93Hi3izGb+WzRenrXm0v7VonR+al60Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tAiusEEq91XNFQeI1MwfmzjhUEW2V/fBeF/h/eKSF1VKncO+7DteADUXUlCuWq0Vg04dvxw+2WPHe7e/jZ+BHclRHPQu0xbASq5KkjzetyIPoniYMwA1ooUX5L+0vEwFUylHtFB51paqwwIFWYlg9JBtcbc75gyaSuQGUdfig2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OM4RgOwE; arc=fail smtp.client-ip=40.107.102.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OM4RgOwE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0BseoDEVlUTiVQLzdJ8ZyXOhtzeXNexa0B9GxfTwA6xl9bZRDqna8vPC+P7YQh0FcC+i8tZp6bux9ICwbus+DzfdqYYM0DDKuS9IJKC0nSfygSa/gGgPcUKRT++9Cagk8bhGrBhsaiIzvQvOfNwC+kLkxZ9XAdsxOcEJ4C/HBwROu1zMs7D/Xu+Qx0YUqdvzaXD+sZ+E2n0cA+/1A8lJsr1lZ7uTugB/cy/MNW9GrD/PF/Be6Esh6H42Zdre5wgRSzQoOf7qSRf9drUAY1RMAi/on8xUlZ7YjtEyhLlFF1+/0vY91UEt2UK43JlT52JIefE7th/V0h2B9WqoWlhjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z2yXMnL03LHO07+rulsgGA/pUs12kHQ9fN+BmKdgR9c=;
 b=jIzU1jF1EQAxY7vl6bQxfGrHNKgP/dwaAUctlQ4Ph6Pigqy8l5CmUPc3pWDlBVpbIh0qxbBXlRtkCcemiR8b3P3jh8lG+BD6aM6ErJDCnhzvPiGNe/x3LUd6/GsivdqgbHSeDDpCJYuuCE+Mn32Ogg41vaQ5IKb8hsA1SE2o+bjQMCN3VY5qvNJH4TAvk0VT48t6JJQojLVKiC9c9BO3ZGIYZ4nBzCjZZ9yIoB+bS1FfOQ4bm1eB5VIQCSPr40Aye6YnT2aHzg2REMsXcUMHk27JWF/jS2f6LbgQH9m2TgFnWAS9aKTEth3jHJMhm9e3R+RGqLuqORw5Wqd4a6+cEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2yXMnL03LHO07+rulsgGA/pUs12kHQ9fN+BmKdgR9c=;
 b=OM4RgOwEJhkXoAMTQLGLhb26PfJnbzNvJTfvRDmFWNE8R2dOIjuH90Y4TLaAlUN3lVeL+Zqz8amakGD46WXRmyKTZCK3rp5N9l+TbyTTs0qAa6QImSkld2oZtKb9M/cCOhuO1eHMxSrf+HUgilSsHGXBskdZtl5iBsvj572/eAU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CY8PR12MB8196.namprd12.prod.outlook.com (2603:10b6:930:78::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Wed, 29 May
 2024 16:50:26 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 16:50:26 +0000
Message-ID: <e0293a49-3609-a83a-f129-97ead8467057@amd.com>
Date: Wed, 29 May 2024 11:50:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 2/5] crypto: ccp: Move security attributes to their own
 file
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
 <20240528210712.1268-3-mario.limonciello@amd.com>
 <7f9db4de-635f-6204-d261-3bcd0aac1c25@amd.com>
 <e29a975a-cb63-43cb-a421-8d7dd5ca36a6@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <e29a975a-cb63-43cb-a421-8d7dd5ca36a6@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:806:121::33) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CY8PR12MB8196:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f500747-acf1-4d14-2a17-08dc7fff70e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SkRNTkorNmQwc2VqT0ZxTUFoaDBET0x4SmdINjdDMm5Fb1hOaXRudCt5aHJB?=
 =?utf-8?B?MlJQNUlyYWVuV1ZIUkFNK3JId21VeUxJcXIyY1FqcHNMeHA1TElMaEZjVUJP?=
 =?utf-8?B?TzEyNGtTdlBBelpVZnd5UUVLVEwvR0F5SWkySzhLenJCL3Jhczg4ZEtuRWc5?=
 =?utf-8?B?eUJON3hrWXNMV29md3N1KzJJbVZpOFV6eDhnR2VPSGVkZFozdmw2MmtoUXZj?=
 =?utf-8?B?NjRUSDE0VG1kclJrV256S0VZZFBxV01Jb3c0QXNBcHlJQmZ6RHJtN0JOQ1Yv?=
 =?utf-8?B?eUVtQTdBQmtuM0ZIN2JTTHl5ZHRhU2RpMFpCZFdGeDFTTG5TaHo1Q0k4S29G?=
 =?utf-8?B?TDdsbXdDa3p0S0hWbEFLSjBLcnI0ZWlpUjhXaXk0OUlGYnZHUzRVMDFzQm9S?=
 =?utf-8?B?eHhnMjZZQ2l5QW5GSWszblY2cHBvWkxLSGdyTXNqb28ydWdGVkx4U0N4Umpy?=
 =?utf-8?B?MmpoMTJUd292RUlvb2RtaTBUTnVta3dRV2NocmNsNTFOVUZBcUZDdVhLdkt2?=
 =?utf-8?B?aHhWMnk1dlR5UTZsZFQxcWxrb2EyeFJNNTY1TisreHdrU0VTNWFQN1RqYXJu?=
 =?utf-8?B?cVo0SlJVNmRVbTY3VjcrenFoSzJkQ2JTUjNmeHBJM1ltcGEyMXA5UFF5b2gz?=
 =?utf-8?B?ZHFQeVVSNXRPbkZiemhyZHh4ZmtOV0c5bG5wR1RJUFBUaDNVUVJXRHNtS0ZM?=
 =?utf-8?B?K21RN3piQ2twd3BxdlVkd1MzVlYrbmhNSSs5Z0ZqcEExY3BBOWM3RHdINUNP?=
 =?utf-8?B?dU9NTEFCVVlUUElhRVdONkdPZnpDaWxQajk3SGY5YXdlNHowWEN4aUR1Uk1z?=
 =?utf-8?B?aEFJSENrZ3dwTkxXSGhrY0dxSGpESU5JNGd1K3dDWnNCcXlZNkkxVU03ME5s?=
 =?utf-8?B?ODlqR1JUaWlBTy9HUDkyblY0NWNYZlJzZXl4em1DcTkvLzhuZXJwbHlwMEo1?=
 =?utf-8?B?NHhhcGxOSXR3ZDdYWjcrQ2NtZTNoKzdLOHFhbm4vRVBDZWcwNDl0QjArTExF?=
 =?utf-8?B?a1ZEM3QwNjMveVdDNXJLQk1IWEhzVGpsRkg1RXNBMHNTYVU2YTVkcmZEYkdY?=
 =?utf-8?B?S01qUUc0V25TdWF0eHZhTUtUN205UWszdGJlQlZEMlBPaXhReXR0UEJ2OFhX?=
 =?utf-8?B?SmgySVZIMTVEaGEwZW92WVBBV2hwTnhEMmpEOHErZU9vek9UKzJ4MC9uYUl6?=
 =?utf-8?B?VUI2dXBqQUxuQ2NxQlJoempianJZSEJzN2VKbDBKL21FcHpYV29GM0NQQ3h1?=
 =?utf-8?B?NmhhSkdOWFBpZjhvcG9jd0ZBaFptMUZEWHNsNzNxbHZRVmRSZzBSbTFmOFUw?=
 =?utf-8?B?Y1ZhcGY5SXBKWkE0R3NYV2RlQXBENVdnT2c3VVFLWlNEOEZDSHlGa2RpbUNh?=
 =?utf-8?B?RGk3NnZoQkN6WUd1UjNMd3V2MnlRRThqWjlrQk1qNVBpbzdQdEpObFFhTnhy?=
 =?utf-8?B?WUY0ZzQvS3BpNjFRU09XRlVOdGpCc3RPNUtYa0ViQVVkZ3JVYVNQUUs0NW5S?=
 =?utf-8?B?bzl1bEpPanZZQy9BeXJuaGx2a0ZTbHg5ZThvVy9ZTFY0N1h5S0N3UFpCdDls?=
 =?utf-8?B?NDRjalUweUptRThDN0NYRTFYVnJWbkUrS0ZjdHdFSGtGQXRoQ1BsTUluZU1G?=
 =?utf-8?B?Ry9UUnQ5d0dsZU1mdE9ZYk9DSUFCeTJWRlVjWm1JV2M3R3FWc3MzalNpZGgz?=
 =?utf-8?B?dU9QdlNGRWpFd1FaajVOM3FhYXJPTzNtaXp5SlZtMk9yS1U0WEdoajdRPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmxOZGlhTCtpYjl4SDZ4c1hoQXVzcnVvUW9nRkFaZUlNY0tkdksrKy96bi9p?=
 =?utf-8?B?Mm9USDFzQ09qTFpZWlorTngyazlianhZKzM0dGRINFJjYzVwcnVacFJ4NU1v?=
 =?utf-8?B?aUN4eXRyNk02MUwyZUFwZGoyU2ZVcm5UbjdJaVBYUFZJakp0U3k2UVBvM0VF?=
 =?utf-8?B?VWdIeG9qVDU1WTVOb0dPU0N4cDBOTUhrcXdxd0ozK21OMEw5ZVJUdUhLK1M2?=
 =?utf-8?B?WXlyUndFUHJyc29xdzJPbUs1S3VENE45WVZpSU9DNGk5dzdZTXN1Umk3K0R1?=
 =?utf-8?B?eEZNZXNYNHQ2TEkzSWpoQWtPWGdQNnFBYVlURkhxY2hud1g1dktOdGR4U0Jw?=
 =?utf-8?B?ZGZOM2tZblFqYTJqMUNKdVNjZ0M0WkR2QjlCOU1TWFpFYjZXZUZZUG1ncGZR?=
 =?utf-8?B?U0NObkR0SmdPVlg1REplK2g4YkF4TzhDT2ZEbDY4eXNCYUw0b1Z2MnJzK1h5?=
 =?utf-8?B?VHV1Tm5Wb0ZFQXFoNW9adm1wYnV3MUNmYnF5SGFia1lIeEZudlN5MDJRS3kx?=
 =?utf-8?B?bGZYTHhvblZGUTRLcW9Za3RnaENtVGtaeTVnKzU1VE9xWFkrMGZmVHBmcGtu?=
 =?utf-8?B?cTJFSEhQWEIrTkdzdkpuOXBzYkxmdEd1dlZmNk9yb1NESVVDdVIrd3NBRkgy?=
 =?utf-8?B?NzdsejdtRWRwTk4vWnNDMldGQmloWkViaFYycGdndHBUNU1GY2Nqb3BaOThS?=
 =?utf-8?B?NSszcWhYbEZ6U3VVcGkrVVh0cWlhS2RoQkdNZGNXTmR4NGZBdGl5TmxyQXoz?=
 =?utf-8?B?NGZKYjNLUzZ1Z3N0d0tFcmF2TGlvNXRrVjFKRVFJcDV3UFlDUSttanZxVXBM?=
 =?utf-8?B?aWZ5U0draUlrT1dRajVHdTFpYVJXZ0NUV2FjVVRsY1VOdTNqM3V5TGdGRDBW?=
 =?utf-8?B?eDZBVXlWNldYcGRzWXliY3RlT2FYdnFMQ0ZXZENMTTFrMmVwaVp3a1pjQXBT?=
 =?utf-8?B?Wnp1ZldDWFo0bW1LYTAwU2drUktRSFI3Wjc1WElxUUFrZHNhdUNXRnptYWd6?=
 =?utf-8?B?SGtPSm5sSXpXV2lXZW8yeHltUUUzNUFXTnV0VEIwbUdleUQvUjVuOUd1VC9X?=
 =?utf-8?B?RTZkb1NuNjVxR0gzQWEyQzlsSnNCaE5lZzlvQkFETVB4aVBMamJJeW16azdu?=
 =?utf-8?B?TVhhbStRaUp1a2Nxbm1GZmdObHNnRy85RjNSeCsyNTJqb0VNZ1hmdmxzRC9T?=
 =?utf-8?B?cXZxVXBSeG94WXg0ZlFvWm1ZeWJrbERaUGZFb1FaL0NQZlB5bjhwVXovWDVR?=
 =?utf-8?B?UzlqazEvV2ppVHd4bC9hTTNNM00zSHo2WjlFNEpDV0QrNHZzQWVLdllHdlNs?=
 =?utf-8?B?NHFnMis1OTBWQU51dm9CYmphRVRNMGxCNEJQV0xVSCtGNW1xU0tJZG5CMFNB?=
 =?utf-8?B?UXNvZmpMSk5oc0Z3Q1dTeVVkNWhVenBtWjJuTGd4Szg0enNURUloSnNtdnBu?=
 =?utf-8?B?VWwyN2pNczRwWmF2N3RDcWM5OXp4dmlFbGIzOXZ3bmZmbjByaU1nOGIzc0p1?=
 =?utf-8?B?ajhSaHpnQmk1ajF6MjA1aXJuanM3bmttb0VPRVVXTFJxaThjTWN0ajNLR3d5?=
 =?utf-8?B?NGR1NjFzenN4N2x2bWorSjBwTzl4YUxwYmMvWTJTWkg1THhOWlVPcU1EdGZx?=
 =?utf-8?B?UWJxMGVnS2pPOEE1bDZWTlFMK3UzaEQ5cVc0QWVSa3JvYXlQVlNhdCt0dzFq?=
 =?utf-8?B?S01lRk15dTJYcFhiYkpSTi9LOEh0eWZZOWliSWpWZGxyK2V4VFhOODJqcDhv?=
 =?utf-8?B?WDVVMWdOVU5WSGkwVUZ2cGVoblJhOGRHWE5nRDNhTlZIRVVPbGFqYzA1QXIw?=
 =?utf-8?B?M3kxNXlOUG9tdUhPWUZDbDNGRGdVbTVVTzl0SENMb1pwak9QYWp0Y2YyTVNm?=
 =?utf-8?B?U0V2UXNlcXdVWjJIZUlRaXA5Wmt6VytQdnU2UCsyeHEzaXFJT01POEg3ODI0?=
 =?utf-8?B?R2xrKzdxOEZlU0lmWFNkSWpOSVprRlB3NVM5TDNiaDlGek91b3lNLzQxSVBE?=
 =?utf-8?B?cXdkVHd2RFMvbmh1RzdHS056c2Mzbkk5elJXaFFRK0o1RlhRdXRTaUtOa0h0?=
 =?utf-8?B?L3JyZG9rMXRqS1lhNDJFNG9RSi93OEg2WDV1QWN6bTY3SExnWFVDUVQwbGFJ?=
 =?utf-8?Q?IATTAdf5vklHoECikBAwK4zGB?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f500747-acf1-4d14-2a17-08dc7fff70e8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 16:50:26.8820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BRWtMipMP/uZzfwigcwoswYIeOPNbIEI0nWvl8Kp/ZmTaSz2hM3HUrIqF0vZwwPaTlJVZlyrDh8YPlQwQ2DSkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8196

On 5/29/24 11:22, Mario Limonciello wrote:
> On 5/29/2024 10:20, Tom Lendacky wrote:
>> On 5/28/24 16:07, Mario Limonciello wrote:
>>> To prepare for other code that will manipulate security attributes
>>> move the handling code out of sp-pci.c. No intended functional changes.
>>>
>>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>>> ---
>>> v1->v2:
>>>   * Only add psp_security_attr_group when PSP support enabled
>>>     (Fixes lkp robot reported Kconfig issue)
>>
>> Just verifying that there's no change in behavior in regards to 
>> whether the attributes are shown. Previously the attributes were not 
>> shown if CONFIG_CRYPTO_DEV_SP_PSP was "n" because the psp value would 
>> be NULL in psp_security_is_visible(), right?
> 
> Yes; that's right.

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
