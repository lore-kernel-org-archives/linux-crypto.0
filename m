Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBADF54670;
	Wed, 29 May 2024 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716996081; cv=fail; b=ES5Y6HB1uo9X7+eLR2q/+iNw6SwJwbKtmkrUBWqNKB3XclZATgLkVYfA7b43h4VYNSRodUVf7agXPzjag3gzy2RoLQw5Trx5+XQs/c991XVZcQGc9oX8j8egIRs1R4LuaPBj6e7wx2T0Zj0zCkqKrw12k0ALjB2oqJ1Ov4kNLq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716996081; c=relaxed/simple;
	bh=feitMPFY/mVdQJ8PSlJbYw5APNQzUz73MoZzcwZjj1I=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eBTOP1Y3aoFv6h51S/QK7NTx9OzewfwbM/uRqxwrMMckbVLbHUvhTd6GD9iLbVFR0lu/9avZWcVDzJ5WEOmjOc+zjWrqf3sGqp6lhivW8wOkKWXaURTZMmY/xOL2F5FUQsgxa01KFz/1nTdmgXJ8ld9yr+v1gbauYGmgZ7zTyKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XgVezFnj; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XgVezFnj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVeaww2qVNxrxZGQgYgEWFSbHJRdyApkB/DNyY6lHcm984qd7JHaRiBIi62X82mF9GcYYxxoCWHwnx38p6KN5GsdTVQ0fw94VSzHJ1Nqmw02z0M/FSCi3cDLaps7cUbtVztdztgqLfjslA1EeVSbLFtXb6E1SDr1utQYevSePFkz3nXYwk9C7RsCBLaIxTzHcnt1utbzMR5BpORFlFV+BNDaLl5eiNUjtZbpbaKNfCBjtmIwhrQvlwausKUbdAR+1etH8o8NGcGNPGCGTrSK8SSb9eAj/LJvCb5DrNcGZOWNBluQX/jnwoVCRUo3RDWekaH2iPdCxAkuwvNG3of1+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZXtB3FcsmvaghNwYvJFvBArXcmcsA0tYmSRwujLMF3c=;
 b=FgSVbiSLGRLQ1NE84KyQZ0McWVnKI3eVlEKkQcMAcqRoHWLgvN7iTUQGmwmqVZSco+8EvBRplvwXve5USNR5Wl4tpC9A+tZfZ6pPWVLYyj/PxOSuWOmYhhchu3XEA268+a7/1hjWeOJnFpMnELig1AFMm5rJMNIiLQhnwa843dxgOQKUcA6v0pZuJJv8F/KKxVnJbDVjX6PqIge8GDOrD3apXm3YYQXJso0XDwErNFZGyeE4u4R5Uf3uKjd5+21szaS/Xb1lK1ti18jwAbpKtbMqj4viGoxmeh7vtL2pagNtMfYsZV8rF3L9Asqbd3hxdovIqPfccdmcqdWLfUa4Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZXtB3FcsmvaghNwYvJFvBArXcmcsA0tYmSRwujLMF3c=;
 b=XgVezFnjZkZbW4LLN5nNClgf59ArKIIl3u74f7Bw77qfhavqcXHTXjculVx6FhDjhXlS7UqZfXJEyDGHJtLYu2QosuoalWh9/W/ocQLR/dypvntgGENwUOUnUdNW/POXN4b1pYQXVXMYr8egRGYNPQmMWxEhvbWHL7t/8V6Cv7w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by CYXPR12MB9337.namprd12.prod.outlook.com (2603:10b6:930:d8::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Wed, 29 May
 2024 15:21:16 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 15:21:15 +0000
Message-ID: <5bb969c4-5d73-80ba-7aac-fb47105a1f40@amd.com>
Date: Wed, 29 May 2024 10:21:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 4/5] crypto: ccp: Add support for getting security
 attributes on some older systems
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
 <20240528210712.1268-5-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240528210712.1268-5-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0019.namprd13.prod.outlook.com
 (2603:10b6:806:130::24) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|CYXPR12MB9337:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d57da52-c8b9-45b8-2f13-08dc7ff2fb49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?V3JMZGxDbVJRQUhHZTFqNXlUckU2aG9EZXVOaVFjdVJ0VjByc2dEZ0lTMzZs?=
 =?utf-8?B?UjRsTTdmOHVDYk0relB0NUQyOGJEdmF3NEVrUkpObVVTUFgwQlpFUitnVFIv?=
 =?utf-8?B?TE9Ma0ZWMjNJL1RjY1lId2FRTDV0bzNFZzk3bmV1eEZoNTdDQ1Y4K2NabnVr?=
 =?utf-8?B?S1hjTVUvdUtQSWpOejNxb2MxY21CdWxBWkUyOGI5SHYrZVRuMXJwMmNaNzVx?=
 =?utf-8?B?OXVwM1YyUzl1V1NJdlZFeEZYL0ttTHdReElBTWFRZHNuVmNCZzRkTWl4RGcx?=
 =?utf-8?B?WW5Pa1RSTm56OHJ4V3NwK0lRSXZWTCs2WXRIeDI5Y3NnSFh5aGFEQmlIaXZF?=
 =?utf-8?B?RzZ6VVB2MmVjVy82a0lQUkhIYWsrekZXTFJZai9jRVBHcU9GLzVpQThpZkdV?=
 =?utf-8?B?di9keWZEMVMzTTRxbFYybEg5aUU3NjZGKy9XQ0FlcEpYZE5kcENPa1Y3STA3?=
 =?utf-8?B?THpsc2RSZk1nQzlKcVY3ejVFRkhna2ZWNkVzRit0VG1LSWlqMWNMMlU2c0dm?=
 =?utf-8?B?R0krVG9yNmZndmdGWVcrSGlGU2p0UFdiWWs2cXBGc0pnVG01VzlMM05Yc1dB?=
 =?utf-8?B?QVNGMDlYWnhZVzd6OXNuNGN5Z1ZUNm9HS0lsd0NiVERVRml6MmVZVFhjWlpw?=
 =?utf-8?B?RGJaQ0x2dVlaNzFRVjA2cFQ4TDRiLzhqTjk3RDBEcm43cU4rL05WRTlVclZZ?=
 =?utf-8?B?andOc3NaWkRnTFM3NUsxSGtkMERyNTdrSHZlOVhvNlRKejNsSUNsdnYvMWdq?=
 =?utf-8?B?MnJzdDZ6STdxSFBabkswRFlzOGo1eUZ5T0hrd0p5WXpZN0M2azBwL3k3bkZF?=
 =?utf-8?B?TDhCV09QVlFnQlZHcXBuTGU2SEIxZnU1ZjhXWGNuUHYvL0x4T0VIeXNuU0pH?=
 =?utf-8?B?aythZHUzYllDbzdrU3VlRVRpM0IvWG85ZVU1U0h3cDVqN1NaRnI4eDZCNWc0?=
 =?utf-8?B?Yi8rclFTcWZqVEVxUnZsUGNTUjhzS0FqdzlLS2dPd013MldoYmg0MjhHNm4v?=
 =?utf-8?B?c3J3dlAyeENNaDJweUE2aitrN1I3MFlhWHR5T2FKSXZJeVE2NVp5MHdCQVVN?=
 =?utf-8?B?Z1YrZzlEbGozZWZTeUJCeExvbXFXeWdVYlI0bHdIdEU0QmM0bjZVQ3lrNlA5?=
 =?utf-8?B?NnJuUXVYdXhjMWR0VVFQRkh1V2pqc1ZjQVZaK1hvcGNxNEwvcHFKSHN3VWpu?=
 =?utf-8?B?U0lvNlJyWFNKcjA1UVlOOGZaaEoyZVpZN2psUVRTdkQzeEIzZWg5MXRNUFVU?=
 =?utf-8?B?VUpHUGdwUS9UaXFHYmFVUEZEV08vRC9Zd3E1a1F4akRIdU5rWmRvL0JkZVg3?=
 =?utf-8?B?dFFPZ0Q5cHloTlhRaDZDN091UHR3ZnJ3aGU3bzM3ZXdLTFUwNi9TdkxMa3JG?=
 =?utf-8?B?VDhiTnhJbGxCN21vUy9RTGVBcGdNanMyK0J3aGZRRGZzOGF4YUZJQ1VSWlFa?=
 =?utf-8?B?OVBLaHMwYk1Ta1k0T3hjVWo2SW43Wnd6M2hBZUpZOTZDaXpiV0RlOHJ6UUQr?=
 =?utf-8?B?T3J4QlNadnRCeDFkYy9jWmNXY0tiRWY1Y3l2d0lFZ3NNazRIV2huT2NUY3ZI?=
 =?utf-8?B?eENBQzZOSFliVzUrUjdHYzJHZmF4T0xsVHU0bVkzd0RXV3llY3NFckcyL1pN?=
 =?utf-8?Q?/aoyc3Yk3zHPvatByqGoLCOpJK2ELSQnrK/ulYV0okqw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UkIrUmY4dzhhdDJOcEdzRjBqWHZTbk16Q0FjclduelhjMTc1cmNjditaUXZT?=
 =?utf-8?B?d25CMXhxaUVSSGswWDNxcHBZSnhEdnFQSVpRS2s0UlZGLzRmZEZYdUEzOTBS?=
 =?utf-8?B?SVI5bS91Tzk0SzJTRDlGTlRacG8yUzRYYzRBSXJwZkwxbm9kRjNIZjhFdXFn?=
 =?utf-8?B?QjZodjBPak9lS056Tk04aFRtU2EwbTN1ck1xZklwR2JYd0R0OW80RFN2K1Za?=
 =?utf-8?B?U2RxbTRVeitneHprWWRwcUEzM1huN0FLUzlVYjdmZWRiL3h4RjcvNW52VWJv?=
 =?utf-8?B?OTdEM2xHVUR0dzlEOUVZZ1QxQ3hhenp5MVIyMDFGWlFxN1dKdDRvOHhDM2h6?=
 =?utf-8?B?SnhGOFVDRXRwSzRWZXp0NTVuTVRONXJWSVc2T01vaEthVkdFeGN2Y3NBQkxy?=
 =?utf-8?B?a3RvK0pKeXVnM3l3c2hhSzlXZ0oyWDJJaDNiYVprT3NoaVI4UVVqUWNsdm0z?=
 =?utf-8?B?a2thcGhiZFRIeWxWOUtMUGovZmcrUjNQVTE3RlhEcTVUUFdKQ3VFMWVMVldu?=
 =?utf-8?B?RTFKZ3hJa2sweWxTVWdXM0IrRzg3VXhIMExKckc3dUFWRkFNZmVEWFdCVEF5?=
 =?utf-8?B?YXl4M2ZpOGdnUTRVbUZDRUdkUTV2RHN3V1ByTTdTV0dHTkNxeFcxZ0M2cjZq?=
 =?utf-8?B?K21xWTMwVHIyZFlKd05JRlVNVGt1Y1RPMG5uZkVReHkwOWN3M0tudGhZazFD?=
 =?utf-8?B?cWUxNWYyWExlbG5MWmlLVFFGT1E4U1BUNzR5ZURHNTRxTlQzTnU5STdScm1q?=
 =?utf-8?B?NDcvUjBBRkVKOXpseWxyVDJOZ05SRkpUKy9tUVdFVEwzTVNUcW9kR3hZQWpn?=
 =?utf-8?B?RnRzZVkraEJRMFdDaC9tc0poc29CVFNiMGdUVmFIRWU1Z1JlbXJEcTcrbzVj?=
 =?utf-8?B?VzFvREI5cDR5ZzBZZTJueXN0ZlRWaENaWWVlcjh5MmF1RktubmlJRzRPLzZ4?=
 =?utf-8?B?Mm5lQTdYekYxRXRVbGcrc0xENmYzamlybzVqSW1KR1pYaTk4OGtaNVhTRjlp?=
 =?utf-8?B?VWNpbWZYUklaZHZvbzFWQ09nZS8xM2R0cFNKMHliWUxqVm9kdXBkUkxzMStZ?=
 =?utf-8?B?bGF1ZjdESU53SjkvYlU5Vng5aTFweFFURnFnRllNMXJPOGgwZ0FQSDE1dlFO?=
 =?utf-8?B?eHA2Vjkrd25reHgrRmx3dFZsdUlHU1N0Z0dsd1kvMFluTnhldDcvZHVlc21P?=
 =?utf-8?B?bTlUSmhoTjJ1NFlqTnJYbUt4Y3VJTnZBS05aTHNhaHlUVjV0dFBhMk4wZ3dz?=
 =?utf-8?B?eWxEdDlralZ6Q3hiS2FGcWh1cHpPWlNWNGtjUXJpM2lWMzVIcVZsbFZmWkpT?=
 =?utf-8?B?QUpCNzZJOW9RRDN6SkhUOExETmJ5cVdHMWkxMVZJWCtKT2U2TUM0OXRNREZq?=
 =?utf-8?B?a3NISkN1QXZFRDRza2ZSZXV6dVpyZGRzVDZlQVMxV1poUkZ5NEQ4ZU9saVA5?=
 =?utf-8?B?cktrV1hrVHhUWURmN0MzQk50YkZFeStkOXprcUNPUVJLYUNwSFBIQmt6SUNG?=
 =?utf-8?B?UGtBWG5qbUdBK1RWa0hYYTRzWkxxSm95dmFHRWk0SGthRDhuVVY1TXhYZmgy?=
 =?utf-8?B?cUZQTURDTEdrelJJdWpnM3ZIcy9sZzNLczVFMkRLNDJ2SUUwODBlVytSeHRI?=
 =?utf-8?B?RkMxemlDZytyU2NzTStPVVJ0M0VrejFhZDE2alhKbm1EdE9Zb1plZE9xSHlS?=
 =?utf-8?B?VXU5QXcxK2gyRnk0MUsrSE5wWnMwZU1PanArdm5UTU5VcWZmZG83ZC9ZZmxC?=
 =?utf-8?B?SWl4T04zTi9CdHEvMHZZa1BISGFTS1dQQXI3ZCszaUhvb01jRHA3ZllxOHVu?=
 =?utf-8?B?WDZ1cWxHWFdMV1AvK0FsZVJlTGNpUmZmbitMQlZPdGN5bkZ3ek9xYXNPMFBu?=
 =?utf-8?B?TDYwMHVSNlFZQmJVa09hZ1FSYnRTQUhnR3pXdWpBUXZEVmt4dXA0Z3ArSUtv?=
 =?utf-8?B?R3JHTlo0TFA3R1JCZlhaajYwZHU5cUIvQnE5T0J6T2h1VmFHUjBpR3VJLzFh?=
 =?utf-8?B?dnQ3R2VJYjRxd1JDTzVvK1o3b2wxMWxrUklaUDEvV2V6RWRmUEV6Z1RnZDFF?=
 =?utf-8?B?djFJOGZRMEdKMWxiMi84TFFIaUxKRzZqeUx3MjhBaUdxU0dPVXAwUTVSY2R0?=
 =?utf-8?Q?j/Nc1IiDue1IsADQhIcF2fgaF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d57da52-c8b9-45b8-2f13-08dc7ff2fb49
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 15:21:15.5541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XEN3rnZ+0yo7B+WrX4YpmWqHmjOJQaBWXxwAvXlhYMItwe8c5T2F3J2cEGvkDh8absiQLojhc6+btJjBSX7jNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9337

On 5/28/24 16:07, Mario Limonciello wrote:
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

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> v1->v2:
>   * Move code to patch 5
> ---
>   drivers/crypto/ccp/hsti.c           | 55 +++++++++++++++++++++++++++++
>   drivers/crypto/ccp/hsti.h           |  2 ++
>   drivers/crypto/ccp/psp-dev.c        |  5 +++
>   drivers/crypto/ccp/psp-dev.h        |  2 --
>   drivers/crypto/ccp/sp-dev.h         |  1 +
>   drivers/crypto/ccp/sp-pci.c         |  5 ++-
>   include/linux/psp-platform-access.h |  1 +
>   7 files changed, 68 insertions(+), 3 deletions(-)
> 
