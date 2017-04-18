From: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
Subject: [PATCH 0/4] staging: add ccree crypto driver
Date: Tue, 18 Apr 2017 17:07:50 +0300
Message-ID: <1492524470-13847-1-git-send-email-gilad@benyossef.com>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gilad.benyossef-5wv7dgnIgG8@public.gmane.org,
        Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Arm TrustZone CryptoCell 700 is a family of cryptographic hardware
accelerators. It is supported by a long lived series of out of tree
drivers, which I am now in the process of unifying and upstreaming.
This is the first drop, supporting the new CryptoCell 712 REE. 

The code still needs some cleanup before maturing to a proper
upstream driver, which I am in the process of doing. However,
as discussion of some of the capabilities of the hardware and
its application to some dm-crypt and dm-verity features recently
took place I though it is better to do this in the open via the
staging tree.

A Git repository based off of Linux 4.11-rc7 is available at
https://github.com/gby/linux.git branch ccree.

Signed-off-by: Gilad Ben-Yossef <gilad-6S/DczAoZh3WXxRugSxzZg@public.gmane.org>
CC: Binoy Jayan <binoy.jayan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
CC: Ofir Drang <ofir.drang-5wv7dgnIgG8@public.gmane.org>

Gilad Ben-Yossef (4):
  staging: add ccree crypto driver
  staging: ccree: add TODO list
  staging: ccree: add devicetree bindings
  MAINTAINERS: add Gilad BY as maintainer for ccree

 .../devicetree/bindings/crypto/arm-cryptocell.txt  |   23 +
 MAINTAINERS                                        |    8 +
 drivers/staging/Kconfig                            |    2 +
 drivers/staging/Makefile                           |    2 +-
 drivers/staging/ccree/Kconfig                      |   52 +
 drivers/staging/ccree/Makefile                     |    3 +
 drivers/staging/ccree/TODO                         |   27 +
 drivers/staging/ccree/bsp.h                        |   21 +
 drivers/staging/ccree/cc_bitops.h                  |   62 +
 drivers/staging/ccree/cc_crypto_ctx.h              |  299 +++
 drivers/staging/ccree/cc_hal.h                     |   35 +
 drivers/staging/ccree/cc_hw_queue_defs.h           |  603 +++++
 drivers/staging/ccree/cc_lli_defs.h                |   57 +
 drivers/staging/ccree/cc_pal_log.h                 |  188 ++
 drivers/staging/ccree/cc_pal_log_plat.h            |   33 +
 drivers/staging/ccree/cc_pal_types.h               |   97 +
 drivers/staging/ccree/cc_pal_types_plat.h          |   29 +
 drivers/staging/ccree/cc_regs.h                    |  106 +
 drivers/staging/ccree/dx_crys_kernel.h             |  180 ++
 drivers/staging/ccree/dx_env.h                     |  224 ++
 drivers/staging/ccree/dx_host.h                    |  155 ++
 drivers/staging/ccree/dx_reg_base_host.h           |   34 +
 drivers/staging/ccree/dx_reg_common.h              |   26 +
 drivers/staging/ccree/hash_defs.h                  |   78 +
 drivers/staging/ccree/hw_queue_defs_plat.h         |   43 +
 drivers/staging/ccree/ssi_aead.c                   | 2832 ++++++++++++++++++++
 drivers/staging/ccree/ssi_aead.h                   |  120 +
 drivers/staging/ccree/ssi_buffer_mgr.c             | 1876 +++++++++++++
 drivers/staging/ccree/ssi_buffer_mgr.h             |  105 +
 drivers/staging/ccree/ssi_cipher.c                 | 1503 +++++++++++
 drivers/staging/ccree/ssi_cipher.h                 |   89 +
 drivers/staging/ccree/ssi_config.h                 |   61 +
 drivers/staging/ccree/ssi_driver.c                 |  557 ++++
 drivers/staging/ccree/ssi_driver.h                 |  228 ++
 drivers/staging/ccree/ssi_fips.c                   |   65 +
 drivers/staging/ccree/ssi_fips.h                   |   70 +
 drivers/staging/ccree/ssi_fips_data.h              |  315 +++
 drivers/staging/ccree/ssi_fips_ext.c               |   96 +
 drivers/staging/ccree/ssi_fips_ll.c                | 1681 ++++++++++++
 drivers/staging/ccree/ssi_fips_local.c             |  369 +++
 drivers/staging/ccree/ssi_fips_local.h             |   77 +
 drivers/staging/ccree/ssi_hash.c                   | 2751 +++++++++++++++++++
 drivers/staging/ccree/ssi_hash.h                   |  101 +
 drivers/staging/ccree/ssi_ivgen.c                  |  301 +++
 drivers/staging/ccree/ssi_ivgen.h                  |   72 +
 drivers/staging/ccree/ssi_pm.c                     |  150 ++
 drivers/staging/ccree/ssi_pm.h                     |   46 +
 drivers/staging/ccree/ssi_pm_ext.c                 |   60 +
 drivers/staging/ccree/ssi_pm_ext.h                 |   33 +
 drivers/staging/ccree/ssi_request_mgr.c            |  713 +++++
 drivers/staging/ccree/ssi_request_mgr.h            |   60 +
 drivers/staging/ccree/ssi_sram_mgr.c               |  138 +
 drivers/staging/ccree/ssi_sram_mgr.h               |   80 +
 drivers/staging/ccree/ssi_sysfs.c                  |  440 +++
 drivers/staging/ccree/ssi_sysfs.h                  |   54 +
 55 files changed, 17429 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
 create mode 100644 drivers/staging/ccree/Kconfig
 create mode 100644 drivers/staging/ccree/Makefile
 create mode 100644 drivers/staging/ccree/TODO
 create mode 100644 drivers/staging/ccree/bsp.h
 create mode 100644 drivers/staging/ccree/cc_bitops.h
 create mode 100644 drivers/staging/ccree/cc_crypto_ctx.h
 create mode 100644 drivers/staging/ccree/cc_hal.h
 create mode 100644 drivers/staging/ccree/cc_hw_queue_defs.h
 create mode 100644 drivers/staging/ccree/cc_lli_defs.h
 create mode 100644 drivers/staging/ccree/cc_pal_log.h
 create mode 100644 drivers/staging/ccree/cc_pal_log_plat.h
 create mode 100644 drivers/staging/ccree/cc_pal_types.h
 create mode 100644 drivers/staging/ccree/cc_pal_types_plat.h
 create mode 100644 drivers/staging/ccree/cc_regs.h
 create mode 100644 drivers/staging/ccree/dx_crys_kernel.h
 create mode 100644 drivers/staging/ccree/dx_env.h
 create mode 100644 drivers/staging/ccree/dx_host.h
 create mode 100644 drivers/staging/ccree/dx_reg_base_host.h
 create mode 100644 drivers/staging/ccree/dx_reg_common.h
 create mode 100644 drivers/staging/ccree/hash_defs.h
 create mode 100644 drivers/staging/ccree/hw_queue_defs_plat.h
 create mode 100644 drivers/staging/ccree/ssi_aead.c
 create mode 100644 drivers/staging/ccree/ssi_aead.h
 create mode 100644 drivers/staging/ccree/ssi_buffer_mgr.c
 create mode 100644 drivers/staging/ccree/ssi_buffer_mgr.h
 create mode 100644 drivers/staging/ccree/ssi_cipher.c
 create mode 100644 drivers/staging/ccree/ssi_cipher.h
 create mode 100644 drivers/staging/ccree/ssi_config.h
 create mode 100644 drivers/staging/ccree/ssi_driver.c
 create mode 100644 drivers/staging/ccree/ssi_driver.h
 create mode 100644 drivers/staging/ccree/ssi_fips.c
 create mode 100644 drivers/staging/ccree/ssi_fips.h
 create mode 100644 drivers/staging/ccree/ssi_fips_data.h
 create mode 100644 drivers/staging/ccree/ssi_fips_ext.c
 create mode 100644 drivers/staging/ccree/ssi_fips_ll.c
 create mode 100644 drivers/staging/ccree/ssi_fips_local.c
 create mode 100644 drivers/staging/ccree/ssi_fips_local.h
 create mode 100644 drivers/staging/ccree/ssi_hash.c
 create mode 100644 drivers/staging/ccree/ssi_hash.h
 create mode 100644 drivers/staging/ccree/ssi_ivgen.c
 create mode 100644 drivers/staging/ccree/ssi_ivgen.h
 create mode 100644 drivers/staging/ccree/ssi_pm.c
 create mode 100644 drivers/staging/ccree/ssi_pm.h
 create mode 100644 drivers/staging/ccree/ssi_pm_ext.c
 create mode 100644 drivers/staging/ccree/ssi_pm_ext.h
 create mode 100644 drivers/staging/ccree/ssi_request_mgr.c
 create mode 100644 drivers/staging/ccree/ssi_request_mgr.h
 create mode 100644 drivers/staging/ccree/ssi_sram_mgr.c
 create mode 100644 drivers/staging/ccree/ssi_sram_mgr.h
 create mode 100644 drivers/staging/ccree/ssi_sysfs.c
 create mode 100644 drivers/staging/ccree/ssi_sysfs.h

-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
