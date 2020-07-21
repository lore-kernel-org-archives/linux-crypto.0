Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F43C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 15:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531C9206E3
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 15:19:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="kdwkunAv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgGUPTk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 11:19:40 -0400
Received: from mail-dm6nam11on2067.outbound.protection.outlook.com ([40.107.223.67]:51041
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726436AbgGUPTk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 11:19:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eezoDraUw6s5s1pY0AL8NqYEI34IJuDipdJBr4C6OmxGQ4TNdufJXryZnWLMB/IX6R9uFf+6xDaayx4b+rf6KZ3gmGAOeKYVtREbQpM2VavBMgtUPN4Ly+fDnp0dqt/0VLISRKSY7NTQExiZCx85GvNmoVhi2hqqYLfVFujK9J9my5WdlqI7sibmFYaHKBYw1gaqCxVHXQtCWuBdIq3tVkORq0rXfOppkd9U1LFPB8uZGJO/RMc/nwtzCk/YoOklOm6/POUC2HVFbUIM8TNUXI9S8chcxIZf/MtQM90287UfJiAR2Euw8lg5W2FdDZ27J0ETMVBzwDnTWKPo7jgHfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cDUlaYJxHrtdoWtmeonTnIZe6mgJD5Yu53PHyFBpaw=;
 b=f1DN/++v7EgFvqeSil7sFbJJtOP5tVB/zSUcGc6NumM4JZ3H44jbv6rYiH5G44+RNeqAiJsPOFnp3dewhUe34LFpVFF79NCZHymQepo4xMnyBDSQlFXJzQExwSnA9kmjjt9XR17csbkgcbp8UwP/WLSET2FSWeQypIOZkyOtA/twMmyrNHnY9x6cGiOosqiqoHVmqocOfzABB8CHBNe57vauFh+57B9hvgkLQo63MiHB5z7K2cu/yHMgezlNQhNPRLc29CgwP2//KMvZx2suM2mSpGzPLvRecXXGdCurJ1DeIW2UB6YO7wgo4JJs9m0I3qC1ttfgwruCJe2Ek8X/7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3cDUlaYJxHrtdoWtmeonTnIZe6mgJD5Yu53PHyFBpaw=;
 b=kdwkunAvDOhQjzSIL+qlwZ1i+gaz5XCyTcVlO71lKJvETn5wbK3zM7b2WDynmsfP+1le5pPq4f6o6Jzc40wEW5AzkwXJmNKLzzmPaKUIe7ytATA9gN9dh+SGOEYzmlyu12ZApWsiqfAdgp9NF5nHD0lOlv2/tc6J4WlBXUauDlA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1925.namprd12.prod.outlook.com (2603:10b6:903:120::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Tue, 21 Jul
 2020 15:19:35 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::9181:78bf:bf0:702b]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::9181:78bf:bf0:702b%5]) with mapi id 15.20.3216.020; Tue, 21 Jul 2020
 15:19:35 +0000
