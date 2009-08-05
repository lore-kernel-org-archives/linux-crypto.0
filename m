From: Milan Broz <mbroz@redhat.com>
Subject: Re: [dm-crypt] cryptsetup with arc4 cipher
Date: Wed, 05 Aug 2009 15:09:59 +0200
Message-ID: <4A7984A7.40109@redhat.com>
References: <87zlaf3zl0.wl@obsidian.enotty.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: dm-crypt@saout.de, linux-crypto@vger.kernel.org
To: Stelios Bounanos <sb-lst@enotty.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:60922 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932737AbZHENKa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2009 09:10:30 -0400
In-Reply-To: <87zlaf3zl0.wl@obsidian.enotty.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stelios Bounanos wrote:
> I was surprised to see arc4 perform so badly, particularly since
> "openssl speed" results tell a very different story.  I decided to do
> some simple benchmarking of my own but I can't seem to get cryptsetup to
> work with arc4:
> 
>   # cryptsetup luksFormat --align-payload=512 -q -c arc4 /dev/sda4 key
>   # cryptsetup luksOpen -d key /dev/sda4 ctest
>     Command failed: No key available with this passphrase.
> 
> The above commands work fine with aes.  I can see arc4 in /proc/crypto.
> 
> Any ideas?

There is apparently some problem in kernel, not sure if dm-crypt or crypto
api one, This ARC4 configuration is allowed (no errors) but produces something
more like random generator:-)

one sector device:
# dmsetup create x --table "0 1 crypt arc4-cbc-plain 0123456789abcdef 0 /dev/sdb 0"

# sha256sum /dev/mapper/x
d37afeeb57a60b69715edd99f2a1523e77f6be51a1c61c56efc91ed691c90dfc  /dev/mapper/x

# sha256sum /dev/mapper/x
fdc87e8e9f158d26e58c5b48c80375b56cc24d0c088872f4aacc7e19fb5c5599  /dev/mapper/x

Not sure what's wrong yet...

Milan
--
mbroz@redhat.com
