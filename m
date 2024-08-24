Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2076.outbound.protection.outlook.com [40.107.244.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F30E3CF5E;
	Sat, 24 Aug 2024 18:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724524304; cv=fail; b=If943tRwK9ZZIP1+4NE3uQ5h0hZUnFjmbExxbCWmm70x2Ee11JlbaMfHT6kFHJF96z6L6rftmY8o5Gmve0Mz60/TfenzxCzAVIGEERxz8IeUKk4+i6JuHccSb11QBzUpU+9EToUIDe8Ng4SNkZu9CYS40mc5C10VvvkNuB3PWx4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724524304; c=relaxed/simple;
	bh=LgPSBgpmCVnY7Pf/p1cWOYbuQur3r7X03Iubq1zHw94=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BjqPJYmMlKMJX+utlRZo9ZvAo6CwVDVxI3FaQRU6q7qlBsojq85q9jB96gfHNMFZlJr/I4riHgIkc6DQfq/Fb3UnJ8GLF0Ra1w+r4QKHcLmZALSbKFNBH0u2CbwehOUYBDQP+m8QIFeOfK/dB7kBlfFXRhwj59wgwzQYmgluSGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b2AQkCoN; arc=fail smtp.client-ip=40.107.244.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b2AQkCoN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yKsxyhqrPHFUKLLdJcS6ED3S3Dsg4qFRWXtqsK2Wdd5qNWbWNAJ1xdbg1B8VO0qfq59HkEvuNLFlbJ+qVHk3FqLi/f8Utuj902fi04Ui1sdF0YbSeQxhBrKhww7p9QMBfj+slNiPM/3PBWOl8lgz3eJamIGlQvyAnVu3+V2YxnGgyEEHLloR7pNW4ysFODQXIElxrRDs7diXJkV8ELQQ6P0Wc69/T9CXUqbrJuiPNNPeaxfzpT1pOscoAtfpoBHK69j6nwRU/dRI8DYY4g61lwLpDY5/Hj6zd9mIStp/YzBeG7/m3dRetyHrQG+oOHhN1LVEnn2rcU7xTode2nOnjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WkPqv+EFZ+8hZNCiDjOWFQuWOGfanQNAkyzT9anFZNU=;
 b=aGekSihWCHFcZNnb2vu1sRaWgKdiZ71pL63Oomvp1HQyX3UeKYzib1H4qDOt+9j9RDbe8oe4IQ6ewwGTu7/JJ6axVT8OlQZHyV5tnNz9zc/IYsvPzuflz/pxDRngit+tDVbmRlqyBpClavD1NDndXfWAAUtVKLs1nSKZNhTX41nS8Nd9J56ruuzEcc6DtEPML4AksCAQoi20ZTpETSm6RBDwwUY3imtFoB0/rYroTufCp4xJ9ZwB0D3SgIDG6B4MbR63Vu7VFmPuAp7+9gfXPwPixlCi6KC4XLIIhSt12uvaUc//760SWeiGykHPF5dfXhICnj5Y3dcV/J+1h2GRxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkPqv+EFZ+8hZNCiDjOWFQuWOGfanQNAkyzT9anFZNU=;
 b=b2AQkCoNgUq6YqDDaYRf+/LXTRA4JItj0WJWelkhOquRT0h3EYUr5Tvo4y/2LIQGvFHWB72cAYYOROApwhNOUYcxGo/3vJlZsYYGIRJ42C7h+iZ/NpCyvKY0kkcJzYtg6/gpPb6RZKH3cAQKf4j5sXrkJfQhZxDZIkX+g6lGPG4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Sat, 24 Aug
 2024 18:31:40 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.7897.021; Sat, 24 Aug 2024
 18:31:40 +0000
Message-ID: <9c545db3-1581-18f0-3543-eb666e1a8eb6@amd.com>
Date: Sat, 24 Aug 2024 13:31:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp: Properly unregister /dev/sev on sev
 PLATFORM_STATUS failure
Content-Language: en-US
To: Pavan Kumar Paluri <papaluri@amd.com>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, stable@vger.kernel.org
References: <20240815122500.71946-1-papaluri@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240815122500.71946-1-papaluri@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0050.namprd05.prod.outlook.com
 (2603:10b6:803:41::27) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a679693-cbce-49c4-f0f3-08dcc46afe9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzlicSs0RHdFMHlBRFZ5QjZWVTFEMW53K3Qxcm9CeGRnWlExT043ZEFPbmtq?=
 =?utf-8?B?THFVSnVVVGxkL1FzR2ZvbzB1bXhkK0tYcllkVEduMS9WeGFjSTk0eGhJYko3?=
 =?utf-8?B?N0FDL21teUUwRUtjYll2T1JObGs5M00yalNTSjhqcVVHSm5DbVdzby9KSWd6?=
 =?utf-8?B?Nm5RR3huZHh6b0YwN3p1YnI3djJTZzNsZlZIdXd4YUhsUFg5cTBxQUFYR3BS?=
 =?utf-8?B?OXNXYWdpVTRza2N5R21ZWGFzVE1CcDBiYTdSL0VZVGl2b04wRys3bVJ5Zm1Q?=
 =?utf-8?B?Zk9leXdzcUR0bElzMENJT2VZTzZjZkFtV0tBWHdNVnFqVWtnWjZPTzlKVXJU?=
 =?utf-8?B?WC9NbnBJQzdVWDI5VEx6aVlXQlRCUmJwRjFRSENzWFNub3pheklOd2ZDZ0RM?=
 =?utf-8?B?NEllMWZRNlZiQUs4Q0t5bldzT3d4dG0vWnpGaTJJVTRWL3dqbkVSRDk4dGs1?=
 =?utf-8?B?bXp2MzdPcDZNVHZhZFpMREk4UUxCd2Y4L05uTTd2MjBPM3czc05pSnlQYnhJ?=
 =?utf-8?B?MzFBZk9FTjFlYUNVOG0zZ0s5KzU4OTRSL1JIU2ZPN1MzQlR0SC85aHY2Mk8z?=
 =?utf-8?B?bHR4Q1pCSERGUWVveFZLZG9hUWptamE0SzBpc1FDVzI5RUZqbnV3Zm1JTmh1?=
 =?utf-8?B?bld0SHFib3hydDVMbGd2Tzdla2VNd3NKQ2JXRnU4Y2N3NFJoZnUrZW85eTly?=
 =?utf-8?B?V3hmemJyQTZsQ2RUUG5yazRsd24rVmZBdkhtZXlBQVFHaXJJSnVjQlNHV2Ir?=
 =?utf-8?B?VGhEQllKMjVObGJCRG04Z2J2U1hNR1k5Z1BzSE5kRG8zMmpoUy85ekpWLzU2?=
 =?utf-8?B?cWliamgweEM5ek1MNXovcWlSYnFuZnhjaWUrSFMzQVNuRVVYUDUzZWlmV3JP?=
 =?utf-8?B?RENZUWs0UU50MisyalFPNS9yU1QwYVNkUmRyZ1ZNa1ZSNGlyc21tWWR5ZkJi?=
 =?utf-8?B?YVdsMkFNOGdFbEEvWUZUOG9vemdCWlE5ejI5VHlYN053V2lIWmpQN0lKN2Ix?=
 =?utf-8?B?djlpRDZjem00ZURWbXNFSlZuRG9wN1VuQjZzc0pRWTk1TkU0SDBVSXA1Q2Ji?=
 =?utf-8?B?TCt1cDZuRmQrSUFyMkdMN04wZXRxM2pRaVpjWTNnZ3drT3g5U0JZTmNFaWl1?=
 =?utf-8?B?dWpnQjBFaTc0M1R6N3RGL2dHaVozK0Ewd3hNLzh6dVdBYXBFUWlMU2FaOWkx?=
 =?utf-8?B?cnlYd3FPMlhSd2pKUWRwbUZaQ1o5VjZHTUU5djg0aWpnS1l1WjQ1aXVveWRq?=
 =?utf-8?B?eXgxazBCUVgwZEgrZ2ZoQjVrVmRzemNtRHRmN2tIMjRWZDdzajJhWmZWQ0VU?=
 =?utf-8?B?TFAxOUpJYUZVdVZ0d3hnWHBqNVdWS0xBcmNTK0FiNVRQalFXMTNZeUFsN1l2?=
 =?utf-8?B?amYxSkpJK0dJRTF0MGRZOGY3cTZWRDVwRU9nZ0ZjTGtuSnlhQXFQeXkyVmZu?=
 =?utf-8?B?SVUzdzltTkROMlR4MjV4STdHZjN6N2tsRjhCYmJvSjBqOWd2VzRFYjdFSS9Q?=
 =?utf-8?B?S2liUnkxVWtLeCtLTDFZUnN4MWxiN0k5QWtJbCtMZE9NOGVqem1nWE9Kemdz?=
 =?utf-8?B?S3hScjhZSDBGK21zNmNsMFZlRnc2S1RteGJ2ell4RFpRckhLYXpsR3l5RVVj?=
 =?utf-8?B?WmVMSVZGOUJ0andWclBEbERSb3F6YTVtRSs4ZmZNNDUrZ0ZDdGovc283MUZN?=
 =?utf-8?B?ME9kd1pReUhTMnJpUndGcHNnRml6N2RjN0hjQWFIN0hTZVNCamlGalllQ2JX?=
 =?utf-8?B?R1RBd05paTVzT0FlNWFkNVZsSXpHZjJXcmVJanlkSlN0bVdyaVJ4TkR1b2Nr?=
 =?utf-8?B?SWp5YTRXa1RjZkVObGlDZz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3g1a0VvWlB2QTFaZkovMVE1OG03cnErNWtTZk1GdnRQbzJjTzF2SEJvb2Za?=
 =?utf-8?B?KzltcHBQQWJpRjVlT0V6YWRMOGFkVk5HTTRPdS9XT2QwVU9KZFMzbjRrdDJ1?=
 =?utf-8?B?OXVRQ0FEOWFSWjJiUjRzaCtiSHp6ekJNS1BlRGxxOXZ3NGovaTNzTTRGQm15?=
 =?utf-8?B?TTN6Si9iOWZiWGFJSGNOV2VuOUNHRHY1Wkc4dmNjVlRUU2Znb2RRL003RjZ2?=
 =?utf-8?B?MjRhcURuNDdCVmY4cTY5bXFMa1orZkZ2L1JhMUxVdjJXb09RWUpoVG1rOFhm?=
 =?utf-8?B?dkZqeEdMZCs2VnNObFhSaFhxT3FUbGZmeXRjcDhsMTdXblBZMVZ3bFVIR0ZY?=
 =?utf-8?B?VXhGS2pLc3lwcXBuSTZEZHhZWnQwSDkwdmZoWC9aRnQzaXdML0hlT1RscElt?=
 =?utf-8?B?ejRveW5TdzlER3RGamlieW1EZXhoQkxrck15TXNWWmVMZ2xSektWemk1alk4?=
 =?utf-8?B?U1FxZ1RaRUhHcVpTdG1LdVUyTXJGSkNCNHdVdWFOcHVVUEw1a2hGRnRkRFB6?=
 =?utf-8?B?Skc4dEpZL1BsVHViSGtYS2NQL0txT3BzYXF1S2hibEthU2UwcDQzVjUzYnhR?=
 =?utf-8?B?NmtNaG1MWTUvOVE2ek5OSlRTVDI5RmNmYWFmcW9EYnI5K1g1TmhxdG9JUnM0?=
 =?utf-8?B?dk9XbS9YcDFYSmNDTXQzQm9aT3FxNWhnOXljUHlxTy9QSHkrck83NVZhYTBU?=
 =?utf-8?B?cXhnbUdnOSsraDQ3Z1hSS3UybEIzcTcwQXJoTm9oWFRTK3pncmlEOFNiQ0Fx?=
 =?utf-8?B?Z0ZxNlFCb0Jvd05nRUZlTzNlZVBzZ24yaUpBNGdWUnQyT3NSUDcwQmxRdnZL?=
 =?utf-8?B?WWVMUkx2MWdTcWJ0aTUrMnZTbUgrN1pMU2NYZC9jVXB1NFl0NG0yQy8wZzdl?=
 =?utf-8?B?ZGMrTFJtQnora052bDVObDI1WTRUc3h6eUZZQzJQYTB3QTd4ZXNqZnF4eXhX?=
 =?utf-8?B?L2FVS2dEdlRVcUtKNUVxUmdrMzltQzVOa3VHaXNIYitUQTBBWjBVUjdvUytj?=
 =?utf-8?B?NDduZXg3Z3dqdkE0VDlNTmY3TWZ1L2lrbHo3K0tVL29qUEJnT0FESTdFVXVL?=
 =?utf-8?B?YXdIb05JZWYxRGhwTUVIQjJLSEhhSDdDUURpRUdBTWdrc2Z2VEwreG5iSXB6?=
 =?utf-8?B?UCtJeTd4dm9DbVptcE1EMjBrcUhXVXJQaGhtVEdZcXlud3Y3T3JkYnFxcnQx?=
 =?utf-8?B?T2RWMFVnNm05a1E4MS9nYWc4RTZNZEJHWlQxZmpZQnM3OEc1ZEV4TkRRbzU5?=
 =?utf-8?B?VVhEQU1ERXNwNEJRb2xSSlV4aFkxclNRZU1CVTQ0dGc5eXpibEJxd1JPd0lB?=
 =?utf-8?B?Z04zdVlYK3JQSjF2U2lhUFNXTENuQXBwTDl4OU9FUjNvZCt6RlE4TVZwaytJ?=
 =?utf-8?B?WmpscjY4Z3k5MkRNYk0vZk1wVWxuQUVCV3RTN01Uek05QzVqakJiYVkyM3c2?=
 =?utf-8?B?T3JYMWJQNlZCL29meTFyQm9ZUU9mU0VabTRINTBFN3RiRlZCTE4xM3NoMmJ0?=
 =?utf-8?B?OW5rRG9hcGlkY0pLV2lvUnFkZUsvdHplM2VJdXBySWVGUG5COHYzUm1MeUZ3?=
 =?utf-8?B?cXQ1R2N0RE0wZCtOb01uaVVsVUxHTXk0MThIZUNnWTg3QUhaMTJyVDNycTUv?=
 =?utf-8?B?cUJFM3FJZ2hxbFBuWUpiRXlSQkJ1aXdKQ3ZRdC9Ba0FuSXlTbVBOelZpdkdB?=
 =?utf-8?B?VXJheE1kczJZOWNqaTJZRVkycm9mQ3lrTGMrY1A1MkZQdFZaYzQ4cElZSHgy?=
 =?utf-8?B?VFkyc2lSSC83V3pGQ0Vsc3RxZzZRWEIwYnpFMFd6QkxqaGYxZXUxTXFyVTdG?=
 =?utf-8?B?ckd3RlE4MDFRVEV3bm1qWGMxR3NYTWZndlg0NEpKam45cUxhc3E1TG5nYUhE?=
 =?utf-8?B?bnVaZk4yK1UySi81emFaOGhZRmdRQ05sbHdxT0FydjJrN0xaWTRGRnlVa1A4?=
 =?utf-8?B?RjdNbE41Mk50TFBIeEFScFVPWW4xbnlremVpV3BIQktERmdIazY3ZFErRVk3?=
 =?utf-8?B?K0FXb0d5OUFmb1NXK3RPTm1wM0lWWEhqZUF1N1BablRHRlhYOTVtZWFseThx?=
 =?utf-8?B?YzhRMzV2cmxKL3preVZEZUdETDNUMlEwQkNGMGlIUm9uSkQ4cXZpUDNTWVdC?=
 =?utf-8?Q?CeyDmJKFEmYAyKXh1W0cJSQCk?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a679693-cbce-49c4-f0f3-08dcc46afe9f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2024 18:31:39.8759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KePxZeL1L2L0GloXjHu/glpwuNj9gY148lSBlq83oN5aRTu4i/sLqc7YczmgPxra1REPJT9zH7gV3yFC4GnZOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719

On 8/15/24 07:25, Pavan Kumar Paluri wrote:
> In case of sev PLATFORM_STATUS failure, sev_get_api_version() fails
> resulting in sev_data field of psp_master nulled out. This later becomes
> a problem when unloading the ccp module because the device has not been
> unregistered (via misc_deregister()) before clearing the sev_data field
> of psp_master. As a result, on reloading the ccp module, a duplicate
> device issue is encountered as can be seen from the dmesg log below.
> 
> on reloading ccp module via modprobe ccp
> 

...

> 
> Address this issue by unregistering the /dev/sev before clearing out
> sev_data in case of PLATFORM_STATUS failure.
> 
> Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
