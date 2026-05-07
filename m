Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010015.outbound.protection.outlook.com [40.93.198.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3FF41B355;
	Thu,  7 May 2026 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778165033; cv=fail; b=CAkI6ITtkZVYRg2pyoDwD6yOoH/qyRVN0uBQPUAVyrHZBnnr21Jf/BgYXvCMFsogrEss8ZFm+5TUFi3wUFJ9cXqZillQRlmdmDaaTCH++6zlguagxPGlNwKtQzQL9XYb5kitTn0Fg0XPEDU1Esze1vBULbW3OOdw59aWrS/KTLM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778165033; c=relaxed/simple;
	bh=i3MjqGKw4I+XJBBHuiCnqjqbaz7MXMpJyhOSyBkqCTc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WXXHjNTKOaHqVM9Wk5TSn8H/evHMSOE/NL5ZSua4cDrggPREcor0ADsfsE0xlIepTlPA+KIN2de7bwO1sxPkq4S0/0QDCZvZ2Gi5V9Fm5W0FXviuSidU9m4Qw/VHEjTPQcj8naPLSzupjnDp6fo6SWqxoaq6vVIeyP9BOvF+x00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CSskaUti; arc=fail smtp.client-ip=40.93.198.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CSskaUti"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mxJfQzwmf3oEEePSxtrpFMPXdPh+ZU3DPvtf5gjPhBRLlIXiPfG3QoNQy9xQNtDDX4jkTXz5rAR70QzWNJRxioIFVY811O7QEO5BhpAzxuDCK6EAvdOfQIeOo4XqClxVism+MzIQ/2zxk86KN4QjMivl4I8evfBwYa1xiWsyphphNoDA5kxD/GH1bP0C6BfMY4AxpKr7eWmCaRFfNC+ukQFINIG3Npt5ZzqYv6Vyh/uqFOckKt4FATS/qiAKdKVTTO578xeLXkrHOipE2GJ4S4BPb51Kt8MHRlpl2Cs7m3g/MkrEQ7YN55mjC7APJEP+Bx7AxKupKtdVUg4MHBsw4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OK70t+olMxU/3Zk5sHMEDx5QpVIDmUYBQ052KL0ZQ6w=;
 b=UfUj4cfMBHjVrwKZFyMK2+97QEqutXCfaUfszdMmkYIFcKhkWjO2E1gWSM7fKHqF0qBBE6t3mpVHEP0ueBuXHAaNz9sxkYW5NT5NbcuLdK1UfBIlwFV7ZGQvbvoepOSe5BUOalLgOwWWrI2pUuE3JxwACUdC93znkFG77xoPZ01dWaEG57wLH+yf42wYS5NcFkxVTwdaFkq7MoZDYuNlO0F2oXMoa/oIdrqZktyiANK6u1OvX7MsbMwg6BImkVA8SK5eg94I9gQND854NBUCvh4ragLSN2VrFHEI/FOKehGiPfh5edYOhZZxq3O9yiXZzv+RtwKuI5AZbZ51vNgc2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OK70t+olMxU/3Zk5sHMEDx5QpVIDmUYBQ052KL0ZQ6w=;
 b=CSskaUtiYjVhJAJQaN5SpnNlKfsy9iaio/+U4SgFXmpNs/V03VtnZn6PoWDFmEILRFO84aoaSdt37MFToGgQMHLojGaPmlkSn/QquyQiigicfWDP2QzD4rX4cLsPpmoiEWcYJKOP2MZacYUfMFd8IzSnIJ0sJXUToQ54G4mEiT4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by IA0PR12MB8693.namprd12.prod.outlook.com (2603:10b6:208:48e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 14:43:45 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::f3f2:852c:78d5:9353%4]) with mapi id 15.20.9870.023; Thu, 7 May 2026
 14:43:44 +0000
Message-ID: <cd6b4e47-850b-4e65-b2b1-2b1d8bb08907@amd.com>
Date: Thu, 7 May 2026 09:43:42 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: ccp: sev-dev-tsm: bail out early when pdev->bus
 is NULL
