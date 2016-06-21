From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Tue, 21 Jun 2016 09:32:13 +0200
Message-ID: <24059874.5WizEqNrfz@tauon.atsec.com>
References: <2754489.L1QYabbYUc@positron.chronox.de> <1639356.ozYDPrS7jM@tauon.atsec.com> <CAJU7zaJFCty9CQZwzY3_N2Rx91mh-FhJd8Us+akHpTzCc5CjZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>,
	George Spelvin <linux@horizon.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37582 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932341AbcFUHcU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 03:32:20 -0400
In-Reply-To: <CAJU7zaJFCty9CQZwzY3_N2Rx91mh-FhJd8Us+akHpTzCc5CjZw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. Juni 2016, 09:12:07 schrieb Nikos Mavrogiannopoulos:

Hi Nikos,

> On Mon, Jun 20, 2016 at 5:43 PM, Stephan Mueller <smueller@chronox.de> 
wrote:
> >> Personally, I don't really use /dev/random, nor would I recommend it
> >> for most application programmers.  At this point, getrandom(2) really
> >> is the preferred interface unless you have some very specialized
> >> needs.
> > 
> > I fully agree. But there are use cases for /dev/random, notably as a seed
> > source for other DRNG.
> 
> Is that really the case? I believe all DRNG's use /dev/urandom anyway
> for seeding since they cannot afford indeterminate blocking. It would
> be a gain for everyone if /dev/random was the same as /dev/urandom in
> Linux.

For standard approaches, this is true. But there are regulations, notably in 
the German realm, /dev/random shall be used, at least partially (see AIS 
20/31).

Ciao
Stephan
