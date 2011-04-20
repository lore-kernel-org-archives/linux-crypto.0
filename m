From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 0/4] crypto: omap-sham driver fixes
Date: Wed, 20 Apr 2011 13:34:54 +0300
Message-ID: <cover.1303295558.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:32796 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab1DTKeT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2011 06:34:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Here is few patches with couple of important fixes...

Regards,
Dmitry

Dmitry Kasatkin (3):
  crypto: omap-sham - remove debug print
  crypto: omap-sham - enable driver for EMU chips
  crypto: omap-sham - hmac calculation bug fix for sha1 base hash

Markku Kylanpaa (1):
  crypto: omap-sham - fix concurrent sha1 calculations

 drivers/crypto/omap-sham.c |   78 +++++++++++++++++++-------------------------
 1 files changed, 34 insertions(+), 44 deletions(-)
