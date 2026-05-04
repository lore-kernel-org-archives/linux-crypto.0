Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8121F3A1CF3;
	Mon,  4 May 2026 19:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777924115; cv=fail; b=phFxW2QSmxfPOvEkWIEfJvb7OzOfGp1mP9UlPQci8Dd4qeDLyssvSVW4eKHm5Yn01rNVZrIgrQT8+0SSt3YKiVgYnws/4gHcs6i8O31xLgXrsMXh4QW/MOw2vKNbCcYfhOqmZVhvOhckNfisHTCnL9eUCfeNtbAcuzJqEQU0Ejg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777924115; c=relaxed/simple;
	bh=EpWCz5+6frZCXkuZ564g9zr8GXJ9uXQx9M2qBzi3JfA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cnNDD5uoG1SrL3LtknqY60KSPX6TGhxwGhQcZ0qLAX7vQtQv1j1/2WitJ3EXGcwPJ3aPHYm0MtwZobDTOZzKUYK2Yl5Ntml0I+Lkxqs8Mk91fw3qDPsKTJrhEDwS4/NOEasVN7/zm32vAYI6/m8iIbh7yUewAydF5UDG95QaEGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hwURWLXp; arc=fail smtp.client-ip=40.93.201.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hwURWLXp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUn8xx8sUBYsHSC0JF9Ly9pGP2ksQYtPWIvBfxNxunmVzPKFU3LU8n+K8B/a8HmjuNXR388tGxsafI/0xgVeGjhUzVOrkr2f1WOYA6VXNYuMlVs52kEeqJcIQO9yavm5NMEphlA9Xvszdoo248GUs48mLKt1Bf2CpOcavRtNtGGzOEwL0WzoSHohP4zx/VMlhpixDdKuJ7fknwps80DZ3JaGfoH+OYsA44gbJAZqa4N61ojWUmudfHlIwnUIxvEczjlsfY8W1CKgpstJIxKrgS1dTBxQTOvDPeq0k2Bv3LHxxklc7YcpPXvK+Bc+xZ4d5n0ufXP/smRA6mhMaSpJwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HNh8/AILVrNP8db9oj2Rfj0HRGhuXDdLFAZVQ8drW2M=;
 b=G5LtWXBtTqiG7eyXDtNl8l9dgxHZ3/WXixEkMT2/JY3V4U4Dgsy+i/WGKFn1sfHnE3N6woLzdfwv3CzMufGrhC7p40/BHcuEb62CxcO4uDQhvPZoxQoru8n6hajhKPCknd0b7/zycfNBho+KEWo2gZuDMVhlOR8WWMatyAx7MaOoh9EkUuZWt01GHURB4Wn1cmBYEMsy3sPV3vRgedt8r8f0F7hgOAV9qoyti0hqFyXQ2GFH0vqnl/RZk4Kw+n7QhWpi82Md8arJASR4oSMkoS0YonIsVlgo8+4dOxzYNShWKLM1d6/IHy3+sP0EN/cTDHX++X/pV0GnsWdabA1P0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HNh8/AILVrNP8db9oj2Rfj0HRGhuXDdLFAZVQ8drW2M=;
 b=hwURWLXpS6xrcwGWFKFmQ8cC8mYPQmxQ3cbXaVvg9tiex/5Jd3Or+1KOHKHn1bLQiL2u28qkfRStcfmZooYqQo+QJBbdRPsbb54YrjtkEdRU6QQcLDkMW7cd/WcJPMI6yVKz5UlgVNDeeIUFdUdd9xY+9upk5uypB8sDDvhlWAg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6036.namprd12.prod.outlook.com (2603:10b6:930:2c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 19:48:30 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 19:48:30 +0000
Message-ID: <c2e845e1-fcf8-4cd8-89c1-4f06aad31ba0@amd.com>
Date: Mon, 4 May 2026 14:48:28 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 0/4] Fix some bugs in the CCP driver
To: Tycho Andersen <tycho@kernel.org>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
 Michael Roth <michael.roth@amd.com>, Alexey Kardashevskiy <aik@amd.com>,
 Dan Williams <dan.j.williams@intel.com>
