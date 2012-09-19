From: Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH 0/3] crypto: talitos fixes for 3.6-rc7
Date: Wed, 19 Sep 2012 21:53:37 +0300
Message-ID: <1348080820-22250-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [213.199.154.144] ([213.199.154.144]:1256 "EHLO
	db3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932070Ab2ISP7T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Sep 2012 11:59:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I know these patches come late and might not be included in 3.6.
But two of them are already sitting in cryptodev tree for some time.
(Don't know where my head was :/).

These patches are needed since:
e46e9a crypto: testmgr - add aead cbc aes hmac sha1,256,512 test vectors
made its way in 3.6-rc2 and is exposing two shortcomings of talitos:
- inability to handle non-contiguous assoc data and iv - fixed by 2/3
- inability to handle zero-length assoc data - fixed by 3/3

Patch 1/3 is the same as:
605425 crypto: talitos - fix icv management on outbound direction
from cryptodev tree.

Patch 2/3 is a rewritten version (so it applies cleanly) of:
79fd31 crypto: talitos - support for assoc data provided as scatterlist
from cryptodev tree.

Patch 3/3 is a new patch that covers the unusual case when assoc data length
is zero. It fixes for talitos what
9b2f4c crypto: authenc - Fix crash with zero-length assoc data
from crypto tree fixes for native crypto.
(http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg07662.html)

AFAICT, patches apply cleanly both on crypto and 3.6-rc6 ToT.

Thanks,
Horia

Horia Geanta (3):
  crypto: talitos - fix icv management on outbound direction
  crypto: talitos - support for assoc data provided as scatterlist
  crypto: talitos - corrrectly handle zero-length assoc data

 drivers/crypto/talitos.c |  189 +++++++++++++++++++++++++++++++++-------------
 1 files changed, 137 insertions(+), 52 deletions(-)

-- 
1.7.7.6
