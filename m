From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: crypto_remove_spawns: BUG: unable to handle kernel NULL pointer
	dereference at 0000000000000018
Date: Mon, 15 Feb 2010 09:47:25 +0200
Message-ID: <b6fcc0a1002142347n1aff4326p3275e70b0ecea0e3@mail.gmail.com>
References: <20100214174507.GA8688@x200>
	 <20100215052729.GA17156@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:54433 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886Ab0BOHr0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2010 02:47:26 -0500
Received: by iwn39 with SMTP id 39so1929095iwn.1
        for <linux-crypto@vger.kernel.org>; Sun, 14 Feb 2010 23:47:25 -0800 (PST)
In-Reply-To: <20100215052729.GA17156@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 15, 2010 at 7:27 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Is this reproducible every time you unload aes_x86_64 after boot?

No, what I do is

1. setup ipcomp in tunnel mode _in fresh netns_ and immediately exit
2. modprobe/rmmod all modules (not much)

~1 hour of this workload and it hits sometimes with aes_x86_64,
sometimes with aes_generic.

> Please attach your config file?

Full config later, for now it's ipv4 only, XFRM stuff as modules,
crypto modules as modules, almost all debugging on.
