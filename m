Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2064.outbound.protection.outlook.com [40.107.100.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5100F1547F5;
	Tue, 20 Aug 2024 19:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724183631; cv=fail; b=WxN+DZkw7qqxGwG50InyagG0sI9LSg5BYpE+M28GXAcVFzfmxFlhNGWNywu8fWrH3KE5BkOGNp5GgDrqWfmtdGmk/n7Q+q0fLfwYFXP2ZDwcULmlaWYuoseGXOU3Ki1IMQOP/txvVTe1Qw7LUb26h1g3FtDb9iUSdg842/KGxmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724183631; c=relaxed/simple;
	bh=9Q5MqE4RH9kvA5iSo0N2cDZln6BPCJzfiCl7kaIO/rE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SW9FoQt0uDDZ9YbbXra4cR9beDBeYNy8CZ+E4tm9oQAquE9ZRt8tuWs6ES1ahMZPStP29LSZ7+Adwy1Z1rzKd0u1eA6HrqWZ1bpIL+IhZSGENmza3Hn0YY2JoAsQA2hMUPm7+HDtA8FQg2FmCxD0WaaMI9MqN1c22Yuh4FpVfG0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OnrAaZIv; arc=fail smtp.client-ip=40.107.100.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OnrAaZIv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H0XL+m5xUhc80l3rfj5fUhsm5lXK9NJC82UQ9kF+ICy3WeqpyDP8GVK2M09InVPjCb+cmxjTKC4X1ogBMvbE8cwdiJeKqJle7xocEHRyx7zKTa4/+ead4gZmPM+1VD6EhjGkzmCnsR1zwEqtYBovtpOW9jnRP/WTODoDAnGwkzkLLeTcpjisI3aX3tef84ZsJ5xkrP8sts6HesstqAqbnxgnomQf7MokJZRYLAv0B+rVBZIsuurrDliUkR+U4NEsvaJFNgBJ04PLihie5csrwZd9CxByNbqfGLW/scg3BgxiSNFsxQXp8jA0rJG299Wmag4TIF6dsaIk9Ty7UXIuPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S9jWFwRc2ViYe6stnKsB7zs6VNnQq3xOJREURJaOqB4=;
 b=CAGRtsZjb3ZRmgK3dXOp+qI7RaONwtosQXSDh3fLV9/1kUBdAhzuKoFrZfQxYeDuu9HaBJN+bnlEp+i72SFMM7Kq3il1YAI/LjK6lJ/cSIngAAx/uYBrLzPzU6ysXct4njXTxsL3ZetJMqIfXgLAleTwyBoqCbbhZQnN7aNzNT2RtC1Fjnrjq/0fGrZKnkwwGBegAe5xrrUNvLaccakWKFqkW92Ky/2xEM+6jX5v7qN9+2fqYEGejFur9+qv4ywLq90REoadfoQrbbB7WouBMfGS/LXaCuV0mZp5X/GJFCErZIXRsiP/uNAoxlw2VrA18siKPZDl8UWNOy1wRZUEpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S9jWFwRc2ViYe6stnKsB7zs6VNnQq3xOJREURJaOqB4=;
 b=OnrAaZIvAGr3aTZCGrstzm+x4tDfj4lEOgAY54lBed3mabBNZSvc7C/Pu+RDpweD2cow1bTRhIAvVaPC8DCyB38YOL4BPsH6a4I3+Z5lfJ0fGSWiUDSWG/nXXjZijGsY7wI7OKxMXgEqoH6zDmXLfjEWBS/mc+BxqDUPwNuaLuA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH3PR12MB9220.namprd12.prod.outlook.com (2603:10b6:610:198::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Tue, 20 Aug
 2024 19:53:43 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::37ee:a763:6d04:81ca%7]) with mapi id 15.20.7875.016; Tue, 20 Aug 2024
 19:53:43 +0000
