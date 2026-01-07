Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012018.outbound.protection.outlook.com [52.101.43.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82A92F746D;
	Wed,  7 Jan 2026 09:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767776707; cv=fail; b=too1uT0Qij1M3XOeFDls0oQOkPvZ2ibHEF1rPWMYJxDz4F9QZjcNeCNjoRk46Pa+FYARsJ5UJN6BxnWygGrSELH7gz96fxYeKG2myzYWJzVGlP6RitFCsYdxaU+SYbpnI2fRe1WBRxkSe1aopTS7M8h83f5SNtdHLZ/68J/ZukA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767776707; c=relaxed/simple;
	bh=osD+sB01UqEABGx8/cB5IUMbZmz1LyjAmod3EPwzMKU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iKIRXaIICvUO7NEn7pqyIwljv5VfjekcRxxfxe9yRAPUNtDLFxhqThvcLxk/BpCzXPYLl9r4fXUBxyqp8uJnqmbErH0moNjWFfrv7ug7Z8YXBYCf/CAYyEBGGl9jgv87lbhp6XjGb0zTdkebUP2a64KwceE/NYQNOhzUcG2Xch4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OQ8zTl+c; arc=fail smtp.client-ip=52.101.43.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OQ8zTl+c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=guayUciyxeL4o3GpeRGFtEfus2Zck+RlPBFLzpoDkg25R2qeGDZfz+27SE2d2wmYn+NPN6c0+cWrs7O4Hr7K+US3jehglvtuSqcXgOSDFPp0b/AqJ8ec855IulPxhHnOSFlzKIi21xMlyUNzAgBfhlXNGoPQ1btUKIugoTNCS56+LE8CGt/CvT+C3QcrlW1YJaajUsniH7W1TSqmLsdr+Kwia+FNN7R4gpnPtTr96SngkX2tLg1QVv92Ei2T1BveXpLpJjkxnw5wQVkdZ8qhLaGbutj8iAhkdaSkFipxV5l4yY5qq5vyo/Tf74T0H4qO2zjC79mEKlxPOsQlKY8ZZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBrrFMiGJzbP6MsBwL/5j9HJcFvmzr5HZ3F9U/6/WDU=;
 b=bkl2kzWe4zOk3w0Rz+M9kco6k7D8vqEiiBUJHy/mvsnz/ITAda1vM/7ONC1lfCLwsd3KwvjwtLzBgBiSsmKbibHRrwybmkq8CU1980GbJzY+xCb2VVBWvzpVPqy0KU3NvtLd83dPj+pY2PPMooss4CQwlO15C9jh60Bg+W0DF7Q2GdNCMYBFI3sInSiVv96ijDmIug10vcvv/Yz0hW8++MnvE2M17FUo6XDmiPENAd0CO9d9zqw/laimjbJXngO0dKMefWtQmZBxax1q4MhLT9FsxRsoH7tELWxLs61r2tVv5dyShh9CXU0Kgu2yvJAcFwjZsK+v7SNN492bwppKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBrrFMiGJzbP6MsBwL/5j9HJcFvmzr5HZ3F9U/6/WDU=;
 b=OQ8zTl+chmsYIQU2kK3FcR90WqvQQXE2e9mb29u/nVmHGBT3qbZeL9H/OgQgWiqmy3k9aT+jVrQ3WjUGEr88zUX+38okBiQTerTn5TgjjMQ4enRv2c6vm6U2gmN25cj4Yy0+csPn0hS3c1gkUgIDvIQ/zkDQ51rnHy9l7iLRkeI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5176.namprd12.prod.outlook.com (2603:10b6:208:311::19)
 by MW4PR12MB6897.namprd12.prod.outlook.com (2603:10b6:303:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 09:05:02 +0000
Received: from BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683]) by BL1PR12MB5176.namprd12.prod.outlook.com
 ([fe80::91cb:8f10:c6d2:d683%5]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 09:05:02 +0000
Message-ID: <f1cb81b7-5aab-48d0-99ce-5f971f5d2fa7@amd.com>
Date: Wed, 7 Jan 2026 14:34:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/5] crypto: ccp - Send PSP_CMD_TEE_RING_DESTROY when
 PSP_CMD_TEE_RING_INIT fails
