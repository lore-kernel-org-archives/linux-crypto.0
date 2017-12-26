From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: [PATCH 0/2] crypto: inside-secure - 2 extra fixes
Date: Tue, 26 Dec 2017 17:21:15 +0100
Message-ID: <20171226162117.4885-1-antoine.tenart@free-electrons.com>
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com,
        gregory.clement@free-electrons.com,
        miquel.raynal@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53379 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750764AbdLZQfF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Dec 2017 11:35:05 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

This series contains two fixes for the Inside Secure SafeXcel crypto
engine driver. The first one removes a warning when the DMA-API debug is
activated and the second one is fixing an issue with the driver in
certain cases where the input length is a multiple of a block size.

Thanks!
Antoine

Antoine Tenart (2):
  crypto: inside-secure - avoid unmapping DMA memory that was not mapped
  crypto: inside-secure - fix hash when length is a multiple of a block

 drivers/crypto/inside-secure/safexcel_hash.c | 54 ++++++++++++++++++----------
 1 file changed, 36 insertions(+), 18 deletions(-)

-- 
2.14.3
