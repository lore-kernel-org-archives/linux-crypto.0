Return-Path: <SRS0=sRio=6G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 536F8C54FCB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 15:11:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 282B521473
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Apr 2020 15:11:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="coYbfQ8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbgDVPLX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 11:11:23 -0400
Received: from mail-bn8nam12on2058.outbound.protection.outlook.com ([40.107.237.58]:26816
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726006AbgDVPLW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 11:11:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kjZdBNijdVATkbSsIQZW/VHaAatpZoJ0G63Vt7dJBoSRNTMgo6opikATinN+CHNiQv9GuCtAfTKkKV5oLaYH3zmiZS3gXUoLkMfbwA3Qu4MZ8pAS1RZlQt8Ic+KO6fOy99E/ZyZ2ONzs7qelYtPz9YCmsXgSpQbjM9K48TIHoCxEcZg+HFTgGulANhuqv5tNIiUDO4YKWnDZXjBeYj2DVuNyNqnZPYHTgtJzFK/vuJFntmkfb/5S975DDqfqqoUjpZGmryEb8NqKUlOMxeGj8B21uLLQyNVTNqAS0syn+BDiGRjXSGXrS7WJdXqusfaTIy6sukeRtwuBBOErjfWrzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0nhrjVXJD4vuqDd/Sr3luCsXeL6CZ5pHqdlBRWYT5o=;
 b=jw0sF0RKV1d6V0yxTAa/d2fVwQCq/2l7Xi2BoVMt4DwFYPnvOfAAqjKLkYBiEIhyXb2VJ5URHkGL6DLyGZiEZUDbX1GVepPL/KC+5MW9pE9sVkKvG4BPsRLxa4+QXYEtkrOFiP4kIjJgW++H5ud9qLTx5t+qL+T5amWOq7WQYNORTKKhoMg6Ht2ZpyShVrEkOdwxonchYU36IPnnWamFJnC+bxTYUmshP/xab5OjoMp8w1iORk6aSaHZLTQxkf12YfaZ1ZHUjxIxz8Us0KUSgpycFpyFCQau3L2Ji+mzNrfOFb6Kx/2lJ7PQnAYWwlnTTQEYoowwsx6OlwkO0pcaTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0nhrjVXJD4vuqDd/Sr3luCsXeL6CZ5pHqdlBRWYT5o=;
 b=coYbfQ8uhct4H3RNJQTJl+rfdd0fS0PXbUXCO14D4uYNGVwlBQu3P7BxTQC2Rreq9zloTvLxY5CY3hnWPXFpXjLzE470uiu7Ut7bhCQfQzNhAD6/FugU25cBszxpvU7mmgfaEXHJJZL6IPiB9bDydVjVAuSxi5Yubs2Mn6b79lE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=brijesh.singh@amd.com; 
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Wed, 22 Apr
 2020 15:11:19 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::38b5:63c2:6c7c:d03d]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::38b5:63c2:6c7c:d03d%8]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 15:11:19 +0000
