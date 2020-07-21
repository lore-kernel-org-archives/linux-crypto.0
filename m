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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84E0DC433EC
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 17:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5871B206E9
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 17:15:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="oOBJ0Zla"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbgGURPX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 13:15:23 -0400
Received: from mail-bn8nam11on2059.outbound.protection.outlook.com ([40.107.236.59]:19649
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730861AbgGURPV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 13:15:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoEfjFdzGIgvJ8M3XpEWB8UI2Y0BR7GwvNRAlXaoZX20DrI+vpoPrFXOnJ0i9mQEByik5pOlpWR6T8CvlIrZuxag4+vg6Isry6186yzcrQyyVfGc5alCWbT6rkQCrmoue6mY9XSyRp14rLwyogBUi9uj3hvzqUSGe3MZen050CeXzMsLSHUjzzTWNVFByERXXvwoyXvXMLPNwVqKTE13+V2ZZp4kHsfdpY5Mtp5xvGejXlTYDCCSSU6k8R6NwKJm247Y50Yr4X9q8enbNetyBTMlEw/TRhYIaz4Jr5V95mnHdLa9w+cUsHPmoQpoftjibSKjr1avpawzq1iBsapMBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEIFLUPf1NJkgiB+k/VIUauEW2vLv/COroKXHqdlrGo=;
 b=InyuY4G9rX3TZGj6ZljpBscu27k9+tlrdOwina9hYa+4OL7QyiyKJi8vF1YZbw2l4+B7MzDwpL1uLXLw8ZMbWW6ZHOImsorPjVj5v9i9MuW+QITZE21a1btlx35d+SmyYy9y82sCDD1IUgzEeohOTZVegQxTsSSr/ZMc/fZKSEVvIAn9QFisuIxlIZbNaudV3rMQpzgyeQUcYGTmwFJvbVvpByQSxgaa5uU8LUFaQ5tuWL1aX9n0ne3J/PvydoEbc7iNfdr58fFg7/bBuWU8VnAnUzhyHgIxEzkZSU8I9cKT8LatpQaJwzdjJH+82N+vS2hEdQJVmrj99Ka0gpRbTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nEIFLUPf1NJkgiB+k/VIUauEW2vLv/COroKXHqdlrGo=;
 b=oOBJ0ZlaJJT/ZyhWX7/15ocCjxOiocJ0ShnQg3+iUwc2AIZRFD1GFztWtKY4nkIXQB+fIbHjxTgw865xwAxpVcCGoaQ+b5WWSl4SVwS0QDlBJ05Cs1TuevrhgGG/QSAHk/9mkgOSwAGDMUmhHaRthdVIrJa9TaRH2+AhhkM6jNo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1542.namprd12.prod.outlook.com (2603:10b6:910:8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.25; Tue, 21 Jul
 2020 17:15:15 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::9181:78bf:bf0:702b]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::9181:78bf:bf0:702b%5]) with mapi id 15.20.3216.020; Tue, 21 Jul 2020
 17:15:15 +0000
Subject: Re: [PATCH v1] crypto: ccp: sp-pci: use generic power management
To:     Vaibhav Gupta <vaibhavgupta40@gmail.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
References: <20200721123146.81710-1-vaibhavgupta40@gmail.com>
 <7100976b-cf7c-c304-e2a6-660876e310af@amd.com>
 <20200721163056.GA396078@gmail.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <95db9ba2-ffbb-ca92-6a70-1ee401920eed@amd.com>
