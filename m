Return-Path: <SRS0=+KeW=2R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01E0C2D0C6
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 18:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A012A206CB
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Dec 2019 18:37:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amdcloud.onmicrosoft.com header.i=@amdcloud.onmicrosoft.com header.b="DsdJhdfS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfL0Shy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Dec 2019 13:37:54 -0500
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:55427
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726379AbfL0Shx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Dec 2019 13:37:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HoufFeJJfSeN2UF0eJUo0G/4TYVbFKmuwRs4K+szfQZdu/tsMgS7XpbbfkZsH8PBG37cR+Nj6lQVuqcH1z+OcGdQdrIMCrtBTMe0jelA3ENe671uWxTAjdQmEDNfVZqQ45WQp2Bj9gM7Q535Y2p0Kk54rAQjo0uW9miI6B7Uq/vR5vxwN8qjSarC9zHSy26Aixi9XKiTjStEKmEao8FXLNo4DgS0HbVx2anKtq3iEs/F+MAv+VIn915SOvFUMFYrIvPO98NkHiGqQxWADsxVnGKi8HCB0Yy7YbEef85a7ix9nP2FzC+yTnJ445mcRSk51QF67u07qcabMqVFbot50Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sui7mQ7DCiAn2IOo4j4Jk6Cr7yVWPoV3sq2ka3+t6js=;
 b=Wpg2+8xip2IVOuHiRHkzfh2uqNuS5tIcyeulG6JaZ1S7Uj9wuab+dEjnpbHdSvmne2fnO703OTHPmsGF43+6FGruyUh9/ZmbZ48QgnvcZcEySKo65x49lU6QXBdA54IGa3t7d/nHnSVAYSFDSZpp88QCan5fBT8vW0NVj3nVE28ZQ/aqzW7bJthCJba4rJPo9MdKVDIGPOLCbUMYznxtfGrvU07zZ1FUUzbTAiBBplNPha6H7F+o6h2dSWi1IHPZ7E86bU6SGuPiWWagJarIv8x5YYn3YfK+hWpVtUigFj7Ax9bsWGtZIFT1tGFgqCFJTkCAaPGTNOcEJR08Jr5NfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sui7mQ7DCiAn2IOo4j4Jk6Cr7yVWPoV3sq2ka3+t6js=;
 b=DsdJhdfS3cbD2p4DFEcc5kAsk7LRBNU34OKbUqs/zAHGj4D++OPJlvDJL34nn/9JsyWBFQsvgI8mvb84b5G6yDdqJmxfXpt9C+8aV0Ntk4wcB24cl4xlPQsA2GplLmqNYB+PYxJNqoi1LgwPCtXPoqPaRIIgsH45Oa9Fss8fEzk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from BN8PR12MB2916.namprd12.prod.outlook.com (20.179.66.155) by
 BN8PR12MB3217.namprd12.prod.outlook.com (20.179.67.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 18:37:40 +0000
Received: from BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029]) by BN8PR12MB2916.namprd12.prod.outlook.com
 ([fe80::45d0:ec5c:7480:8029%5]) with mapi id 15.20.2559.017; Fri, 27 Dec 2019
 18:37:40 +0000
Subject: Re: [PATCH 2/4] tee: add AMD-TEE driver
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tee-dev@lists.linaro.org
Cc:     Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>
References: <cover.1577423898.git.Rijo-john.Thomas@amd.com>
 <e1942aaa4a49a1b616d912f6b656af4fa4b9dec3.1577423898.git.Rijo-john.Thomas@amd.com>
From:   Gary R Hook <ghook@amd.com>
Message-ID: <34d68f53-b15e-a0d4-fb93-ca4d9ab291b1@amd.com>
Date:   Fri, 27 Dec 2019 12:37:38 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
In-Reply-To: <e1942aaa4a49a1b616d912f6b656af4fa4b9dec3.1577423898.git.Rijo-john.Thomas@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0701CA0014.namprd07.prod.outlook.com
 (2603:10b6:803:28::24) To BN8PR12MB2916.namprd12.prod.outlook.com
 (2603:10b6:408:6a::27)