To: Stepan Ionichev <sozdayvek@gmail.com>, Alexey Kardashevskiy <aik@amd.com>
Cc: john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 ashish.kalra@amd.com
References: <20260507023619.398-1-sozdayvek@gmail.com>
Content-Language: en-US
From: Tom Lendacky <thomas.lendacky@amd.com>
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20260507023619.398-1-sozdayvek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0089.namprd05.prod.outlook.com (2603:10b6:8:56::6)
 To DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|IA0PR12MB8693:EE_
X-MS-Office365-Filtering-Correlation-Id: a12c4ef3-c382-430e-a991-08deac470a36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vkgazWO1yXZDYMvZSWZ+/aEonMZVGcusfr+yCT6UkjWV/CCdxBzUFCFygCx6i63l7eSyxWCxchHah/n/MB3SP3LFc/c7BrMblrHQa08fGT10Leg3O5ClaSY5spUO2XTz7iyuMYS3KdEN+OXb99QCJx61qxzUb+lzH9eu9B0f4c38GvNMX12g4hIUhY3VRuQaBzQbEZzr0jPdM+mcHEzkomTOVnvBBj1mPPcTTpvvra5j6iwD6dizX0FM+5ckR4EvnV+oDs/c3w/BpmJ9l/8qEVQ5+EllAVrpw7XuWRPCbnJmvBZ+4Ch3sYe8HzFA1xcHx5XPwmnZPUMcl1zj/kYMVI4VKyGV5t70n6VUOobcSnCG0nBDuBAFo5o1/KoQhWU40wdmemUkKxDv4rxvtY52ZUlIzaSpREBY3DRLcsq0mD+TJXHK9lsXfUUx90vzjfZdIuStqGqSFt9OB07z8ERnhtO2LGdhsdgNEjb748v29QuhdJnsH03NhJZCfrwqG/YIsNbAz6dVF0syCUXMsdGjSEfGATzciqLz1e+PdVVzhRSm57BUqABX9e3F6APX8wNO6nbTgo76doiaMJLXdo7t7gPtz9AfU1i4EpXuSOADRw6KwGJtHdAhqSD68tdBAR+UZeusTAsYi5DPClHUgikEDBffIuG+DDxFpMcQvPYQj2KtIbqoRIbszHTU2XUrBZtU
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NXBHVlp1Z3NXOCtYQzd5OS9YVzlLM1NGZkZrZmRjRGJRSWJKS0I5ckh5a0xn?=
 =?utf-8?B?cXFIRXVhMGpLbmFscjhIMkcvT3ViVXdTNHQ3QndwakhidkFJN3dkdWQrd3JK?=
 =?utf-8?B?VTQxWFRWK3k5V3JFeFFBSjdLZlNVRlhtcE5vcnh2RnFYbjZaem9NaDBUdXF6?=
 =?utf-8?B?QkxDKytEbU9FWmg2TFJNczNPRlRBcS9Fcy9hSWxSZi9SeUk0V2VuNklYRnNT?=
 =?utf-8?B?U0Z0RlJvL29uQ0VHbEIvRWlMR0lwR0xPWWEwVGZkRHBBaUtvcUZHZG1vWjlS?=
 =?utf-8?B?K1ZydTRyWHUxMzBCQXh6RWRzLzNhWjJ2SG00Nzk0NjdzbTZMWW0ycDVmU2dL?=
 =?utf-8?B?RU1LR1BYK2U2M1llemZmTkFGSGppVGRUL2ZkMFBqaFVUK3pWYndLL2tVTWpV?=
 =?utf-8?B?djhSeGRveVVXWC9qUWJPbzQxVHZ2VE1vb2ExRXUwbjBDa01aUDdNRWtzYlor?=
 =?utf-8?B?aUNIWUk5d3VGQXJ3Z0hTUjhVc1FyL3p1Zm9ES3BlTWkyRkFteUxMQUo3ajNp?=
 =?utf-8?B?dUxUNDVBTVkvRGJFWkdNZmFuOHpYR1g4bjF3SUdXQ093VE9SZHlzR3RjeHRk?=
 =?utf-8?B?ZjBtaVpaSGRxY3RuTkR4dUpQTVN0U0MvYnBRdW8rNGVSNTVSQzJ0anBESEly?=
 =?utf-8?B?aWc4YmpsYzY1dldocjM4NWRFbngvR1pyQ1RLSS9JWkZwdExGSm5peU5TdWhm?=
 =?utf-8?B?WTY0SkZEOHRqWXd4ZlhlYko2NFZ5S0VGWmJTOGNhZXh4RU9uNGZFWldVRGVY?=
 =?utf-8?B?dGdFcXZDOEY3d3NNUVdXY0RtOGZiZkRCRUJ2WDdyRXJ3TEdzWlljalRqV2RD?=
 =?utf-8?B?aFU2cjB3V2czVTM0UUY2MlJWdW81SEVlNStWK1M1MnpLb0tham0vUVlPYit4?=
 =?utf-8?B?T2NwQzBSaEZjRk00US9VWnBLM1ZSSkx2NWRlQTV0ZmZMTVRFV3JqY3lNU3FX?=
 =?utf-8?B?QUdidzhGTXJYQ012Um0zM2tLbE14RFNLQzRHR08xY1R6QnBFdnlPcmpXYlB2?=
 =?utf-8?B?SmJMYXI3dmpuTUtrREFrTCtlNTFNWW1BUHZJVnRhTG9YUGs0VTdjYTEwRFcv?=
 =?utf-8?B?UVE2bjVwMVdWY2YxMWxFclY0cFppbkcrcTBXN3BRN1VPQjhFMmF2bGZuLzFz?=
 =?utf-8?B?NlFoVzErSjFGUE0yQmNPN2dzNGErQlZZd3NLZjAwMW9Ma2MyWmtTN1A5VVRF?=
 =?utf-8?B?UkJMenFNNk10Nmg0dzBwUi91azhvS2RWZEMwbEdtYTdFdzN5dDdzV2R6OVRv?=
 =?utf-8?B?a2xISGQ0Y0c1VjBXT2tBVzZRamlYYURsK2hNMTYyNERjMy9KQXRTdlFSTG54?=
 =?utf-8?B?L0trWVZGZi8xTDN3OThCOTYydFNTcUdwMTgxR3hVTzdQU3ltQTBZRzNNTU9m?=
 =?utf-8?B?TkFmb1RBYTFxU0hVeDZ2VGNsTmZzVDM3eWhVdG0rcU5vY09RNUNqODYxYkcr?=
 =?utf-8?B?d1BDbXQxUlMrZGRYdXFzaVdtc1hON2llKzEvYzRycnlvZ1REa0pQOHpEZkox?=
 =?utf-8?B?UVNiN2gyNlFQempGTXI1ZEU3ZGJYTURTY0NXVFZ3K0psK3FFeHpXTW9xNlhi?=
 =?utf-8?B?b2lUdk1rVlFXR0U1eWxJRGFwOTZKZjdibHljQzkvTmpBQlhQa2k2dmxyeVlN?=
 =?utf-8?B?ZVhYNzA3dkNTNUtvcTBrMXIreFlRQXNlOXVUNG1SZ0E3TzRycGdncVFLelM1?=
 =?utf-8?B?WUR6RXBZUGFhWFJzZ3NkcXpkSWZrUmxHMkJQSGlFTnA4VTNPcHJZcmF6UmlR?=
 =?utf-8?B?ak5DSG5tNmd1R2ZOQXRhYkM5aXk5dlJONG0wMHdiKzYybi8zeVNOeGRNSWxp?=
 =?utf-8?B?T09SejN0aE9CeXErODZ6Uk1GQXNja2tnMDdWM1JzTXZ6NmoyQU83UUM1TFE5?=
 =?utf-8?B?MFhjaVBkczFFK2tCYUtrNDA0Vk43MUgxekNtVEZZM0tjRkFKZkcrWnBBTUdX?=
 =?utf-8?B?VDRjVGp1SFRndHZPc2VYQ3EyK1ZyL3B3NmdDUEswZ1V2ZlJObHJnWGV2RHZL?=
 =?utf-8?B?aWZVSHExNXpuckhxdWFzd3pMWVJvemtOVVp1enRVWG94RVR2VmxMMG9jbkpw?=
 =?utf-8?B?Rzh1bSs5bGhIMWx1NjVURzJ0UEM5czZhMHg2YUgwa1Q1OWs4ZHozZ3ZiR2Vq?=
 =?utf-8?B?RHR6UFJRQ0J0MloySDJYVFdoSWxnUEtHZ2JvMnhnY1duOE9JWG9OWmkwOFRV?=
 =?utf-8?B?aVYrcWtVMlBjMDNQTFYwMTBGY1VtMnlRbDlUTnViYW9WUnhWam44Q2ZRU0Nk?=
 =?utf-8?B?TDIzVUp0MXdWVkRWMHFDN0hQV2FFeFNmaHh2RXBpSWtJNSt4cWRWdUQwNFRD?=
 =?utf-8?Q?yXCEF3hwl1aQ4VbL0O?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a12c4ef3-c382-430e-a991-08deac470a36
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 14:43:44.9224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5axg4jhD3qqK0F8Wz09Q2PA6VeVs/XSWxCsf2hTXm/P2w4e2tSQN6QDoIz3qGBL6aQgWVbTb5EwqJcqt3X2Biw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8693

