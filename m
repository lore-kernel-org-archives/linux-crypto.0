From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 16:00:03 +0200
Message-ID: <1428674403.3377.4.camel@stressinduktion.org>
References: <20150318095345.GA12923@zoho.com>
	 <550959EB.4000304@iogearbox.net> <6407649.tbmT00FeL6@tauon>
	 <2792913.x6Cv5ZCyOY@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Daniel Borkmann <daniel@iogearbox.net>, mancha <mancha1@zoho.com>,
	tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2792913.x6Cv5ZCyOY@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fr, 2015-04-10 at 15:25 +0200, Stephan Mueller wrote:
> I would like to bring up that topic again as I did some more analyses:
> 
> For testing I used the following code:
> 
> static inline void memset_secure(void *s, int c, size_t n)
> {
>         memset(s, c, n);
> 	BARRIER
> }
> 
> where BARRIER is defined as:
> 
> (1) __asm__ __volatile__("" : "=r" (s) : "0" (s));
> 
> (2) __asm__ __volatile__("": : :"memory");
> 
> (3) __asm__ __volatile__("" : "=r" (s) : "0" (s) : "memory");

Hm, I wonder a little bit...

Could you quickly test if you replace (s) with (n) just for the fun of
it? I don't know if we should ask clang people about that, at least it
is their goal to be as highly compatible with gcc inline asm.

Thanks for looking into this!

Bye,
Hannes
