Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9655DC10DCE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 15:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD9A2072A
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 15:57:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="NVp8Dhnn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgCFP5Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Mar 2020 10:57:25 -0500
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:44449
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726231AbgCFP5Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Mar 2020 10:57:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gaxoh7Iw5YoXdbZhw/hyhXxAlD31w38SeMnltd9ZsEQTldvLAAIfaOn3EXGMc0hVGWLCJJH+NViRuNkh1Qd+n7TLIgjHdksaPunzFWlZLKBsm6taCvp0Ip9CWbvRWTooRfg0BAP6S8QRbkC6292bEcyIKcL6F4PDuMvO0z9gJ1HmnQc5RuT7YXriLsJQZpzGyFNK9zsvIqPNqXUWEEEPAPu9JLTBnMTJF5ZuhuN2799a69GjoMS9IAly2BY0sg7h2onB5faqqWpKhAm4StuE2sW/UUhuy8VcamtaTc/qJmAJE3vNxQTEY7hdSAITjhNBYmpA1wNum/PM2budHer69A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKGPK1RURm0Urj2/gtQsfdph8YndmPxUqSsSMmpPZ04=;
 b=eZbvIfASN4eSihonxN0TEcN+JAL/BMJy7y8lZppqDSkVRrER4xb1/142eFO5pYD/C+PrYDSJL+VQZ0apkiZ1kmzHnuFMbKTG/Lvq4Umw+nzJZC5cwsLpomny+/bBQu2ovzDfbQu6K0+5otofIRxJq7VkpTsYGI6YdlKgv8lCvn7uIOevvCcSXk2oKON2+qaKD7YOE5w9dpyEQrwzIBF+dawjzsSuahKG4QtRciO4NLKDAZV6kMLp4OJHKgYvq3t0CZAcuqcM+1rWsVo458gxEGtahxUzX2tY4lcE4TRhzd8w1Dey0uISshY31OVGULByaaDfP8iWrv9a8HxEkcUKHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKGPK1RURm0Urj2/gtQsfdph8YndmPxUqSsSMmpPZ04=;
 b=NVp8DhnncKJqT46V0kMZEU30t0OTfzBwFxEJhh9G9k8APoQQP6diI562vrF7A8hFQwPTFBH5D26DuWN0B+Ua9J3fjBhWuVhimahczL74qdkmwIErvNB80IRcfuq79ZQcpxBy+Q8mQosmmlxgFMf5NZ1sKidYUmFbKEm7PLwsg1k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Thomas.Lendacky@amd.com; 
