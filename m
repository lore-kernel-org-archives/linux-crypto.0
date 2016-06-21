From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Subject: Re: [PATCH v5 0/7] /dev/random - a new approach
Date: Tue, 21 Jun 2016 12:03:56 -0400
Message-ID: <e2612733-f3c1-bdc0-5822-3f20c44fe781@gmail.com>
References: <2754489.L1QYabbYUc@positron.chronox.de>
 <1639356.ozYDPrS7jM@tauon.atsec.com>
 <CAJU7zaJFCty9CQZwzY3_N2Rx91mh-FhJd8Us+akHpTzCc5CjZw@mail.gmail.com>
 <24059874.5WizEqNrfz@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
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
To: Stephan Mueller <smueller@chronox.de>,
	Nikos Mavrogiannopoulos <nmav@gnutls.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <24059874.5WizEqNrfz@tauon.atsec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 2016-06-21 03:32, Stephan Mueller wrote:
> Am Dienstag, 21. Juni 2016, 09:12:07 schrieb Nikos Mavrogiannopoulos:
>
> Hi Nikos,
>
>> On Mon, Jun 20, 2016 at 5:43 PM, Stephan Mueller <smueller@chronox.de>
> wrote:
>>>> Personally, I don't really use /dev/random, nor would I recommend it
>>>> for most application programmers.  At this point, getrandom(2) really
>>>> is the preferred interface unless you have some very specialized
>>>> needs.
>>>
>>> I fully agree. But there are use cases for /dev/random, notably as a seed
>>> source for other DRNG.
>>
>> Is that really the case? I believe all DRNG's use /dev/urandom anyway
>> for seeding since they cannot afford indeterminate blocking. It would
>> be a gain for everyone if /dev/random was the same as /dev/urandom in
>> Linux.
>
> For standard approaches, this is true. But there are regulations, notably in
> the German realm, /dev/random shall be used, at least partially (see AIS
> 20/31).
Which just goes to show how utterly stupid some people who write laws 
and regulations are.  Saying specifically that '/dev/random shall be 
used' does not enforce any improvement of entrophic value in the data at 
all, it just coincidentally improves the theoretical quality of the data 
because of how Linux and some legacy UNIX systems are designed.  This 
'regulation' already provides zero benefit other than a placebo effect 
on at least OpenBSD, FreeBSD, and I'm pretty certain most other BSD 
derivatives, as /dev/random and /dev/urandom point to the same thing 
there (on OpenBSD it's an arcfour based drbg, FreeBSD does similar but 
uses a CSPRNG called Fortuna), and while I'm not certain, I believe AIX 
does likewise (although they use a design based on yarrow).

On top of that though, just because some poorly thought out standard 
requires it's usage doesn't mean we have to work based on that.
