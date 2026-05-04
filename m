Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012057.outbound.protection.outlook.com [52.101.53.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D699F30C629;
	Mon,  4 May 2026 20:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777925815; cv=fail; b=F92Z6WODYjQKALWjRb6y3EZOXtFw5YCBf+RxcLdw5OYJeZKj4Ze1BIZiEcrukYzjirc53KLNCUJYFHhlEA6a3X4+qVEHrzx20A75ECa6YCmUpC/TGm0ftXRivJ+5qxOwWQay5yIy92DNNZZKqE+C6Ndco9DfcsCQHXCKhSNygbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777925815; c=relaxed/simple;
	bh=mcrFHAQ9KkQv2j4CtzQBGSUoisDY7DFOceiOCwH/U28=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dNHftfpLb+IrQaVhJMcoIVQ4TX1ApbKi6rBImS/BBGHPNBfsnHwpEXZdaZj3tM8hwo0PfbH8Huo7f1Psq0+MdnCxgBNMk26Vq/0n+CeV1XMyYmCSKl6w6a8i02kVEMKfhOvjCb3IUGqJ8O+9P1yPItmMSBfk6YqbRThjf/EvXpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Z+Itiu4i; arc=fail smtp.client-ip=52.101.53.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Z+Itiu4i"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jkl936IbCYnpkgRvc/FwPrVr61HALx9hkaoDrt3Hxz+063xA5ES2QcI6Uy5JmfZokvD5OFZiBoju7uLR0I1nXpUUnZW+qIsY635lLdUOYY1IPar5fm2ao2uN+B7f6pPuzfmQXcNU3IEy8iTHUFdg+/DTgMbJXSoRDC6mq1QajfBQw8xLRFSljDPCUdc8XERUQ8LlfWhMehh3vxTBr83dSrOPcumm3RPDx0H+bvkI1GewBSSGD/B6xvOqM8WF5aO15Xzkm/aNob935LM7r8usIqZoxRyAc54qsAJZBcIgCR4HTw/8sFaU1zaIyk6SiTqJjix3DFCNv2kBqvplNUCX+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Q/xyL/fULA0zDV8UnHsclhSCIKfNKe7ET31VgCKWVA=;
 b=FN0jppphoTGX1NoX6RasrQg5fleGbRT8pG0goAVlsRCDo1V4tjyvTctiTLfAlNxnvewQOMZzRNeGHgOxHj8vhjDOkwcIf4tZrQKmsQfajI8d5gc2pZcMIHoB0DCPM91g1zI27m5vPgWwsya8jBIixWa0hljV9/u9jW++gSXeOVuSeExLUumDtOV+eFzNZozOyEcufx4igka3nVpKpW4XgbFgHzNE1jRIFyVT4FCsoEQFnpWcLC8XuI8Afv9lmY4euGv+UJ+GJs+Db2wZ8vnOcvrqXNww8Ay4Wo5DmoVetk0H8nqKkCEMqDzjrdd8ALoESjD7jAfqZMmRjiF5w8Ln7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Q/xyL/fULA0zDV8UnHsclhSCIKfNKe7ET31VgCKWVA=;
 b=Z+Itiu4igjoUJsxmt4CVrbz6oPrXdaCZrmAtExUHiO0GQeJD4AWGyh0iv4ZEM0xE67ifLD+3eznmp/nPh5OdN4Kc99v+RmGAUiu1XDk/ENCf3JZ3L4LQ0pUB5amlU6U4I4YUcSCt2EDbzT5K4hszAviEnDdr8HOD+RdTOnn0vHg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8931.namprd12.prod.outlook.com (2603:10b6:208:48a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 20:16:49 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 20:16:49 +0000
Message-ID: <6f5c32b1-0a08-4ef5-be6d-44e3191b5c09@amd.com>
Date: Mon, 4 May 2026 15:16:47 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp - Define pci_device_ids using named
 initializers
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig_=28The_Capable_Hub=29?=
 <u.kleine-koenig@baylibre.com>, John Allen <john.allen@amd.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>
Cc: Markus Schneider-Pargmann <msp@baylibre.com>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260504152421.2147027-2-u.kleine-koenig@baylibre.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260504152421.2147027-2-u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR07CA0033.namprd07.prod.outlook.com
 (2603:10b6:610:20::46) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8931:EE_
X-MS-Office365-Filtering-Correlation-Id: fb5ebc31-b4e5-4edb-7e7e-08deaa1a12ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	0qGShLCru9n5DeqDroaPJlufUh+xw8k71EXAD4phuXPm6bjaGtFMnR+3/I4f/qX0IClD5VvzdNLeyI1TZ9PXeHVrEwI+p9mTvGHwsho3i0DlvLtzvE0PCsjMfOZyUfPAZ2W0S9y+zXQMtXHZBd4B4Cn8cKt6R3U82LfDUw3izC5gUE8KHy+WIlc54mZ5rx4gK6e7SKUPuy0Q8Hkx4VI+ARx+Fj8Wb4oCiiL2eZinS+Zc5zWS2dcU7v8f48PqBBHyUCnBkFaXpbUg7mEFanOvKKmvv5MDJXwj/eIfrtplYopfS/uUW9Z8GfXrrqYrM+WDXfVxm1Vcue4n5+zwAbTU0DlNkLHUKLW5hVxu7886QFjQag2DvIu0EmVL5QssQhOpB3gdUuPbWbJSKhQkAnRF0W5h8g4s+rN+RezUoN8gJzzXBzDKdiw2emXIniJGgHGWuwIpoU6kOpuokghAwXNOmv/qh2HoTqc7UBpfn+whmTEiIqeg+acuPQBJ8JVwJz3v9VYkknJkBdp0kvFiIVwz4Af6eacOXnKYZjTmUwqUOb0iiEZxkbx4Zf7t9p0XUFJqBcCUhxllIOJjQCyGNGrY27fjWP/r8ElmMAXOLGIwnVGm9yIbpBvvgXuiYd8ylmlt2JR4xv3fDC/5lgtr4wnhjwem7MRkmYXJGduBdkfehsiJ1OqWKpKIyGGWTmaAgU5iqj1AA4MhVcwqzjhhCNEI4w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RlovU2hJelZPdWtROTZJUFRsckExWFRtbmIzcGZPUHBucG4yVWVEMWZCaUk3?=
 =?utf-8?B?UHdGU20vUVF5QnJBQTFFaUFzSnB3czFOQ3BmaFpnVGJkTGNiMUNIcEpxQW95?=
 =?utf-8?B?RmJ3UU5JNU9lTDVCZk5vQTU3RVdQRjllc2FUS0pobmxsaE50eVZESzBDalF6?=
 =?utf-8?B?WmxwcTJTdlpPZGhQbU1ZYyttU21CS09vQURydGdIb1YrZktXZTVKUVlDZWdo?=
 =?utf-8?B?N1dIZ2VuT21QaFVNS3hqaVljZlA2WEFQeDA4T1NvM0s0RWZJTGpWTCsxQzA3?=
 =?utf-8?B?ckFmaXhicDdnUG9TNXk4RmtOMlFNdlF4cks0Q2ROb2JDWjkwVWJHMzFhS1k3?=
 =?utf-8?B?V3g3LzlURTF5eGdIdDFFTk1lUkEzK01ubVZjdUtxN24wejZlWmJKM3BmSWhn?=
 =?utf-8?B?SThjYjNoRGthR3FvSjd2dW5Eb3RWWjlBeUFkRGo4Wm9aUVZqNjM2N1FwWkpv?=
 =?utf-8?B?Q1B5YVppaXFnRlBqRE9ocm9KVXM5NVF3eUlFck9ucHhma1dPWWRtWDIwTkhE?=
 =?utf-8?B?WGFsTVlCbFh0MjY4VmluWWorM2pHZlVSTDU2a3hNam42bmxURWoyWWhpd3JJ?=
 =?utf-8?B?UnNuUytPNTBhUi9FYllJS1FnYlNoMjB0RzY5Q3JPNUVtR0JJNlRDaG9QYjhJ?=
 =?utf-8?B?NWVoT0V3N3RpMGoxNmdhcm1XZWZwUXh1NVhScXNlNkZGNkw1bUtKWmpiZlJw?=
 =?utf-8?B?dXJpSFBHMWIrZ3k3UkpMQjlZRXZoaVJGZGRzNzI4VWVPdjUzekZHNVlINkRu?=
 =?utf-8?B?T2ZjOVBXcGZzNGQrVEJlWWwvaCs3S1gzSzRIczF2NHN3YmFlQlh1bU1NVVFm?=
 =?utf-8?B?NHFheXN2MWNPZHJzRlJEcVdUVXpDR041aVNpU0hXVEFBQk1TQWdFT2xxdXZB?=
 =?utf-8?B?YVcxUTlRWnp0NVM1MDJTelpHQXdwd2t0M0oyaXNyQWk3bm15RHN1ZXZvdzhE?=
 =?utf-8?B?UVNFTlZVYjg5RDcxVllCcUdxRHZzS3ZGT1JpYWdIK1JoTmZHQXBxWmJvVUR0?=
 =?utf-8?B?REtEVjFIbUZCM21GTmY0MjJVYXRNV0hNUEQwWUdNOVlRV1d0MVZLUWQwYTU3?=
 =?utf-8?B?SGxWZkZCNlZ4RXNmb0s5TGZ0WG1EKysxYVhGTEwyK0NCMW83R1dlOWFKMnNO?=
 =?utf-8?B?aFBqY2xtK0JLMVhqZGdoYzhMRmhiWm80c1h4anZHNWRtRzlHRmsvZGJMejhr?=
 =?utf-8?B?UFNnZlhEdjJvaFFaeEl6QmdFcEZPYmNWMkhJK2JEN2tJWGt1N3RPeEJ0QWd4?=
 =?utf-8?B?RENBQ0t5QVcwaWFnamVrOFJINTVyUnJicDZmWDFWR3lPUUhWWHBLMEJsTXVG?=
 =?utf-8?B?emdKNXI3N2ZoRng4ZHlLWEQwd1NEZXBlRDgvREgvOUVDeEo5OURmN29GNzhF?=
 =?utf-8?B?YThKb1ZyOFdWVlh6MFRmNjJSSit2MEdnTUI2elIrY2hGY0xWY0Y4RWNTYi8w?=
 =?utf-8?B?Wk5xWkQ3eFluaWZuZTNiTnRvdzVpZW1NMGpjNTZmQUFzSGJFdlpHTDFNT2Vj?=
 =?utf-8?B?SWFzbFp2ZythN2x0SForSldUZ1lkK1dYK285MVRCQWV4NXhzWjBLL3RqNFJo?=
 =?utf-8?B?K281a01PNmw3RnFqNGw2TDFpVnY5eWhiamloVW53aDU1OHcxTlg0bThsYUc5?=
 =?utf-8?B?Vk5GV0FyUlFPZnpJQ3hIRkc0cHhjVEhaWXdialoyWEc2YWlxclFsVzhBaHpI?=
 =?utf-8?B?L0JvVGQwbXNSeCs1ejVsdVMvU2cyd001TnVIZDF3UTVBTTVIRG1iV0Y5aXE1?=
 =?utf-8?B?bCtJWUJqVEpOTmRTL01DQkRwMG8wQkFPVDhnL296d2NWeGJlRmFBeGJKeUZ4?=
 =?utf-8?B?TE85eGxpLzJoWk96YnpKamsxNFhFRVY4Mk9GRExIRVMycXJpVkZmek0wREV1?=
 =?utf-8?B?RC9sYmVzamFnSWI5TThOejVzcVpVLzlRbkc0Q0p0YytlSG02dTlZalVOVlZx?=
 =?utf-8?B?YWRmL01DWUVTUVRKaGx6VHdZbTNsaXRlcUxWTXc3UWJPbnBrcCtmUDgyMTFh?=
 =?utf-8?B?eGwraUZIL3A3Y3FVK1NQUDhhSE1McEhuY2M4WjZ4VmMxeC9FY3ZtVHl6V2VQ?=
 =?utf-8?B?czkzWUhzOWhsLzYvMTR0YnhlNEFoQWpHaDBLNXJ5d01LQ3hXM25RZGN6R0tu?=
 =?utf-8?B?Z29VTmFubnFBSmc1V1VDSllhaUxUSDdGZjBiQm0ybzNZeGFoTE1MaS9HcTNv?=
 =?utf-8?B?Vk53R0MxK0x1Y0NkWmYwWTRnNjl0cU5oREkxaGtldzk1d0dhY0pqcDlLSVpr?=
 =?utf-8?B?UkxSRzBYK1ZBOHpZNFQ0dWlYQll5V3pTL3J6Q0tzaXh2ZDVDTGZzeWZKY1pH?=
 =?utf-8?Q?F4AUmOMbIhfI5tvYv5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5ebc31-b4e5-4edb-7e7e-08deaa1a12ba
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 20:16:49.6275
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kLuEoYwzGd0z/mlzcyKiIFXJe0VVI/c9Bp/n6E3bh3lydaXg4WGsFBk+hCjPknB4dEWfjNEgexKy46yy+GQKKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8931

On 5/4/26 10:24, Uwe Kleine-König (The Capable Hub) wrote:
> The .driver_data member of the struct pci_device_id array was
> initialized by list expressions. This isn't easily readable if you're
> not into PCI. Using the PCI_DEVICE macro and named initializers is more
> explicit and thus easier to parse. Also skip explicit assignment of 0
> (which the compiler then takes care of) in the terminating entry.
> 
> Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> Hello,
> 
> The secret plan is to make struct pci_device_id::driver_data an
> anonymous union (similar to
> https://lore.kernel.org/all/cover.1776579304.git.u.kleine-koenig@baylibre.com/)
> and that requires named initializers. But IMHO it's also a nice cleanup
> on its own.
> 
> The anonymous union will allow changes like the following:
> 
> -	{ PCI_VDEVICE(AMD, 0x1537), .driver_data = (kernel_ulong_t)&dev_vdata[0] },
> +	{ PCI_VDEVICE(AMD, 0x1537), .driver_data_ptr = &dev_vdata[0] },
> 
> (together with the respective change in the code when the value is
> used). This gets rid of a bunch of casts and thus slightly improves
> type safety.
> 
> Best regards
> Uwe
> 
>  drivers/crypto/ccp/sp-pci.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 6ac805d99ccb..ede6ff9ad0c2 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -552,21 +552,21 @@ static const struct sp_dev_vdata dev_vdata[] = {
>  
>  };
>  static const struct pci_device_id sp_pci_table[] = {
> -	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
> -	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&dev_vdata[1] },
> -	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
> -	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
> -	{ PCI_VDEVICE(AMD, 0x15DF), (kernel_ulong_t)&dev_vdata[4] },
> -	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
> -	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
> -	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
> -	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
> -	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
> -	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
> -	{ PCI_VDEVICE(AMD, 0x17D8), (kernel_ulong_t)&dev_vdata[8] },
> -	{ PCI_VDEVICE(AMD, 0x115A), (kernel_ulong_t)&dev_vdata[9] },
> +	{ PCI_VDEVICE(AMD, 0x1537), .driver_data = (kernel_ulong_t)&dev_vdata[0] },
> +	{ PCI_VDEVICE(AMD, 0x1456), .driver_data = (kernel_ulong_t)&dev_vdata[1] },
> +	{ PCI_VDEVICE(AMD, 0x1468), .driver_data = (kernel_ulong_t)&dev_vdata[2] },
> +	{ PCI_VDEVICE(AMD, 0x1486), .driver_data = (kernel_ulong_t)&dev_vdata[3] },
> +	{ PCI_VDEVICE(AMD, 0x15DF), .driver_data = (kernel_ulong_t)&dev_vdata[4] },
> +	{ PCI_VDEVICE(AMD, 0x14CA), .driver_data = (kernel_ulong_t)&dev_vdata[5] },
> +	{ PCI_VDEVICE(AMD, 0x15C7), .driver_data = (kernel_ulong_t)&dev_vdata[6] },
> +	{ PCI_VDEVICE(AMD, 0x1649), .driver_data = (kernel_ulong_t)&dev_vdata[6] },
> +	{ PCI_VDEVICE(AMD, 0x1134), .driver_data = (kernel_ulong_t)&dev_vdata[7] },
> +	{ PCI_VDEVICE(AMD, 0x17E0), .driver_data = (kernel_ulong_t)&dev_vdata[7] },
> +	{ PCI_VDEVICE(AMD, 0x156E), .driver_data = (kernel_ulong_t)&dev_vdata[8] },
> +	{ PCI_VDEVICE(AMD, 0x17D8), .driver_data = (kernel_ulong_t)&dev_vdata[8] },
> +	{ PCI_VDEVICE(AMD, 0x115A), .driver_data = (kernel_ulong_t)&dev_vdata[9] },
>  	/* Last entry must be zero */
> -	{ 0, }
> +	{ }
>  };
>  MODULE_DEVICE_TABLE(pci, sp_pci_table);
>  
> 
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731

