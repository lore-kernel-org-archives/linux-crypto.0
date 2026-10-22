Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792703357;
	b=yPMgrB8c/+mEnT8uRLeZEnPK5fZL4B7gJi4vpODnaiit6CjL5o/g7DI1MmOyrWv7r7hM
	 qYs8GWPtnnUa0c5JRPoetJBMg2w4rL9to5JPt/7UFwf8wJWGS+eIypylkcET6Sj/2lFh8
	 6NX51n1b1FCaSzeA7+ywywAaxE8wYoSh4LTi20ySjoJEx7sTyumUCQgocsyjWC0xcWUA0
	 qYiruaT3Rg3JcZjheAZm/JqpbJHekAUuujcdKXRUsw2UHxGe6fypJOxNZhD2bkpjnpr7y
	 Vcqru0J2FUX78o4k9wMt89EkMl0f9kJnJphTPjsNov+l0ZKNp7VoVVcpS/ngIrsFzpA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792703357;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Message-ID:Date:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:Autocrypt:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-ClientProxiedBy:
	 MIME-Version:X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=zqZ0bUgGSjxadqMjgMrYM2ZxEhnzqaSZpELFxvmMXno=;
	b=irwaqCuUQGJeUZLZkOAaVVumLBVEynv9Apje2MGS0P0CdwPI7iZdqvGwp7rw522/1Xun
	 04zU5aZ4HYjOUo2tEqxgeOw/0PHcHk0SOcIJyxfQcc88KtcLJ6MKNJtS8l0+SGdcz0kYV
	 n8es+O+LwaIDJ1wNEXaBxpJko2qmiyGqQsIuLZnJ6JsVN5RzXdz18SjDjorpZuB5TISS7
	 6ut8ol2/zXYNbPrPppAW9ewuosnlAmhrHLBBfdf0QQujU2bn1LOIb45w7BYqFvkCqIbQ8
	 E8+le2eWTwaxt9VCg8H/mFueWCzr/XQUqFHCoI4aJ3Y82gnkrd47XXhOH56A1jyOhKQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=amd.com;
	spf=fail smtp.mailfrom=amd.com;
	dkim=pass header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b="Hzu/PFBi";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.56.17
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010017.outbound.protection.outlook.com [52.101.56.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03144606A319
	for <linux-crypto@vger.kernel.org>; Thu, 22 Oct 2026 21:09:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03144606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=amd.com header.i=@amd.com header.a=rsa-sha256 header.s=selector1 header.b=Hzu/PFBi
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gfbtxgsvziFEelqqKVT/Z1JZWCWeFX4wP5HRAvCIkNtZ6eYZ1pjjsoRmlMA6I3MQZ1waNr4uOcEVSPgFeOQ7QxplEUd7NEfw9RtLnlN98xIR/vJFD86Lka2eMrMqt/W/wnbI3scj3GOC1PejPIYuVx/+EoE6It5MGqA329WJ4Qw9A624SiBCNKB02BaX74p8yqor6XyGFw4jGU1MinkzWGzjM/udS9d0miFGPunnls1THEnc3/PAqOn5cR7E/jfioNOsQO22oac2OIXJhc+SHwaFaR6ucFak/VsblhuU2i6dmkNf+zMDiLmIEBd0KGYD547wNW+Zof0f6GH52uwZ/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zqZ0bUgGSjxadqMjgMrYM2ZxEhnzqaSZpELFxvmMXno=;
 b=G8tad7WTzST3MjziV0NL1Dhkf+h9n0ee/D5iNpSW9NcMpwvnWnN+JQRoGkiRO/c2/aM1f+9dDsixwqCNhvVPrK+e7IgHGoZHbCEdFqsMPNEhRndDvtgl4ixUeRI/7MUzj6ZUn0ukAMJErfgflRulUYuCyB20/O9MsBd3z0zNkBzFiW2xPr6Ch5Mq+vlk8MJp5bxicpu+zQCiBjIvyGM33Cvs76lEI84vg5ObdelYEV8weDNXRL2nErrYBGofnVbyKzcb2scnlD/FdyCH/3mGf7WE7KvTQnksj/GZeWR8xQX81jpE7Bl0NtFJLS35cjEyy+F7CqfXxrmAko7CErtQyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zqZ0bUgGSjxadqMjgMrYM2ZxEhnzqaSZpELFxvmMXno=;
 b=Hzu/PFBirBxs2W/Ql3/S4TdXIyl0wPfALypkqFl3epOXP0cXINafCdjxWlPdSR7sOdx7QCqz3NPpEHN4TgU4E791eFVvDem3pH1h0uh29GQWUfzsR1EiyPzoTi9/zf0QedKTWN+ec9P/Wm4nTAkgWmAjfgDyj41bqBRpVjdQSSQ=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by BN7PPFCEE68E7BF.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6e2) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 21:09:12 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%6]) with mapi id 15.21.0546.012; Thu, 22 Oct 2026
 21:09:12 +0000
