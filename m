From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/8] crypto: aead - Convert gcm to new interface
Date: Tue, 16 Jun 2015 13:45:51 +0800
Message-ID: <20150616054551.GA21524@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	horia.geanta@freescale.com, ruchika.gupta@freescale.com,
	cristian.stoica@freescale.com, NiteshNarayanLal@freescale.com,
	jinyanjiang@gmail.com, Kim Phillips <kim.phillips@freescale.com>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38953 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbbFPFp6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 01:45:58 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes since v1:

* Fixed various bugs in caam conversion.

Original description:

This series converts various GCM implementations to the new AEAD
interface.  The main changes are that the IV must no longer be
manually added to the AD for rfc4543, and that both src/dst now
contain space at the head equal to assoclen, but only src has
the actual AD.

Note that I don't have hardware to test anything but generic
GCM and aesni, so you guys will have to test the rest of it
for me.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
