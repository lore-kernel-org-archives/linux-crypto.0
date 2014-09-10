From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/3] crypto: qat: Qat driver fixes.
Date: Wed, 10 Sep 2014 14:07:20 -0700
Message-ID: <20140910210559.25455.16693.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, bruce.w.allan@intel.com, qat-linux@intel.com,
	conor.mcloughlin@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:19980 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720AbaIJVIr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Sep 2014 17:08:47 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
Updates for the qat driver.
First patch enables all 32 IRQs by default.
Second fixes a typo of tasklet variable.
Third removes extra buffers for HW state for partial requests.
---

Tadeusz Struk (3):
      crypto: qat: Enable all 32 IRQs
      crypto: qat: Fix typo in name of tasklet_struct
      crypto: qat: Removed unneeded partial state


 .../crypto/qat/qat_common/adf_transport_internal.h |    2 -
 drivers/crypto/qat/qat_common/qat_algs.c           |   66 ++------------------
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.h |    2 -
 drivers/crypto/qat/qat_dh895xcc/adf_isr.c          |    8 +-
 4 files changed, 13 insertions(+), 65 deletions(-)

-- 
