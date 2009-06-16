From: Erik Lotspeich <erik@lotspeich.org>
Subject: Question about error codes
Date: Tue, 16 Jun 2009 11:47:15 -0500
Message-ID: <4A37CC93.8040905@lotspeich.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@redhat.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.lotspeich.org ([75.76.192.54]:47481 "EHLO
	starfish.lotspeich.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255AbZFPRqB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2009 13:46:01 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

I have a question about the meaning of the error codes returned by the
Linux kernel crypto API.  In particular, I am interested in the codes
returned by crypto_ablkcipher_encrypt() & crypto_ablkcipher_decrypt().
I am receiving a return value of 22 from crypto_ablkcipher_encrypt.  I
would like to find what this means.  I don't get this error code
consistently, so I'm trying to find out if I am using the API
incorrectly; I'm using the test code, tcrypt.c, as a guide.

I looked through the source, but it was not obvious in the code where
these error codes were coming from; I did not see them enumerated in a
header file either.

Any help would be greatly appreciated.

Regards,

Erik
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAko3zJMACgkQY21D/n6bGwc6QACgoXNEKl1xWtADpXzBexeJfokT
N4cAoJdEElT7Ko1sjEoPfxkh5DCg14YD
=2kfv
-----END PGP SIGNATURE-----
