Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010045.outbound.protection.outlook.com [52.101.85.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042193515CB;
	Tue, 22 Sep 2026 01:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790041648; cv=fail; b=eNsauKdNujQYhTk6Y/84FkSfNCgl5yVbEYtusBr0H/RYWs84lc6S7eOKIfJ1/lm9HVWsILPtMfqlngmEYE0hc0pAqVrdLqurALhKpMW2sP60NQ+VYo8vbuzngeioSOEGZEEtEk9JfOy5B3GvWMf8bMZP8U+t0o5394Q/CSO7Zso=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790041648; c=relaxed/simple;
	bh=T4192OfanmUgTEdh36Jpsgw6H8pKfHAIZHM8NMDdfHI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lgPc9yaF4+0XsN4hm1pBKF84ZJqlCPBkTVXDgD0bKZ2+BJ30g5mz3l4BQb1ulHnEDxwRGsl0p7VITROkefHpzI+2z0AKleZ5hNS29Wn8Zbdd2A2pIXCxSPrqThhbOLUvaIrzKrlldtB1/vf183/3s23e788+0JHwM7LZkWunekI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aYOr7r+Y; arc=fail smtp.client-ip=52.101.85.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aYOr7r+Y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wYOvQL78DqkzcDl7+PeBq7co5XzFJU4LzgXoFQBioDNONhqytCUdY7qCZhfYdEl5BR5znJGqFLcrjOXAZ4WeanqtuRhZQdSvHHz760YNE4FA9JC94Rp4LBMYaoKIwmGELM+sUOfhQZb8bdhR3anZIVQOvZQD04jzl3/E4zAnQ74Q6e7vJRDOly8DTB5cXaLRR3ai2ifiWqUxHCgzkFo2rOq8H1ZQ+N7Q4Ie03iD9A4lLHIaN0XruMQzh4qzPEMapAxmY9PZFQ+V/BDaXL8qX5Lnu7BKfgqb7+Dj1LK7NYhb5zHTQVe0fNPG6C+U19ugaTZ61qSjgqSPzIHmZL6klsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tqhu25l4yCUpHDAbHo+0hp+MAWr7DyEXMjSaZHST630=;
 b=cRWSqWnaDBWpaYMbCAo0hrRppSjefHeFd37Fd16JdpRsVUNd72toUBHeOAvJYprmcuQ9XcqSgseoCR9fLfO3oRQUY/YpnUAcKNgep9QjpXa4AAFIq6srkHutMNHgicEWxfcdnmkzvSS5L9z5MWV+pRsNGnNkM8VrtoUpGVRm1YdTG7jOZeNB0g4fXmWlICgevTyHiE1+IYBBpvdA17p14dDtwGiZJ1dlwlX4srOuoEmvDnpyFYV7sHNcumxW3GUqYW+X8cIXV9NiDSM13g1Wp3DUrMyAWrRhCFYhG77R+3frqSJlOdHyE+nItHPIYi/LsvwARRH9SQ19WoHXC6ahag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tqhu25l4yCUpHDAbHo+0hp+MAWr7DyEXMjSaZHST630=;
 b=aYOr7r+Y6/Bzs0v/4KZRVu6KIMjA0H0I5O+gB2FDsde2+o5gd6EsFyYjUVJZn1ps0uDtsSLUEXkTXO77KWh+N5oJ6hmGC+3VH8w3+gFpwFmgUyzbDT2OHcPUuWtUpx/D5I2vwBMGkFvFNXLCW/uU0KRGuGPh17oLu0v62xWvjpE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL3PR12MB9049.namprd12.prod.outlook.com (2603:10b6:208:3b8::21)
 by IA1PR12MB8553.namprd12.prod.outlook.com (2603:10b6:208:44e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 22 Sep
 2026 01:47:23 +0000
Received: from BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad]) by BL3PR12MB9049.namprd12.prod.outlook.com
 ([fe80::ae6a:9bdd:af5b:e9ad%4]) with mapi id 15.21.0428.015; Tue, 22 Sep 2026
 01:47:22 +0000
