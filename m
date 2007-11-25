From: Mikko Herranen <mikko.herranen@cs.helsinki.fi>
Subject: [PATCH 0/2] Add GCM/GMAC support to cryptoapi
Date: Sun, 25 Nov 2007 16:22:53 +0200 (EET)
Message-ID: <Pine.LNX.4.64.0711251601100.3663@antarct>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pne-smtpout3-sn2.hy.skanova.net ([81.228.8.111]:60805 "EHLO
	pne-smtpout3-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbXKYOX3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 25 Nov 2007 09:23:29 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These patches add GCM/GMAC support to the cryptoapi.

The first patch adds AEAD support to tcrypt, as it's currently not
possible to do combined encryption/authentication tests. The
second patch adds GCM to cryptoapi.

-- 
Mikko Herranen