On 5/6/26 21:36, Stepan Ionichev wrote:
> dsm_create() initially checks pdev->bus when computing segment_id:
> 
> 	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;
> 
> But the next two lines unconditionally dereference pdev->bus via
> pcie_find_root_port() and especially pci_dev_id(pdev), which expands
> to PCI_DEVID(dev->bus->number, dev->devfn). If pdev->bus is in fact
> NULL, segment_id is initialised to 0 but the very next statement
> crashes the kernel.
> 
> smatch flags this:
> 
>   drivers/crypto/ccp/sev-dev-tsm.c:253 dsm_create() error: we
>     previously assumed 'pdev->bus' could be null (see line 251)
> 
> Make the NULL handling consistent: if pdev->bus is NULL the device
> has no PCI context to work with and SEV TIO setup cannot proceed,
> so return -ENODEV before any of the bus-dependent lookups. The
> remaining initialisation now runs only on the path where pdev->bus
> is known to be valid.
> 
> No change for callers where pdev->bus is non-NULL, which is the
> only case where dsm_create() did meaningful work before this change.
> 
> Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>

This should have a Fixes: tag, which would have then added the main author
of the file to the email, so adding Alexey Kardashevskiy manually.

@Alexey, please also submit a patch to make yourself a maintainer of the
TIO/TSM support.

