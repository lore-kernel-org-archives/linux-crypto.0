From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 0/1] omap-sham: use prefetch mechanism to increase transfer speed
Date: Thu,  2 Sep 2010 17:17:34 +0300
Message-ID: <cover.1283436919.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:19046 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab0IBOR0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Sep 2010 10:17:26 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Samu Onkalo (1):
  crypto: omap-sham: Adjust DMA parameters

 drivers/crypto/omap-sham.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)
