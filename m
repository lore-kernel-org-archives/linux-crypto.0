Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2053.outbound.protection.outlook.com [40.107.220.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5951D9A48;
	Tue,  5 Nov 2024 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730840801; cv=fail; b=lWWnSjpb10+QDtyaYhIj20YiObD28Hc47+6EXcMcUjbLeiNGbh1eHiaJVuQNjcFbg5MLa2BDrR7PSiuGWuULI/bcAQT+zHfMXXz/CBMM0rB78bzcyDRoHh8b3CiMz1bf26vlHMlNKRtwb7VIUlkF4+y0I+Y5Ov2xTvcNT4ji95g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730840801; c=relaxed/simple;
	bh=H7XXVX/knbhHHsy7glChgAQCkmjVwxIgLt1ndT554BM=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=RXNrjvEhAZfiytQ9dq0qsZ/0TplRfRHbPfbZPpMRRVYvKk3edFyLeF5ev3JhMUfO+IRc+gQJypzFEjbukW6v0bmMjegnGeaG9VapJ39Y6nAm8TamdFoE6PBO2MGe5xcdgSnEkrhrVsizs5azmAiG1H8qgHbBsUA+UudEOTBoJjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rqb8rjXu; arc=fail smtp.client-ip=40.107.220.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rqb8rjXu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yjN355WayZjJ3KyRslhprL1Lb6DM0kken8kS7JWlP/lW4quYijwZMWUiZ0L2ZcHnB60RFB4gxWPR+hScDBQknMKcQI0TooYDv2Ov6xyc9EcAfyngpYahEJne4HknJlkG+yuHP/4psRoRsRxVKH3zq/vC/xz/m9va2yZbVzwE8ojK5t5iBMwRogCo+Wrd8gUw13HgtnoQ5lV+lNQ73VmWgxFsvR3WCyMasY+YaCZ+BS1/u5qJHcGtwb3hRC8rEKPTeb6ea2EphHW9D/uZzP84y4+gSUzELLqepFxd5q949T2dZ11QOLAvkIf9CN9M2dFoDMoiN+YqIAloCUpEgq5aow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nY3FNUKMl93lpykl+8N6hxkl3T/k+8SVfJY2TdXiyo8=;
 b=gp7HMY5m3O5e28AjfAPURi2CoWz3IQYcf9xlqr7p5ttIt6BShBBAZNVVYz1R9HzzYqrgdjQ2kSvRCDlw6g8hQBxIs8/lvE0C2Hm0Hw3MBv617/CftEBYl0CzBZ1t6rnYllbLdEALeykmUde8qI9ZrDIhpJMl5K6b92l2v5pIltvspZ7pY3NwjkwJVw+uRvT4ahAYQxvsOZBj5QJipGd5t4JKonFDUNVDNAkzhPnx4Z/fhtgncjrG/gwok/xMWUu+CG84+SQhipoNHoTgvIs48fjSLG45sNP4ZM0rlvADPQCvsfrYhPXHrHMIMZn6l3Prfw5axXrnqmCl9Psmgnwcaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nY3FNUKMl93lpykl+8N6hxkl3T/k+8SVfJY2TdXiyo8=;
 b=rqb8rjXuPpQ5VJSgPjF7UKod2MH+2dasY3msbCN8nufyQfBx0NbNt2CTZvoyvhcNWCCvTj5bStYXFGpi/SjCO3KPY2b2CSxGc5y+taCkF+AQ4QXQFZghfu7omkAO9BYNEOpKqMaF7lVYswjq5cVCp95mI7mlu0wf2RvthoE2m7Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY5PR12MB6624.namprd12.prod.outlook.com (2603:10b6:930:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Tue, 5 Nov
 2024 21:06:34 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8114.031; Tue, 5 Nov 2024
 21:06:34 +0000
Message-ID: <7a8a20be-3942-5d5c-719c-2e02d0a85b6c@amd.com>
Date: Tue, 5 Nov 2024 15:06:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
To: Dionna Glaze <dionnaglaze@google.com>, x86@kernel.org,
 linux-kernel@vger.kernel.org, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Ashish Kalra <ashish.kalra@amd.com>
Cc: linux-crypto@vger.kernel.org
References: <20241105010558.1266699-1-dionnaglaze@google.com>
 <20241105010558.1266699-4-dionnaglaze@google.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v4 3/6] crypto: ccp: Track GCTX through sev commands
In-Reply-To: <20241105010558.1266699-4-dionnaglaze@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR13CA0151.namprd13.prod.outlook.com
 (2603:10b6:806:28::6) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY5PR12MB6624:EE_
X-MS-Office365-Filtering-Correlation-Id: 2208589f-7aea-4a38-4504-08dcfdddbac0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ull0Vm0vcnp3WEZqRVg4bFNnMVAyS0lsU3o4eFY3UUhDcmNnNHNodDhORjJh?=
 =?utf-8?B?RThrRWl4T1NrQys4bHFrYkd2YnlIWEI4a1RNMGNiWTE5VmNBbGdBeW0ydXZp?=
 =?utf-8?B?TGNQSkE2eGZTdXN4T3RnR1pOR3k3RTgzODVVMEc0QVRqN3JJc0YyZXdHeThp?=
 =?utf-8?B?ZWt0RktOdXBzbmRQZFpnSXVGMHZqTkdKYVBSWWtaU1NoVk13aHdHeDlMZmdl?=
 =?utf-8?B?STZMNXNEWGNGQ1YwQi9IM2Jzd0tWUzFPdGZSUXZTTWllYkZ6SytIMi9WVUlX?=
 =?utf-8?B?TEtFWDAvUFJEa3ZFdW9CYVJqbml4bFlXY3BqVEdKMFU5dFZIR08wTVE2NWxt?=
 =?utf-8?B?dDk3SVZGa0FKL1VjS053OVUwVHFLSk84cEQxeU1ERVdTOE5FaDJ4S2NsSlcv?=
 =?utf-8?B?ZWM5YkF3V2xaUlNXOHNBQkdrZWJ3VEFRYTRzTHFUY3RVNVQ3eHIzWlBSRzFp?=
 =?utf-8?B?WHZZM3oxUENYMUNLdml6N1VSeW9QR2d4VkFEczUvdnFoWTFCZGM0V241bGpJ?=
 =?utf-8?B?L1crVHVxRzZTVll0Rm9IVUxXckxiMFdCajlCRy9jM0I5RXpkUnh4Y3NLQnk2?=
 =?utf-8?B?UDJ4T1QvMFRoVkRmdDc4cHFLUVd3V2NacDViU1A4bUp6ZC84OFJKa2RYRnAy?=
 =?utf-8?B?NnpoVmNVcE5Nc3lWOWNVOTQzNFBSM1QzUzF2UUtZNHJzaG1kbFZ3VlJmMy96?=
 =?utf-8?B?SmxSL2tQQllZVmRtUlp3UFpFZW9lakxpeVpiRDBDZ1VHTmw0V0ZCN2dRWUdC?=
 =?utf-8?B?ZWZZY3BuMG1KVmppNVVBZEFqb0M4alhsT1d3cGFJUDlPYkk3cUxLZUtjUHho?=
 =?utf-8?B?ZzdDQmpibTNXc0x5RkFnYmoyMWhoTjRnYk94bk95MkxYWFBiOGxDbVdrV0s5?=
 =?utf-8?B?Tkc5Nk5UTkhKcVhRc2JBSnVIWS9OL0h2UTdnWGRDVXFxbzVCRVJQL09HeCtF?=
 =?utf-8?B?Wm8rMEhMUG9hMnN0QlRveE9DUmZ6VnFFNEJncmx6U0gwVGNHbnhGbWtINnRi?=
 =?utf-8?B?NElVaVcrVjAybHpRaTBwamMzc0FaY2VXOVBYUG1oQURQeGVPcTJacXo4MFZS?=
 =?utf-8?B?OVJnbnRzSmFvMlJzeGJRZmZ5OG5JUUNodjJGODJER1hWeEtPL0pKSUNjM3hO?=
 =?utf-8?B?SmZzT1lJOVdFWjVpQThnRVZKMXBWUzdhdC9xb1E4N2t2ZUxhMERETWZHWk4w?=
 =?utf-8?B?VVdzM3g2ZXR5Uit4emVzZmpqSGtkMVh4RU4xcUIvMUJ1ZVpxdUxpTTdPRVBP?=
 =?utf-8?B?RTVEZUExU29nOFllU2hiSS9USmtpYmhyL2ZpeHI0TG9CUXBlTFBwU2xRUVo5?=
 =?utf-8?B?MDlmUitML1BZV1RtZ0YzU3MzUGlLM1UvY3ZWN1ZocGl4RnI0MVo1dzhiWDZG?=
 =?utf-8?B?bVEzaE02eTc0VWNwdVFpSFBQcHM1Tk9DSCs5R2VHWHh5ODhmYUxud2ZxTEp5?=
 =?utf-8?B?U2FReVhxeERNZ1FxYkNBV2htMGNpRm4yeUwxYWhjVkplZ21zeWVqVWU0YW9u?=
 =?utf-8?B?OVZmdkRvbkJ1dTlsR3YzTTVaTEd1R0ZKbCs5ckNhWWtlS3NIQmZZZDRNbzA5?=
 =?utf-8?B?a2NabmlZSTFTYitkbldkVDRUQXcxdEswVEJVaGFhN0lJTGpzcEducy9nQU96?=
 =?utf-8?B?bFBNaHZuVWhvUm15NnpVcS9lTisvOWg4ZmhlRFp6M0hqRHMzMGwzM3VEUDd0?=
 =?utf-8?B?WmNVWXQ5UjdIODV5QjlZRHM2L1YxRWpDZzFaNURuSHhYOVBJSm5rYXMxRkor?=
 =?utf-8?Q?ZydFEQvsmSzUkV4DKbpYJtySWn0x/asShN9Wpbo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cVdFcjU2OHd5eEFEcUI1UncxK1VjOXRtckIxVW9pRk0wVGVaTVFoemUxL1B3?=
 =?utf-8?B?UjNETVhYdzlPRXhrQVZtM28zdkFoUm9iakdsUkE2aWlKMDBpTElZWWtleDZR?=
 =?utf-8?B?dGhoNS9TakR1ZEtQSUdnL2tRaCs1UmU4K1hZMzNQaVRyU1pueEpTdlJocGpn?=
 =?utf-8?B?YnlnK3FPamxPV1RMQ3gvNFRETGxHKzRxZGpZR3pSenVlY3gxdkxaKzlwMk0v?=
 =?utf-8?B?SmV2a0tBZlJpWnh2QjZUKy94UHhYb24wd1BtZlMrYjhCTEFUa3BkdW5kVDk2?=
 =?utf-8?B?ZWxGNDJoRkdFZnpINE4wcE1KWHdCWFM0eEpWTWJBVDBhQW9rSzhEeHFKR0xM?=
 =?utf-8?B?U2hEckovZ2t1U05XSWxvZVV0MUVyeTl2YlliUk5DNnYyb2VaSFZXUUozUkZS?=
 =?utf-8?B?cEs2R3pUMzJOU0ZrYTNLc3Y1RE9iUTU2V1pOUlR5a2FOVUp6UXFvQnlqVTRi?=
 =?utf-8?B?MjBWVjZBYmlxdE9OOE9OMGZZN3c5OVg1NUxDTDRiY2g4ZmJmMW9hd1VVN1JF?=
 =?utf-8?B?RHZGR0FxWG5QMjE5V3ZPejhnZFVmd3RuQjE4QWEzR3Bpa2hHVy9zamxkNWQ0?=
 =?utf-8?B?R3ZtVEtnZERyVkZ6SXR2NXBXR0lHRTF4NFlvNG9HQ2t2bEYyR1Vod0RuSU0v?=
 =?utf-8?B?YkJuSlh4SmUvYjVVcEhwMHhZR3JKQnZKTXhVVFBweTZMTUwyQXppQlhZQm1C?=
 =?utf-8?B?MUx4WG1BSUYyM2x0RWhoc1dSaUFpOENWdk45dlJ6RFZtM1RoVjBFcE5tSHhN?=
 =?utf-8?B?RlNDUDh4VWZPUzBWRkM0QWJqSUZQSHBMV2JFdE9Ya3RJMTF4eUdTZjRrTEJv?=
 =?utf-8?B?bFpYSkYvM1R1RW9TWHh3Y2taRnpiSkk4RkVaaFp6SDZrR0FQcWl3NDM4d0xQ?=
 =?utf-8?B?SFpmMWxNdHQwWXVLNmFHSWJNQzFjdzVzYjk0cjJCNHE0ZUF0MXBBSU9pRVRH?=
 =?utf-8?B?NFNVVHNLWXdCaEdmdkRrdCtLQUs5RjNxSlAvcExPQktwZDFVMVd1Wm9OQlV0?=
 =?utf-8?B?Vy9yL0h0NVY2ZEdZNDRrTmJ6T21aZmUzajdJNHJyeW90eDRHeUpSWlJHaG5O?=
 =?utf-8?B?eU1sRHArRjdWYXBkaFA0aVhrM01kL3FWYndoc3BEK0lBQTNrWlRtSm1UMWls?=
 =?utf-8?B?U3JKb01rTnR1TVFqaG1DcFJOQ2tucFFrUXA1K1JZMDdyTzNjSmFSRkpLWjZh?=
 =?utf-8?B?WThOMngyNnJSRU5MN0pINlIrUzVmK21OR0VyWEQyWVZDSHdaSlpaYTNIRy92?=
 =?utf-8?B?bWlDRHBWUVJkR2NKUE9nc2wzWmhkV3NMSGtsTWNuaTA3Sk1ZNTNPVnNFOE5k?=
 =?utf-8?B?MkkxeFR5NVVxbDg3WjhhVWI3aVBJL251WTF0c0lvM1lVdjRCRnNpNU5lcVZ0?=
 =?utf-8?B?dlNXN2FiNFR5cytrRFBMcHFIZDV2T014cTdWNkg1dERiZnp1d2E3Nk1TVk0w?=
 =?utf-8?B?dmxpdXNzTEVWc2xHR0g1bEVESFhLSXJhdHhFNWd0RmZxNDBTK0ZnQWU0UXIz?=
 =?utf-8?B?czRiOWVkQ3M5aGZVVWR2bk9NQndmamdZRVZ2TmZjc09yZ3BsZnRFY29tSHp3?=
 =?utf-8?B?aUJBR2NlTEpjUTRseGI1RlR3WkFFUE9jaVNsWisvVDVOVElEa0NTcTBBa0NV?=
 =?utf-8?B?WHFmd2pPTit1ZTl1cnB5SitVcXhoRHZVWU9lc1EwSjNiOG5Fa2RXNlBaT00v?=
 =?utf-8?B?SWp1TXl5eUhIbFUwUVQ0QUlEUkx2eGRiOUdxM3BJOFh2alFNeXhIMGlxK2Vw?=
 =?utf-8?B?VEU4MElhVGl3ZlZJWnFoNVZOWkVhQVlpOC82TDZpZ2sxMk9zOFlpQWgwZFZv?=
 =?utf-8?B?N1J1d21pR2VQOEQxOTB3UUJZVmRBU0JhNElOaE12MFp4clNvYjZ6eWlZdVk2?=
 =?utf-8?B?Y0RTWjlPbGN6RVZFSHZlUmdLTElpcExoc3E1WWdRU3p0Z0VQcEIyV2tyVXQ0?=
 =?utf-8?B?TlIrNExEelE3VHk0WUNDaktNUHRtYm5BM05VTVZoL1VyVlFGUkZybmNYVjYy?=
 =?utf-8?B?WjdMaWNTQmZKc2Y5L09YWWFuamZhRDBYTFh1clFPREhNaVBsYzBzZVNtczY0?=
 =?utf-8?B?QWNXRU91T210UjJGZXBrMWZpOWpaZUcwS2NvYmZRSkk4b1dUU1RRb3hyMjF3?=
 =?utf-8?Q?/gK5PBldEML6ncKoiOuluu4uw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2208589f-7aea-4a38-4504-08dcfdddbac0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 21:06:34.4751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BOGzfXgoQIvU6oYrzgi+QQNUHLOl5oBE4OQoQbNUpsrdXErxt+U+xbi1w0AV/UvssXtTjb5x7+kG/jjhs78gQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6624

On 11/4/24 19:05, Dionna Glaze wrote:
> In preparation for SEV firmware hotloading support, add bookkeeping
> structures for GCTX pages that are in use.
> 
> Compliance with SEV-SNP API section 3.3 Firmware Updates and 4.1.1
> Live Update: before a firmware is committed, all active GCTX pages
> should be updated with SNP_GUEST_STATUS to ensure their data structure
> remains consistent for the new firmware version.
> There can only be cpuid_edx(0x8000001f)-1 many SEV-SNP asids in use at
> one time, so this map associates asid to gctx in order to track which
> addresses are active gctx pages that need updating. When an asid and
> gctx page are decommissioned, the page is removed from tracking for
> update-purposes.
> Given that GCTX page creation and binding through the SNP_ACTIVATE
> command are separate, the creation operation also tracks pages that are
> yet to be bound to an asid.

I believe we have an ASID "allocated" by the time we call
snp_context_create(). And snp_decommission_context() is always called to
remove the context. Maybe a ccp driver API to create and destroy a
context would be good here. The ASID would be an additional parameter
and allow for associating the guest context page to the ASID right from
the start.

This way you don't need an snp_unbound_gctx_pages array.

I think it will make the code a lot simpler, but it does add an API
dependency between the CCP and KVM that needs to be worked out between
the maintainers.

> 
> The hotloading support depends on FW_UPLOAD, so the new functions are
> added in a new file whose object file is conditionally included in the
> module build.
> 
> Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
> ---
>  drivers/crypto/ccp/Makefile  |   1 +
>  drivers/crypto/ccp/sev-dev.c |   5 ++
>  drivers/crypto/ccp/sev-dev.h |  15 +++++
>  drivers/crypto/ccp/sev-fw.c  | 117 +++++++++++++++++++++++++++++++++++
>  4 files changed, 138 insertions(+)
>  create mode 100644 drivers/crypto/ccp/sev-fw.c
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 394484929dae3..b8b5102cc7973 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -14,6 +14,7 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>                                     platform-access.o \
>                                     dbc.o \
>                                     hsti.o
> +ccp-$(CONFIG_FW_UPLOAD) += sev-fw.o

As you saw from the krobot mail, you will probably need to create
something like CRYPTO_DEV_SP_PSP_FW_UPLOAD, which depends on
CRYPTO_DEV_SP_PSP and FW_UPLOAD.

>  
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>  ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 9810edbb272d2..9265b6d534bbe 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -982,6 +982,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>  	print_hex_dump_debug("(out): ", DUMP_PREFIX_OFFSET, 16, 2, data,
>  			     buf_len, false);
>  
> +	if (!ret)
> +		snp_cmd_bookkeeping_locked(cmd, sev, data);

I prefer to see this flow as:

	if (ret)
		return ret;

	snp_cmd_bookkeeping_locked(cmd, sev, data);

	return 0;

And if you end up creating APIs to create and destroy context pages,
then this call can be removed and each API call directly into the
appropriate tracking function.

> +
>  	return ret;
>  }
>  
> @@ -1179,6 +1182,8 @@ static int __sev_snp_init_locked(int *error)
>  
>  	sev_es_tmr_size = SNP_TMR_SIZE;
>  
> +	rc = sev_snp_platform_init_firmware_upload(sev);

