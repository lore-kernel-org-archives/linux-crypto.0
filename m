Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE58A13FD99;
	Tue, 12 Nov 2024 21:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731445733; cv=fail; b=qxdPmPZaVFQjiisCvwiaxiUP2PhhiBAlyvFmDgGTrjpX7/6jxF9rli8J6txBlEyrHXEa2kbeFQmW+Po6tspOZavyJ7T+LVpSwL3g80cLq7cWpxW1SxQh+4Nt5xPtPKoJQ2+w+ekTnZ0dtEx0OdeGDsocYWDEto7lGHVD8FA1Vms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731445733; c=relaxed/simple;
	bh=/vLLQHzDRA5DSnUp97fpDm8BEbmZgz2uRSwlJPir8TE=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=a5QmY0caddco7vyJRLs71gn0McgfscUjWOCfxhUjRUH7Ey1dHMK3mxsPWcocLXhrysgxjlIMnER+p0mUWAcCADCHL43ooFuw4gvMkKLnB+7i1yM/RaCTo7XLsBpuZi7KESajx9/Sd8WIN1CcyDdpRF+YZsIszX4tvpFPiXs9FEA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZNeNq5So; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZNeNq5So"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HoHbxN7wdh+9g44AXUVdE7Okr46U+v19nB9QTrD242AgZcwr/2B2on2a6b05jystAqMANzDey/4tJBj3XwhvCgQugwCtxtbHzWHymlzCQ1NY67L/a4QkMTlvyrjUNEm7Mip16GOUFgeqnMxHd194s2rN+Lrp/YKMancZHgEal5Gq1R9oJiR5iEZ8impj2AkTpCo7evg0ZFNQXUD7K+Ap1ZlM4bFErAzoe1JEFAohVgJixPO/lA1FXzywosJ0MBErbVhNQVfuR6yrQimjmC9lIhl7c3aeQMYZt5NrKG40P72pQCiQ8J19SUfIUN0A0qfQEsTe3Hus0ftR9coCscKfrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bSxxyCuvmMjzY8t2lpi9sAbTuI3kY4uaa7G7fjMeNZs=;
 b=BLY4chmZmAttSkNHDAuaEKSUqBHONgURKAGBc0iPpGByfPAef3UVVxEUNu+XbEl4PTmpTl0NjqQIHvOa/Z/l/BwAJsXWvHiPsY3/Yx/rNN9Bhul9+SRkGoXyK7FVNfnHDY/o9AsMNwTuukeeu7utmg6PcY+gLNzyCDH7hs8oRCZJH4Yb1pP5kmUXXKBd904rMmQyWEFseS3gI4qnhKNwCRPUQd3yhTtBOYzD8/Jnv5EiJ9hdqU20Xmnp81jcaLdLgKqllTOHJSiq3fQUz9XggLnYrjtHdGSBE2MFiqJJnX+Bl70FQnUzsi3vEEuqgIRJt1DxR2OpwoxZwaOAv+2dbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSxxyCuvmMjzY8t2lpi9sAbTuI3kY4uaa7G7fjMeNZs=;
 b=ZNeNq5SoMddclojrcIgzIb5X4702KvDJXUUQ+MgtyIFC+bIQNm8IlMFikp28v/a2r6+DuHrG3AJ4vj+YsGYrRGrb92J0tB6IU9z2Z0YvMwahTn9xOhgDfZfNc6s7a2AN/ciM2swDN0Z3oPZXHBUMkgkdSD8ywTh9137/kTQaOQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ0PR12MB6712.namprd12.prod.outlook.com (2603:10b6:a03:44e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.27; Tue, 12 Nov
 2024 21:08:48 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 21:08:47 +0000
Message-ID: <5212b2a8-a20a-3702-de07-7c3e3b7e8dcc@amd.com>
Date: Tue, 12 Nov 2024 15:08:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
 Ashish Kalra <ashish.kalra@amd.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-coco@lists.linux.dev,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Michael Roth <michael.roth@amd.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Russ Weight <russ.weight@linux.dev>, Danilo Krummrich <dakr@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Tianfei zhang <tianfei.zhang@intel.com>, Alexey Kardashevskiy <aik@amd.com>,
 linux-crypto@vger.kernel.org
References: <20241107232457.4059785-1-dionnaglaze@google.com>
 <20241107232457.4059785-8-dionnaglaze@google.com>
 <4ec6b73f-4707-c93a-f046-213ac4d4549d@amd.com>
 <CAAH4kHaAqh1R6CGBKXNsO+uQnscwGo0Y06MTny8CebSWK9QMaw@mail.gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 07/10] crypto: ccp: Add preferred access checking
 method
