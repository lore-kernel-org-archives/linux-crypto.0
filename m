From: Matthias-Christian Ott <ott@mirix.org>
Subject: Why does CRYPTO_USER require CAP_NET_ADMIN?
Date: Sat, 05 Apr 2014 16:43:44 +0200
Message-ID: <534016A0.6020702@mirix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from a.mirix.org ([78.46.130.147]:47003 "EHLO a.mirix.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaDEPHX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Apr 2014 11:07:23 -0400
Received: from [2003:5c:ad4d:eb00:81e4:224d:b76e:6be9]
	by a.mirix.org with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <ott@mirix.org>)
	id 1WWRoD-0006ih-F3
	for linux-crypto@vger.kernel.org; Sat, 05 Apr 2014 16:43:01 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If I'm not mistaken, CRYPTO_USER requires CAP_NET_ADMIN for all
requests. Is there any reason for this requirement for read-only requests?

I think read-only requests should not require CAP_NET_ADMIN. An example
where this is important is important is AF_ALG. I'm working on AF_ALG
support for GnuTLS, encryption and decryption via AF_ALG does not
require special capabilities. However, retrieving the cipher priority to
determine whether the cipher is hardware accelerated does require
CAP_NET_ADMIN.

Regards,
Matthias-Christian
