From: Francis Moreau <francis.moro@gmail.com>
Subject: question about crypto module dependency
Date: Tue, 17 Jan 2012 19:34:25 +0100
Message-ID: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35102 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab2AQSe0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jan 2012 13:34:26 -0500
Received: by bkas6 with SMTP id s6so1979256bka.19
        for <linux-crypto@vger.kernel.org>; Tue, 17 Jan 2012 10:34:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I'm wondering how this scenario is supposed to work: let's say a
module A uses 'crc32c' function in lib/libcrc32c.c. In its turn this
function calls crypto_shash_update() which is exported by
crypto/shash.c. But now no module implementing "crc32c" has still been
loaded although crc32c.ko is available. Therefore the initial load of
module A fails although all required modules by the system are
present.

If the above is correct, how should it be handled ?

Thanks
-- 
Francis