Message-ID: <ce67be1d-797e-47d0-8d6d-434143a95ca3@amd.com>
Date: Mon, 21 Sep 2026 20:47:20 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - fix SFS ioctl race against device teardown
To: Muhammad Bilal <meatuni001@gmail.com>, herbert@gondor.apana.org.au
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
 bp@alien8.de, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260919192432.272680-1-meatuni001@gmail.com>
Content-Language: en-US
From: "Kalra, Ashish" <ashish.kalra@amd.com>
Autocrypt: addr=ashish.kalra@amd.com; keydata=
 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
In-Reply-To: <20260919192432.272680-1-meatuni001@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN7PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:806:f3::13) To BL3PR12MB9049.namprd12.prod.outlook.com
 (2603:10b6:208:3b8::21)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR12MB9049:EE_|IA1PR12MB8553:EE_
X-MS-Office365-Filtering-Correlation-Id: d79e578e-aada-47d3-fcb5-08df184b7214
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|1800799024|56012099006|11063799006|10067099003|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	jzGLN1HeSy0HQvjmghZ/j9f2Yu2kZjYCG98RXq8cONrrx8ZWJbePp0SYpZ+73OhH5P4GXFEgYH7FA18etDItFldJ6QYhik/Wfza8ZokvgFof/shJvozCtsxEeJUvat29RI3BEDrNYApTpXZxLgMDDmqOmZSvuphnAGhVMZbsTKV9oRhxhrs5PCsu3QFDrrGq56fZ+QfQHEC0hb6RQ96y3BEAmqZY5iG1cp+QXIltqtUzjgNBo3tDRJXljQ5xfHa/px/f3BYNj+tbE3CyAhyzRfVM7Xyvcbhgo4TyJ4dTytR/5L4og4Z473R9F/weIAaPOnMQ04xJRvJi1T9nhhjmqTvpOz5/AoCZSK3/zhOqr9y9YOfER9sBN3qNOOHt/ToQwQQB5v3WbEuYVj29w0TTH9Qchwpn7ucWRLSDTRgsrwPo2l+UMZvmIfUlyVEzus+fo0N+4p2ETrLIt8gYcikrMKBD4PHFq1XdPXP6yGHB54WHEYlkGayRNmS41WFQMQiNv44buid1yubmijxA+b5IBjejZicz11QKCcJDJG5zB3Ag/7VsNSPpmDpKsjH96C3v9QYhivTCXMIfbiTyggVGgbXUFxuGyW8KGGThAssnUdFjO0/3FMah0vr1Nib0qbns52l1Relx1/BqSLolhy5OSl7cjruc+3xu2tTOfSkhmp0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR12MB9049.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(1800799024)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MVkxbHhIUTdPN1B0bFBRdjU1SW1CVUc4Zy9RaVZxTm5GNnVkbEYxbmdJUXB2?=
 =?utf-8?B?RW9QMXJUQ3BMZ3dHM0FJVzdqV0g3S3ZDYWR0c0R5RmV6UzI2MlU5Wnhpb3Qw?=
 =?utf-8?B?TnBOeXpEbEI5OGI1S041SGZXRFdpdmJveUZrTElxZlZuaXByQjJ0ejVQQW14?=
 =?utf-8?B?U25DN2pGVzErK2xXbHVCTVZ0OTJ6QUNpbFN2K0FESlhOdkpEWWVUOGpGbXAx?=
 =?utf-8?B?U1ArczVqR0pjL1FZRnNhV0pXbW51ZEp3M01iUmZ5Wmd0ZHhORFgzL2pIODVj?=
 =?utf-8?B?K1hyNERMWE0xNmFiamloSWV5T21BZHJweHVWY1drbWRocDFjQzdPMzNPdmVz?=
 =?utf-8?B?cFZzTGszb0h2R0lTTEJPeEdUZVdob0Noa3k5MW8yYmJUWFdXS2xDRG9FTWZw?=
 =?utf-8?B?SjVNWlZRMDZhSHoxYWpUWlZGODYzV2swTEJsNjhUMW9Baml3TkREU09IWTkv?=
 =?utf-8?B?MGYxV1hEM2grencxQnVvUFFJYzd6Mm54cThzd1VIR25kTHJncENzSVVtVGl1?=
 =?utf-8?B?Qkk0YTBKQ25tSE50amlMNlZSbEo1VVYyR09qUmxFV3VBRnVxN3N1MTRhT1VK?=
 =?utf-8?B?TzRPbUZxTjZ2NUJlNjRIek81cVlvSWhDNmJWU3ZHRHdLZUJLTW9NdTlJYXRU?=
 =?utf-8?B?bzhXWU1VMld1Zmt1SmdNWDllSUNIbjV2Sm03ZzNLSjhWWGJtVnFxM1JMU0Zr?=
 =?utf-8?B?ckIrVTB2cFZ3UUJwRFZGR3ROcXByTCtUMk9mQlhWWWJ6Wk1jQ2ZCcGtwdkNh?=
 =?utf-8?B?eDVXeXYwNWF2aS9zK0cvS2dIeHhkOWRWNThmUE1zbjR2N05GSGtsaDBQS2xh?=
 =?utf-8?B?b2U3dUFEVUNXVzlVTUxFTStqdGF0akRINVNiMDRNdVR6NFBxZnNlU1Rzcnlq?=
 =?utf-8?B?TVRYdkVzK2hhK2E5emp5d1paU1BNWXN6OG5CY095blZmTmU5UVN4c1RHdFdE?=
 =?utf-8?B?Wkczdm16TCszNGhDNUV2N3BkY2h6SEoyQkhzeCs5ZFUvZE5FdW9PRCtCYzQ5?=
 =?utf-8?B?ZHZYYkRxaFplQUE1elRQaVZSSmJPRXdJajl3TjkrZmwzSy96T1pqODJQK0sx?=
 =?utf-8?B?S25ud2NOemNQUmVxR1hodFlPODNmeWsyWlFNMGhYRVAzQXdZYjJtVExLcWJ5?=
 =?utf-8?B?VnNyLzZROEFUV1FxRDErL0JJY3RNY2RPL1AwNC9oSTZHMjlFb3BlZzBabUI1?=
 =?utf-8?B?azAxaXJmWGt4WjZZRVVCQVVFQjJreXdSK091UHBJQVk2enBLR00wZXpNZEh6?=
 =?utf-8?B?SEs4R09VM25ITWRyRnA1ZXN0TFp1L3RxcFFFMmI2a3RPRWgyTHlLU2NRUWZ4?=
 =?utf-8?B?RUhNeFZXNG1hNnlINkY4SmY0WUpxTS9zbkxBWGZ1NVkycDYrd1JaQ0hZdTZU?=
 =?utf-8?B?VTVTUW5zUUUrWjJ4Q3lFU1JEOHRwS3FQUHpFZHhJU3Z6cTluV1NyUi9lYTJy?=
 =?utf-8?B?OUF6TkZwbGlTSzV4ZVRNT0hkZU5kWFIvQTR1NzJGa1MwZmE5U3luRjlZUkhB?=
 =?utf-8?B?a1pCR21XVGNFZk1JdDhrMFdpeDkvS1ZHL1c5SlZZb2Z5ejBZVFJnblBsRjY1?=
 =?utf-8?B?bFF0SStKbjJsTUdNSXhuMjFrMHUraldTMnJmR1c3ajBsTWgzcHRFZFd1emk2?=
 =?utf-8?B?RDNqK2twT1p4emNEQXN2YzBscjZYTnE5WVBSS3U1VGs4QnhyQnBFa3lySXhi?=
 =?utf-8?B?SjhZV1BFbVpxLzlweGxRV0tmTkh1RlBLVmkvRnpyMUJ1R2FWU3RheitVZlhC?=
 =?utf-8?B?M0dVNEMzZXgzc0xpNWFobG5kRFAwUGVHSXlkNEJOaDkzd2J3OWlWZXQ4Snk1?=
 =?utf-8?B?citTc2VSbUtIK0tPczIvQjZENitrd2RIUml1TnJ1WEMwL0dMZk9KWXB5Z0dR?=
 =?utf-8?B?dDYyazRrR2FHQnByWDFiQ2RvUU9SdExqMDZPbjJNeUQwTjd1Q09Cd2hwTzQ5?=
 =?utf-8?B?VDlCZUppUW1WTDE2WkdtaTRRRWlVYzdIV1dPdnk5b2dXM0ZRSmNaLzJrVGdB?=
 =?utf-8?B?UnQxa0FHejJpNkpmTGlGRVRYOXI1K1psNEY5Q2VqQ3A1aDJxdkNPWjRRSDJD?=
 =?utf-8?B?M1p5MHZETTBrOENpaGhGb3FuKzZXL0pTNnl5OVBrWXVEWjk4U0l0eTFVejZI?=
 =?utf-8?B?UE8wZk15c0l1SUUvRXlyV1RGaURpaEpjTTNZTXdML0ZaWWZlMUFCdVZJUm5L?=
 =?utf-8?B?cGU3M1liQnV6NEJjdXNaSUwrSFc0RkptZEM5bTBGZzZzTVVVNGpXUUZiOWsv?=
 =?utf-8?B?WkRMM093Ui95V1lsTXlWam44bUlIK1BXQ3BLRzdNbHdNamp1RjFXWEQzY0Q0?=
 =?utf-8?B?RWNGTnhGZWFmTG9zeXB6Q0FCd1I3VGpaUm0vYUJOSm4vK1lZZ3hoZz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d79e578e-aada-47d3-fcb5-08df184b7214
