Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4832227AC3E;
	Tue, 24 Jun 2025 18:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750788971; cv=fail; b=MjpcwEpzlzSc0vYll4ho8nRsX9G/E0ijZRawk79q5prZuSQ4WJ5oIbcvEtrPhwTpuXslvhQ4hpOxVkkWNYAScXIPu9km+/5Te0kAMJ2ES7iulM4J/1lwjO9tLO2yBxT75u6uZsunNGn0HWuhuXzilYYDOd0qBnBqOtVIBpeBcVQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750788971; c=relaxed/simple;
	bh=aKA3JszrrsEIhx8vM0Z5YT46Zr7hf5FeJMfFsYnjSt0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KATLSfZGSekXmIDsGp0Hxa67UkWMS6VKkPvA7BY4DiVdwKMkytkiiY3eWWGx7etOyJ4W8sy/QYqe/3d4pL3hAGt/xqR65T3RFomA3xzXIekK3T70eqEOJgJH/eHvNgUayoWIWV+njVhfi8z9k4NMOi35e5TN6HaW8agCSh7SRxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sWOtn4O7; arc=fail smtp.client-ip=40.107.220.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sWOtn4O7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6rudFHbOOrBV0TURKQBbvieQq1Alytb2Iz2JRH6vYpu8fXmf/r3rGoiLuvC4zocE4Uxm8Z12e1YVn8XRw+epaxWPxA1urp+pp1CArpIPyw0SUdhWX0MhTUTlFY93zpB+MFF7BfeKW6gUcUfg0cwTKhjCUaNoLJfdSqADiweDIH1dGzgd1l9334M5+YgO9R/hi+fMcZkSqUrsqf21295FhrsXARxgmK7hUm1vkEIg9a4RFRdQxn4pColLcE6uGNUa4i0GUhrS5wvUoKoaIHQg9jJDbv16mfObc02PgHy0bk7iEAiZBs0HZOwmpMtotT0nybZY9LpOGlilP6bCg6QoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JwD1g/UodCdtwSybTjSJj5rzhliL0/uynIImsIXesPM=;
 b=Cxu1iuYQIEKzJaKd5xJvUyICSf01K6afkoSqdjSJhcDIBiYNnJMtYHhMUaiqW2s2PMutjAIlHGH2t3a+XioDZGCOYXrfhdp55voJGHqGXzpG2Iy5KvxnEPHfIIRgQ0tf2T3jnQ1+FuNsO7V2Rw5cjj2EWYZy6kwVCFNULhZhUmwKEn5yJwrMtnS6gwQLF4GMUkm2YlmvCntxmURAMdXP+0LgXuRPPvWfz0a+ZtDl/741tvwdlOcWmzX7a9l+/J43TOUJQGlQyDeMwYawpfs5wAgGH9hFaTWT6QpQ8CBg5v+8eBMWZbxHIGrux7oT5n6azP3J9CTRdMWpFg0o6KK+VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JwD1g/UodCdtwSybTjSJj5rzhliL0/uynIImsIXesPM=;
 b=sWOtn4O7sIa9C/sQOojjRgE00LTFisYRDG/v/PM9ruyC6+CVnmBgF7sQsbYYfgmj1VCRbNGf0Lm5BhL/11ptxps1TEzL7tCK2QrPM/K7N0ND3+YunJK4QVdYw8tO79Hvpy+uBJyOR4y2SZkTrd4E4aF78Z//cj1ghbhppOWG0mw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by MW3PR12MB4378.namprd12.prod.outlook.com (2603:10b6:303:52::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Tue, 24 Jun
 2025 18:16:07 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8857.019; Tue, 24 Jun 2025
 18:16:07 +0000
Message-ID: <cfd60f1c-4640-e5c4-4531-84648d358183@amd.com>
Date: Tue, 24 Jun 2025 13:16:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] crypto: ccp - Fix crash when rebind ccp device for
 ccp.ko
Content-Language: en-US
To: Mengbiao Xiong <xisme1998@gmail.com>, herbert@gondor.apana.org.au,
 davem@davemloft.net
