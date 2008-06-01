From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [RFC PATCH] [XFRM] xfrm_algo: correct usage of RIPEMD-160
Date: Sun,  1 Jun 2008 19:16:17 +0200
Message-ID: <1212340578-15574-1-git-send-email-rueegsegger@swiss-it.ch>
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:57604 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYFARQV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 1 Jun 2008 13:16:21 -0400
In-Reply-To: <>
References: <>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes HMAC-RIPEMD-160 usable with IPsec/XFRM.

Since I have no IPsec test setup the patch has not (yet) been tested with
IPsec and is thus marked as RFC. I will put together a test environment which
will take some time. In the meantime it would be great if somebody who already
has a working IPsec environment could test this patch.

-Adrian

