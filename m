Return-Path: <SRS0=f4rb=ZZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DB0C432C3
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 15:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B87F206E4
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Dec 2019 15:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="BPhzyxkG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfLCP6C (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Dec 2019 10:58:02 -0500
Received: from mail-eopbgr680054.outbound.protection.outlook.com ([40.107.68.54]:5819
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726105AbfLCP6B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Dec 2019 10:58:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czDeRivsN8NYl4x6Ye1cOxkGVbEISUn1WmAqh0nWhBEt8UDRQMIkL+DDHa/dw0wKbEjwiJq2BkCAso5tKUqb5L81aXGlCBkGUuwPTMzN74rActFcNbzXN0FODVI4S5bPLHfMfycG6yLryVzmc7ts/AbS+hnMrmTEtFWBzvHEI5F+UDEFLtHg6xFqvDTMDD7EuN48AfOMEuBAJ/iN+0O1TelhtgmJg3kJuWGlMTg4JEMwPO2ruSuPErYXcjuNspK09syQg2oZpzUYyU34zAOEeO4rjUmxON0fLyy6VKhWNkgwHRizrF9MzhZjctQQCABXwlrtipiGgBuCQ11WM7YdEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1/IWsAtqhrfLVfMhyNocxuvNJ1Cn7wZPdDkGLYcilc=;
 b=QhOOW1l+OJGCKaqZIkQb8iCU02Dr9939LDk7aH3VQjBtuXiiayRRiJtC7ia2hf3eyQuJzy5NWl3s/aozjW79HIDRPiBAkzQd3VkeD5B30XNFIQCDc30oR2xl5E7zITCjMZHcuC8TiR0OyhM4ZF0nhFx7cNeqzdW6jpxyRfe49HORORdJA9lwUR0ITuIevYR2TZ9u6Dy3xBK2fN0f43LvZYQlEqUo4vBG26psnmjAt/MzdVA8MD8kMQ+swZWkFfArXMBUf3/KAJ8qJJ6nq5ZQ6Xn3EN7mgfqqGG7DppHnZozV3T57sYKB+mYlg4d1dgijtZRssjvKo1b+gzZmwPpF1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1/IWsAtqhrfLVfMhyNocxuvNJ1Cn7wZPdDkGLYcilc=;
 b=BPhzyxkGAceLWWtDuNJsu8tkRx19EGZqmfLhM6lin0OvHlqNE/aS8+PzVYlzTBGC6XvOOQFbKBfs78T+oj3urHg7JV8SRcnlS2dWY5m/rXPUt34sAzyeq5zMl4sOMxJ5VnrzGZQh5geg3N1L8eUc8XQQPyKji4MousAlGKynq6g=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from MWHPR12MB1455.namprd12.prod.outlook.com (10.172.56.18) by
 MWHPR12MB1375.namprd12.prod.outlook.com (10.169.205.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.21; Tue, 3 Dec 2019 15:57:52 +0000
Received: from MWHPR12MB1455.namprd12.prod.outlook.com
 ([fe80::a9f5:1fad:a0bf:fa95]) by MWHPR12MB1455.namprd12.prod.outlook.com
 ([fe80::a9f5:1fad:a0bf:fa95%11]) with mapi id 15.20.2495.014; Tue, 3 Dec 2019
 15:57:52 +0000
Subject: Re: [RFC PATCH v2 2/6] crypto: ccp - create a generic psp-dev file
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <cover.1575282249.git.Rijo-john.Thomas@amd.com>
 <fa06de4e44de4b1d9f37abeb35950438d356e09d.1575282249.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <gary.hook@amd.com>
Message-ID: <c874fa57-612a-9f94-8845-fe8a7c4b743b@amd.com>
Date:   Tue, 3 Dec 2019 09:57:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <fa06de4e44de4b1d9f37abeb35950438d356e09d.1575282249.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CY4PR21CA0045.namprd21.prod.outlook.com
 (2603:10b6:903:12b::31) To MWHPR12MB1455.namprd12.prod.outlook.com
 (2603:10b6:301:10::18)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5b761bf9-5f0d-4cef-f10e-08d778098da4
X-MS-TrafficTypeDiagnostic: MWHPR12MB1375:|MWHPR12MB1375:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB13755FD0B7D40858710871AAFD420@MWHPR12MB1375.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 02408926C4
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(189003)(199004)(26005)(386003)(2486003)(76176011)(14454004)(66476007)(316002)(66556008)(229853002)(50466002)(2906002)(66946007)(478600001)(11346002)(6436002)(6512007)(99286004)(186003)(5660300002)(25786009)(446003)(2616005)(6246003)(230700001)(30864003)(305945005)(8936002)(65956001)(6666004)(86362001)(3846002)(31696002)(81166006)(58126008)(14444005)(6486002)(81156014)(4326008)(7736002)(54906003)(52116002)(6506007)(31686004)(36756003)(53546011)(110136005)(6116002)(8676002)(23676004)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR12MB1375;H:MWHPR12MB1455.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OrM0akuhRttFX3yxT8QMs+hdoWIVV6NAXk7qR8mpgncyvYJPkiaHmX2iFvAr7L/VwTJdvmPu+F4muJS9Tt9n4BtLbJz3gbmhlwP4WwWEuvh0ikk6HlIDIlxi9OXOUJrzXY96OLqKK75VRbjqGzhiX8vr9gZJviPI6Jy2ByTxjCcdgAMwvCW053qlV45LXOREiCkLQYQJvwCmBb9IB3mk2uW5Oiayqke4f+/xYK+ivN6f5Me1OUw1ApHbkmGo0hQPtb5uzYtZOSps96yppcPYY9Se+8pQMCheeWdgYU8uGR8DbbcbNZ0nqV0KWd1KTi6eiga8KKfVrDWS20k8t/YUuWX4lh9JttuvgCRe51MgRvPOhXm51oE/qIkU/UGetSf0k6JMJ7dV3pCgJY3w0EAIm9axOi8KmlErSRYUip2iAW914suZ9Z3LMngF0Nbymfyd
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b761bf9-5f0d-4cef-f10e-08d778098da4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2019 15:57:52.5419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gLbThjutp9tGKcp850uO1WyaMnhYJvLmDGev2sYEFNobedVnKmX2ozaL+SUzs5z/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1375
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/2/19 10:39 PM, Rijo Thomas wrote:
> The PSP (Platform Security Processor) provides support for key management
> commands in Secure Encrypted Virtualization (SEV) mode, along with
> software-based Trusted Execution Environment (TEE) to enable third-party
> Trusted Applications.
> 
> Therefore, introduce psp-dev.c and psp-dev.h files, which can invoke
> SEV (or TEE) initialization based on platform feature support.
> 
> TEE interface support will be introduced in a later patch.


This patch does not cleanly apply to the current cryptodev-2.6 tree. 
Please ensure that you have pulled and rebased, built, and tested just 
prior to sending out your patches.

grh

> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Jens Wiklander <jens.wiklander@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>
> ---
>   drivers/crypto/ccp/Makefile  |   3 +-
>   drivers/crypto/ccp/psp-dev.c | 194 ++++++++++++++++++++++++++++++
>   drivers/crypto/ccp/psp-dev.h |  52 +++++++++
>   drivers/crypto/ccp/sev-dev.c | 273 ++++++++++++++++---------------------------
>   drivers/crypto/ccp/sev-dev.h |  36 +++---
>   drivers/crypto/ccp/sp-pci.c  |   2 +-
>   6 files changed, 367 insertions(+), 193 deletions(-)
>   create mode 100644 drivers/crypto/ccp/psp-dev.c
>   create mode 100644 drivers/crypto/ccp/psp-dev.h
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 9dafcf2..3b29ea4 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -8,7 +8,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
>   	    ccp-dmaengine.o
>   ccp-$(CONFIG_CRYPTO_DEV_CCP_DEBUGFS) += ccp-debugfs.o
>   ccp-$(CONFIG_PCI) += sp-pci.o
> -ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += sev-dev.o
> +ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
> +                                   sev-dev.o
>   
>   obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>   ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> new file mode 100644
> index 0000000..2cd7a5e
> --- /dev/null
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -0,0 +1,194 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * AMD Platform Security Processor (PSP) interface
> + *
> + * Copyright (C) 2016,2019 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/irqreturn.h>
> +
> +#include "sp-dev.h"
> +#include "psp-dev.h"
> +#include "sev-dev.h"
> +
> +struct psp_device *psp_master;
> +
> +static struct psp_device *psp_alloc_struct(struct sp_device *sp)
> +{
> +	struct device *dev = sp->dev;
> +	struct psp_device *psp;
> +
> +	psp = devm_kzalloc(dev, sizeof(*psp), GFP_KERNEL);
> +	if (!psp)
> +		return NULL;
> +
> +	psp->dev = dev;
> +	psp->sp = sp;
> +
> +	snprintf(psp->name, sizeof(psp->name), "psp-%u", sp->ord);
> +
> +	return psp;
> +}
> +
> +static irqreturn_t psp_irq_handler(int irq, void *data)
> +{
> +	struct psp_device *psp = data;
> +	unsigned int status;
> +
> +	/* Read the interrupt status: */
> +	status = ioread32(psp->io_regs + psp->vdata->intsts_reg);
> +
> +	/* invoke subdevice interrupt handlers */
> +	if (status) {
> +		if (psp->sev_irq_handler)
> +			psp->sev_irq_handler(irq, psp->sev_irq_data, status);
> +	}
> +
> +	/* Clear the interrupt status by writing the same value we read. */
> +	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int psp_check_sev_support(struct psp_device *psp)
> +{
> +	unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
> +
> +	/*
> +	 * Check for a access to the registers.  If this read returns
> +	 * 0xffffffff, it's likely that the system is running a broken
> +	 * BIOS which disallows access to the device. Stop here and
> +	 * fail the PSP initialization (but not the load, as the CCP
> +	 * could get properly initialized).
> +	 */
> +	if (val == 0xffffffff) {
> +		dev_notice(psp->dev, "psp: unable to access the device: you might be running a broken BIOS.\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!(val & 1)) {
> +		/* Device does not support the SEV feature */
> +		dev_dbg(psp->dev, "psp does not support SEV\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +int psp_dev_init(struct sp_device *sp)
> +{
> +	struct device *dev = sp->dev;
> +	struct psp_device *psp;
> +	int ret;
> +
> +	ret = -ENOMEM;
> +	psp = psp_alloc_struct(sp);
> +	if (!psp)
> +		goto e_err;
> +
> +	sp->psp_data = psp;
> +
> +	psp->vdata = (struct psp_vdata *)sp->dev_vdata->psp_vdata;
> +	if (!psp->vdata) {
> +		ret = -ENODEV;
> +		dev_err(dev, "missing driver data\n");
> +		goto e_err;
> +	}
> +
> +	psp->io_regs = sp->io_map;
> +
> +	ret = psp_check_sev_support(psp);
> +	if (ret)
> +		goto e_disable;
> +
> +	/* Disable and clear interrupts until ready */
> +	iowrite32(0, psp->io_regs + psp->vdata->inten_reg);
> +	iowrite32(-1, psp->io_regs + psp->vdata->intsts_reg);
> +
> +	/* Request an irq */
> +	ret = sp_request_psp_irq(psp->sp, psp_irq_handler, psp->name, psp);
> +	if (ret) {
> +		dev_err(dev, "psp: unable to allocate an IRQ\n");
> +		goto e_err;
> +	}
> +
> +	ret = sev_dev_init(psp);
> +	if (ret)
> +		goto e_irq;
> +
> +	if (sp->set_psp_master_device)
> +		sp->set_psp_master_device(sp);
> +
> +	/* Enable interrupt */
> +	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
> +
> +	dev_notice(dev, "psp enabled\n");
> +
> +	return 0;
> +
> +e_irq:
> +	sp_free_psp_irq(psp->sp, psp);
> +e_err:
> +	sp->psp_data = NULL;
> +
> +	dev_notice(dev, "psp initialization failed\n");
> +
> +	return ret;
> +
> +e_disable:
> +	sp->psp_data = NULL;
> +
> +	return ret;
> +}
> +
> +void psp_dev_destroy(struct sp_device *sp)
> +{
> +	struct psp_device *psp = sp->psp_data;
> +
> +	if (!psp)
> +		return;
> +
> +	sev_dev_destroy(psp);
> +
> +	sp_free_psp_irq(sp, psp);
> +}
> +
> +void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t handler,
> +			     void *data)
> +{
> +	psp->sev_irq_data = data;
> +	psp->sev_irq_handler = handler;
> +}
> +
> +void psp_clear_sev_irq_handler(struct psp_device *psp)
> +{
> +	psp_set_sev_irq_handler(psp, NULL, NULL);
> +}
> +
> +struct psp_device *psp_get_master_device(void)
> +{
> +	struct sp_device *sp = sp_get_psp_master_device();
> +
> +	return sp ? sp->psp_data : NULL;
> +}
> +
> +void psp_pci_init(void)
> +{
> +	psp_master = psp_get_master_device();
> +
> +	if (!psp_master)
> +		return;
> +
> +	sev_pci_init();
> +}
> +
> +void psp_pci_exit(void)
> +{
> +	if (!psp_master)
> +		return;
> +
> +	sev_pci_exit();
> +}
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
> new file mode 100644
> index 0000000..7c014ac
> --- /dev/null
> +++ b/drivers/crypto/ccp/psp-dev.h
> @@ -0,0 +1,52 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * AMD Platform Security Processor (PSP) interface driver
> + *
> + * Copyright (C) 2017-2019 Advanced Micro Devices, Inc.
> + *
> + * Author: Brijesh Singh <brijesh.singh@amd.com>
> + */
> +
> +#ifndef __PSP_DEV_H__
> +#define __PSP_DEV_H__
> +
> +#include <linux/device.h>
> +#include <linux/list.h>
> +#include <linux/bits.h>
> +#include <linux/interrupt.h>
> +
> +#include "sp-dev.h"
> +
> +#define PSP_CMDRESP_RESP		BIT(31)
> +#define PSP_CMDRESP_ERR_MASK		0xffff
> +
> +#define MAX_PSP_NAME_LEN		16
> +
> +extern struct psp_device *psp_master;
> +
> +typedef void (*psp_irq_handler_t)(int, void *, unsigned int);
> +
> +struct psp_device {
> +	struct list_head entry;
> +
> +	struct psp_vdata *vdata;
> +	char name[MAX_PSP_NAME_LEN];
> +
> +	struct device *dev;
> +	struct sp_device *sp;
> +
> +	void __iomem *io_regs;
> +
> +	psp_irq_handler_t sev_irq_handler;
> +	void *sev_irq_data;
> +
> +	void *sev_data;
> +};
> +
> +void psp_set_sev_irq_handler(struct psp_device *psp, psp_irq_handler_t handler,
> +			     void *data);
> +void psp_clear_sev_irq_handler(struct psp_device *psp);
> +
> +struct psp_device *psp_get_master_device(void);
> +
> +#endif /* __PSP_DEV_H */
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index ba9f555..ec595e6 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -21,7 +21,7 @@
>   #include <linux/ccp.h>
>   #include <linux/firmware.h>
>   
> -#include "sp-dev.h"
> +#include "psp-dev.h"
>   #include "sev-dev.h"
>   
>   #define DEVICE_NAME		"sev"
> @@ -30,7 +30,6 @@
>   
>   static DEFINE_MUTEX(sev_cmd_mutex);
>   static struct sev_misc_dev *misc_dev;
> -static struct psp_device *psp_master;
>   
>   static int psp_cmd_timeout = 100;
>   module_param(psp_cmd_timeout, int, 0644);
> @@ -45,68 +44,45 @@
>   
>   static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
>   {
> -	if (psp_master->api_major > maj)
> -		return true;
> -	if (psp_master->api_major == maj && psp_master->api_minor >= min)
> -		return true;
> -	return false;
> -}
> -
> -static struct psp_device *psp_alloc_struct(struct sp_device *sp)
> -{
> -	struct device *dev = sp->dev;
> -	struct psp_device *psp;
> +	struct sev_device *sev = psp_master->sev_data;
>   
> -	psp = devm_kzalloc(dev, sizeof(*psp), GFP_KERNEL);
> -	if (!psp)
> -		return NULL;
> -
> -	psp->dev = dev;
> -	psp->sp = sp;
> +	if (sev->api_major > maj)
> +		return true;
>   
> -	snprintf(psp->name, sizeof(psp->name), "psp-%u", sp->ord);
> +	if (sev->api_major == maj && sev->api_minor >= min)
> +		return true;
>   
> -	return psp;
> +	return false;
>   }
>   
> -static irqreturn_t psp_irq_handler(int irq, void *data)
> +static void sev_irq_handler(int irq, void *data, unsigned int status)
>   {
> -	struct psp_device *psp = data;
> -	unsigned int status;
> +	struct sev_device *sev = data;
>   	int reg;
>   
> -	/* Read the interrupt status: */
> -	status = ioread32(psp->io_regs + psp->vdata->intsts_reg);
> -
>   	/* Check if it is command completion: */
> -	if (!(status & PSP_CMD_COMPLETE))
> -		goto done;
> +	if (!(status & SEV_CMD_COMPLETE))
> +		return;
>   
>   	/* Check if it is SEV command completion: */
> -	reg = ioread32(psp->io_regs + psp->vdata->cmdresp_reg);
> +	reg = ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
>   	if (reg & PSP_CMDRESP_RESP) {
> -		psp->sev_int_rcvd = 1;
> -		wake_up(&psp->sev_int_queue);
> +		sev->int_rcvd = 1;
> +		wake_up(&sev->int_queue);
>   	}
> -
> -done:
> -	/* Clear the interrupt status by writing the same value we read. */
> -	iowrite32(status, psp->io_regs + psp->vdata->intsts_reg);
> -
> -	return IRQ_HANDLED;
>   }
>   
> -static int sev_wait_cmd_ioc(struct psp_device *psp,
> +static int sev_wait_cmd_ioc(struct sev_device *sev,
>   			    unsigned int *reg, unsigned int timeout)
>   {
>   	int ret;
>   
> -	ret = wait_event_timeout(psp->sev_int_queue,
> -			psp->sev_int_rcvd, timeout * HZ);
> +	ret = wait_event_timeout(sev->int_queue,
> +			sev->int_rcvd, timeout * HZ);
>   	if (!ret)
>   		return -ETIMEDOUT;
>   
> -	*reg = ioread32(psp->io_regs + psp->vdata->cmdresp_reg);
> +	*reg = ioread32(sev->io_regs + sev->psp->vdata->cmdresp_reg);
>   
>   	return 0;
>   }
> @@ -150,42 +126,45 @@ static int sev_cmd_buffer_len(int cmd)
>   static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   {
>   	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
>   	unsigned int phys_lsb, phys_msb;
>   	unsigned int reg, ret = 0;
>   
> -	if (!psp)
> +	if (!psp || !psp->sev_data)
>   		return -ENODEV;
>   
>   	if (psp_dead)
>   		return -EBUSY;
>   
> +	sev = psp->sev_data;
> +
>   	/* Get the physical address of the command buffer */
>   	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
>   	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
>   
> -	dev_dbg(psp->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
> +	dev_dbg(sev->dev, "sev command id %#x buffer 0x%08x%08x timeout %us\n",
>   		cmd, phys_msb, phys_lsb, psp_timeout);
>   
>   	print_hex_dump_debug("(in):  ", DUMP_PREFIX_OFFSET, 16, 2, data,
>   			     sev_cmd_buffer_len(cmd), false);
>   
> -	iowrite32(phys_lsb, psp->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
> -	iowrite32(phys_msb, psp->io_regs + psp->vdata->cmdbuff_addr_hi_reg);
> +	iowrite32(phys_lsb, sev->io_regs + psp->vdata->cmdbuff_addr_lo_reg);
> +	iowrite32(phys_msb, sev->io_regs + psp->vdata->cmdbuff_addr_hi_reg);
>   
> -	psp->sev_int_rcvd = 0;
> +	sev->int_rcvd = 0;
>   
>   	reg = cmd;
> -	reg <<= PSP_CMDRESP_CMD_SHIFT;
> -	reg |= PSP_CMDRESP_IOC;
> -	iowrite32(reg, psp->io_regs + psp->vdata->cmdresp_reg);
> +	reg <<= SEV_CMDRESP_CMD_SHIFT;
> +	reg |= SEV_CMDRESP_IOC;
> +	iowrite32(reg, sev->io_regs + psp->vdata->cmdresp_reg);
>   
>   	/* wait for command completion */
> -	ret = sev_wait_cmd_ioc(psp, &reg, psp_timeout);
> +	ret = sev_wait_cmd_ioc(sev, &reg, psp_timeout);
>   	if (ret) {
>   		if (psp_ret)
>   			*psp_ret = 0;
>   
> -		dev_err(psp->dev, "sev command %#x timed out, disabling PSP \n", cmd);
> +		dev_err(sev->dev, "sev command %#x timed out, disabling PSP\n", cmd);
>   		psp_dead = true;
>   
>   		return ret;
> @@ -197,7 +176,7 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
>   		*psp_ret = reg & PSP_CMDRESP_ERR_MASK;
>   
>   	if (reg & PSP_CMDRESP_ERR_MASK) {
> -		dev_dbg(psp->dev, "sev command %#x failed (%#010x)\n",
> +		dev_dbg(sev->dev, "sev command %#x failed (%#010x)\n",
>   			cmd, reg & PSP_CMDRESP_ERR_MASK);
>   		ret = -EIO;
>   	}
> @@ -222,20 +201,23 @@ static int sev_do_cmd(int cmd, void *data, int *psp_ret)
>   static int __sev_platform_init_locked(int *error)
>   {
>   	struct psp_device *psp = psp_master;
> +	struct sev_device *sev;
>   	int rc = 0;
>   
> -	if (!psp)
> +	if (!psp || !psp->sev_data)
>   		return -ENODEV;
>   
> -	if (psp->sev_state == SEV_STATE_INIT)
> +	sev = psp->sev_data;
> +
> +	if (sev->state == SEV_STATE_INIT)
>   		return 0;
>   
> -	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &psp->init_cmd_buf, error);
> +	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &sev->init_cmd_buf, error);
>   	if (rc)
>   		return rc;
>   
> -	psp->sev_state = SEV_STATE_INIT;
> -	dev_dbg(psp->dev, "SEV firmware initialized\n");
> +	sev->state = SEV_STATE_INIT;
> +	dev_dbg(sev->dev, "SEV firmware initialized\n");
>   
>   	return rc;
>   }
> @@ -254,14 +236,15 @@ int sev_platform_init(int *error)
>   
>   static int __sev_platform_shutdown_locked(int *error)
>   {
> +	struct sev_device *sev = psp_master->sev_data;
>   	int ret;
>   
>   	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
>   	if (ret)
>   		return ret;
>   
> -	psp_master->sev_state = SEV_STATE_UNINIT;
> -	dev_dbg(psp_master->dev, "SEV firmware shutdown\n");
> +	sev->state = SEV_STATE_UNINIT;
> +	dev_dbg(sev->dev, "SEV firmware shutdown\n");
>   
>   	return ret;
>   }
> @@ -279,14 +262,15 @@ static int sev_platform_shutdown(int *error)
>   
>   static int sev_get_platform_state(int *state, int *error)
>   {
> +	struct sev_device *sev = psp_master->sev_data;
>   	int rc;
>   
>   	rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
> -				 &psp_master->status_cmd_buf, error);
> +				 &sev->status_cmd_buf, error);
>   	if (rc)
>   		return rc;
>   
> -	*state = psp_master->status_cmd_buf.state;
> +	*state = sev->status_cmd_buf.state;
>   	return rc;
>   }
>   
> @@ -321,7 +305,8 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp)
>   
>   static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>   {
> -	struct sev_user_data_status *data = &psp_master->status_cmd_buf;
> +	struct sev_device *sev = psp_master->sev_data;
> +	struct sev_user_data_status *data = &sev->status_cmd_buf;
>   	int ret;
>   
>   	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
> @@ -336,9 +321,10 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>   
>   static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
>   {
> +	struct sev_device *sev = psp_master->sev_data;
>   	int rc;
>   
> -	if (psp_master->sev_state == SEV_STATE_UNINIT) {
> +	if (sev->state == SEV_STATE_UNINIT) {
>   		rc = __sev_platform_init_locked(&argp->error);
>   		if (rc)
>   			return rc;
> @@ -349,6 +335,7 @@ static int sev_ioctl_do_pek_pdh_gen(int cmd, struct sev_issue_cmd *argp)
>   
>   static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
>   {
> +	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pek_csr input;
>   	struct sev_data_pek_csr *data;
>   	void *blob = NULL;
> @@ -382,7 +369,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp)
>   	data->len = input.length;
>   
>   cmd:
> -	if (psp_master->sev_state == SEV_STATE_UNINIT) {
> +	if (sev->state == SEV_STATE_UNINIT) {
>   		ret = __sev_platform_init_locked(&argp->error);
>   		if (ret)
>   			goto e_free_blob;
> @@ -425,21 +412,22 @@ void *psp_copy_user_blob(u64 __user uaddr, u32 len)
>   
>   static int sev_get_api_version(void)
>   {
> +	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_status *status;
>   	int error = 0, ret;
>   
> -	status = &psp_master->status_cmd_buf;
> +	status = &sev->status_cmd_buf;
>   	ret = sev_platform_status(status, &error);
>   	if (ret) {
> -		dev_err(psp_master->dev,
> +		dev_err(sev->dev,
>   			"SEV: failed to get status. Error: %#x\n", error);
>   		return 1;
>   	}
>   
> -	psp_master->api_major = status->api_major;
> -	psp_master->api_minor = status->api_minor;
> -	psp_master->build = status->build;
> -	psp_master->sev_state = status->state;
> +	sev->api_major = status->api_major;
> +	sev->api_minor = status->api_minor;
> +	sev->build = status->build;
> +	sev->state = status->state;
>   
>   	return 0;
>   }
> @@ -535,6 +523,7 @@ static int sev_update_firmware(struct device *dev)
>   
>   static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
>   {
> +	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pek_cert_import input;
>   	struct sev_data_pek_cert_import *data;
>   	void *pek_blob, *oca_blob;
> @@ -568,7 +557,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp)
>   	data->oca_cert_len = input.oca_cert_len;
>   
>   	/* If platform is not in INIT state then transition it to INIT */
> -	if (psp_master->sev_state != SEV_STATE_INIT) {
> +	if (sev->state != SEV_STATE_INIT) {
>   		ret = __sev_platform_init_locked(&argp->error);
>   		if (ret)
>   			goto e_free_oca;
> @@ -690,6 +679,7 @@ static int sev_ioctl_do_get_id(struct sev_issue_cmd *argp)
>   
>   static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
>   {
> +	struct sev_device *sev = psp_master->sev_data;
>   	struct sev_user_data_pdh_cert_export input;
>   	void *pdh_blob = NULL, *cert_blob = NULL;
>   	struct sev_data_pdh_cert_export *data;
> @@ -742,7 +732,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp)
>   
>   cmd:
>   	/* If platform is not in INIT state then transition it to INIT. */
> -	if (psp_master->sev_state != SEV_STATE_INIT) {
> +	if (sev->state != SEV_STATE_INIT) {
>   		ret = __sev_platform_init_locked(&argp->error);
>   		if (ret)
>   			goto e_free_cert;
> @@ -788,7 +778,7 @@ static long sev_ioctl(struct file *file, unsigned int ioctl, unsigned long arg)
>   	struct sev_issue_cmd input;
>   	int ret = -EFAULT;
>   
> -	if (!psp_master)
> +	if (!psp_master || !psp_master->sev_data)
>   		return -ENODEV;
>   
>   	if (ioctl != SEV_ISSUE_CMD)
> @@ -887,9 +877,9 @@ static void sev_exit(struct kref *ref)
>   	misc_deregister(&misc_dev->misc);
>   }
>   
> -static int sev_misc_init(struct psp_device *psp)
> +static int sev_misc_init(struct sev_device *sev)
>   {
> -	struct device *dev = psp->dev;
> +	struct device *dev = sev->dev;
>   	int ret;
>   
>   	/*
> @@ -920,115 +910,61 @@ static int sev_misc_init(struct psp_device *psp)
>   		kref_get(&misc_dev->refcount);
>   	}
>   
> -	init_waitqueue_head(&psp->sev_int_queue);
> -	psp->sev_misc = misc_dev;
> +	init_waitqueue_head(&sev->int_queue);
> +	sev->misc = misc_dev;
>   	dev_dbg(dev, "registered SEV device\n");
>   
>   	return 0;
>   }
>   
> -static int psp_check_sev_support(struct psp_device *psp)
> -{
> -	unsigned int val = ioread32(psp->io_regs + psp->vdata->feature_reg);
> -
> -	/*
> -	 * Check for a access to the registers.  If this read returns
> -	 * 0xffffffff, it's likely that the system is running a broken
> -	 * BIOS which disallows access to the device. Stop here and
> -	 * fail the PSP initialization (but not the load, as the CCP
> -	 * could get properly initialized).
> -	 */
> -	if (val == 0xffffffff) {
> -		dev_notice(psp->dev, "psp: unable to access the device: you might be running a broken BIOS.\n");
> -		return -ENODEV;
> -	}
> -
> -	if (!(val & 1)) {
> -		/* Device does not support the SEV feature */
> -		dev_dbg(psp->dev, "psp does not support SEV\n");
> -		return -ENODEV;
> -	}
> -
> -	return 0;
> -}
> -
> -int psp_dev_init(struct sp_device *sp)
> +int sev_dev_init(struct psp_device *psp)
>   {
> -	struct device *dev = sp->dev;
> -	struct psp_device *psp;
> -	int ret;
> +	struct device *dev = psp->dev;
> +	struct sev_device *sev;
> +	int ret = -ENOMEM;
>   
> -	ret = -ENOMEM;
> -	psp = psp_alloc_struct(sp);
> -	if (!psp)
> +	sev = devm_kzalloc(dev, sizeof(*sev), GFP_KERNEL);
> +	if (!sev)
>   		goto e_err;
>   
> -	sp->psp_data = psp;
> +	psp->sev_data = sev;
>   
> -	psp->vdata = (struct psp_vdata *)sp->dev_vdata->psp_vdata;
> -	if (!psp->vdata) {
> -		ret = -ENODEV;
> -		dev_err(dev, "missing driver data\n");
> -		goto e_err;
> -	}
> +	sev->dev = dev;
> +	sev->psp = psp;
>   
> -	psp->io_regs = sp->io_map;
> +	sev->io_regs = psp->io_regs;
>   
> -	ret = psp_check_sev_support(psp);
> -	if (ret)
> -		goto e_disable;
> +	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
>   
> -	/* Disable and clear interrupts until ready */
> -	iowrite32(0, psp->io_regs + psp->vdata->inten_reg);
> -	iowrite32(-1, psp->io_regs + psp->vdata->intsts_reg);
> -
> -	/* Request an irq */
> -	ret = sp_request_psp_irq(psp->sp, psp_irq_handler, psp->name, psp);
> -	if (ret) {
> -		dev_err(dev, "psp: unable to allocate an IRQ\n");
> -		goto e_err;
> -	}
> -
> -	ret = sev_misc_init(psp);
> +	ret = sev_misc_init(sev);
>   	if (ret)
>   		goto e_irq;
>   
> -	if (sp->set_psp_master_device)
> -		sp->set_psp_master_device(sp);
> -
> -	/* Enable interrupt */
> -	iowrite32(-1, psp->io_regs + psp->vdata->inten_reg);
> -
> -	dev_notice(dev, "psp enabled\n");
> +	dev_notice(dev, "sev enabled\n");
>   
>   	return 0;
>   
>   e_irq:
> -	sp_free_psp_irq(psp->sp, psp);
> +	psp_clear_sev_irq_handler(psp);
>   e_err:
> -	sp->psp_data = NULL;
> +	psp->sev_data = NULL;
>   
> -	dev_notice(dev, "psp initialization failed\n");
> -
> -	return ret;
> -
> -e_disable:
> -	sp->psp_data = NULL;
> +	dev_notice(dev, "sev initialization failed\n");
>   
>   	return ret;
>   }
>   
> -void psp_dev_destroy(struct sp_device *sp)
> +void sev_dev_destroy(struct psp_device *psp)
>   {
> -	struct psp_device *psp = sp->psp_data;
> +	struct sev_device *sev = psp->sev_data;
>   
> -	if (!psp)
> +	if (!sev)
>   		return;
>   
> -	if (psp->sev_misc)
> +	if (sev->misc)
>   		kref_put(&misc_dev->refcount, sev_exit);
>   
> -	sp_free_psp_irq(sp, psp);
> +	psp_clear_sev_irq_handler(psp);
>   }
>   
>   int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
> @@ -1037,21 +973,18 @@ int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
>   	if (!filep || filep->f_op != &sev_fops)
>   		return -EBADF;
>   
> -	return  sev_do_cmd(cmd, data, error);
> +	return sev_do_cmd(cmd, data, error);
>   }
>   EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
>   
> -void psp_pci_init(void)
> +void sev_pci_init(void)
>   {
> -	struct sp_device *sp;
> +	struct sev_device *sev = psp_master->sev_data;
>   	int error, rc;
>   
> -	sp = sp_get_psp_master_device();
> -	if (!sp)
> +	if (!sev)
>   		return;
>   
> -	psp_master = sp->psp_data;
> -
>   	psp_timeout = psp_probe_timeout;
>   
>   	if (sev_get_api_version())
> @@ -1067,13 +1000,13 @@ void psp_pci_init(void)
>   	 * firmware in INIT or WORKING state.
>   	 */
>   
> -	if (psp_master->sev_state != SEV_STATE_UNINIT) {
> +	if (sev->state != SEV_STATE_UNINIT) {
>   		sev_platform_shutdown(NULL);
> -		psp_master->sev_state = SEV_STATE_UNINIT;
> +		sev->state = SEV_STATE_UNINIT;
>   	}
>   
>   	if (sev_version_greater_or_equal(0, 15) &&
> -	    sev_update_firmware(psp_master->dev) == 0)
> +	    sev_update_firmware(sev->dev) == 0)
>   		sev_get_api_version();
>   
>   	/* Initialize the platform */
> @@ -1086,27 +1019,27 @@ void psp_pci_init(void)
>   		 * failed and persistent state has been erased.
>   		 * Retrying INIT command here should succeed.
>   		 */
> -		dev_dbg(sp->dev, "SEV: retrying INIT command");
> +		dev_dbg(sev->dev, "SEV: retrying INIT command");
>   		rc = sev_platform_init(&error);
>   	}
>   
>   	if (rc) {
> -		dev_err(sp->dev, "SEV: failed to INIT error %#x\n", error);
> +		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
>   		return;
>   	}
>   
> -	dev_info(sp->dev, "SEV API:%d.%d build:%d\n", psp_master->api_major,
> -		 psp_master->api_minor, psp_master->build);
> +	dev_info(sev->dev, "SEV API:%d.%d build:%d\n", sev->api_major,
> +		 sev->api_minor, sev->build);
>   
>   	return;
>   
>   err:
> -	psp_master = NULL;
> +	psp_master->sev_data = NULL;
>   }
>   
> -void psp_pci_exit(void)
> +void sev_pci_exit(void)
>   {
> -	if (!psp_master)
> +	if (!psp_master->sev_data)
>   		return;
>   
>   	sev_platform_shutdown(NULL);
> diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
> index c178d9f..d54fce1 100644
> --- a/drivers/crypto/ccp/sev-dev.h
> +++ b/drivers/crypto/ccp/sev-dev.h
> @@ -24,37 +24,25 @@
>   #include <linux/psp-sev.h>
>   #include <linux/miscdevice.h>
>   
> -#include "sp-dev.h"
> -
> -#define PSP_CMD_COMPLETE		BIT(1)
> -
> -#define PSP_CMDRESP_CMD_SHIFT		16
> -#define PSP_CMDRESP_IOC			BIT(0)
> -#define PSP_CMDRESP_RESP		BIT(31)
> -#define PSP_CMDRESP_ERR_MASK		0xffff
> -
> -#define MAX_PSP_NAME_LEN		16
> +#define SEV_CMD_COMPLETE		BIT(1)
> +#define SEV_CMDRESP_CMD_SHIFT		16
> +#define SEV_CMDRESP_IOC			BIT(0)
>   
>   struct sev_misc_dev {
>   	struct kref refcount;
>   	struct miscdevice misc;
>   };
>   
> -struct psp_device {
> -	struct list_head entry;
> -
> -	struct psp_vdata *vdata;
> -	char name[MAX_PSP_NAME_LEN];
> -
> +struct sev_device {
>   	struct device *dev;
> -	struct sp_device *sp;
> +	struct psp_device *psp;
>   
>   	void __iomem *io_regs;
>   
> -	int sev_state;
> -	unsigned int sev_int_rcvd;
> -	wait_queue_head_t sev_int_queue;
> -	struct sev_misc_dev *sev_misc;
> +	int state;
> +	unsigned int int_rcvd;
> +	wait_queue_head_t int_queue;
> +	struct sev_misc_dev *misc;
>   	struct sev_user_data_status status_cmd_buf;
>   	struct sev_data_init init_cmd_buf;
>   
> @@ -63,4 +51,10 @@ struct psp_device {
>   	u8 build;
>   };
>   
> +int sev_dev_init(struct psp_device *psp);
> +void sev_dev_destroy(struct psp_device *psp);
> +
> +void sev_pci_init(void);
> +void sev_pci_exit(void);
> +
>   #endif /* __SEV_DEV_H */
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 473cf14..b29d2e6 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -22,7 +22,7 @@
>   #include <linux/ccp.h>
>   
>   #include "ccp-dev.h"
> -#include "sev-dev.h"
> +#include "psp-dev.h"
>   
>   #define MSIX_VECTORS			2
>   
> 

