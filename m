Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012037.outbound.protection.outlook.com [52.101.43.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3FC395ADC;
	Tue,  8 Sep 2026 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788898877; cv=fail; b=NlXV0FBDtE6jEKxwudHQB6vs3hCfbfP1Z/xDUA/Eq/mMuKxwNjM8+wkyCs8RZP9iFwzJWqvEzmExTpYoOTXwQuFbw2ZBv9rc8N0CbkSn7qMfeOTRHHbnfOS6Bn+vPq0I6HrolKtwbXtx7rUAkHiE5ODzOZ4qtURtI95oPJwY+TI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788898877; c=relaxed/simple;
	bh=ZOYE7flYEVbVzHy2+IvkToXNizsfWB36yhaw0UuNwGs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qsVRnghQD8FWRGmkpybcFPw1LMGDfYJW2pJfEy40jNRSQVkVP2MNU0O+KtJeOFdA2WNd2C9LdMP9fU5kERh8h4HZ6vyw+Dpfa3+P4klHrkvKeE9kt12uR+ZHhFApXAHgrMBx9QJrLlX3xk/+s1F7ZXGCvb0O9Nw4L1d+jvzBSQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wL3YXrI3; arc=fail smtp.client-ip=52.101.43.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wL3YXrI3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bzm14M8AqK1p1eyNkasD3pt2Dh85lntNQNopeVyTtNhaL+RyU+YR7i5vB3cV52NFOXuovU9/fgtlZWiUwUbbpuLkLNDrROn9CWR8D9h+AOwPbiQM1cD1UO7PdY+O+F+iMfYq7MdkxCPfl6vcsJbMP1X844LTEmE3e8aIYsRYI0SNhY+0UyMx2eydNO3UFqSGslD7WVHShWjSAZxmnak5yq9PaHjgh+LrmobkHNVvTkxONsyqQx0DQ2mKDk8c5yE+WcbS4W+QTWisN4ltcmPJ1U6ETt9DwBEonfZBxiOBwd4y22TDQ6Y0bM0lvZz7J4Zdm1Qm8JMPVQB4n6md/1cxNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6D+YazrK/ku5LeLolkKE2Hj6OgQPJEB5aXrwcvDuXU8=;
 b=uxC4txPZQ90mfnb0AHRZwmGVeXADMV2jdabUe6j95khOJ7uop463Fb7CbMsS0L4CPiW0x1pUqekwKlQs/6cOcylKhHZqp5+C6NwtYf0k20+i9N3/ybhdzuNa9XBm/nrK2Zm7576Pj+HenrqTbGmI5VU/7C7cY7hQP0eWDfv5FFtdHPtOEMS+m+GebNTHNRJhkaZGf3c5GShdcu8BhiyH1fPD8MF0mRiVSuckTo0WJMLw2x6v+f/DM3lQC677UsymGtViYAAnqNEHAQHVaMQhtl6dGDe9TiQzHMI7Q1b+S+C9rYanbYtZqazxs8EYUmUt52Z08uJqQ+6uedJFaRo9bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6D+YazrK/ku5LeLolkKE2Hj6OgQPJEB5aXrwcvDuXU8=;
 b=wL3YXrI3V46pGd29ehuULozfBCbnuvhYgZlD13QXUtSdeaTPle3C9MDRVRIUG7NoZk1KztpUZBq6Uo/q0WkrMNE9exb9PX19ulb8GntVWanCeQ7/ysSXYZR55syyXmYo9Fec/+x3PI31zh1AhPLkIv1Vqvl+PD4aNQtycnmDnp4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN7PR12MB8131.namprd12.prod.outlook.com (2603:10b6:806:32d::12)
 by DS0PR12MB9057.namprd12.prod.outlook.com (2603:10b6:8:c7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Tue, 8 Sep 2026
 20:21:10 +0000
Received: from SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46]) by SN7PR12MB8131.namprd12.prod.outlook.com
 ([fe80::c2dd:62c5:67fe:aa46%4]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 20:21:10 +0000
Message-ID: <4d1106dd-4427-489a-8d38-9da365b6a53b@amd.com>
Date: Tue, 8 Sep 2026 15:21:08 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: ccp: use named initializers for
 acpi_device_id
To: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>,
 John Allen <john.allen@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260903-acpi-crypto-v1-0-253cc6fd9836@thegoodpenguin.co.uk>
 <20260903-acpi-crypto-v1-1-253cc6fd9836@thegoodpenguin.co.uk>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260903-acpi-crypto-v1-1-253cc6fd9836@thegoodpenguin.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:610:76::15) To SN7PR12MB8131.namprd12.prod.outlook.com
 (2603:10b6:806:32d::12)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR12MB8131:EE_|DS0PR12MB9057:EE_