Since this is mainly doing memory allocation, this should be moved to
just after the minimum firmware version check so that a failure would be
before SNP_INIT.

> +
>  	return rc;
>  }
>  
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3e4e5574e88a3..28add34484ed1 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -57,6 +57,13 @@ struct sev_device {
>  	bool cmd_buf_backup_active;
>  
>  	bool snp_initialized;
> +
> +#ifdef CONFIG_FW_UPLOAD

This would be changed to whatever your new CONFIG option is.

> +	u32 last_snp_asid;

unsigned int max_snp_asid;

> +	u64 *snp_asid_to_gctx_pages_map;

s/_pages//

> +	u64 *snp_unbound_gctx_pages;

s/_pages//

> +	u32 snp_unbound_gctx_end;

unsigned int snp_unbound_gctx_end;

> +#endif /* CONFIG_FW_UPLOAD */
>  };
>  
>  int sev_dev_init(struct psp_device *psp);
> @@ -65,4 +72,12 @@ void sev_dev_destroy(struct psp_device *psp);
>  void sev_pci_init(void);
>  void sev_pci_exit(void);
>  
> +#ifdef CONFIG_FW_UPLOAD
> +void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data);
> +int sev_snp_platform_init_firmware_upload(struct sev_device *sev);
> +#else
> +static inline void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data) { }
> +static inline int sev_snp_platform_init_firmware_upload(struct sev_device *sev) { return 0; }
> +#endif /* CONFIG_FW_UPLOAD */
> +
>  #endif /* __SEV_DEV_H */
> diff --git a/drivers/crypto/ccp/sev-fw.c b/drivers/crypto/ccp/sev-fw.c
> new file mode 100644
> index 0000000000000..55a5a572da8f1
> --- /dev/null
> +++ b/drivers/crypto/ccp/sev-fw.c
> @@ -0,0 +1,117 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * AMD Secure Encrypted Virtualization (SEV) firmware upload API
> + */
> +
> +#include <linux/firmware.h>
> +#include <linux/psp-sev.h>
> +
> +#include <asm/sev.h>
> +
> +#include "sev-dev.h"
> +
> +/*
> + * After a gctx is created, it is used by snp_launch_start before getting

s/gctx/guest context page/

> + * bound to an asid. The launch protocol allocates an asid before creating a

s/asid/ASID/

> + * matching gctx page, so there should never be more unbound gctx pages than
> + * there are possible SNP asids.
> + *
> + * The unbound gctx pages must be updated after executing DOWNLOAD_FIRMWARE_EX
> + * and before committing the firmware.

Not needed here.

> + */
> +static void snp_gctx_create_track_locked(struct sev_device *sev, void *data)
> +{
> +	struct sev_data_snp_addr *gctx_create = data;
> +
> +	/* This condition should never happen, but is needed for memory safety. */
> +	if (sev->snp_unbound_gctx_end >= sev->last_snp_asid) {
> +		dev_warn(sev->dev, "Too many unbound SNP GCTX pages to track\n");
> +		return;

Should this return an error and fail the command?

> +	}
> +
> +	sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end] = gctx_create->address;
> +	sev->snp_unbound_gctx_end++;
> +}
> +
> +/*
> + * PREREQUISITE: The snp_activate command was successful, meaning the asid

s/snp_activate/SNP_ACTIVATE/
s/asid/ASID/

> + * is in the acceptable range 1..sev->last_snp_asid.
> + *
> + * The gctx_paddr must be in the unbound gctx buffer.

Do you mean unbound gctx array?

> + */
> +static void snp_activate_track_locked(struct sev_device *sev, void *data)
> +{
> +	struct sev_data_snp_activate *data_activate = data;
> +
> +	sev->snp_asid_to_gctx_pages_map[data_activate->asid] = data_activate->gctx_paddr;
> +
> +	for (int i = 0; i < sev->snp_unbound_gctx_end; i++) {
> +		if (sev->snp_unbound_gctx_pages[i] == data_activate->gctx_paddr) {
> +			/*
> +			 * Swap the last unbound gctx page with the now-bound
> +			 * gctx page to shrink the buffer.
> +			 */
> +			sev->snp_unbound_gctx_end--;
> +			sev->snp_unbound_gctx_pages[i] =
> +				sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end];
> +			sev->snp_unbound_gctx_pages[sev->snp_unbound_gctx_end] = 0;
> +			break;
> +		}
> +	}

