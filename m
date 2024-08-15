Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E401A00DF;
	Thu, 15 Aug 2024 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733644; cv=fail; b=aIKlfvmM5bB7bi+j/sdB55pjWULiYSrO4UgqcdFbnJAFRI3LgeCfqGkNS4seCUyaO4GI7L5l/PIsirGNARMcslaPdE6oPjs2psUFvX+lVP7sgND9HlT0AVq5FXEXBVEhZy7G/aWrAW/GaH1atMKimtAlw0EN8PCveVZT1LcnXc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733644; c=relaxed/simple;
	bh=VTl0i2YiKS8R8ElQpDrFp50kjkZGgZQc2wwGr56IPuA=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=IM1dV93ud00pjKFW+oycioaKAQxlnmYw6aSpj6mck8SBLlWU1sW6vClYZsfcTpAd7WCXte1yuWUj50VMIZYoYFT/Sf39e/yO1eTNdGd/aRZWpZ9ln90Ly9abjMctvcQhcu5huz1TtbsG74IXKTscFPqonxJcj5Kbf5BmhE0ZNlY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XpUlpEmh; arc=fail smtp.client-ip=40.107.220.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XpUlpEmh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TrwmE43a8Wb9FJ4+tKGZp3L1+OdwASAv55S8oFriGZUAqjTi5xOEAiqdv9CP+OLG332V+5Jq3gzbhZbNJtiKVu2nVjn7PgMe0Z4sERLYQxzrLkxkX3/aTnme4xD4e98p0LcDxkdTghZJB7Z2gjYfy4GvfLoyr4r4RC7yIhy4TpuFD0Qw/2kIq33n4wkstMjQIZe6EfXxl6Wimko/bvzvNs1gOeH2CibJkxZ6M8B9oABrKSJV6d6dzhMTBu9Ue3DaRRu9C0sVwaLPiMWlDuQrwApmejNpWA2jHBPKkfa3pQf7QIYB+0soxP5VumfVcgWNPCJg5h9M7vnaqQe5u6fBLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVxJu9ERuxEfloAY6F4M6erML5++hr5iztAYlGs19Ao=;
 b=wmhP4y3OAMwp49hdK3ApWnO0ysWYSV6IZ5hyPKbjYI/O777M0LtDV8BKgvxQAnRFNY8lA8VU2wtDSDzCzJC1knWqv7RQx7lnab5vRh6n8OJuSGIP3tPeUznL/5grznT8eehjeqC13K14N/6cWFRR7nEOGmLOcltcpWbcDeAJ2eLCHoQO4tVYjOLlaFlyYO93GX6ozxBBL5/hjI1yssMYlcgZ42ej+5jN73jZOy3HjknPf3usk6WyAM4WWM5Uk2WiWNWS25uwtAYtodzvalkgRt2S1O5x5viGAfv2E05x4gv18s+4kwlDck1dQt3svb0GakidVPC6uVN1gV16mRK7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVxJu9ERuxEfloAY6F4M6erML5++hr5iztAYlGs19Ao=;
 b=XpUlpEmh3ageAPuGiD5LEuowfBEog1DdKRwzN2zVA1muVCgm1WySdSFh8C28Xhlkk66JUC0L8TogegfixJ8nECAxrMNoRx/34ffUcrKLKFl8siuckpNemp9qeRgMlFxqVSw8jMYOtx3OnTdhZ7n/BBaZ8NcvF9hikmS5K4zCfxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH8PR12MB7326.namprd12.prod.outlook.com (2603:10b6:510:216::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.19; Thu, 15 Aug
 2024 14:53:57 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7875.016; Thu, 15 Aug 2024
 14:53:57 +0000
Message-ID: <c28836c4-e823-dc36-e753-1a5ee3831629@amd.com>
Date: Thu, 15 Aug 2024 09:53:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Diederik de Haas <didi.debian@cknow.org>, John Allen <john.allen@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <D3GJCRNY4KDK.3SPJB5WP8Z7DK@cknow.org>
 <0561862d-99d9-ae72-49d0-9ad0639482ea@amd.com>
 <D3GKA618AGIM.36RB2FW9Z21JE@cknow.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [BUG] Non working HWRNG on AMD Ryzen 5 5500GT
In-Reply-To: <D3GKA618AGIM.36RB2FW9Z21JE@cknow.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR04CA0194.namprd04.prod.outlook.com
 (2603:10b6:806:126::19) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH8PR12MB7326:EE_
X-MS-Office365-Filtering-Correlation-Id: c6454674-d097-480f-41a7-08dcbd3a1710
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?U0FrUUNUTUdWRS9uWTdxbDNGNlY0bXZxS2NOWHFCZ2p1Uld3ODhsa2M5UjhT?=
 =?utf-8?B?Vk5tbDJYSHNzUlBCaHJORndua0lUbHBnQjlRUkJuVmREUDZSZWhKUGZwdnVi?=
 =?utf-8?B?V2NSNkVTYThOWDNVUkFUNzR3Zk9VcDdVaUtPVjFZMG51SXBhUk5KcUZqazVX?=
 =?utf-8?B?T2Z2bzdqMlFXYWs1QUtJZWpPTHQ5OVNseGo0WFJIQWlibkt2aWd5TDBZNDNh?=
 =?utf-8?B?Z2p0bVRiaWZtNWhwU2MyRXZ5K0pNaUdWdFNQK3JFVlFTN0wrR2paZHNUQW5k?=
 =?utf-8?B?d3VXME1JSDNUOEMrZ00yWUhmMlZHdE5sMlc3SFNDcThKZG5rUVJvZUw1K2Y4?=
 =?utf-8?B?UkJrWVkzVkNaVkxvM0hIdFZ1dGZ6SWN6N0d3bFBYdkJ2elVQd09lTHJmN2NP?=
 =?utf-8?B?NmFJTTJzNXVXZnhxTU1IMlJoV1h3VW5oSnYvcmhqQmZsT2ZFa2RYNnEzeUM2?=
 =?utf-8?B?cGwyaVdMQWxiUGtybTJxcElkUjBaMnhLRjdLUnNDNFhiR1g4QnpHQlNGME1z?=
 =?utf-8?B?Y1BQWTY4YmRZVUt3cTI0ZUR0SWFoV041SjB2dUdtRDk0cVFUZzNDTElUQUVW?=
 =?utf-8?B?Yk9GRm10OGpiTVA0SG0zTHJuVzBJOEFYUnZNbk1WY3NJWlhBZThmSFVMK0Z6?=
 =?utf-8?B?U29nVzZjLzlCckE2NDZrNS80TzFLQ0J2SHNYWkU4b0I1V0hpNThqN3NLVExY?=
 =?utf-8?B?eU9iSG53L1V0UFFVZGliQldFaDArNmRWNlgzQ2VPWEprcFJGdUN2Q0YrTUVD?=
 =?utf-8?B?Ukh4dkNVSmE4TGtHUTNvM1BDVk5oMEp0TlFzeWk4SHFsZzZaQVUrS0luS3k0?=
 =?utf-8?B?RXdEbjl1a1ZxMDkvN1dRZ3ExOGs2dFlCTkpmMXZRaGxtVXpuYjA5QXBRSlZG?=
 =?utf-8?B?cjZSQmNCN2xjZjhWY3ExdkIwZnluemRGNUJTUkFWTzdmcUR6K1ZabGFqUjQz?=
 =?utf-8?B?a0NiWFNJQzlJR3hpWEZTOVdJMmtKMkd3K2lXS0dVdDRFK2hmZEYyL3lBWmRM?=
 =?utf-8?B?djQwZTUzTHA4QytkMVg3TCt6VU1JcWRZOHR5U1YxNG1KWDNPSDY4N21INHN4?=
 =?utf-8?B?eTNQRW5XcGZHV3o2UlJ0UFJnVHJEeEkvdzN2MmJrdnJsTXNsa2VHaE5zSmhk?=
 =?utf-8?B?alZiTk1mcjNxY1NNNml3dFJUMmpUVWxEbDZndUpMYnVBaVo2ZEZrRmFzUG1L?=
 =?utf-8?B?ZlR5ZlJMOStYTCs2N1lZR2lWYmx2ejJnMW1wYU00cDlNZ2pQNm1lbHF4Rlpn?=
 =?utf-8?B?M3ZDcExqcVBGNnhnOHJxUGNDVXhwNFJwMldFakVHOVlIUzFBdmtWdjF3UVQr?=
 =?utf-8?B?cjQyelJlb0Q2SzFkZW9QY05TWUcyemFsNWxDdm5YR1hNd1N5cDcxcVYvMmN2?=
 =?utf-8?B?N1dLZjBLbHFpMmp2eVdjbTlwQTA3UHh0T011RFRBUlZpcUdqdzFvVWJiWGIz?=
 =?utf-8?B?MHgxdmpVczU3S3diTmlJazhvdFBmTHdBVlRMNWFvRHMrTlRjNXh4bGlYNTUy?=
 =?utf-8?B?TTI4Zm1ILzhid1prSVdpVGhiMUI5MHRzRmFNOGY0TzNKNGZ0K0dXeGlac0hH?=
 =?utf-8?B?d2VBNlVXMUhXUnhDM0VTMEtWS0lRVkV6R0M0SWU5K1pyUHJBUU1MaGlaUXJT?=
 =?utf-8?B?TFNMOHVReTV6NHg0eXBVSTRmc1VuMUgyb0tJbTF6ZjhIVy91SFZ2MUIyRXF3?=
 =?utf-8?B?SEo2WlIzT3didGRCMXR5RjhoZlN2c3dKODljLzFQYkJKNnNwVjZNTmVMTWw1?=
 =?utf-8?Q?4CBukvkc35nXTHykfJ1NhXaIsRrAbXmMB92lM7J?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MkYxR2FvMHY5VnVxNmZ3TjQySHFWT2o0UFlOMjNPSUd6ZSs3TkJFNVRIZFR1?=
 =?utf-8?B?NlpKYUczaWRMZEJMbTBCbHQvcjI4T3MzcHZORHg4K1BSOTFqMzlXNnJNVHpl?=
 =?utf-8?B?QW5Xc3RIRnZ3N2lpME05MjBXU1RCNWJGTFovNnVRYnp0bmdZanVLQzNEUTRC?=
 =?utf-8?B?RGtML1h2SU9vWDc0UTBDSE5vVWdjcFZCQW5TeC9rcFpvNDFHN1VLcWpwelZP?=
 =?utf-8?B?bmFScnNHbTFac1FmVUdCUU1Ed0xPS0RKTHFCbTFsemNaNkNjdGo4OVZvbndk?=
 =?utf-8?B?c1VTdlQrYkt2VnUvY05yQ3FNUnpkT3FDVU03RW5QUnl0RW1XQzF0aHZLQ3dz?=
 =?utf-8?B?eXB3YnVUbTNZdXV0NjJuYkpkUHhla3M0aEh2TGdCV2dGdUlBbS9keU1TRVl5?=
 =?utf-8?B?dUhyUnFpeFQvSDJBM0dPMFp4VEdxNHNrME04eUZNMVNpWmJBTFc0dmMzVnJp?=
 =?utf-8?B?R3JOVU9sOFdRMUFhb1J0eUpOOElDWnEvUjlub2hJaWhYanhrK1B5VDBVa0VQ?=
 =?utf-8?B?a2JpY0lXanFreUlzdENrQjlVMzJKOFBsQ3FqQXAzcU5kcUo4clBEOEVoNzhm?=
 =?utf-8?B?eU8vRU42MGpYUkFuSmZpS29Qa25aMHN4ZFJPb21TV3RHYmFwb3FETWJzN1U1?=
 =?utf-8?B?d25pTFBEZFBkN3FhUFNNVzJMT3dLSDFURG0vT1NqSzcxY1YvU04yVWNaYlVZ?=
 =?utf-8?B?aFRJb3F6Y0t6UEU1VTZVTjM1aExVdy9qU1FLR0J5ZWRzeDdoVlJXcnI5bXh5?=
 =?utf-8?B?Uy92WUdNT0xibnEzL0NmcmJKWHpaZmJFWFh1bnVNM0oxUmd6cXJrRTdyWjFE?=
 =?utf-8?B?K2dhVXYybGhvcGJ6blpyeHNDMEh2Vi8xcSs2VGk4ckpTbU56NmlyQjVuV1Jt?=
 =?utf-8?B?QTVuSlk4MlV2c2h6OHVxRzdNckt3ZXdLTWRNWXJFKzdaZFF2djBqMVg2YU5D?=
 =?utf-8?B?amtwWmpEcG5BaHZBd2J6ZG5JMHdqci9VeVc1VDVhNitWM1V0TnJCNFFydFVl?=
 =?utf-8?B?RWFrcWhFdDdiaXV1R2dvVUJMMWJZU0dTWWF2OUtOY3p2T1laSXhCM0taNHZD?=
 =?utf-8?B?bmZlekJoNE1zdmNibGZEcVVidHBsakV4QVJUT01EWkJkZjlFaC9wS0tCNk5p?=
 =?utf-8?B?cERmK1dMN1I3U2wzeGswak9aSWpzdVNQSDdlTmJKTVp3dlYxSDBJNkw2cjdO?=
 =?utf-8?B?VkliZk1jRzl4bkhxU3pJdDVQbDZRR3k4REhvOUlRWENTeGdVeWVrd1NGd24y?=
 =?utf-8?B?NERZY2dMaW0xK0xvU0tvNVVpV3g3ZUZEbHFIOXRXVXlveFdUL0QrM253WnJ0?=
 =?utf-8?B?TVhMdm92ZEgwNWt1T2Qways3Ym9Vaklvem5oeXdkY3pqRU1xMFB6ZnpwTTlB?=
 =?utf-8?B?cnNJUHZpdHpucW9DOGJxemh5dUluNGdyZkdnM3JoaklwQXFTVkZRdm1TU3oz?=
 =?utf-8?B?TUhseERaTS81VHpMekxpUUpPMVM2UTZRdmtvQ205c2FnMjhNQVZZTTZHajdh?=
 =?utf-8?B?RDVyemUrUkVDV0lValNHaVQ1a3RidEd5QkhmQ0FFeXltVzdmdGg1WG9Vbzla?=
 =?utf-8?B?VDY2TThjUEg2NFhHcml3Q2M0NGlERFpjR0pVL1JLNHd3QWRhUWVuemJSQjVI?=
 =?utf-8?B?VnBSZmZjaEdrOTEweXdwYVNjS2VCTHRVcm5kS0JzclBPM0YxaXNaT0NFQzVy?=
 =?utf-8?B?U2lLTmRlc2lzcFB6Z0ErTkFHM2k5ZzhraW9FYVhvWThRWk05SlpJcGVzcGpN?=
 =?utf-8?B?aWEraEVsNEs2QTBhQ3NDY0dhd0dYNGZUZTU2TStlRVc1YUZac1ROejU2bGZJ?=
 =?utf-8?B?OHR2TVdVTzhKZnNWZDNkYnJwbWJwdVViN2JrMHg3M3lVTVlxTGRBaTR4Q0hX?=
 =?utf-8?B?ZTY0SUdiUnZTcnJtSVhjdGFRUEhacEdTVmxQeG5KRDg1Wk1rcHVuajhBWVlQ?=
 =?utf-8?B?NTZKaWJlaWs4Szlrd0VPMndFQnFSYzQvUEw4Ukhsa1E3aDh6UzRlSG94aGdT?=
 =?utf-8?B?TmVram9vQ1ZGaFhIOG9vaXhRK3Q4L2lweXRoOEpOTkYyaWZHVWRQYnZPTnhE?=
 =?utf-8?B?dTRFYjhway82c0RhWFFLeWs3UWVyakFnb3VrRG01OURGUkNyYjdJcktURDJj?=
 =?utf-8?Q?pyOdZlE7SrJdSAExPd0BpDsNT?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6454674-d097-480f-41a7-08dcbd3a1710
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2024 14:53:57.3687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YKyKZdCH8XVydEV4cWMjdkA1OGFJapPdhznpb8NM0wyzR3CFmAOHYy3Og8Eqne6juHrQtDYqP+v7btBVEAJy5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7326

On 8/15/24 09:40, Diederik de Haas wrote:
> On Thu Aug 15, 2024 at 4:16 PM CEST, Tom Lendacky wrote:
>> On 8/15/24 08:56, Diederik de Haas wrote:
>>> I recently bought an Asus ROG STRIX B550-F GAMING MB with an
>>> AMD Ryzen 5 5500GT CPU (and installed the latest BIOS: 3607).
>>> I'm running Debian Testing/Sid on it with kernel 6.9 and now 6.10
>>> and it seems to work great.
>>> I've been doing some (unrelated) tests with `rngtest` from the
>>> `rng-tools5` package and wondered how it would fare on my AMD CPU.
>>
>> I'm not very familiar with this test. What is the command line that you
>> are using to invoke it?
> 
> ```
> root@cs04:~# cat /dev/hwrng | rngtest -c 1000
> rngtest 5
> Copyright (c) 2004 by Henrique de Moraes Holschuh
> This is free software; see the source for copying conditions.
> There is NO warranty; not even for MERCHANTABILITY or FITNESS
> FOR A PARTICULAR PURPOSE.
> 
> rngtest: starting FIPS tests...
> cat: /dev/hwrng: No such device
> rngtest: entropy source drained

Ok, this makes sense since you are using /dev/hwrng. This device does
not exist because the CCP support in the ccp driver did not create one.
It appears that the BIOS has blocked access to the MMIO range for the
CCP so that during initialization, when attempting to read the number of
queues available, 0xffffffff is read instead of the actual number of
queues available, which as Jason noted, results in the "broken BIOS"
message.

This may not matter, though. I don't know if this version of the ASP/CCP
device (1022:15df) provides any queues to the OS to use.

The fact that there is no /dev/hwrng device is not a kernel bug, though.

Thanks,
Tom

> ```
> 
> Or when using ``dd`` you'd get a similar output:
> 
> ```
> root@cs04:~# dd if=ev/hwrng bs%6 | rngtest -c 1000
> rngtest 5
> ...
> 
> rngtest: starting FIPS tests...
> dd: error reading '/dev/hwrng': No such device
> 0+0 records in
> 0+0 records out
> rngtest: entropy source drained
> 0 bytes copied, 4.8214e-05 s, 0.0 kB/s
> ``
> 
> Debian package page: https://packages.debian.org/unstable/rng-tools5
> Debian hasn't switched to the new upstream (yet?), but that can be found
> here: https://github.com/nhorman/rng-tools
> 
>>> And I found out it doesn't work at all!
>>> But on another system I have (Asus ROG CROSSHAIR VII HERO MB +
>>> AMD Ryzen 1800X CPU) it works absolutely fine.
>>>
>>> # dmesg | grep ccp
>>> [    5.399853] ccp 0000:07:00.2: ccp: unable to access the device: you might
>>> be running a broken BIOS.
>>> [    5.401031] ccp 0000:07:00.2: tee enabled
>>> [    5.401113] ccp 0000:07:00.2: psp enabled
>>
>> Which system is this output from?
> 
> My new system ("cs04") with AMD Ryzen 5 5500GT CPU/APU.
> 
>> Can you provide the output from lspci -nn?
> 
> ```
> root@cs04:~# lspci -nn
> 00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne Root Complex [1022:1630]
> 00:00.2 IOMMU [0806]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne IOMMU [1022:1631]
> 00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
> 00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
> 00:02.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne PCIe GPP Bridge [1022:1634]
> 00:02.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne PCIe GPP Bridge [1022:1634]
> 00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Renoir PCIe Dummy Host Bridge [1022:1632]
> 00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Renoir Internal PCIe GPP Bridge to Bus [1022:1635]
> 00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:790b] (rev 51)
> 00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:790e] (rev 51)
> 00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 0 [1022:166a]
> 00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 1 [1022:166b]
> 00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 2 [1022:166c]
> 00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 3 [1022:166d]
> 00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 4 [1022:166e]
> 00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 5 [1022:166f]
> 00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 6 [1022:1670]
> 00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Cezanne Data Fabric; Function 7 [1022:1671]
> 01:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset USB 3.1 XHCI Controller [1022:43ee]
> 01:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset SATA Controller [1022:43eb]
> 01:00.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset Switch Upstream Port [1022:43e9]
> 02:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
> 02:08.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
> 02:09.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
> 05:00.0 Ethernet controller [0200]: Intel Corporation Ethernet Controller I225-V [8086:15f3] (rev 03)
> 06:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller PM9A1/PM9A3/980PRO [144d:a80a]
> 07:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Cezanne [Radeon Vega Series / Radeon Vega Mobile Series] [1002:1638] (rev c9)
> 07:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Renoir Radeon High Definition Audio Controller [1002:1637]
> 07:00.2 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Family 17h (Models 10h-1fh) Platform Security Processor [1022:15df]
> 07:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne USB 3.1 [1022:1639]
> 07:00.4 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Renoir/Cezanne USB 3.1 [1022:1639]
> 07:00.6 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Family 17h/19h HD Audio Controller [1022:15e3]
> ```
> 
> Cheers,
>   Diederik
> 
>> Thanks,
>> Tom
>>
>>>
>>> Found an article [1] which could be relevant and downloaded and ran the
>>> accompanying test program (written by Jason Donenfeld):
>>> # ./amd-rdrand-bug
>>> Your RDRAND() does not have the AMD bug.
>>> # ./test-rdrand
>>> RDRAND() =7c993c0
>>> RDRAND() =c7c697d
>>> ... (more seemingly random numbers)
>>> RDRAND() =a858101
>>>
>>> I tried it with the latest microcode dd 2024-07-10, but that didn't make
>>> a difference.
>>>
>>> So I'd like to know if this may actually be a bug on the kernel side.
>>>
>>> Happy to provide additional information or run tests or try patches.
>>>
>>> Cheers,
>>>   Diederik
>>>
>>> [1] https://arstechnica.com/gadgets/2019/10/how-a-months-old-amd-microcode-bug-destroyed-my-weekend/
> 
