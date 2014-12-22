From: Marcel Holtmann <marcel@holtmann.org>
Subject: Using separate initcall level for crypto subsystem
Date: Mon, 22 Dec 2014 10:46:47 -0800
Message-ID: <EB9C4333-B282-4D94-9713-C986F1B7E931@holtmann.org>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Johan Hedberg <johan.hedberg@gmail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59985 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754322AbaLVSqz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Dec 2014 13:46:55 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

we wanted to add some crypto selftests to the Bluetooth subsystem that checks our usage of the crypto handling we use for Bluetooth Low Energy Legacy Pairing and Secure Connections.

Since the Crypto subsystem and Bluetooth subsystem both use subsys_initcall that goes horrible wrong when running it built-in. So I wonder if it would make sense to introduce a crypto_initcall that comes before the subsys_initcall.

Any thoughts on this?

Regards

Marcel
