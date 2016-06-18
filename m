From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Sat, 18 Jun 2016 18:31:26 +0200
Message-ID: <3381856.qSaz1KcX2Z@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com> <1466171773.20087.66.camel@redhat.com> <20160618144408.GA5344@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160618144408.GA5344@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Samstag, 18. Juni 2016, 10:44:08 schrieb Theodore Ts'o:

Hi Theodore,

> 
> At the end of the day, with these devices you really badly need a
> hardware RNG.  We can't generate randomness out of thin air.  The only
> thing you really can do requires user space help, which is to generate
> keys lazily, or as late as possible, so you can gather as much entropy
> as you can --- and to feed in measurements from the WiFi (RSSI
> measurements, MAC addresses seen, etc.)  This won't help much if you
> have an FBI van parked outside your house trying to carry out a
> TEMPEST attack, but hopefully it provides some protection against a
> remote attacker who isn't try to carry out an on-premises attack.

All my measurements on such small systems like MIPS or smaller/older ARMs do 
not seem to support that statement :-)

Ciao
Stephan
