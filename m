From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: [PATCH 1/3] drivers: crypto: Add Support for Octeon-tx CPT Engine
Date: Sat, 19 Nov 2016 01:01:03 +0530
Message-ID: <3226bed9-4ddd-f7cd-ae48-cc077936123e@caviumnetworks.com>
References: <1479481209-11475-1-git-send-email-gcherianv@gmail.com>
 <1479481209-11475-2-git-send-email-gcherianv@gmail.com>
 <582F4EA7.9030303@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        George Cherian <george.cherian@cavium.com>
To: David Daney <ddaney@caviumnetworks.com>, <gcherianv@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0068.outbound.protection.outlook.com ([104.47.38.68]:47168
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752302AbcKRUDV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2016 15:03:21 -0500
In-Reply-To: <582F4EA7.9030303@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

Thanks for the review.
On Saturday 19 November 2016 12:25 AM, David Daney wrote:
> On 11/18/2016 07:00 AM, gcherianv@gmail.com wrote:
>> From: George Cherian <george.cherian@cavium.com>
>>
>> Enable the Physical Function diver for the Cavium Crypto Engine (CPT)
>> found in Octeon-tx series of SoC's. CPT is the Cryptographic 
>> Acceleration
>> Unit. CPT includes microcoded GigaCypher symmetric engines (SEs) and
>> asymmetric engines (AEs).
>>
>> Signed-off-by: George Cherian <george.cherian@cavium.com>
>
>
> How was this tested?
Using ecryptfs and dm-crypt.
>
>
>> ---
>>   drivers/crypto/cavium/cpt/Kconfig        |  22 +
>>   drivers/crypto/cavium/cpt/Makefile       |   2 +
>>   drivers/crypto/cavium/cpt/cpt.h          |  90 +++
>>   drivers/crypto/cavium/cpt/cpt_common.h   | 377 +++++++++++++
>>   drivers/crypto/cavium/cpt/cpt_hw_types.h | 940 
>> +++++++++++++++++++++++++++++++
>>   drivers/crypto/cavium/cpt/cpt_main.c     | 891 
>> +++++++++++++++++++++++++++++
>>   drivers/crypto/cavium/cpt/cpt_pf_mbox.c  | 174 ++++++
>>   7 files changed, 2496 insertions(+)
>>   create mode 100644 drivers/crypto/cavium/cpt/Kconfig
>>   create mode 100644 drivers/crypto/cavium/cpt/Makefile
>>   create mode 100644 drivers/crypto/cavium/cpt/cpt.h
>>   create mode 100644 drivers/crypto/cavium/cpt/cpt_common.h
>>   create mode 100644 drivers/crypto/cavium/cpt/cpt_hw_types.h
>>   create mode 100644 drivers/crypto/cavium/cpt/cpt_main.c
>>   create mode 100644 drivers/crypto/cavium/cpt/cpt_pf_mbox.c
>>
>> diff --git a/drivers/crypto/cavium/cpt/Kconfig 
>> b/drivers/crypto/cavium/cpt/Kconfig
>> new file mode 100644
>> index 0000000..8fe3f44
>> --- /dev/null
>> +++ b/drivers/crypto/cavium/cpt/Kconfig
>> @@ -0,0 +1,22 @@
>> +#
>> +# Cavium crypto device configuration
>> +#
>> +
>> +config CRYPTO_DEV_CPT
>> +    tristate
>> +    select HW_RANDOM_OCTEON
>
> This makes no sense.  HW_RANDOM_OCTEON is for a mips64 based SOC and 
> isn't present on devices that have this crypto block.  Why select this?
>
Yeah true... I actually wanted to this one instead 
|CONFIG_HW_RANDOM_CAVIUM|
>
>> +    select CRYPTO_AES
>> +    select CRYPTO_DES
>> +    select CRYPTO_BLKCIPHER
>> +    select FW_LOADER
>> +
>> +config OCTEONTX_CPT_PF
>> +    tristate "Octeon-tx CPT Physical function driver"
>> +    depends on ARCH_THUNDER
>> +    select CRYPTO_DEV_CPT
>> +    help
>> +      Support for Cavium CPT block found in octeon-tx series of
>> +      processors.
>> +
>> +      To compile this as a module, choose M here: the module will be
>> +      called cptpf.
>> diff --git a/drivers/crypto/cavium/cpt/Makefile 
>> b/drivers/crypto/cavium/cpt/Makefile
>> new file mode 100644
>> index 0000000..bf758e2
>> --- /dev/null
>> +++ b/drivers/crypto/cavium/cpt/Makefile
>> @@ -0,0 +1,2 @@
>> +obj-$(CONFIG_OCTEONTX_CPT_PF) += cptpf.o
>> +cptpf-objs := cpt_main.o cpt_pf_mbox.o
>> diff --git a/drivers/crypto/cavium/cpt/cpt.h 
>> b/drivers/crypto/cavium/cpt/cpt.h
>> new file mode 100644
>> index 0000000..63d12da
>> --- /dev/null
>> +++ b/drivers/crypto/cavium/cpt/cpt.h
>> @@ -0,0 +1,90 @@
>> +/*
>> + * Copyright (C) 2016 Cavium, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or 
>> modify it
>> + * under the terms of version 2 of the GNU General Public License
>> + * as published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __CPT_H
>> +#define __CPT_H
>> +
>> +#include "cpt_common.h"
>> +
>> +#define BASE_PROC_DIR    "cavium"
>> +
>> +#define PF  0
>> +#define VF  1
>> +
>> +struct cpt_device;
>> +
>> +struct microcode {
>> +    uint8_t  is_mc_valid;
>
> s/uint8_t/u8/  ??
>
> That could be done everywhere.
will do
>
> [...]
>> diff --git a/drivers/crypto/cavium/cpt/cpt_common.h 
>> b/drivers/crypto/cavium/cpt/cpt_common.h
>> new file mode 100644
>> index 0000000..351ed4a
>> --- /dev/null
>> +++ b/drivers/crypto/cavium/cpt/cpt_common.h
>> @@ -0,0 +1,377 @@
>> +/*
>> + * Copyright (C) 2016 Cavium, Inc.
>> + *
>> + * This program is free software; you can redistribute it and/or 
>> modify it
>> + * under the terms of version 2 of the GNU General Public License
>> + * as published by the Free Software Foundation.
>> + */
>> +
>> +#ifndef __CPT_COMMON_H
>> +#define __CPT_COMMON_H
>> +
>> +#include <asm/byteorder.h>
>> +#include <linux/uaccess.h>
>> +#include <linux/types.h>
>> +#include <linux/spinlock.h>
>> +#include <linux/pci.h>
>> +#include <linux/cpumask.h>
>> +#include <linux/string.h>
>> +#include <linux/pci_regs.h>
>> +#include <linux/delay.h>
>> +#include <linux/printk.h>
>> +#include <linux/sched.h>
>> +#include <linux/completion.h>
>> +#include <asm/arch_timer.h>
>> +#include <linux/types.h>
>> +
>> +#include "cpt_hw_types.h"
>> +
>> +/* configuration space offsets */
>> +#ifndef PCI_VENDOR_ID
>> +#define PCI_VENDOR_ID 0x00 /* 16 bits */
>> +#endif
>> +#ifndef PCI_DEVICE_ID
>> +#define PCI_DEVICE_ID 0x02 /* 16 bits */
>> +#endif
>> +#ifndef PCI_REVISION_ID
>> +#define PCI_REVISION_ID 0x08 /* Revision ID */
>> +#endif
>> +#ifndef PCI_CAPABILITY_LIST
>> +#define PCI_CAPABILITY_LIST 0x34 /* first capability list entry */
>> +#endif
>> +
>
> Standard PCI core functions give you access to all that information, 
> use pdev->device, pdev->revision, etc. instead of reinventing the 
> wheel here with all these #defines.
>
>
>> +/* Device ID */
>> +#define PCI_VENDOR_ID_CAVIUM 0x177d
>
> This is defined in pci_ids.h, use value from there instead of placing 
> a duplicate definition here.
>
okay will remove them
>> +#define CPT_81XX_PCI_PF_DEVICE_ID 0xa040
>> +#define CPT_81XX_PCI_VF_DEVICE_ID 0xa041
>> +
>> +#define PASS_1_0 0x0
>> +
>> +/* CPT Models ((Device ID<<16)|Revision ID) */
>> +/* CPT models */
>> +#define CPT_81XX_PASS1_0 ((CPT_81XX_PCI_PF_DEVICE_ID << 8) | PASS_1_0)
>> +#define CPTVF_81XX_PASS1_0 ((CPT_81XX_PCI_VF_DEVICE_ID << 8) | 
>> PASS_1_0)
>> +
>> +#define PF 0
>> +#define VF 1
>> +
>> +#define DEFAULT_DEVICE_QUEUES CPT_NUM_QS_PER_VF
>> +
>> +#define SUCCESS    (0)
>> +#define FAIL    (1)
>> +
>> +#ifndef ROUNDUP4
>> +#define ROUNDUP4(val) (((val) + 3) & 0xfffffffc)
>> +#endif
>> +
>> +#ifndef ROUNDUP8
>> +#define ROUNDUP8(val) (((val) + 7) & 0xfffffff8)
>> +#endif
>> +
>> +#ifndef ROUNDUP16
>> +#define ROUNDUP16(val) (((val) + 15) & 0xfffffff0)
>> +#endif
>> +
>
> kernel.h has round_up(), use that instead of defining all these.
>
>> +#define ERR_ADDR_LEN 8
>> +
>
> What is that for?  It looks unused.
>
> [...]
>> +/*###### PCIE EP-Mode Configuration Registers #########*/
>> +#define PCIEEP0_CFG000 (0x0)
>> +#define PCIEEP0_CFG002 (0x8)
>> +#define PCIEEP0_CFG011 (0x2C)
>> +#define PCIEEP0_CFG020 (0x50)
>> +#define PCIEEP0_CFG025 (0x64)
>> +#define PCIEEP0_CFG030 (0x78)
>> +#define PCIEEP0_CFG044 (0xB0)
>> +#define PCIEEP0_CFG045 (0xB4)
>> +#define PCIEEP0_CFG082 (0x148)
>> +#define PCIEEP0_CFG095 (0x17C)
>> +#define PCIEEP0_CFG096 (0x180)
>> +#define PCIEEP0_CFG097 (0x184)
>> +#define PCIEEP0_CFG103 (0x19C)
>> +#define PCIEEP0_CFG460 (0x730)
>> +#define PCIEEP0_CFG461 (0x734)
>> +#define PCIEEP0_CFG462 (0x738)
>> +
>> +/*#######  PCIe EP-Mode SR-IOV Configuration Registers  #####*/
>> +#define PCIEEPVF0_CFG000 (0x0)
>> +#define PCIEEPVF0_CFG002 (0x8)
>> +#define PCIEEPVF0_CFG011 (0x2C)
>> +#define PCIEEPVF0_CFG030 (0x78)
>> +#define PCIEEPVF0_CFG044 (0xB0)
>> +
>
> Where are all those defines used?  What are they for?
>
>
> That's all I can look at for now.
>
I will address your comments in next version.
> David.
>