Cc: john.allen@amd.com, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250624065418.1743-1-xisme1998@gmail.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20250624065418.1743-1-xisme1998@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0079.namprd11.prod.outlook.com
 (2603:10b6:806:d2::24) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|MW3PR12MB4378:EE_
X-MS-Office365-Filtering-Correlation-Id: f9d706cf-7d19-400f-b1b8-08ddb34b301c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VnpyMUhNekdNdWZiazBnY0NWUitaY1NsSUd5WkJ4Y3BzWWl3WC8rdVhNQU5S?=
 =?utf-8?B?Q0dPdzh0aEcxQlNMOTJmV3J3UTNic250dmxFYmVkY0VOemN2UFBVQTkwbzBM?=
 =?utf-8?B?V3g4N1d1NlNaRGJqTXpGcllwZE9rcGJkdUhBWmoycjZ4ODdBRllyYVZ5ZEhy?=
 =?utf-8?B?K0JabVdFaFBKQjdnSThZRDQ3VjdEekwwMGo2UkZnL1R3T25DMUV4QnB1NDJ6?=
 =?utf-8?B?SFlQcXl3alpkQUVpampjUTVCN3NmQnJVU3J0TzZMTWs0azBYeWUzaysrOWV2?=
 =?utf-8?B?SnRaVU5Va0NwS003dnlyKzRtb1BSbkZNcEdHTEN6U2lvVXJaT0V4MTdXNGpy?=
 =?utf-8?B?YVpkckYrVE0xaFQ1czJPRjFBNFFCUktLZ2dLTDRGWUt5OVpOZG9MbWhRUHRt?=
 =?utf-8?B?aVh5Qjk2ZEZiRDhpbEt3aXpMdWpDWUUzcm9nMUVnMXdxeElTQWtRVEJ2UXdw?=
 =?utf-8?B?VTFGWVllMTREZTJWZXptZmFRSGhVei9hUDhnR0VTZUphSndKaUw5VXZtaGt0?=
 =?utf-8?B?SHM4ZEpEMHZCUUx3RzNiTmZPVTNkOER4dkpXYm5xOE5FZnZTb3VqeFZoMjZH?=
 =?utf-8?B?TzRTMGk0RUJ5a3UrNitrdlRYcTZGc1pXVUpzRUcvZEJpTFZ5WGhTWTZrUXZU?=
 =?utf-8?B?OXZuZ1hQWnMyVE1qb3RuVVNrUTU2Sk5zLzlwOFUwU3BEUzN6cXlOeTJmU2N4?=
 =?utf-8?B?dDFrQjNTOW8zNHdlbEpoSGphL2ZDb3doVDg0UGZ2cHVyU0tYN0Q1SnNudDZN?=
 =?utf-8?B?cUg0U0o4Q0s3ZzJpaEYzeEM5OGdBclBCNGZLU3UyTTZMRVJ3dGNjcFZZak9L?=
 =?utf-8?B?QjM2THUrdFNHbGlaa3JFL2hJL3pqYUJMSU1wNFdWN05EMkY1VHRGTnc1YnUz?=
 =?utf-8?B?ZlhpRlRnZG5KaXVDbVVPc2VTek5KTjFnTGxQY3I3MzZxZzVWN2pZV1pOUWlF?=
 =?utf-8?B?NG9SM1Vhajk3UEJVb25DbmVsSmFnOG96OWRaMEZPVDgvZHB3cWFERGRXTytG?=
 =?utf-8?B?WmpmQkEydk1sR3hxWVE4NDE1OTM2bGJwOHNrN1REaTBiZHlJYUhMNTdMT2l0?=
 =?utf-8?B?RTBnQk5VZmNzbEk1cllqME54Z2piY1JhdzdrMEU0WnhCSHc3Z0hERHZPQVN4?=
 =?utf-8?B?UjhLS1BwVVlDSUt2MUNiVURxK3NxYVhrb0w1b25lMDVQaEVQUFk1ZFIvaU5C?=
 =?utf-8?B?dzI4elRMZkpnWVVoR0dLWWtJSTZLMnZzYjU2QUtWcVl4VDh2dHpCRDM1b01U?=
 =?utf-8?B?c3d0NnRLYzN3Y2NKT0IycHg3bXlZT3RoU0hrMjIzM3NIdnhiSi9iaG0rMUdq?=
 =?utf-8?B?cU5QNnFIUUJNQXAwYVU2azhLWmJBQllnbityb25GK3Q1WSt0cGZXR2hHYTN6?=
 =?utf-8?B?MWdrLzJLcXBEMzg1YklSVWpNSk1abmIyMTJZRVlNdjZGMzY0WHBuc0tjUkJQ?=
 =?utf-8?B?bk1vdERuUnpGZE1FV0JtMkEwd1dFRFdDUEpHSFVIWWFvN0hEN1VCRGpMMWEv?=
 =?utf-8?B?bG5VNHJnRHJ0WHI4WkRoZ0ZRY240SG83Rmt4akxUMHR4TGY0dVZGMlY5SlY3?=
 =?utf-8?B?eFFxK29LRWRWbThIMWgrNTRiVEtEZ1RRUnV2VnVCOUdPbytxNmJFTjRleWsv?=
 =?utf-8?B?RUs5Z0cvaEk2dFU5ejk2MnErWmsrb09ROHkyU3BHL2NJaU1oWG4weGpYVjhm?=
 =?utf-8?B?YkE1bStKSUFOcml6MGZJcW5rcmhsbHF0bmk0Qkl3Ym9FL1NGRnNkUDhhaG53?=
 =?utf-8?B?RDdVS3M1aDR4Sm1Cd0NCcmlQNDM5bmpwNVljNHp1Y0FOTkZlbzdwMkdtRzNL?=
 =?utf-8?B?dTl6dHl0L0pUQ0hMaHBaekhpL3E2Q1FYanc2TDl0dC9KS09UL0dqWUJrRHl1?=
 =?utf-8?B?amxRVXEvT3YxUHJDZ1UvY1hiYWQ3Z2thQytCT2E1SzM2ZnA2a1B4dEgwZ2VD?=
 =?utf-8?Q?IaEK8j6nzCQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cUlFQmFaZldIZEo2OUVoS0grTWZaWlRVdFlMakRCS0xNbHVHdVRlM3R3OUVB?=
 =?utf-8?B?SWRzZHBkbUp3Z0Z5N0h6MGxSZlZkWFk3Uzl4ZlRIRFRmTUJnaXBJMjRGOGU3?=
 =?utf-8?B?ZXhTYjJ2WHRUZzU1dklKQVQrKzkzdVdIb1lHeWRmVGg0L3ZSVVVtVU1YY2xP?=
 =?utf-8?B?RTJTemhxNTFob0tBczFONllsTm5udkI2S1lyQk5ZTk4vZm9pYlRtQmhoNzNl?=
 =?utf-8?B?SCtYR0xUS1NwVE90VGRqUnErRGEyWTJqcXl4Y28zOU1xUVpiMTM0NDNBL1gz?=
 =?utf-8?B?ekVTeVJwOEVMOVFOWExBb0VLT1luQ3ZwUjE5KzB1cXR4SnJSSjFGM0gxYWpZ?=
 =?utf-8?B?YU9mMEtSSXBqTWNuaFdKMEF4dU0ycExVT0ZFSHFrRXhuMmNOZmZmRTZka05S?=
 =?utf-8?B?NW9pOTF5TUF3dWRxY094MHFRbmsrc094SVV4ajRaY3JTbnl5NGcwMkgzazdP?=
 =?utf-8?B?dWZFNnQ0Wmh2QUZ3VkxTK3pDRFNmNTczS1dOaFdiUTJIRmYzQ2xneklNZzJp?=
 =?utf-8?B?UUQ2RFIxeDR3aTRKc2RPcElNR1JUYWxzVk5wS2FybkV1SWZkc0ZvM1lNWldB?=
 =?utf-8?B?U2VBL2pPOUdFWWhPd2VUc0JZU2NQTkxjeG5TVkJJdFBueWNzbmFQSXV4ZmJJ?=
 =?utf-8?B?V0l3amxuQmdGVVkwQ29QS053UUgzbStqTExyM1pPUXptWUVERFh5QW13VFMy?=
 =?utf-8?B?L0NnZWNrYS8vU0V4ZE1oR2FUYUxwbXQ3OWswMmhLalBlMVVuQmZmRU1zZmx1?=
 =?utf-8?B?K3I2Y296NXE3ZzhmSEE0QjdGY21XOW5qV01XUXhhVW5UbzJObTZlT2M1VVBD?=
 =?utf-8?B?RG5ROVZhdm9UQXBrSk9jckJWQ01sU01GZzJCY3Y4TFg4UW5TTkNXZGVMdTh3?=
 =?utf-8?B?OUhSeFR0WFArdUNvQTMyYnRQMUtwck54ajA0R1dQd2FhWWszRm12NU1UK2hY?=
 =?utf-8?B?dTFVdnZFQjZxUHdGRUE5UUljZFdIY3VVRjZrUUJsc016M0tkak5zMFNMbms2?=
 =?utf-8?B?ckoxbEtqYU1LYnFGMzNTd2tMeHBqVmFlNWZqUTNjUWQ0QTBhZFFKQTN4WHN4?=
 =?utf-8?B?R0lPc045QVRMaHU0QU1rTlJZZkl5eHBBWnFvSDUxMTNyWkFHcHdlNWNPY3Fs?=
 =?utf-8?B?QjI1Wis1Q0VkL1puczJERnhseFd6SE0zUStvTTRlekd0WUxlT2JzN1BMbDlV?=
 =?utf-8?B?UHZtQkYrYnRacEJKUDdiZVdYRDBnajR0b3dEZDdNWExyMEYycGVPUjJmVEY1?=
 =?utf-8?B?RlR5bG9jRDNwbVZWQjJRYmNveDlwTDZSYWdkaXlwRXQ3eDhaVG9obUVDRlp6?=
 =?utf-8?B?OFptNGNoaTI5Y09FYUJVZ1RnWGkzZnJWWVBOSUxMMmhPYTNPWXoyQVR3Qy9I?=
 =?utf-8?B?VGR6bVJEUW0wNDFCZkxkdTBrd3RwUVhVREZFRzN0THZucXc4ZTRxTW9aNjFH?=
 =?utf-8?B?aXNzL215emRDU0RvYVhSb0FHckxndjB0by9SZzVRL3UrUXdGV1BzSWpHWk9t?=
 =?utf-8?B?c1F2aHZuM1JUaUtTYWlocVlUZ3VVQytBOVQyeU5mcUlPL1hDSWNqRmpjcEhR?=
 =?utf-8?B?RTRGZ2I2cldvWm1PbFhOWlVUK0UvUzhmbnN4WnJLUVRCKzFUTUFuWlNRem54?=
 =?utf-8?B?bjQ1b0l0dFlXVjBhUnRiSTV3dkYwaUhRaDdqaHdoRVJFRGtHZE0vdU9zU1Zh?=
 =?utf-8?B?VldMaldMYmtkTlRxVjMvcG90b09GTG10NTZOVUo4ZnBVZ3lIYjJtWm5SYUk3?=
 =?utf-8?B?RFo0Z3BDOHdqem5mdFpvb1U4MHNpM3ZlRlo0RDlSWG1yUnJtK1pFVkttalFw?=
 =?utf-8?B?dmh0c29DV1l2Tjd3OUdVbkFGdHh4M3VKa1hlcWZTczlqWklMV2JSWnZWbkxY?=
 =?utf-8?B?c0xlcU0vamlicmdJVjBxcEc3WTcwTmxqcUFDUjNJc3h3dkx6bER2bUR6Vmtp?=
 =?utf-8?B?T29GUWxtbnMwL1ovQzhqeEhZQVV3aXJDVmtwbTU0UkZoV2Y5a3hPREl5eGhC?=
 =?utf-8?B?dWtkUmlpUjByOGFwSDlIWWdWTlFGamY4MjdQaWtrS3JHMjVSajRqM2FVeHJ1?=
 =?utf-8?B?M001a1k0SThOWVZteVduc2R6bndzNWxmS2ZRNFBIQVl0Z2xEYzNhUldWUEtD?=
 =?utf-8?Q?5PUSr/i20sSMcJqyoJlxs3x19?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9d706cf-7d19-400f-b1b8-08ddb34b301c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2025 18:16:07.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wbvPpmUNY+8mth4PRl2Gr71kxziyG5hW1huIYfYXspkF/ld1VBKzRIE/490DRwblDZNI446OAAaKA3GnXYoBQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4378

