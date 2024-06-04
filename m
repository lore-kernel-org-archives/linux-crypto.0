Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A2514830B;
	Tue,  4 Jun 2024 16:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717518545; cv=fail; b=rbA+KCuNEixdmZ8KHy+zWd3O+SsbQiXhyG+R+zbOLR5ArAxAngkmeIaZSlI+Pu/kvfdRBcR1GxKI7fMH0E9N7uW8ce37l5m4AcbbYp8qmrQ5vk4dUfZLnweOVyVwnF19XZgBcPaq1bk/wL3Oyp0yjzPLeR3u9ui14hcmdTllnEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717518545; c=relaxed/simple;
	bh=12WGguNaM9mjQahSLWL9WFk1CnXCLNZeTFcJlrVML+o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mt4jW+mkSZd741tDrTNqa5m3IOj90oHvFlPjq0lekbXkV/v/kVXDCJMOG+ptBB5VvyETwhPSXWhxkHZzpNycG35QGJF2Iy2kAl+2UGQcIuiH4j+ZhpisodON6k1UO6+iThWxof1AgV7ux4paGN2juc/AcCzHIFj8gO9OfU8TEL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WjrlL7D6; arc=fail smtp.client-ip=40.107.243.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WjrlL7D6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKvAuU7rsSamErJkmfRGeK6iFaM6YhiJjbz0G2RtE05qO6uR7jERwKp8o+uSGJAXVtq6oxaySba5snfGJsZCptGvPGkTpGUUAPDAKLFVFGBHQUI+rDQZiz3FRhb6A6SbltsDOz/Ooqe4DEAnue2g9Uxx1aSA0NpVhebrDNQatr9VNedoAxLD+jp+FfbHAb8NAjNJca7p1cJHDBGO8YhJRbyQVyd3wKHekSA5Btjg9uNtKf1GQNUqhWL1bTzUk0mps8MgJGU7XcQY3MdbFFb5TtjWHsgyguaPvVL6EuI81EYbzjwGEnhQLZek6GM5v+udscrzxvPyP7GjB0DNbJEMFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BH0oweUn3bO6VT9Sgv3lMeAc9c992sWbMPA0q/6k5GY=;
 b=hRqphVPj5Gnv7DeeVYZ86y/ZBh8phcPFyeoQV43jdaGVzBOYkbDG2+HZQjRVTQQ47jWoZekGgRT7ppb9a6q9rAZIaWCpjPX84PtTh0EhcPvez3ZH6XyNAndYsY15yR/TZrHHmgTBr+UnVi5iah4SrHT6cjjuLkZLOsQV8VejWyxQNnNjl1t/1qF4gPv3rfbGGioI5XI22cq+dABirDSr3xLPRTz9oGPrmax1uZkA8KfxzonVVTjj6vRvdJ3oaMEj4muo50e1J4Tirq4hbKk3aXr4PpfcgQKhKLnt0muTG4wW8wy1o/rrepi1UMNtoUcPLMnNn2yUxC8WGGYjDrTRVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BH0oweUn3bO6VT9Sgv3lMeAc9c992sWbMPA0q/6k5GY=;
 b=WjrlL7D6dif7CrKU8ua3TzTaMIJhiZvpsGsw0Qmj97bFUcKdvKcpMw5jGdr6fllweZpE2PbHMdLiVXwVcTWsjcfe56fTXCFt2tXqvPjLkPzxkmvoPSdYq3MO1Fe/L8XVlJMF4mDubWXyTj/6yq34SCsae5fOG8PZyZ5PflthFCU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by MW4PR12MB7309.namprd12.prod.outlook.com (2603:10b6:303:22f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Tue, 4 Jun
 2024 16:29:00 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 16:29:00 +0000
Message-ID: <99c5b19c-a8a3-484d-9adb-b313c57bc1f7@amd.com>
Date: Tue, 4 Jun 2024 11:28:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] crypto: ccp - Fix null pointer dereference in
 __sev_snp_shutdown_locked
Content-Language: en-US
To: Kim Phillips <kim.phillips@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>
Cc: Mario Limonciello <mario.limonciello@amd.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20240603151212.18342-1-kim.phillips@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20240603151212.18342-1-kim.phillips@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0022.prod.exchangelabs.com (2603:10b6:5:296::27)
 To BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|MW4PR12MB7309:EE_
