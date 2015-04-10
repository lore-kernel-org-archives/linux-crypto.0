From: Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Fri, 10 Apr 2015 16:26:00 +0200
Message-ID: <1428675960.3377.8.camel@stressinduktion.org>
References: <20150318095345.GA12923@zoho.com> <2792913.x6Cv5ZCyOY@tauon>
	 <1428674403.3377.4.camel@stressinduktion.org> <1697288.aUGCRhyl06@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Daniel Borkmann <daniel@iogearbox.net>, mancha <mancha1@zoho.com>,
	tytso@mit.edu, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	dborkman@redhat.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1697288.aUGCRhyl06@tauon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fr, 2015-04-10 at 16:09 +0200, Stephan Mueller wrote:
> Am Freitag, 10. April 2015, 16:00:03 schrieb Hannes Frederic Sowa:
> 
> Hi Hannes,
> 
> >On Fr, 2015-04-10 at 15:25 +0200, Stephan Mueller wrote:
> >> I would like to bring up that topic again as I did some more analyses:
> >> 
> >> For testing I used the following code:
> >> 
> >> static inline void memset_secure(void *s, int c, size_t n)
> >> {
> >> 
> >>         memset(s, c, n);
> >> 	
> >> 	BARRIER
> >> 
> >> }
> >> 
> >> where BARRIER is defined as:
> >> 
> >> (1) __asm__ __volatile__("" : "=r" (s) : "0" (s));
> >> 
> >> (2) __asm__ __volatile__("": : :"memory");
> >> 
> >> (3) __asm__ __volatile__("" : "=r" (s) : "0" (s) : "memory");
> >
> >Hm, I wonder a little bit...
> >
> >Could you quickly test if you replace (s) with (n) just for the fun of
> >it? I don't know if we should ask clang people about that, at least it
> >is their goal to be as highly compatible with gcc inline asm.
> 
> Using 
> 
>  __asm__ __volatile__("" : "=r" (n) : "0" (n) : "memory");
> 
> clang O2/3: no mov
> 
> gcc O2/3: mov present
> 
> ==> not good

I suspected a problem in how volatile with non-present output args could
be different, but this seems not to be the case.

I would contact llvm/clang mailing list and ask. Maybe there is a
problem? It seems kind of strange to me...

Thanks,
Hannes