Subject: Re: [PATCH v1] crypto: ccp: sp-pci: use generic power management
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
References: <20200721123146.81710-1-vaibhavgupta40@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <7100976b-cf7c-c304-e2a6-660876e310af@amd.com>
Date:   Tue, 21 Jul 2020 10:19:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200721123146.81710-1-vaibhavgupta40@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR07CA0083.namprd07.prod.outlook.com
 (2603:10b6:4:ad::48) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by DM5PR07CA0083.namprd07.prod.outlook.com (2603:10b6:4:ad::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.19 via Frontend Transport; Tue, 21 Jul 2020 15:19:34 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 841e03b0-147b-4cd9-cc46-08d82d8979b0
X-MS-TrafficTypeDiagnostic: CY4PR12MB1925:
X-Microsoft-Antispam-PRVS: <CY4PR12MB1925CD7462160E16F4EBB23DEC780@CY4PR12MB1925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uxFu/FHxsmtBZRT5v+NFFkn/8V6u7i8v2Sfl5ZhgClj1zkQ9uMWdizGqtUnXT9Z2Izb8Ln7etrt5K6yol0ipFDrBM/s4Kfyd0p+dmpXVqDpPzwvAPJs5fjVspqvHGZ4q9HKLygxA++0drC+qC1O9UhRDqVLHtd02hAhnlQ12Fw6He+zibHMX2Mq9Czt5nXc3vuYOIA72zEjtp9dBlg8XtCZJBXaeVH1YYekuT3asMLLsURYjoPZupjDSdWHUOQr5tXjaVJU+xscnaU7eCQe+L1NiuArK2YBIo18YDEg7ytijfEV3DHwcdn6aNhI3BUVDG3pafk+Ci7P55Bb7eS4xAfFV0YDCRhv+exbfswaM12SD7GFDf7gUKbxiEXq1IL3TMtFIKXV4LqckbtR9BxAJzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(2906002)(26005)(86362001)(4326008)(110136005)(66946007)(31686004)(6486002)(31696002)(66476007)(53546011)(66556008)(8676002)(956004)(83380400001)(2616005)(8936002)(52116002)(36756003)(478600001)(186003)(16526019)(316002)(5660300002)(7416002)(16576012)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nWU3IGBsME3j1P0poFybCt4152r9C5YOMu3/IcqAKrcfvm+PxJhTK9yYfPo/TFqjCUrqD7Sf9P2+n3ViLXZukeN7nSzHpwxdGUOFaEJdaVQdLEZof7J7vpet6Cy28xuX130YeTP+uiIFoPtJ+tWEe1F/hqoriRXffR5AqPtbYxY6YvjwahQyZbqa7nasTiNHY1np0Tu8C4eqIqrEuUTRjuloDEA59S/iRgT2hDZpGEAB0TI7fVsbRihoWIJfgpEnGxyjZwYiOd0hbqPGwzumiYVLWTE24KbxAs3sBouSqr3XUiHrEnSuMlMtbAwMqKgiT7sly62VcyQp3gWjeG85zyroWOH6BkqR0K6n1zu5MmEnPOtvjN/U7de/0mt31QzItg0DiVT8SrhFsXP/2Qu15aCptxXYVJyZR2Zo9O2aX0NNYaqn36WdJYEwDUQlYh4HS3vv+F7K5dYkJTaRwieNLKCs6B8BFjS3anNvhG+PP78=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 841e03b0-147b-4cd9-cc46-08d82d8979b0
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 15:19:35.0873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WYija3CZTpANk817et6Ikog8Dx/I/hC0TWtEwBBkRCZaxCm/AtAm47RjSLUwV9yEHYW8YOySHmR2N32atgc1pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1925
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/21/20 7:31 AM, Vaibhav Gupta wrote:
> Drivers using legacy power management .suspen()/.resume() callbacks
> have to manage PCI states and device's PM states themselves. They also
> need to take care of standard configuration registers.
> 
> Switch to generic power management framework using a single
> "struct dev_pm_ops" variable to take the unnecessary load from the driver.
> This also avoids the need for the driver to directly call most of the PCI
> helper functions and device power state control functions as through
> the generic framework, PCI Core takes care of the necessary operations,
> and drivers are required to do only device-specific jobs.
> 
> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
> ---
>  drivers/crypto/ccp/ccp-dev.c     |  8 +++-----
>  drivers/crypto/ccp/sp-dev.c      |  6 ++----
>  drivers/crypto/ccp/sp-dev.h      |  6 +++---
>  drivers/crypto/ccp/sp-pci.c      | 17 ++++++-----------
>  drivers/crypto/ccp/sp-platform.c |  2 +-
>  5 files changed, 15 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
> index 19ac509ed76e..8ae26d3cffff 100644
> --- a/drivers/crypto/ccp/ccp-dev.c
> +++ b/drivers/crypto/ccp/ccp-dev.c
> @@ -531,8 +531,7 @@ int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>  	return len;
>  }
>  
> -#ifdef CONFIG_PM
> -bool ccp_queues_suspended(struct ccp_device *ccp)
> +bool __maybe_unused ccp_queues_suspended(struct ccp_device *ccp)

These aren't static functions, so is the __maybe_unused necessary?

(Same comment on the other non-static functions changed below)

