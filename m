From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 11:30:42 +0100
Message-ID: <550953D2.9090409@iogearbox.net>
References: <20150318095345.GA12923@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Cesar Eduardo Barros <cesarb@cesarb.eti.br>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>
To: mancha <mancha1@zoho.com>, tytso@mit.edu,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150318095345.GA12923@zoho.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[ Cc'ing Cesar ]

On 03/18/2015 10:53 AM, mancha wrote:
> Hi.
>
> The kernel RNG introduced memzero_explicit in d4c5efdb9777 to protect
> memory cleansing against things like dead store optimization:
>
>     void memzero_explicit(void *s, size_t count)
>     {
>             memset(s, 0, count);
>             OPTIMIZER_HIDE_VAR(s);
>     }
>
> OPTIMIZER_HIDE_VAR, introduced in fe8c8a126806 to protect crypto_memneq
> against timing analysis, is defined when using gcc as:
>
>     #define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=r" (var) : "0" (var))
>
> My tests with gcc 4.8.2 on x86 find it insufficient to prevent gcc from
> optimizing out memset (i.e. secrets remain in memory).

Could you elaborate on your test case?

memzero_explicit() is actually an EXPORT_SYMBOL(), are you saying
that gcc removes the call to memzero_explicit() entirely, inlines
it, and then optimizes the memset() eventually away?

Last time I looked, it emitted a call to memzero_explicit(), and
inside memzero_explicit() it did the memset() as it cannot make
any assumption from there. I'm using gcc (GCC) 4.8.3 20140911
(Red Hat 4.8.3-7).

> Two things that do work:
>
>     __asm__ __volatile__ ("" : "=r" (var) : "0" (var))
>
>     and
>
>     __asm__ __volatile__("": : :"memory")
>
> The first is OPTIMIZER_HIDE_VAR plus a volatile qualifier and the second
> is barrier() [as defined when using gcc].
>
> I propose memzero_explicit use barrier().
>
> --- a/lib/string.c
> +++ b/lib/string.c
> @@ -616,7 +616,7 @@ EXPORT_SYMBOL(memset);
>   void memzero_explicit(void *s, size_t count)
>   {
>          memset(s, 0, count);
> -       OPTIMIZER_HIDE_VAR(s);
> +       barrier();
>   }
>   EXPORT_SYMBOL(memzero_explicit);
>
> For any attribution deemed necessary, please use "mancha security".
> Please CC me on replies.
>
> --mancha
>
> PS CC'ing Herbert Xu in case this impacts crypto_memneq.
>
