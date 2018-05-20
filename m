From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: cryptomgr_test / drbg_ctr: BUG: sleeping function called from invalid context
Date: Sun, 20 May 2018 21:54:07 +0200
Message-ID: <14009987.cibGRJrWdm@positron.chronox.de>
References: <CAMuHMdW_4gvQYhCxcXR+sa6dhwAshyJnhXhc36=VC=hWKB-7Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdW_4gvQYhCxcXR+sa6dhwAshyJnhXhc36=VC=hWKB-7Jw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 18. Mai 2018, 10:36:04 CEST schrieb Geert Uytterhoeven:

Hi Geert,
> 
> I tried following the code path, but couldn't find where it went wrong.
> 
> mutex_lock(&drbg->drbg_mutex) is called from drbg_instantiate(), which is
> inlined by the compiler into drbg_kcapi_seed().
> 
> Do you have a clue?

It is the first time I hear from such an issue. Yes, the DRBG should not be 
called in atomic context. But I do not see where we have an atomic context 
(either a spin_lock or in an interrupt handler) when we are executing the test 
manager.

I will keep looking.

Ciao
Stephan
