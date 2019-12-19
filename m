Return-Path: <SRS0=xTm+=2J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2BAC43603
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 22:58:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F2342467B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Dec 2019 22:58:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="g7B8CJh4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfLSW56 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Dec 2019 17:57:58 -0500
Received: from mail-co1nam11on2063.outbound.protection.outlook.com ([40.107.220.63]:20304
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726930AbfLSW55 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Dec 2019 17:57:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlGxoOBOFN4ZkO0S00lvFuIufm+leEJmil6yUUb+1yPzCSuLyeHisjxBig8pCTuWfrQ9R7jhjrWnGJTaI2OcOYh9un8IzxOhl34Y2UHPrq0fKpvSSk2o9lAkUFBQ06j5p43iXLBz8URY4Mn60k71bInl9g4VNC1wYw0s9ub97gQliPDlBJtPM9QTPDZkO3TwIL4AZTTxeRV8xcOl7r9EkQH5HfYABuQTRwwqmwf6bxMgECDUOlakrVQVkLb6AgJr0h3c6OzYq4mx4a/emwibf9WC/2atqu3zaxldOrnn6CTPliDvn+OSX8UQwnUeGpz+Z2adZq89ue4JsdhtWxpwNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWazoTWzKq5G3xbtzjl3fMdegmPzcKk6goKZ3kJ5NWo=;
 b=FrDpzu0EdKzi1CtQj59b/zYpb5a+hde5kWB9zINtZuCEtfpFiHPd5mus08UD294htG5v8LTZY/ud34/oA58MhqiyNzwOBIf75G8s1vzx9wKvdLzURD3q32sK5J0AItTiQaP11TvzWHX7j83d5vVux/J3HwyaKW3tJIZh9ui5rEgV1ri9YtTV/4Urjs8dQhHSl8kkdnTbVfzeJvgoZJtxTB5/LY3FqrQm69OMVItGT0WWgaXmnojGtTztcvl3UBLEZZYsmtX4IRs+OCupLvF1sShETpv7LqsNYfAycn6oGOYpQrqHDimIxr3xE/1rNSaonKzI7g6oXXRRR8vnpcSj/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWazoTWzKq5G3xbtzjl3fMdegmPzcKk6goKZ3kJ5NWo=;
 b=g7B8CJh4x0Jo50jUqG/nTcLBSP8YDyE4clv8hljck80t3xZoopS+FcTppDc/9/M67y1socrhbNERr2kJepMFrFTgMjaUYTIZVGsqGiYO7fl503zfvttkk9XY3GSxI1qNcKYrzZwjIn/5bvZM1+lK774lZbtXmckJ306J/70yVsk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB2421.namprd12.prod.outlook.com (52.132.141.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Thu, 19 Dec 2019 22:57:30 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::6d85:d029:53c0:ba61%5]) with mapi id 15.20.2538.019; Thu, 19 Dec 2019
 22:57:30 +0000
Subject: Re: [RFC PATCH v3 6/6] crypto: ccp - provide in-kernel API to submit
 TEE commands
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
 <8bde26314458954e1f229f5c737063692744a6cc.1575438845.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <gary.hook@amd.com>
