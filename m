Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 966CEC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 22:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55E9B24672
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 22:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="Qnvb8U5V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLSW5P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 17:57:15 -0500
Received: from mail-co1nam11on2063.outbound.protection.outlook.com ([40.107.220.63]:20304
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726943AbfLSW5P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 17:57:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYvDmLfaEwZKUfxeykRXIbMgVeWeW3a/TkJZEeFleFInpJ7Socst8MeNHgTYiKir1BGVDAHy4kFYfLa6I90xzyNo/z8k2NmnW2bS+c9r/oEkngyYnAWWRQ5PvIC+nwqs7VcBaBYc9adKRTI+mxLj4sUXT5N9vZtfRSXQWsDHoJSTOuUDApK69mrVtDzvVZ+Qew30zHmrg07/gQ2ASSJpIVifo7zVeMY5oiaTeGUoGoQJPvx8yGdX2rDn3eCPLs2/hUAEekOvD7WoSmYQWkSaZYXOMm+YyUYpcqM4znDKfzjSeN97r43NNQryAllogQL+vFCIq4w+6fax9qD5Okzx6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxE3/2OC6brm2WBSTxG53YWP/dW12PcqU4u8JQX/ypw=;
 b=a4dvOIw4lBhaHf3b4R7KhYsl7ruYMKWJYGdGepbKTuNo1rjS0GBtfQydZSpmyNh4wDTO9TAGbxQv+4ywwY6r0PbflE4/iXf1SvW1yX6Auke9qJTw6IJ1rWaOV5/sH6E/DUksV9rvTjS6SlZYid4MEGgtTHIhzQ/g3w+5BByv+wW2SkvrxyaiigmwxrtrALjKh9DwLsQ+HFk3/PqgCmIQSumnNPpy2b5a53j/hr4RY4c8J5EGzrnSWSzzowd9paLOz8fuoQ9Bbk5n7kecgY3orj2fmjQ5s7ndBHGb6B5KiuTFWzHN1vRT7pS59bwGvj+aSbVeFARnGFs3CUBzvtFTGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxE3/2OC6brm2WBSTxG53YWP/dW12PcqU4u8JQX/ypw=;
 b=Qnvb8U5VFZD6ndOeM5J77wmmYVu2kWy++s8QSKLQeFO/uAwr0f3rwJQT1zrx98ZH+x4Jb5A7CcXjaHMNViFbvHgwTcpADTfO/9Za/yw3HBp4n1nGsZJKJl7eNaAraqXPYZackuH6umjfxpD5I7pPF/VMwkv7pJwmF0b53YNp8sY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2421.namprd12.prod.outlook.com (52.132.141.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Thu, 19 Dec 2019 22:56:40 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61%5]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 22:56:39 +0000
Subject: Re: [RFC PATCH v3 3/6] crypto: ccp - move SEV vdata to a dedicated
 data structure
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
 <f1ce9dbeb28ba2adfe9ad205d59f0a91fefd5a33.1575438845.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <gary.hook@amd.com>
Message-ID: <a516221c-5a4b-efff-38d5-da3a35bcd388@amd.com>
Date:   Thu, 19 Dec 2019 16:56:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <f1ce9dbeb28ba2adfe9ad205d59f0a91fefd5a33.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0061.prod.exchangelabs.com (2603:10b6:800::29) To
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bd5433da-eae2-4466-dd3d-08d784d6b558
X-MS-TrafficTypeDiagnostic: DM5PR12MB2421:|DM5PR12MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB24214B86FB915ABC6FA4C9BDFD520@DM5PR12MB2421.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:785;
X-Forefront-PRVS: 0256C18696
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(189003)(199004)(31686004)(8936002)(81166006)(5660300002)(66946007)(86362001)(110136005)(54906003)(53546011)(186003)(478600001)(52116002)(26005)(81156014)(6506007)(8676002)(36756003)(316002)(4326008)(2616005)(66476007)(31696002)(2906002)(66556008)(6512007)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2421;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UMHySeo/y0sDtA4WgFf9iTT8BvzKcU/eLbakSx9lFoNqszEuzVX9V/K+6iB8XeMtHndTSmOpAJhts7W4XbHpm+1B6iaZFcteAfDRqV81ngTpMGn751k/FFgEzBRCyUf770PLAR0xQMgFUsmoQenQjPJBKQKWDZrDL/bITxSl64kearerYFUTn+VXTSlzzMFPKd4mvwRIZ852DT5ISS3hTwQMnlabeXrzrVfR20NYMoTfoZIhl2BmnsFr2kQe5UUdqbNbmRiAtU7Pn9QTPDe94QlWAK/9YwcOd2N8Msz04ybfoG8jRG2PX0pG+giqNU37BQU8IpSUn/X+BQsY8i1pBhDTnP7kF9Bn1yG+k1cd/TeeuA0/p5/jyaEzdKP664T9l5+xwWVg/4tL8y/NT6ANAouiA5kOlKvl6E5mYW4gJyM2kJaIF6Jaz1VS10XQfmDX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd5433da-eae2-4466-dd3d-08d784d6b558
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2019 22:56:39.8871
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JvlPcdqZJqkbhagTqdxXUVcYw8LoU+Rqe/+71aYZ4eQ17Bq0JrGMUqdKHwoRkb3P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2421
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/4/19 12:19 AM, Rijo Thomas wrote:
> PSP can support both SEV and TEE interface. Therefore, move
> SEV specific registers to a dedicated data structure.
> TEE interface specific registers will be added in a later
> patch.
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Jens Wiklander <jens.wiklander@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/sev-dev.c | 17 ++++++++++++-----
>   drivers/crypto/ccp/sev-dev.h |  2 ++
>   drivers/crypto/ccp/sp-dev.h  |  6 +++++-
>   drivers/crypto/ccp/sp-pci.c  | 16 ++++++++++++----
>   4 files changed, 31 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index a608b52..e68fa48 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -65,7 +65,7 @@ static void sev_irq_handler(int irq, void *data, unsigned int status)
>   		return;
>   
>   	/* Check if it is SEV command completion: */
> -	reg = ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
> +	reg = ioread32(sev->io_regs + sev->vdata->cmdresp_reg);
>   	if (reg & PSP_CMDRESP_RESP) {
>   		sev->int_rcvd = 1;
>   		wake_up(&sev->int_queue);
> @@ -82,7 +82,7 @@ static int sev_wait_cmd_ioc(struct sev_device *sev,
>   	if (!ret)
>   		return -ETIMEDOUT;
>   
> -	*reg = ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
> +	*reg = ioread32(sev->io_regs + sev->vdata->cmdresp_reg);
>   
>   	return 0;
>   }
> @@ -148,15 +148,15 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
>   			     sev_cmd_buffer_len(cmd), false);
>   
> -	iowrite32(phys_lsb, sev->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
> -	iowrite32(phys_msb, sev->io_regs + psp->vdata->cmdbuff_addr_hi_reg);
> +	iowrite32(phys_lsb, sev->io_regs + sev->vdata->cmdbuff_addr_lo_reg);
> +	iowrite32(phys_msb, sev->io_regs + sev->vdata->cmdbuff_addr_hi_reg);
>   
>   	sev->int_rcvd = 0;
>   
>   	reg = cmd;
>   	reg <<= SEV_CMDRESP_CMD_SHIFT;
>   	reg |= SEV_CMDRESP_IOC;
> -	iowrite32(reg, sev->io_regs + psp->vdata->cmdresp_reg);
> +	iowrite32(reg, sev->io_regs + sev->vdata->cmdresp_reg);
>   
>   	/* wait for command completion */
>   	ret = sev_wait_cmd_ioc(sev, &reg, psp_timeout);
> @@ -949,6 +949,13 @@ int sev_dev_init(struct psp_device *psp)
>   
>   	sev->io_regs = psp->io_regs;
>   
> +	sev->vdata = (struct sev_vdata *)psp->vdata->sev;
> +	if (!sev->vdata) {
> +		ret = -ENODEV;
> +		dev_err(dev, "sev: missing driver data\n");
> +		goto e_err;
> +	}
> +
>   	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
>   
>   	ret = sev_misc_init(sev);
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index 3d84ac3..dd5c4fe 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -40,6 +40,8 @@ struct sev_device {
>   
>   	void __iomem *io_regs;
>   
> +	struct sev_vdata *vdata;
> +
>   	int state;
>   	unsigned int int_rcvd;
>   	wait_queue_head_t int_queue;
> diff --git a/drivers/crypto/ccp/sp-dev.h b/drivers/crypto/ccp/sp-dev.h
> index 53c1256..0394c75 100644
> --- a/drivers/crypto/ccp/sp-dev.h
> +++ b/drivers/crypto/ccp/sp-dev.h
> @@ -39,10 +39,14 @@ struct ccp_vdata {
>   	const unsigned int rsamax;
>   };
>   
> -struct psp_vdata {
> +struct sev_vdata {
>   	const unsigned int cmdresp_reg;
>   	const unsigned int cmdbuff_addr_lo_reg;
>   	const unsigned int cmdbuff_addr_hi_reg;
> +};
> +
> +struct psp_vdata {
> +	const struct sev_vdata *sev;
>   	const unsigned int feature_reg;
>   	const unsigned int inten_reg;
>   	const unsigned int intsts_reg;
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index b29d2e6..733693d 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -262,19 +262,27 @@ static int sp_pci_resume(struct pci_dev *pdev)
>   #endif
>   
>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
> -static const struct psp_vdata pspv1 = {
> +static const struct sev_vdata sevv1 = {
>   	.cmdresp_reg		= 0x10580,
>   	.cmdbuff_addr_lo_reg	= 0x105e0,
>   	.cmdbuff_addr_hi_reg	= 0x105e4,
> +};
> +
> +static const struct sev_vdata sevv2 = {
> +	.cmdresp_reg		= 0x10980,
> +	.cmdbuff_addr_lo_reg	= 0x109e0,
> +	.cmdbuff_addr_hi_reg	= 0x109e4,
> +};
> +
> +static const struct psp_vdata pspv1 = {
> +	.sev			= &sevv1,
>   	.feature_reg		= 0x105fc,
>   	.inten_reg		= 0x10610,
>   	.intsts_reg		= 0x10614,
>   };
>   
>   static const struct psp_vdata pspv2 = {
> -	.cmdresp_reg		= 0x10980,
> -	.cmdbuff_addr_lo_reg	= 0x109e0,
> -	.cmdbuff_addr_hi_reg	= 0x109e4,
> +	.sev			= &sevv2,
>   	.feature_reg		= 0x109fc,
>   	.inten_reg		= 0x10690,
>   	.intsts_reg		= 0x10694,
> 

