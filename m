Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41C7EC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 16:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F047A23339
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Jan 2021 16:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbhAMQSk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Jan 2021 11:18:40 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:27320
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727109AbhAMQSj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Jan 2021 11:18:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzsxKkNNn9ZDNUdS6Pby4S4aCjT3UqJSQOIqBwbBKefR0xc4+RbydnJ97ECzy99aRAKFDRyodDjoxvIWr8hp3VEt498/zJSHpWHlxBqDvi3TdonXvABhwNolst0VFaxZDepxTyrBUwaUu/TVn3boj+TGfXhGh3xtjDdI2gzcEFVMvPGt4Qf/kMnfuZEWK53P8GJwJK8l5cJBNdUSX4B3LtGPT5JgBXbGG6M9xXYG1rbieKnTccFPpHdye5KPBKlkmEn6YsLG0GwH6xtf4ggQC2LzVm+kIYKVaRcxj5ycS3F2DERDEUcghBSpso8GaNRM5e2oaso8nvbOczYeYQK6hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kIIlKzLqdTPtllnWtxcIvEI2c7vtdqiCI7fQ2NlhWE=;
 b=CCrADieO/KDtQYbCKKLc9Sg18p0taWCMTpnt//pNVbWDXmdCCooWgPMHBe4AkGGuhINCURmBZet62eFCc3H/B+3eT2WB9VlA4aUCSaaS4acpQy/qaQeU6gKMZJm0s+upKeWCrGxYq3gzLzLxGveXBYy0dRH/92KmTYtJo1K3x59mm9ROLBf85Cz9fKIGziyi+C0u+hSGIzK+M5NYEdH4lcRFcEEzKtyCjB1xsfQkg/fiw2dVwiGAmPl9EkqrAjcqiqqhPzP9lyurC8g2eLF87vLhE02RRTp1g7JWnbVhoEksO7Q5nQi4CRKWIrJhvTbrS226JTAvm4xe4Kw4JA1whA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kIIlKzLqdTPtllnWtxcIvEI2c7vtdqiCI7fQ2NlhWE=;
 b=3sil8yglTjDVxpMVGbxDsfqwxm57wFNk4++7IRXJALoF42sgV8NnwhM9YIPBaLxwIa/kKWlSXuV2taQAB/S6JFAQ80oqQeE3LVHZneFQvQ1vQuEHFPLRIar/3zdlUsTr3YH5U6DeJCxNh9rnsj2k+s1dTe3/wBnpAJByIgCIRCM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SN6PR12MB2607.namprd12.prod.outlook.com (2603:10b6:805:6d::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.12; Wed, 13 Jan
 2021 16:17:45 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::21ed:fdce:2ba8:2179]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::21ed:fdce:2ba8:2179%7]) with mapi id 15.20.3742.012; Wed, 13 Jan 2021
 16:17:44 +0000
Date:   Wed, 13 Jan 2021 10:17:34 -0600
From:   John Allen <john.allen@amd.com>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
        ludovic.desroches@microchip.com, jesper.nilsson@axis.com,
        lars.persson@axis.com, horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        gcherian@marvell.com, thomas.lendacky@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v3 06/19] crypto: ccp: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20210113161734.GA31464@theseus>
