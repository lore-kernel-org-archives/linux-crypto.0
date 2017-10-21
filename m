From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 0/3] crypto-ansi_cprng: Fine-tuning for three function
 implementations
Date: Sat, 21 Oct 2017 19:12:52 +0200
Message-ID: <d284473a-b968-2b3e-9147-1c8598a26f7c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:63344 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932180AbdJUROJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Oct 2017 13:14:09 -0400
Content-Language: en-GB
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 21 Oct 2017 19:06:54 +0200

Two update suggestions were taken into account
from static source code analysis.

Markus Elfring (3):
  Use common error handling code in get_prng_bytes()
  Delete two variable assignments in get_prng_bytes()
  Delete unnecessary blank lines

 crypto/ansi_cprng.c | 47 ++++++++++++++++++-----------------------------
 1 file changed, 18 insertions(+), 29 deletions(-)

-- 
2.14.2
