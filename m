From: Jeffrey Walton <noloader@gmail.com>
Subject: What are the requirements to create/open an AF_ALG socket type?
Date: Sun, 3 Apr 2016 16:42:01 -0400
Message-ID: <CAH8yC8mYXDu1M3FoyaS8K_pyECcD60DYJHMWw8Yr3pXCoqeNuA@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33800 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbcDCUmC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Apr 2016 16:42:02 -0400
Received: by mail-ig0-f169.google.com with SMTP id gy3so3603199igb.1
        for <linux-crypto@vger.kernel.org>; Sun, 03 Apr 2016 13:42:01 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'm testing userspace crypto code using AF_ALG domain socket. The call
to 'socket(AF_ALG, SOCK_SEQPACKET, 0)' always fails with errno=2. The
failure has been experienced on 3.8, 4.1, 4.2 and 4.4 kernels
(provided by Debian, Fedora, Lubuntu and Ubuntu). I also experienced
it on a Gentoo kernel, but I don't recall the kernel version. I've
checked the kernel configs, and they all include
"CONFIG_CRYPTO_USER_API={y|m}".

When similar code is called from userland using the async crypto gear,
then the call to socket usually succeeds. During async testing, I also
see a dmesg about registering a socket family 38. The dmesg is not
present during the non-async failures.

I also checked the kernel crypto documentation at
http://www.kernel.org/doc/Documentation/crypto/ and
http://www.kernel.org/doc/htmldocs/crypto-API/User.html, but I don't
see a requirement I might be missing. I also checked a couple of slide
decks introducing the userspace crypto API, and I don't see what the
presenters are doing differently. Finally, I checked the LVN example
provided at http://lwn.net/Articles/410848/.

If it matters, I usually disable IPv6 via a boot parameter since I
don't use it in my environments. But I'm guessing it has nothing to do
with the problem since the async gear works fine.

What are the requirements to create/open an AF_ALG socket?

Or maybe, what is missing so the call to socket succeeds?

Thanks in advance.

**********

#include <stdio.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <linux/if_alg.h>

int main(int argc, char* argv[])
{
        s = socket(AF_ALG, SOCK_SEQPACKET, 0);
        if (s == -1) {
                fprintf(stderr, "Failed to open socket: %d\n", errno);
                goto cleanup;
        }
        ...
}