In-Reply-To: <CAAH4kHaAqh1R6CGBKXNsO+uQnscwGo0Y06MTny8CebSWK9QMaw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR12CA0009.namprd12.prod.outlook.com
 (2603:10b6:806:6f::14) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ0PR12MB6712:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b7971ab-5a39-48df-0e08-08dd035e32be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RUdOUFZveUFHNEpid1BoZ2NvNXJXbVB0ZkErbWdTUUhDTnhiU1dVS2lHMWE0?=
 =?utf-8?B?a2dZTEsySXpFTW0wOWZvZ0NkNExPamRiRVdXMDdIUGJ1cUxwN1U4S0d4b0ZN?=
 =?utf-8?B?QWZPVWdud0ZTRjlEdXR1R1dVQjRqMWxPZG1rVXJ3NXUyQkpJVkFiWFhjd0tm?=
 =?utf-8?B?MDM4SEZFandyY0ZyUkpEWkYxT21VVjZBSmRuY0N2YzZoRUtvRmwrYWZPODBN?=
 =?utf-8?B?ak02QjYzVk85ZDRIM25GbUI2TythM0I1dHYyM0hVa3ZFVHZzVDd6NTlOblBO?=
 =?utf-8?B?TjNxVTh0VFFEbGJSUXBsa0lEUzczZHZudEJtcXdObDJLVzFNSkFaU3RCdTRV?=
 =?utf-8?B?dnVkVDVCcEtLVTV1YUM1KzkzN2d3NmhVNk1vbGdMeXdkejZGUm9vTEhxb3BW?=
 =?utf-8?B?cEMvaWw0aVJyN0JsVXRrcFlEenRWSXRrZHBDamdBRXpxUVRSb0U5ZW5Uamlm?=
 =?utf-8?B?SlpVcU5EYjRoa2tTZFlpREprM3hxUU9XYUxYZGgzaWt3OEE3Tzk5TkcrbFVp?=
 =?utf-8?B?cUs4eDUwQ05ZeW9pQzBkczNhU3pYVjRCd2E3VnB4VDl4c1UyTVZEc2djNi9S?=
 =?utf-8?B?WDFxSFdKSiszaTdGSDVoazBjNlJxQzNHNGtuemF0Ti94WHdKSTZweXVUV2pi?=
 =?utf-8?B?QW5MVmhhNWhpTnpoRDZtTzNpS0l3UHpQKzZHbVpibmhkVGt0Ym9NMCtFUVJX?=
 =?utf-8?B?NWNOMkJqRWROQW9jNU5rZUxkeFdkdWhyNFh2UUZpTGRvK2ppY2RONWMzL2Q5?=
 =?utf-8?B?SVY3QU9rL28yZkdzcGVRSlFVSi92dUVtOEhlMUxEYmlCZFIyUXVhYTl4YW9r?=
 =?utf-8?B?SXRRNDZJcXNhaXJCcnBNMTBWT0x4cVNZY2RJOWxEdGhCcDJudHljektNZmx4?=
 =?utf-8?B?OHV2a2ZLYTBRYnpyT09MelVicFh2NnZKRXdLTjJjbFRFTWZkY0JBTWx0VGZW?=
 =?utf-8?B?OVIwTC9Sd1ozZUZJM3Z3MmZFRlNlcXdubTNkWjUwejZWMGRwU3ZjOFZpSGVZ?=
 =?utf-8?B?MHBqa2pRMThsaHNKSjQ1UHEzb09laUxPeFg4TEpJd3F5MllVZ0V3NzJhVmJP?=
 =?utf-8?B?M0VLbGpqb1JMYWNGOFk3UjZhcjNoZFRNVm1rSlhNU3lNM0loRkdrVjhpYkNx?=
 =?utf-8?B?d29IOEw0UkxKUlp5V0tObjdrdkM3TU56RTV2UGVxSlVBWTcwSGdDMWtjdk14?=
 =?utf-8?B?VCtBQjViRWZBby9aMnZBVmV0U1BOd0JJS3NvL1JZMElKVU9FVDg4QldaeXpv?=
 =?utf-8?B?d21OOEQ5MEhpKzRJSzRZVEtGTHd0QjZLRlh0dUdkRzBqZ3NIMUFqL25WWGlW?=
 =?utf-8?B?T2h3ajdwRjRNVDkwVG45YVA4djRVQ21ZYmwrZlJ3b0pDWDBDZmdvZ3FrVFFE?=
 =?utf-8?B?KzJvMjIwWkMrOGtKcHJ5M1U2VWthNktLWWJKQkZpQThGK3Zud2ZFVmFxMStv?=
 =?utf-8?B?VVBZSGFGemZjMjgxNXFQcnlhWDRyMnAwV3B0bGZ5VEpweEpQN0pGbXY2bStp?=
 =?utf-8?B?UkYvK1A2am5aMmFtaUt0dTBFcUNzOCtHU29uUVJ3bkN5cnZOTFlCYzN6aFM0?=
 =?utf-8?B?dGRtdy9BeVRrRXpYWEdDL1o0L21ubHkwRmQ2aWVGNkx3bmJXU1N4K1QraE1n?=
 =?utf-8?B?Nk1wQnlUc0FEN3pjSUJ6Nm85dHkyRnJYQWhZRTVNSmVIYkVrMGhBZXYyMUxH?=
 =?utf-8?B?NFZzU0lRMWdwWFV1eko5elFJU2VaSktSajlYekNFWVhVM0JrT3lGQnhRN0NN?=
 =?utf-8?Q?Wa3MD+flumdGaZyFwCQGHXAyAgP5JY7lQw4WiA1?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WXAwTGhVUS96VlBKb2Nxall5a1NmVjdDYjE5bDlMQ0FIUzM3Ymo2MVFWR09S?=
 =?utf-8?B?NkpBcEIyNFdOS2Y3YjNsRmJPU3RoS2tuN01rMmVoUnJpWjBJa0pqNjhKVXdq?=
 =?utf-8?B?eVRvVXZQM05vTWM4bS9DZkJHaExRRmlOeGNmQ3NSMzZYOXQvamNDMXhML2Vp?=
 =?utf-8?B?Ky9RakljQW85ZlBxbWdhc3JjTWZ2aG4vdmZEcitoVlZmYnNZOEwzWmFVaUtI?=
 =?utf-8?B?U09aZzQ3RW1pZGJTNEcyeVNNeVZhUWg5bUJBRThqZk11Mjd1bXBoRmdWV0NF?=
 =?utf-8?B?aWtzWHpNOEYwaVJ6R2tOcjBkRzFhMVpZTXNqaFhCT09LQTR4Y09xSTd3dVAx?=
 =?utf-8?B?a0lqZXNDU3ZGRHRCRTFUek5KQTZ3ZzE1dWJuWjVib052T1RvcVhmdlhlclNK?=
 =?utf-8?B?ME4yWFNZSlNvcThaUDRrQklEOFhQcThwVjJTRWVnUTZlT3pJNVJFcTRzTUh6?=
 =?utf-8?B?NFhFeW1TWVJpNmt4TVhkZ2RzcTVGVUIwZWhqVFR0TWpxMnM1RmtWYkNXUnNx?=
 =?utf-8?B?MjltdlNJNVZLUjIyZUNrZTl6QkRFdFZLNW1EK0hRc3I5Qjg4VXhXazRTV3NF?=
 =?utf-8?B?dFNRUEl6THhsbExSVTRsbFJRaDdrdWptOExTMG8wUUZWWURLMDJuVk5CaWlC?=
 =?utf-8?B?SzVrcHNFV2l0Qk1XWDJqOVYrRkhqMnQzRWcwWFBZcWlGNi84NmVGcG95NzNv?=
 =?utf-8?B?dDVuZFZSa3dUVlZHNFdCaSt6ZVYzNEIrOU42cDFyOC9aTVJuZHN3SVR3UDBP?=
 =?utf-8?B?VHBDd3pRSXBTSkRrcitnb0JsYklyanBjajRieUg4TmoxMTBZdGlaM2NPWWFZ?=
 =?utf-8?B?V1ZHVVZTZFR4c2Y0dHpIc1R1OC9PR1hiWTdXOUIzRjNyU2NDZGZjSDNodzRu?=
 =?utf-8?B?UGVGRzJ6eThzQWRuQ1JXcnh4SEo4cXFudlhTT2VJcWVkRXJTVk9wVWFIVUg3?=
 =?utf-8?B?SVpEdTRBc2tDbk1yZ2RxdUZpeEhROHkvQmpVOFU0TVRBN0pXM0NNT3BJR3ZJ?=
 =?utf-8?B?RFZYYW82bHhWcmY4SUxGSXNKNWR1dkkzVi82cVRZOEdTZWRyZzZybzNZMHYx?=
 =?utf-8?B?TmxJTE90cG43bFI3ZUlDaEtMbkJCdklUekprbDJiUlhPbTBkWkRYVFBKemlS?=
 =?utf-8?B?ejRUZUFmaVVPTDZGMXhNWms2RGRPVndtY2lDTXI2VXpJYmEybCtVa3NuSHc5?=
 =?utf-8?B?REZOeXowVkJ3S2dYOUMrVWttaFFMb0RFNDBsRlZrWC9CQ2NQNEFUTm5kTGxr?=
 =?utf-8?B?bnY4cDNHeTNIVTg3M1F5OUpwNWlCWWNLa3VhcDdYMWN2YzhNbGVqY1JDVlNw?=
 =?utf-8?B?RUhMcS9ST0I5UC9EYzdtbWRLOWduVmROWjkvMG12RGJBbytyaXFxclpEdUhh?=
 =?utf-8?B?SE9mZFRxaTc5cHNTbWtZeE5pZG1wVTJYZ2VVVWdUVFpUOWt5bmpVV2NqWHFF?=
 =?utf-8?B?ZG40SWV5MjdpNzV1S0x4dnJRZ3Vvd2M2TjZXc0tjVGxoSWVIUHU5dFlVakZK?=
 =?utf-8?B?bER1T1ZvQkNBNTdZdVRGQXdVbWh5UkZ4c0xVOFRRNFlLZzJhclpTTGczd0U3?=
 =?utf-8?B?aGJ5WFJlWUtTM2djRFBKOTZaa0ZEaGZsQVgxalZpWXJXZklXRTJtUWQ4WjIw?=
 =?utf-8?B?OTJvRmd6V0tSMndORHUxYzBtR0dNV2RYeThLTmREYndSSWRrTHB5aTh0R0xG?=
 =?utf-8?B?OTlHRGRIYnI5a1UwTjJiZjM3aGt2MHFwWHE3YmpidkY3VFk5NTBRV0pwN3RQ?=
 =?utf-8?B?b3V2L3NkV1o4TndyTkN4SWttL01BSU13Tm8weU5tdk1xaWYrM0FrclpvbnF3?=
 =?utf-8?B?bDJxajFSdVBDa1ZaYWd4TlRjWUpDcW1rWnBzNnloM2R6RWtzZVZRSm1ic0tO?=
 =?utf-8?B?cnpkbHRGK0FYNnVONUcxSzI3ZjI2K0FVUEhFLzNGa1llcVVKWTI2N3VZYjlV?=
 =?utf-8?B?S3lZZ3JQT040UVBiNlZUZU5tMXZ2NXFyYTdxNloxdU9qRk1aWGtRdVlpVlN6?=
 =?utf-8?B?azVGTmRYdUtpVitrdTlVQjdRYjlIOXd3d2tLQjZ1RkN3Smc4T1N5T2JlM3NN?=
 =?utf-8?B?UjBvOHJnUnE5TXFhMzhLakJSNW5tTUJUQlMxV1pWY0o2M3BSWVZ1amJMVkRC?=
 =?utf-8?Q?/G+e3FUKQi5sWZnjUq3Nh2NtL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7971ab-5a39-48df-0e08-08dd035e32be
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 21:08:47.1893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mfe8jqXvwPWICnBN1QcDZc8ZatrAno7zzTAvyROp7qJOFw1cPThZwzvv2CbCc2KmrTCcyLc/E8PuJ9rBJycXug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6712