X-MS-Office365-Filtering-Correlation-Id: cc9a16d4-c3f3-482f-76d0-08dc84b3704b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NUplRHNsTE9OMS8xUFd3azNpenE4c2hpMWcwRnZqUW5OOXJCMVZqL3lGS3A1?=
 =?utf-8?B?L0NHRjF1S0xTMEtDQ28xc29wQ29aWWxGRDFSc0JLem1PUkRxc3hlRE5xQVhZ?=
 =?utf-8?B?TGhmenhRa00xL2lDZFp2c2hYQ3JjQlo3YTVPVGVxNll5L2ExdGg0dGJ3d08y?=
 =?utf-8?B?RE5XY0pRSVVlNUxVbGxFZEVqZUNBWVRXNlZ6Tk5JdTR2ckJnZnVXVDVjTXI3?=
 =?utf-8?B?azVKUVlFcUJObWx2Kys1VTRQcVRhQ2tqL1ZNYlRabmxyZmZRbVZXZS9pRUtr?=
 =?utf-8?B?cmZpM1lBWVVxNEFQbGphQ3o1MDZGZjZqRUFEYlN1UFd2WnZ6R1ZURXY3S1dl?=
 =?utf-8?B?U2Z5a1lQWmxCRVg5WHdhTXIxeWd2ZnZDRW9ZeTZGTWNSVlU3a1hQN2dubWtM?=
 =?utf-8?B?SmtvVGdoTWVnTTh3Qy9WSFhQYmd6QlJvVjVGL1ozM1NTMko0R2RFeHZEWW9v?=
 =?utf-8?B?MXBwT1BMWkt0YVFGTjRUY3FLWUlmdXNBcFBBYkRPRGFLWjdlZVMyZy9ITEJ6?=
 =?utf-8?B?NUtSOUtkWGQ5YzdZYXdPbW9tMCt0VGo1Y1pXbmdQVGtSVmtpdUhNZFpZcktE?=
 =?utf-8?B?ZDZ3R2M2ZDBEVWs2OGhZS1FEaitudFBLNEhhYk5LNmk2cG0yRDZQRGZ5Nmxa?=
 =?utf-8?B?V01TaS9VdkZyZGFWTS9ocUZwTDFNSGdOSlRkTmNzQ0ZmVEY3ZjEvclJkY1RI?=
 =?utf-8?B?dDdnVXQrYmZJSU1handBT3lVbDFpZUgwNjQ2S0lveTRqcDFvZEFpRzFjOXNx?=
 =?utf-8?B?NU5na3JuODFORDloSnF4TFYvRHRRbzNma2h6akVlendGR1Z1RkdxWXRTNExj?=
 =?utf-8?B?a1J2VEViQjBEWTdCYnZKSGswWUJQeGhHU0U5TDZ1UzhFM2N5RWN1bEZPS1dF?=
 =?utf-8?B?TDRjZURsY0FBRFROaVg5ZzRVVkdDZk1JZS85VzRRdCt2UEhOVW5OWlNpQTVH?=
 =?utf-8?B?ZWlGSENLOEIxRHZkV0lyWElJZk9zb1g1YTBkR1NrT1Riam9ZemVEdUR6V3U1?=
 =?utf-8?B?WHNlU3daaHNmVVNYRHlWWDcxdE53QlFXRHZlTUF4TWpRVDJVdGVKdStiQ2VX?=
 =?utf-8?B?ZGxnSkVRT0pYYmFyWEw0L3U3QzlOa0svUkJwQml0NTFkRUVIY2xHREp3Um1t?=
 =?utf-8?B?MCt1ang5OUlmZHdNeGppZHkxajNndzZDWEVHNERPOW5Sc1Bzd1JUa0xIaDVK?=
 =?utf-8?B?NGxZRlJiSVZzd3ZJUHRTL3FwaFgwWkQ1WW1kVUVvRjZ3dXd3Tk90cE5aR0Ro?=
 =?utf-8?B?ZGo0bm5sNW1CR2VaSytxV3M5bTZsMTRHOHpHOHU2b2hwR2tUSk90NGJ1bzhT?=
 =?utf-8?B?aW5Cd0toZHNKYXgrRmNjeEFnOG1mVXQyRHdtWENHUzNRcWhCUmZXYlF3TUVS?=
 =?utf-8?B?YWNVWUlFWXU3TlRqTkZQa0l5RHZ2L01INm1IY0hvcWl0cDZ0NGQ2UlU5akdQ?=
 =?utf-8?B?cmhaQS9DS3FUZ2kxOFlmVkhzWGx2SmNJZFk2VCtTcXU0dmloOG9Fem5BU0lE?=
 =?utf-8?B?cG5PRVdyWWpmY3J4NEhZeTY3T1pjQnhycTdlQnJ4MDdXM3VRckNQMWhLYlRL?=
 =?utf-8?B?KzNNMktTTHl0RUFUTTZkSmxHdXNXak5lQ29wRnUyZzA2VU1XaGpXaFZJa1pS?=
 =?utf-8?B?N0x3Z1R0UCtXNkdtMXd5aFdOdWFRSG9ZT2lrV2dVclZ1cEpTajZJaU1TSitv?=
 =?utf-8?B?TERhSjlnVy8yMGlvOFpWMkxVZkVqekFZRjBlVy9ra0ZwSXJKZForQmh3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K3o2aEZ3S280aG5Jb3ovbE9xaUhsaWV2UHNHbTJGaFkwVjFRekcySWpDVlNL?=
 =?utf-8?B?NmlvVFJkbmtqRDhIa0luVnZvNzVlaUh6WTNHbGZpZlFHS2hNeG5NckVSSmpC?=
 =?utf-8?B?TnRvL3Y2dnBZN0V6Z1BKeTcwbHVXYXRXMFVSK2Izb1RsNXNtM21tV1JyTnlF?=
 =?utf-8?B?Mnd0YitrOWhhOE9VMTVCSk9YUVR6QTNneHVnQm52dytxUkJOcjREYnR1Rmpt?=
 =?utf-8?B?aW43MFpCZUlaaTVPbVA2T3ZvOUxMa3BaRXErRmhoQ1JndnJHbHA5ODhBc0ZP?=
 =?utf-8?B?ZUFXTm43V3ZUMFE5d01WN3ZyYllxVWVzMHZWdlNUREZ2eWcwV1Ryd2diRytO?=
 =?utf-8?B?cFFRUjdWa21uck1SOXNNOFhxOTlhbFllQnpaN3JaNU1DdTU3emI2dVhxdTYz?=
 =?utf-8?B?U1pZdk9TUVBWZkUvelNsbkZJTHQ1U2tyNEtsVjBCY3JnVHNCNytmNzBpMVlH?=
 =?utf-8?B?ZUpVL2MzM3hBUXdBb3J6UWhxZVRlTDlIMHI3RUw1VnNBeWFORFJROUJYdUZ0?=
 =?utf-8?B?c0NwRUNwNHh5Q3FORVpXdzlhSDJ4MkV2QWFwNTNocVRqYzVYMzEwVDRSMWVV?=
 =?utf-8?B?NllGVDRIRDhpcmRmOEpoWDlmQmdXazg5WGpKM1VzQ1dnUFFXVmF0R1R0NmxJ?=
 =?utf-8?B?MElJZTZRZlc4c0pKYUlwSXVFZGNsRTdkbHZOMVZ1OWEzRjMxRGFDUjF5RkR6?=
 =?utf-8?B?cEMzeDBJV2xsQUtrUHN1c0diZG5Kd1poeDY2MzVMc0hTTlhMQlBrQUg2QTVt?=
 =?utf-8?B?bExRdHNzUWtyaHRWOVM4OHpZTWIybHUwSnJNNkhTQlpQb2lzQlhoMERJc0Jh?=
 =?utf-8?B?eGVrbFhFR0FtSXBwYk96a0N1d2lOcG53WWhHTHRpS20vNHpDTDFDRDRza2t3?=
 =?utf-8?B?dmlMbWZrRzJpSVdLT0JsazBhZXh3R0oxTlpoYmQ0dXdpbjdzU2JVR3V0WjNm?=
 =?utf-8?B?bzQvMm9IVWg0R3FJRmQvQytKWEp6cng1QkNjSVh4bVczUzduVkFtenRNc2dp?=
 =?utf-8?B?M0pmQ08vSWlCeldDWkNWbllDZHRFS2ZvWVlDNHFrYVJveTNnZTRLTlVyeUZo?=
 =?utf-8?B?VVg2K0RIcVExQXZvak84VmdHZFpNNkE2Y3pGcnJSZ3orNHo1clhYTkZENUZO?=
 =?utf-8?B?OWFEdFJYNDVxMzVxWStRUTVsRTFzNjY3RTJzZzZwbXVTL3hOejloSnVPTFEx?=
 =?utf-8?B?aExLZGQvc1hySW9kS2RhR0RoSjBHWTYzN04rRnpURzhZMmtIeTJPVWZrME15?=
 =?utf-8?B?WnE4YUlTQ2s1UUQ4dmFTak44WW9ZTFpWeTdkdkhkcmZBV09URnowNmVXemhq?=
 =?utf-8?B?SjVtWWlzZ3RJYjJmTytkRVFTcUVpTTFPcyt1bkZLaXBJdFYwckpFaEt4Nm55?=
 =?utf-8?B?eHcvY280cys4NjZqL1I3RlAwa3RWVDFOOTJBN0xVU0d2M09rTS9ncU11bHFs?=
 =?utf-8?B?bnlLaFVaYnVOV2VYRU51QVkzUm5DbmxORXhZL0liWk5zRUxtM1A1am56NFZa?=
 =?utf-8?B?SWp2bENwZ21uMXEwRE85QUF3aXZBRGJBVWpMMFRoTnFtS05hRWZJN2RsZEZX?=
 =?utf-8?B?VzNncGtWdkxUbzI0KzBlZVplYnJONkNvRFNBOHJSU3MyNm1UR09SQnBOdUdS?=
 =?utf-8?B?TndaR1g5T21rRVdCRDVDVEZldml0OURJYzE5RkRnUW96eVYvS0Ura2hSM2JN?=
 =?utf-8?B?SGFUR2ZqVXBaQnJIWmM4TkhZOXFhWHVONjBnT2NJOEUzSlNpdFFXdkZIUU42?=
 =?utf-8?B?b3haVzE2Y0haTXFIcm1iK0hjS2IvZWR5bDJXcjhkN2lmUG16b2dWKzR6ekxo?=
 =?utf-8?B?MUhEMDI5VTl0K0tkZ3hZL1d3Q1B1clkwUjJLS0x3cS8vRFY0eEhRZmhERDgz?=
 =?utf-8?B?L0hUdUVBd0x2bHlOYmZEZURSenpWd01DWEgwK25mRFArZWljdFpqMGFXYUVn?=
 =?utf-8?B?NGUzS1VVQUt5UzM4UnU1OFBicW9SVStTNitIemNwSmVNM3QyQmd4cHBhUy9L?=
 =?utf-8?B?S3Y2NGxhemVzdStMWEFGYkMwdlFtWnVRcVdYUFl5SzFtcWQ5NTNBM2JuSSsw?=
 =?utf-8?B?N21xQlV4UEVnKzdtMjVENFI0d0VrNEFVcFpKTklCQ2R6OTdnM1VwVmNDdkJK?=
 =?utf-8?Q?56U5cuK6iNn+OdlWhiRri0ZCM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc9a16d4-c3f3-482f-76d0-08dc84b3704b
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 16:28:59.9098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LI2tzFONU11fT951QEb2AVlvKQfqWNkeeTxEsktDa/P36jHiys4hFwvW5IU7LONSXa7jlDLOjdWFtrjOyIa7Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7309

On 6/3/24 10:12, Kim Phillips wrote:
> Another DEBUG_TEST_DRIVER_REMOVE induced splat found, this time
> in __sev_snp_shutdown_locked().
> 

> 
> Fixes: ccb88e9549e7 ("crypto: ccp - Fix null pointer dereference in __sev_platform_shutdown_locked")

Shouldn't the Fixes tag be:

1ca5614b84ee ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")

Thanks,
Tom

> Cc: stable@vger.kernel.org
> Signed-off-by: Kim Phillips <kim.phillips@amd.com>
> ---
>   drivers/crypto/ccp/sev-dev.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
