From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Subject: CONFIG_CRYPTO_PCRYPT, CONFIG_CRYPTO_CRYPTD etc. questions
Date: Sun, 9 Oct 2011 01:00:08 +0200
Message-ID: <CAGmahrQ5YC0UynzyjzMcvunh_UgKo-OMF6A9PM_nD3w12hrM2Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36542 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1JHXAI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 8 Oct 2011 19:00:08 -0400
Received: by pzk1 with SMTP id 1so12749107pzk.1
        for <linux-crypto@vger.kernel.org>; Sat, 08 Oct 2011 16:00:08 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hey,

how do they work? Should one use them? Does it work with all ciphers?
Do they exclude each other?

Do they need module parameters? What if they are built-in? How can I
verify that they work?
How do they work? There is absolutely no fucking information
whatsoever, neither in the help text nor in the docs. Am i missing
something?

Talking mostly about typical disk encryption on SMP machines via
dm-crypt, interested in best performance. (without AES-NI)