To: "Mario Limonciello (AMD)" <superm1@kernel.org>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Cc: "Allen, John" <John.Allen@amd.com>, "David S . Miller"
 <davem@davemloft.net>, Hans de Goede <hansg@kernel.org>,
 "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER"
 <linux-crypto@vger.kernel.org>,
 "open list:AMD PMF DRIVER" <platform-driver-x86@vger.kernel.org>,
 Lars Francke <lars.francke@gmail.com>, Yijun Shen <Yijun.Shen@dell.com>
References: <20260106045423.55190-1-superm1@kernel.org>
 <20260106045423.55190-6-superm1@kernel.org>
Content-Language: en-US
From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
In-Reply-To: <20260106045423.55190-6-superm1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0242.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:21a::8) To BL1PR12MB5176.namprd12.prod.outlook.com
 (2603:10b6:208:311::19)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5176:EE_|MW4PR12MB6897:EE_
X-MS-Office365-Filtering-Correlation-Id: bbc9ef2a-e23e-4154-371e-08de4dcbd773
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q3hZQ2QzV2U3dG5QaU41Y2E1ZUU0Z1ZmRjNCUnBMbjBwQ240alVFZHB0UHZR?=
 =?utf-8?B?ZWVSZlR5WEZiOTVTSW10QUM3cGJ5eUVDM05BcFhrZGdJNjlzMjJzOHlLTGJ1?=
 =?utf-8?B?bnloU1RkQW9vZytRczI1ZWNraHZRdWlhRzQ2NXRHdld3ZlRkaS8yQzh4QmM5?=
 =?utf-8?B?NGFaWGtMM3M1SU56SUlXRzl6Tk9maWhLeVV5dC9aMTVzNU8xdm1oSWIwcWtC?=
 =?utf-8?B?UEFuenc1WS9vcWJYZ0k4bWVXT1JObzRmeG9yalNBaFhkdlFJWDR2MG5kNkVJ?=
 =?utf-8?B?VHQyRkJyMDZydVJPSndOdnFTdVNlcWl6Q2gxeXpoTjA4cEZHSzA2ckgxRi9W?=
 =?utf-8?B?VTZRSy9NUFZkRm1TajhIdHlBWWlNN1laSE4vTFA4dm44RXREM0NXMGUvdFp0?=
 =?utf-8?B?RWtqcXhkdUdUT2dqd0V6Qi91VzR3MVRaMzF0RUdRRDA4VmhPMHNRZVdpMWVO?=
 =?utf-8?B?YnZPd2RsQnV0dHcvWG01M3pZeVlzc2VncjJEQlkxREJUUWlicy83SE54ZHNK?=
 =?utf-8?B?ZDZJcFhSZHg3V0RRMExwengvZThYLzZZMUtiV2FQUEZBOTZBdkdQSHZZMGxx?=
 =?utf-8?B?eVczVnh6bmRwL1BGcDVKOEdtUVc2WmJkWlNXRnZHUEZub0QwMkZTbWhrTFQ5?=
 =?utf-8?B?VzkwaGFueEgzWXBNRFlGSVNSVnUrT042bXd3YmpzSXpyY3dIemNHTjNJSXo2?=
 =?utf-8?B?N0ViMlI3K0lEcndsOGpyMWpuMEZYNXc0b1FWcDNOYy9xTmdGR3pSSnp0Z21t?=
 =?utf-8?B?S21Ub1RuZUZRQ0Q4Uk1sRnJlcTZqT1QzN29QYzZNNTU1MlQ5L1dtbXRLWkF1?=
 =?utf-8?B?c0dHSkRJWkZ4TURuNjRzU0EzLzczcklaKzNoenE5clptWWNYNmhmZmU0TXgr?=
 =?utf-8?B?SEFCVHE1aG1GZHVQSWJHb3FxVzdNd21tU01Ja0J1Y3VvVWlzOFR6VlUwSzFp?=
 =?utf-8?B?QmV1UmgzMjh3ZC9SUWlsalhmSDd1RDBlWU00aTArMDUrc21DVWFFeUY3dUVw?=
 =?utf-8?B?SlRiS3ZUQTZTQjRaSnBsKzdscnhxbldwemErSFJVOTFFalZIam1sM2RRays3?=
 =?utf-8?B?UnRHd2tzNGhOUjVTSURSM3NDT2lzam9pMldpTkcwSjhXd1ZmMTFadXA2NWJP?=
 =?utf-8?B?UUpHUzVlZHNQQ01CZk9ydjJHVlQrVkxsMEFJOGptVThzcWNhZVh1NnNEZmVG?=
 =?utf-8?B?clhTTDVGUGpkVXpVOGJTSzZzWUw5cVpJVE95YjVSUzBtM1pEM3lHWEc5UFdB?=
 =?utf-8?B?Smw0bGlTa1EvY3VjNFVDWEpPcU5PUU52dUgrOFJsbWtHM3FSUUxWbHExSFk2?=
 =?utf-8?B?SlM3OXFmSXI5dURXdmNKbXBQampPcGxhRnNMSmdNQ21UZ3h6M2p6NUFDOXhn?=
 =?utf-8?B?elczSGxtOTB2VUZjNTluRkYxNWl6WXAzRFcxa3lwc0NuT0xITzhjRnV1ZThI?=
 =?utf-8?B?MnF0S01EWThBL0EzOVh6SU42NVZDbUQxS1dxRTlBK1pzVmFzbDBha0hUNU14?=
 =?utf-8?B?TWNCUzdZNWU4bTVGdGxGZWN1cFRCZE9xYVBueElHbmNScnpIcmhBZDBXb1hD?=
 =?utf-8?B?MWlJbExBUG0wZUhackZySmFpMzdQK2ZoTDNqdlVnVmRqdWJyZjJJazgzaEhP?=
 =?utf-8?B?SEU1Ni9HeldpaEorRTkza1JwdjhsV2czbVZZbFMyNkhQVHJKK3NIWnprVFJr?=
 =?utf-8?B?bmFYOE1RMGFPZzh2TDN1OFpUbW9kcDRGWmhoSVRCWm1SOUZjTmsvdkNNdXdm?=
 =?utf-8?B?ZUJvQ1hkZFRrSU15T3RuTUNwMGhSRCsxMWRFVHhCYzJOZC9nb1NWVHF4UTRk?=
 =?utf-8?B?ZmNEN1FEM3dKbUp4Q3hYaGc3WXlEdm5COHFjVXhyV2g0VmFISXFkUVg2QmVX?=
 =?utf-8?B?TklOdnV1ME1mSENjeExRK2Y5ZlkrTVFKMDY1WmtzYlZEWVlLcHhVQ1B3OVE2?=
 =?utf-8?B?YzF6VjAwK21UcVBERVlpRExHUnhSU0J3NWljMjhhbC9YZ3ZwR2YrdFoyZW5r?=
 =?utf-8?B?bGl0VlBZbHlBPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eWdCTW12ZG5iN1dNSG9aNDVxWmxlVVJ0Wjh6ZGd6ZE9kdXV2YUQ4MldvYjEz?=
 =?utf-8?B?dTlJZnpCYVoxeFpZN2R3c2pXMzEwN3k3SDN0Y3llYmVXMGx1MzVhZnpnb3pW?=
 =?utf-8?B?THh4amVGbXprUlJrTy8wbVk2ZGZZNDNjdHRlQld5MkhqNTJ2bmt6UDJXUk8r?=
 =?utf-8?B?WUg2U0pKR25jS25aZEMvTjVSTGpNaGJDcHR6eE1jdHY5MktVSEtadHM1bHps?=
 =?utf-8?B?VndTVkFOQmc2eUN2bWI3aUtTclp2N2lyMXNBekh2SDhUL2NteTFrcVFLd1Ar?=
 =?utf-8?B?cktCNnRmSnBWRWNWblNnQnNpZ0UxNG1GWTFWTlhkUjBCTE9FaHFQcTFSaDdt?=
 =?utf-8?B?VG5EOFZ5Q1laU0QwVHNCUnZjd0JaUGtSaHR6WTBBMllka3h6VlFEdEN4YXds?=
 =?utf-8?B?d2FEWXJmZE9OUVYyZkgreEN5MDZzd0srNi9yMlE1ejdsZDVmZm9QMXZBaGlG?=
 =?utf-8?B?TWlxdEJxUjRqUktqTE5zbFVaZmdHM2dLOFRkalMvVHVnMkdBL1FHbWVLbVBS?=
 =?utf-8?B?a0c5M2xISmswNmQ0QUJqUXdYWnFNa2JDZTF1ZmhYeWtVS2FYQ3lFMkthaHZB?=
 =?utf-8?B?YlNlbFpWQU9teFRBb2ZzNEpEbzJIcnE0VDUyaXNub0FJVXBRL0RoNnJWem5n?=
 =?utf-8?B?NzJHUmJ1Z0R0S0M4ZFVJRU40dGtxcHNGNnlnYlRwNWk5MmZ5SzdGR0xOOC9F?=
 =?utf-8?B?TFhPdXAzdEFkeGMzNk5aOHhteldRQ09SU0k3N082RjRCaWxNWElvNlVoZXdR?=
 =?utf-8?B?SnBqUkkwZzY5RU9hZ0JSWG4vbVhUVW1vRDRjRzB5Q0dFUjBLSnhLOXV4aTFD?=
 =?utf-8?B?bU1Tc1VuYmMyOFJPeFVnSXR5Skw4YUF1UHNjRCtIMUZaRFpiYmViOHd4R2JQ?=
 =?utf-8?B?MS9YNlVySi9wQVFLTG9pS3lCT2RBbzAyeVZvMEEvL2VtYkVnZ0lyazBQdll5?=
 =?utf-8?B?MktQUEZncStOWTVYUzAvMCtJZ1pIMkJSVDBqNW8zSmt0UXhnOXUxcnE3UnJC?=
 =?utf-8?B?a2UyWVp0ZmFBaU5Dc2tnWitWazdURVl5SjFyZ0JwdUNSZVZoUDdRek5ULzJG?=
 =?utf-8?B?L2RqY1BYdDJ2MytEQzNXbmphb1l5MmFtWVJMelo1cjRRRFZNQ2N5K3MvemRX?=
 =?utf-8?B?ZW9QVmcvdktVWXJQUjg1eThMSWg1dkdRdXZ5djhjRk9UNDJLa2swaTJiWlhy?=
 =?utf-8?B?dHJsaEZOYkp4KzAwR0pKQ045N1NISFBmOEtIc04rQ2daK2srWmRnbmpLdUFy?=
 =?utf-8?B?Ykkzb2VMTFdZTXNCajFGSVZON0VZUTkycm9WVEVBWXQrVllPbXlBY1pONVhn?=
 =?utf-8?B?aENHa3ljNzBaVlZEclF0R1kvb1hrRGRCSWFaUTEydndyZ2gwVDgxV1ladE5W?=
 =?utf-8?B?RVZjeDAxdEZxMXYwZ0JJVjBQQlRwdSs4YjhwZzlrR3QvZHBpNWlDb3JmVTFR?=
 =?utf-8?B?QmM5THQ0c1JiTW0vNm4xN1IwOTZvT2xzcmMyVHpRTEZPOUlueVJwcDZLTVJs?=
 =?utf-8?B?Ni9aY3lPVTUvaDRkZnhtdlJiVWVXcy9pVHRNckZBK0o2ZURaVlZONUhhVHk3?=
 =?utf-8?B?d2dNUlFsU2dZQkowQXIyYnZJRUd3WmNWK3ZVRnhYUTNCZERzbTc3ZG1EaWM3?=
 =?utf-8?B?cllzWThwT3lrUWtHWndrdVNlWkdQeTlOTXdqUzZwa2ZtaWt3RGdMeXd0N2JB?=
 =?utf-8?B?UzdPS21OcWdKQ0hCb2hPb0RRNWZZWnloUlZNamlhdTY5N0pBYWFIMFhvRE45?=
 =?utf-8?B?SFR1amlINkRNMXdKSkpySFFJcW9lM0ltZEUyQUtzZ3JIYUZaY1JnZ2Q5TjRX?=
 =?utf-8?B?b3c3VXB1VHF2MmhMQ0xLVjFIWmVCdkpLUUpMeUNaVXV3NnVOdytPYnc5V0ty?=
 =?utf-8?B?eS83TEFJaTJCRmN4akFJV2FLOFdvK25lckwyWWxDcGlGYXFLUUs2ZGg2Qnla?=
 =?utf-8?B?Q2tRMENGQStscGY1Sk5ySnZIMDN2M0kxc1M4UXRHSVhiOE9iOVFWL25ybXZH?=
 =?utf-8?B?TkpncERNRmdUSGQ1UDEvUU9MWjlZb1pPTUIxR2h3dndxZ3RYMU9UTVFtVzJN?=
 =?utf-8?B?OXRDVklKZFdFSXdIQ0FSVzhoaE91b0NXMGlUZXcxS05ldjUwSjBZN2RiU3I2?=
 =?utf-8?B?WkF3MkMxSWxrbmtjYURIdXl2dUFIZTI1dmp4cy9QK2hKZzB6Q2tGSEVXZEpK?=
 =?utf-8?B?RXpId0lKU0I2YXp5d1ZldmlQa0VWZTR2NEcxcnRUdFF0REx4b0kyZjNPaGZB?=
 =?utf-8?B?Wm9aNGhoam5LZXcyME9BbVoweWtYMG1WRU1CUmpKWVpaamdtMlREbFdzczdk?=
 =?utf-8?B?d2ZUdU95YTBtNHg1Y2NsNk0yUUxRLzlWcWF3RGdJaXQ1Q0x1RElydz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc9ef2a-e23e-4154-371e-08de4dcbd773
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 09:05:02.4495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AhwsLuHxyuY5xCg4qu5idDuCwiq/yxaeQeXy2nOCJBP2zNRcTS17SLqgAhhHYD5FI8ABURMryVESGS1QpZTDVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6897