Thanks,
Tom

> ---
>  drivers/crypto/ccp/sev-dev-tsm.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
> index b07ae529b..f303d8f55 100644
> --- a/drivers/crypto/ccp/sev-dev-tsm.c
> +++ b/drivers/crypto/ccp/sev-dev-tsm.c
> @@ -248,12 +248,19 @@ static void dsm_remove(struct pci_tsm *tsm)
>  static int dsm_create(struct tio_dsm *dsm)
>  {
>  	struct pci_dev *pdev = dsm->tsm.base_tsm.pdev;
> -	u8 segment_id = pdev->bus ? pci_domain_nr(pdev->bus) : 0;
> -	struct pci_dev *rootport = pcie_find_root_port(pdev);
> -	u16 device_id = pci_dev_id(pdev);
> +	struct pci_dev *rootport;
> +	u8 segment_id;
> +	u16 device_id;
>  	u16 root_port_id;
>  	u32 lnkcap = 0;
>  
> +	if (!pdev->bus)
> +		return -ENODEV;
> +
> +	segment_id = pci_domain_nr(pdev->bus);
> +	rootport = pcie_find_root_port(pdev);
> +	device_id = pci_dev_id(pdev);
> +
>  	if (pci_read_config_dword(rootport, pci_pcie_cap(rootport) + PCI_EXP_LNKCAP,
>  				  &lnkcap))
>  		return -ENODEV;

