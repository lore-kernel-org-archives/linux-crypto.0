From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: What are the requirements to create/open an AF_ALG socket type?
Date: Sun, 3 Apr 2016 17:11:37 -0400
Message-ID: <CAH8yC8meoP9PwCZsLh12LEg-S=QgzV6us3hQvdyJHuNjEbT3hw@mail.gmail.com>
References: <CAH8yC8mYXDu1M3FoyaS8K_pyECcD60DYJHMWw8Yr3pXCoqeNuA@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:34090 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbcDCVLh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Apr 2016 17:11:37 -0400
Received: by mail-ig0-f177.google.com with SMTP id gy3so4157789igb.1
        for <linux-crypto@vger.kernel.org>; Sun, 03 Apr 2016 14:11:37 -0700 (PDT)
In-Reply-To: <CAH8yC8mYXDu1M3FoyaS8K_pyECcD60DYJHMWw8Yr3pXCoqeNuA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Apr 3, 2016 at 4:42 PM, Jeffrey Walton <noloader@gmail.com> wrote:
> I'm testing userspace crypto code using AF_ALG domain socket. The call
> to 'socket(AF_ALG, SOCK_SEQPACKET, 0)' always fails with errno=2. The
> failure has been experienced on 3.8, 4.1, 4.2 and 4.4 kernels
> (provided by Debian, Fedora, Lubuntu and Ubuntu). I also experienced
> it on a Gentoo kernel, but I don't recall the kernel version. I've
> checked the kernel configs, and they all include
> "CONFIG_CRYPTO_USER_API={y|m}".
>
> When similar code is called from userland using the async crypto gear,
> then the call to socket usually succeeds. During async testing, I also
> see a dmesg about registering a socket family 38. The dmesg is not
> present during the non-async failures.
>
> I also checked the kernel crypto documentation at
> http://www.kernel.org/doc/Documentation/crypto/ and
> http://www.kernel.org/doc/htmldocs/crypto-API/User.html, but I don't
> see a requirement I might be missing. I also checked a couple of slide
> decks introducing the userspace crypto API, and I don't see what the
> presenters are doing differently. Finally, I checked the LVN example
> provided at http://lwn.net/Articles/410848/.
>
> If it matters, I usually disable IPv6 via a boot parameter since I
> don't use it in my environments. But I'm guessing it has nothing to do
> with the problem since the async gear works fine.
>
> What are the requirements to create/open an AF_ALG socket?
>
> Or maybe, what is missing so the call to socket succeeds?

Cancel...My apologies...

The call to bind() was failing after the socket was created.
Mis-identifying socket() was due to a copy/paste of the error logic.

The bind failure was due to .salg_type = "hmac" with .salg_name = "sha512".

Jeff
