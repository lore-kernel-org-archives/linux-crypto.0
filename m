Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 687ACC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 22:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3060824672
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 22:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="xsdEKuqD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLSW54 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 17:57:56 -0500
Received: from mail-co1nam11on2063.outbound.protection.outlook.com ([40.107.220.63]:20304
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726982AbfLSW54 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 17:57:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZ4kG1w3anYAdunDEQIdUTX6ech3Li0xexRz0J9qUlwk4YZizIq8NHzu9GP5231q9X6chC+ax2clz7B3OHKa1FU+MtShhaYv8ZaSMxASdPpseaxrd0RGTIXzdO7kyLdOgpZwvpWKvDpQRAKXK/pZelGAxD+dbYuWkCuCKTdZvbcnkptI6ARZUloZ79x3mEE33q9/PVX84dGGzDdqy2s7stqmfjOVm1VD9r76E0YZ4V2D7ekLD1tyn8va+Xqm2+yCFrW33uqVbzNKUHFs0CabFCsqu+qETGShjyHuiDfOPX/7X8FZx30f5JSXT+aM8I4PPFOVLvhcYEjqSggFLkj2zA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TccnvQJRSH0FVZkh49TVgW14bfHVG7FF8g1HiNImSLA=;
 b=ZpBNcRdwvCqwahFgdLj7rcwEsor0Nac3ugUCZkPBlGqKb/CP9DdXI1vDT5LKiAbUfsGfOYPdgN1q9e5KO9R7fMGCAb2v3OlMx+QfPch3w5CacLFQqF4rjAmwCoU3pIPcKyTllByD6dvxyYAyTEOoDMSPAKTogTZJO45J1T2lGhPFyw9uMjD9g2jv10J1h45GzfVM7/N++DAt58hEYDmdxreJYuwP76SRZfOBScg0ehhT8vmQk5nRkTn3HS4hSKeH1X1vUHUtx7QRpxe9tven2OwesQhn4sdhG+tAxO6V6cCtPvIemMKlWLk6W2UwNxoVYVDnrTkl+FtHC/fX3mXo2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TccnvQJRSH0FVZkh49TVgW14bfHVG7FF8g1HiNImSLA=;
 b=xsdEKuqDaEcNrSXv4eYRZAj8lEALEIECJcOob2NngpJ1nJTXDYMGokZBlTm0eLXcjgTx5+0Z0R3pjjq/Sdundw/6M9yqhByuXxJtYWakpYNe2jabVEPmKhkV9ijfjo8IFZDuzLlZXIi5nWlDiBLbf5mYMaf3p2KuALYYt59Lz0k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2421.namprd12.prod.outlook.com (52.132.141.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Thu, 19 Dec 2019 22:56:54 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61%5]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 22:56:54 +0000
Subject: Re: [RFC PATCH v3 4/6] crypto: ccp - check whether PSP supports SEV
 or TEE before initialization
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1575438845.git.Rijo-john.Thomas@amd.com>
 <6a7be399d095373d2677440ff1fef406f97bf0d0.1575438845.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <gary.hook@amd.com>
Message-ID: <1e1aecde-7c1a-3d5b-be38-c4cfecfd16aa@amd.com>
Date:   Thu, 19 Dec 2019 16:56:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <6a7be399d095373d2677440ff1fef406f97bf0d0.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0069.prod.exchangelabs.com (2603:10b6:800::37) To
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5e502df2-112f-4f0f-3a58-08d784d6be2d
X-MS-TrafficTypeDiagnostic: DM5PR12MB2421:|DM5PR12MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2421815D52DDC2BD0789AA57FD520@DM5PR12MB2421.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1850;
X-Forefront-PRVS: 0256C18696
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(189003)(199004)(31686004)(8936002)(81166006)(5660300002)(66946007)(86362001)(110136005)(54906003)(53546011)(186003)(478600001)(52116002)(26005)(81156014)(6506007)(8676002)(36756003)(316002)(4326008)(2616005)(66476007)(31696002)(2906002)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2421;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1Q/FNzNbNM2YrZ4qnBR/6DwtqVT4NciOwVDfv8LJYTKsC27O16ye0OhEEomvH/XbpIAml76EVXXBmHYrPmjG/0vczPRWTs27BR9IQzEvLEEeDNgaj34u0Mc5bJergt0N75CJeWVpfFhKZHVnMRATxhrKBSFIguro8miWBMR+L0OrJzI+URMIJcXD7fO8GPXknUtliZNYZOdsbA4hSOiRxmmhSGer9M8/m/aglOj/Tb/oYLUVzcQEl9oflrZP6d1zmwMk2RbqJvgZLXaDJ1AJ2UUSVoSZWGG8ON99qhkeqMUmi7g45/2LVHyIrTJ2xBNLXOBmVMQV7vEAmCu2vTUE8mku0UvhOFyn76VpokCBN77vOKN/YMwonYEpswBEh+AWADfhKr31nFp/vjVRpmjOC88J/EFph5ruzURTHrOhyog+svkl+0KiRsntqOXKvJxl
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e502df2-112f-4f0f-3a58-08d784d6be2d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2019 22:56:54.7766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMQRLg2awUEVLk3fzyeNL28h6vwCoufsr6GO/zoAs3ihWALukwGrQbcp8TLEvNz/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2421
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/4/19 12:19 AM, Rijo Thomas wrote:
> Read PSP feature register to check for TEE (Trusted Execution Environment)
> support.
> 
> If neither SEV nor TEE is supported by PSP, then skip PSP initialization.
> 
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Jens Wiklander <jens.wiklander@linaro.org>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/psp-dev.c | 46 +++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 2cd7a5e..3bedf72 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -53,7 +53,7 @@ static irqreturn_t psp_irq_handler(int irq, void *data)
>   	return IRQ_HANDLED;
>   }
>   
> -static int psp_check_sev_support(struct psp_device *psp)
> +static unsigned int psp_get_capability(struct psp_device *psp)
>   {
>   	unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
>   
> @@ -66,11 +66,17 @@ static int psp_check_sev_support(struct psp_device *psp)
>   	 */
>   	if (val == 0xffffffff) {
>   		dev_notice(psp->dev, "psp: unable to access the device: you might be running a broken BIOS.\n");
> -		return -ENODEV;
> +		return 0;
>   	}
>   
> -	if (!(val & 1)) {
> -		/* Device does not support the SEV feature */
> +	return val;
> +}
> +
> +static int psp_check_sev_support(struct psp_device *psp,
> +				 unsigned int capability)
> +{
> +	/* Check if device supports SEV feature */
> +	if (!(capability & 1)) {
>   		dev_dbg(psp->dev, "psp does not support SEV\n");
>   		return -ENODEV;
>   	}
> @@ -78,10 +84,36 @@ static int psp_check_sev_support(struct psp_device *psp)
>   	return 0;
>   }
>   
> +static int psp_check_tee_support(struct psp_device *psp,
> +				 unsigned int capability)
> +{
> +	/* Check if device supports TEE feature */
> +	if (!(capability & 2)) {
> +		dev_dbg(psp->dev, "psp does not support TEE\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static int psp_check_support(struct psp_device *psp,
> +			     unsigned int capability)
> +{
> +	int sev_support = psp_check_sev_support(psp, capability);
> +	int tee_support = psp_check_tee_support(psp, capability);
> +
> +	/* Return error if device neither supports SEV nor TEE */
> +	if (sev_support && tee_support)
> +		return -ENODEV;
> +
> +	return 0;
> +}
> +
>   int psp_dev_init(struct sp_device *sp)
>   {
>   	struct device *dev = sp->dev;
>   	struct psp_device *psp;
> +	unsigned int capability;
>   	int ret;
>   
>   	ret = -ENOMEM;
> @@ -100,7 +132,11 @@ int psp_dev_init(struct sp_device *sp)
>   
>   	psp->io_regs = sp->io_map;
>   
> -	ret = psp_check_sev_support(psp);
> +	capability = psp_get_capability(psp);
> +	if (!capability)
> +		goto e_disable;
> +
> +	ret = psp_check_support(psp, capability);
>   	if (ret)
>   		goto e_disable;
>   
> 

