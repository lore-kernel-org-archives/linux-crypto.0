Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2088.outbound.protection.outlook.com [40.107.236.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92324223DDE;
	Fri, 20 Jun 2025 19:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750447235; cv=fail; b=NZ3KVBfvZZwzHSpUNHskAywDb36oDJx42j1VqRAVlksi2HMtAokPAkG9D2LZpyVyXJklg5ChjXs0Ppk5NC/k1tos+kjIs5B362KPft5va6jiLqKHS+C6NXY7uNYhBlz2jsfqLBjK9rw93lU5HSYKTMwrN0GiC2HWsmZdS7Wbb38=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750447235; c=relaxed/simple;
	bh=E/+IJMx2BDEYp1q/zu8Lozv5LRsTa+vzyyjhVTaUzYg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OtH2Do7o1l59hkg6Jg1mgFzcLnB+5Yt9QusE1Wy3fQclep1Ze+MTrneT1kt734AGedhehFYES1lJ9jE280XYRf7RDH7w8blf1A13ET96Gjb75P7g0gF2UEBAskszdaWxgdFf8Ge7WBh6TaDyhMqe31aKjDQ5bqiyt84lIC0tGqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=TAXGaNmT; arc=fail smtp.client-ip=40.107.236.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="TAXGaNmT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXdPLAfE7GbspEJYFW77WEsL6LjDrgOYdkYgrwJavNvhnGnV9QbkwrXJj7FX4jjc6wsQDmjnuAtuSnjft3/aFYQdjZYX8rkrkHEZszc0oICTYT5AbwvBWaUrfF1V1KFkA8+VBN0Jy04uJeCcQacfHXmrsfMKeapb8EKydD2gZaI/jyZSVPUwVnxVmGq5Wtets0BCt5NzCLT6Rv1xgPhqsRm0gzgN1u65Rstm21vrk0pRweTt/xt5Eyt1hmClNFF7x/TgMEU0oT/DH80RJdW3UkcONsWEyT3mJjnGHMJzLRWjju1gu+y5EOkDnKfnM4O6qhPk3nPbzfUbZaSZd3rWMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLuWc4VdonxYcSp7jQUYGIq1ddLLNcDF9Wbpks8/+X0=;
 b=hBzfBJTdiGzvhVaLaVqgcpCx4Ys1d3tBALAzr8J2fvwR0mCgz4IWp87BUuuC9gg8Srq+UmZj8dWzvmGEyY8ShKupN3vA3ocCnAOqpD9kmGZDE4lkYTK+AUSbT++LXYsoJZt10JgVk7vxKgbuLfuh6bEfAdMTvbyt7I1zrn6tcs84ciliwusd9VAiylSHgjhFTR+ha5shbw5IcQV1xHtrkL5GH4f3j06de/X2/KuSMkqbxRcFPqG4gvZdEEHLrVIaPa42FQArVotcs3cHxcza03hdGTUllBOYrQq8jpCNPat++Bi9RjAa7FcWZXJXy/rOskJoWzuQCbQaigCXLdCoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLuWc4VdonxYcSp7jQUYGIq1ddLLNcDF9Wbpks8/+X0=;
 b=TAXGaNmTbbJfQlQRMUXPVr+hkVrHWQNqvHy4yQHlMO52JnR7tsko0+nChwVx4AyXnCk7IKs7FQvRey027fwaKebUYUCdPRxbVzouEQxsKhfHX59vlqduzrGZWgjOaW9M7sGHt3vml6Qxtg839AE4RvhpPIIxoyhaCKi3hn6taCw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH7PR12MB8054.namprd12.prod.outlook.com (2603:10b6:510:27f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Fri, 20 Jun
 2025 19:20:28 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8857.019; Fri, 20 Jun 2025
 19:20:28 +0000
Message-ID: <a0ce9850-cde4-4e17-997b-ad06a76a23d6@amd.com>
Date: Fri, 20 Jun 2025 14:20:26 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto/ccp: Fix locking on alloc failure handling
Content-Language: en-US
To: Alexey Kardashevskiy <aik@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Michael Roth <michael.roth@amd.com>
References: <20250617094354.1357771-1-aik@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250617094354.1357771-1-aik@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0133.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::18) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH7PR12MB8054:EE_
X-MS-Office365-Filtering-Correlation-Id: 80a9d22e-1fdf-45e2-8408-08ddb02f83e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ODY5VGlEU2x1bDloUy9BcmZxMnF3V0RRZmd5ZWlrOGY1VEF0MGkrM29uOVdt?=
 =?utf-8?B?S01YRGtCd1B2VXhhcVYvQkp1bWU1cU5mbG1IOVUyNkplcnVpRmhJemtOS0FM?=
 =?utf-8?B?SUdZSGovNlB3ak03alpkOHhVb0FONzJEeFFPdFZZczdua2I2SzY5Z0UyRml1?=
 =?utf-8?B?dUlzNnZQNUhuUEV0WlNyUEwySDVqWGtnSmdqbDBZVUxBSTZ1aVplMWY0dHhH?=
 =?utf-8?B?T1Vkdk4rcmd1Q0RrdFd6TGNCSEpyb0oxdnpjV21YVWRCWGlGVE9JanhHRkhM?=
 =?utf-8?B?eWp6dHN4L1FEQUhkbmlCZjh0NFI3Q2ZzbTViRDRPdWhYQ01rWFY0dTMwZWVS?=
 =?utf-8?B?aXVQYlRPbEtLcE5Tc1FNeHZUZ3FYUGVJaEFCVHpyUE94THY1VmcwQzFCN3Bk?=
 =?utf-8?B?NWs4Q0dKbytlVnkxcGhUSk1BWFRMUEk1QTB2V09VdXNXRFgxOTN1dnJab3dP?=
 =?utf-8?B?M1d6NzJFS21sUGJtZ3lCWVpPbUVzR0V0VGpFeDVpcmdXV1ZYYmpPNFFQakM5?=
 =?utf-8?B?N3RQMWlPczFnWHluSmxrc1kvUGorRG1uNHNjcUU0UnRmRUVjUlNNT1JCS2xL?=
 =?utf-8?B?OVgwRWZhTGlRaFVrb3RXWTFyaGg1UU1WNXdNc1hySG9JL2EzaWNkMlQ2eEpJ?=
 =?utf-8?B?VnBFLy9HdlFWQUptL05CeitzSWVZU0s3NW82Ym1OYURtZVN0S0RucVZPZ2Qr?=
 =?utf-8?B?NUJZVlNFaDFpR3dodnVaeWlJNkFwM25VUmpXU0IvekJENC9wRVA0bFRNODZY?=
 =?utf-8?B?cmROK2NvQ2h4SDRFZmN0V1JUeU9WMVlzUUhzY1BNOHgwYUF0WWhGQ1creG1y?=
 =?utf-8?B?Rys4dzlTcXVoUXFEdytrOTB6TEZ0eUxtY0c3a2YzQTBjVkZ6YmtGQmdQYU4z?=
 =?utf-8?B?R290ZXlGbXR2WitTdmh2Zk1CVmVHd0NZWFV3N1k2MGd3cnVSN3lJNGpqNk5O?=
 =?utf-8?B?L3VtQnkwOXhTTjQwZWN1YWFUbmh5WVdzclFEYUFFdHdjS0lTbXVpUmorSjdn?=
 =?utf-8?B?NTBCazJJODNodHNvQ3pwYUNmRVgrT3VjRnlOSHQ2TUVYQzdGUWRteHBjRTlU?=
 =?utf-8?B?MDVUNExCVDZRYS85dXZXTWdkVnFKUU1oNy90ckRQdCtkbVVod0p4R0xvcFN4?=
 =?utf-8?B?S3ZjeW4yTnRvaEJrRTdwL3dmVUZyREdBaUZHcExJUmthMUZ4Q0U4SWsxTWVo?=
 =?utf-8?B?STFtOG9yWkdOYkh0andIR0pKNzdyTlNVUGY1K3l5NUJzejVaU1hJSEQ2bTlV?=
 =?utf-8?B?Vy9MdWxHSjRWU2tERU9JcWwyZE9OT0RCTnJndEM1ZzJsMTFWL2JFbWN6T3dV?=
 =?utf-8?B?amJMYmdSTFBxRkVDa1QvdDZsUmk3ODV6TlIxNGVWMnNsc01uMFRWcUdESnkx?=
 =?utf-8?B?eU5ybGZDZWF6RHF2clhTalFOTzE5a0FIeTlQL2NibjloK3lnMTRnbUYxSmRX?=
 =?utf-8?B?Ly9vR2hYNVhPWXA4NzRnRENYL3JCTXIxUU5NOVdiYmdmVHpGVlo5ZzFLaTRR?=
 =?utf-8?B?Q1JlS0dyckpuK1VKeTBqQTlUR0hQcmV4d0FacmVDbnhibGNTa3B4ODFEY3FH?=
 =?utf-8?B?dkFnUXVXcUtZd1c3ZU9qV0Fsc21QRXBHOE01UHJQYmtZb3JwZFNzVkhoYkFT?=
 =?utf-8?B?QnVsT05MMytkaGIvWEdlcDNlUkttaDY3eXZqa3Rrc2pmazJNcHVJdFVXVWtH?=
 =?utf-8?B?Yk5wWDh1SWRuNkVBcmNlazRLQmlKazJhRFpXb1Z6ZkFQMkk5VzFiMFlBOHdC?=
 =?utf-8?B?Tm00c2krbzZHZUZyTDA0bmxpSTc5NjJBbTIxYnh1eHVLL1BOc3Z2SmhCQjUz?=
 =?utf-8?B?MnQ1ajEwZXljbHNDR2JFRXhDN29wdkpwN28rSmliRUl4Tnk2Q2NSVzlmeXVh?=
 =?utf-8?B?VHpDNENQb01BZnV4T3BvVkhNUUFEYm8rTUdMcU1mRUVGT2dVOVZoTHpNMmxY?=
 =?utf-8?Q?o8Rjy9tU01g=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djhUdVlBNlpNbHdRZTZySWpyRm9MT1JNaVZ3NnFOKzFOVXRxVlVIa1pzWXpp?=
 =?utf-8?B?UUlzOWNWWGFPTkU0RTh1SlpwQTJLbWNycEpqMVNqR3NDTitBYnRRTHMxSW1Z?=
 =?utf-8?B?dmxkM1NlNFR4WFd2bVdmOG9kY21ZeFMzeTVUR2ZnRmNrc0Q5Lzk3ajN1eHps?=
 =?utf-8?B?RzY2b1BlTytmZzBYc3I0RVdEbGhqVzk4QmdxTzBBWDhhQmcrT0laaWMrT2tw?=
 =?utf-8?B?VXBhSTFMM2ptOWhMRGxFZmpDKzQwSlVvamJKZGRRRmsxaFR6S2R3THZRWkUv?=
 =?utf-8?B?TnRHSk5TUWZnUnF6ZEh2YWFhWlBCZ3EzZ1Q0WCsxUGNoRVBvbERoeVp2OUc2?=
 =?utf-8?B?ODN5N0NMK3ZTRWl1cnB4dDdEamR3S010OERaTzJveHdEWHc3N2RVTFVpT3JB?=
 =?utf-8?B?WDgwazFDNnVmUllENnQ0dG9qQml4dFRPdGg0RHJkUm5naVE2OEFqWUFCcW1u?=
 =?utf-8?B?UTY3dGxGa0h4VVFHYjdFcDdKWG5rbEJkRUx3ckJBY1VjVHFsRTJaa1FMeWZw?=
 =?utf-8?B?d3JxTUJVaGt1eWN2RnY3SnBlbUZyY3hTT0tRRDRJMFVhVjFkOTRrVVFQMFow?=
 =?utf-8?B?OFBZNE9YVnFVbGkyRjE2MVVxMHJCOExKdGY0ZWs2dzlrdy9MZXo5cVBYL3Jt?=
 =?utf-8?B?RHYyZnZtWnpnajdTYUtWTVBlc05iczlUQTBiZ1BaWEZLM1Q0TGpNbVhyZW12?=
 =?utf-8?B?ZHpzRGttWFJCVzEveUlNZ21mcm9zZUJRaDk5SzZEdXo0eDRZam9RSUJFRmpF?=
 =?utf-8?B?QUxlZ3RhdUJvejVVSU5WQUs3bGFVWkoxM3dnZWpRWmMxbUZiQ3BKdW5XVU04?=
 =?utf-8?B?OU9pbEpHc3BUdWlvMTArSDd4TEhyeEJSYW0wcE1ZOGNHQ1h6Q083RE1XeE9u?=
 =?utf-8?B?S2d6L0Zlc0gwL0hhV01MYTNJdkRwU2R4Sk1rVHNSVzEydWlrNDZhVUhNN1U1?=
 =?utf-8?B?NHIxWkhCOGdqeE1vZjJxd0ZoWHBITlBwK0xxc09uMmZyUmVGNFZ4bWk1cmFO?=
 =?utf-8?B?VkFCK01QZU12QmFUT3JkK2syZkVhU3ZzYnJKb1ZqajIrSCtwUTl6WmRxWUpC?=
 =?utf-8?B?TitsSWdZRzJTTlRJelkwZXA1cm50UUFkYkxCODlkNC91d1lrV0FLcWFhZ2h1?=
 =?utf-8?B?dUtEeTYyWXdsMmlIVVIvNTZ0VHF1YWxTeFJpY01lNGJBUG5aYkk3MnE2T2p5?=
 =?utf-8?B?RjdsT2czQXBvZFJqR2pKS0h4bXhmaHpkenlCSEpiRHdwS3RmVXpLdXliYXJj?=
 =?utf-8?B?eXMxU2ZHajFrTkxucFlXVGYrTmU4K2NKOVhua1ZqcjA0WGd4d0UwQXlnZjkv?=
 =?utf-8?B?YWF6eWVKQXBiejhISzdiZWIzdkVUdjRKc0QrNU42d0UzejhXVW9kZEdYc1BD?=
 =?utf-8?B?emUrMFVIMXhLcnpqTWNtVFRWRytGVWpDemo1bm03cCtJYTdvQVFSSjRQRzNp?=
 =?utf-8?B?N0lUY0ZHMHhEVytMOUhYb2doMGlkbjJ2dWxneVp1K0k4SzRkcEx0ZDdUTy9Y?=
 =?utf-8?B?ak41bHpIeDFFVVRwYU0xSVBST0RnMjc2UkltL1ZmTnFqWGVSbGlYWnhJeS9m?=
 =?utf-8?B?K1ViSUtQaUdJSU1uUEFhWXIzWEJpOC9uYnE2MFFGaGtpWG1OME9uOWdZekFR?=
 =?utf-8?B?R2M3Tlk2V3lnclRkam11QUNGY1hRYmszakkrTmM4Q25ReHFrYzJ4UTdQMC82?=
 =?utf-8?B?ZXN4T0FwYjhHWlVnTEJ6RXV3bmxrcUJVZ1VnVCtrTHVKdXVTNlU3eHNCaXJa?=
 =?utf-8?B?U0dESDQxTlZybzA0R1B6MkJGMytMS2ZUVzIvT3J3SzlsMC9ETU1XSkFrTEdp?=
 =?utf-8?B?WlVpNFZCKzlSbFQrTXlqaFRYaEZKRXhUTkFsdzdHT2hUM3ovTHIva2xCbjYv?=
 =?utf-8?B?YUc0bnJjMUNLVENxNUU3bnlVTTk1RlBacittb0g1TkhMeGxMVlZTM1dJbVhZ?=
 =?utf-8?B?bzFPeDkrSm9Jbk1MRDFIYzVLQmo0WkFwaUIvcU01RkQxTkZMOG8yU1VIY3Ax?=
 =?utf-8?B?RFFEQkJMeFFhRVFubTQyd0swNFdESXJhbW1lS3V3SEg2WjZRaHZucUR2SmRU?=
 =?utf-8?B?RlBjNTE0eVhMY3NiSHFyenRvdEZBZnBFVlN6RjJZNVpEbHFWZlNDWkU4SXh5?=
 =?utf-8?Q?ZFMV+Rc5Qz6AjJ9AVdJ/Ln4qC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80a9d22e-1fdf-45e2-8408-08ddb02f83e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2025 19:20:28.1840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dEUbiR/o46gnWpPuVbtrBAHD808BcsjaOd/jn6snTd2t2Ssml+rv6FU0OjhqU/D+7nYAU+Q52YHkd3ytINmfMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8054

On 6/17/25 04:43, Alexey Kardashevskiy wrote:
> The __snp_alloc_firmware_pages() helper allocates pages in the firmware
> state (alloc + rmpupdate). In case of failed rmpupdate, it tries
> reclaiming pages with already changed state. This requires calling
> the PSP firmware and since there is sev_cmd_mutex to guard such calls,
> the helper takes a "locked" parameter so specify if the lock needs to
> be held.
> 
> Most calls happen from snp_alloc_firmware_page() which executes without
> the lock. However
> 
> commit 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
> 
> switched sev_fw_alloc() from alloc_pages() (which does not call the PSP) to
> __snp_alloc_firmware_pages() (which does) but did not account for the fact
> that sev_fw_alloc() is called from __sev_platform_init_locked()
> (via __sev_platform_init_handle_tmr()) and executes with the lock held.
> 
> Add a "locked" parameter to __snp_alloc_firmware_pages().
> Make sev_fw_alloc() use the new parameter to prevent potential deadlock in
> rmp_mark_pages_firmware() if rmpupdate() failed.

Would it make sense to add the locked parameter to sev_fw_alloc(), too?
Right now there is only one caller of sev_fw_alloc(), but in the future,
if some other path should call sev_fw_alloc() and that path doesn't have
the lock, then we'll miss taking it.

Thanks,
Tom

> 
> Fixes: 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 3451bada884e..16a11d5efe46 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -434,7 +434,7 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
>  	return rc;
>  }
>  
> -static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
> +static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
>  {
>  	unsigned long npages = 1ul << order, paddr;
>  	struct sev_device *sev;
> @@ -453,7 +453,7 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
>  		return page;
>  
>  	paddr = __pa((unsigned long)page_address(page));
> -	if (rmp_mark_pages_firmware(paddr, npages, false))
> +	if (rmp_mark_pages_firmware(paddr, npages, locked))
>  		return NULL;
>  
>  	return page;
> @@ -463,7 +463,7 @@ void *snp_alloc_firmware_page(gfp_t gfp_mask)
>  {
>  	struct page *page;
>  
> -	page = __snp_alloc_firmware_pages(gfp_mask, 0);
> +	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
>  
>  	return page ? page_address(page) : NULL;
>  }
> @@ -498,7 +498,7 @@ static void *sev_fw_alloc(unsigned long len)
>  {
>  	struct page *page;
>  
> -	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len));
> +	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), true);
>  	if (!page)
>  		return NULL;
>  