Message-ID: <992a572f-e25a-2bab-38c3-ed1ce0b69e17@amd.com>
Date:   Thu, 19 Dec 2019 16:57:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <8bde26314458954e1f229f5c737063692744a6cc.1575438845.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0050.prod.exchangelabs.com (2603:10b6:800::18) To
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
MIME-Version: 1.0
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 53f8003b-7783-42d5-4cd7-08d784d6d373
X-MS-TrafficTypeDiagnostic: DM5PR12MB2421:|DM5PR12MB2421:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB2421344C28FEB93D8AA8E4F9FD520@DM5PR12MB2421.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-Forefront-PRVS: 0256C18696
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(189003)(199004)(31686004)(8936002)(81166006)(5660300002)(66946007)(86362001)(110136005)(54906003)(53546011)(186003)(478600001)(52116002)(26005)(81156014)(6506007)(8676002)(36756003)(316002)(4326008)(2616005)(66476007)(31696002)(2906002)(66556008)(6512007)(6486002)(134885004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB2421;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6RRBPYthdSdtYvJxHYEIf351K/I4oZeLzrTp40yHU7jQ5mzB/JJiNhEg3epQPPq3r8HMCbsc6nur9UrONi8zRJ13Ech1LRuTHjotyu2OIKs3a9iM/pLP5nYv95LpNmYXiicdKjlFWksbwJ7lti3IvCB+/OLvION9j0U3tX1LoC2Oq3JKzykw92I3HQY3SfY7h3QIyQHS27gzwX0xeo5hbrtZwjc4E9mOkxlBFNMEBTXzEco7L3UU35omhXvq++UuHOIDhD+Dz0diYPt8jI4PHBL5oOBOhxCMEdoCcOKwuVGyZBotxt+yIv7ayocr0FUbR6r7yCEHy2h4m/PJT5/H7pS5Dk0rE/ZOWoq6huS3D3HWG2eMfULaUHvn3xKlAuyg1acQvgl5S14he2kE8xhzXdXPR/+FJ2rToSYw0/TMdION4K4RrMzuhfm64OdkNk5PFP5DDFdaBiSA48A9ZExYJa2gXo3Vr1DEHTOJFzcCjru4t0IRxVky2iXEPx4YYoKs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f8003b-7783-42d5-4cd7-08d784d6d373
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2019 22:57:30.4749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBq/8Qpt+lNx/kXHFlVjDbRTW7xcUAFMVV7XjL1PeC/hugwN0nYHe0rReHWRPcVE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2421
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/4/19 12:19 AM, Rijo Thomas wrote:
> Extend the functionality of AMD Secure Processor (SP) driver by
> providing an in-kernel API to submit commands to TEE ring buffer for
> processing by Trusted OS running on AMD Secure Processor.
> 
> Following TEE commands are supported by Trusted OS:
> 
> * TEE_CMD_ID_LOAD_TA : Load Trusted Application (TA) binary into
>    TEE environment
> * TEE_CMD_ID_UNLOAD_TA : Unload TA binary from TEE environment
> * TEE_CMD_ID_OPEN_SESSION : Open session with loaded TA
> * TEE_CMD_ID_CLOSE_SESSION : Close session with loaded TA
> * TEE_CMD_ID_INVOKE_CMD : Invoke a command with loaded TA
> * TEE_CMD_ID_MAP_SHARED_MEM : Map shared memory
> * TEE_CMD_ID_UNMAP_SHARED_MEM : Unmap shared memory
> 
> Linux AMD-TEE driver will use this API to submit command buffers
> for processing in Trusted Execution Environment. The AMD-TEE driver
> shall be introduced in a separate patch.
> 
> Cc: Jens Wiklander <jens.wiklander@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/crypto/ccp/tee-dev.c | 126 +++++++++++++++++++++++++++++++++++++++++++
>   drivers/crypto/ccp/tee-dev.h |   1 +
>   include/linux/psp-tee.h      |  73 +++++++++++++++++++++++++
>   3 files changed, 200 insertions(+)
>   create mode 100644 include/linux/psp-tee.h
> 
> diff --git a/drivers/crypto/ccp/tee-dev.c b/drivers/crypto/ccp/tee-dev.c
> index ccbc2ce..555c8a7 100644
> --- a/drivers/crypto/ccp/tee-dev.c
> +++ b/drivers/crypto/ccp/tee-dev.c
> @@ -14,6 +14,7 @@
>   #include <linux/slab.h>
>   #include <linux/gfp.h>
>   #include <linux/psp-sev.h>
> +#include <linux/psp-tee.h>
>   
>   #include "psp-dev.h"
>   #include "tee-dev.h"
> @@ -38,6 +39,7 @@ static int tee_alloc_ring(struct psp_tee_device *tee, int ring_size)
>   	rb_mgr->ring_start = start_addr;
>   	rb_mgr->ring_size = ring_size;
>   	rb_mgr->ring_pa = __psp_pa(start_addr);
> +	mutex_init(&rb_mgr->mutex);
>   
>   	return 0;
>   }
> @@ -55,6 +57,7 @@ static void tee_free_ring(struct psp_tee_device *tee)
>   	rb_mgr->ring_start = NULL;
>   	rb_mgr->ring_size = 0;
>   	rb_mgr->ring_pa = 0;
> +	mutex_destroy(&rb_mgr->mutex);
>   }
>   
>   static int tee_wait_cmd_poll(struct psp_tee_device *tee, unsigned int timeout,
> @@ -236,3 +239,126 @@ void tee_dev_destroy(struct psp_device *psp)
>   
>   	tee_destroy_ring(tee);
>   }
> +
> +static int tee_submit_cmd(struct psp_tee_device *tee, enum tee_cmd_id cmd_id,
> +			  void *buf, size_t len, struct tee_ring_cmd **resp)
> +{
> +	struct tee_ring_cmd *cmd;
> +	u32 rptr, wptr;
> +	int nloop = 1000, ret = 0;
> +
> +	*resp = NULL;
> +
> +	mutex_lock(&tee->rb_mgr.mutex);
> +
> +	wptr = tee->rb_mgr.wptr;
> +
> +	/* Check if ring buffer is full */
> +	do {
> +		rptr = ioread32(tee->io_regs + tee->vdata->ring_rptr_reg);
> +
> +		if (!(wptr + sizeof(struct tee_ring_cmd) == rptr))
> +			break;
> +
> +		dev_info(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
> +			 rptr, wptr);
> +
> +		/* Wait if ring buffer is full */
> +		mutex_unlock(&tee->rb_mgr.mutex);
> +		schedule_timeout_interruptible(msecs_to_jiffies(10));
> +		mutex_lock(&tee->rb_mgr.mutex);
> +
> +	} while (--nloop);
> +
> +	if (!nloop && (wptr + sizeof(struct tee_ring_cmd) == rptr)) {
> +		dev_err(tee->dev, "tee: ring buffer full. rptr = %u wptr = %u\n",
> +			rptr, wptr);
> +		ret = -EBUSY;
> +		goto unlock;
> +	}
> +
> +	/* Pointer to empty data entry in ring buffer */
> +	cmd = (struct tee_ring_cmd *)(tee->rb_mgr.ring_start + wptr);
> +
> +	/* Write command data into ring buffer */
> +	cmd->cmd_id = cmd_id;
> +	cmd->cmd_state = TEE_CMD_STATE_INIT;
> +	memset(&cmd->buf[0], 0, sizeof(cmd->buf));
> +	memcpy(&cmd->buf[0], buf, len);
> +
> +	/* Update local copy of write pointer */
> +	tee->rb_mgr.wptr += sizeof(struct tee_ring_cmd);
> +	if (tee->rb_mgr.wptr >= tee->rb_mgr.ring_size)
> +		tee->rb_mgr.wptr = 0;
> +
> +	/* Trigger interrupt to Trusted OS */
> +	iowrite32(tee->rb_mgr.wptr, tee->io_regs + tee->vdata->ring_wptr_reg);
> +
> +	/* The response is provided by Trusted OS in same
> +	 * location as submitted data entry within ring buffer.
> +	 */
> +	*resp = cmd;
> +
> +unlock:
> +	mutex_unlock(&tee->rb_mgr.mutex);
> +
> +	return ret;
> +}
> +
> +static int tee_wait_cmd_completion(struct psp_tee_device *tee,
> +				   struct tee_ring_cmd *resp,
> +				   unsigned int timeout)
> +{
> +	/* ~5ms sleep per loop => nloop = timeout * 200 */
> +	int nloop = timeout * 200;
> +
> +	while (--nloop) {
> +		if (resp->cmd_state == TEE_CMD_STATE_COMPLETED)
> +			return 0;
> +
> +		usleep_range(5000, 5100);
> +	}
> +
> +	dev_err(tee->dev, "tee: command 0x%x timed out, disabling PSP\n",
> +		resp->cmd_id);
> +
> +	psp_dead = true;
> +
> +	return -ETIMEDOUT;
> +}
> +
> +int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
> +			u32 *status)
> +{
> +	struct psp_device *psp = psp_get_master_device();
> +	struct psp_tee_device *tee;
> +	struct tee_ring_cmd *resp;
> +	int ret;
> +
> +	if (!buf || !status || !len || len > sizeof(resp->buf))
> +		return -EINVAL;
> +
> +	*status = 0;
> +
> +	if (!psp || !psp->tee_data)
> +		return -ENODEV;
> +
> +	if (psp_dead)
> +		return -EBUSY;
> +
> +	tee = psp->tee_data;
> +
> +	ret = tee_submit_cmd(tee, cmd_id, buf, len, &resp);
> +	if (ret)
> +		return ret;
> +
> +	ret = tee_wait_cmd_completion(tee, resp, TEE_DEFAULT_TIMEOUT);
> +	if (ret)
> +		return ret;
> +
> +	memcpy(buf, &resp->buf[0], len);
> +	*status = resp->status;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(psp_tee_process_cmd);
> diff --git a/drivers/crypto/ccp/tee-dev.h b/drivers/crypto/ccp/tee-dev.h
> index b3db0fc..f099601 100644
> --- a/drivers/crypto/ccp/tee-dev.h
> +++ b/drivers/crypto/ccp/tee-dev.h
> @@ -54,6 +54,7 @@ struct tee_init_ring_cmd {
>    * @wptr:        index to the last written entry in ring buffer
>    */
>   struct ring_buf_manager {
> +	struct mutex mutex;	/* synchronizes access to ring buffer */
>   	void *ring_start;
>   	u32 ring_size;
>   	phys_addr_t ring_pa;
> diff --git a/include/linux/psp-tee.h b/include/linux/psp-tee.h
> new file mode 100644
> index 0000000..63bb221
> --- /dev/null
> +++ b/include/linux/psp-tee.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * AMD Trusted Execution Environment (TEE) interface
> + *
> + * Author: Rijo Thomas <Rijo-john.Thomas@amd.com>
> + *
> + * Copyright 2019 Advanced Micro Devices, Inc.
> + *
> + */
> +
> +#ifndef __PSP_TEE_H_
> +#define __PSP_TEE_H_
> +
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +
> +/* This file defines the Trusted Execution Environment (TEE) interface commands
> + * and the API exported by AMD Secure Processor driver to communicate with
> + * AMD-TEE Trusted OS.
> + */
> +
> +/**
> + * enum tee_cmd_id - TEE Interface Command IDs
> + * @TEE_CMD_ID_LOAD_TA:          Load Trusted Application (TA) binary into
> + *                               TEE environment
> + * @TEE_CMD_ID_UNLOAD_TA:        Unload TA binary from TEE environment
> + * @TEE_CMD_ID_OPEN_SESSION:     Open session with loaded TA
> + * @TEE_CMD_ID_CLOSE_SESSION:    Close session with loaded TA
> + * @TEE_CMD_ID_INVOKE_CMD:       Invoke a command with loaded TA
> + * @TEE_CMD_ID_MAP_SHARED_MEM:   Map shared memory
> + * @TEE_CMD_ID_UNMAP_SHARED_MEM: Unmap shared memory
> + */
> +enum tee_cmd_id {
> +	TEE_CMD_ID_LOAD_TA = 1,
> +	TEE_CMD_ID_UNLOAD_TA,
> +	TEE_CMD_ID_OPEN_SESSION,
> +	TEE_CMD_ID_CLOSE_SESSION,
> +	TEE_CMD_ID_INVOKE_CMD,
> +	TEE_CMD_ID_MAP_SHARED_MEM,
> +	TEE_CMD_ID_UNMAP_SHARED_MEM,
> +};
> +
> +#ifdef CONFIG_CRYPTO_DEV_SP_PSP
> +/**
> + * psp_tee_process_cmd() - Process command in Trusted Execution Environment
> + * @cmd_id:     TEE command ID (&enum tee_cmd_id)
> + * @buf:        Command buffer for TEE processing. On success, is updated
> + *              with the response
> + * @len:        Length of command buffer in bytes
> + * @status:     On success, holds the TEE command execution status
> + *
> + * This function submits a command to the Trusted OS for processing in the
> + * TEE environment and waits for a response or until the command times out.
> + *
> + * Returns:
> + * 0 if TEE successfully processed the command
> + * -%ENODEV    if PSP device not available
> + * -%EINVAL    if invalid input
> + * -%ETIMEDOUT if TEE command timed out
> + * -%EBUSY     if PSP device is not responsive
> + */
> +int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf, size_t len,
> +			u32 *status);
> +
> +#else /* !CONFIG_CRYPTO_DEV_SP_PSP */
> +
> +static inline int psp_tee_process_cmd(enum tee_cmd_id cmd_id, void *buf,
> +				      size_t len, u32 *status)
> +{
> +	return -ENODEV;
> +}
> +#endif /* CONFIG_CRYPTO_DEV_SP_PSP */
> +#endif /* __PSP_TEE_H_ */
> 

