From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [cryptodev:master 130/134] aes_generic.c:undefined reference to `_restgpr_31_x'
Date: Fri, 12 Jan 2018 15:41:11 -0600
Message-ID: <20180112214111.GQ21977@gate.crashing.org>
References: <201801122249.RHvvGQJ6%fengguang.wu@intel.com> <CAK8P3a0Rfbo=wJgEAm3vVFY1MpPWLE3HMGcUdoOXxqOVm8jRyw@mail.gmail.com> <20180112163946.GE21977@gate.crashing.org> <CAK8P3a39=PVpwiSk_3CjRnYBawhXqMatHKSsHCd2KHCgR+Zmyg@mail.gmail.com> <20180112204154.GM21977@gate.crashing.org> <CAK8P3a2YVVseBFNoDbwOtqR3-JHFuZ-WZD6-PzztNTO_X_soaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:34583 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964844AbeALVle (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 16:41:34 -0500
Content-Disposition: inline
In-Reply-To: <CAK8P3a2YVVseBFNoDbwOtqR3-JHFuZ-WZD6-PzztNTO_X_soaw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 12, 2018 at 10:29:01PM +0100, Arnd Bergmann wrote:
> On Fri, Jan 12, 2018 at 9:41 PM, Segher Boessenkool
> <segher@kernel.crashing.org> wrote:
> > On Fri, Jan 12, 2018 at 08:43:21PM +0100, Arnd Bergmann wrote:
> >> On Fri, Jan 12, 2018 at 5:39 PM, Segher Boessenkool
> 
> >> We could theoretically work around it by turning that into
> >> "#if defined(CONFIG_CC_OPTIMIZE_FOR_SIZE) ||
> >> defined(CONFIG_CRYPTO_AES)", but that seems rather ugly.
> >>
> >> My earlier patch already tried to be more specific, turning very
> >> specific optimizations off rather than moving from -O2 to -Os,
> >> but that turned out to lead to significantly worse performance,
> >> where -Os improved performance slightly. Is there a way
> >> to ask powerpc compilers to use mostly -Os but not the
> >> specific thing that makes it link to _restgpr_31_x?
> >
> > There is no such thing, sorry.  Would be very hard to implement, and
> > older compilers will never get it, so it won't help you anyway :-(
> 
> We use -Os only for gcc-7.1 and higher, where it produces faster
> code for AES and avoids running into
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356
> 
> > Maybe for now just enable it in crtsavres.S always, with a comment?
> > That -Os workaround is hopefully not going to live long either...
> 
> It depends on whether or how soon someone comes up with a
> better fix for PR83356.
> gcc-8.0.0 is currently not affected by it, so we could limit the
> workaround (and the hack in crtsavres.S) to gcc-7-only.

I guess you could enable the _x routines whenever you use ubsan?  Ubsan
will cause much bigger code growth than the handful of insns in those
routines?


Segher