On 6/24/25 01:54, Mengbiao Xiong wrote:
> When CONFIG_CRYPTO_DEV_CCP_DEBUGFS is enabled, rebinding
> the ccp device causes the following crash:
> 
> $ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/unbind
> $ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/bind
> 
> [  204.976930] BUG: kernel NULL pointer dereference, address: 0000000000000098
> [  204.978026] #PF: supervisor write access in kernel mode
> [  204.979126] #PF: error_code(0x0002) - not-present page
> [  204.980226] PGD 0 P4D 0
> [  204.981317] Oops: Oops: 0002 [#1] SMP NOPTI
> ...
> [  204.997852] Call Trace:
> [  204.999074]  <TASK>
> [  205.000297]  start_creating+0x9f/0x1c0
> [  205.001533]  debugfs_create_dir+0x1f/0x170
> [  205.002769]  ? srso_return_thunk+0x5/0x5f
> [  205.004000]  ccp5_debugfs_setup+0x87/0x170 [ccp]
> [  205.005241]  ccp5_init+0x8b2/0x960 [ccp]
> [  205.006469]  ccp_dev_init+0xd4/0x150 [ccp]
> [  205.007709]  sp_init+0x5f/0x80 [ccp]
> [  205.008942]  sp_pci_probe+0x283/0x2e0 [ccp]
> [  205.010165]  ? srso_return_thunk+0x5/0x5f
> [  205.011376]  local_pci_probe+0x4f/0xb0
> [  205.012584]  pci_device_probe+0xdb/0x230
> [  205.013810]  really_probe+0xed/0x380
> [  205.015024]  __driver_probe_device+0x7e/0x160
> [  205.016240]  device_driver_attach+0x2f/0x60
> [  205.017457]  bind_store+0x7c/0xb0
> [  205.018663]  drv_attr_store+0x28/0x40
> [  205.019868]  sysfs_kf_write+0x5f/0x70
> [  205.021065]  kernfs_fop_write_iter+0x145/0x1d0
> [  205.022267]  vfs_write+0x308/0x440
> [  205.023453]  ksys_write+0x6d/0xe0
> [  205.024616]  __x64_sys_write+0x1e/0x30
> [  205.025778]  x64_sys_call+0x16ba/0x2150
> [  205.026942]  do_syscall_64+0x56/0x1e0
> [  205.028108]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  205.029276] RIP: 0033:0x7fbc36f10104
> [  205.030420] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8d 05 e1 08 2e 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 49 89 d4 53 48 89 f5
> 
> This patch sets ccp_debugfs_dir to NULL after destroying it in
> ccp5_debugfs_destroy, allowing the directory dentry to be
> recreated when rebinding the ccp device.
> 
> Tested on AMD Ryzen 7 1700X.
> 
> Fixes: 3cdbe346ed3f ("crypto: ccp - Add debugfs entries for CCP information")
> Signed-off-by: Mengbiao Xiong <xisme1998@gmail.com>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/ccp-debugfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
> index a1055554b..dc26bc22c 100644
> --- a/drivers/crypto/ccp/ccp-debugfs.c
> +++ b/drivers/crypto/ccp/ccp-debugfs.c
> @@ -319,5 +319,8 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
>  
>  void ccp5_debugfs_destroy(void)
>  {
> +	mutex_lock(&ccp_debugfs_lock);
>  	debugfs_remove_recursive(ccp_debugfs_dir);
> +	ccp_debugfs_dir = NULL;
> +	mutex_unlock(&ccp_debugfs_lock);
>  }
