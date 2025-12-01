Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011016.outbound.protection.outlook.com [52.101.52.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B943523EABC;
	Mon,  1 Dec 2025 08:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764576552; cv=fail; b=Xf5EBtCso4PrkOhqnafOt3MYReW2cVIdaTRD8KJQEbM2lUCtAdcSJCw1bMR5LNX25lgt9KmCHmKRCedGCDfyINQrNnoUoN52JPWrmj4Owp4tCbPfqYXpQ0v7QOj4IRlk2plHXZSZPi0xc/2OD+p9+Pr5QwvVk7HwoAmFJRk9+Bw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764576552; c=relaxed/simple;
	bh=MbyYoq9t/SHXhsBMtgpJICZNP/lke8FhXaGV4DNYHPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=hL1fru7vF5INS5n3cL7VTEVpOWEAAWArgMm2XtouuWU0o2+PHrqBvwNTx1cV3UevugmOoPJs6y91SQrlMPIkvAh77Xp4NcYL9bl3mJuw5ZbBkLLD/vIw3cQyugZhPKLO9ts3OaidDU0fY1AJQVUYNnT6wgXi+JhjXkvrTg9P0t8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WFQnFF77; arc=fail smtp.client-ip=52.101.52.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WFQnFF77"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d1pHk2joQc7HsdtqUtcDZytsEk5nA/bR65Q8grkCsnZ4xRYc4g2RzbduA+8Lm+a6JmM/BQFkJ9Y0TIorOTT5Z6e72dF/pKT8gzwrmpzYDrVMzpnfmz0Z8WTLG32g1y8Rx5U3l2jtGFi1e7LV0TqKDUdotnPZhXDbBM2VWuf8EA9XWwQj6kQ/O4tuQyQVjkcOeN91Iis88OF6zeCqr8D/TZsb3/jKF6dxkTiPZPCR4/9w0xdXVUvugXG1tsQs9d724nFLa/8kCUQEc+EKzrqQDeIBAy8BvHA76NRAMmluMRWlW5ssgx/gHDvxLbHw7QzBZ1wI+uWoBsjVT+yFc0w36w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8lVEtSR7h1/vIVih+UgDpEs8qcLr1iuUQkJ9hbjaZQ=;
 b=bW99wI3xF9dDHyLq9qL77t4OBLPV5eL7qgcPd4imbLpAxMjdy06ewwEdw2kB7cMwOC2AykjHXXVhEsSwtwgs9VSl532e2LKyOrcxvLOi/T7yUza+kI7Q+5bZz3SWbPCH2aJEotPN6Frz1Idty1REGFNgQkKWRQr1eNlRBT09dcHCw6dLkBsnteSUHzuLrA4zOL1myaF4Yd3e5krIjAiY7wujjiVEYlXnYs+jg5JYHrI6IsHaan452TGJW1vajk6pmKsHGOL9g+fNV9lhUe7SspUIwPe/aRe/qgXd45EgAGKPVfOlafXUER/2VJYKuS2XmFW9r2ybg0Kq8rj3sN53Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8lVEtSR7h1/vIVih+UgDpEs8qcLr1iuUQkJ9hbjaZQ=;
 b=WFQnFF77yAnrk7kBIykWrNpRhRok6bHm9GWyHDCDytmILQu21VR6Izwn5gTIoVR8X3ERGPuIRMppGwEkcf9bGHuxm79lcL2UYDwt7aUR7+UmfqhjX8R0zPtCCPuL3KewTNkJKH3sF2FslrffK9wROjR+CiFx7suo+y4OjRqGuMQ=
Received: from SJ0PR05CA0142.namprd05.prod.outlook.com (2603:10b6:a03:33d::27)
 by CY8PR12MB7290.namprd12.prod.outlook.com (2603:10b6:930:55::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Mon, 1 Dec
 2025 08:09:06 +0000
Received: from MWH0EPF000971E5.namprd02.prod.outlook.com
 (2603:10b6:a03:33d:cafe::a6) by SJ0PR05CA0142.outlook.office365.com
 (2603:10b6:a03:33d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.9 via Frontend Transport; Mon, 1
 Dec 2025 08:08:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 MWH0EPF000971E5.mail.protection.outlook.com (10.167.243.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Mon, 1 Dec 2025 08:09:05 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.17; Mon, 1 Dec
 2025 02:09:05 -0600
Received: from satlexmb08.amd.com (10.181.42.217) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 1 Dec
 2025 02:09:05 -0600
Received: from [172.31.185.117] (10.180.168.240) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server id 15.2.2562.17 via Frontend
 Transport; Mon, 1 Dec 2025 00:09:01 -0800
Message-ID: <1e930d39-164a-4ec3-9452-b8d084dfb133@amd.com>
Date: Mon, 1 Dec 2025 13:39:00 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH kernel] crypto/ccp: Fix no-TSM build in SEV-TIO PCIe IDE
To: Alexey Kardashevskiy <aik@amd.com>, <linux-crypto@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Herbert
 Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
	Dan Williams <dan.j.williams@intel.com>, "Borislav Petkov (AMD)"
	<bp@alien8.de>, <linux-coco@lists.linux.dev>, Srikanth Aithal
	<Srikanth.Aithal@amd.com>
References: <https://lore.kernel.org/r/ffbe5f5f-48c6-42b0-9f62-36fb0a4f67ab@amd.com>
 <20251201075257.484492-1-aik@amd.com>
Content-Language: en-US
From: "Aithal, Srikanth" <sraithal@amd.com>
In-Reply-To: <20251201075257.484492-1-aik@amd.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Received-SPF: None (SATLEXMB04.amd.com: sraithal@amd.com does not designate
 permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E5:EE_|CY8PR12MB7290:EE_
X-MS-Office365-Filtering-Correlation-Id: 90ccafe5-7443-40a6-bdfd-08de30b0e5b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UXZTQ2hRTDE0a3pkQVhveEptV1FOUXAxNDh2bEZOZUIzTHpEVEYvQm1nd2p4?=
 =?utf-8?B?L0dCeWhUeWFWMncvVnBNSXBCSEdFSlRaMlMwdTJaem0ya25EQk1VVlIwV3RK?=
 =?utf-8?B?U3VXNFA3TTFVOEs1TWc1bVNLK3Jac1JaY29jdG5FOVdMcVhTeE55RzhoeUFk?=
 =?utf-8?B?UGI5QmJsNy9ucFdibGszN29LTzJFZXJkTEFWMkx3cGw2UHFTNnhwMGZmOWVT?=
 =?utf-8?B?VjQ2WVB1RVdqQzl0UkdmZW1TWmFMcWNmTHl6c1FsYlhOVE5iUmdzVVBHSXVZ?=
 =?utf-8?B?SENoSW9qZDNRL0NhcDJMRzdJaUZQNEtiQSttUEpCMjdCUVBrcFp4RzJEZjlN?=
 =?utf-8?B?N1loRExUSVlzMjVXSGZibkcyUmJBQlI1Z2tQMXlkbkkxRDllMjUwZGxZMUM1?=
 =?utf-8?B?TVBUZy9qTGtxN0lielBTaFl0eVdyTFpGeWRhSzFBTE5ZNmZKVVdpQ0I3MkN5?=
 =?utf-8?B?QUtycTY0MlVOTitnSUx1RFBYamVKUHF0NkppWVJyUlRpWjE0emZkbk1vVFBK?=
 =?utf-8?B?WkkxWEJjZzZrNWxsQ2xVbUJxZ1h3NmY5by9tZEo2K3ZJVlB0c0h5bFN2RWx3?=
 =?utf-8?B?VHVadnh6M1VTMGlHTjN1M0FWcGJ3V0VVY0ovNHFJWXNBRkRxMkRwc0g0NnRV?=
 =?utf-8?B?T0x4NTdUaDEyNENJVmFza0hkMnVzMURBZnhxYkwzdWhxSjdQb3E5bFhkNmZr?=
 =?utf-8?B?NDlJaG5hSUF1RHRPREdobWxqczQzaTV1VWVsdW5qdmxBTkhhcFB1YUQxZTQ3?=
 =?utf-8?B?THAxdW9aYXN4V1JhbjhuQ3dKUlA5OUxObHdTWGs0TExTaEQvMkFSQUNKNUxF?=
 =?utf-8?B?Z0NmTHlsdzlaNjQxNDRXTVZsekx5N2pIWm5PUjgyZ2RldThpRXpnM204eVhP?=
 =?utf-8?B?dEVnQXVpVUUzSmZUdmVlVlRQc3M5L3d4eDF2eXp0WDhKL3A5SEkwVUlVelJF?=
 =?utf-8?B?VllROFp4YmlWTW5jTzhkcURvaGRheGpBWjZhQThnK2Q2WENZeFdoa0YxUmN0?=
 =?utf-8?B?SmUxRHJ3UHBxNDNSV0g1MEFVVjQ0OUxEVktvSnBIRVNZbm9oRjY5MUJ5OWJk?=
 =?utf-8?B?aEp4ZnpZUWRHNmxZeEt5M3haVjB0dHNleGR3Sk5qUEg1aHRjajhieENrQ1ly?=
 =?utf-8?B?RVJTRlZWQ0dydUxiQzZ3ZzhCMDZJc2lXeGFKeHNhTDRqbGp3OTgzMnRiZE52?=
 =?utf-8?B?OGtNRGZISkhWQ0VlSE9GUkpyTitETjZxdklYenhtS1R6ZkQvUENhZmFkc21S?=
 =?utf-8?B?T0pMRkNrZHB4SEw0a2RMNHJTQ09WSG9yT1BYYjYwM1I5QUQ5NFlCbnBEamYz?=
 =?utf-8?B?QUM5QVhIV3VxMzlRVUo5R3JaSDZSc1FFdTlWcXA5K0J2VVowak84YUgwS3FN?=
 =?utf-8?B?aGNlZndOd29jWVFQbWZyNEx2SVlJaGhIWS9ML2NNaWpISm9PNmQzMVRFVjFs?=
 =?utf-8?B?OVpRL1cwUFNwbGx6T2NXR3ZvZjVlNjNwUTM5b0hRYjBpYnpUMlp5OGhock9L?=
 =?utf-8?B?OVdHdFV3eVpmWHJRVkJ5VUxVaUtzSFBhcDU4VWdXWVA3MmZPQjYwdlA0WFVo?=
 =?utf-8?B?WmU0SnpZRVlWQStyQ3JuVGhCUkhDQUJjNG1qU21Da0RyRU5PM3JnbkptQTBX?=
 =?utf-8?B?ZUtaNS9XSzJXSS9MVS9aM3pHYmp1aVpCQjEyYVpTakEyK1BpL3JiYVorK3Nv?=
 =?utf-8?B?bHlJRUZlTU9uWTMwSE43VStZRGplQjRQT1JYYWtHOVhuY1RpOU5Nd0tlRHFT?=
 =?utf-8?B?LzdNOEVpTmJOVzRrYk5nQ1RtRG9nOEhBZGNENEZ5TVJ5K2x5QUFOaW9qbm40?=
 =?utf-8?B?RzZsNmJ2VEFjVEYwamdLS0JKMGFDTWNIS1RISWdMRjlOWTdmRHJMeGVmWnBl?=
 =?utf-8?B?RW1QMTNzTFZpMENTb3RrbDU1OE5uS2FvcU56dDRkVU1PTVNVQUJmSTVCTUtH?=
 =?utf-8?B?ZUpXQmJJcmhycGxwWXAyeE93VEJyblRySm42M2NsUVhMTEV3cHVCV2p5UHdi?=
 =?utf-8?B?TzdVR3VzZURIbjhmdUF4TUh2cG9ZYWVRNGJESkpFZ0RIZ2xpd2J3cWVwZ1V5?=
 =?utf-8?B?emdUZUtyVENUZ0poZ0J0TVgxcEYrbjA1akNGVkRUSWdvMlJuRXNGRFlJdzho?=
 =?utf-8?Q?RU3A=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2025 08:09:05.7998
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90ccafe5-7443-40a6-bdfd-08de30b0e5b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E5.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7290

On 12/1/2025 1:22 PM, Alexey Kardashevskiy wrote:
> Here are some cleanups for disable TSM+IDE.
> 
> Fixes: 3532f6154971 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
> Reported-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
> Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> ---
> 
> Better be just squashed into 3532f6154971 while it is in the next.
> ---
>   drivers/crypto/ccp/sev-dev-tio.h | 12 ------------
>   drivers/crypto/ccp/sev-dev.h     |  8 ++++++++
>   drivers/crypto/ccp/sev-dev.c     | 12 ++++--------
>   3 files changed, 12 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev-tio.h b/drivers/crypto/ccp/sev-dev-tio.h
> index 7c42351210ef..71f232a2b08b 100644
> --- a/drivers/crypto/ccp/sev-dev-tio.h
> +++ b/drivers/crypto/ccp/sev-dev-tio.h
> @@ -7,8 +7,6 @@
>   #include <linux/pci-ide.h>
>   #include <uapi/linux/psp-sev.h>
>   
> -#if defined(CONFIG_CRYPTO_DEV_SP_PSP)
> -
>   struct sla_addr_t {
>   	union {
>   		u64 sla;
> @@ -129,14 +127,4 @@ int sev_tio_dev_connect(struct tsm_dsm_tio *dev_data, u8 tc_mask, u8 ids[8], u8
>   int sev_tio_dev_disconnect(struct tsm_dsm_tio *dev_data, bool force);
>   int sev_tio_dev_reclaim(struct tsm_dsm_tio *dev_data);
>   
> -#endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
> -
> -#if defined(CONFIG_PCI_TSM)
> -void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
> -void sev_tsm_uninit(struct sev_device *sev);
> -int sev_tio_cmd_buffer_len(int cmd);
> -#else
> -static inline int sev_tio_cmd_buffer_len(int cmd) { return 0; }
> -#endif
> -
>   #endif	/* __PSP_SEV_TIO_H__ */
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index dced4a8e9f01..d3e506206dbd 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -81,4 +81,12 @@ void sev_pci_exit(void);
>   struct page *snp_alloc_hv_fixed_pages(unsigned int num_2mb_pages);
>   void snp_free_hv_fixed_pages(struct page *page);
>   
> +#if defined(CONFIG_PCI_TSM)
> +void sev_tsm_init_locked(struct sev_device *sev, void *tio_status_page);
> +void sev_tsm_uninit(struct sev_device *sev);
> +int sev_tio_cmd_buffer_len(int cmd);
> +#else
> +static inline int sev_tio_cmd_buffer_len(int cmd) { return 0; }
> +#endif
> +
>   #endif /* __SEV_DEV_H */
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 365867f381e9..67ea9b30159a 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -38,7 +38,6 @@
>   
>   #include "psp-dev.h"
>   #include "sev-dev.h"
> -#include "sev-dev-tio.h"
>   
>   #define DEVICE_NAME		"sev"
>   #define SEV_FW_FILE		"amd/sev.fw"
> @@ -1365,11 +1364,6 @@ static int snp_filter_reserved_mem_regions(struct resource *rs, void *arg)
>   	return 0;
>   }
>   
> -static bool sev_tio_present(struct sev_device *sev)
> -{
> -	return (sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED) != 0;
> -}
> -
>   static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>   {
>   	struct psp_device *psp = psp_master;
> @@ -1448,10 +1442,12 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
>   		data.list_paddr = __psp_pa(snp_range_list);
>   
>   #if defined(CONFIG_PCI_TSM)
> -		data.tio_en = sev_tio_present(sev) &&
> +		bool tio_supp = !!(sev->snp_feat_info_0.ebx & SNP_SEV_TIO_SUPPORTED);
> +
> +		data.tio_en = tio_supp &&
>   			sev_tio_enabled && psp_init_on_probe &&
>   			amd_iommu_sev_tio_supported();
> -		if (sev_tio_present(sev) && !psp_init_on_probe)
> +		if (tio_supp && !psp_init_on_probe)
>   			dev_warn(sev->dev, "SEV-TIO as incompatible with psp_init_on_probe=0\n");
>   #endif
>   		cmd = SEV_CMD_SNP_INIT_EX;

This fixes the issue. Thank you.
Tested-by: Srikanth Aithal <Srikanth.Aithal@amd.com>
