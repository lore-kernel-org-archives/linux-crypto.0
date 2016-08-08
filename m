From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: AF_ALG broken?
Date: Mon, 8 Aug 2016 13:47:33 -0400
Message-ID: <CAH8yC8nFhMCfXpdrcz1bJDPfbMHRGQpkV6yOZ7gy4yRHJwXkWw@mail.gmail.com>
References: <20160808164427.GB1041@n2100.armlinux.org.uk>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36536 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbcHHRre (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 13:47:34 -0400
Received: by mail-io0-f169.google.com with SMTP id b62so364504745iod.3
        for <linux-crypto@vger.kernel.org>; Mon, 08 Aug 2016 10:47:34 -0700 (PDT)
In-Reply-To: <20160808164427.GB1041@n2100.armlinux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> When trying to use the openssl AF_ALG module with 4.8-rc1 with imx
> caam, I get this:
>
> $ OPENSSL_CONF=/shared/crypto/openssl-imx.cnf strace openssl dgst -md5 </bin/bash
> ...
> socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> close(3)                                = 0
> socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
> accept(3, 0, NULL)                      = 4
> fstat64(0, {st_mode=S_IFREG|0755, st_size=666864, ...}) = 0
> mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6fab000
> read(0, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\2\0(\0\1\0\0\0\21'\2\0004\0\0\0"..., 8192) = 8192
> send(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\2\0(\0\1\0\0\0\21'\2\0004\0\0\0"..., 8192, MSG_MORE) = -1 ENOKEY (Required key not available)

As far as I know from testing on x86, it has never worked as expected.
I believe you have to use 'sendto' and 'recvfrom' because 'send' and
'recv' use default structures, and they configure the object
incorrectly.

Jeff