MIME-Version: 1.0
Received: from [4.3.2.105] (47.220.193.178) by SN4PR0701CA0014.namprd07.prod.outlook.com (2603:10b6:803:28::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 18:37:39 +0000
X-Originating-IP: [47.220.193.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d93f8c45-c547-42a5-d70c-08d78afbda38
X-MS-TrafficTypeDiagnostic: BN8PR12MB3217:|BN8PR12MB3217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR12MB32175CD7857A8478AC5DD00AFD2A0@BN8PR12MB3217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:260;
X-Forefront-PRVS: 0264FEA5C3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(189003)(199004)(66946007)(66556008)(66476007)(110136005)(16576012)(54906003)(956004)(6706004)(6486002)(478600001)(4326008)(52116002)(30864003)(186003)(2616005)(31696002)(5660300002)(8936002)(2906002)(81166006)(36756003)(8676002)(81156014)(316002)(26005)(53546011)(31686004)(16526019)(78286006)(84106002)(579004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR12MB3217;H:BN8PR12MB2916.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rv37Q8OfyNbjhBKx19zmDRgTPAcpEGYoFjf0fLDBjNL4AyM41sOjxos0604RYWVrGIebd54DPTSY8IdsH6OLhs1VZS7NMX0qYmXQyVMfmh7uemmWZt0Qy7j7vurrzZKdk9lfFY7YYNZNK93XH0GaoKiOCIvzEUgC56bTVEC8C4qu4mA3DM37/thwvWuEDD10GneZbAP0AMBhvC//EoCxvqt2ooFZPMDmrt3RrdgZKs9ZQySPv81ixAhgy7da3NyXtiRL9Pl24EYJ/6SqoZwSQ1HTQk0XykNyePfL0JvX4/O1G2GUVZK0gFbaDD6/VWJQiHGta5N6B4zxDz6w+BtgwKjPKTaXDqH/aCUU3WxsQiUMRAYje9U6vX7d5Vuqpa8N4oieWE7aw8rZSPdoavTiafINF29LWOgChKFcXoP0I/+L1RdqFRSe0LxMcxC1GzxqvxRwi27m0DiNs3IHx2sSgOWSJTefPFV6iHpiarxwLWAVM45M+97RoMabnsEQnXI0c9C7BQeJ38+1Yj3fdr2ufQ==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93f8c45-c547-42a5-d70c-08d78afbda38
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2019 18:37:40.1915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: va+Ri9I8EjwcaSlWsKCSTuKYC3htmbo3Nqazcr+xUF0wgnMv2CCDm+Ry0N7w9zu4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3217
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 12/26/19 11:24 PM, Rijo Thomas wrote:
> Adds AMD-TEE driver.
> * targets AMD APUs which has AMD Secure Processor with software-based
>    Trusted Execution Environment (TEE) support
> * registers with TEE subsystem
> * defines tee_driver_ops function callbacks
> * kernel allocated memory is used as shared memory between normal
>    world and secure world.
> * acts as REE (Rich Execution Environment) communication agent, which
>    uses the services of AMD Secure Processor driver to submit commands
>    for processing in TEE environment
> 
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Acked-by: Jens Wiklander <jens.wiklander@linaro.org>
> Co-developed-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> Signed-off-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

Reviewed-by: Gary R Hook <gary.hook@amd.com>

> ---
>   drivers/tee/Kconfig                 |   2 +-
>   drivers/tee/Makefile                |   1 +
>   drivers/tee/amdtee/Kconfig          |   8 +
>   drivers/tee/amdtee/Makefile         |   5 +
>   drivers/tee/amdtee/amdtee_if.h      | 183 +++++++++++++
>   drivers/tee/amdtee/amdtee_private.h | 159 +++++++++++
>   drivers/tee/amdtee/call.c           | 373 ++++++++++++++++++++++++++
>   drivers/tee/amdtee/core.c           | 510 ++++++++++++++++++++++++++++++++++++
>   drivers/tee/amdtee/shm_pool.c       |  93 +++++++
>   include/uapi/linux/tee.h            |   1 +
>   10 files changed, 1334 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/tee/amdtee/Kconfig
>   create mode 100644 drivers/tee/amdtee/Makefile
>   create mode 100644 drivers/tee/amdtee/amdtee_if.h
>   create mode 100644 drivers/tee/amdtee/amdtee_private.h
>   create mode 100644 drivers/tee/amdtee/call.c
>   create mode 100644 drivers/tee/amdtee/core.c
>   create mode 100644 drivers/tee/amdtee/shm_pool.c
> 
> diff --git a/drivers/tee/Kconfig b/drivers/tee/Kconfig
> index 4f3197d..8da63f3 100644
> --- a/drivers/tee/Kconfig
> +++ b/drivers/tee/Kconfig
> @@ -14,7 +14,7 @@ if TEE
>   menu "TEE drivers"
>   
>   source "drivers/tee/optee/Kconfig"
> -
> +source "drivers/tee/amdtee/Kconfig"
>   endmenu
>   
>   endif
> diff --git a/drivers/tee/Makefile b/drivers/tee/Makefile
> index 21f51fd..68da044 100644
> --- a/drivers/tee/Makefile
> +++ b/drivers/tee/Makefile
> @@ -4,3 +4,4 @@ tee-objs += tee_core.o
>   tee-objs += tee_shm.o
>   tee-objs += tee_shm_pool.o
>   obj-$(CONFIG_OPTEE) += optee/
> +obj-$(CONFIG_AMDTEE) += amdtee/
> diff --git a/drivers/tee/amdtee/Kconfig b/drivers/tee/amdtee/Kconfig
> new file mode 100644
> index 0000000..4e32b64
> --- /dev/null
> +++ b/drivers/tee/amdtee/Kconfig
> @@ -0,0 +1,8 @@
> +# SPDX-License-Identifier: MIT
> +# AMD-TEE Trusted Execution Environment Configuration
> +config AMDTEE
> +	tristate "AMD-TEE"
> +	default m
> +	depends on CRYPTO_DEV_SP_PSP
> +	help
> +	  This implements AMD's Trusted Execution Environment (TEE) driver.
> diff --git a/drivers/tee/amdtee/Makefile b/drivers/tee/amdtee/Makefile
> new file mode 100644
> index 0000000..ff14852
> --- /dev/null
> +++ b/drivers/tee/amdtee/Makefile
> @@ -0,0 +1,5 @@
> +# SPDX-License-Identifier: MIT
> +obj-$(CONFIG_AMDTEE) += amdtee.o
> +amdtee-objs += core.o
> +amdtee-objs += call.o
> +amdtee-objs += shm_pool.o
> diff --git a/drivers/tee/amdtee/amdtee_if.h b/drivers/tee/amdtee/amdtee_if.h
> new file mode 100644
> index 0000000..ff48c3e
> --- /dev/null
> +++ b/drivers/tee/amdtee/amdtee_if.h
> @@ -0,0 +1,183 @@
> +/* SPDX-License-Identifier: MIT */
> +
> +/*
> + * Copyright 2019 Advanced Micro Devices, Inc.
> + */
> +
> +/*
> + * This file has definitions related to Host and AMD-TEE Trusted OS interface.
> + * These definitions must match the definitions on the TEE side.
> + */
> +
> +#ifndef AMDTEE_IF_H
> +#define AMDTEE_IF_H
> +
> +#include <linux/types.h>
> +
> +/*****************************************************************************
> + ** TEE Param
> + ******************************************************************************/
> +#define TEE_MAX_PARAMS		4
> +
> +/**
> + * struct memref - memory reference structure
> + * @buf_id:    buffer ID of the buffer mapped by TEE_CMD_ID_MAP_SHARED_MEM
> + * @offset:    offset in bytes from beginning of the buffer
> + * @size:      data size in bytes
> + */
> +struct memref {
> +	u32 buf_id;
> +	u32 offset;
> +	u32 size;
> +};
> +
> +struct value {
> +	u32 a;
> +	u32 b;
> +};
> +
> +/*
> + * Parameters passed to open_session or invoke_command
> + */
> +union tee_op_param {
> +	struct memref mref;
> +	struct value val;
> +};
> +
> +struct tee_operation {
> +	u32 param_types;
> +	union tee_op_param params[TEE_MAX_PARAMS];
> +};
> +
> +/* Must be same as in GP TEE specification */
> +#define TEE_OP_PARAM_TYPE_NONE                  0
> +#define TEE_OP_PARAM_TYPE_VALUE_INPUT           1
> +#define TEE_OP_PARAM_TYPE_VALUE_OUTPUT          2
> +#define TEE_OP_PARAM_TYPE_VALUE_INOUT           3
> +#define TEE_OP_PARAM_TYPE_INVALID               4
> +#define TEE_OP_PARAM_TYPE_MEMREF_INPUT          5
> +#define TEE_OP_PARAM_TYPE_MEMREF_OUTPUT         6
> +#define TEE_OP_PARAM_TYPE_MEMREF_INOUT          7
> +
> +#define TEE_PARAM_TYPE_GET(t, i)        (((t) >> ((i) * 4)) & 0xF)
> +#define TEE_PARAM_TYPES(t0, t1, t2, t3) \
> +	((t0) | ((t1) << 4) | ((t2) << 8) | ((t3) << 12))
> +
> +/*****************************************************************************
> + ** TEE Commands
> + *****************************************************************************/
> +
> +/*
> + * The shared memory between rich world and secure world may be physically
> + * non-contiguous. Below structures are meant to describe a shared memory region
> + * via scatter/gather (sg) list
> + */
> +
> +/**
> + * struct tee_sg_desc - sg descriptor for a physically contiguous buffer
> + * @low_addr: [in] bits[31:0] of buffer's physical address. Must be 4KB aligned
> + * @hi_addr:  [in] bits[63:32] of the buffer's physical address
> + * @size:     [in] size in bytes (must be multiple of 4KB)
> + */
> +struct tee_sg_desc {
> +	u32 low_addr;
> +	u32 hi_addr;
> +	u32 size;
> +};
> +
> +/**
> + * struct tee_sg_list - structure describing a scatter/gather list
> + * @count:   [in] number of sg descriptors
> + * @size:    [in] total size of all buffers in the list. Must be multiple of 4KB
> + * @buf:     [in] list of sg buffer descriptors
> + */
> +#define TEE_MAX_SG_DESC 64
> +struct tee_sg_list {
> +	u32 count;
> +	u32 size;
> +	struct tee_sg_desc buf[TEE_MAX_SG_DESC];
> +};
> +
> +/**
> + * struct tee_cmd_map_shared_mem - command to map shared memory
> + * @buf_id:    [out] return buffer ID value
> + * @sg_list:   [in] list describing memory to be mapped
> + */
> +struct tee_cmd_map_shared_mem {
> +	u32 buf_id;
> +	struct tee_sg_list sg_list;
> +};
> +
> +/**
> + * struct tee_cmd_unmap_shared_mem - command to unmap shared memory
> + * @buf_id:    [in] buffer ID of memory to be unmapped
> + */
> +struct tee_cmd_unmap_shared_mem {
> +	u32 buf_id;
> +};
> +
> +/**
> + * struct tee_cmd_load_ta - load Trusted Application (TA) binary into TEE
> + * @low_addr:    [in] bits [31:0] of the physical address of the TA binary
> + * @hi_addr:     [in] bits [63:32] of the physical address of the TA binary
> + * @size:        [in] size of TA binary in bytes
> + * @ta_handle:   [out] return handle of the loaded TA
> + */
> +struct tee_cmd_load_ta {
> +	u32 low_addr;
> +	u32 hi_addr;
> +	u32 size;
> +	u32 ta_handle;
> +};
> +
> +/**
> + * struct tee_cmd_unload_ta - command to unload TA binary from TEE environment
> + * @ta_handle:    [in] handle of the loaded TA to be unloaded
> + */
> +struct tee_cmd_unload_ta {
> +	u32 ta_handle;
> +};
> +
> +/**
> + * struct tee_cmd_open_session - command to call TA_OpenSessionEntryPoint in TA
> + * @ta_handle:      [in] handle of the loaded TA
> + * @session_info:   [out] pointer to TA allocated session data
> + * @op:             [in/out] operation parameters
> + * @return_origin:  [out] origin of return code after TEE processing
> + */
> +struct tee_cmd_open_session {
> +	u32 ta_handle;
> +	u32 session_info;
> +	struct tee_operation op;
> +	u32 return_origin;
> +};
> +
> +/**
> + * struct tee_cmd_close_session - command to call TA_CloseSessionEntryPoint()
> + *                                in TA
> + * @ta_handle:      [in] handle of the loaded TA
> + * @session_info:   [in] pointer to TA allocated session data
> + */
> +struct tee_cmd_close_session {
> +	u32 ta_handle;
> +	u32 session_info;
> +};
> +
> +/**
> + * struct tee_cmd_invoke_cmd - command to call TA_InvokeCommandEntryPoint() in
> + *                             TA
> + * @ta_handle:     [in] handle of the loaded TA
> + * @cmd_id:        [in] TA command ID
> + * @session_info:  [in] pointer to TA allocated session data
> + * @op:            [in/out] operation parameters
> + * @return_origin: [out] origin of return code after TEE processing
> + */
> +struct tee_cmd_invoke_cmd {
> +	u32 ta_handle;
> +	u32 cmd_id;
> +	u32 session_info;
> +	struct tee_operation op;
> +	u32 return_origin;
> +};
> +
> +#endif /*AMDTEE_IF_H*/
> diff --git a/drivers/tee/amdtee/amdtee_private.h b/drivers/tee/amdtee/amdtee_private.h
> new file mode 100644
> index 0000000..d7f798c
> --- /dev/null
> +++ b/drivers/tee/amdtee/amdtee_private.h
> @@ -0,0 +1,159 @@
> +/* SPDX-License-Identifier: MIT */
> +
> +/*
> + * Copyright 2019 Advanced Micro Devices, Inc.
> + */
> +
> +#ifndef AMDTEE_PRIVATE_H
> +#define AMDTEE_PRIVATE_H
> +
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/tee_drv.h>
> +#include <linux/kref.h>
> +#include <linux/types.h>
> +#include "amdtee_if.h"
> +
> +#define DRIVER_NAME	"amdtee"
> +#define DRIVER_AUTHOR   "AMD-TEE Linux driver team"
> +
> +/* Some GlobalPlatform error codes used in this driver */
> +#define TEEC_SUCCESS			0x00000000
> +#define TEEC_ERROR_GENERIC		0xFFFF0000
> +#define TEEC_ERROR_BAD_PARAMETERS	0xFFFF0006
> +#define TEEC_ERROR_COMMUNICATION	0xFFFF000E
> +
> +#define TEEC_ORIGIN_COMMS		0x00000002
> +
> +/* Maximum number of sessions which can be opened with a Trusted Application */
> +#define TEE_NUM_SESSIONS			32
> +
> +#define TA_LOAD_PATH				"/amdtee"
> +#define TA_PATH_MAX				60
> +
> +/**
> + * struct amdtee - main service struct
> + * @teedev:		client device
> + * @pool:		shared memory pool
> + */
> +struct amdtee {
> +	struct tee_device *teedev;
> +	struct tee_shm_pool *pool;
> +};
> +
> +/**
> + * struct amdtee_session - Trusted Application (TA) session related information.
> + * @ta_handle:     handle to Trusted Application (TA) loaded in TEE environment
> + * @refcount:      counter to keep track of sessions opened for the TA instance
> + * @session_info:  an array pointing to TA allocated session data.
> + * @sess_mask:     session usage bit-mask. If a particular bit is set, then the
> + *                 corresponding @session_info entry is in use or valid.
> + *
> + * Session structure is updated on open_session and this information is used for
> + * subsequent operations with the Trusted Application.
> + */
> +struct amdtee_session {
> +	struct list_head list_node;
> +	u32 ta_handle;
> +	struct kref refcount;
> +	u32 session_info[TEE_NUM_SESSIONS];
> +	DECLARE_BITMAP(sess_mask, TEE_NUM_SESSIONS);
> +	spinlock_t lock;	/* synchronizes access to @sess_mask */
> +};
> +
> +/**
> + * struct amdtee_context_data - AMD-TEE driver context data
> + * @sess_list:    Keeps track of sessions opened in current TEE context
> + */
> +struct amdtee_context_data {
> +	struct list_head sess_list;
> +};
> +
> +struct amdtee_driver_data {
> +	struct amdtee *amdtee;
> +};
> +
> +struct shmem_desc {
> +	void *kaddr;
> +	u64 size;
> +};
> +
> +/**
> + * struct amdtee_shm_data - Shared memory data
> + * @kaddr:	Kernel virtual address of shared memory
> + * @buf_id:	Buffer id of memory mapped by TEE_CMD_ID_MAP_SHARED_MEM
> + */
> +struct amdtee_shm_data {
> +	struct  list_head shm_node;
> +	void    *kaddr;
> +	u32     buf_id;
> +};
> +
> +struct amdtee_shm_context {
> +	struct list_head shmdata_list;
> +};
> +
> +#define LOWER_TWO_BYTE_MASK	0x0000FFFF
> +
> +/**
> + * set_session_id() - Sets the session identifier.
> + * @ta_handle:      [in] handle of the loaded Trusted Application (TA)
> + * @session_index:  [in] Session index. Range: 0 to (TEE_NUM_SESSIONS - 1).
> + * @session:        [out] Pointer to session id
> + *
> + * Lower two bytes of the session identifier represents the TA handle and the
> + * upper two bytes is session index.
> + */
> +static inline void set_session_id(u32 ta_handle, u32 session_index,
> +				  u32 *session)
> +{
> +	*session = (session_index << 16) | (LOWER_TWO_BYTE_MASK & ta_handle);
> +}
> +
> +static inline u32 get_ta_handle(u32 session)
> +{
> +	return session & LOWER_TWO_BYTE_MASK;
> +}
> +
> +static inline u32 get_session_index(u32 session)
> +{
> +	return (session >> 16) & LOWER_TWO_BYTE_MASK;
> +}
> +
> +int amdtee_open_session(struct tee_context *ctx,
> +			struct tee_ioctl_open_session_arg *arg,
> +			struct tee_param *param);
> +
> +int amdtee_close_session(struct tee_context *ctx, u32 session);
> +
> +int amdtee_invoke_func(struct tee_context *ctx,
> +		       struct tee_ioctl_invoke_arg *arg,
> +		       struct tee_param *param);
> +
> +int amdtee_cancel_req(struct tee_context *ctx, u32 cancel_id, u32 session);
> +
> +int amdtee_map_shmem(struct tee_shm *shm);
> +
> +void amdtee_unmap_shmem(struct tee_shm *shm);
> +
> +int handle_load_ta(void *data, u32 size,
> +		   struct tee_ioctl_open_session_arg *arg);
> +
> +int handle_unload_ta(u32 ta_handle);
> +
> +int handle_open_session(struct tee_ioctl_open_session_arg *arg, u32 *info,
> +			struct tee_param *p);
> +
> +int handle_close_session(u32 ta_handle, u32 info);
> +
> +int handle_map_shmem(u32 count, struct shmem_desc *start, u32 *buf_id);
> +
> +void handle_unmap_shmem(u32 buf_id);
> +
> +int handle_invoke_cmd(struct tee_ioctl_invoke_arg *arg, u32 sinfo,
> +		      struct tee_param *p);
> +
> +struct tee_shm_pool *amdtee_config_shm(void);
> +
> +u32 get_buffer_id(struct tee_shm *shm);
> +#endif /*AMDTEE_PRIVATE_H*/
> diff --git a/drivers/tee/amdtee/call.c b/drivers/tee/amdtee/call.c
> new file mode 100644
> index 0000000..87ccad2
> --- /dev/null
> +++ b/drivers/tee/amdtee/call.c
> @@ -0,0 +1,373 @@
> +// SPDX-License-Identifier: MIT
> +/*
> + * Copyright 2019 Advanced Micro Devices, Inc.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/tee.h>
> +#include <linux/tee_drv.h>
> +#include <linux/psp-tee.h>
> +#include <linux/slab.h>
> +#include <linux/psp-sev.h>
> +#include "amdtee_if.h"
> +#include "amdtee_private.h"
> +
> +static int tee_params_to_amd_params(struct tee_param *tee, u32 count,
> +				    struct tee_operation *amd)
> +{
> +	int i, ret = 0;
> +	u32 type;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (!tee || !amd || count > TEE_MAX_PARAMS)
> +		return -EINVAL;
> +
> +	amd->param_types = 0;
> +	for (i = 0; i < count; i++) {
> +		/* AMD TEE does not support meta parameter */
> +		if (tee[i].attr > TEE_IOCTL_PARAM_ATTR_TYPE_MEMREF_INOUT)
> +			return -EINVAL;
> +
> +		amd->param_types |= ((tee[i].attr & 0xF) << i * 4);
> +	}
> +
> +	for (i = 0; i < count; i++) {
> +		type = TEE_PARAM_TYPE_GET(amd->param_types, i);
> +		pr_debug("%s: type[%d] = 0x%x\n", __func__, i, type);
> +
> +		if (type == TEE_OP_PARAM_TYPE_INVALID)
> +			return -EINVAL;
> +
> +		if (type == TEE_OP_PARAM_TYPE_NONE)
> +			continue;
> +
> +		/* It is assumed that all values are within 2^32-1 */
> +		if (type > TEE_OP_PARAM_TYPE_VALUE_INOUT) {
> +			u32 buf_id = get_buffer_id(tee[i].u.memref.shm);
> +
> +			amd->params[i].mref.buf_id = buf_id;
> +			amd->params[i].mref.offset = tee[i].u.memref.shm_offs;
> +			amd->params[i].mref.size = tee[i].u.memref.size;
> +			pr_debug("%s: bufid[%d] = 0x%x, offset[%d] = 0x%x, size[%d] = 0x%x\n",
> +				 __func__,
> +				 i, amd->params[i].mref.buf_id,
> +				 i, amd->params[i].mref.offset,
> +				 i, amd->params[i].mref.size);
> +		} else {
> +			if (tee[i].u.value.c)
> +				pr_warn("%s: Discarding value c", __func__);
> +
> +			amd->params[i].val.a = tee[i].u.value.a;
> +			amd->params[i].val.b = tee[i].u.value.b;
> +			pr_debug("%s: a[%d] = 0x%x, b[%d] = 0x%x\n", __func__,
> +				 i, amd->params[i].val.a,
> +				 i, amd->params[i].val.b);
> +		}
> +	}
> +	return ret;
> +}
> +
> +static int amd_params_to_tee_params(struct tee_param *tee, u32 count,
> +				    struct tee_operation *amd)
> +{
> +	int i, ret = 0;
> +	u32 type;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (!tee || !amd || count > TEE_MAX_PARAMS)
> +		return -EINVAL;
> +
> +	/* Assumes amd->param_types is valid */
> +	for (i = 0; i < count; i++) {
> +		type = TEE_PARAM_TYPE_GET(amd->param_types, i);
> +		pr_debug("%s: type[%d] = 0x%x\n", __func__, i, type);
> +
> +		if (type == TEE_OP_PARAM_TYPE_INVALID ||
> +		    type > TEE_OP_PARAM_TYPE_MEMREF_INOUT)
> +			return -EINVAL;
> +
> +		if (type == TEE_OP_PARAM_TYPE_NONE ||
> +		    type == TEE_OP_PARAM_TYPE_VALUE_INPUT ||
> +		    type == TEE_OP_PARAM_TYPE_MEMREF_INPUT)
> +			continue;
> +
> +		/*
> +		 * It is assumed that buf_id remains unchanged for
> +		 * both open_session and invoke_cmd call
> +		 */
> +		if (type > TEE_OP_PARAM_TYPE_MEMREF_INPUT) {
> +			tee[i].u.memref.shm_offs = amd->params[i].mref.offset;
> +			tee[i].u.memref.size = amd->params[i].mref.size;
> +			pr_debug("%s: bufid[%d] = 0x%x, offset[%d] = 0x%x, size[%d] = 0x%x\n",
> +				 __func__,
> +				 i, amd->params[i].mref.buf_id,
> +				 i, amd->params[i].mref.offset,
> +				 i, amd->params[i].mref.size);
> +		} else {
> +			/* field 'c' not supported by AMD TEE */
> +			tee[i].u.value.a = amd->params[i].val.a;
> +			tee[i].u.value.b = amd->params[i].val.b;
> +			tee[i].u.value.c = 0;
> +			pr_debug("%s: a[%d] = 0x%x, b[%d] = 0x%x\n",
> +				 __func__,
> +				 i, amd->params[i].val.a,
> +				 i, amd->params[i].val.b);
> +		}
> +	}
> +	return ret;
> +}
> +
> +int handle_unload_ta(u32 ta_handle)
> +{
> +	struct tee_cmd_unload_ta cmd = {0};
> +	int ret = 0;
> +	u32 status;
> +
> +	if (!ta_handle)
> +		return -EINVAL;
> +
> +	cmd.ta_handle = ta_handle;
> +
> +	ret = psp_tee_process_cmd(TEE_CMD_ID_UNLOAD_TA, (void *)&cmd,
> +				  sizeof(cmd), &status);
> +	if (!ret && status != 0) {
> +		pr_err("unload ta: status = 0x%x\n", status);
> +		ret = -EBUSY;
> +	}
> +
> +	return ret;
> +}
> +
> +int handle_close_session(u32 ta_handle, u32 info)
> +{
> +	struct tee_cmd_close_session cmd = {0};
> +	int ret = 0;
> +	u32 status;
> +
> +	if (ta_handle == 0)
> +		return -EINVAL;
> +
> +	cmd.ta_handle = ta_handle;
> +	cmd.session_info = info;
> +
> +	ret = psp_tee_process_cmd(TEE_CMD_ID_CLOSE_SESSION, (void *)&cmd,
> +				  sizeof(cmd), &status);
> +	if (!ret && status != 0) {
> +		pr_err("close session: status = 0x%x\n", status);
> +		ret = -EBUSY;
> +	}
> +
> +	return ret;
> +}
> +
> +void handle_unmap_shmem(u32 buf_id)
> +{
> +	struct tee_cmd_unmap_shared_mem cmd = {0};
> +	int ret = 0;
> +	u32 status;
> +
> +	cmd.buf_id = buf_id;
> +
> +	ret = psp_tee_process_cmd(TEE_CMD_ID_UNMAP_SHARED_MEM, (void *)&cmd,
> +				  sizeof(cmd), &status);
> +	if (!ret)
> +		pr_debug("unmap shared memory: buf_id %u status = 0x%x\n",
> +			 buf_id, status);
> +}
> +
> +int handle_invoke_cmd(struct tee_ioctl_invoke_arg *arg, u32 sinfo,
> +		      struct tee_param *p)
> +{
> +	struct tee_cmd_invoke_cmd cmd = {0};
> +	int ret = 0;
> +
> +	if (!arg || (!p && arg->num_params))
> +		return -EINVAL;
> +
> +	arg->ret_origin = TEEC_ORIGIN_COMMS;
> +
> +	if (arg->session == 0) {
> +		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
> +		return -EINVAL;
> +	}
> +
> +	ret = tee_params_to_amd_params(p, arg->num_params, &cmd.op);
> +	if (ret) {
> +		pr_err("invalid Params. Abort invoke command\n");
> +		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
> +		return ret;
> +	}
> +
> +	cmd.ta_handle = get_ta_handle(arg->session);
> +	cmd.cmd_id = arg->func;
> +	cmd.session_info = sinfo;
> +
> +	ret = psp_tee_process_cmd(TEE_CMD_ID_INVOKE_CMD, (void *)&cmd,
> +				  sizeof(cmd), &arg->ret);
> +	if (ret) {
> +		arg->ret = TEEC_ERROR_COMMUNICATION;
> +	} else {
> +		ret = amd_params_to_tee_params(p, arg->num_params, &cmd.op);
> +		if (unlikely(ret)) {
> +			pr_err("invoke command: failed to copy output\n");
> +			arg->ret = TEEC_ERROR_GENERIC;
> +			return ret;
> +		}
> +		arg->ret_origin = cmd.return_origin;
> +		pr_debug("invoke command: RO = 0x%x ret = 0x%x\n",
> +			 arg->ret_origin, arg->ret);
> +	}
> +
> +	return ret;
> +}
> +
> +int handle_map_shmem(u32 count, struct shmem_desc *start, u32 *buf_id)
> +{
> +	struct tee_cmd_map_shared_mem *cmd;
> +	phys_addr_t paddr;
> +	int ret = 0, i;
> +	u32 status;
> +
> +	if (!count || !start || !buf_id)
> +		return -EINVAL;
> +
> +	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd)
> +		return -ENOMEM;
> +
> +	/* Size must be page aligned */
> +	for (i = 0; i < count ; i++) {
> +		if (!start[i].kaddr || (start[i].size & (PAGE_SIZE - 1))) {
> +			ret = -EINVAL;
> +			goto free_cmd;
> +		}
> +
> +		if ((u64)start[i].kaddr & (PAGE_SIZE - 1)) {
> +			pr_err("map shared memory: page unaligned. addr 0x%llx",
> +			       (u64)start[i].kaddr);
> +			ret = -EINVAL;
> +			goto free_cmd;
> +		}
> +	}
> +
> +	cmd->sg_list.count = count;
> +
> +	/* Create buffer list */
> +	for (i = 0; i < count ; i++) {
> +		paddr = __psp_pa(start[i].kaddr);
> +		cmd->sg_list.buf[i].hi_addr = upper_32_bits(paddr);
> +		cmd->sg_list.buf[i].low_addr = lower_32_bits(paddr);
> +		cmd->sg_list.buf[i].size = start[i].size;
> +		cmd->sg_list.size += cmd->sg_list.buf[i].size;
> +
> +		pr_debug("buf[%d]:hi addr = 0x%x\n", i,
> +			 cmd->sg_list.buf[i].hi_addr);
> +		pr_debug("buf[%d]:low addr = 0x%x\n", i,
> +			 cmd->sg_list.buf[i].low_addr);
> +		pr_debug("buf[%d]:size = 0x%x\n", i, cmd->sg_list.buf[i].size);
> +		pr_debug("list size = 0x%x\n", cmd->sg_list.size);
> +	}
> +
> +	*buf_id = 0;
> +
> +	ret = psp_tee_process_cmd(TEE_CMD_ID_MAP_SHARED_MEM, (void *)cmd,
> +				  sizeof(*cmd), &status);
> +	if (!ret && !status) {
> +		*buf_id = cmd->buf_id;
> +		pr_debug("mapped buffer ID = 0x%x\n", *buf_id);
> +	} else {
> +		pr_err("map shared memory: status = 0x%x\n", status);
> +		ret = -ENOMEM;
> +	}
> +
> +free_cmd:
> +	kfree(cmd);
> +
> +	return ret;
> +}
> +
> +int handle_open_session(struct tee_ioctl_open_session_arg *arg, u32 *info,
> +			struct tee_param *p)
> +{
> +	struct tee_cmd_open_session cmd = {0};
> +	int ret = 0;
> +
> +	if (!arg || !info || (!p && arg->num_params))
> +		return -EINVAL;
> +
> +	arg->ret_origin = TEEC_ORIGIN_COMMS;
> +
> +	if (arg->session == 0) {
> +		arg->ret = TEEC_ERROR_GENERIC;
> +		return -EINVAL;
> +	}
> +
> +	ret = tee_params_to_amd_params(p, arg->num_params, &cmd.op);
> +	if (ret) {
> +		pr_err("invalid Params. Abort open session\n");
> +		arg->ret = TEEC_ERROR_BAD_PARAMETERS;
> +		return ret;
> +	}
> +
> +	cmd.ta_handle = get_ta_handle(arg->session);
> +	*info = 0;
> +
> +	ret = psp_tee_process_cmd(TEE_CMD_ID_OPEN_SESSION, (void *)&cmd,
> +				  sizeof(cmd), &arg->ret);
> +	if (ret) {
> +		arg->ret = TEEC_ERROR_COMMUNICATION;
> +	} else {
> +		ret = amd_params_to_tee_params(p, arg->num_params, &cmd.op);
> +		if (unlikely(ret)) {
> +			pr_err("open session: failed to copy output\n");
> +			arg->ret = TEEC_ERROR_GENERIC;
> +			return ret;
> +		}
> +		arg->ret_origin = cmd.return_origin;
> +		*info = cmd.session_info;
> +		pr_debug("open session: session info = 0x%x\n", *info);
> +	}
> +
> +	pr_debug("open session: ret = 0x%x RO = 0x%x\n", arg->ret,
> +		 arg->ret_origin);
> +
> +	return ret;
> +}
> +
> +int handle_load_ta(void *data, u32 size, struct tee_ioctl_open_session_arg *arg)
> +{
> +	struct tee_cmd_load_ta cmd = {0};
> +	phys_addr_t blob;
> +	int ret = 0;
> +
> +	if (size == 0 || !data || !arg)
> +		return -EINVAL;
> +
> +	blob = __psp_pa(data);
> +	if (blob & (PAGE_SIZE - 1)) {
> +		pr_err("load TA: page unaligned. blob 0x%llx", blob);
> +		return -EINVAL;
> +	}
> +
> +	cmd.hi_addr = upper_32_bits(blob);
> +	cmd.low_addr = lower_32_bits(blob);
> +	cmd.size = size;
> +
> +	ret = psp_tee_process_cmd(TEE_CMD_ID_LOAD_TA, (void *)&cmd,
> +				  sizeof(cmd), &arg->ret);
> +	if (ret) {
> +		arg->ret_origin = TEEC_ORIGIN_COMMS;
> +		arg->ret = TEEC_ERROR_COMMUNICATION;
> +	} else {
> +		set_session_id(cmd.ta_handle, 0, &arg->session);
> +	}
> +
> +	pr_debug("load TA: TA handle = 0x%x, RO = 0x%x, ret = 0x%x\n",
> +		 cmd.ta_handle, arg->ret_origin, arg->ret);
> +
> +	return 0;
> +}
> diff --git a/drivers/tee/amdtee/core.c b/drivers/tee/amdtee/core.c
> new file mode 100644
> index 0000000..dd360f3
> --- /dev/null
> +++ b/drivers/tee/amdtee/core.c
> @@ -0,0 +1,510 @@
> +// SPDX-License-Identifier: MIT
> +/*
> + * Copyright 2019 Advanced Micro Devices, Inc.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/io.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/string.h>
> +#include <linux/device.h>
> +#include <linux/tee_drv.h>
> +#include <linux/types.h>
> +#include <linux/mm.h>
> +#include <linux/uaccess.h>
> +#include <linux/firmware.h>
> +#include "amdtee_private.h"
> +#include "../tee_private.h"
> +
> +static struct amdtee_driver_data *drv_data;
> +static DEFINE_MUTEX(session_list_mutex);
> +static struct amdtee_shm_context shmctx;
> +
> +static void amdtee_get_version(struct tee_device *teedev,
> +			       struct tee_ioctl_version_data *vers)
> +{
> +	struct tee_ioctl_version_data v = {
> +		.impl_id = TEE_IMPL_ID_AMDTEE,
> +		.impl_caps = 0,
> +		.gen_caps = TEE_GEN_CAP_GP,
> +	};
> +	*vers = v;
> +}
> +
> +static int amdtee_open(struct tee_context *ctx)
> +{
> +	struct amdtee_context_data *ctxdata;
> +
> +	ctxdata = kzalloc(sizeof(*ctxdata), GFP_KERNEL);
> +	if (!ctxdata)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(&ctxdata->sess_list);
> +	INIT_LIST_HEAD(&shmctx.shmdata_list);
> +
> +	ctx->data = ctxdata;
> +	return 0;
> +}
> +
> +static void release_session(struct amdtee_session *sess)
> +{
> +	int i = 0;
> +
> +	/* Close any open session */
> +	for (i = 0; i < TEE_NUM_SESSIONS; ++i) {
> +		/* Check if session entry 'i' is valid */
> +		if (!test_bit(i, sess->sess_mask))
> +			continue;
> +
> +		handle_close_session(sess->ta_handle, sess->session_info[i]);
> +	}
> +
> +	/* Unload Trusted Application once all sessions are closed */
> +	handle_unload_ta(sess->ta_handle);
> +	kfree(sess);
> +}
> +
> +static void amdtee_release(struct tee_context *ctx)
> +{
> +	struct amdtee_context_data *ctxdata = ctx->data;
> +
> +	if (!ctxdata)
> +		return;
> +
> +	while (true) {
> +		struct amdtee_session *sess;
> +
> +		sess = list_first_entry_or_null(&ctxdata->sess_list,
> +						struct amdtee_session,
> +						list_node);
> +
> +		if (!sess)
> +			break;
> +
> +		list_del(&sess->list_node);
> +		release_session(sess);
> +	}
> +	kfree(ctxdata);
> +
> +	ctx->data = NULL;
> +}
> +
> +/**
> + * alloc_session() - Allocate a session structure
> + * @ctxdata:    TEE Context data structure
> + * @session:    Session ID for which 'struct amdtee_session' structure is to be
> + *              allocated.
> + *
> + * Scans the TEE context's session list to check if TA is already loaded in to
> + * TEE. If yes, returns the 'session' structure for that TA. Else allocates,
> + * initializes a new 'session' structure and adds it to context's session list.
> + *
> + * The caller must hold a mutex.
> + *
> + * Returns:
> + * 'struct amdtee_session *' on success and NULL on failure.
> + */
> +static struct amdtee_session *alloc_session(struct amdtee_context_data *ctxdata,
> +					    u32 session)
> +{
> +	struct amdtee_session *sess;
> +	u32 ta_handle = get_ta_handle(session);
> +
> +	/* Scan session list to check if TA is already loaded in to TEE */
> +	list_for_each_entry(sess, &ctxdata->sess_list, list_node)
> +		if (sess->ta_handle == ta_handle) {
> +			kref_get(&sess->refcount);
> +			return sess;
> +		}
> +
> +	/* Allocate a new session and add to list */
> +	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
> +	if (sess) {
> +		sess->ta_handle = ta_handle;
> +		kref_init(&sess->refcount);
> +		spin_lock_init(&sess->lock);
> +		list_add(&sess->list_node, &ctxdata->sess_list);
> +	}
> +
> +	return sess;
> +}
> +
> +/* Requires mutex to be held */
> +static struct amdtee_session *find_session(struct amdtee_context_data *ctxdata,
> +					   u32 session)
> +{
> +	u32 ta_handle = get_ta_handle(session);
> +	u32 index = get_session_index(session);
> +	struct amdtee_session *sess;
> +
> +	list_for_each_entry(sess, &ctxdata->sess_list, list_node)
> +		if (ta_handle == sess->ta_handle &&
> +		    test_bit(index, sess->sess_mask))
> +			return sess;
> +
> +	return NULL;
> +}
> +
> +u32 get_buffer_id(struct tee_shm *shm)
> +{
> +	u32 buf_id = 0;
> +	struct amdtee_shm_data *shmdata;
> +
> +	list_for_each_entry(shmdata, &shmctx.shmdata_list, shm_node)
> +		if (shmdata->kaddr == shm->kaddr) {
> +			buf_id = shmdata->buf_id;
> +			break;
> +		}
> +
> +	return buf_id;
> +}
> +
> +static DEFINE_MUTEX(drv_mutex);
> +static int copy_ta_binary(struct tee_context *ctx, void *ptr, void **ta,
> +			  size_t *ta_size)
> +{
> +	const struct firmware *fw;
> +	char fw_name[TA_PATH_MAX];
> +	struct {
> +		u32 lo;
> +		u16 mid;
> +		u16 hi_ver;
> +		u8 seq_n[8];
> +	} *uuid = ptr;
> +	int n = 0, rc = 0;
> +
> +	n = snprintf(fw_name, TA_PATH_MAX,
> +		     "%s/%08x-%04x-%04x-%02x%02x%02x%02x%02x%02x%02x%02x.bin",
> +		     TA_LOAD_PATH, uuid->lo, uuid->mid, uuid->hi_ver,
> +		     uuid->seq_n[0], uuid->seq_n[1],
> +		     uuid->seq_n[2], uuid->seq_n[3],
> +		     uuid->seq_n[4], uuid->seq_n[5],
> +		     uuid->seq_n[6], uuid->seq_n[7]);
> +	if (n < 0 || n >= TA_PATH_MAX) {
> +		pr_err("failed to get firmware name\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&drv_mutex);
> +	n = request_firmware(&fw, fw_name, &ctx->teedev->dev);
> +	if (n) {
> +		pr_err("failed to load firmware %s\n", fw_name);
> +		rc = -ENOMEM;
> +		goto unlock;
> +	}
> +
> +	*ta_size = roundup(fw->size, PAGE_SIZE);
> +	*ta = (void *)__get_free_pages(GFP_KERNEL, get_order(*ta_size));
> +	if (IS_ERR(*ta)) {
> +		pr_err("%s: get_free_pages failed 0x%llx\n", __func__,
> +		       (u64)*ta);
> +		rc = -ENOMEM;
> +		goto rel_fw;
> +	}
> +
> +	memcpy(*ta, fw->data, fw->size);
> +rel_fw:
> +	release_firmware(fw);
> +unlock:
> +	mutex_unlock(&drv_mutex);
> +	return rc;
> +}
> +
> +int amdtee_open_session(struct tee_context *ctx,
> +			struct tee_ioctl_open_session_arg *arg,
> +			struct tee_param *param)
> +{
> +	struct amdtee_context_data *ctxdata = ctx->data;
> +	struct amdtee_session *sess = NULL;
> +	u32 session_info;
> +	void *ta = NULL;
> +	size_t ta_size;
> +	int rc = 0, i;
> +
> +	if (arg->clnt_login != TEE_IOCTL_LOGIN_PUBLIC) {
> +		pr_err("unsupported client login method\n");
> +		return -EINVAL;
> +	}
> +
> +	rc = copy_ta_binary(ctx, &arg->uuid[0], &ta, &ta_size);
> +	if (rc) {
> +		pr_err("failed to copy TA binary\n");
> +		return rc;
> +	}
> +
> +	/* Load the TA binary into TEE environment */
> +	handle_load_ta(ta, ta_size, arg);
> +	if (arg->ret == TEEC_SUCCESS) {
> +		mutex_lock(&session_list_mutex);
> +		sess = alloc_session(ctxdata, arg->session);
> +		mutex_unlock(&session_list_mutex);
> +	}
> +
> +	if (arg->ret != TEEC_SUCCESS)
> +		goto out;
> +
> +	if (!sess) {
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* Find an empty session index for the given TA */
> +	spin_lock(&sess->lock);
> +	i = find_first_zero_bit(sess->sess_mask, TEE_NUM_SESSIONS);
> +	if (i < TEE_NUM_SESSIONS)
> +		set_bit(i, sess->sess_mask);
> +	spin_unlock(&sess->lock);
> +
> +	if (i >= TEE_NUM_SESSIONS) {
> +		pr_err("reached maximum session count %d\n", TEE_NUM_SESSIONS);
> +		rc = -ENOMEM;
> +		goto out;
> +	}
> +
> +	/* Open session with loaded TA */
> +	handle_open_session(arg, &session_info, param);
> +
> +	if (arg->ret == TEEC_SUCCESS) {
> +		sess->session_info[i] = session_info;
> +		set_session_id(sess->ta_handle, i, &arg->session);
> +	} else {
> +		pr_err("open_session failed %d\n", arg->ret);
> +		spin_lock(&sess->lock);
> +		clear_bit(i, sess->sess_mask);
> +		spin_unlock(&sess->lock);
> +	}
> +out:
> +	free_pages((u64)ta, get_order(ta_size));
> +	return rc;
> +}
> +
> +static void destroy_session(struct kref *ref)
> +{
> +	struct amdtee_session *sess = container_of(ref, struct amdtee_session,
> +						   refcount);
> +
> +	/* Unload the TA from TEE */
> +	handle_unload_ta(sess->ta_handle);
> +	mutex_lock(&session_list_mutex);
> +	list_del(&sess->list_node);
> +	mutex_unlock(&session_list_mutex);
> +	kfree(sess);
> +}
> +
> +int amdtee_close_session(struct tee_context *ctx, u32 session)
> +{
> +	struct amdtee_context_data *ctxdata = ctx->data;
> +	u32 i, ta_handle, session_info;
> +	struct amdtee_session *sess;
> +
> +	pr_debug("%s: sid = 0x%x\n", __func__, session);
> +
> +	/*
> +	 * Check that the session is valid and clear the session
> +	 * usage bit
> +	 */
> +	mutex_lock(&session_list_mutex);
> +	sess = find_session(ctxdata, session);
> +	if (sess) {
> +		ta_handle = get_ta_handle(session);
> +		i = get_session_index(session);
> +		session_info = sess->session_info[i];
> +		spin_lock(&sess->lock);
> +		clear_bit(i, sess->sess_mask);
> +		spin_unlock(&sess->lock);
> +	}
> +	mutex_unlock(&session_list_mutex);
> +
> +	if (!sess)
> +		return -EINVAL;
> +
> +	/* Close the session */
> +	handle_close_session(ta_handle, session_info);
> +
> +	kref_put(&sess->refcount, destroy_session);
> +
> +	return 0;
> +}
> +
> +int amdtee_map_shmem(struct tee_shm *shm)
> +{
> +	struct shmem_desc shmem;
> +	struct amdtee_shm_data *shmnode;
> +	int rc, count;
> +	u32 buf_id;
> +
> +	if (!shm)
> +		return -EINVAL;
> +
> +	shmnode = kmalloc(sizeof(*shmnode), GFP_KERNEL);
> +	if (!shmnode)
> +		return -ENOMEM;
> +
> +	count = 1;
> +	shmem.kaddr = shm->kaddr;
> +	shmem.size = shm->size;
> +
> +	/*
> +	 * Send a MAP command to TEE and get the corresponding
> +	 * buffer Id
> +	 */
> +	rc = handle_map_shmem(count, &shmem, &buf_id);
> +	if (rc) {
> +		pr_err("map_shmem failed: ret = %d\n", rc);
> +		kfree(shmnode);
> +		return rc;
> +	}
> +
> +	shmnode->kaddr = shm->kaddr;
> +	shmnode->buf_id = buf_id;
> +	list_add(&shmnode->shm_node, &shmctx.shmdata_list);
> +
> +	pr_debug("buf_id :[%x] kaddr[%p]\n", shmnode->buf_id, shmnode->kaddr);
> +
> +	return 0;
> +}
> +
> +void amdtee_unmap_shmem(struct tee_shm *shm)
> +{
> +	u32 buf_id;
> +	struct amdtee_shm_data *shmnode = NULL;
> +
> +	if (!shm)
> +		return;
> +
> +	buf_id = get_buffer_id(shm);
> +	/* Unmap the shared memory from TEE */
> +	handle_unmap_shmem(buf_id);
> +
> +	list_for_each_entry(shmnode, &shmctx.shmdata_list, shm_node)
> +		if (buf_id == shmnode->buf_id) {
> +			list_del(&shmnode->shm_node);
> +			kfree(shmnode);
> +			break;
> +		}
> +}
> +
> +int amdtee_invoke_func(struct tee_context *ctx,
> +		       struct tee_ioctl_invoke_arg *arg,
> +		       struct tee_param *param)
> +{
> +	struct amdtee_context_data *ctxdata = ctx->data;
> +	struct amdtee_session *sess;
> +	u32 i, session_info;
> +
> +	/* Check that the session is valid */
> +	mutex_lock(&session_list_mutex);
> +	sess = find_session(ctxdata, arg->session);
> +	if (sess) {
> +		i = get_session_index(arg->session);
> +		session_info = sess->session_info[i];
> +	}
> +	mutex_unlock(&session_list_mutex);
> +
> +	if (!sess)
> +		return -EINVAL;
> +
> +	handle_invoke_cmd(arg, session_info, param);
> +
> +	return 0;
> +}
> +
> +int amdtee_cancel_req(struct tee_context *ctx, u32 cancel_id, u32 session)
> +{
> +	return -EINVAL;
> +}
> +
> +static const struct tee_driver_ops amdtee_ops = {
> +	.get_version = amdtee_get_version,
> +	.open = amdtee_open,
> +	.release = amdtee_release,
> +	.open_session = amdtee_open_session,
> +	.close_session = amdtee_close_session,
> +	.invoke_func = amdtee_invoke_func,
> +	.cancel_req = amdtee_cancel_req,
> +};
> +
> +static const struct tee_desc amdtee_desc = {
> +	.name = DRIVER_NAME "-clnt",
> +	.ops = &amdtee_ops,
> +	.owner = THIS_MODULE,
> +};
> +
> +static int __init amdtee_driver_init(void)
> +{
> +	struct amdtee *amdtee = NULL;
> +	struct tee_device *teedev;
> +	struct tee_shm_pool *pool = ERR_PTR(-EINVAL);
> +	int rc;
> +
> +	drv_data = kzalloc(sizeof(*drv_data), GFP_KERNEL);
> +	if (IS_ERR(drv_data))
> +		return -ENOMEM;
> +
> +	amdtee = kzalloc(sizeof(*amdtee), GFP_KERNEL);
> +	if (IS_ERR(amdtee)) {
> +		rc = -ENOMEM;
> +		goto err_kfree_drv_data;
> +	}
> +
> +	pool = amdtee_config_shm();
> +	if (IS_ERR(pool)) {
> +		pr_err("shared pool configuration error\n");
> +		rc = PTR_ERR(pool);
> +		goto err_kfree_amdtee;
> +	}
> +
> +	teedev = tee_device_alloc(&amdtee_desc, NULL, pool, amdtee);
> +	if (IS_ERR(teedev)) {
> +		rc = PTR_ERR(teedev);
> +		goto err;
> +	}
> +	amdtee->teedev = teedev;
> +
> +	rc = tee_device_register(amdtee->teedev);
> +	if (rc)
> +		goto err;
> +
> +	amdtee->pool = pool;
> +
> +	drv_data->amdtee = amdtee;
> +
> +	pr_info("amd-tee driver initialization successful\n");
> +	return 0;
> +
> +err:
> +	tee_device_unregister(amdtee->teedev);
> +	if (pool)
> +		tee_shm_pool_free(pool);
> +
> +err_kfree_amdtee:
> +	kfree(amdtee);
> +
> +err_kfree_drv_data:
> +	kfree(drv_data);
> +	drv_data = NULL;
> +
> +	pr_err("amd-tee driver initialization failed\n");
> +	return rc;
> +}
> +module_init(amdtee_driver_init);
> +
> +static void __exit amdtee_driver_exit(void)
> +{
> +	struct amdtee *amdtee;
> +
> +	if (!drv_data || !drv_data->amdtee)
> +		return;
> +
> +	amdtee = drv_data->amdtee;
> +
> +	tee_device_unregister(amdtee->teedev);
> +	tee_shm_pool_free(amdtee->pool);
> +}
> +module_exit(amdtee_driver_exit);
> +
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION("AMD-TEE driver");
> +MODULE_VERSION("1.0");
> +MODULE_LICENSE("Dual MIT/GPL");
> diff --git a/drivers/tee/amdtee/shm_pool.c b/drivers/tee/amdtee/shm_pool.c
> new file mode 100644
> index 0000000..065854e
> --- /dev/null
> +++ b/drivers/tee/amdtee/shm_pool.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: MIT
> +/*
> + * Copyright 2019 Advanced Micro Devices, Inc.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/tee_drv.h>
> +#include <linux/psp-sev.h>
> +#include "amdtee_private.h"
> +
> +static int pool_op_alloc(struct tee_shm_pool_mgr *poolm, struct tee_shm *shm,
> +			 size_t size)
> +{
> +	unsigned int order = get_order(size);
> +	unsigned long va;
> +	int rc;
> +
> +	va = __get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
> +	if (!va)
> +		return -ENOMEM;
> +
> +	shm->kaddr = (void *)va;
> +	shm->paddr = __psp_pa((void *)va);
> +	shm->size = PAGE_SIZE << order;
> +
> +	/* Map the allocated memory in to TEE */
> +	rc = amdtee_map_shmem(shm);
> +	if (rc) {
> +		free_pages(va, order);
> +		shm->kaddr = NULL;
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static void pool_op_free(struct tee_shm_pool_mgr *poolm, struct tee_shm *shm)
> +{
> +	/* Unmap the shared memory from TEE */
> +	amdtee_unmap_shmem(shm);
> +	free_pages((unsigned long)shm->kaddr, get_order(shm->size));
> +	shm->kaddr = NULL;
> +}
> +
> +static void pool_op_destroy_poolmgr(struct tee_shm_pool_mgr *poolm)
> +{
> +	kfree(poolm);
> +}
> +
> +static const struct tee_shm_pool_mgr_ops pool_ops = {
> +	.alloc = pool_op_alloc,
> +	.free = pool_op_free,
> +	.destroy_poolmgr = pool_op_destroy_poolmgr,
> +};
> +
> +static struct tee_shm_pool_mgr *pool_mem_mgr_alloc(void)
> +{
> +	struct tee_shm_pool_mgr *mgr = kzalloc(sizeof(*mgr), GFP_KERNEL);
> +
> +	if (!mgr)
> +		return ERR_PTR(-ENOMEM);
> +
> +	mgr->ops = &pool_ops;
> +
> +	return mgr;
> +}
> +
> +struct tee_shm_pool *amdtee_config_shm(void)
> +{
> +	struct tee_shm_pool_mgr *priv_mgr;
> +	struct tee_shm_pool_mgr *dmabuf_mgr;
> +	void *rc;
> +
> +	rc = pool_mem_mgr_alloc();
> +	if (IS_ERR(rc))
> +		return rc;
> +	priv_mgr = rc;
> +
> +	rc = pool_mem_mgr_alloc();
> +	if (IS_ERR(rc)) {
> +		tee_shm_pool_mgr_destroy(priv_mgr);
> +		return rc;
> +	}
> +	dmabuf_mgr = rc;
> +
> +	rc = tee_shm_pool_alloc(priv_mgr, dmabuf_mgr);
> +	if (IS_ERR(rc)) {
> +		tee_shm_pool_mgr_destroy(priv_mgr);
> +		tee_shm_pool_mgr_destroy(dmabuf_mgr);
> +	}
> +
> +	return rc;
> +}
> diff --git a/include/uapi/linux/tee.h b/include/uapi/linux/tee.h
> index 4b9eb06..6596f3a 100644
> --- a/include/uapi/linux/tee.h
> +++ b/include/uapi/linux/tee.h
> @@ -56,6 +56,7 @@
>    * TEE Implementation ID
>    */
>   #define TEE_IMPL_ID_OPTEE	1
> +#define TEE_IMPL_ID_AMDTEE	2
>   
>   /*
>    * OP-TEE specific capabilities
> 

