From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: crypto-caamhash: Fine-tuning for several function implementations
Date: Thu, 15 Sep 2016 16:36:35 +0200
Message-ID: <970e9e1b-c1dc-eb28-b380-92c15e9b1961@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Labbe Corentin <clabbe.montjoie@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:53586 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751681AbcIOOhH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 10:37:07 -0400
In-Reply-To: <566ABCD9.1060404@users.sourceforge.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 15 Sep 2016 16:27:23 +0200

Some update suggestions were taken into account
from static source code analysis.

Markus Elfring (6):
  Use kmalloc_array() in ahash_setkey()
  Rename jump labels in ahash_setkey()
  Rename a jump label in five functions
  Return a value directly in caam_hash_cra_init()
  Delete an unnecessary initialisation in seven functions
  Move common error handling code in two functions

 drivers/crypto/caam/caamhash.c | 111 +++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 59 deletions(-)

-- 
2.10.0