References: <20260408143259.602767-1-tycho@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260408143259.602767-1-tycho@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:806:f2::16) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6036:EE_
X-MS-Office365-Filtering-Correlation-Id: 9684675e-a223-4816-b9a8-08deaa161dfa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	8uJj8Te0ozf1P1gd415LWxWJAF8Me7vanX9cZ7ORkOSrQ/IKQJYZzkX1vHBdBwLRDqovf0uO8yJGHJXx1N9XiR6ZH+NMeKKWUzTT0gvgTm6Ff5biQ6K1aYutV2G3mSNUmMNqJwTgA6t7ibnOcgL8OC8YJK8wbBFvfU1q4TtFgsogZ4djq+dOyVGSA7dCTqkhxC59mxPjwLmoIKcZwzoBhzLJWQHiXpPM+mCZW8hcrsfT93zmqoYIMprULSRLZG1JRhfxR7d9baRmSrqKu5syjoiXzMK3lOOwu9IJPzlKc4beXjsQBk0YGFGF+2cZXkO4GtnIpdRGvb4GYQCv5c2hPLY5CdI3phNjymHp7mfCwpD4pOS33NAvnPrhRRKHGdc6X80hHsLLbJivpr1Ys3U9tK+aDT4GaDagVXOXyWoyA7w36E90aGsVY+N1N1njFXHCSWpx+juBXXK3xLlu6BmjIuaIuLY+sXzRVXrmhYqPXsaTt5m3dTAEvpvsNbXkHQRdCa5Pf47sNCJcAwirMoBqzJlPTxRG+aO4+Q5tNXnogt7/dvE9VGn76ZgpYe8tNwg5T7fUm8QFsW+sVjvOIc6kAI6aHjz4rzQb+pTmEK6dZc1pSHRnf6bsJ4wwMThvsDKpWACVWO4qUBrezybmHK2KqwE9sobppOfeOCfM5N0Jm61RXgzjiNM3fOBe92ttcX0CzearnUrM4SO8ROn8FoZDrw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzJCQmJ3RHVkWXdvYWMwUUtJT1MzMG5CWVpmM0NlV2Q1RW4xdW93ajdtTmJ2?=
 =?utf-8?B?bytjTFZRWTZ1OG16OW5qOW5sc2NxTUhKY0RmQVJxRGlrTS9ZUUl0K21ZRUha?=
 =?utf-8?B?RU9kY0lsaVQwcWQ0dkx2V1lrUjFuNTljcjdaTHEwU2oybFJRMERTSm5EaURs?=
 =?utf-8?B?V1NpSUcrRk1nYWFxajhMb3Urdi9DQTdGRG9yM3ZzRkw3QkFLRExySkZ2VnJ4?=
 =?utf-8?B?ZVM2bzZreTNFV0JvbEgrLy9BZFo0c2JEWjdiS3k5QVM3MC9ySHBhWFFpZWl0?=
 =?utf-8?B?VVJTbGdEdlU1UjdXbW1jcXFtRW5nOE9NSENuMEFNZUJWVTQxOE1VYlkwdUZx?=
 =?utf-8?B?MzZjbXV0eEg4WFNuZldGRGp0cGZWVVIwc0IwN1pkUkdETW5DWDU0U290Sm5P?=
 =?utf-8?B?RWI3UUUzVjlVYlordGpzMU16Nk1KWnV2VDEraDhoaHZEazRNajQvVkcwUm55?=
 =?utf-8?B?TkE5bXBxdVJ4aFRTRVBRMkV1bDlvemV6RlhzNlh0ODEwTndIUVlSV1V1c3RN?=
 =?utf-8?B?TmpBVFVSdFA1eFlyN0dvM1V0TTJSdWJYOXhOTnZ2cGl6QTZmOFVMcmltNjZx?=
 =?utf-8?B?Tjc5YlBZQmZsUGg2QnhSakhuL0pHRzBSTTM3N2NCcmZGUWliSjk5TVcwVC9U?=
 =?utf-8?B?YVpTdDBlTkhRR0gzUlRDVS9mSWdHaW5sU1M5bU9HMUJKQXF6QVZNcmphc3ZQ?=
 =?utf-8?B?TUpONXFhL3A4RmRnTzBOMnptNHdJVEdJeTZVa1U1cnFZcUpienN1WWM3cHJJ?=
 =?utf-8?B?Q0dJaG52ZUhYYmZqTVdzbE41WjZKSCtGUHVFN2RDN1pJV1UxZWFMdW8xa1N5?=
 =?utf-8?B?SjFLQVlteGF2Uy8xQVc1WkxsR2hhVFErTnJHSXJzR1M0K3JwZGVJS1lHMkdr?=
 =?utf-8?B?QUE2ay84ZmlVRFByUXBVUGZOZW4weG5NVGM2OG81WEJ1SjF4bUw0YWplMTB6?=
 =?utf-8?B?WENMenpGQ2FaRVZFQWtQN084SlRyb29iNCs5NXVBNWpYTlFNOXM2U0FVSU1M?=
 =?utf-8?B?Sk1GbnJ1QjZ2Ump3cWRYZitBdnlNV0k3YVZRVDcrWHVOeUpOU0d2WEZXYWpj?=
 =?utf-8?B?RGJiMFRucE5STlowRHVyZ3BIWXZxcDlBTmpFNFVHejJ0dzlCNjMvSklmQnRv?=
 =?utf-8?B?TFY4bWd2R0tNcXE4Z0lvS3ZwZE1jMW1sNlFZTG5QcTVTMHRmT1FxV2dVZWEz?=
 =?utf-8?B?RW1NRFd1UGVwMHVOaE0wbzV0S0ltbHVXQklrYytoR0dhSUh4SmVEbU85TS9h?=
 =?utf-8?B?dllhOTJHazBZMkpaQzhRMGx0RkhRTGtMMnB5ZE56OEphMUVoUGVJeFdORGVu?=
 =?utf-8?B?N2ZOaDQvWEFVY2NhL3J4cnljdHNjNHhBN0krMTBUbEx5bHEvZk1pSmNyOHR6?=
 =?utf-8?B?cXR5OHpxcUdsOFhmaExrVk03QmhqUjhHVVpVRXFqN3RKc0VadHlTdSsyYUc2?=
 =?utf-8?B?UlRhK2ozbU55dHZJOERycTArQ3JqN0FIejdCU0NMVUdkOWVDUGNCTGdWM2s5?=
 =?utf-8?B?WmNmUDFoQXB2NzNSRlVBaVJaR1pJTEwxeVcwYm9hK2pNQ0NnY3ZUV0kxN1gy?=
 =?utf-8?B?dlM4MzgxOFBrYjJrNnhsbzhnVGsrSzZOT2ZkVitMZlIzVXVyUW40OEVNbHQz?=
 =?utf-8?B?OW5YQzlDQWJoSDFmbkt1T0ZURGxZaTJ6TlJLQ0RFb0RwaEJ5TnF5TVFUR2Jv?=
 =?utf-8?B?UjNER08yczVzbnpTczlnOXptTlQvenRJK1A5TW5FTXZ3Syt5QzBHNW9ZbEll?=
 =?utf-8?B?ZjgzSXgraWhGYUVnR0FCS3dPM1JKQmgxeXBPSlVtRUR0WStiekJpTGduOGJM?=
 =?utf-8?B?ekxIVHZxeEJ1eGZ1NnBQREFJU0g2aUZlUHU2MlpYd1l6K2NUQVU3bjBEcE9L?=
 =?utf-8?B?Y3hFNlNWUDMwdTFiL1VaTXJvNitaYnppQzhpdjlnU3grSUFrZytxN1hXUE5B?=
 =?utf-8?B?M1hOWnhLMGRrRGpUdVB3cTd6N3B3WTE0TysvWnFaaVNRSVoxWW1kamk0bEhF?=
 =?utf-8?B?Z3pvdW9GaUlIRHhIckRiMkQxSlZ1ejl4aHhQdFJsNXhxa0ZyOHhUK2dVMjdk?=
 =?utf-8?B?dWxNSFc3L2dFZ1BFQi9GTDRkZDE0RUlFSjNERS9wYk9Nc2l4QnRNWGVxNXdw?=
 =?utf-8?B?QUNLaUxEV1doaEN4OHVicXVncWJ6Ym9GT0h3TW1QbTBOSlRXLzJGVllURG5J?=
 =?utf-8?B?ZzdLTmx2NnlTWFcwOE5wQnVkWTZ4bUtVb01Zemw1c0FPeGtFSDMzcUtoRjNN?=
 =?utf-8?B?SW4yTmZqVSt6Z3hManYzWExOZ3hublVDZ3V2Ynh2SkYwZ3hKZG9kRlplVWcw?=
 =?utf-8?Q?Rpz/8nYa7YpsXatiKM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9684675e-a223-4816-b9a8-08deaa161dfa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 19:48:30.4207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fiPLj+ArFYPmg5kuZwd4euQNNck29e68T0TCVSzqRRREbL9YQmP5igGJbk75nd98EE0ImrmiSUTwXF2Laj1sSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6036

On 4/8/26 09:32, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> This set of fixes came out of using various AI tools on the SNP shutdown
> series:
> https://lore.kernel.org/all/20260326161110.1764303-1-tycho@kernel.org/
> 
> I'm not quite sure how to cite these tools yet, checkpatch complained a
> bit about my citations here. Happy to respin if there's a better way. It
> looks like e.g. Assisted-by in the process of being added:
> https://lore.kernel.org/all/20260302143659.41882-1-thomas.hellstrom@linux.intel.com/
> 
> Thanks,
> 
> Tycho
> 
> Tycho Andersen (AMD) (4):
>   crypto/ccp: Reverse the cleanup order in psp_dev_destroy()
>   crypto/ccp: Fix snp_filter_reserved_mem_regions() off-by-one
>   crypto/ccp: Check for page allocation failure correctly in TIO
>   crypto/ccp: Initialize data during __sev_snp_init_locked()
> 
>  drivers/crypto/ccp/psp-dev.c |  8 ++++----
>  drivers/crypto/ccp/sev-dev.c | 23 +++++++++++++----------
>  2 files changed, 17 insertions(+), 14 deletions(-)

For the series:

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> 
> 
> base-commit: 6c927e5ca9d238f8ae40b453a8382eb9cf4ee855

