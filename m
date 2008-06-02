From: Adrian-Ken Rueegsegger <rueegsegger@swiss-it.ch>
Subject: [RFC PATCH] [XFRM] xfrm_algo: correct usage of RIPEMD-160
Date: Mon,  2 Jun 2008 11:33:08 +0200
Message-ID: <1212399189188-git-send-email-rueegsegger@swiss-it.ch>
Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zux006-004-203.adsl.green.ch ([81.6.4.203]:53153 "EHLO
	mailx.swiss-it.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYFBJdM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 05:33:12 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes HMAC-RIPEMD-160 usable with IPsec/XFRM. The RIPEMD-160
implementation is currently in the cryptodev-2.6 tree.

Since I have no IPsec test setup the patch has not (yet) been tested with
IPsec and is thus marked as RFC. I will put together a test environment which
will take some time. In the meantime it would be great if somebody who already
has a working IPsec environment could test this patch.

Thanks,
Adrian

