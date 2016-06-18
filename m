From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Sat, 18 Jun 2016 10:44:08 -0400
Message-ID: <20160618144408.GA5344@thunk.org>
References: <1466007463.20087.11.camel@redhat.com>
 <6137456.oZ1CFC9kFY@positron.chronox.de>
 <1466171773.20087.66.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Stephan Mueller <smueller@chronox.de>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38138 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404AbcFROo3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 18 Jun 2016 10:44:29 -0400
Content-Disposition: inline
In-Reply-To: <1466171773.20087.66.camel@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 17, 2016 at 03:56:13PM +0200, David Ja=C5=A1a wrote:
> I was thinking along the lines that "almost every important package
> supports FreeBSD as well where they have to handle the condition so
> option to switch to Rather Break Than Generate Weak Keys would be nic=
e"
> - but I didn't expect that systemd could be a roadblock here. :-/

It wasn't just systemd; it also broke OpenWRT and Ubuntu Quantal
systems from booting.

> I was also thinking of little devices where OpenWRT or proprietary
> Linux-based systems run that ended up with predictable keys way too
> ofter (or as in OpenWRT's case, with cumbersome tutorials how to
> generate keys elsewhere).

OpenWRT and other embedded devices (a) generally use a single master
oscillator to drive everything, and (b) often use RISC architectures
such as MIPS.

Which means that arguments of the form ``the Intel L1 / L2 cache
architecture is ****soooo**** complicated that no human could possibly
figure out how they would affect timing calculations, and besides, my
generator passes FIPS 140-2 tests (never mind AES(NSA_KEY, CNTR++)
also passes the FIPS 140-2 statistical tests)'' --- which I normally
have trouble believing --- are even harder for me to believe.

At the end of the day, with these devices you really badly need a
hardware RNG.  We can't generate randomness out of thin air.  The only
thing you really can do requires user space help, which is to generate
keys lazily, or as late as possible, so you can gather as much entropy
as you can --- and to feed in measurements from the WiFi (RSSI
measurements, MAC addresses seen, etc.)  This won't help much if you
have an FBI van parked outside your house trying to carry out a
TEMPEST attack, but hopefully it provides some protection against a
remote attacker who isn't try to carry out an on-premises attack.

Cheers,

						- Ted