What if it isn't found for some reason, should an error be returned and
fail the SNP_ACTIVATE command?

> +}
> +
> +static void snp_decommission_track_locked(struct sev_device *sev, void *data)
> +{
> +	struct sev_data_snp_addr *data_decommission = data;
> +
> +	for (int i = 1; i <= sev->last_snp_asid; i++) {
> +		if (sev->snp_asid_to_gctx_pages_map[i] == data_decommission->address) {
> +			sev->snp_asid_to_gctx_pages_map[i] = 0;
> +			break;
> +		}
> +	}
> +}
> +
> +void snp_cmd_bookkeeping_locked(int cmd, struct sev_device *sev, void *data)
> +{
> +	if (!sev->snp_asid_to_gctx_pages_map)
> +		return;
> +
> +	switch (cmd) {
> +	case SEV_CMD_SNP_GCTX_CREATE:
> +		snp_gctx_create_track_locked(sev, data);
> +		break;
> +	case SEV_CMD_SNP_ACTIVATE:
> +		snp_activate_track_locked(sev, data);
> +		break;
> +	case SEV_CMD_SNP_DECOMMISSION:
> +		snp_decommission_track_locked(sev, data);
> +		break;
> +	default:
> +		break;
> +	}
> +}
> +
> +int sev_snp_platform_init_firmware_upload(struct sev_device *sev)