References: <20210112014650.10887-1-allen.lkml@gmail.com>
 <20210112014650.10887-7-allen.lkml@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112014650.10887-7-allen.lkml@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [165.204.53.104]
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from theseus (165.204.53.104) by BY3PR04CA0017.namprd04.prod.outlook.com (2603:10b6:a03:217::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.7 via Frontend Transport; Wed, 13 Jan 2021 16:17:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf883aea-651b-4a21-21d0-08d8b7dec2ac
X-MS-TrafficTypeDiagnostic: SN6PR12MB2607:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26073FD23BA1FA51CBF03B669AA90@SN6PR12MB2607.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:283;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HmDSsuhwi7tPic/nP3AvfdiltUfETj9oI8fzXurnPH5ZWc42m7yhg46ei8u5JSAwwCfTwx1NEimukJd8ejbGdJqNZ/mMKyMwk0hECTpLO7+KsZ79A/BcMozFdzqPzm64nVgBa8M1CTmy1om5hw8JO9ou5qpLUUUKHE0N8VBsjYXVHugLkmxd+E67F5vKWXDN1B6IsPN9IRnKnOwYoQPoajKc4hvNF4NXIXojtJTumKbTrsHbBalFYLZk8dWgy2rJt0f+uFT6qww0aE1lXDSkvBw0fDctj4aRuIZr/3kTd2fZehA1WL6ELQfs4g7ftTMuzp9Gnze2qHU7AhXkzFtlDUCDIUzmfNXVUE9JhrJDeFnZQnKt9lPYABLhbIfpfNklAHhqnLoc+jK+VtSIYvVRag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(39860400002)(136003)(396003)(83380400001)(1076003)(86362001)(8936002)(54906003)(9576002)(44832011)(316002)(9686003)(52116002)(186003)(478600001)(7416002)(66946007)(66476007)(2906002)(8676002)(6496006)(33716001)(26005)(6916009)(33656002)(66556008)(16526019)(956004)(5660300002)(4326008)(55016002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rPtbvQ4ZuSmm1/nmvLO1XCeM/GOEfb7w2JUTvSemBSZgyktwLsm/dHeX7Kdc?=
 =?us-ascii?Q?1WDWv3ts3wjfM3BoG4kxPHGx3gATRF9yCmbDsB6HPrGfkI0j3iZ9cFnb0FJb?=
 =?us-ascii?Q?ssNqGnr15n74+76bI7900G/2mE83Ve5JIb19bB4w8wER3qjK1rwCrzXMsjIk?=
 =?us-ascii?Q?eKSKJYWdQWXYgYdDZQpebZj42cbT7n4VcFUnoZZuiMq3o6A8SocnGPhSA1Qr?=
 =?us-ascii?Q?hxKsBib7y6yJsEEvlo6aDdvRU/sB6yeyxku9ZfC80DjnxW5W527C/6AfhAxc?=
 =?us-ascii?Q?quTpcYI9RPhfudeCgvwMctf0tYq+p6gjGPj3oETl4LBGa+cl0XFwoiNOkQPX?=
 =?us-ascii?Q?nO0DWkx6gRlELFRfHTmvvPGs4k0SHVihI/W1R+nDdem+i+qfbbrRLfEhIEgN?=
 =?us-ascii?Q?iHJQ92oSbahT/rDXdLkIH9yRuiY+qjQwWInzVymU9uhGBUdqZX0Kfu35OarJ?=
 =?us-ascii?Q?To+ES7ZFcZGvWEnt2yCm959Vw0nITduNpngrTZWiorbRtPNbp4uNiKe8IH4N?=
 =?us-ascii?Q?Bdbqe46Qx07y1O+jQ8P47kage6v4yURSsvkW8CZvuhSXHL6iLxHahhR5KknY?=
 =?us-ascii?Q?6u9V8s82KL8F640TqQeWBm7K7UQLkoeSb0icP2ZAdxeTwFqcWlj6hjXSHPPN?=
 =?us-ascii?Q?LItqTTxyh5VmBe6pK6SLfxlWYXqdTqUgWccEGvoY/lJKdf0uBaPlU7UgcimM?=
 =?us-ascii?Q?bGLaX4mFoXVYKotgIhizhHDUj3UewOeTKtPw7A6LKlG9R6iNLrs0mLR8JLw4?=
 =?us-ascii?Q?LWVvmXdq+3t/vabo6EflNNvzfJsGA+XLrMC/+SN9bAVgz9pOAU6j81GoDnXy?=
 =?us-ascii?Q?lgO3T+5ijmVm0PgUoTzLqWuHVR9kBdP2ernxN+QsUStnrb0vDAzaGnr4pyKP?=
 =?us-ascii?Q?v4fI2vODcDZTI2V64EX+Sj8yg7a1A81tpJMehWydui2tZVh2HORGqnz2D9V5?=
 =?us-ascii?Q?JPgpLgcBCk4LwKfyAql2QFjtmMYAVq1G4SdrpHQEFJP3lbOrcNz54+Kggf2M?=
 =?us-ascii?Q?KciC?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 16:17:44.7669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: cf883aea-651b-4a21-21d0-08d8b7dec2ac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CGrEbJ6lNh2Dnxqf1yX8NiKDDEXbGZTXULUarTV/3H9WEVNwJZ4z3sAQG98wGUoWYy231zEL/YgBLOS3B70VUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2607
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 12, 2021 at 07:16:37AM +0530, Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>

Acked-by: John Allen <john.allen@amd.com>

> ---
>  drivers/crypto/ccp/ccp-dev-v3.c    | 9 ++++-----
>  drivers/crypto/ccp/ccp-dev-v5.c    | 9 ++++-----
>  drivers/crypto/ccp/ccp-dmaengine.c | 7 +++----
>  3 files changed, 11 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c b/drivers/crypto/ccp/ccp-dev-v3.c
> index 0d5576f6ad21..858566867fa3 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -321,9 +321,9 @@ static void ccp_enable_queue_interrupts(struct ccp_device *ccp)
>  	iowrite32(ccp->qim, ccp->io_regs + IRQ_MASK_REG);
>  }
>  
> -static void ccp_irq_bh(unsigned long data)
> +static void ccp_irq_bh(struct tasklet_struct *t)
>  {
> -	struct ccp_device *ccp = (struct ccp_device *)data;
> +	struct ccp_device *ccp = from_tasklet(ccp, t, irq_tasklet);
>  	struct ccp_cmd_queue *cmd_q;
>  	u32 q_int, status;
>  	unsigned int i;
> @@ -361,7 +361,7 @@ static irqreturn_t ccp_irq_handler(int irq, void *data)
>  	if (ccp->use_tasklet)
>  		tasklet_schedule(&ccp->irq_tasklet);
>  	else
> -		ccp_irq_bh((unsigned long)ccp);
> +		ccp_irq_bh(&ccp->irq_tasklet);
>  
>  	return IRQ_HANDLED;
>  }
> @@ -457,8 +457,7 @@ static int ccp_init(struct ccp_device *ccp)
>  
>  	/* Initialize the ISR tasklet? */
>  	if (ccp->use_tasklet)
> -		tasklet_init(&ccp->irq_tasklet, ccp_irq_bh,
> -			     (unsigned long)ccp);
> +		tasklet_setup(&ccp->irq_tasklet, ccp_irq_bh);
>  
>  	dev_dbg(dev, "Starting threads...\n");
>  	/* Create a kthread for each queue */
> diff --git a/drivers/crypto/ccp/ccp-dev-v5.c b/drivers/crypto/ccp/ccp-dev-v5.c
> index 7838f63bab32..e68b05a3169b 100644
> --- a/drivers/crypto/ccp/ccp-dev-v5.c
> +++ b/drivers/crypto/ccp/ccp-dev-v5.c
> @@ -733,9 +733,9 @@ static void ccp5_enable_queue_interrupts(struct ccp_device *ccp)
>  		iowrite32(SUPPORTED_INTERRUPTS, ccp->cmd_q[i].reg_int_enable);
>  }
>  
> -static void ccp5_irq_bh(unsigned long data)
> +static void ccp5_irq_bh(struct tasklet_struct *t)
>  {
> -	struct ccp_device *ccp = (struct ccp_device *)data;
> +	struct ccp_device *ccp = from_tasklet(ccp, t, irq_tasklet);
>  	u32 status;
>  	unsigned int i;
>  
> @@ -772,7 +772,7 @@ static irqreturn_t ccp5_irq_handler(int irq, void *data)
>  	if (ccp->use_tasklet)
>  		tasklet_schedule(&ccp->irq_tasklet);
>  	else
> -		ccp5_irq_bh((unsigned long)ccp);
> +		ccp5_irq_bh(&ccp->irq_tasklet);
>  	return IRQ_HANDLED;
>  }
>  
> @@ -894,8 +894,7 @@ static int ccp5_init(struct ccp_device *ccp)
>  	}
>  	/* Initialize the ISR tasklet */
>  	if (ccp->use_tasklet)
> -		tasklet_init(&ccp->irq_tasklet, ccp5_irq_bh,
> -			     (unsigned long)ccp);
> +		tasklet_setup(&ccp->irq_tasklet, ccp5_irq_bh);
>  
>  	dev_dbg(dev, "Loading LSB map...\n");
>  	/* Copy the private LSB mask to the public registers */
> diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
> index 0770a83bf1a5..a85690866b05 100644
> --- a/drivers/crypto/ccp/ccp-dmaengine.c
> +++ b/drivers/crypto/ccp/ccp-dmaengine.c
> @@ -121,9 +121,9 @@ static void ccp_cleanup_desc_resources(struct ccp_device *ccp,
>  	}
>  }
>  
> -static void ccp_do_cleanup(unsigned long data)
> +static void ccp_do_cleanup(struct tasklet_struct *t)
>  {
> -	struct ccp_dma_chan *chan = (struct ccp_dma_chan *)data;
> +	struct ccp_dma_chan *chan = from_tasklet(chan, t, cleanup_tasklet);
>  	unsigned long flags;
>  
>  	dev_dbg(chan->ccp->dev, "%s - chan=%s\n", __func__,
> @@ -712,8 +712,7 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
>  		INIT_LIST_HEAD(&chan->active);
>  		INIT_LIST_HEAD(&chan->complete);
>  
> -		tasklet_init(&chan->cleanup_tasklet, ccp_do_cleanup,
> -			     (unsigned long)chan);
> +		tasklet_setup(&chan->cleanup_tasklet, ccp_do_cleanup);
>  
>  		dma_chan->device = dma_dev;
>  		dma_cookie_init(dma_chan);
> -- 
> 2.25.1
> 
