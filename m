From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/2] crypto-testmgr: Fine-tuning for drbg_cavs_test()
Date: Sat, 21 Oct 2017 19:52:23 +0200
Message-ID: <7c2b4df8-a04b-cacd-13ba-4d9afb346263@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:59355 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932196AbdJURwj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Oct 2017 13:52:39 -0400
Content-Language: en-GB
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 21 Oct 2017 19:47:43 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (2):
  Use common error handling code
  Delete an unnecessary variable initialisation

 crypto/testmgr.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

-- 
2.14.2
