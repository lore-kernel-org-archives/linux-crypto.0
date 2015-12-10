From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: crypto: qat - add support for new devices to FW loader
Date: Fri, 11 Dec 2015 01:03:04 +0300
Message-ID: <20151210220304.GB21797@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qat-linux@intel.com, linux-crypto@vger.kernel.org
To: pingchao.yang@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30719 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbLJWDQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 17:03:16 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Pingchao Yang,

The patch b0272276d903: "crypto: qat - add support for new devices to
FW loader" from Dec 4, 2015, leads to the following static checker
warning:

	drivers/crypto/qat/qat_common/qat_hal.c:421 qat_hal_check_ae_active()
	warn: bitwise AND condition is false here

drivers/crypto/qat/qat_common/qat_hal.c
   414  int qat_hal_check_ae_active(struct icp_qat_fw_loader_handle *handle,
   415                              unsigned int ae)
   416  {
   417          unsigned int enable = 0, active = 0;
   418  
   419          qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &enable);
   420          qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS, &active);
   421          if ((enable & (0xff >> CE_ENABLE_BITPOS)) ||
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Never true.
CE_ENABLE_BITPOS is 8.
Perhaps the intention was to left shift like we do with ACS_ABO_BITPOS
on the next line?

   422              (active & (1 << ACS_ABO_BITPOS)))
   423                  return 1;
   424          else
   425                  return 0;
   426  }

regards,
dan carpenter