X-MS-Exchange-CrossTenant-AuthSource: BL3PR12MB9049.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2026 01:47:22.9043
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4bXPRlv1Vn9zNyTQB0RB9AFJmzH6KhrjbR8gKcNJgto7OxmuCNeETftYoX3w//3jX6VMtcXXVEm1MXGIwZaDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8553


On 9/19/2026 2:24 PM, Muhammad Bilal wrote:
> [You don't often get email from meatuni001@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> sfs_ioctl() reads psp_master->sfs_data and caches it in sfs_dev before
> taking sfs_ioctl_mutex, while sfs_dev_destroy() frees sfs_dev->page
> and sfs_dev->command_buf with no locking at all and only clears
> psp->sfs_data afterwards. A call to sfs_ioctl() that reads sfs_data
> just before sfs_dev_destroy() runs will still acquire the mutex and
> go on to use the now-freed command buffer in send_sfs_cmd().
> 
> Have both functions take sfs_ioctl_mutex before touching
> psp->sfs_data, so a call that is already using sfs_dev completes
> before teardown can free it, and a call arriving after teardown sees
> sfs_data cleared and returns -ENODEV instead of racing it.
> 
> Fixes: 648dbccc03a0 ("crypto: ccp - Add AMD Seamless Firmware Servicing (SFS) driver")
> Signed-off-by: Muhammad Bilal <meatuni001@gmail.com>
> ---
>  drivers/crypto/ccp/sfs.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
> index a4777839790b..530141f8bc74 100644
> --- a/drivers/crypto/ccp/sfs.c
> +++ b/drivers/crypto/ccp/sfs.c
> @@ -111,13 +111,13 @@ static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>         struct sfs_device *sfs_dev;
>         int ret = 0;
> 
> +       guard(mutex)(&sfs_ioctl_mutex);
> +
>         if (!psp_master || !psp_master->sfs_data)
>                 return -ENODEV;
> 
>         sfs_dev = psp_master->sfs_data;
> 
> -       guard(mutex)(&sfs_ioctl_mutex);
> -
>         switch (cmd) {
>         case SFSIOCFWVERS:
>                 dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
> @@ -191,8 +191,11 @@ static void sfs_exit(struct kref *ref)
> 
>  void sfs_dev_destroy(struct psp_device *psp)
>  {
> -       struct sfs_device *sfs_dev = psp->sfs_data;
> +       struct sfs_device *sfs_dev;
> +
> +       guard(mutex)(&sfs_ioctl_mutex);
> 
> +       sfs_dev = psp->sfs_data;
>         if (!sfs_dev)
>                 return;
> 
> --
> 2.55.0
> 

Reviewed-by: Ashish Kalra <ashish.kalra@amd.com>
