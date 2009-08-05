From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [dm-crypt] cryptsetup with arc4 cipher
Date: Wed, 5 Aug 2009 22:30:17 +0200
Message-ID: <20090805203017.GA5875@Chamillionaire.breakpoint.cc>
References: <87zlaf3zl0.wl@obsidian.enotty.net> <4A7984A7.40109@redhat.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Stelios Bounanos <sb-lst@enotty.net>, dm-crypt@saout.de,
	linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:38632 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265AbZHEUaj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2009 16:30:39 -0400
Content-Disposition: inline
In-Reply-To: <4A7984A7.40109@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Milan Broz | 2009-08-05 15:09:59 [+0200]:

>There is apparently some problem in kernel, not sure if dm-crypt or crypto
>api one, This ARC4 configuration is allowed (no errors) but produces something
>more like random generator:-)
>
>one sector device:
># dmsetup create x --table "0 1 crypt arc4-cbc-plain 0123456789abcdef 0 /dev/sdb 0"
>
># sha256sum /dev/mapper/x
>d37afeeb57a60b69715edd99f2a1523e77f6be51a1c61c56efc91ed691c90dfc  /dev/mapper/x
>
># sha256sum /dev/mapper/x
>fdc87e8e9f158d26e58c5b48c80375b56cc24d0c088872f4aacc7e19fb5c5599  /dev/mapper/x
>
>Not sure what's wrong yet...
If you close the mapping, re-run the test you should get the same
result. There is nothing wrong :)

Don't use this as a block cipher in dm-crypt, it is a bad idea.

The long story:
ARC4 is a stream cipher and not a block cipher. Its internal state is
reseted in setkey() and every crypto request (encrypt/decrypt don't
matter) update the internal state of the stream cipher. That's why you
get a different result every time you read the same block.

If you want to use this stream cipher in dm-crypt you would have to
setup it up in ECB mode and use a key like "passphrase-IV". You have to
set this key before a requests and wait until its done until you
issue another crypto request (which includes setkey).
CBC will not work because one of its requirements is that the cipher
provides an inverse function which ARC4 simply does not have.
In generall your problem here is that you want to encrypt/decrypt blocks
(seeks) and not a stream.

>Milan

Sebastian
