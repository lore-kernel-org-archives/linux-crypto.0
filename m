Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010014.outbound.protection.outlook.com [52.101.193.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8326857F73E;
	Wed,  9 Sep 2026 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788965875; cv=fail; b=Xi1OyCDq4wCWTF9z6bARgqt3f7qXE0ARJ9OBpr56kDzVxqHnM86gSd08s43+e2QvvvHYAAOVE/2vS/7acZA3+B11n/bauXMAd9S9Bq4KzbEoyQCPq3F05X8RbWDzHSfamG+2B0DlTDrwXsoSYDAGVPLLLzhZK9xfvXWUbvrvNY4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788965875; c=relaxed/simple;
	bh=GxnUgJ+uw4BYBTPHtYIC/yRW+UFaOD0b4aWQoEmijAU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hnAmEVG4dzOy/R4RcoDIuWjFquzY2whwkVenGbQfBeCCl8z1RpBvdkwdAkKvsT+9GbpHw+nvsgY1IlF2dvzVL+VWUqnWD3WexproANHGAK8rtCEGuouzJ/X2jjunF5Kj/O1EX2L9RxntmE7X6CsN+rF6KEOpW/xMIePV+C3kPBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N2aFKO+v; arc=fail smtp.client-ip=52.101.193.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N2aFKO+v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ohdKp+lJ0SEFBToqrTG8t6jKpBhL8gl6IvPcrI8Zi/QCvRCoYGhdOnVsxU+BRyqYaPHp2opnqcLVIi2NYsZrDlEpilOv0PQ2LVhebyXBy6sIxZcViya195rbOlKj2LgXnKwCl7r8noeeh9wPGlkpSCuXC3r4JXwAqHuhLTl0HWYZybmkrEcyUaczNnQe+n8+NAkgSLhsvfgxXgiRzVS5kB5sHPdvlUcVkVVLkpN7FlCiag+pgG//cEDyDeu4mKthB/Abx0us5VAbtRNJKOsq5dpKpxTShfQvvx5waRLyui9inW4N0UBsNJpuBcq/4+cTUmTJHDZp7yQhgmbUYi8LXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X4ZcNlBxOgc2fxKLuAfFJ6YmxKy6r2ecJG803v4UgOU=;
 b=k+LG8r3Phh51l0ZjjmGC9OUoksTt+XdCaDtydC8nnMXFVcHk0jlFM4w+L8MBa+b8y8U+ZK9yxPUMWzVvhqJTNONq0rHkfr5UiewjFo0dPCJZHrAH91w2a1l1iVd5Rub9UD3GfFqKw1Z+iuzyhYOrzin90Hpao/HPxMEbIc26KPAF1eZ8hY1CD/HDpJTy07iZmnsEA0F44mc+coGOH3CObiWE84oarl7CKbcyag+ICwDK/dePv/KArXPicPPyUq3wCT9mE5pN4/g8sDt46jGb8PX9fZzggfbpKIVOs8lvkHaizVtuOJ0JMRRbfbi/0RDepZFTjfEmibaLOZwbjVGNjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4ZcNlBxOgc2fxKLuAfFJ6YmxKy6r2ecJG803v4UgOU=;
 b=N2aFKO+vBVgTSsZvomrx20yv1dQBJ0KfCX636nZRkRc+zI1AIZp/wKHmpi04IKwCxtcIhu11rSFONjirSlLIs5vSSQgxHMokjbZq9VWf/6QkKunbhUzGXFhEgLpFMZpYfssh6heRDtCgdhU4NW8Q1JzUGjl35pdMpz+2dnl8ENc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SJ2PR12MB8136.namprd12.prod.outlook.com (2603:10b6:a03:4f8::6)
 by DS7PR12MB5910.namprd12.prod.outlook.com (2603:10b6:8:7b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.406.7; Wed, 9 Sep 2026 14:57:45 +0000
Received: from SJ2PR12MB8136.namprd12.prod.outlook.com
 ([fe80::e5a6:6049:4f4c:afe2]) by SJ2PR12MB8136.namprd12.prod.outlook.com
 ([fe80::e5a6:6049:4f4c:afe2%6]) with mapi id 15.21.0406.007; Wed, 9 Sep 2026
 14:57:45 +0000
Message-ID: <108bb0a4-d6a0-4a6a-8fae-33d3d9484b57@amd.com>
Date: Wed, 9 Sep 2026 09:57:43 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: psp-sev.h: clean up kernel-doc warnings
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: Ashish Kalra <ashish.kalra@amd.com>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
References: <20260901001438.3917854-1-rdunlap@infradead.org>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260901001438.3917854-1-rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0054.namprd03.prod.outlook.com
 (2603:10b6:610:b3::29) To SJ2PR12MB8136.namprd12.prod.outlook.com
 (2603:10b6:a03:4f8::6)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR12MB8136:EE_|DS7PR12MB5910:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f3e2764-7c77-4bb8-bb49-08df0e82b4ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|10067099003|3023799007|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	/ta3VuHgmY9CeN6QZ2Gd4LqGTuMRBhvS8dWY6ZPyMWyzxV9lwINbCNIyFRH2L0tb5iIbmXcuFLyVzQhcLsH0Xy7AJEvwY4UXLt6UC0PQ8LBe3nKQ3DY+XaB+zFPoGvq57ugEFoiTJztam9ddHdoKbqKoxcODqKc1BDkdhFjNn8Az90WCa96275nojotjZ40+F8njYDg9x6/w3Au3PSQ6FdnVezox4splmG1XYb4VCHiuNTG/ynw1i2K7fkH1LoKw/26o+kdyBsDcE5mULqtrOTp8yXmjyk7asFYAtiVDUfLaz7otlR7UneMUBb+AWXV0ryYMtpHyi92/+U7ag082aoYk2H9zoTWqNoAhzYHpCJSjDVzJGiQ0XqQNiZPnHZmPKM+zKFg1MgLekUrzmKIVWhdKsPDVW3BnJMXH5u2IQnXFxYjpC8D4LQRCNMwN/U+SbDonC4a9/snGT9n/0/ega6mttyc6b0NyfwSTAWiUF4jslybOVNlZCPHpplVpgu2bq8vx7Gc7RobxGBAk2LOPHUbO6WYFfaC62MzZAVEic4eTYGkUzKUmig+3a7OJQ/U/TjNKXIavNg+60IspiCxcwVwNT1bKEA+RLtYILTlXJq9DqHk6Ae6L1GYvK3iV03q+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR12MB8136.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(10067099003)(3023799007)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Ty9qUElkWDZzV2NEbHovTy9iZUlQWkxZUGdFblo3M0V2b3dXbEhDWmhRTjFU?=
 =?utf-8?B?b0dQMTBJS2NLcllDUkFjRTF6akRydEtJUGp3VFJ5YUt3V2JIWEpvWEU4ZGIx?=
 =?utf-8?B?clpPTGZlN2Z2dTdvQWpZM1p5OU95aEFPcHVBbG1VaDdLQlhpbVk4bk41WUdX?=
 =?utf-8?B?QkFlSUh4bjYzTlhpVjd0YklZMEtxR0NGMFBuQ3Rjc2pTb3JIbDV1MjdRdmsr?=
 =?utf-8?B?aFZoaEtCQ3FMTHNob2FFcFUxbkYzV3RieC9Cb1RLR0ZUMG9LOGE2dlFWYVJ1?=
 =?utf-8?B?bUFlVTUyamE3bFBKK1ZuOVlzNE4vbWJTRjBJUEI0L29vdzFTenVlR0I5UUN4?=
 =?utf-8?B?UDdXVGQzeDc3elVTeitFOUdtSmdrNThBK0dXV1RmaVZwdWo0UmJ4Y1lUS1R4?=
 =?utf-8?B?KytPQWwxMGxrUVluYTN3VEtudGYwM0UrdkwwdHZheG9XSGNvM24xNUp5Smkx?=
 =?utf-8?B?N0l5ODE0eEtHdmpIbGxwcCtsZVQyZVpXQUhQaTYvbkxmdTU1YStpa1ZRUzF4?=
 =?utf-8?B?elAvSm1YcmNGckZHU2JhRzUxYkl1YTRNR1lYWHZHaHljS3BUWXpUVHhyWUk0?=
 =?utf-8?B?UTFvN0xyKzQ0c0lTUzhxK3NuUGlxc3pQR0lZZDdvS1VvUXVKL0lvYStiRHpN?=
 =?utf-8?B?TXNuY3J1L0VHQmFQMG44OUtqSkV5UURJOTh3OUc5Q3l0WlloR2piaU5vS2pa?=
 =?utf-8?B?MVM0anNRRWI4NE1NamwzcVpBaUNBUzNaYUJnTWpGOVVJcGJna2oxdkF5UkZw?=
 =?utf-8?B?VmJYY0FQKzk1TjNLRThtM1l5bkZoM3BIbVdzWVI5VkFUU3RneU1neHRxczlO?=
 =?utf-8?B?SFlWc3FteDZiejJmdllUN2dZZ2hTd1JkMUhCb3ZkTkRzQmVwUGpNVDZDY2Nv?=
 =?utf-8?B?TXh2QStFUmxYeTh4emxQaGV6QzNqa2pLZEJrZUNLekwwSUFhTG4xd0cyd25G?=
 =?utf-8?B?N2VoN2lQWmxtRFFyOUp0bG9UMWl1MXJiYTJJemZ0Ri9ZbXlLekJCcE9zWlRH?=
 =?utf-8?B?U1kwN05OSzZuQjJBcnRrQnJ1eVdmRmFmNy9yUGY4amdPY0NLYnRCWU0xTlhP?=
 =?utf-8?B?MHRMTzRoOWhYK2g2dXlUWGNaeENSMlNmd1REZ0hXZWhINTU0RmRranJ2bDhv?=
 =?utf-8?B?WWFTWmF4SWd1KzR3RWUrL0xqTmV4SVB2Ty9WSG9EUDNEN1BmMFV6TWkybzln?=
 =?utf-8?B?clpoc2l6MkpOK2JwMzR2QUd3MG1aSXQrRDg0RGZuSUVDeEE2UXFFWWhXMTh1?=
 =?utf-8?B?QXlrdXdIWEhMUmJpdVlHaWpOSytrN2FWK3dESng1MVRPNWVacUdzUmE3THhY?=
 =?utf-8?B?SUdyZnN2ZlVCUlAvSWxSUmxqOXAxWjZmc1I2ZTdRVjJxVmNJVHFCK1I3S3N1?=
 =?utf-8?B?cTNJMWdlYlltNGZzR1hsc2M0RVhFNUNUd1FHUUFrVVNNVkk5Zi8xMmZIaXEy?=
 =?utf-8?B?OW80TiswcElpOUtPTytsd045TWwzLzdtM1VtM01PKzAwTCt3TkF6eEl1d3Bv?=
 =?utf-8?B?ZWE5L2NIWU1wb25SNFBLVE5pOG5ZNHpoOHpLYStoRTFJZEZObTMwcXpBTjhV?=
 =?utf-8?B?blZYemVwRnRBWXMwL1lqVGFEeVE3MzlNMXgvWlhRM1ZjckVNMWxiYS9JZjFv?=
 =?utf-8?B?WE1iMjZaem1Lbjk5S3BJOFhlTFdrd2VubXVZRjlCWVJKWXJ6aXpRNjVNTUVq?=
 =?utf-8?B?Q0hrNGxxaHVRVThuTlN5OTZsU043ZlFGQ0ZTb2J5aUY1cHdrRklRTXB3cXU2?=
 =?utf-8?B?TER1b3E5NlhvQTBpaUxjTmc3WTR2SUJzRjFJK2tPQlFSdEJjNlBETXdkdnky?=
 =?utf-8?B?MUdWUUErTzE3MjZOazg0Wi9HVmNKUzZWTXZKNmNiR2FNUm5ZYXhNa1BEWHdC?=
 =?utf-8?B?ZHJjcG5jZlQzT0ZKNS9tOXpTcU9sTVpSaVRkb3diUUx3QTBnS0xmTXEvK3dw?=
 =?utf-8?B?RFhWcGQyd3dyUE5QSjRYK0F5WUZBRWtJS3ZIeFJpMi9sVFljaFg0b3poU0JW?=
 =?utf-8?B?Wmh4VWdPbm9PYUxWUTA2Mmx2ekRvOGNLWWJvSjlPbFFrNUtiSThFSTR3WHNk?=
 =?utf-8?B?L0tBcGNpc3ovMDdkWW45TU9CYlRsSzVGZjcxbTRYOG5hcFRtbXZqTWRTdFZG?=
 =?utf-8?B?a2xFd01OZS9TczlYUXNXaW5WekcrSGhSUnkxa1BPd2NPdEVjTXBvRXpVWkYr?=
 =?utf-8?B?bWNuZ1ZqbXhJSnJmb3NCbVZhS1pLbldLUDc5WFZNMmtpdUIxaWp5eFI1a215?=
 =?utf-8?B?b2FEWFMxNEVCRE1Jdk94d1AxcllwNnM0Z2p0WnZyY1g3cFdKR3loeW9WZGxQ?=
 =?utf-8?Q?mcP7BuYhIJ3OBeam57?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3e2764-7c77-4bb8-bb49-08df0e82b4ff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR12MB8136.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2026 14:57:45.7066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hVv1TEz9+ewd8OE3LaAHslNG+lOqRlGS4lOCG0sJ3ifJpzJjXsyvlYzAh8QZtgjkclFebTvh73S0c4zTZVrqPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5910

On 8/31/26 19:14, Randy Dunlap wrote:
> Clean up kernel-doc comments to prevent warnings in both
> <linux/psp-sev.h> and <uapi/linux/psp-sev.h>.
> 
> Binary files are the same before and after this patch.
> 
> include/linux/psp-sev.h: (62 lines; edited for brevity)
> Warning: include/linux/psp-sev.h:52 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform state
> Warning: include/linux/psp-sev.h:63 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform and guest management commands
> Warning: include/linux/psp-sev.h:167 struct member 'reserved' not described in 'sev_data_init'
> Warning: include/linux/psp-sev.h:187 struct member 'reserved' not described in 'sev_data_init_ex'
> Warning: include/linux/psp-sev.h:216 expecting prototype for struct sev_data_cert_import. Prototype was for struct sev_data_pek_cert_import instead
> Warning: include/linux/psp-sev.h:253 struct member 'pdh_cert_address' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 struct member 'pdh_cert_len' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 struct member 'reserved' not described in 'sev_data_pdh_cert_export'
> Warning: include/linux/psp-sev.h:253 Excess struct member 'pdh_address' description in 'sev_data_pdh_cert_export' (did you mean one of: 'pdh_cert_address', 'cert_chain_address')
> Warning: include/linux/psp-sev.h:253 Excess struct member 'pdh_len' description in 'sev_data_pdh_cert_export' (did you mean one of: 'pdh_cert_len')
> Warning: include/linux/psp-sev.h:446 expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_data instead
> Warning: include/linux/psp-sev.h:469 expecting prototype for struct sev_data_send_update. Prototype was for struct sev_data_send_update_vmsa instead
> Warning: include/linux/psp-sev.h:506 struct member 'policy' not described in 'sev_data_receive_start'
> Warning: include/linux/psp-sev.h:799 struct member 'rapl_dis' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'ciphertext_hiding_en' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'tio_en' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:799 struct member 'max_snp_asid' not described in 'sev_data_snp_init_ex'
> Warning: include/linux/psp-sev.h:843 missing initial short description on line:
>  * struct sev_platform_init_args
> Warning: include/linux/psp-sev.h:893 expecting prototype for struct feature_info. Prototype was for struct snp_feature_info instead
> Warning: include/linux/psp-sev.h:956 missing initial short description on line:
>  * struct sev_snp_tcb_version_genoa_milan
> Warning: include/linux/psp-sev.h:973 missing initial short description on line:
>  * struct sev_snp_tcb_version_turin
> Warning: include/linux/psp-sev.h:1053 function parameter 'filep' not described in 'sev_issue_cmd_external_user'
> Warning: include/linux/psp-sev.h:1053 function parameter 'id' not described in 'sev_issue_cmd_external_user'
> Warning: include/linux/psp-sev.h:1112 function parameter 'data' not described in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 function parameter 'error' not described in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 Excess function parameter 'decommission' description in 'sev_guest_decommission'
> Warning: include/linux/psp-sev.h:1112 Excess function parameter 'sev_ret' description in 'sev_guest_decommission'
> 
> include/uapi/linux/psp-sev.h:
> Warning: include/uapi/linux/psp-sev.h:18 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV platform commands
> Warning: include/uapi/linux/psp-sev.h:39 This comment starts with '/**', but isn't a kernel-doc comment.
>  * SEV Firmware status code
> Warning: include/uapi/linux/psp-sev.h:125 struct member 'api_major' not described in 'sev_user_data_status'
> Warning: include/uapi/linux/psp-sev.h:125 struct member 'api_minor' not described in 'sev_user_data_status'
> Warning: include/uapi/linux/psp-sev.h:125 Excess struct member 'major' description in 'sev_user_data_status' (did you mean one of: 'api_major')
> Warning: include/uapi/linux/psp-sev.h:125 Excess struct member 'minor' description in 'sev_user_data_status' (did you mean one of: 'api_minor')
> Warning: include/uapi/linux/psp-sev.h:153 expecting prototype for struct sev_user_data_cert_import. Prototype was for struct sev_user_data_pek_cert_import instead
> Warning: include/uapi/linux/psp-sev.h:168 struct member 'pdh_cert_address' not described in 'sev_user_data_pdh_cert_export'
> Warning: include/uapi/linux/psp-sev.h:168 struct member 'pdh_cert_len' not described in 'sev_user_data_pdh_cert_export'
> Warning: include/uapi/linux/psp-sev.h:168 Excess struct member 'pdh_address' description in 'sev_user_data_pdh_cert_export' (did you mean one of: 'pdh_cert_address', 'cert_chain_address')
> Warning: include/uapi/linux/psp-sev.h:168 Excess struct member 'pdh_len' description in 'sev_user_data_pdh_cert_export' (did you mean one of: 'pdh_cert_len')
> Warning: include/uapi/linux/psp-sev.h:263 expecting prototype for struct sev_data_snp_vlek_load. Prototype was for struct sev_user_data_snp_vlek_load instead
> Warning: include/uapi/linux/psp-sev.h:273 expecting prototype for struct sev_user_data_snp_vlek_wrapped_vlek_hashstick. Prototype was for struct sev_user_data_snp_wrapped_vlek_hashstick instead
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> ---
> Cc: Ashish Kalra <ashish.kalra@amd.com>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> 
>  include/linux/psp-sev.h      |  114 +++++++++++++++++++++++++--------
>  include/uapi/linux/psp-sev.h |   26 +++----
>  2 files changed, 101 insertions(+), 39 deletions(-)
> 
> --- linux-next-20260828.orig/include/linux/psp-sev.h
> +++ linux-next-20260828/include/linux/psp-sev.h
> @@ -49,7 +49,7 @@
>  
>  #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
>  
> -/**
> +/*
>   * SEV platform state
>   */
>  enum sev_state {
> @@ -60,7 +60,7 @@ enum sev_state {
>  	SEV_STATE_MAX
>  };
>  
> -/**
> +/*
>   * SEV platform and guest management commands
>   */
>  enum sev_cmd {
> @@ -162,7 +162,9 @@ enum sev_cmd {
>   */
>  struct sev_data_init {
>  	u32 flags;			/* In */
> +	/* private: */
>  	u32 reserved;			/* In */

I noticed that, for example, struct sev_snp_tcb_version_genoa_milan has
the reserved field as part of the kernel-doc, which seems to eliminate
the need for the "/* private: */" and "/* public: */" comments. Would it
be better to instead just add the reserved fields to the kernel doc?

Thanks,
Tom

> +	/* public: */
>  	u64 tmr_address;		/* In */
>  	u32 tmr_len;			/* In */
>  } __packed;
> @@ -182,7 +184,9 @@ struct sev_data_init_ex {
>  	u32 flags;                      /* In */
>  	u64 tmr_address;                /* In */
>  	u32 tmr_len;                    /* In */
> +	/* private: */
>  	u32 reserved;                   /* In */
> +	/* public: */
>  	u64 nv_address;                 /* In/Out */
>  	u32 nv_len;                     /* In */
>  } __packed;
> @@ -201,17 +205,19 @@ struct sev_data_pek_csr {
>  } __packed;
>  
>  /**
> - * struct sev_data_cert_import - PEK_CERT_IMPORT command parameters
> + * struct sev_data_pek_cert_import - PEK_CERT_IMPORT command parameters
>   *
> - * @pek_address: PEK certificate chain
> - * @pek_len: len of PEK certificate
> - * @oca_address: OCA certificate chain
> - * @oca_len: len of OCA certificate
> + * @pek_cert_address: PEK certificate chain
> + * @pek_cert_len: len of PEK certificate
> + * @oca_cert_address: OCA certificate chain
> + * @oca_cert_len: len of OCA certificate
>   */
>  struct sev_data_pek_cert_import {
>  	u64 pek_cert_address;			/* In */
>  	u32 pek_cert_len;			/* In */
> +	/* private: */
>  	u32 reserved;				/* In */
> +	/* public: */
>  	u64 oca_cert_address;			/* In */
>  	u32 oca_cert_len;			/* In */
>  } __packed;
> @@ -240,15 +246,17 @@ struct sev_data_get_id {
>  /**
>   * struct sev_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
>   *
> - * @pdh_address: PDH certificate address
> - * @pdh_len: len of PDH certificate
> + * @pdh_cert_address: PDH certificate address
> + * @pdh_cert_len: len of PDH certificate
>   * @cert_chain_address: PDH certificate chain
>   * @cert_chain_len: len of PDH certificate chain
>   */
>  struct sev_data_pdh_cert_export {
>  	u64 pdh_cert_address;			/* In */
>  	u32 pdh_cert_len;			/* In/Out */
> +	/* private: */
>  	u32 reserved;				/* In */
> +	/* public: */
>  	u64 cert_chain_address;			/* In */
>  	u32 cert_chain_len;			/* In/Out */
>  } __packed;
> @@ -312,7 +320,9 @@ struct sev_data_launch_start {
>  	u32 policy;				/* In */
>  	u64 dh_cert_address;			/* In */
>  	u32 dh_cert_len;			/* In */
> +	/* private: */
>  	u32 reserved;				/* In */
> +	/* public: */
>  	u64 session_address;			/* In */
>  	u32 session_len;			/* In */
>  } __packed;
> @@ -326,7 +336,9 @@ struct sev_data_launch_start {
>   */
>  struct sev_data_launch_update_data {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved;
> +	/* public: */
>  	u64 address;				/* In */
>  	u32 len;				/* In */
>  } __packed;
> @@ -340,7 +352,9 @@ struct sev_data_launch_update_data {
>   */
>  struct sev_data_launch_update_vmsa {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved;
> +	/* public: */
>  	u64 address;				/* In */
>  	u32 len;				/* In */
>  } __packed;
> @@ -354,7 +368,9 @@ struct sev_data_launch_update_vmsa {
>   */
>  struct sev_data_launch_measure {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved;
> +	/* public: */
>  	u64 address;				/* In */
>  	u32 len;				/* In/Out */
>  } __packed;
> @@ -372,13 +388,19 @@ struct sev_data_launch_measure {
>   */
>  struct sev_data_launch_secret {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved1;
> +	/* public: */
>  	u64 hdr_address;			/* In */
>  	u32 hdr_len;				/* In */
> +	/* private: */
>  	u32 reserved2;
> +	/* public: */
>  	u64 guest_address;			/* In */
>  	u32 guest_len;				/* In */
> +	/* private: */
>  	u32 reserved3;
> +	/* public: */
>  	u64 trans_address;			/* In */
>  	u32 trans_len;				/* In */
>  } __packed;
> @@ -411,19 +433,25 @@ struct sev_data_send_start {
>  	u32 policy;				/* Out */
>  	u64 pdh_cert_address;			/* In */
>  	u32 pdh_cert_len;			/* In */
> +	/* private: */
>  	u32 reserved1;
> +	/* public: */
>  	u64 plat_certs_address;			/* In */
>  	u32 plat_certs_len;			/* In */
> +	/* private: */
>  	u32 reserved2;
> +	/* public: */
>  	u64 amd_certs_address;			/* In */
>  	u32 amd_certs_len;			/* In */
> +	/* private: */
>  	u32 reserved3;
> +	/* public: */
>  	u64 session_address;			/* In */
>  	u32 session_len;			/* In/Out */
>  } __packed;
>  
>  /**
> - * struct sev_data_send_update - SEND_UPDATE_DATA command
> + * struct sev_data_send_update_data - SEND_UPDATE_DATA command
>   *
>   * @handle: handle of the VM to process
>   * @hdr_address: physical address containing packet header
> @@ -435,19 +463,25 @@ struct sev_data_send_start {
>   */
>  struct sev_data_send_update_data {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved1;
> +	/* public: */
>  	u64 hdr_address;			/* In */
>  	u32 hdr_len;				/* In/Out */
> +	/* private: */
>  	u32 reserved2;
> +	/* public: */
>  	u64 guest_address;			/* In */
>  	u32 guest_len;				/* In */
> +	/* private: */
>  	u32 reserved3;
> +	/* public: */
>  	u64 trans_address;			/* In */
>  	u32 trans_len;				/* In */
>  } __packed;
>  
>  /**
> - * struct sev_data_send_update - SEND_UPDATE_VMSA command
> + * struct sev_data_send_update_vmsa - SEND_UPDATE_VMSA command
>   *
>   * @handle: handle of the VM to process
>   * @hdr_address: physical address containing packet header
> @@ -461,10 +495,14 @@ struct sev_data_send_update_vmsa {
>  	u32 handle;				/* In */
>  	u64 hdr_address;			/* In */
>  	u32 hdr_len;				/* In/Out */
> +	/* private: */
>  	u32 reserved2;
> +	/* public: */
>  	u64 guest_address;			/* In */
>  	u32 guest_len;				/* In */
> +	/* private: */
>  	u32 reserved3;
> +	/* public: */
>  	u64 trans_address;			/* In */
>  	u32 trans_len;				/* In */
>  } __packed;
> @@ -491,6 +529,7 @@ struct sev_data_send_cancel {
>   * struct sev_data_receive_start - RECEIVE_START command parameters
>   *
>   * @handle: handle of the VM to perform receive operation
> + * @policy: policy information for the VM
>   * @pdh_cert_address: system physical address containing PDH certificate blob
>   * @pdh_cert_len: len of PDH certificate blob
>   * @session_address: system physical address containing session blob
> @@ -501,7 +540,9 @@ struct sev_data_receive_start {
>  	u32 policy;				/* In */
>  	u64 pdh_cert_address;			/* In */
>  	u32 pdh_cert_len;			/* In */
> +	/* private: */
>  	u32 reserved1;
> +	/* public: */
>  	u64 session_address;			/* In */
>  	u32 session_len;			/* In */
>  } __packed;
> @@ -519,13 +560,19 @@ struct sev_data_receive_start {
>   */
>  struct sev_data_receive_update_data {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved1;
> +	/* public: */
>  	u64 hdr_address;			/* In */
>  	u32 hdr_len;				/* In */
> +	/* private: */
>  	u32 reserved2;
> +	/* public: */
>  	u64 guest_address;			/* In */
>  	u32 guest_len;				/* In */
> +	/* private: */
>  	u32 reserved3;
> +	/* public: */
>  	u64 trans_address;			/* In */
>  	u32 trans_len;				/* In */
>  } __packed;
> @@ -543,13 +590,19 @@ struct sev_data_receive_update_data {
>   */
>  struct sev_data_receive_update_vmsa {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved1;
> +	/* public: */
>  	u64 hdr_address;			/* In */
>  	u32 hdr_len;				/* In */
> +	/* private: */
>  	u32 reserved2;
> +	/* public: */
>  	u64 guest_address;			/* In */
>  	u32 guest_len;				/* In */
> +	/* private: */
>  	u32 reserved3;
> +	/* public: */
>  	u64 trans_address;			/* In */
>  	u32 trans_len;				/* In */
>  } __packed;
> @@ -573,7 +626,9 @@ struct sev_data_receive_finish {
>   */
>  struct sev_data_dbg {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved;
> +	/* public: */
>  	u64 src_addr;				/* In */
>  	u64 dst_addr;				/* In */
>  	u32 len;				/* In */
> @@ -589,7 +644,9 @@ struct sev_data_dbg {
>   */
>  struct sev_data_attestation_report {
>  	u32 handle;				/* In */
> +	/* private: */
>  	u32 reserved;
> +	/* public: */
>  	u64 address;				/* In */
>  	u8 mnonce[16];				/* In */
>  	u32 len;				/* In/Out */
> @@ -781,9 +838,14 @@ struct sev_data_snp_guest_request {
>   *
>   * @init_rmp: indicate that the RMP should be initialized.
>   * @list_paddr_en: indicate that list_paddr is valid
> + * @rapl_dis: whether RAPL is disabled
> + * @ciphertext_hiding_en: whether ciphertext hiding is enabled
> + * @tio_en: Indicates that SNP_INIT_EX initialized the RMP for SEV-TIO
>   * @rsvd: reserved
>   * @rsvd1: reserved
>   * @list_paddr: system physical address of range list
> + * @max_snp_asid: When non-zero, enable ciphertext hiding and specify the
> + *  maximum ASID that can be used for an SEV-SNP guest.
>   * @rsvd2: reserved
>   */
>  struct sev_data_snp_init_ex {
> @@ -841,7 +903,7 @@ struct sev_data_snp_shutdown_ex {
>  } __packed;
>  
>  /**
> - * struct sev_platform_init_args
> + * struct sev_platform_init_args - parameters for sev_platform_init()
>   *
>   * @error: SEV firmware error code
>   * @probe: True if this is being called as part of CCP module probe, which
> @@ -879,12 +941,12 @@ struct sev_data_snp_feature_info {
>  } __packed;
>  
>  /**
> - * struct feature_info - FEATURE_INFO structure
> + * struct snp_feature_info - FEATURE_INFO structure
>   *
>   * @eax: output of SNP_FEATURE_INFO command
>   * @ebx: output of SNP_FEATURE_INFO command
>   * @ecx: output of SNP_FEATURE_INFO command
> - * #edx: output of SNP_FEATURE_INFO command
> + * @edx: output of SNP_FEATURE_INFO command
>   */
>  struct snp_feature_info {
>  	u32 eax;
> @@ -954,7 +1016,7 @@ struct sev_data_snp_verify_mitigation_ds
>  } __packed;
>  
>  /**
> - * struct sev_snp_tcb_version_genoa_milan
> + * struct sev_snp_tcb_version_genoa_milan - v1 SVN payload
>   *
>   * @boot_loader: SVN of PSP bootloader
>   * @tee: SVN of PSP operating system
> @@ -971,7 +1033,7 @@ struct sev_snp_tcb_version_genoa_milan {
>  };
>  
>  /**
> - * struct sev_snp_tcb_version_turin
> + * struct sev_snp_tcb_version_turin - v2 SVN payload
>   *
>   * @fmc: SVN of FMC firmware
>   * @boot_loader: SVN of PSP bootloader
> @@ -1037,9 +1099,9 @@ int sev_platform_status(struct sev_user_
>   * behalf of userspace. The caller must pass a valid SEV file descriptor
>   * so that we know that it has access to SEV device.
>   *
> - * @filep - SEV device file pointer
> - * @cmd - command to issue
> - * @data - command buffer
> + * @filep: SEV device file pointer
> + * @id: command to issue
> + * @data: command buffer
>   * @error: SEV command return code
>   *
>   * Returns:
> @@ -1056,8 +1118,8 @@ int sev_issue_cmd_external_user(struct f
>  /**
>   * sev_guest_deactivate - perform SEV DEACTIVATE command
>   *
> - * @deactivate: sev_data_deactivate structure to be processed
> - * @sev_ret: sev command return code
> + * @data: sev_data_deactivate structure to be processed
> + * @error: sev command return code
>   *
>   * Returns:
>   * 0 if the sev successfully processed the command
> @@ -1071,8 +1133,8 @@ int sev_guest_deactivate(struct sev_data
>  /**
>   * sev_guest_activate - perform SEV ACTIVATE command
>   *
> - * @activate: sev_data_activate structure to be processed
> - * @sev_ret: sev command return code
> + * @data: sev_data_activate structure to be processed
> + * @error: sev command return code
>   *
>   * Returns:
>   * 0 if the sev successfully processed the command
> @@ -1086,7 +1148,7 @@ int sev_guest_activate(struct sev_data_a
>  /**
>   * sev_guest_df_flush - perform SEV DF_FLUSH command
>   *
> - * @sev_ret: sev command return code
> + * @error: sev command return code
>   *
>   * Returns:
>   * 0 if the sev successfully processed the command
> @@ -1100,8 +1162,8 @@ int sev_guest_df_flush(int *error);
>  /**
>   * sev_guest_decommission - perform SEV DECOMMISSION command
>   *
> - * @decommission: sev_data_decommission structure to be processed
> - * @sev_ret: sev command return code
> + * @data: sev_data_decommission structure to be processed
> + * @error: sev command return code
>   *
>   * Returns:
>   * 0 if the sev successfully processed the command
> --- linux-next-20260828.orig/include/uapi/linux/psp-sev.h
> +++ linux-next-20260828/include/uapi/linux/psp-sev.h
> @@ -15,7 +15,7 @@
>  
>  #include <linux/types.h>
>  
> -/**
> +/*
>   * SEV platform commands
>   */
>  enum {
> @@ -36,7 +36,7 @@ enum {
>  	SEV_MAX,
>  };
>  
> -/**
> +/*
>   * SEV Firmware status code
>   */
>  typedef enum {
> @@ -109,8 +109,8 @@ typedef enum {
>  /**
>   * struct sev_user_data_status - PLATFORM_STATUS command parameters
>   *
> - * @major: major API version
> - * @minor: minor API version
> + * @api_major: major API version
> + * @api_minor: minor API version
>   * @state: platform state
>   * @flags: platform config flags
>   * @build: firmware build id for API version
> @@ -139,12 +139,12 @@ struct sev_user_data_pek_csr {
>  } __packed;
>  
>  /**
> - * struct sev_user_data_cert_import - PEK_CERT_IMPORT command parameters
> + * struct sev_user_data_pek_cert_import - PEK_CERT_IMPORT command parameters
>   *
> - * @pek_address: PEK certificate chain
> - * @pek_len: length of PEK certificate
> - * @oca_address: OCA certificate chain
> - * @oca_len: length of OCA certificate
> + * @pek_cert_address: PEK certificate chain
> + * @pek_cert_len: length of PEK certificate
> + * @oca_cert_address: OCA certificate chain
> + * @oca_cert_len: length of OCA certificate
>   */
>  struct sev_user_data_pek_cert_import {
>  	__u64 pek_cert_address;			/* In */
> @@ -156,8 +156,8 @@ struct sev_user_data_pek_cert_import {
>  /**
>   * struct sev_user_data_pdh_cert_export - PDH_CERT_EXPORT command parameters
>   *
> - * @pdh_address: PDH certificate address
> - * @pdh_len: length of PDH certificate
> + * @pdh_cert_address: PDH certificate address
> + * @pdh_cert_len: length of PDH certificate
>   * @cert_chain_address: PDH certificate chain
>   * @cert_chain_len: length of PDH certificate chain
>   */
> @@ -248,7 +248,7 @@ struct sev_user_data_snp_config {
>  } __packed;
>  
>  /**
> - * struct sev_data_snp_vlek_load - SNP_VLEK_LOAD structure
> + * struct sev_user_data_snp_vlek_load - SNP_VLEK_LOAD structure
>   *
>   * @len: length of the command buffer read by the PSP
>   * @vlek_wrapped_version: version of wrapped VLEK hashstick (Must be 0h)
> @@ -264,7 +264,7 @@ struct sev_user_data_snp_vlek_load {
>  } __packed;
>  
>  /**
> - * struct sev_user_data_snp_vlek_wrapped_vlek_hashstick - Wrapped VLEK data
> + * struct sev_user_data_snp_wrapped_vlek_hashstick - Wrapped VLEK data
>   *
>   * @data: Opaque data provided by AMD KDS (as described in SEV-SNP Firmware ABI
>   *        1.54, SNP_VLEK_LOAD)

