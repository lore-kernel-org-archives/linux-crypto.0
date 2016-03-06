From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 0/3] crypto: af_alg - add TLS type encryption
Date: Sat, 05 Mar 2016 17:20:44 -0800
Message-ID: <20160306012044.6369.63924.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	davem@davemloft.net, tadeusz.struk@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54193 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbcCFBZP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Mar 2016 20:25:15 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
The following series adds TLS type authentication. To do this a new
template, encauth, is introduced. It is derived from the existing authenc
template and modified to work in "first auth then encrypt" mode.
The algif interface is also changed to work with the new authentication type.

---

Tadeusz Struk (3):
      crypto: authenc - add TLS type encryption
      crypto: af_alg - add AEAD operation type
      crypto: algif_aead - modify algif aead interface to work with encauth


 crypto/Makefile             |    2 
 crypto/af_alg.c             |    6 +
 crypto/algif_aead.c         |   93 +++++++-
 crypto/encauth.c            |  510 +++++++++++++++++++++++++++++++++++++++++++
 include/crypto/if_alg.h     |    1 
 include/uapi/linux/if_alg.h |    4 
 6 files changed, 601 insertions(+), 15 deletions(-)
 create mode 100644 crypto/encauth.c

--