Message-ID: <036689a5-08be-447a-a387-d7c496205872@amd.com>
Date: Thu, 22 Oct 2026 16:09:09 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] crypto: ccp - Make usage of sev_cmd_mutex more
 granular
To: Michael Roth <michael.roth@amd.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, ackerleytng@google.com,
 ashish.kalra@amd.com, aik@amd.com, seanjc@google.com, pbonzini@redhat.com
References: <20261021192434.1924950-1-michael.roth@amd.com>
 <20261021192434.1924950-2-michael.roth@amd.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20261021192434.1924950-2-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:610:b2::23) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|BN7PPFCEE68E7BF:EE_
X-MS-Office365-Filtering-Correlation-Id: d78e92bb-97b2-4b07-0c13-08df3080b877
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|22082099003|10067099003|18002099003|261021121427099003|261021123027099003|11063799006|4143699003|261009223027099003|56012099006|261022105027099003|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	OIS8Loq4cNq9bMu4yGkLlzmOJ27/SVSbI19WBNhCroGOiCuftzSW/c7RWa1wbhQsG7RJGfijkaRl47+KlESi+0J1W/QxoXaRoYkGih6Ade1w7V9pVdKBCe8dnMBmKnw15pRjjCMI6n0bqaqDABKdjt30aZn3ZChmwMNfzJa3gGofqbQXd9VNfWlfq0bvfWnZoBOpIBTtn0bbCxqMZCsDEkNbMVOgmWmefAJ70iBZ3Fx0S8z/4NKSEsHmWH894azPtFWqSBpu10DoT0twjRk8Xga1AiuVK9pK89u5sm6p8T+Ejf2HKRP1Qk2xKWh6LrZ50Bp6PsdrOwI1nERFO5UfhYYXmlItFrwNbP1c7cg8Bg5aGtgdP+Ali/eGDdP1V8V9mehPSXcMs78cAR7aUHciWul9QBV54UhjkPOg5KCGjHd2ia+QAd92UVH1PEkCjWxLYQMLSrLg9upDwCUp5nSV4S+ygTiSXCBwWz+xT33sAMa1+DpZ3MXIerqyLHKRCl8HnAqHzUizM8hwY2K66fEGsR7tatct/3zNkYE5LERId8wBt2XcNflUZYIuVVzJm8hF8wetUymyXSp9RBOMW0k6HPO+z19zm9FsfirqJ5hpLRKZFC9R8ynz5yzWDBMeI7iZiFW50ABtZFoq2SM1LkRWf/IFpad9J9vI+tQKMKXUDMQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(22082099003)(10067099003)(18002099003)(261021121427099003)(261021123027099003)(11063799006)(4143699003)(261009223027099003)(56012099006)(261022105027099003)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFRaSTZLZUdvekFqSHJTTG5uTE5MQVNhN2g3eXpZWU5TUldFUmxvTFJCM1J6?=
 =?utf-8?B?YWRKdHVhekZ2ZnMwc3FOT2pWaE5Tc3hsMVRlcklySllzYWp0ME1LVmtqRWhI?=
 =?utf-8?B?SEdFWWlTZ0RZRHhvYk5LWGtaUkhJaVdPaVhXcDZFZVhvbWJURmNxRjg2SENs?=
 =?utf-8?B?TDJhOWE5czBqSWR0cTA1NjBSVXVoVC9JdThOWlA5V3RWbVF3KzVHbkdWUGlB?=
 =?utf-8?B?a3E4MEFvVzhSWThSRW9scG1xNnQ5MHJzMHlUK0lPUmFKVTVXbm5YSDNhamoz?=
 =?utf-8?B?M0laVjRWUEFxMWJYZjNRd0NRQllXVnNnWnZBTTd5b0E2dDVYTWxiUjI5ajRT?=
 =?utf-8?B?Q2F2WFpRK2p1WXhVakUzdmJNTE1ib0lXc1k2dFNHN0NYSzR6YmRMdHhYZUtC?=
 =?utf-8?B?MXpPY3o3TEdhcXRsdlM0Yi9kVU50TVltODErT3MxbnBDQXJwWFhKdDJSM2tq?=
 =?utf-8?B?blBSRG14eC91MnhsMmZ2VVFIV0xpcU5Da2JyUy9LaDVqeDk5R056a3JvL2Nu?=
 =?utf-8?B?eitaQW5XOEdVK25yeFNPVFROYjd4NDRQNkhBK3ZJTUdoL08vRWVzRFUyWlBp?=
 =?utf-8?B?aWU4c2FicGlKV2NOaUd3aExUQnY3UmNVWHh6bTMzd3IxdWhFSkMxNWN3ZUZl?=
 =?utf-8?B?eStlS3ZhdWUrSFZOZWdWTDlyZ1MvbjNGUGkwbzRKemZxc3VZUnBxUFhSUFdF?=
 =?utf-8?B?SW5oYzJvU3U1RVdOZGFMK1dsUHBoeEUyV2JUKzRVdjE4WDdWZWdaNk5QVTR5?=
 =?utf-8?B?L1ZsTlIrS0t3c3Brc28rMkloNEFEbm45ZXBvOVpTais3Y082c2pBdUlUaDFZ?=
 =?utf-8?B?NWxqbXJxcmZGT2hqY1Mya1llOWNJb1hyQlhlck9FSy9QS1NqdnRMajdYTmtS?=
 =?utf-8?B?S3pEYklOUzV0S0d6TWRod2xXYXhSWnVINnJXU0hyVG1DYVdYeHA1SUxXanlV?=
 =?utf-8?B?OU9rNXNUa2tBTEMyTXd3ZDNGY2d1cG9WVStka1B5NUMyZnpaR05OOHZQYXRV?=
 =?utf-8?B?dXl2aWhFcm01SnVwWFZQMklGK2FXR0RhZ28vVEg3WXF6RWlrR3RsUmIwWUlQ?=
 =?utf-8?B?QktCSWJ5UVFYNzNSSG5SVDM3N2FTelExUnVzYTJhYjhGZmlzSWFPT3JaVFJ4?=
 =?utf-8?B?dGFCYTJRRVhySG9FUU1xaWZLYVF0OEVnRVFHR3BaaVQ5QUtTMTl4V3MvL0Jz?=
 =?utf-8?B?WFN4OGRzL2tpdDNRQVdWZVErZ0RoTm5HbFgzZWZ4TjdRV2pxNmluMEhDakdQ?=
 =?utf-8?B?VUFYVXVWdUtnVzN5Ym5QV3ZmNHdFRUlqeHZhVkFTMmVYaFJiSnlxcWdEeUpJ?=
 =?utf-8?B?M0tHUDYvR2wvZGpXd2dCcFQ3eWFmaEFuM29tN2JWMmQvRy80REdEMjJNbHp5?=
 =?utf-8?B?a2JJZU1WcllPOVVYTGp1SW5lUEN5U3RXWk5UcXhrNmNCQy93alpHQkttdTAr?=
 =?utf-8?B?TEYwL1VBQmtGRWdBMnF0bERsZHZjZy8zSmRqMkVKZGUrNTdwZkhqd3g2V2Z6?=
 =?utf-8?B?cVRMTHNqLzBKbTJoZkVKaUNUZVZHckVDS3grWGdiZmZETERKd2lLZmdhQUtr?=
 =?utf-8?B?Z1lqZm9semVWWXE2VDIraXZuRnErSUo0V0FJOGxicXZQcmY4WVcxRnZEYlZJ?=
 =?utf-8?B?VENQQjlPSTNiNWpZUk1LMlZUcTV3cWxEbTN2Ulc5bDVldVBtbktwTUY5NU9x?=
 =?utf-8?B?bE5PdWlycFlJZGkwNi9RaGRHZjh1M2RLVkFIOXM1WDl1N0I0S0l2Y2QzUThH?=
 =?utf-8?B?QjFicGFMWkdrNm9FRDF0WGQvbTF2V1pveHZYcWJKV29EOE0vOUxaQ1BvN3dm?=
 =?utf-8?B?ZVNJZkVIWnRHaDZpVGNpTWZGYXgxMFVnWGdvdkk1OWV2eEdKMGMwZTJBRTly?=
 =?utf-8?B?Y05xSUJQc2tXUEtUUDhQZUNKN1NkRndELzd6d2taazVBM3k2Q05kTjZUODF0?=
 =?utf-8?B?c1ZyTnNxcENrUDlhZ2dCcFJzWVhSTmhlN3B5RFJIWTFpYTZFU0VXT3lXN2sr?=
 =?utf-8?B?MTRpaC9uUEJLRERCZkVyNEFRRGxKYzdHNjFITkc0RWJsODJRUDZmRmVxeDF1?=
 =?utf-8?B?M0pZaHpwa2lwdkNjcHFYMWplQlMzeXI2aFdCbFNIclM3SUZ4eE1FNENuV3Zo?=
 =?utf-8?B?d01BUjY2K1c0b29UTFROajNKa0RQUWRKRnUvVzhnL0dQeVhwa2Fxa1NTK3FV?=
 =?utf-8?B?cW1KQkJHM2JneVcrMGtIQWZEQkxzSy9vWEdZZi9ZMTMvbjZKUWp2L29odWV6?=
 =?utf-8?B?QzlQYmptRGU0Sks1bFhxREVyVG1mNFk2Ti80dUJBUzByWTlKSHlIdUFBQ3Fm?=
 =?utf-8?Q?VW+YrQhDPlwROcIpWp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d78e92bb-97b2-4b07-0c13-08df3080b877
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 21:09:11.9735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UvYt5hTMMopSNfZ0WwfkzRNXE7yuj1SoTSfXyGvVLLC2kWaKNt99/e0an5abC8pR1snOfyXVP5+BCSbQxTl7Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPFCEE68E7BF

On 10/21/26 14:15, Michael Roth wrote:
> The current code makes very coarse usage of the sev_cmd_mutex; for SEV
> firmware ioctls, it is essentially taken upon entry, and ends up
> wrapping a lot of potentially time-consuming prep work that may need to
> be done before issuing the actual firmware call, which is the main thing
> the mutex is meant to protect.
> 
> Additionally, some of that prep work involves
> copy_from_user()/copy_to_user() calls which can generate page faults and
> unecessarily lead to potential deadlock scenarios. No known case exists
> in current upstream, but with the upcoming KVM/guest_memfd support for
> in-place conversion of the same PFN between shared/private state, a
> special fault handler is needed that could theoretically deadlock if a
> malicious user tries to use guest_memfd pages as the source/target of
> previously mentioned copy_from_user()/copy_to_user() scenarios.
> 
> There's no reason to hold the mutex across these problematic scenarios
> however. Push sev_cmd_mutex down from the top-level sev_ioctl() into
> each individual command handler, acquiring the mutex mainly around the
> platform state transitions and firmware command execution.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sev-dev.c | 101 ++++++++++++++++++++++++++---------
>  1 file changed, 76 insertions(+), 25 deletions(-)
> 