>  {
>  	unsigned int suspended = 0;
>  	unsigned long flags;
> @@ -549,7 +548,7 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
>  	return ccp->cmd_q_count == suspended;
>  }
>  
> -int ccp_dev_suspend(struct sp_device *sp, pm_message_t state)
> +int __maybe_unused ccp_dev_suspend(struct sp_device *sp)
>  {
>  	struct ccp_device *ccp = sp->ccp_data;
>  	unsigned long flags;
> @@ -577,7 +576,7 @@ int ccp_dev_suspend(struct sp_device *sp, pm_message_t state)
>  	return 0;
>  }
>  
> -int ccp_dev_resume(struct sp_device *sp)
> +int __maybe_unused ccp_dev_resume(struct sp_device *sp)
>  {
>  	struct ccp_device *ccp = sp->ccp_data;
>  	unsigned long flags;
> @@ -601,7 +600,6 @@ int ccp_dev_resume(struct sp_device *sp)
>  
>  	return 0;
>  }
> -#endif
>  
>  int ccp_dev_init(struct sp_device *sp)
>  {
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index ce42675d3274..6284a15e5047 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -211,13 +211,12 @@ void sp_destroy(struct sp_device *sp)
>  	sp_del_device(sp);
>  }
>  
> -#ifdef CONFIG_PM
> -int sp_suspend(struct sp_device *sp, pm_message_t state)
> +int sp_suspend(struct sp_device *sp)
>  {
>  	int ret;
>  
>  	if (sp->dev_vdata->ccp_vdata) {
> -		ret = ccp_dev_suspend(sp, state);
> +		ret = ccp_dev_suspend(sp);
>  		if (ret)
>  			return ret;
>  	}
> @@ -237,7 +236,6 @@ int sp_resume(struct sp_device *sp)
>  
>  	return 0;
>  }
> -#endif
>  
>  struct sp_device *sp_get_psp_master_device(void)
>  {
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index f913f1494af9..0218d0670eee 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -119,7 +119,7 @@ int sp_init(struct sp_device *sp);
>  void sp_destroy(struct sp_device *sp);
>  struct sp_device *sp_get_master(void);
>  
> -int sp_suspend(struct sp_device *sp, pm_message_t state);
> +int sp_suspend(struct sp_device *sp);
>  int sp_resume(struct sp_device *sp);
>  int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
>  		       const char *name, void *data);
> @@ -134,7 +134,7 @@ struct sp_device *sp_get_psp_master_device(void);
>  int ccp_dev_init(struct sp_device *sp);
>  void ccp_dev_destroy(struct sp_device *sp);
>  
> -int ccp_dev_suspend(struct sp_device *sp, pm_message_t state);
> +int ccp_dev_suspend(struct sp_device *sp);
>  int ccp_dev_resume(struct sp_device *sp);
>  
>  #else	/* !CONFIG_CRYPTO_DEV_SP_CCP */
> @@ -145,7 +145,7 @@ static inline int ccp_dev_init(struct sp_device *sp)
>  }
>  static inline void ccp_dev_destroy(struct sp_device *sp) { }
>  
> -static inline int ccp_dev_suspend(struct sp_device *sp, pm_message_t state)
> +static inline int ccp_dev_suspend(struct sp_device *sp)
>  {
>  	return 0;
>  }
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index cb6cb47053f4..f471dbaef1fb 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -252,23 +252,19 @@ static void sp_pci_remove(struct pci_dev *pdev)
>  	sp_free_irqs(sp);
>  }
>  
> -#ifdef CONFIG_PM
> -static int sp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int __maybe_unused sp_pci_suspend(struct device *dev)
>  {
> -	struct device *dev = &pdev->dev;
>  	struct sp_device *sp = dev_get_drvdata(dev);
>  
> -	return sp_suspend(sp, state);
> +	return sp_suspend(sp);
>  }
>  
> -static int sp_pci_resume(struct pci_dev *pdev)
> +static int __maybe_unused sp_pci_resume(struct device *dev)
>  {
> -	struct device *dev = &pdev->dev;
>  	struct sp_device *sp = dev_get_drvdata(dev);
>  
>  	return sp_resume(sp);
>  }
> -#endif
>  
>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>  static const struct sev_vdata sevv1 = {
> @@ -365,15 +361,14 @@ static const struct pci_device_id sp_pci_table[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, sp_pci_table);
>  
> +static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
> +
>  static struct pci_driver sp_pci_driver = {
>  	.name = "ccp",
>  	.id_table = sp_pci_table,
>  	.probe = sp_pci_probe,
>  	.remove = sp_pci_remove,
> -#ifdef CONFIG_PM
> -	.suspend = sp_pci_suspend,
> -	.resume = sp_pci_resume,
> -#endif
> +	.driver.pm = &sp_pci_pm_ops,
>  };
>  
>  int sp_pci_init(void)
> diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
> index 831aac1393a2..9dba52fbee99 100644
> --- a/drivers/crypto/ccp/sp-platform.c
> +++ b/drivers/crypto/ccp/sp-platform.c

This file use the same "#ifdef CONFIG_PM" to define the suspend and resume
functions (see sp_platform_driver variable). Doesn't that need to be
updated similar to sp-pci.c? Not sure how this compile tested successfully
unless your kernel config didn't have CONFIG_PM defined?

Thanks,
Tom

> @@ -207,7 +207,7 @@ static int sp_platform_suspend(struct platform_device *pdev,
>  	struct device *dev = &pdev->dev;
>  	struct sp_device *sp = dev_get_drvdata(dev);
>  
> -	return sp_suspend(sp, state);
> +	return sp_suspend(sp);
>  }
>  
>  static int sp_platform_resume(struct platform_device *pdev)
> 