Message-ID: <57e4ba05-549c-49fd-a8a1-ec2437556ba3@amd.com>
Date: Tue, 20 Aug 2024 14:53:52 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/crypto:Remove unused variable
To: Zhu Jun <zhujun2@cmss.chinamobile.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240820074242.4926-1-zhujun2@cmss.chinamobile.com>
Content-Language: en-US
From: Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <20240820074242.4926-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0050.namprd05.prod.outlook.com
 (2603:10b6:803:41::27) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|CH3PR12MB9220:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d5d6dd8-adbc-4f63-23b0-08dcc151cbaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Szk1NUNqczFvaExvV2FQVnphUkprVDFvL29sa0d4RDN4M2ZkU05iTXhIcHVt?=
 =?utf-8?B?M012M1c1TlBDTDZoRHFYS1FxWlJsYWo0Z1liYzdJQjJzMVorYzVwUkpFUDV3?=
 =?utf-8?B?b1o2Z291TllwR2RHSnFPL1F2aDg4V1RLUlk3VzhxalhFejZ2MTdwbjl2TzlU?=
 =?utf-8?B?b3JUSFJEYmdkekx1RFpDdkhVdjNoK1V5UU1aOTdBUUNJL211NkJvcU1scCs4?=
 =?utf-8?B?bC8yaktYR3gxL2NaVkh1SGdUdWd2S3NiaW5EdldNNFFmcExDT0lLU25NdDlm?=
 =?utf-8?B?bGlXcExvck5EMUp0MlNEcU85VFErSmZPWmtrTUk1LzdDalFYWWF0L3JMb2t4?=
 =?utf-8?B?UHhHV2xiZnhkblBBTndRZ3dWMnBVdXVhQ2l2S1JvT09Db1V2aVo1WVdWSm1T?=
 =?utf-8?B?REtlaTcyMmx4eHh4ZzkyMjgzbjQ1MUJiRXJqTjVPMWJXYzZBQXpIUGNaNUlj?=
 =?utf-8?B?YXZrZlZVN05DU2NBTWU4cURkVXVYR25UOFBCRm53L3NTL3NNM3dBY1FiM2NZ?=
 =?utf-8?B?MHdrYXdGdmNqVmh3R2xLOVhNQzhqZXJuOXJ3eXQ0L2F2NVJVRU5qOFluQk53?=
 =?utf-8?B?WWRzOWZ0SVhicnh2WFVnNEhuRnpiQUxpMHFpWXdmdmN3ejFNRGlRTUg4UmN6?=
 =?utf-8?B?VmNVU2tOZzMxRnhaQkp0aFN4MytlMUJkZDhVQ2JBcU5kd2R6d2U4UWd2Z0g5?=
 =?utf-8?B?dEpUVmxseWlkVXZMQit1bDNoem1wRW4vVHNPNEdEQ0JVbmlISWpZaTY1dXFK?=
 =?utf-8?B?bXQ2ODR5MStqNVVxT0ZqanQ1eVVoTjVsWkU1OFU0YUUwdlJtV1VWRmQ2SEZ0?=
 =?utf-8?B?a0hEUENrOHZFS0NGK1N3WW1pOUhQMWQwbmJjV2kvM2h6TVRLM2RCendKWC9x?=
 =?utf-8?B?SERCeGFvSUVGckZsMndjaWJjTjd4YmNUQkpWWWppNnRTK2pTakNNcVFHc3Nj?=
 =?utf-8?B?TytXS3VBeUhZZ29qTUhRQVI1clFoYTQrWHMyUHJnVm04dVFHMlplay90ZXl5?=
 =?utf-8?B?U3NtUFdSUkhkZzlEaGd1OTdQZEgrcW93c3hyNlgxZC83OE9qUWJnNFhILzVq?=
 =?utf-8?B?aWcvdGwrZW14dzBuZnhaTDRGN09iMm9EU3NFNzZPSG9pQ2FMWE1vOUNpb3Nt?=
 =?utf-8?B?ZStWOFBUWWE2bFk4OU1kUHZtc0RvOWdNazJZb2ZQWSs4UmdjcnN5NHBpcU80?=
 =?utf-8?B?RXZPbVhFcy9EbjNTYnh4dEVzUUFJWGxVY0k0akxBOG1JVFFwb2xlY1kxOURw?=
 =?utf-8?B?c01sOTFubzU3OHcwNkRuTDVlLzNTUCt0dUhYSi9qM3hFelArMHQ5eTROK1Rh?=
 =?utf-8?B?eEVnV0dMdXJaQWpiUkRjMkQwTE9XdE5MWEFOQ05UOGVSaWNyZHBpcGFzVVlB?=
 =?utf-8?B?aklhU0w2ODVVTmxXYXFXYUIzdHduSklTdmxMblFYaFJiVEtKWHdkTkVaQWlk?=
 =?utf-8?B?UTJmSExIeGpVVWV4ZjBQUkxOUnVVd3E5c3lhNXRiRjk4MFdiWWpXaDRVMFFZ?=
 =?utf-8?B?MmNEZjZXMXhEekhJU3RzM3FnTDZnZEVXMkxIaHhqaHVYaVV4VUF0dmRZOE9m?=
 =?utf-8?B?TVJEM3F2cnMxYVQwMlNsZ2VyYUZ0M0F3cll2RFVobUlLbTZJcnZBOVBOcnpw?=
 =?utf-8?B?OTh6aFhST3hwL29wNFJoVzFSTkNSdEU3V1JkWmJ0L1BjTGR6bzhXS3Z5YWlH?=
 =?utf-8?B?Z3ArZ0lMc1M5N3JyNlM3eHpjYy9vRnRVTlJsVEV1R1pndkR1R05wcnpuZHlR?=
 =?utf-8?B?Mkt4RENDSWlISEpQNDhCQURpNDlnMXFKS0d5bzZ6bjFpRVl1bTdqR2FRTk5l?=
 =?utf-8?B?TzJFM3YrbTA0aEVpMTkxQT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MmZvZFpUODhpeVVYckZrbjR2VEp3SHNTNGoyekRndSsxYXYxMFJnQmFPRVla?=
 =?utf-8?B?b0VRazZsTUQ0SElQd09BSlVDOU1HNXUxTjNLcEVTeEVLMVhhd25sNDh0Y2lE?=
 =?utf-8?B?MHlNZVZPVERaWGxxU1VFNEcxM3ExSlpHZmdBMkorMjNsRHdnWDZLakpiNnJM?=
 =?utf-8?B?eXp2UjkrQjlvRHBKejdwdWt0T0hIRVpvRGo2a3pLaE5RTzc1SzBKTXU0ZnNy?=
 =?utf-8?B?N2t3a2E4R2k4OU5GSTMzcWluazA0VTZyMHhRSXBlTDFGMnNUdUhpRnFWemhu?=
 =?utf-8?B?anpDREI4RmNQQlpKeHRnRlBCb0Y2LyszNzBZVzhsSFJnZms5bUtqeWxNY2pP?=
 =?utf-8?B?TlZaWkhqNnhZY0FINTNDT1JOYVY0RWZaajExTHhvOW05cm9wZUtjdklTazdi?=
 =?utf-8?B?UUlWTEp2ZVhoa005Y3UrZVVmcWdsRVRoUFRUQ1JQK3VFVEY0NWxsZ0lNZjQr?=
 =?utf-8?B?bTBsRitDbDUrRGlHaUZLM3pNQi94VndqVmp5WG1sSmZ0Z0czZ2FRdHFPMUdK?=
 =?utf-8?B?UnE0NUZtQVdOWE43KzJKMWRoWU5FaFJ0QzRRdG10VUJldnpoWWk1NXlQYytU?=
 =?utf-8?B?b2RkZEMwYWY5bnVWWDNpUlEwK3NON09sZ0F0ckQ4NFZZbUNEMTMyUitXQWlu?=
 =?utf-8?B?TGkraFh2MnNvWERiNGRzT2RNQm1TVHFET2IrK1Y3QVQzU0d6RkZqQ3RRMlMw?=
 =?utf-8?B?K3Rjc3NnaVlSSnZSWFZ5eUtBbFdRSk9SWHU5QUhLR3BsdTV3QmxaL2g5V202?=
 =?utf-8?B?QnFkcXp0OVZuUWxDNXFzQ205Slcva2c0QmRUQlozdUVzZVpvbjFzeVhuTEpZ?=
 =?utf-8?B?VmJkZ0VtRjk0Ulc2RjFYWEQ2K2tmQlFLRlBKcEdILy9zRzFaT3kzY1dkVlY4?=
 =?utf-8?B?VEM5eENmalRyUlJRbkRIa3lIeTVia3ZNRE8yNlpERmg2M3RQTUpyMFdCYlpy?=
 =?utf-8?B?aFQwb1Zad0RpYWl4ZCtPbGp6UTcyZ2ZSckN5Ujh0MUU3K2JDenBKbXVuNVE3?=
 =?utf-8?B?OVowOE55d1UzRnl6dU9OcUU5Qkc0dGZidWpVSzVOazQzQ2ZwQTNPZXAzbmtS?=
 =?utf-8?B?c2pjMW05a0xSemdYbk9sWExRQ3RkMWpzbk5GWmp4WXZUYzhRb0FqV3BMbzAz?=
 =?utf-8?B?Z0NhYTBZSitXTUR5YXhLZXdndmFvckFOMUlqczNXa3hxYzNYYlNyamlQcXh0?=
 =?utf-8?B?QVdYLzRRODl4ZTYwTS96VFJQVUIzZ0kxRWNCUFJCOG83ekM1dk5ocWJwWlJj?=
 =?utf-8?B?UHFucGdRcWVZTXVPQW5KRWlGbWNiWmRDREFnbEF2dzExb2dmS2ZpZ0twaFJ4?=
 =?utf-8?B?Y0ZlNmYyS0ZtWTdObGE1UGxWUVBSZHVuQlZSNWdzVEgrakNvL2dSMnZET2pn?=
 =?utf-8?B?aGU2cVRiR1krbjdlclllVjFyaXdKRkIxNTdKeFRpcE9JOVRCN3p4cU5sdXJn?=
 =?utf-8?B?R0VHMGZ6TmRLcnhTVkRtQnh1ZFZONzRtdVBhSm5DY2JBNndkOWhDOWRwUm5M?=
 =?utf-8?B?d0lSbDAxQVZtSmF5OGpaUVJRajVFNVJQM1dSZ1hyRmdOaWNOWnBCc0N1aStD?=
 =?utf-8?B?c2gvQXBxSW9qOVJ2MjNtaU0yNGt3V0FidXJINnlrUDlQR2pyUWtzMU1yWHBH?=
 =?utf-8?B?d0c3WGlwTzk0SjJOejFmclFBcXluTjR4enVYZ1NDdVdBVUFzU2pLOStDdkZ5?=
 =?utf-8?B?R1V3SngrQldUU3JFV25wZzVLaVcxMzNsc0hmL2hLSXFWczJFQ3FONzRwcE4y?=
 =?utf-8?B?NlFWOE5pTTcvbWRad2RNT29vdlUxKy9FVWlMMzRER01EV2dZNTZ1SFhlWkc0?=
 =?utf-8?B?ZWhiZHRIMitaREYxQnZvcDlUUkFHSlBGUGZNZEpTcUhkb21CeE1ia0Y3WGcw?=
 =?utf-8?B?WElUUTZqcUFBUGhXQjVxa052cS8zY3lmc0laQUpOeGVxNmJuNDZTN2swekxq?=
 =?utf-8?B?ejRwdDBNYi9CenNBQkpnNjliZVdQL0pWeUVTTE1ZNDVEano5RjFSSXZqenJK?=
 =?utf-8?B?ZVk5RmVHYURRQ3JRSGszOGNvWDd5QlczdTBxTnVRMWpXZGJ2V3oyVnEwK0NS?=
 =?utf-8?B?dkhQQU1WTFlUOGE3bFJwVVExb0lSSGt0TE85ak9JZWExcW5hNGlMTy9tZWw2?=
 =?utf-8?Q?EUOEUaEGNjFoz+5p/7oNYOlv8?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d5d6dd8-adbc-4f63-23b0-08dcc151cbaa
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2024 19:53:43.5305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xaj6A/KMz5C6iM3vw2gxcHcUJl98188MGdhQSnvi1Ckks0UQHPRm8punpndsSbNQW5xQflm6/KULXrTuV340QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9220

On 8/20/2024 02:42, Zhu Jun wrote:
> the variable is never referenced in the code, just remove them.

nit on the sentence:

s,the variable,the ret variable,
s,them,it,

> 
> Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>

Thank you!

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>

> ---
>   tools/crypto/ccp/dbc.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/tools/crypto/ccp/dbc.c b/tools/crypto/ccp/dbc.c
> index a807df0f0597..80248d3d3a5a 100644
> --- a/tools/crypto/ccp/dbc.c
> +++ b/tools/crypto/ccp/dbc.c
> @@ -57,7 +57,6 @@ int process_param(int fd, int msg_index, __u8 *signature, int *data)
>   		.msg_index = msg_index,
>   		.param = *data,
>   	};
> -	int ret;
>   
>   	assert(signature);
>   	assert(data);