Date:   Tue, 21 Jul 2020 12:15:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200721163056.GA396078@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0120.namprd05.prod.outlook.com
 (2603:10b6:803:42::37) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN4PR0501CA0120.namprd05.prod.outlook.com (2603:10b6:803:42::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.17 via Frontend Transport; Tue, 21 Jul 2020 17:15:14 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 61845507-dd30-40ed-c9f8-08d82d99a27c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1542:
X-Microsoft-Antispam-PRVS: <CY4PR12MB154244173A14A2197A334EECEC780@CY4PR12MB1542.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DOJxaS1jrRB+1kTN9D1m6PHoHgpF4PrzmWrkE0U1UGVl1zBZMxaK4bOtTiMkVcea2X9k/7zcmTVSZgwAsyecoD0RFJOaZh/xCoOwqJlHTDlyqN+SXLqZuS6eMAmDbZDyokMbOf0OZHQqmijepkTscAsht5zub3CmG6yaEzoz9RyoqxHD6BAM2+WOs6aiRwDCj1iFxL3dWNwDDtjzpQJcrxLZRVJ7PVWUtFJH3Yu9mykOFgK1Tc1//i7eNizcwvyLCAQFi4oLYbM7mwGHUHOKb0ZZSPri2TmVTozcDT+/BDDV0uyCDRuv3EAGSKtT8a1biqoP8hlmRzvG0an/gS6DU2XzD5oVKPlXNJ2s82A16sWUq2ACvCBIPgVTVVgu5Pl5McGoEb8VWa7swefrkEPbow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(54906003)(2906002)(36756003)(83380400001)(6486002)(6916009)(4326008)(478600001)(16526019)(8936002)(53546011)(31696002)(31686004)(8676002)(16576012)(316002)(956004)(2616005)(5660300002)(66476007)(66946007)(26005)(66556008)(86362001)(7416002)(52116002)(186003)(41533002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Fc9jZ99k+x/9v60m55DYmGJ2RMrDsJzHsup/VOpVLiS0a2ma6/em49uvys0AIlAP5mFYYGrlXxSAXhSNd4Pt4eUvw2fQBBPOCwYdzomZT76Ww+w6D2+rwZJxrgJncdUxlirZEjc2rjPYGNkOryUSC8OTNzHostBnjvP58mKhpyDHrjZyWZEjXriuVijhr07H41QoHoRUXZUWLc5YMEIt+bv6MwcCwH7nbYZqeT8NkfTWe+EzK0gvA9FmXC4w1jK14YTY1NSVjDCnm7MihgYPZyM0eVATpcjsOWB52JpMc2T48IWSxjtTYxYJonTJGudn2vHyrDqthpb0muK/0Oii7SusKsstypnTKPxFU4rbOR+g3Kpr/BKo/GxbrTJNZfpnQE+DwmPyRzEG7jDyLPrn6oQQhMyhA/ql4M4Sa0FO0CodluuEx3jVyar00MlyTrkn79ZcirjKxzUphljHoGRGv2OYj440S/D01Dib//ORQwk=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61845507-dd30-40ed-c9f8-08d82d99a27c
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 17:15:15.4177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TowECh8ePM3gRA1/zppmHldpLCZ9XnHlfw55DuIPVc6GHFEXbL2JE9R5bK8wV26C8mcOikenxv55DwzlcTuEhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1542
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 7/21/20 11:30 AM, Vaibhav Gupta wrote:
> On Tue, Jul 21, 2020 at 10:19:33AM -0500, Tom Lendacky wrote:
>> On 7/21/20 7:31 AM, Vaibhav Gupta wrote:
>>> Drivers using legacy power management .suspen()/.resume() callbacks
>>> have to manage PCI states and device's PM states themselves. They also
>>> need to take care of standard configuration registers.
>>>
>>> Switch to generic power management framework using a single
>>> "struct dev_pm_ops" variable to take the unnecessary load from the driver.
>>> This also avoids the need for the driver to directly call most of the PCI
>>> helper functions and device power state control functions as through
>>> the generic framework, PCI Core takes care of the necessary operations,
>>> and drivers are required to do only device-specific jobs.
>>>
>>> Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
>>> ---
>>>  drivers/crypto/ccp/ccp-dev.c     |  8 +++-----
>>>  drivers/crypto/ccp/sp-dev.c      |  6 ++----
>>>  drivers/crypto/ccp/sp-dev.h      |  6 +++---
>>>  drivers/crypto/ccp/sp-pci.c      | 17 ++++++-----------
>>>  drivers/crypto/ccp/sp-platform.c |  2 +-
>>>  5 files changed, 15 insertions(+), 24 deletions(-)
>>>
>>> diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
>>> index 19ac509ed76e..8ae26d3cffff 100644
>>> --- a/drivers/crypto/ccp/ccp-dev.c
>>> +++ b/drivers/crypto/ccp/ccp-dev.c
>>> @@ -531,8 +531,7 @@ int ccp_trng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>>>  	return len;
>>>  }
>>>  
>>> -#ifdef CONFIG_PM
>>> -bool ccp_queues_suspended(struct ccp_device *ccp)
>>> +bool __maybe_unused ccp_queues_suspended(struct ccp_device *ccp)
>>
>> These aren't static functions, so is the __maybe_unused necessary?
>>
>> (Same comment on the other non-static functions changed below)
>>
>>>  {
>>>  	unsigned int suspended = 0;
>>>  	unsigned long flags;
>>> @@ -549,7 +548,7 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
>>>  	return ccp->cmd_q_count == suspended;
>>>  }
>>>  
>>> -int ccp_dev_suspend(struct sp_device *sp, pm_message_t state)
>>> +int __maybe_unused ccp_dev_suspend(struct sp_device *sp)
>>>  {
>>>  	struct ccp_device *ccp = sp->ccp_data;
>>>  	unsigned long flags;
>>> @@ -577,7 +576,7 @@ int ccp_dev_suspend(struct sp_device *sp, pm_message_t state)
>>>  	return 0;
>>>  }
>>>  
>>> -int ccp_dev_resume(struct sp_device *sp)
>>> +int __maybe_unused ccp_dev_resume(struct sp_device *sp)
>>>  {
>>>  	struct ccp_device *ccp = sp->ccp_data;
>>>  	unsigned long flags;
>>> @@ -601,7 +600,6 @@ int ccp_dev_resume(struct sp_device *sp)
>>>  
>>>  	return 0;
>>>  }
>>> -#endif
>>>  
>>>  int ccp_dev_init(struct sp_device *sp)
>>>  {
>>> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
>>> index ce42675d3274..6284a15e5047 100644
>>> --- a/drivers/crypto/ccp/sp-dev.c
>>> +++ b/drivers/crypto/ccp/sp-dev.c
>>> @@ -211,13 +211,12 @@ void sp_destroy(struct sp_device *sp)
>>>  	sp_del_device(sp);
>>>  }
>>>  
>>> -#ifdef CONFIG_PM
>>> -int sp_suspend(struct sp_device *sp, pm_message_t state)
>>> +int sp_suspend(struct sp_device *sp)
>>>  {
>>>  	int ret;
>>>  
>>>  	if (sp->dev_vdata->ccp_vdata) {
>>> -		ret = ccp_dev_suspend(sp, state);
>>> +		ret = ccp_dev_suspend(sp);
>>>  		if (ret)
>>>  			return ret;
>>>  	}
>>> @@ -237,7 +236,6 @@ int sp_resume(struct sp_device *sp)
>>>  
>>>  	return 0;
>>>  }
>>> -#endif
>>>  
>>>  struct sp_device *sp_get_psp_master_device(void)
>>>  {
>>> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
>>> index f913f1494af9..0218d0670eee 100644
>>> --- a/drivers/crypto/ccp/sp-dev.h
>>> +++ b/drivers/crypto/ccp/sp-dev.h
>>> @@ -119,7 +119,7 @@ int sp_init(struct sp_device *sp);
>>>  void sp_destroy(struct sp_device *sp);
>>>  struct sp_device *sp_get_master(void);
>>>  
>>> -int sp_suspend(struct sp_device *sp, pm_message_t state);
>>> +int sp_suspend(struct sp_device *sp);
>>>  int sp_resume(struct sp_device *sp);
>>>  int sp_request_ccp_irq(struct sp_device *sp, irq_handler_t handler,
>>>  		       const char *name, void *data);
>>> @@ -134,7 +134,7 @@ struct sp_device *sp_get_psp_master_device(void);
>>>  int ccp_dev_init(struct sp_device *sp);
>>>  void ccp_dev_destroy(struct sp_device *sp);
>>>  
>>> -int ccp_dev_suspend(struct sp_device *sp, pm_message_t state);
>>> +int ccp_dev_suspend(struct sp_device *sp);
>>>  int ccp_dev_resume(struct sp_device *sp);
>>>  
>>>  #else	/* !CONFIG_CRYPTO_DEV_SP_CCP */
>>> @@ -145,7 +145,7 @@ static inline int ccp_dev_init(struct sp_device *sp)
>>>  }
>>>  static inline void ccp_dev_destroy(struct sp_device *sp) { }
>>>  
>>> -static inline int ccp_dev_suspend(struct sp_device *sp, pm_message_t state)
>>> +static inline int ccp_dev_suspend(struct sp_device *sp)
>>>  {
>>>  	return 0;
>>>  }
>>> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
>>> index cb6cb47053f4..f471dbaef1fb 100644
>>> --- a/drivers/crypto/ccp/sp-pci.c
>>> +++ b/drivers/crypto/ccp/sp-pci.c
>>> @@ -252,23 +252,19 @@ static void sp_pci_remove(struct pci_dev *pdev)
>>>  	sp_free_irqs(sp);
>>>  }
>>>  
>>> -#ifdef CONFIG_PM
>>> -static int sp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>>> +static int __maybe_unused sp_pci_suspend(struct device *dev)
>>>  {
>>> -	struct device *dev = &pdev->dev;
>>>  	struct sp_device *sp = dev_get_drvdata(dev);
>>>  
>>> -	return sp_suspend(sp, state);
>>> +	return sp_suspend(sp);
>>>  }
>>>  
>>> -static int sp_pci_resume(struct pci_dev *pdev)
>>> +static int __maybe_unused sp_pci_resume(struct device *dev)
>>>  {
>>> -	struct device *dev = &pdev->dev;
>>>  	struct sp_device *sp = dev_get_drvdata(dev);
>>>  
>>>  	return sp_resume(sp);
>>>  }
>>> -#endif
>>>  
>>>  #ifdef CONFIG_CRYPTO_DEV_SP_PSP
>>>  static const struct sev_vdata sevv1 = {
>>> @@ -365,15 +361,14 @@ static const struct pci_device_id sp_pci_table[] = {
>>>  };
>>>  MODULE_DEVICE_TABLE(pci, sp_pci_table);
>>>  
>>> +static SIMPLE_DEV_PM_OPS(sp_pci_pm_ops, sp_pci_suspend, sp_pci_resume);
>>> +
>>>  static struct pci_driver sp_pci_driver = {
>>>  	.name = "ccp",
>>>  	.id_table = sp_pci_table,
>>>  	.probe = sp_pci_probe,
>>>  	.remove = sp_pci_remove,
>>> -#ifdef CONFIG_PM
>>> -	.suspend = sp_pci_suspend,
>>> -	.resume = sp_pci_resume,
>>> -#endif
>>> +	.driver.pm = &sp_pci_pm_ops,
>>>  };
>>>  
>>>  int sp_pci_init(void)
>>> diff --git a/drivers/crypto/ccp/sp-platform.c b/drivers/crypto/ccp/sp-platform.c
>>> index 831aac1393a2..9dba52fbee99 100644
>>> --- a/drivers/crypto/ccp/sp-platform.c
>>> +++ b/drivers/crypto/ccp/sp-platform.c
>>
>> This file use the same "#ifdef CONFIG_PM" to define the suspend and resume
>> functions (see sp_platform_driver variable). Doesn't that need to be
>> updated similar to sp-pci.c? Not sure how this compile tested successfully
>> unless your kernel config didn't have CONFIG_PM defined?
> I am not sure but my .config file has "CONFIG_PM=y"

Ok, my miss on that, you didn't update the sp_platform_suspend signature,
so no issue there.

> 
> The motive is update PM of sp-pci. Months ago, we decided to remove
> "#ifdef CONFIG_PM" container and mark the callbacks as __maybe_unused.

Is this being done only for struct pci_driver structures then? Or will
there be a follow on effort for struct platform_driver structures?

I can see the need for the __maybe_unused on the sp_pci_suspend() and
sp_pci_resume() functions since those are static functions that may cause
warnings depending on whether CONFIG_PM_SLEEP is defined or not.

The ccp_dev_suspend() and ccp_dev_resume() functions, though, are external
functions that I would think shouldn't require the __may_unused attribute
because the compiler wouldn't know if they are invoked or not within that
file (similar to how the sp_suspend() and sp_resume() weren't modified to
include the __maybe_unused attribute).  Can you try a compile test without
changing those functions and without CONFIG_PM=y and see if you run into
issues?

Thanks,
Tom

> Hence, I did similar changes to all files on which sp-pci is dependent.
> 
> This caused change in function defintion and declaration of sp_suspend().
> 
> sp-pci is not depended upon sp-platform. sp-platform was modified only because
> it also invoked sp_suspend() which got modified.
> 
> Thus, I didn't made any other changes to sp-platofrm.
> 
> Thanks
> Vaibhav Gupta
>>
>> Thanks,
>> Tom
>>
>>> @@ -207,7 +207,7 @@ static int sp_platform_suspend(struct platform_device *pdev,
>>>  	struct device *dev = &pdev->dev;
>>>  	struct sp_device *sp = dev_get_drvdata(dev);
>>>  
>>> -	return sp_suspend(sp, state);
>>> +	return sp_suspend(sp);
>>>  }
>>>  
>>>  static int sp_platform_resume(struct platform_device *pdev)
>>>