On 1/6/2026 10:24, Mario Limonciello (AMD) wrote:
> The hibernate resume sequence involves loading a resume kernel that is just
> used for loading the hibernate image before shifting back to the existing
> kernel.
> 
> During that hibernate resume sequence the resume kernel may have loaded
> the ccp driver.  If this happens the resume kernel will also have called
> PSP_CMD_TEE_RING_INIT but it will never have called
> PSP_CMD_TEE_RING_DESTROY.
> 
> This is problematic because the existing kernel needs to re-initialize the
> ring.  One could argue that the existing kernel should call destroy
> as part of restore() but there is no guarantee that the resume kernel did
> or didn't load the ccp driver.  There is also no callback opportunity for
> the resume kernel to destroy before handing back control to the existing
> kernel.
> 
> Similar problems could potentially exist with the use of kdump and
> crash handling. I actually reproduced this issue like this:
> 
> 1) rmmod ccp
> 2) hibernate the system
> 3) resume the system
> 4) modprobe ccp
> 
> The resume kernel will have loaded ccp but never destroyed and then when
> I try to modprobe it fails.
> 
> Because of these possible cases add a flow that checks the error code from
> the PSP_CMD_TEE_RING_INIT call and tries to call PSP_CMD_TEE_RING_DESTROY
> if it failed.  If this succeeds then call PSP_CMD_TEE_RING_INIT again.
> 
> Fixes: f892a21f51162 ("crypto: ccp - use generic power management")
> Reported-by: Lars Francke <lars.francke@gmail.com>
> Closes: https://lore.kernel.org/platform-driver-x86/CAD-Ua_gfJnQSo8ucS_7ZwzuhoBRJ14zXP7s8b-zX3ZcxcyWePw@mail.gmail.com/
> Tested-by: Yijun Shen <Yijun.Shen@Dell.com>
> Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
> ---
> v4:
>  * Add tag (Yijun)
>  * Move and rename PSP_TEE_STS_RING_BUSY (Ilpo)
> v3:
>  * Add a comment (Tom)
>  * Add a define for busy condition (Shyam)
>  * Rename label (Shyam)
>  * Upgrade message to info (Shyam)
>  * Use a helper that validates result for destroy command (Shyam)
> ---
>  drivers/crypto/ccp/tee-dev.c | 12 ++++++++++++
>  include/linux/psp.h          |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index ef1430f86ad62..ea9b94d5b10ba 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -113,6 +113,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  {
>  	int ring_size = MAX_RING_BUFFER_ENTRIES * sizeof(struct tee_ring_cmd);
>  	struct tee_init_ring_cmd *cmd;
> +	bool retry = false;
>  	unsigned int reg;
>  	int ret;
>  
> @@ -135,6 +136,7 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	/* Send command buffer details to Trusted OS by writing to
>  	 * CPU-PSP message registers
>  	 */
> +retry_init:
>  	ret = psp_mailbox_command(tee->psp, PSP_CMD_TEE_RING_INIT, cmd,
>  				  TEE_DEFAULT_CMD_TIMEOUT, &reg);
>  	if (ret) {
> @@ -145,6 +147,16 @@ static int tee_init_ring(struct psp_tee_device *tee)
>  	}
>  
>  	if (FIELD_GET(PSP_CMDRESP_STS, reg)) {
> +		/*
> +		 * During the hibernate resume sequence driver may have gotten loaded
> +		 * but the ring not properly destroyed. If the ring doesn't work, try
> +		 * to destroy and re-init once.
> +		 */
> +		if (!retry && FIELD_GET(PSP_CMDRESP_STS, reg) == PSP_TEE_STS_RING_BUSY) {
> +			dev_info(tee->dev, "tee: ring init command failed with busy status, retrying\n");
> +			if (tee_send_destroy_cmd(tee))

so it becomes infinite retry? I think we need to set the retry flag to
true to indicate that ring busy.

> +				goto retry_init;
> +		}
>  		dev_err(tee->dev, "tee: ring init command failed (%#010lx)\n",
>  			FIELD_GET(PSP_CMDRESP_STS, reg));
>  		tee_free_ring(tee);
> diff --git a/include/linux/psp.h b/include/linux/psp.h
> index 92e60aeef21e1..b337dcce1e991 100644
> --- a/include/linux/psp.h
> +++ b/include/linux/psp.h
> @@ -18,6 +18,7 @@
>   * and should include an appropriate local definition in their source file.
>   */
>  #define PSP_CMDRESP_STS		GENMASK(15, 0)
> +#define  PSP_TEE_STS_RING_BUSY 0x0000000d  /* Ring already initialized */

additional spaces between the macro names.

Thanks,
Shyam

>  #define PSP_CMDRESP_CMD		GENMASK(23, 16)
>  #define PSP_CMDRESP_RESERVED	GENMASK(29, 24)
>  #define PSP_CMDRESP_RECOVERY	BIT(30)

