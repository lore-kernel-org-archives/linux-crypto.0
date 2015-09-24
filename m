From: pavi1729 <pavitra1729@gmail.com>
Subject: crypto_cbc_encrypt query
Date: Thu, 24 Sep 2015 20:06:34 +0530
Message-ID: <CAMf7+Lhk9E-PKtpA5TyrU9hGz1RviLQ062y5gFmnTD15LAyQdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33717 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbIXOgf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Sep 2015 10:36:35 -0400
Received: by iofh134 with SMTP id h134so78507886iof.0
        for <linux-crypto@vger.kernel.org>; Thu, 24 Sep 2015 07:36:35 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
  Shouldn't "walk" be memset ?

FILE:            crypto/cbc.c
FUNCTION:  crypto_cbc_encrypt

"walk" is local variable and its uninitialized in
"crypto_cbc_encrypt". The same is passed to
"blkcipher_walk_virt" which does below

walk->flags &= ~BLKCIPHER_WALK_PHYS;

So neither 'walk' nor 'walk->flags' is memset or init to a proper value.

Thanks,
Pavi
