Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F03C01591EC;
	Wed, 29 May 2024 15:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716996034; cv=fail; b=pv23kp9yHm41SUyGu3BN6w1yr3RjFfPMWYJex2qSztRLmHXqiF/uhGmyhZJdBtExdyCxmJf1UsfGbw1gCN17ehF1GO5mI5zq7tV3S03lW2S44ki5Bq5nnsXmAu7jmG0/20NkZukbPf4k6WoqqYR1ALNsQmkb2Y2ku+kX+qpno+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716996034; c=relaxed/simple;
	bh=XV0hSy4IwcyFAnF2OUoX8YuVRU6zz9PYnbhpMf4SPp0=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=PWmdxfhk1OvC6M1r8BBXaGJE3D6zeef30yqy7K+88X53R/D2LPjSTuXo9nbEFKpEL50iSugHUuZeyFsy+aACRT8NX+eTskL2LQHuSOBKwCKyFa7lC040byA2yNvR0JS+OT72kmtAjrTO2RHJbmpz6lYfXroE9MFhLIHMr/p/PIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kq0XKzn/; arc=fail smtp.client-ip=40.107.92.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kq0XKzn/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSNvzkg6xVxlMSA84y7JWWg/e6yWXf8oP46RjzXQ0MsBafyP+5OUp+ocxl6znWaiptiHDW+YHXrRLS/IfsSVm5hZgDu1PJ2nOjMp15Z6rhLTxGvy7p62YIaAHeZADDeaxahnTXhbiyB5BcqUDcfcIPghnQB3Ki2tGUf6yRexowIa1peZpv76oucz2o+D/KbhpJoUu8MeMQmbr4nYt23l6yhGyJj9E2zBbBIrCVziCigcjwhNzp4h5q+ADHDbw7gWqseuqlGfz+gkfv6wXZg+8YZlRkWqcSK8FovjfNGnocnvR/MCpRabHr1ywe8o4kRGJ64pMrIwkPHGrvnnQ01IqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4TakvxCBPxsP88TrU5CBmvl3cJEeaMX1ZR3nC8+AHBM=;
 b=D6l2T06PdFIrzilLzvbdf+2MJrSfoGgbtxsNlgrI0YIYFvJ4DYvQFjwimIue0/0LfqDQ7ciRruVH+RTK1mXW0TVhHyUvRBvtwxPmMXhbArchugM8BwPq4RinPQuO9ISwsGs3xDqTn+DukEirtioaYu1IHkuXycpUbwCBOzntOHaUBWgVQyh+cNkmT1DOK6MkC4pWsrSr7JT2EsKM0U01JiWYlD+yPoxIbsdgBcHKjeWJ+121Q1Nbg5OrP0p8F/pHkDTCiuf8WrHp1eytUDFfyHs4HeUmKuoxjge1Zs666Nj3OQKslGWCBLwDEPxgtua4C+HyFSo4WJbisfxHYx/Rfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4TakvxCBPxsP88TrU5CBmvl3cJEeaMX1ZR3nC8+AHBM=;
 b=kq0XKzn/Oy0S7AzPJ0vqRAtcURYZT6PYdeGa7UT5QqAgF8t58WUyaHdmMq1+vYQT4vPVHGJgHWoosQ42iTzhi83S/nf9OJrN1QLo6nW1YOhzNm+7gC2aLJ5e9H23koahANmkR19Uydggc4AZo9/fQN879VyzUjUr1blYXuGxnjk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5732.namprd12.prod.outlook.com (2603:10b6:208:387::17)
 by BY5PR12MB4097.namprd12.prod.outlook.com (2603:10b6:a03:213::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.19; Wed, 29 May
 2024 15:20:29 +0000
Received: from BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52]) by BL1PR12MB5732.namprd12.prod.outlook.com
 ([fe80::bf0:d462:345b:dc52%7]) with mapi id 15.20.7611.030; Wed, 29 May 2024
 15:20:29 +0000
Message-ID: <7f9db4de-635f-6204-d261-3bcd0aac1c25@amd.com>
Date: Wed, 29 May 2024 10:20:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Mario Limonciello <mario.limonciello@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - DB..."
 <linux-crypto@vger.kernel.org>, Richard Hughes <hughsient@gmail.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20240528210712.1268-1-mario.limonciello@amd.com>
 <20240528210712.1268-3-mario.limonciello@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/5] crypto: ccp: Move security attributes to their own
 file