On 11/12/24 13:47, Dionna Amalie Glaze wrote:
> On Mon, Nov 11, 2024 at 2:46 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>
>> On 11/7/24 17:24, Dionna Glaze wrote:
>>> sev_issue_cmd_external_user is the only function that checks permissions
>>> before performing its task. With the new GCTX API, it's important to
>>> establish permission once and have that determination dominate later API
>>> uses. This is implicitly how ccp has been used by dominating uses of
>>> sev_do_cmd by a successful sev_issue_cmd_external_user call.
>>>
>>> Consider sev_issue_cmd_external_user deprecated by
>>> checking if a held file descriptor passes file_is_sev, similar to the
>>> file_is_kvm function.
>>>
>>> This also fixes the header comment that the bad file error code is
>>> -%EINVAL when in fact it is -%EBADF.
>>
>> Same comment as before. This commit merely creates a helper function, so
>> this commit message is not appropriate.
>>
> 
> Is this a meta-comment about how the commit presupposes being in a
> series with a goal, but should have a self-contained commit message? I
> don't know what "same comment as before" you're referring to.

I made the same comment in your previous series.

> How about this:
> 
> crypto: ccp: Add file_is_sev to identify access
> 
> Access to the ccp driver only needs to be determined once, so

once per KVM ioctl invocation

> sev_issue_cmd_external_user called in a loop (e.g. for
> SNP_LAUNCH_UPDATE) does more than it needs to.
> 
> The file_is_sev function allows the caller to determine access before using
> sev_do_cmd or other API methods multiple times without extra access
> checking.
> 
> This also fixes the header comment that the bad file error code is
> -%EINVAL when in fact it is -%EBADF.

Yes, I like this better.

Thanks,
Tom

> 
> 
> 
> 