Received: from BN8PR12MB3154.namprd12.prod.outlook.com (2603:10b6:408:6d::10)
 by BN8PR12MB3492.namprd12.prod.outlook.com (2603:10b6:408:67::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 6 Mar
 2020 15:57:19 +0000
Received: from BN8PR12MB3154.namprd12.prod.outlook.com
 ([fe80::fdf0:c7aa:3bd7:7d51]) by BN8PR12MB3154.namprd12.prod.outlook.com
 ([fe80::fdf0:c7aa:3bd7:7d51%4]) with mapi id 15.20.2793.013; Fri, 6 Mar 2020
 15:57:19 +0000
Subject: Re: [PATCH 2/2] crypto/ccp: Cleanup sp_dev_master in
 psp_dev_destroy()
To:     John Allen <john.allen@amd.com>, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        brijesh.singh@amd.com, bp@suse.de, linux-kernel@vger.kernel.org
References: <20200303135724.14060-1-john.allen@amd.com>
 <20200303135724.14060-3-john.allen@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <d8e12b10-6a80-fdca-f378-eb3b9ca4b8e2@amd.com>
Date:   Fri, 6 Mar 2020 09:57:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200303135724.14060-3-john.allen@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN1PR12CA0079.namprd12.prod.outlook.com
 (2603:10b6:802:21::14) To BN8PR12MB3154.namprd12.prod.outlook.com
 (2603:10b6:408:6d::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by SN1PR12CA0079.namprd12.prod.outlook.com (2603:10b6:802:21::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Fri, 6 Mar 2020 15:57:18 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 245d9cc4-8603-4179-3b34-08d7c1e70cd9
X-MS-TrafficTypeDiagnostic: BN8PR12MB3492:|BN8PR12MB3492:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB349290609320585AD3609C10ECE30@BN8PR12MB3492.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:211;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(199004)(189003)(5660300002)(36756003)(66476007)(66556008)(66946007)(53546011)(478600001)(31686004)(2616005)(26005)(16576012)(316002)(4326008)(31696002)(956004)(86362001)(6486002)(52116002)(16526019)(81166006)(186003)(8936002)(81156014)(2906002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR12MB3492;H:BN8PR12MB3154.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: njstnxso8t2tlaRWES2tmOSbZ1y52LY4AU/EqTyzttaW5nW6r8Pr8abEmX2UgwuEthzVl90bxdoD1IfqlXSQ1rjl139PMvgdmnSCme4E63wAmW7+O1GQ1j0oKWRfuLjowDiHyW69xWYgc5RZ+9WbkDi+ccD5Xq6qkqrEUhtkBTJ4DgyEL/5ZBGsVA7SkeM2cYhQF3a+UpqYrhvcCSiPU9xe8qyLDIBRnQNRK3pc1HdzU23l92r+j8Zr5SwbJZsm0XLqRl7eFGWJuIoAfGmQQXi2NMMCmH9WUMkWs3RQmn/nNdpqasKc1MjmlkJuF28RZODffsCxtOih7nFh35gnMT/nNnO5HoGAu9Qrqx9jDnw2ak7p+LViLrnewMIV8dQQJ0XufD67akoEVkMM6HA5G+nVkmbN26eA4i1TNZ0+pWl+gHCqjT+RDBazNGGW4zVWy
X-MS-Exchange-AntiSpam-MessageData: EGUftWtyqP7pBB/ViXb3i1mxgHPlOt6zOhWd9455JrKcakWyA0QNBfua2OZv5DuR7DVjS8lMUaE2aSs+MySMNEI7HIcr3e0G4a6/XPjcnYapk6Ri6qMdFTwFGGH+48vncY6lQ8LakIyCvS8XOyZ3JQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 245d9cc4-8603-4179-3b34-08d7c1e70cd9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 15:57:19.5682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dp34kKQHKYN3ztEpHlDl9QqXtTUqqFa9o/jkUekNJ0DkrEE96JRlj307viLlguuUzALz9FzbcgSfHgABchQ8Ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3492
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 3/3/20 7:57 AM, John Allen wrote:
> Introduce clear_psp_master_device() to ensure that sp_dev_master gets
> properly cleared on the release of a psp device.
> 
> Fixes: 2a6170dfe755 ("crypto: ccp: Add Platform Security Processor (PSP) device support")
> Signed-off-by: John Allen <john.allen@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>  drivers/crypto/ccp/psp-dev.c | 3 +++
>  drivers/crypto/ccp/sp-dev.h  | 1 +
>  drivers/crypto/ccp/sp-pci.c  | 9 +++++++++
>  3 files changed, 13 insertions(+)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index e95e7aa5dbf1..ae7b44599914 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -215,6 +215,9 @@ void psp_dev_destroy(struct sp_device *sp)
>  	tee_dev_destroy(psp);
>  
>  	sp_free_psp_irq(sp, psp);
> +
> +	if (sp->clear_psp_master_device)
> +		sp->clear_psp_master_device(sp);
>  }
>  
>  void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t handler,
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 423594608ad1..f913f1494af9 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -90,6 +90,7 @@ struct sp_device {
>  	/* get and set master device */
>  	struct sp_device*(*get_psp_master_device)(void);
>  	void (*set_psp_master_device)(struct sp_device *);
> +	void (*clear_psp_master_device)(struct sp_device *);
>  
>  	bool irq_registered;
>  	bool use_tasklet;
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 56c1f61c0f84..cb6cb47053f4 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -146,6 +146,14 @@ static struct sp_device *psp_get_master(void)
>  	return sp_dev_master;
>  }
>  
> +static void psp_clear_master(struct sp_device *sp)
> +{
> +	if (sp == sp_dev_master) {
> +		sp_dev_master = NULL;
> +		dev_dbg(sp->dev, "Cleared sp_dev_master\n");
> +	}
> +}
> +
>  static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct sp_device *sp;
> @@ -206,6 +214,7 @@ static int sp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	pci_set_master(pdev);
>  	sp->set_psp_master_device = psp_set_master;
>  	sp->get_psp_master_device = psp_get_master;
> +	sp->clear_psp_master_device = psp_clear_master;
>  
>  	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(48));
>  	if (ret) {
> 
