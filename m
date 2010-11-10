From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: [PATCH 0/4]v2 omap-sham off mode and error handling fixes.
Date: Wed, 10 Nov 2010 19:36:35 +0200
Message-ID: <cover.1289410468.git.dmitry.kasatkin@nokia.com>
Cc: linux-crypto@vger.kernel.org, linux-omap@vger.kernel.org
To: herbert@gondor.hengli.com.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:62852 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab0KJRhI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Nov 2010 12:37:08 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Please ignore previous patch set.
Some old patches appeared there...

Dmitry Kasatkin (4):
  omap-sham: uses digest buffer in request context
  omap-sham: DMA initialization fixes for off mode
  omap-sham: error handling improved
  omap-sham: removed redundunt locking

 drivers/crypto/omap-sham.c |  144 +++++++++++++++++++++++++-------------------
 1 files changed, 83 insertions(+), 61 deletions(-)