X-MS-Office365-Filtering-Correlation-Id: 523422fb-7138-4fb2-e4c5-08df0de6b8bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|376014|1800799024|10067099003|56012099006|5023799004|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ABamjFzBccTUUl43ovnA92QtZZ9IXUGAJ7GQBDXwjJaz6AekiaGhn9We1vR8bAXeLMf1SEVvnQhPDaKSUVFghrsZFy0hMsnc12IhbJaBA7LyfV9wVqa4rID0ZQf4zh9ko2mbjxtdltk75jHLOV16lh5HcigYNvNc0Til3fUzST/AJNqLCv1d5Mtm08quRSppXNMz494KF4/ts4JYpf3t346yeFSa8cDLBvvjIUEJkrh/v2+kPD2hm2AarhOh0sulXxdyiLM44ckmMAq2UyieBS6aVMno0xQWZ2vrGx8XsJgJH1HYMpAHSFeLUiMlWj+Js54XJ1BMUh2Zf/FRUJnQN6TP1NWw7lnn7LwkACtgMyTDAw7n1ao3ZKKRmGnIk7o2Kcc9xmcJT1ILsZPfyhnuP5JE5X7Q7HHGrWoCUef50IxYrccus2GiTF5eu45D5c19lD92d1tWrPsLGbh243K0sVlpjrH95IWMhIsGtc/1xAbG9dOMfj3JNBb5aXV3PAC02QeuHcETJ1Oo9lXxSQ+DZX8bWQpMEpsk2lhX0r3HqdoznHGcJc3HCu2g8QEe31lx9w6BI8wSlhg/N8eEEttdb1BjeOltTGqRy1tBTS7F5/TfqJ0X6ajZhQVUFPumwS/FlG/IrTdlWvXkvhdI62i8epEKGnsp6coOkGzwSxLM4nM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR12MB8131.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(1800799024)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZzAyUzVyRTZHTHpSbzJxT3R3RzVzNWJUSE9SeGdZUkUwVnRKbG4rNmQyWDJW?=
 =?utf-8?B?MkVwN0lZL3BjOE5BZERDV3FHSWt4MkVQMkpXYVVSeWFpSTI4WDE1ZnJOVTlw?=
 =?utf-8?B?cFI1U0k5a1VtTGpHMThVdkNNUG51QVdrL2Z5WndJS2pHcWhESW1UdElTN1JQ?=
 =?utf-8?B?cmROSGJveTVzNWJCYUdpbXB5ZVZsQjBRRWdRTWZEOEJYTnVLQU5YYkdTQ3RO?=
 =?utf-8?B?UDlYdHk3M1RMYVA1WUUzSDlMald4cWx0YXVFUFZMZXptV1FtcExuMldsT0pO?=
 =?utf-8?B?QzVWY3lybmxLQ096WlRlcy9ZUFIzWi92WjdTTHZEVS95Q2QzMnY0VFFyV20z?=
 =?utf-8?B?Z0RrR2hSQXBzb1poUDNVUWlvYlNMSHBCTlNtNWNXUzZwZlpTTFAzNlhId3Zp?=
 =?utf-8?B?VWtTOXZvbnN5Y0Z3MFBKNlFuL2tEM1RRQ21tWnpGclI3UWZRMlBweXRrOHNz?=
 =?utf-8?B?NXEwK1B3RnlwRDJYWFFvTEw2YXlrazEwVXgrdzFsQ3c3QnA2UDVXOElyTFVo?=
 =?utf-8?B?eXJjT0l6Y3JYYnNaenFDM1Fyc2Y4bVZGa0JIaVBpdmxwdTdmTm5yczRSSElm?=
 =?utf-8?B?cU84bXM2cDZoTTVCczdoOFA1dGRpc1dPOWUza1UxUklYM3E5bWIyL1hUczA5?=
 =?utf-8?B?dFFWRmVBeU9kSytlbUQwVUFiVmI2TkdUbHo5N2hvVGJreGpIYTh3My83TGYx?=
 =?utf-8?B?anZnaUdRTXkvOXNMSmd5V08yS25HNWdVQ3VtVzRmUnRYNkdrQnlnOHZvaFpL?=
 =?utf-8?B?TmtLSFRrdjd6NzRJZEMwdVE1bExOZVY2OHpjRXhyZXpVelFoNnpvd2JLMFJ2?=
 =?utf-8?B?eFF2V0dhSHlHZ05qYnBKcXZmTlExamExbVFyQVRlQldqMCt4Q09nUklSK0xX?=
 =?utf-8?B?b25GbG9GNFAxRmswZlpYR0wyOGVjSkJFWFhKWlVZc1VBak91YWt5aFM4aCs0?=
 =?utf-8?B?VkNENUdXRVlQZ1VkeVliN3Z0cUd0OU1OUXFxdm1jVDhvcUFlN3ZFRWlpRHVa?=
 =?utf-8?B?YVBjM0RxN1BYWDZKVWM1MmtMclFhc2VESFRwUmo2VmdNZWhvMnBNcFNCNnU0?=
 =?utf-8?B?a29sR0Jid2J4a25KWVZOb0NyaGRpWkI0Y0cvZmY4R1VDMGkxS3IvdDBPSDhW?=
 =?utf-8?B?OS9QeXJKSzlyR243VkM1bWt4OHgrSFUxQkdMUnQ2dVBqeHZiM0lQVng5WUoy?=
 =?utf-8?B?dEw3L2pESXRzY2c4Z0hRUkdiZGN5QW9yMGF3WDBRS2FEM0F4Nm1pdGgzRmpt?=
 =?utf-8?B?NHZjTUwrWWdFM1diNjIwZjh5L0VYTFlEdDN5ejc1TnRmY2FNdkI2VS9zbnhk?=
 =?utf-8?B?a2VnNzdUb0hBTXY2Rll6dmpCc2p1ZmdWR0swSjViK0U5NEJvWW1RWWRmUVFQ?=
 =?utf-8?B?K0dUS1FYcjA1eXhSQ1lDY3piRGZ2UFM0c1hhbThvVTIrK1ZXYTNSOHUyNmo1?=
 =?utf-8?B?bHdlTzR3aW1ibjJhMmtkRHNKMXRldmg0MHhkSW5XQUZjN2lnU0tQZGRVbkxE?=
 =?utf-8?B?RkN5bG9iaVU5ajl5TkE3UU5hSVRHaFFQdjZRVk8yekRTM2ozaXBGMENLNG15?=
 =?utf-8?B?Vmd5bVVXNVpuMkg4ZE9SakwvZ2VEeW9wRVdHL0lqck9DQXFna3cwRHVSU1hM?=
 =?utf-8?B?VVF1U1VQOUxZbnhBVjBPRzZtM1hMRmY5RmJocHNLSlY3MmZFVktiTnA3VCtY?=
 =?utf-8?B?bCtJYmtRYmUwVVA5STZaK1RmRVlZeVc5YjM2bHNDUzhidk84K1NmeElyVkRY?=
 =?utf-8?B?aksyVmNSVjVIMXVvSGhib3N0Y3hVTGZqMWMraUMxVTlmd1ptRDc0bkNGaHMy?=
 =?utf-8?B?OTRyWE1HMmYxY0N1eUNlb3pvemxEeXByNzloRFFNQmlYVDBWUFQ2Mm1pZmcy?=
 =?utf-8?B?Z3laM2RrMkxaSmRSaDMzSUVFZytrZW54Sk5TQWZNdGdXbks5YkF3eWdUQTJN?=
 =?utf-8?B?TUVmZ2Q5UkwxUjdWeXdENkUwU0JCNWdyVlNEOUZpZ2ZhUVhyRk1DdURuNDBl?=
 =?utf-8?B?eGJBR0NQQ3E4elJ6TmFKQlBKRFlyK2MvOHgraVovbnJoL1kwTFFkQjcrQTNo?=
 =?utf-8?B?Y0Z3OUJKaksvMlJaZElnYVpyS2xDTWhiYkozRzkxczdQMFB5dEZFOGFpaGdX?=
 =?utf-8?B?UlFSa2xMZzlnMXJlU1RWam5oQjZRR3U3aWRFTWpMbm5TUDVVRVdZd2Y5YUpZ?=
 =?utf-8?B?V0M0UkZtbDFkVEJuNnFkZ20rcmk2UHdKODlrY2x0UVI2V2N6ZWdnUUoycHls?=
 =?utf-8?B?RVIyemZEQ05GenA0dG11dnRhR2kyOVphZTJhYjZIdTl4RnpZYkpvNjlhTS9t?=
 =?utf-8?Q?smfE75iBDStTqCuaor?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 523422fb-7138-4fb2-e4c5-08df0de6b8bf
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8131.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 20:21:10.4725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZyjF9y2iHNwuSFGpMbFuU0VxCy4MA1xtU9BvdD10fbzFpKARzbBkLHwOoDlS2t+Fmcfg61PUvW80bP4FuN5uUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9057

On 9/3/26 10:42, Pawel Zalewski (The Capable Hub) wrote:
> Use a named initializer for the acpi_device_id fields which
> makes the code more readable and consistent with how lists
> are initialized in the rest of the kernel code base.
> 
> While we are at it - unify the list terminator to have
> a single space between the brackets and no trailing
> comma.
> 
> Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/sp-platform.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
> index 3f9843fa77827..c7ac840cbe136 100644
> --- a/drivers/crypto/ccp/sp-platform.c
> +++ b/drivers/crypto/ccp/sp-platform.c
> @@ -40,8 +40,8 @@ static const struct sp_dev_vdata dev_vdata[] = {
>  };
>  
>  static const struct acpi_device_id sp_acpi_match[] = {
> -	{ "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
> -	{ },
> +	{ .id = "AMDI0C00", .driver_data = (kernel_ulong_t)&dev_vdata[0] },
> +	{ }
>  };
>  MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
>  
> 

