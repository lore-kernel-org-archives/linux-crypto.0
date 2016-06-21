From: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Tue, 21 Jun 2016 09:12:07 +0200
Message-ID: <CAJU7zaJFCty9CQZwzY3_N2Rx91mh-FhJd8Us+akHpTzCc5CjZw@mail.gmail.com>
References: <2754489.L1QYabbYUc@positron.chronox.de> <3817952.8FvMDE0Kc7@tauon.atsec.com>
 <20160620152838.GE9848@thunk.org> <1639356.ozYDPrS7jM@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
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
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1639356.ozYDPrS7jM@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 20, 2016 at 5:43 PM, Stephan Mueller <smueller@chronox.de> wrote:
>> Personally, I don't really use /dev/random, nor would I recommend it
>> for most application programmers.  At this point, getrandom(2) really
>> is the preferred interface unless you have some very specialized
>> needs.
> I fully agree. But there are use cases for /dev/random, notably as a seed
> source for other DRNG.

Is that really the case? I believe all DRNG's use /dev/urandom anyway
for seeding since they cannot afford indeterminate blocking. It would
be a gain for everyone if /dev/random was the same as /dev/urandom in
Linux.

regards,
Nikos
