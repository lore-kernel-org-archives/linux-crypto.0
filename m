From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: algif_hash bug?
Date: Fri, 8 Jan 2016 14:55:14 -0600
Message-ID: <56902232.2010309@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0057.outbound.protection.outlook.com ([207.46.100.57]:51751
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755611AbcAHUzd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jan 2016 15:55:33 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert,

AF_ALG hash supports the accept() call to allow for partial hash states
to be cloned. If an accept() is issued against a socket before ever
doing a send(), crypto_ahash_init() will never have been called for the
original socket.  The hash_accept function in algif_hash will call
crypto_ahash_export() which will return an uninitialized request context
and then use that for import into the new socket. A problem arises here
because hash_accept sets the 'more' bit of the new context to 1
(ctx2->more = 1). This will cause the first send() call for the new
socket to skip calling crypto_ahash_init() which can result in an
error or oops because the request context for the cloned socket was
never initialized.

Is it assumed that the accept() call should only ever be made after
having issued at least one send()? Should the ctx2->more value be the
value from the original context so that crypto_ahash_init() is called
when needed?

Thanks,
Tom
