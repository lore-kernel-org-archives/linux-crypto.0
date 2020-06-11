Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80251C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 20:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5025720838
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 20:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="1KP5tli1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgFKUrz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 16:47:55 -0400
Received: from mail-bn8nam11on2052.outbound.protection.outlook.com ([40.107.236.52]:10176
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725869AbgFKUrz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 16:47:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaLyHkbrDnmypjRhrHi4s7XaORHNGl6Au6gxnOTXqlag079NPdpTMeYm5G+sIIQYEtdBhnL+IpxCJw1Vnv6xEQpP8RuJfnicXs7X3vNz3V4ONHKCr6qTBA5lL4iVXslclEkzRatqUbY2ce2eVcLqeJlaPepLkBKBccKMD7Ej3WS5Sp0mky1OVdc/F3YQVl5CbG2WgE1mhpNPGl3rjdFTlXW7fDxyEOVMRYkjUZtg5scJVZbblCd5SvT40Bp+uEAlBHk2U1Klcz0RU9YfG8PK8X7XANN6F9F+PfomKA/R8q2Oh7biFJt8T/MvKKIe11EqY2klalY4UtNJLwKlv4/Wfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zElgi5oyA4AT5kXSg6efqBjJdWmXtfI2K4Be5fGOhdM=;
 b=c1apRVIsqvigNu+KHXqTS/Q7avWmxqgZAOLhu4NbT54kbpHyT8HXmAP14Yxi7jCb6ic5pp+eTuTaJ7SBcdyB+NySaPc1enpXHcUHzVmZjQAWD9NONE5jfvtFHMzNH7bdB+EAwqD+KqUXs9DtJ43IF6Fey+Mr6GvsEDbeI31qhwDIP8GY26lwmQfl3iY+uPZyzo0bqeFBJ1VcZUE2WcZ+K5PjIsKkDavxMD6kpis/39Wbv1NC6knYwMmXEPHxXBd66BvMVjEzP5wUWpfNSmUUikmoYNG+2Sf3nQxeA9osA6N39eM0ClKFe9DjGxfrY4n3TM3U/DR8tavX5RuEvYhcUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zElgi5oyA4AT5kXSg6efqBjJdWmXtfI2K4Be5fGOhdM=;
 b=1KP5tli1hF12kegyWkitheA2rIzhdCvtBa8XCuPjRrPF57eFMHz5D41127grmKSKL5N5tbjX2rhABfemDrfpzoOWiqNhNACptYArP10E5BIozUgBc9xLQNpmJ+mzcs1ZBvXoZBJx87QGOXo+ThQMYqotcze+wps5EX9kekrlU24=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13)
 by SA0PR12MB4381.namprd12.prod.outlook.com (2603:10b6:806:70::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.20; Thu, 11 Jun
 2020 20:47:50 +0000
Received: from SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::698e:73e7:484d:e3c9]) by SA0PR12MB4400.namprd12.prod.outlook.com
 ([fe80::698e:73e7:484d:e3c9%3]) with mapi id 15.20.3088.018; Thu, 11 Jun 2020
 20:47:50 +0000