snp_init_guest_context_tracking

> +{
> +	u32 max_snp_asid;

s/max_snp_asid/min_sev_asid/

> +
> +	/*
> +	 * cpuid_edx(0x8000001f) is the minimum SEV ASID, hence the exclusive

CPUID 0x8000001f_EDX contains the ...

> +	 * maximum SEV-SNP ASID. Save the inclusive maximum to avoid confusing
> +	 * logic elsewhere.
> +	 */
> +	max_snp_asid = cpuid_edx(0x8000001f);

if (max_snp_asid <= 1)
	return 0;

Then the indentation below can be removed and the alignment fixed.

> +	sev->last_snp_asid = max_snp_asid - 1;
> +	if (sev->last_snp_asid) {
> +		sev->snp_asid_to_gctx_pages_map = devm_kmalloc_array(
> +			sev->dev, max_snp_asid * 2, sizeof(u64), GFP_KERNEL | __GFP_ZERO);
> +		sev->snp_unbound_gctx_pages = &sev->snp_asid_to_gctx_pages_map[max_snp_asid];
> +		if (!sev->snp_asid_to_gctx_pages_map) {

I'd prefer to see the success check immediately after the allocation call.

Thanks,
Tom


> +			dev_err(sev->dev,
> +				"SEV-SNP: snp_asid_to_gctx_pages_map memory allocation failed\n");
> +			return -ENOMEM;
> +		}
> +	}
> +	return 0;
> +}
