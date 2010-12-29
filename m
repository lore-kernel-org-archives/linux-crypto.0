From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 0/1] crypto: omap-sham backlog handling fix
Date: Wed, 29 Dec 2010 11:58:27 +0200
Message-ID: <cover.1293616613.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:64170 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962Ab0L2J6l (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Dec 2010 04:58:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Please take this important fix.

- Dmitry


Dmitry Kasatkin (1):
  omap-sham: backlog handling fix

 drivers/crypto/omap-sham.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)
