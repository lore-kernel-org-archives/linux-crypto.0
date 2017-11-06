From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 3/3] staging: ccree: simplify ioread/iowrite
Date: Mon, 6 Nov 2017 10:59:47 +0200
Message-ID: <CAOtvUMcjUJw_hRwf+4pEv9-yXwgjnRrUpWbyASFt6AFjfTyOpg@mail.gmail.com>
References: <1509951354-16370-1-git-send-email-gilad@benyossef.com>
 <1509951354-16370-4-git-send-email-gilad@benyossef.com>
 <20171106083736.GJ18478@eros>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ofir Drang <ofir.drang@arm.com>
To: "Tobin C. Harding" <me@tobin.cc>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20171106083736.GJ18478@eros>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 6, 2017 at 10:37 AM, Tobin C. Harding <me@tobin.cc> wrote:
> On Mon, Nov 06, 2017 at 06:55:52AM +0000, Gilad Ben-Yossef wrote:
>> Registers ioread/iowrite operations were done via macros,
>> sometime using a "magical" implicit parameter.
>>
>> Replace all register access with simple inline macros.
>>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>
> Hi,
>
> Nice work. I had a little trouble following this one. Perhaps you are
> doing more than one thing per patch, feel free to ignore me if I am
> wrong but it seems you are moving the macro definition of CC_REG to a
> different header, adding the new inline functions and doing some other
> change that I can't grok (commented on below).
>
> Perhaps this patch could be broken up.

Thank you Tobin.

The original macro that I am replacing had an assumption of a variable void *
cc_base being defined in the context of the macro being called, even though
it was not listed in the explicit parameter list of the macro.

The inline function that replace it instead takes an explicit
parameter a pointer to
struct ssi_drive data * , who has said cc_base as one of the fields.

As a result several function that took a void * cc_base parameter
(which is than only
used implicitly via the macro without ever being visibly referenced), now take
struct ssi_drive data * parameter instead which is passed explicitly
to the inline
function.

These seems to be the places you are referring to. They are cascading changes
resulting from the change in API between the macro and the inline
function that replaces it.

I imagine I can try to break that change to two patches but at least
in my mind this is artificial
and it is a single logical change.

Having said that, if you think otherwise and consider this
none-reviewable even after this
explanation let me know and  I'd be happy to break it down.

Many thanks,
Gilad




