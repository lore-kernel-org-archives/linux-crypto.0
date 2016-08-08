From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: AF_ALG broken?
Date: Mon, 8 Aug 2016 19:11:17 +0100
Message-ID: <20160808181117.GD1041@n2100.armlinux.org.uk>
References: <20160808164427.GB1041@n2100.armlinux.org.uk>
 <CAH8yC8nFhMCfXpdrcz1bJDPfbMHRGQpkV6yOZ7gy4yRHJwXkWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jeffrey Walton <noloader@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57914 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcHHSLZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Aug 2016 14:11:25 -0400
Content-Disposition: inline
In-Reply-To: <CAH8yC8nFhMCfXpdrcz1bJDPfbMHRGQpkV6yOZ7gy4yRHJwXkWw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 08, 2016 at 01:47:33PM -0400, Jeffrey Walton wrote:
> > When trying to use the openssl AF_ALG module with 4.8-rc1 with imx
> > caam, I get this:
> >
> > $ OPENSSL_CONF=/shared/crypto/openssl-imx.cnf strace openssl dgst -md5 </bin/bash
> > ...
> > socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> > close(3)                                = 0
> > socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> > bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
> > accept(3, 0, NULL)                      = 4
> > fstat64(0, {st_mode=S_IFREG|0755, st_size=666864, ...}) = 0
> > mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb6fab000
> > read(0, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\2\0(\0\1\0\0\0\21'\2\0004\0\0\0"..., 8192) = 8192
> > send(4, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\2\0(\0\1\0\0\0\21'\2\0004\0\0\0"..., 8192, MSG_MORE) = -1 ENOKEY (Required key not available)
> 
> As far as I know from testing on x86, it has never worked as expected.
> I believe you have to use 'sendto' and 'recvfrom' because 'send' and
> 'recv' use default structures, and they configure the object
> incorrectly.

This used to work, because that's how I've tested my previous CAAM
and Marvell CESA patches.  So, this is not a case of "never worked"
but is definitely a regression caused by some kernel change.

There's also people's presentations that illustrate example code:

https://events.linuxfoundation.org/sites/events/files/slides/lcj-2014-crypto-user.pdf

which can also be found at:

https://lwn.net/Articles/410833/

and that example code comes from Herbert, so one would assume that
it's tested and was working.  Note that it doesn't use any send*,
but uses write().

Testing that code on 4.8-rc (and 4.7 fwiw) gives:

socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
accept(3, 0, NULL)                      = 4
write(4, "abc", 3)                      = -1 ENOKEY (Required key not available)
read(4, 0xbec50508, 20)                 = -1 ENOKEY (Required key not available)

IOW, the same problem - and it seems not to be a recent regression.

Since the last time I tested CESA or CAAM was back in 4.4 times,
it's got to be something between 4.4 and 4.7.

Looking at the history, my guess would be the setkey changes -
crypto: algif_skcipher - Require setkey before accept(2)
crypto: af_alg - Disallow bind/setkey/... after accept(2)
crypto: af_alg - Add nokey compatibility path
crypto: hash - Add crypto_ahash_has_setkey
crypto: algif_hash - Require setkey before accept(2)

-- 
Rmk's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
