From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: crypto: qat - Intel(R) QAT transport code
Date: Tue, 2 Dec 2014 15:21:40 +0300
Message-ID: <20141202122140.GA15748@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21347 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbaLBMWB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 07:22:01 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Tadeusz Struk,

The patch a672a9dc872e: "crypto: qat - Intel(R) QAT transport code"
from Jun 5, 2014, leads to the following static checker warning:

	drivers/crypto/qat/qat_common/adf_transport.c:412 adf_init_bank()
	error: potentially using uninitialized 'coalesc_enabled'.

drivers/crypto/qat/qat_common/adf_transport.c
   407          /* Enable IRQ coalescing always. This will allow to use
   408           * the optimised flag and coalesc register.
   409           * If it is disabled in the config file just use min time value */
   410          if (adf_get_cfg_int(accel_dev, "Accelerator0",
   411                              ADF_ETRMGR_COALESCING_ENABLED_FORMAT,
   412                              bank_num, &coalesc_enabled) && coalesc_enabled)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This condition is reversed, so it only enables coalescing on error.

Probably this feature has not been tested yet.

   413                  adf_enable_coalesc(bank, "Accelerator0", bank_num);
   414          else
   415                  bank->irq_coalesc_timer = ADF_COALESCING_MIN_TIME;
   416  

regards,
dan carpenter