Cc:     brijesh.singh@amd.com, Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2] crypto: ccp: Add support for SEV-ES to the PSP driver
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
References: <9530369b1f0be211ae2512a1ab9f54281a4420d9.1587491088.git.thomas.lendacky@amd.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <49205c0d-91a4-8013-18f6-411da302783f@amd.com>
Date:   Wed, 22 Apr 2020 10:11:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <9530369b1f0be211ae2512a1ab9f54281a4420d9.1587491088.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN2PR01CA0052.prod.exchangelabs.com (2603:10b6:800::20) To
 SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN2PR01CA0052.prod.exchangelabs.com (2603:10b6:800::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Wed, 22 Apr 2020 15:11:19 +0000
X-Originating-IP: [70.112.153.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b59b636-472c-4745-e04f-08d7e6cf694d
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:|SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB43842ADF7BAA85721DAA371BE5D20@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(956004)(16526019)(31686004)(54906003)(8936002)(5660300002)(81156014)(36756003)(6506007)(316002)(6512007)(26005)(478600001)(53546011)(186003)(52116002)(6486002)(31696002)(2906002)(44832011)(2616005)(86362001)(66476007)(66946007)(4326008)(6666004)(66556008)(8676002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZ5EOGJhyXBvUKtVsg1C+hBBFZz9AB6ENg0zFziZEwr7xOUyhTcGVvnYV7Xym5v0yDyy6m1NEeDKVAA0eX5nEySSHKmGUDeE//DHHm8uOhlv/IJVJ0rVV2oymIEreADCnPs3dS8oNsMpD2DO0sH8EUc+mKyamH1DhRm8HivkOAK9l6aDsoWZx5FM6H/TI3IB011MPEIm91pIa/vBOxOLWv2DwFRyWRkfbqOQGiige40M9osnTTxDptY+r+fYYYXzXo/DJrknWSZYxpQmOolSYB5p0A1G/LT04Dtqaj0wtukYoLbblMBKCN0H6uVJbtrh015w4SwhFZnJ4+Os4Edi/mkmruTvZFYE2TX3YHklQ4ogQuSZoWTue1r2oadqSx4Bd9SkYCVmBRjWrsRg/8YZID1H3WhQl+eTEzV3L9ZT8mhkhVwi8wkkMonQyNWAcLQO
X-MS-Exchange-AntiSpam-MessageData: +Kv65zQCKXU1jRVH2kVrFA6ngdD7oSg+G2mUx0dfFpUxxFSLHPmYpNVqwjyKRR5uRu4bDYjJosgdhAEQjGjZ5QBShZTshDPZFqdqoopO+sU6ajw/uqaqYBSAguUh1Ebg/78pMNp/yW30OTsVhmEPMw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b59b636-472c-4745-e04f-08d7e6cf694d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 15:11:19.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+XzGGeLderewD+WltKfy4Sg+QbQ7G4ceYTLyKWH5GfF6kw5Q8o/cSChmJOS2Gz/Oc8CSy9cVcWGLSFtHuwYlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 4/21/20 12:44 PM, Tom Lendacky wrote:
> To provide support for SEV-ES, the hypervisor must provide an area of
> memory to the PSP. Once this Trusted Memory Region (TMR) is provided to
> the PSP, the contents of this area of memory are no longer available to
> the x86.
>
> Update the PSP driver to allocate a 1MB region for the TMR that is 1MB
> aligned and then provide it to the PSP through the SEV INIT command.
>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>
> ---


Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>


> Changes since v1:
> - No need to over-allocate the memory area to obtain the required
>   alignment when using the page allocator.
> ---
>  drivers/crypto/ccp/sev-dev.c | 43 ++++++++++++++++++++++++++++++++++++
>  include/linux/psp-sev.h      |  2 ++
>  include/uapi/linux/psp-sev.h |  2 ++
>  3 files changed, 47 insertions(+)
>
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 896f190b9a50..439cd737076e 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -20,6 +20,7 @@
>  #include <linux/hw_random.h>
>  #include <linux/ccp.h>
>  #include <linux/firmware.h>
> +#include <linux/gfp.h>
>  
>  #include <asm/smp.h>
>  
> @@ -44,6 +45,14 @@ MODULE_PARM_DESC(psp_probe_timeout, " default timeout value, in seconds, during
>  static bool psp_dead;
>  static int psp_timeout;
>  
> +/* Trusted Memory Region (TMR):
> + *   The TMR is a 1MB area that must be 1MB aligned.  Use the page allocator
> + *   to allocate the memory, which will return aligned memory for the specified
> + *   allocation order.
> + */
> +#define SEV_ES_TMR_SIZE		(1024 * 1024)
> +static void *sev_es_tmr;
> +
>  static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> @@ -214,6 +223,20 @@ static int __sev_platform_init_locked(int *error)
>  	if (sev->state == SEV_STATE_INIT)
>  		return 0;
>  
> +	if (sev_es_tmr) {
> +		u64 tmr_pa;
> +
> +		/*
> +		 * Do not include the encryption mask on the physical
> +		 * address of the TMR (firmware should clear it anyway).
> +		 */
> +		tmr_pa = __pa(sev_es_tmr);
> +
> +		sev->init_cmd_buf.flags |= SEV_INIT_FLAGS_SEV_ES;
> +		sev->init_cmd_buf.tmr_address = tmr_pa;
> +		sev->init_cmd_buf.tmr_len = SEV_ES_TMR_SIZE;
> +	}
> +
>  	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &sev->init_cmd_buf, error);
>  	if (rc)
>  		return rc;
> @@ -1012,6 +1035,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>  void sev_pci_init(void)
>  {
>  	struct sev_device *sev = psp_master->sev_data;
> +	struct page *tmr_page;
>  	int error, rc;
>  
>  	if (!sev)
> @@ -1041,6 +1065,16 @@ void sev_pci_init(void)
>  	    sev_update_firmware(sev->dev) == 0)
>  		sev_get_api_version();
>  
> +	/* Obtain the TMR memory area for SEV-ES use */
> +	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
> +	if (tmr_page) {
> +		sev_es_tmr = page_address(tmr_page);
> +	} else {
> +		sev_es_tmr = NULL;
> +		dev_warn(sev->dev,
> +			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
> +	}
> +
>  	/* Initialize the platform */
>  	rc = sev_platform_init(&error);
>  	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
> @@ -1075,4 +1109,13 @@ void sev_pci_exit(void)
>  		return;
>  
>  	sev_platform_shutdown(NULL);
> +
> +	if (sev_es_tmr) {
> +		/* The TMR area was encrypted, flush it from the cache */
> +		wbinvd_on_all_cpus();
> +
> +		free_pages((unsigned long)sev_es_tmr,
> +			   get_order(SEV_ES_TMR_SIZE));
> +		sev_es_tmr = NULL;
> +	}
>  }
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 5167bf2bfc75..7fbc8679145c 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -100,6 +100,8 @@ struct sev_data_init {
>  	u32 tmr_len;			/* In */
>  } __packed;
>  
> +#define SEV_INIT_FLAGS_SEV_ES	0x01
> +
>  /**
>   * struct sev_data_pek_csr - PEK_CSR command parameters
>   *
> diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
> index 0549a5c622bf..91b4c63d5cbf 100644
> --- a/include/uapi/linux/psp-sev.h
> +++ b/include/uapi/linux/psp-sev.h
> @@ -83,6 +83,8 @@ struct sev_user_data_status {
>  	__u32 guest_count;			/* Out */
>  } __packed;
>  
> +#define SEV_STATUS_FLAGS_CONFIG_ES	0x0100
> +
>  /**
>   * struct sev_user_data_pek_csr - PEK_CSR command parameters
>   *
