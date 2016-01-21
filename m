From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: GPF in ChaCha20 SSSE3 Implementation
Date: Thu, 21 Jan 2016 18:28:31 +0100
Message-ID: <CAHmME9rENo1wKVpTzFv7TcMcgFEjBhF6xFDs3X2pKtsCXM2Bog@mail.gmail.com>
References: <CAHmME9r9QGqJE__dfzuypW87Kyy1g3i4BbWnZD+NPAchK_TmMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: martin@strongswan.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from frisell.zx2c4.com ([192.95.5.64]:36102 "EHLO frisell.zx2c4.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbcAUR2f (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Jan 2016 12:28:35 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d40a75af
	for <linux-crypto@vger.kernel.org>;
	Thu, 21 Jan 2016 17:27:33 +0000 (UTC)
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a7d63e66
	TLS version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=YES
	for <linux-crypto@vger.kernel.org>;
	Thu, 21 Jan 2016 17:27:32 +0000 (UTC)
Received: by mail-wm0-f49.google.com with SMTP id b14so92528119wmb.1
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jan 2016 09:28:33 -0800 (PST)
In-Reply-To: <CAHmME9r9QGqJE__dfzuypW87Kyy1g3i4BbWnZD+NPAchK_TmMA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg17498.html

Eli's patch fixes the issue!

I'd recommend you send this off for stable inclusion, as it's
potentially remotely exploitable.