Cc:     brijesh.singh@amd.com, kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] crypto: ccp - Fix sparse warnings in sev-dev
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
References: <20200604080941.GA8278@gondor.apana.org.au>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <eb7d5079-0515-2e4d-8812-eb3d24fe6bfd@amd.com>
Date:   Thu, 11 Jun 2020 15:47:57 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.1
In-Reply-To: <20200604080941.GA8278@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: DM6PR02CA0118.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::20) To SA0PR12MB4400.namprd12.prod.outlook.com
 (2603:10b6:806:95::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by DM6PR02CA0118.namprd02.prod.outlook.com (2603:10b6:5:1b4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.21 via Frontend Transport; Thu, 11 Jun 2020 20:47:48 +0000
X-Originating-IP: [165.204.77.11]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ae706835-2d93-4589-63e0-08d80e48b43a
X-MS-TrafficTypeDiagnostic: SA0PR12MB4381:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4381F29FEA392A29F2C84F2CE5800@SA0PR12MB4381.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:393;
X-Forefront-PRVS: 0431F981D8
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yw0Y4S9G8EfMeEX3F4j/Nwjnaycqk84ZrkILK9WpZBjD9C4MSehmkwRKHz1c+JK/YPcAfvBO821Euuk2/AEoqHE8H43FsAaVLw8XDaVBLOD6/s6fBpT/gXVZvZqvfWu3svdU1T/lzZh7uwjRIyEo05uj8jJrFwEDAYVY1p91KcPxJVGjMqdev1lmbz9wlE4Cif60kMnVCRAnasmAiNGS0JXZA2j4ETd66iywFQ7F51IkmVQoSvHypzC+1Dq2rMjZ+cHY2ZNCFPUoBhmUtuIeeNIatcRCwoo49KdQCvrumQePftaJop1o4dZAQOoC3l7fXvvTxI9Z5WKVfUVkUCqLHrvOu5iFTWrqsD+w8Nh20yOIJKdmCtAcqc3oNSBAx/Ri
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(36756003)(8676002)(8936002)(16526019)(83380400001)(6506007)(31696002)(86362001)(26005)(31686004)(478600001)(53546011)(186003)(52116002)(4326008)(316002)(6486002)(6512007)(5660300002)(110136005)(2906002)(44832011)(66476007)(66946007)(956004)(2616005)(66556008)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jvn81zFwMHmM/zDHyOculPu6+S4TN7xM4rbCXTnaptDauziatEoUxf6el8WuZOdQ1ArVYJ/V6Oqeea7X1ktBX9KGh+6ZkGcl2Qv+NCw2m4Rj9bW+gMXvV2SRxQTqT6Tw9sqU+72Nwbf6UBcqcMFILwPrwswjoAOg+wgqDRouSk9tiAACumNbmrSdHefBdIuPL9K4EnSNTZZalgFvQHizcET+j0+HzX+a9oFql9+slwP4GcfivnH6HqTSK8oLN7VM4ATj9n/oCnugxgTviBbpzmtxiw9Bzc5qxzGY2dhCs/tChDJbYP26dK4z6sLZeof3DWpSMLADIy5iU9lNEPXPYThjNriRWaMIrMa+jAyV9I4sk4GCRk2XlxDVoxxJmbMXz9vMxTh581UsxRW2Zile/cQnQ//nGc8kT/dzca3ge/CkGPhsaeVa+vzXXNdspOu6AdSD0AxSfTEjjO9NZWfdaPJkcsHA5jPrD/6HhrFaaAk=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae706835-2d93-4589-63e0-08d80e48b43a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2020 20:47:50.1216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZQTtFodUJ3MUOZdVECPy9U0N74LrpLi+JODACe2ezqgC6r1MP/KMoqjHF5KWCvdvZ7/IWMpFicqgmh27dRm0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4381
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 6/4/20 3:09 AM, Herbert Xu wrote:
> This patch fixes a bunch of sparse warnings in sev-dev where the
> __user marking is incorrectly handled.
>
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: 7360e4b14350 ("crypto: ccp: Implement SEV_PEK_CERT_IMPORT...")
> Fixes: e799035609e1 ("crypto: ccp: Implement SEV_PEK_CSR ioctl...")
> Fixes: 76a2b524a4b1 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Fixes: d6112ea0cb34 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>

thanks

> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 439cd737076e..aa576529283b 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -376,6 +376,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_device *sev = psp_master->sev_data;
>  	struct sev_user_data_pek_csr input;
>  	struct sev_data_pek_csr *data;
> +	void __user *input_address;
>  	void *blob = NULL;
>  	int ret;
>  
> @@ -394,7 +395,8 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  		goto cmd;
>  
>  	/* allocate a physically contiguous buffer to store the CSR blob */
> -	if (!access_ok(input.address, input.length) ||
> +	input_address = (void __user *)input.address;
> +	if (!access_ok(input_address, input.length) ||
>  	    input.length > SEV_FW_BLOB_MAX_SIZE) {
>  		ret = -EFAULT;
>  		goto e_free;
> @@ -427,7 +429,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  	if (blob) {
> -		if (copy_to_user((void __user *)input.address, blob, input.length))
> +		if (copy_to_user(input_address, blob, input.length))
>  			ret = -EFAULT;
>  	}
>  
> @@ -438,7 +440,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>  	return ret;
>  }
>  
> -void *psp_copy_user_blob(u64 __user uaddr, u32 len)
> +void *psp_copy_user_blob(u64 uaddr, u32 len)
>  {
>  	if (!uaddr || !len)
>  		return ERR_PTR(-EINVAL);
> @@ -447,7 +449,7 @@ void *psp_copy_user_blob(u64 __user uaddr, u32 len)
>  	if (len > SEV_FW_BLOB_MAX_SIZE)
>  		return ERR_PTR(-EINVAL);
>  
> -	return memdup_user((void __user *)(uintptr_t)uaddr, len);
> +	return memdup_user((void __user *)uaddr, len);
>  }
>  EXPORT_SYMBOL_GPL(psp_copy_user_blob);
>  
> @@ -622,6 +624,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>  {
>  	struct sev_user_data_get_id2 input;
>  	struct sev_data_get_id *data;
> +	void __user *input_address;
>  	void *id_blob = NULL;
>  	int ret;
>  
> @@ -633,9 +636,10 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>  		return -EFAULT;
>  
>  	/* Check if we have write access to the userspace buffer */
> +	input_address = (void __user *)input.address;
>  	if (input.address &&
>  	    input.length &&
> -	    !access_ok(input.address, input.length))
> +	    !access_ok(input_address, input.length))
>  		return -EFAULT;
>  
>  	data = kzalloc(sizeof(*data), GFP_KERNEL);
> @@ -667,8 +671,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>  	}
>  
>  	if (id_blob) {
> -		if (copy_to_user((void __user *)input.address,
> -				 id_blob, data->len)) {
> +		if (copy_to_user(input_address, id_blob, data->len)) {
>  			ret = -EFAULT;
>  			goto e_free;
>  		}
> @@ -727,6 +730,8 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	struct sev_user_data_pdh_cert_export input;
>  	void *pdh_blob = NULL, *cert_blob = NULL;
>  	struct sev_data_pdh_cert_export *data;
> +	void __user *input_cert_chain_address;
> +	void __user *input_pdh_cert_address;
>  	int ret;
>  
>  	/* If platform is not in INIT state then transition it to INIT. */
> @@ -752,16 +757,19 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	    !input.cert_chain_address)
>  		goto cmd;
>  
> +	input_pdh_cert_address = (void __user *)input.pdh_cert_address;
> +	input_cert_chain_address = (void __user *)input.cert_chain_address;
> +
>  	/* Allocate a physically contiguous buffer to store the PDH blob. */
>  	if ((input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) ||
> -	    !access_ok(input.pdh_cert_address, input.pdh_cert_len)) {
> +	    !access_ok(input_pdh_cert_address, input.pdh_cert_len)) {
>  		ret = -EFAULT;
>  		goto e_free;
>  	}
>  
>  	/* Allocate a physically contiguous buffer to store the cert chain blob. */
>  	if ((input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) ||
> -	    !access_ok(input.cert_chain_address, input.cert_chain_len)) {
> +	    !access_ok(input_cert_chain_address, input.cert_chain_len)) {
>  		ret = -EFAULT;
>  		goto e_free;
>  	}
> @@ -797,7 +805,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  	if (pdh_blob) {
> -		if (copy_to_user((void __user *)input.pdh_cert_address,
> +		if (copy_to_user(input_pdh_cert_address,
>  				 pdh_blob, input.pdh_cert_len)) {
>  			ret = -EFAULT;
>  			goto e_free_cert;
> @@ -805,7 +813,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>  	}
>  
>  	if (cert_blob) {
> -		if (copy_to_user((void __user *)input.cert_chain_address,
> +		if (copy_to_user(input_cert_chain_address,
>  				 cert_blob, input.cert_chain_len))
>  			ret = -EFAULT;
>  	}
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index 7fbc8679145c..49d155cd2dfe 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -597,7 +597,7 @@ int sev_guest_df_flush(int *error);
>   */
>  int sev_guest_decommission(struct sev_data_decommission *data, int *error);
>  
> -void *psp_copy_user_blob(u64 __user uaddr, u32 len);
> +void *psp_copy_user_blob(u64 uaddr, u32 len);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
>  