In-Reply-To: <20240528210712.1268-3-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0030.namprd13.prod.outlook.com
 (2603:10b6:806:130::35) To BL1PR12MB5732.namprd12.prod.outlook.com
 (2603:10b6:208:387::17)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5732:EE_|BY5PR12MB4097:EE_
X-MS-Office365-Filtering-Correlation-Id: ebf7e518-ddf4-4f9f-330c-08dc7ff2e009
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YndNV0JjTnV3WnRmS2pMbUZtMThmSTFxL2lSTzlmdUY1czA1V2JUdmIzSEhD?=
 =?utf-8?B?bjdib2gwWmdra1JSMDN0ekFmVi8vYkxnNExjd2ZPZUtwM2NXYVkweVJBMExo?=
 =?utf-8?B?RkQvc2NjM1czQUF4RzlxN010aWE5YjZzS3ZreEdaRVlrYUlCeDFVaU9GSHk5?=
 =?utf-8?B?N0ZkWkhhbFkya3NYUERMVzh3ZEphRlNVRVVoUHI2K0cxT09VN21adjkvUEhy?=
 =?utf-8?B?MlQ0TVhBVmVFdWdLY2NtbzBRWittcSttZitBM2J3aG5tRTdURWdUQWxYbGtt?=
 =?utf-8?B?dUhPekNIUEYvTzBqYXBHZjhqUWVzblFjdS9LbGJSWTE1N1VhcUtvK0NrNjBo?=
 =?utf-8?B?WHJUb0xra0hZTldsSDZGVHZMZDJpSUlKdXFyalBnTnhQVjBEdzZSVFBuMlJX?=
 =?utf-8?B?YVc3WTRNOHpFNXJtWEZVRk1OVTNJbHVpWTVWcXBTQytFekE0SUxIZ0loTEsy?=
 =?utf-8?B?eDMwQmY0MDJ6MCtObXJmMEdxMGx5YjBpTGlIOVpFZzZ1YnlQU1JLL0pIM3RV?=
 =?utf-8?B?VWdTMW1DVlVFWTJpcmkyLzIvNlJSd3NoeUpKeGEzMFQzbEhzb0lkMU9Db1Nk?=
 =?utf-8?B?NHQ5cUJpNnh1KzlDdWY1bVRpNDZSY3VBZDlpQ0xqTDZEWXZ3ZEJuVWlpWjJs?=
 =?utf-8?B?b21zdlJsbUFXTVl6RVFBbVV4NGg3anMyM0JmNlBjeDdYeVFWajdvV1lzd3cr?=
 =?utf-8?B?c0w4ZlNyeGRsR0hWUjBJZVVxSmlmY2FFamVSUExyTHVXdmwrbnF2Zy9LZHBQ?=
 =?utf-8?B?MDFEU1IrejBhbm1TKzYwaHhBTmx5VlVrNm8rSHNCZk5LVXEwU1NlRFhlRTRk?=
 =?utf-8?B?eDFPbVZjOVhXRE8wMkcwV1lRcjU4VDFlMUJVNmJCemU3aGxCMzBLajhyUDhS?=
 =?utf-8?B?T3lHTFJ3T010TnFSY1ZmVXBFVnAxemFtZW8rdFNzSHJsQkpiME4yUlVzRzIx?=
 =?utf-8?B?UCtyUnVjZ29wdVRpUnUrc1A5OFh0d0l5MGdFSXp2SXdDN1RoSE9TWnlxZWpG?=
 =?utf-8?B?eHptd3l2ekI4RWlPMHMwZThOUVNIaHdsVGEzWWxXeVBBenVwT1N5NDRSUjM4?=
 =?utf-8?B?d2tiTXRqNnlKT0NIS0tjQkZZK2Q5S0toN1I1dHY0ZllqMS9HQUxHS1JQOTU1?=
 =?utf-8?B?dEY3RDVQL01hOUg2R0tJcW1mSytSN0VHVXlxQjFiWGltSThYdFB5Qjl6UEtu?=
 =?utf-8?B?RDhVb3ZNRVBma2YrbXpKSFowZWRLRFpwQVdNOFNoclBvdjJoTjNHMHUzdE5C?=
 =?utf-8?B?Q0ZVSk8yazhwZ3hKRCt1RlpVdlNJblJhTWppaDBZdDhwYy9DblBuVXFUMTRB?=
 =?utf-8?B?bEFSRlpSck9EZVhlczIvajJSTy9vLzZmMk9BMTZMcjZLaUZ6WkZhVzZoMTRK?=
 =?utf-8?B?Q01MRjJvV1ZmU2N6TE02dk5vN2RWcHA3bWZrMnlSRDhaMEdIMnBoTy90Ukgr?=
 =?utf-8?B?VmtUeS9KankzbXBQV0dhcm1yaVZCRmhZekpaNytpMUFBbXJDRE1BS1FLaDhP?=
 =?utf-8?B?QVFpaVNkTmZsaU0wcDZ0NGtPYUJrSEJuZUhFSXFDTUk2ODVYUW1RaEMxUU9y?=
 =?utf-8?B?SXM2dHBSLzRrYTArdzd0Tk9nenBkNUNGVS9UTnFEZmpEV2M2QUozMXNaNG5i?=
 =?utf-8?B?aTVPNEltVG03NndKWGFXMytETURlM1lmRFJsZFN2NFdPU0N5ZVlHRURtNWVT?=
 =?utf-8?B?UVlBV2ROMEJoU2txVzZIYTJ4cFgrR3crSE9pY0VxZ1hhY3duRjNWNFl3PT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5732.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OE1SbVZpTEFKREF4SHZKTmtnZitncDVYS2d4cmVTRmtDZ1BIelpNbVJqSHNC?=
 =?utf-8?B?QmRGNlI1YUIrcTVvUUdwMzdRc05uS1FNT1U2NHJJTDEvSXNZc2s4MjVDZGlB?=
 =?utf-8?B?WFVpSkt0QUUrb2tXb0QxVndwaVcwUkxpN2Fyd1l4ck1YeW53bzR4dUc1Yk1W?=
 =?utf-8?B?K1FGZHkwSHcrSTJ5cmlIM2FpYlliTVlzY1ViSFY0cGYrNEpyWmRoTzZ1eDV0?=
 =?utf-8?B?OFhRRWdNMnBzK1d2K3VFa0hQaFA4a1hrcDEyMUljRndPbE94aXJtZEFwOXo5?=
 =?utf-8?B?UHo5K21pMmNZWC96bXo3VVNuQzBrQTdDRDhpcENzVGlXWjVCL1UyNkRJb0lD?=
 =?utf-8?B?c0daQjRtajM5UUNHU3NnaTFaVVhyclc3T3JUc1dGZmNndVJGWlR3endzMjAx?=
 =?utf-8?B?L1VnWmU2VUZmOTE3V1JNM2lmVkloVEYxdFhCZFoyTVYzY2h6MlJMNXNIcXAr?=
 =?utf-8?B?Ty9UTDZOMG1heXlFNS9PVTJubFhScTg2c2o5bU1QSDFjejNhV21jSVFULzMz?=
 =?utf-8?B?T1V4d1lrVmRmenlvYnF1bnRmbkpBM2dFaTJlMUd3NVNmdERoVjZ3YkloWWtj?=
 =?utf-8?B?SEU2cUdVeS85YUloTVNmVDRzMUwvRnA3WGN3Vzg3QXNUVDhZaFBDUG93Um9q?=
 =?utf-8?B?VUZCK3dmYkZ6aDNHWlZzWmZrbHVwb0RvV3F2ZjBjTUREWjJjOHhQelRrbitH?=
 =?utf-8?B?NHAybXB1dEFWalZyemR6TnJzcDBXSHY4ZnBRRGtRYTUwRjI4WWYxd3E0TTVK?=
 =?utf-8?B?RXJXNHBuZzdZZ3htVFlnL1RpM3JNcHZsaEFRMVZ3Z1hYalRaRU9XWXJici9C?=
 =?utf-8?B?NCtRWENoQkZ4bXFTdHRoUVd2SXJ2RnNHa1NML2FWdHhHaU1LNlVuWmg0c2RX?=
 =?utf-8?B?WVZpR3RMeDh1clRTYVFRaW15c0gxT2hkWkhKSUlSaFA1VnRncG1tay9zMHQx?=
 =?utf-8?B?c2ZSbE1UdU5EdlVnVkgvclR2NDRFWlpxWnlZSXVuMXkyeHEvNjBsRXhHV3F5?=
 =?utf-8?B?M1R6Y1FxSXN2ektnY0JWRGgzcW1sN0ViWnQzNzJiNHpjTW5qMUV3V2dhN2ds?=
 =?utf-8?B?UktyQUZ1akNLc0NNV0h0TmNRbEJJMXFoNnh1SHpvSHZuUkRQMDlMTmtnVk1E?=
 =?utf-8?B?eHlnUzFFclc0ZzJHeks1Mk1HclZCUjFZY2RDQnhvYTV0YmRnQ2ZBK0hRbS93?=
 =?utf-8?B?QUJNM0UrTFBqZGJUT1FaVlFCSldLNUpidHRmSUZDL1RxK01ISy9oSm40NmJX?=
 =?utf-8?B?Unpkai9jWUc0QnJYQ295Sm1FQWkwdjBYS0dEcnlwZkxNb2RJRDdqZU5jb1U5?=
 =?utf-8?B?VXEyWFZDYkV5ZUxQaGpDNW92SDVsNzVRNG93UEpRZUVJdXhQSEpTeTBXeGxG?=
 =?utf-8?B?MkpETVNkOHVHV0JQZmxIblRHY0ZUaExHYlMvNXVRV0tNVTFzS0VWU0E4UXY0?=
 =?utf-8?B?OEtKMlk4U3oxc0FRajk4WUhzaGNUeEY4UkhnbTU4YmV3eUszeS9ROXpMTStu?=
 =?utf-8?B?SHV4dDVlb3grVkNCZ1kzWFIzTHZBN0FGRStLUEt2WThKNHZuZG50S3lmMzdw?=
 =?utf-8?B?aVhEeGFWNlRSYzZ1VlBTVUVUZUdUd0Qyb3I4TjlkZU5QUisxckcwS05PTmY1?=
 =?utf-8?B?V2RkdTM1NC82Nm9BNWozMGFRaTFCNEpzU0JhMVhHbEYzOVdDZXd2Mk1ETHBm?=
 =?utf-8?B?ZGZQMHJZeTRUeWlwWW1nby9Lc1dBb2NPSUVqK0gyc3J0T3ZCYlpJTGdsOGlr?=
 =?utf-8?B?aXZpdTVDaEQ1c1VZeG1sZm51c0pQc1k4QTNZWjAzN0pSRjNoV3NzaDNuVXNy?=
 =?utf-8?B?NjdycFgvNTYwTU1Sa1hiNmJzbmlmUVhhSHdsN1ByNGF6SFZ6MHdyZTRzSDhk?=
 =?utf-8?B?VE1UUFh0T014Vm5nRk84TzRKeHorNnpNVlJxaGRIVCtlNEw2aEtqRndPNW9L?=
 =?utf-8?B?cW1uSVdFSHAxOXJ6bFMzOC82eENINExBNUsrd2c0bzlSa0phQWFzMUtHTXRt?=
 =?utf-8?B?VEFqNGdkUkhUQk44V1hDM2IrUi9xOElkSUFSdmhvTWVjSU81TnM5VFNEbjRO?=
 =?utf-8?B?QU94eFVoeVRPcENLblhNNHRqajZXZXA1d09JL0YxbUJmRFZDTUh3VmQyVElr?=
 =?utf-8?Q?MnW234xL0ua7Jj/zYpP0XG+tD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf7e518-ddf4-4f9f-330c-08dc7ff2e009
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5732.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2024 15:20:29.8573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxARVtIpAvfE8fQxGxbxIr2W8wKiSDNW6jaR2xPbFcvKGa7PEVxE3dK5epZA605R6pjHvnt1k8+T5g5jFzCMvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4097

On 5/28/24 16:07, Mario Limonciello wrote:
> To prepare for other code that will manipulate security attributes
> move the handling code out of sp-pci.c. No intended functional changes.
> 
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v1->v2:
>   * Only add psp_security_attr_group when PSP support enabled
>     (Fixes lkp robot reported Kconfig issue)

Just verifying that there's no change in behavior in regards to whether 
the attributes are shown. Previously the attributes were not shown if 
CONFIG_CRYPTO_DEV_SP_PSP was "n" because the psp value would be NULL in 
psp_security_is_visible(), right?

Thanks,
Tom

> ---
>   MAINTAINERS                  |  6 ++++
>   drivers/crypto/ccp/Makefile  |  3 +-
>   drivers/crypto/ccp/hsti.c    | 68 ++++++++++++++++++++++++++++++++++++
>   drivers/crypto/ccp/hsti.h    | 15 ++++++++
>   drivers/crypto/ccp/psp-dev.c |  1 +
>   drivers/crypto/ccp/sp-pci.c  | 58 ++----------------------------
>   6 files changed, 95 insertions(+), 56 deletions(-)
>   create mode 100644 drivers/crypto/ccp/hsti.c
>   create mode 100644 drivers/crypto/ccp/hsti.h
> 
