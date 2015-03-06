From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/2] crypto: Documentation - add AF_ALG to DocBook
Date: Fri, 06 Mar 2015 21:33:41 +0100
Message-ID: <1463694.oXIsepBPWM@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

the AF_ALG interface description is added to the kernel crypto API
DocBook. It is extended by the newly added AEAD and RNG interfaces.

An example of the documentation can be viewed at [1].

[1] http://www.chronox.de/crypto-API/User.html

Stephan Mueller (2):
  crypto: Documentation - AEAD / RNG AF_ALG interface
  MAINTAINERS: add crypto-API.tmpl

 Documentation/DocBook/crypto-API.tmpl         | 596 ++++++++++++++++++++++++++
 Documentation/crypto/crypto-API-userspace.txt | 205 ---------
 MAINTAINERS                                   |   1 +
 3 files changed, 597 insertions(+), 205 deletions(-)
 delete mode 100644 Documentation/crypto/crypto-API-userspace.txt

-- 
2.1.0
