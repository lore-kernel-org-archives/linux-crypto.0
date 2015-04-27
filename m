From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 1/6] random: Addition of kernel_pool
Date: Mon, 27 Apr 2015 16:32:32 +0200
Message-ID: <1441670.vWIupYPgcC@tauon>
References: <1631051.qmxH657I75@myon.chronox.de> <3407082.JU6Cks92ze@myon.chronox.de> <20150427065609.GA21100@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Paul Bolle <pebolle@tiscali.nl>, andreas.steffen@strongswan.org,
	tytso@mit.edu, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150427065609.GA21100@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Montag, 27. April 2015, 14:56:09 schrieb Herbert Xu:

Hi Herbert,

>On Sat, Apr 25, 2015 at 05:40:41PM +0200, Stephan Mueller wrote:
>> +				if (p->entropy_count <=
>> +					p->poolinfo->poolfracbits / 4) {
>
>There appears to be a "3 *" missing.

Correct, I will update my patch accordingly.
>
>Cheers,


Ciao
Stephan