>
>> ---
>>  drivers/staging/ccree/cc_hal.h           | 33 ------------------
>>  drivers/staging/ccree/cc_regs.h          | 35 --------------------
>>  drivers/staging/ccree/dx_reg_base_host.h | 25 --------------
>>  drivers/staging/ccree/ssi_driver.c       | 47 ++++++++++++--------------
>>  drivers/staging/ccree/ssi_driver.h       | 20 +++++++++--
>>  drivers/staging/ccree/ssi_fips.c         | 12 +++----
>>  drivers/staging/ccree/ssi_pm.c           |  4 +--
>>  drivers/staging/ccree/ssi_request_mgr.c  | 57 ++++++++++++++++----------------
>>  drivers/staging/ccree/ssi_sysfs.c        | 11 +++---
>>  9 files changed, 78 insertions(+), 166 deletions(-)
>>  delete mode 100644 drivers/staging/ccree/cc_hal.h
>>  delete mode 100644 drivers/staging/ccree/cc_regs.h
>>  delete mode 100644 drivers/staging/ccree/dx_reg_base_host.h
>>
>> diff --git a/drivers/staging/ccree/cc_hal.h b/drivers/staging/ccree/cc_hal.h
>> deleted file mode 100644
>> index eecc866..0000000
>> --- a/drivers/staging/ccree/cc_hal.h
>> +++ /dev/null
>> @@ -1,33 +0,0 @@
>> -/*
>> - * Copyright (C) 2012-2017 ARM Limited or its affiliates.
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License version 2 as
>> - * published by the Free Software Foundation.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU General Public License
>> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
>> - */
>> -
>> -/* pseudo cc_hal.h for cc7x_perf_test_driver (to be able to include code from
>> - * CC drivers).
>> - */
>> -
>> -#ifndef __CC_HAL_H__
>> -#define __CC_HAL_H__
>> -
>> -#include <linux/io.h>
>> -
>> -#define READ_REGISTER(_addr) ioread32((_addr))
>> -#define WRITE_REGISTER(_addr, _data)  iowrite32((_data), (_addr))
>> -
>> -#define CC_HAL_WRITE_REGISTER(offset, val) \
>> -     WRITE_REGISTER(cc_base + (offset), val)
>> -#define CC_HAL_READ_REGISTER(offset) READ_REGISTER(cc_base + (offset))
>> -
>> -#endif
>> diff --git a/drivers/staging/ccree/cc_regs.h b/drivers/staging/ccree/cc_regs.h
>> deleted file mode 100644
>> index 2a8fc73..0000000
>> --- a/drivers/staging/ccree/cc_regs.h
>> +++ /dev/null
>> @@ -1,35 +0,0 @@
>> -/*
>> - * Copyright (C) 2012-2017 ARM Limited or its affiliates.
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License version 2 as
>> - * published by the Free Software Foundation.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU General Public License
>> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
>> - */
>> -
>> -/*!
>> - * @file
>> - * @brief This file contains macro definitions for accessing ARM TrustZone
>> - *        CryptoCell register space.
>> - */
>> -
>> -#ifndef _CC_REGS_H_
>> -#define _CC_REGS_H_
>> -
>> -#include <linux/bitfield.h>
>> -
>> -#define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
>> -                                 DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
>> -                                 DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
>> -
>> -/* Register name mangling macro */
>> -#define CC_REG(reg_name) DX_ ## reg_name ## _REG_OFFSET
>> -
>> -#endif /*_CC_REGS_H_*/
>> diff --git a/drivers/staging/ccree/dx_reg_base_host.h b/drivers/staging/ccree/dx_reg_base_host.h
>> deleted file mode 100644
>> index 47bbadb..0000000
>> --- a/drivers/staging/ccree/dx_reg_base_host.h
>> +++ /dev/null
>> @@ -1,25 +0,0 @@
>> -/*
>> - * Copyright (C) 2012-2017 ARM Limited or its affiliates.
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License version 2 as
>> - * published by the Free Software Foundation.
>> - *
>> - * This program is distributed in the hope that it will be useful,
>> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> - * GNU General Public License for more details.
>> - *
>> - * You should have received a copy of the GNU General Public License
>> - * along with this program; if not, see <http://www.gnu.org/licenses/>.
>> - */
>> -
>> -#ifndef __DX_REG_BASE_HOST_H__
>> -#define __DX_REG_BASE_HOST_H__
>> -
>> -#define DX_BASE_CC 0x80000000
>> -#define DX_BASE_HOST_RGF 0x0UL
>> -#define DX_BASE_CRY_KERNEL     0x0UL
>> -#define DX_BASE_ROM     0x40000000
>> -
>> -#endif /*__DX_REG_BASE_HOST_H__*/
>> diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
>> index 1a9b9c9..1a3c481 100644
>> --- a/drivers/staging/ccree/ssi_driver.c
>> +++ b/drivers/staging/ccree/ssi_driver.c
>> @@ -91,7 +91,6 @@ void dump_byte_array(const char *name, const u8 *buf, size_t len)
>>  static irqreturn_t cc_isr(int irq, void *dev_id)
>>  {
>>       struct ssi_drvdata *drvdata = (struct ssi_drvdata *)dev_id;
>> -     void __iomem *cc_base = drvdata->cc_base;
>>       struct device *dev = drvdata_to_dev(drvdata);
>>       u32 irr;
>>       u32 imr;
>> @@ -99,22 +98,22 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
>>       /* STAT_OP_TYPE_GENERIC STAT_PHASE_0: Interrupt */
>>
>>       /* read the interrupt status */
>> -     irr = CC_HAL_READ_REGISTER(CC_REG(HOST_IRR));
>> +     irr = cc_ioread(drvdata, CC_REG(HOST_IRR));
>>       dev_dbg(dev, "Got IRR=0x%08X\n", irr);
>>       if (unlikely(irr == 0)) { /* Probably shared interrupt line */
>>               dev_err(dev, "Got interrupt with empty IRR\n");
>>               return IRQ_NONE;
>>       }
>> -     imr = CC_HAL_READ_REGISTER(CC_REG(HOST_IMR));
>> +     imr = cc_ioread(drvdata, CC_REG(HOST_IMR));
>>
>>       /* clear interrupt - must be before processing events */
>> -     CC_HAL_WRITE_REGISTER(CC_REG(HOST_ICR), irr);
>> +     cc_iowrite(drvdata, CC_REG(HOST_ICR), irr);
>>
>>       drvdata->irq = irr;
>>       /* Completion interrupt - most probable */
>>       if (likely((irr & SSI_COMP_IRQ_MASK) != 0)) {
>>               /* Mask AXI completion interrupt - will be unmasked in Deferred service handler */
>> -             CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR), imr | SSI_COMP_IRQ_MASK);
>> +             cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | SSI_COMP_IRQ_MASK);
>>               irr &= ~SSI_COMP_IRQ_MASK;
>>               complete_request(drvdata);
>>       }
>> @@ -122,7 +121,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
>>       /* TEE FIPS interrupt */
>>       if (likely((irr & SSI_GPR0_IRQ_MASK) != 0)) {
>>               /* Mask interrupt - will be unmasked in Deferred service handler */
>> -             CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
>> +             cc_iowrite(drvdata, CC_REG(HOST_IMR), imr | SSI_GPR0_IRQ_MASK);
>>               irr &= ~SSI_GPR0_IRQ_MASK;
>>               fips_handler(drvdata);
>>       }
>> @@ -132,7 +131,7 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
>>               u32 axi_err;
>>
>>               /* Read the AXI error ID */
>> -             axi_err = CC_HAL_READ_REGISTER(CC_REG(AXIM_MON_ERR));
>> +             axi_err = cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
>>               dev_dbg(dev, "AXI completion error: axim_mon_err=0x%08X\n",
>>                       axi_err);
>>
>> @@ -151,47 +150,44 @@ static irqreturn_t cc_isr(int irq, void *dev_id)
>>  int init_cc_regs(struct ssi_drvdata *drvdata, bool is_probe)
>>  {
>>       unsigned int val, cache_params;
>> -     void __iomem *cc_base = drvdata->cc_base;
>>       struct device *dev = drvdata_to_dev(drvdata);
>>
>>       /* Unmask all AXI interrupt sources AXI_CFG1 register */
>> -     val = CC_HAL_READ_REGISTER(CC_REG(AXIM_CFG));
>> -     CC_HAL_WRITE_REGISTER(CC_REG(AXIM_CFG), val & ~SSI_AXI_IRQ_MASK);
>> +     val = cc_ioread(drvdata, CC_REG(AXIM_CFG));
>> +     cc_iowrite(drvdata, CC_REG(AXIM_CFG), val & ~SSI_AXI_IRQ_MASK);
>>       dev_dbg(dev, "AXIM_CFG=0x%08X\n",
>> -             CC_HAL_READ_REGISTER(CC_REG(AXIM_CFG)));
>> +             cc_ioread(drvdata, CC_REG(AXIM_CFG)));
>>
>>       /* Clear all pending interrupts */
>> -     val = CC_HAL_READ_REGISTER(CC_REG(HOST_IRR));
>> +     val = cc_ioread(drvdata, CC_REG(HOST_IRR));
>>       dev_dbg(dev, "IRR=0x%08X\n", val);
>> -     CC_HAL_WRITE_REGISTER(CC_REG(HOST_ICR), val);
>> +     cc_iowrite(drvdata, CC_REG(HOST_ICR), val);
>>
>>       /* Unmask relevant interrupt cause */
>>       val = (unsigned int)(~(SSI_COMP_IRQ_MASK | SSI_AXI_ERR_IRQ_MASK |
>>                              SSI_GPR0_IRQ_MASK));
>> -     CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR), val);
>> +     cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
>>
>>  #ifdef DX_HOST_IRQ_TIMER_INIT_VAL_REG_OFFSET
>>  #ifdef DX_IRQ_DELAY
>>       /* Set CC IRQ delay */
>> -     CC_HAL_WRITE_REGISTER(CC_REG(HOST_IRQ_TIMER_INIT_VAL),
>> -                           DX_IRQ_DELAY);
>> +     cc_iowrite(drvdata, CC_REG(HOST_IRQ_TIMER_INIT_VAL), DX_IRQ_DELAY);
>>  #endif
>> -     if (CC_HAL_READ_REGISTER(CC_REG(HOST_IRQ_TIMER_INIT_VAL)) > 0) {
>> +     if (cc_ioread(drvdata, CC_REG(HOST_IRQ_TIMER_INIT_VAL)) > 0) {
>>               dev_dbg(dev, "irq_delay=%d CC cycles\n",
>> -                     CC_HAL_READ_REGISTER(CC_REG(HOST_IRQ_TIMER_INIT_VAL)));
>> +                     cc_ioread(drvdata, CC_REG(HOST_IRQ_TIMER_INIT_VAL)));
>>       }
>>  #endif
>>
>>       cache_params = (drvdata->coherent ? CC_COHERENT_CACHE_PARAMS : 0x0);
>>
>> -     val = CC_HAL_READ_REGISTER(CC_REG(AXIM_CACHE_PARAMS));
>> +     val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
>>
>>       if (is_probe)
>>               dev_info(dev, "Cache params previous: 0x%08X\n", val);
>>
>> -     CC_HAL_WRITE_REGISTER(CC_REG(AXIM_CACHE_PARAMS),
>> -                           cache_params);
>> -     val = CC_HAL_READ_REGISTER(CC_REG(AXIM_CACHE_PARAMS));
>> +     cc_iowrite(drvdata, CC_REG(AXIM_CACHE_PARAMS), cache_params);
>> +     val = cc_ioread(drvdata, CC_REG(AXIM_CACHE_PARAMS));
>>
>>       if (is_probe)
>>               dev_info(dev, "Cache params current: 0x%08X (expect: 0x%08X)\n",
>> @@ -280,7 +276,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
>>       }
>>
>>       /* Verify correct mapping */
>> -     signature_val = CC_HAL_READ_REGISTER(CC_REG(HOST_SIGNATURE));
>> +     signature_val = cc_ioread(new_drvdata, CC_REG(HOST_SIGNATURE));
>>       if (signature_val != DX_DEV_SIGNATURE) {
>>               dev_err(dev, "Invalid CC signature: SIGNATURE=0x%08X != expected=0x%08X\n",
>>                       signature_val, (u32)DX_DEV_SIGNATURE);
>> @@ -292,7 +288,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
>>       /* Display HW versions */
>>       dev_info(dev, "ARM CryptoCell %s Driver: HW version 0x%08X, Driver version %s\n",
>>                SSI_DEV_NAME_STR,
>> -              CC_HAL_READ_REGISTER(CC_REG(HOST_VERSION)),
>> +              cc_ioread(new_drvdata, CC_REG(HOST_VERSION)),
>>                DRV_MODULE_VERSION);
>>
>>       rc = init_cc_regs(new_drvdata, true);
>> @@ -410,8 +406,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
>>  void fini_cc_regs(struct ssi_drvdata *drvdata)
>>  {
>>       /* Mask all interrupts */
>> -     WRITE_REGISTER(drvdata->cc_base +
>> -                    CC_REG(HOST_IMR), 0xFFFFFFFF);
>> +     cc_iowrite(drvdata, CC_REG(HOST_IMR), 0xFFFFFFFF);
>>  }
>>
>>  static void cleanup_cc_resources(struct platform_device *plat_dev)
>> diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
>> index e01c880..94c755c 100644
>> --- a/drivers/staging/ccree/ssi_driver.h
>> +++ b/drivers/staging/ccree/ssi_driver.h
>> @@ -40,11 +40,8 @@
>>  #include <linux/platform_device.h>
>>
>>  /* Registers definitions from shared/hw/ree_include */
>> -#include "dx_reg_base_host.h"
>>  #include "dx_host.h"
>> -#include "cc_regs.h"
>>  #include "dx_reg_common.h"
>> -#include "cc_hal.h"
>>  #define CC_SUPPORT_SHA DX_DEV_SHA_MAX
>>  #include "cc_crypto_ctx.h"
>>  #include "ssi_sysfs.h"
>> @@ -73,6 +70,13 @@
>>
>>  #define SSI_COMP_IRQ_MASK BIT(DX_HOST_IRR_AXIM_COMP_INT_BIT_SHIFT)
>>
>> +#define AXIM_MON_COMP_VALUE GENMASK(DX_AXIM_MON_COMP_VALUE_BIT_SIZE + \
>> +                                 DX_AXIM_MON_COMP_VALUE_BIT_SHIFT, \
>> +                                 DX_AXIM_MON_COMP_VALUE_BIT_SHIFT)
>> +
>> +/* Register name mangling macro */
>> +#define CC_REG(reg_name) DX_ ## reg_name ## _REG_OFFSET
>> +
>>  /* TEE FIPS status interrupt */
>>  #define SSI_GPR0_IRQ_MASK BIT(DX_HOST_IRR_GPR0_BIT_SHIFT)
>>
>> @@ -188,5 +192,15 @@ void fini_cc_regs(struct ssi_drvdata *drvdata);
>>  int cc_clk_on(struct ssi_drvdata *drvdata);
>>  void cc_clk_off(struct ssi_drvdata *drvdata);
>>
>> +static inline void cc_iowrite(struct ssi_drvdata *drvdata, u32 reg, u32 val)
>> +{
>> +     iowrite32(val, (drvdata->cc_base + reg));
>> +}
>> +
>> +static inline u32 cc_ioread(struct ssi_drvdata *drvdata, u32 reg)
>> +{
>> +     return ioread32(drvdata->cc_base + reg);
>> +}
>> +
>>  #endif /*__SSI_DRIVER_H__*/
>>
>> diff --git a/drivers/staging/ccree/ssi_fips.c b/drivers/staging/ccree/ssi_fips.c
>> index d424aef..4aea99f 100644
>> --- a/drivers/staging/ccree/ssi_fips.c
>> +++ b/drivers/staging/ccree/ssi_fips.c
>> @@ -19,7 +19,6 @@
>>
>>  #include "ssi_config.h"
>>  #include "ssi_driver.h"
>> -#include "cc_hal.h"
>>  #include "ssi_fips.h"
>>
>>  static void fips_dsr(unsigned long devarg);
>> @@ -34,9 +33,8 @@ struct ssi_fips_handle {
>>  static bool cc_get_tee_fips_status(struct ssi_drvdata *drvdata)
>>  {
>>       u32 reg;
>> -     void __iomem *cc_base = drvdata->cc_base;
>>
>> -     reg = CC_HAL_READ_REGISTER(CC_REG(GPR_HOST));
>> +     reg = cc_ioread(drvdata, CC_REG(GPR_HOST));
>>       return (reg == (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK));
>>  }
>>
>> @@ -46,12 +44,11 @@ static bool cc_get_tee_fips_status(struct ssi_drvdata *drvdata)
>>   */
>>  void cc_set_ree_fips_status(struct ssi_drvdata *drvdata, bool status)
>>  {
>> -     void __iomem *cc_base = drvdata->cc_base;
>>       int val = CC_FIPS_SYNC_REE_STATUS;
>>
>>       val |= (status ? CC_FIPS_SYNC_MODULE_OK : CC_FIPS_SYNC_MODULE_ERROR);
>>
>> -     CC_HAL_WRITE_REGISTER(CC_REG(HOST_GPR0), val);
>> +     cc_iowrite(drvdata, CC_REG(HOST_GPR0), val);
>>  }
>>
>>  void ssi_fips_fini(struct ssi_drvdata *drvdata)
>> @@ -89,13 +86,12 @@ static void fips_dsr(unsigned long devarg)
>>  {
>>       struct ssi_drvdata *drvdata = (struct ssi_drvdata *)devarg;
>>       struct device *dev = drvdata_to_dev(drvdata);
>> -     void __iomem *cc_base = drvdata->cc_base;
>>       u32 irq, state, val;
>>
>>       irq = (drvdata->irq & (SSI_GPR0_IRQ_MASK));
>>
>>       if (irq) {
>> -             state = CC_HAL_READ_REGISTER(CC_REG(GPR_HOST));
>> +             state = cc_ioread(drvdata, CC_REG(GPR_HOST));
>>
>>               if (state != (CC_FIPS_SYNC_TEE_STATUS | CC_FIPS_SYNC_MODULE_OK))
>>                       tee_fips_error(dev);
>> @@ -105,7 +101,7 @@ static void fips_dsr(unsigned long devarg)
>>        * unmask AXI completion interrupt.
>>        */
>>       val = (CC_REG(HOST_IMR) & ~irq);
>> -     CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR), val);
>> +     cc_iowrite(drvdata, CC_REG(HOST_IMR), val);
>>  }
>>
>>  /* The function called once at driver entry point .*/
>> diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
>> index 73b31cd..36a4980 100644
>> --- a/drivers/staging/ccree/ssi_pm.c
>> +++ b/drivers/staging/ccree/ssi_pm.c
>> @@ -41,7 +41,7 @@ int ssi_power_mgr_runtime_suspend(struct device *dev)
>>       int rc;
>>
>>       dev_dbg(dev, "set HOST_POWER_DOWN_EN\n");
>> -     WRITE_REGISTER(drvdata->cc_base + CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
>> +     cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_ENABLE);
>>       rc = ssi_request_mgr_runtime_suspend_queue(drvdata);
>>       if (rc != 0) {
>>               dev_err(dev, "ssi_request_mgr_runtime_suspend_queue (%x)\n",
>> @@ -60,7 +60,7 @@ int ssi_power_mgr_runtime_resume(struct device *dev)
>>               (struct ssi_drvdata *)dev_get_drvdata(dev);
>>
>>       dev_dbg(dev, "unset HOST_POWER_DOWN_EN\n");
>> -     WRITE_REGISTER(drvdata->cc_base + CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
>> +     cc_iowrite(drvdata, CC_REG(HOST_POWER_DOWN_EN), POWER_DOWN_DISABLE);
>>
>>       rc = cc_clk_on(drvdata);
>>       if (rc) {
>> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
>> index 2f12ee2..a8a7dc6 100644
>> --- a/drivers/staging/ccree/ssi_request_mgr.c
>> +++ b/drivers/staging/ccree/ssi_request_mgr.c
>> @@ -122,8 +122,8 @@ int request_mgr_init(struct ssi_drvdata *drvdata)
>>       dev_dbg(dev, "Initializing completion tasklet\n");
>>       tasklet_init(&req_mgr_h->comptask, comp_handler, (unsigned long)drvdata);
>>  #endif
>> -     req_mgr_h->hw_queue_size = READ_REGISTER(drvdata->cc_base +
>> -             CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
>> +     req_mgr_h->hw_queue_size = cc_ioread(drvdata,
>> +                                          CC_REG(DSCRPTR_QUEUE_SRAM_SIZE));
>>       dev_dbg(dev, "hw_queue_size=0x%08X\n", req_mgr_h->hw_queue_size);
>>       if (req_mgr_h->hw_queue_size < MIN_HW_QUEUE_SIZE) {
>>               dev_err(dev, "Invalid HW queue size = %u (Min. required is %u)\n",
>> @@ -197,12 +197,12 @@ static void request_mgr_complete(struct device *dev, void *dx_compl_h, void __io
>>  }
>>
>>  static inline int request_mgr_queues_status_check(
>> -             struct device *dev,
>> +             struct ssi_drvdata *drvdata,
>>               struct ssi_request_mgr_handle *req_mgr_h,
>> -             void __iomem *cc_base,
>>               unsigned int total_seq_len)
>>  {
>>       unsigned long poll_queue;
>> +     struct device *dev = drvdata_to_dev(drvdata);
>>
>>       /* SW queue is checked only once as it will not
>>        * be chaned during the poll becasue the spinlock_bh
>> @@ -222,7 +222,7 @@ static inline int request_mgr_queues_status_check(
>>       /* Wait for space in HW queue. Poll constant num of iterations. */
>>       for (poll_queue = 0; poll_queue < SSI_MAX_POLL_ITER ; poll_queue++) {
>>               req_mgr_h->q_free_slots =
>> -                     CC_HAL_READ_REGISTER(CC_REG(DSCRPTR_QUEUE_CONTENT));
>> +                     cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
>>               if (unlikely(req_mgr_h->q_free_slots <
>>                                               req_mgr_h->min_free_hw_slots)) {
>>                       req_mgr_h->min_free_hw_slots = req_mgr_h->q_free_slots;
>> @@ -288,7 +288,7 @@ int send_request(
>>                * in case iv gen add the max size and in case of no dout add 1
>>                * for the internal completion descriptor
>>                */
>> -             rc = request_mgr_queues_status_check(dev, req_mgr_h, cc_base,
>> +             rc = request_mgr_queues_status_check(drvdata, req_mgr_h,
>>                                                    max_required_seq_len);
>>               if (likely(rc == 0))
>>                       /* There is enough place in the queue */
>> @@ -404,14 +404,13 @@ int send_request(
>>  int send_request_init(
>>       struct ssi_drvdata *drvdata, struct cc_hw_desc *desc, unsigned int len)
>>  {
>> -     struct device *dev = drvdata_to_dev(drvdata);
>>       void __iomem *cc_base = drvdata->cc_base;
>>       struct ssi_request_mgr_handle *req_mgr_h = drvdata->request_mgr_handle;
>>       unsigned int total_seq_len = len; /*initial sequence length*/
>>       int rc = 0;
>>
>>       /* Wait for space in HW and SW FIFO. Poll for as much as FIFO_TIMEOUT. */
>> -     rc = request_mgr_queues_status_check(dev, req_mgr_h, cc_base,
>> +     rc = request_mgr_queues_status_check(drvdata, req_mgr_h,
>>                                            total_seq_len);
>>       if (unlikely(rc != 0))
>>               return rc;
>> @@ -422,7 +421,7 @@ int send_request_init(
>>
>>       /* Update the free slots in HW queue */
>>       req_mgr_h->q_free_slots =
>> -             CC_HAL_READ_REGISTER(CC_REG(DSCRPTR_QUEUE_CONTENT));
>> +             cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
>>
>>       return 0;
>>  }
>> @@ -486,7 +485,8 @@ static void proc_completions(struct ssi_drvdata *drvdata)
>>
>>                       dev_info(dev, "Delay\n");
>>                       for (i = 0; i < 1000000; i++)
>> -                             axi_err = READ_REGISTER(drvdata->cc_base + CC_REG(AXIM_MON_ERR));
>> +                             axi_err = cc_ioread(drvdata,
>> +                                                 CC_REG(AXIM_MON_ERR));
>>               }
>>  #endif /* COMPLETION_DELAY */
>>
>> @@ -507,20 +507,16 @@ static void proc_completions(struct ssi_drvdata *drvdata)
>>       }
>>  }
>>
>> -static inline u32 cc_axi_comp_count(void __iomem *cc_base)
>> +static inline u32 cc_axi_comp_count(struct ssi_drvdata *drvdata)
>>  {
>> -     /* The CC_HAL_READ_REGISTER macro implictly requires and uses
>> -      * a base MMIO register address variable named cc_base.
>> -      */
>>       return FIELD_GET(AXIM_MON_COMP_VALUE,
>> -                      CC_HAL_READ_REGISTER(CC_REG(AXIM_MON_COMP)));
>> +                      cc_ioread(drvdata, CC_REG(AXIM_MON_COMP)));
>>  }
>>
>>  /* Deferred service handler, run as interrupt-fired tasklet */
>>  static void comp_handler(unsigned long devarg)
>>  {
>>       struct ssi_drvdata *drvdata = (struct ssi_drvdata *)devarg;
>> -     void __iomem *cc_base = drvdata->cc_base;
>>       struct ssi_request_mgr_handle *request_mgr_handle =
>>                                               drvdata->request_mgr_handle;
>>
>> @@ -529,12 +525,16 @@ static void comp_handler(unsigned long devarg)
>>       irq = (drvdata->irq & SSI_COMP_IRQ_MASK);
>>
>>       if (irq & SSI_COMP_IRQ_MASK) {
>> -             /* To avoid the interrupt from firing as we unmask it, we clear it now */
>> -             CC_HAL_WRITE_REGISTER(CC_REG(HOST_ICR), SSI_COMP_IRQ_MASK);
>> +             /* To avoid the interrupt from firing as we unmask it,
>> +              * we clear it now
>> +              */
>> +             cc_iowrite(drvdata, CC_REG(HOST_ICR), SSI_COMP_IRQ_MASK);
>>
>> -             /* Avoid race with above clear: Test completion counter once more */
>> +             /* Avoid race with above clear: Test completion counter
>> +              * once more
>> +              */
>>               request_mgr_handle->axi_completed +=
>> -                             cc_axi_comp_count(cc_base);
>> +                             cc_axi_comp_count(drvdata);
>>
>>               while (request_mgr_handle->axi_completed) {
>>                       do {
>> @@ -543,20 +543,21 @@ static void comp_handler(unsigned long devarg)
>>                                * request_mgr_handle->axi_completed is 0.
>>                                */
>>                               request_mgr_handle->axi_completed =
>> -                                             cc_axi_comp_count(cc_base);
>> +                                             cc_axi_comp_count(drvdata);
>
> I can't easily see why you are making this change. Is this more than one
> thing per patch?
>
>>                       } while (request_mgr_handle->axi_completed > 0);
>>
>> -                     /* To avoid the interrupt from firing as we unmask it, we clear it now */
>> -                     CC_HAL_WRITE_REGISTER(CC_REG(HOST_ICR), SSI_COMP_IRQ_MASK);
>> +                     cc_iowrite(drvdata, CC_REG(HOST_ICR),
>> +                                SSI_COMP_IRQ_MASK);
>>
>> -                     /* Avoid race with above clear: Test completion counter once more */
>>                       request_mgr_handle->axi_completed +=
>> -                                     cc_axi_comp_count(cc_base);
>> +                                     cc_axi_comp_count(drvdata);
>
> And here again.
>
>>               }
>>       }
>> -     /* after verifing that there is nothing to do, Unmask AXI completion interrupt */
>> -     CC_HAL_WRITE_REGISTER(CC_REG(HOST_IMR),
>> -                           CC_HAL_READ_REGISTER(CC_REG(HOST_IMR)) & ~irq);
>> +     /* after verifing that there is nothing to do,
>> +      * unmask AXI completion interrupt
>> +      */
>> +     cc_iowrite(drvdata, CC_REG(HOST_IMR),
>> +                cc_ioread(drvdata, CC_REG(HOST_IMR)) & ~irq);
>>  }
>>
>>  /*
>> diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
>> index b5bc5f8..5d39f15 100644
>> --- a/drivers/staging/ccree/ssi_sysfs.c
>> +++ b/drivers/staging/ccree/ssi_sysfs.c
>> @@ -29,18 +29,17 @@ static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
>>  {
>>       struct ssi_drvdata *drvdata = sys_get_drvdata();
>>       u32 register_value;
>> -     void __iomem *cc_base = drvdata->cc_base;
>>       int offset = 0;
>>
>> -     register_value = CC_HAL_READ_REGISTER(CC_REG(HOST_SIGNATURE));
>> +     register_value = cc_ioread(drvdata, CC_REG(HOST_SIGNATURE));
>>       offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ", DX_HOST_SIGNATURE_REG_OFFSET, register_value);
>> -     register_value = CC_HAL_READ_REGISTER(CC_REG(HOST_IRR));
>> +     register_value = cc_ioread(drvdata, CC_REG(HOST_IRR));
>>       offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ", DX_HOST_IRR_REG_OFFSET, register_value);
>> -     register_value = CC_HAL_READ_REGISTER(CC_REG(HOST_POWER_DOWN_EN));
>> +     register_value = cc_ioread(drvdata, CC_REG(HOST_POWER_DOWN_EN));
>>       offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ", DX_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
>> -     register_value =  CC_HAL_READ_REGISTER(CC_REG(AXIM_MON_ERR));
>> +     register_value =  cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
>>       offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ", DX_AXIM_MON_ERR_REG_OFFSET, register_value);
>> -     register_value = CC_HAL_READ_REGISTER(CC_REG(DSCRPTR_QUEUE_CONTENT));
>> +     register_value = cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
>>       offset += scnprintf(buf + offset, PAGE_SIZE - offset, "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT", DX_DSCRPTR_QUEUE_CONTENT_REG_OFFSET, register_value);
>>       return offset;
>>  }
>> --
>> 2.7.4
>>
>> _______________________________________________
>> devel mailing list
>> devel@linuxdriverproject.org
>> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
>
> hope this helps,
> Tobin.



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
