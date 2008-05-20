From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [PATCH 0/3] [CRYPTO] ripemd: Fix endian issues
Date: Tue, 20 May 2008 21:49:49 +0200
Message-ID: <1211312992-6439-1-git-send-email-rueegsegger@swiss-it.ch>
Cc: sebastian@breakpoint.cc, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:51075 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677AbYETTtz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 May 2008 15:49:55 -0400
In-Reply-To: <>
References: <>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

These patches fix the endian issues reported by Sebastian Siewior for
the three remaining RIPEMD modules rmd160, rmd256 and rmd320.

 crypto/rmd160.c |   37 +++++++++----------------------------
 crypto/rmd256.c |   37 +++++++++----------------------------
 crypto/rmd320.c |   37 +++++++++----------------------------
 3 files changed, 27 insertions(+), 84 deletions(-)


