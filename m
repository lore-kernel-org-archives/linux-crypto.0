From: "George Spelvin" <linux@horizon.com>
Subject: Re: [BISECTED] 4943ba16 ("include crypto- module prefix") breaks wifi
Date: 30 Apr 2015 07:00:51 -0400
Message-ID: <20150430110051.32143.qmail@ns.horizon.com>
References: <CAGXu5jKCr8-0-5EGHi3isnaeOm4qdazF=kpajcindgwCxeaK5w@mail.gmail.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux@horizon.com
To: keescook@chromium.org, minipli@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:23997 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750930AbbD3LHd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Apr 2015 07:07:33 -0400
In-Reply-To: <CAGXu5jKCr8-0-5EGHi3isnaeOm4qdazF=kpajcindgwCxeaK5w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sorry for the long silence; the last e-mails arrived as I went on a trip,
and the packet got lost.

I just upgraded my laptop to 4.0.1 and had to remember the magic
incantation to get the wireless working.  ("modprobe ctr")

> George, any updates on this?

It turns out that I found the problem.  An odd bit of pilot error, but
NOT a kernel problem.  See bottom.

> Also, could you please provide the output of "depmod -n | grep
> crypto-"? There should be lines for crypto-ccm and crypto-ctr if you
> build them as modules.

alias crypto-twofish-asm twofish_i586
alias crypto-twofish twofish_i586
alias crypto-salsa20-asm salsa20_i586
alias crypto-salsa20 salsa20_i586
alias crypto-serpent serpent_sse2_i586
alias crypto-cmac cmac
alias crypto-xcbc xcbc
alias crypto-md4 md4
alias crypto-sha256-generic sha256_generic
alias crypto-sha256 sha256_generic
alias crypto-sha224-generic sha256_generic
alias crypto-sha224 sha256_generic
alias crypto-ecb ecb
alias crypto-lrw lrw
alias crypto-xts xts
alias crypto-ctr ctr
alias crypto-rfc3686 ctr
alias crypto-gcm gcm
alias crypto-rfc4543 gcm
alias crypto-rfc4106 gcm
alias crypto-gcm_base gcm
alias crypto-ccm ccm
alias crypto-rfc4309 ccm
alias crypto-ccm_base ccm
alias crypto-cryptd cryptd
alias crypto-twofish-generic twofish_generic
alias crypto-twofish twofish_generic
alias crypto-serpent-generic serpent_generic
alias crypto-serpent serpent_generic
alias crypto-tnepres serpent_generic
alias crypto-salsa20-generic salsa20_generic
alias crypto-salsa20 salsa20_generic
alias crypto-michael_mic michael_mic
alias crypto-crc32 crc32
alias crypto-ansi_cprng ansi_cprng
alias crypto-stdrng ansi_cprng
alias crypto-ghash-generic ghash_generic
alias crypto-ghash ghash_generic


Anyway, the problem was a long time ago, in /etc/modprobe.d/local.conf,
I had blacklisted several unwanted crypto modules in order to suppress
some mysterious urge my system had to load every loadable module at
boot time.

"Hey, bozo!  The point of making them modules is that I *don't* want them
taking up unswappable memory all the time!"  So I hit it with a hammer.

One line written years ago was "blacklist ctr".  The light dawns.

It turns out that this doesn's stop an explicit "modprobe ctr" from
working, but *does* stop alias processing that resolves to ctr.
Thus, the kernel change broke my strange kmod (mis-)configuration.

This fits the observed symptoms, and I apologize for wasting your time.
