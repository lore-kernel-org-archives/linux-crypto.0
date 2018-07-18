From: Yann Droneaud <ydroneaud@opteya.com>
Subject: Re: [PATCH] random: add a config option to trust the CPU's hwrng
Date: Wed, 18 Jul 2018 17:29:58 +0200
Message-ID: <822ef031e3589a5cda5972eeeb457bbad69ecde6.camel@opteya.com>
References: <20180718014344.1309-1-tytso@mit.edu>
         <37046662f2b38f98854abfa1b5868a27c3fa0888.camel@opteya.com>
         <20180718142625.GA5942@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        labbott@redhat.com
To: "Theodore Y. Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180718142625.GA5942@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Le mercredi 18 juillet 2018 à 10:26 -0400, Theodore Y. Ts'o a écrit :
> On Wed, Jul 18, 2018 at 09:22:13AM +0200, Yann Droneaud wrote:
> > 
> > The text message should explain this is only relevant during
> > initialization / early boot.
> > 
> > The config option name should state this.
> 
> There are other workarounds for hangs that happen after
> initialization / early boot, yes.  They are of varying levels of
> quality / safely, but that's neither here nor there.
> 
> However, enabling config option means that the CRNG will be
> initialized with potentially information available to the CPU
> manufacturer and/or Nation States, and this persists *after*
> initialization / early boot.  So to say, "we're perfectly safe after
> we leave initialization / early boot" is not true.
> 

Sure, but, AFAICT, RDRAND is already in use through arch_get_random_*()
functions when CONFIG_ARCH_RANDOM is enabled.

>From an outside PoV, there's a conflict: why one would want its kernel
to use CPU hwrng if one has purposely disabled CONFIG_RANDOM_TRUST_CPU
?

> So I'd much rather make it clear that we are trusting the CPU
> manufacturer far more than just during early boot.
> 

Then, should CONFIG_ARCH_RANDOM depends on CONFIG_RANDOM_TRUST_CPU  (on
x86 at least) ?

Regards.

-- 
Yann Droneaud
OPTEYA
