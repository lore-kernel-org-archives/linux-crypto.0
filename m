From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Non-destructive ChaCha20Poly1305 Decryption
Date: Fri, 22 Jan 2016 13:19:38 +0100
Message-ID: <CAHmME9qvEFzWG3ds_gZr0A56QdXFVcgu6XSKhxgYSWY7RA5T5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: martin@strongswan.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:35125 "EHLO frisell.zx2c4.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbcAVMTn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jan 2016 07:19:43 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id f0bdc2f0
	for <linux-crypto@vger.kernel.org>;
	Fri, 22 Jan 2016 12:18:40 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f4a128ea
	TLS version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=YES
	for <linux-crypto@vger.kernel.org>;
	Fri, 22 Jan 2016 12:18:39 +0000 (UTC)
Received: by mail-wm0-f45.google.com with SMTP id n5so129273552wmn.0
        for <linux-crypto@vger.kernel.org>; Fri, 22 Jan 2016 04:19:40 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Martin,

Your ChaCha20Poly1305 implementation when decrypting calls chacha20
decryption before it verifies the auth tag. Not only does this waste
CPU cycles, but it makes it impossible to attempt decryption of cipher
texts using different keys (until one is right) without creating a
copy, which is unfortunate. (It also is one of the nice benefits of
EtM.) Would you consider reversing the order of these operations? That
is -- not performing the chacha20 step if the poly1305 tag does not
verify?

Thanks,
Jason
