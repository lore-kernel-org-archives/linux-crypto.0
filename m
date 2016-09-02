From: Quentin Lambert <lambert.quentin@gmail.com>
Subject: [PATCH 0/2] add omitted release in qat_common
Date: Fri,  2 Sep 2016 16:37:57 +0200
Message-ID: <20160902143759.31125-1-lambert.quentin@gmail.com>
Cc: kernel-janitors@vger.kernel.org
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Salvatore Benedetto <salvatore.benedetto@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quentin Lambert <lambert.quentin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:32801 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751496AbcIBOiH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2016 10:38:07 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The first patch introduces a variable to handle different error codes and be
able to reuse the same clean up code. The second add an omitted release by
jumping to the clean code having set the returned value to the proper error
code.

---
 drivers/crypto/qat/qat_common/qat_uclo.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)
---
