From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/2] crypto: drbg: performance improvements
Date: Sun, 01 Mar 2015 20:38:12 +0100
Message-ID: <50904620.OAA2OAojed@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: 'Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36248 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbbCATkd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Mar 2015 14:40:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The following patches increase the performance of the CTR DRBG and Hash
DRBG.

The updates successfully pass the CAVS testing. for Hash DRBG and CTR
DRBG.

Stephan Mueller (2):
  crypto: drbg: use single block cipher API
  crypto: drbg: remove superflowous memsets

 crypto/drbg.c | 57 ++++++++++++++++-----------------------------------------
 1 file changed, 16 insertions(+), 41 deletions(-)

-- 
2.1.0
