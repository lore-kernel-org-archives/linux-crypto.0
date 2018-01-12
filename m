From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [cryptodev:master 130/134] aes_generic.c:undefined reference to `_restgpr_31_x'
Date: Fri, 12 Jan 2018 16:10:50 -0600
Message-ID: <20180112221050.GR21977@gate.crashing.org>
References: <201801122249.RHvvGQJ6%fengguang.wu@intel.com> <CAK8P3a0Rfbo=wJgEAm3vVFY1MpPWLE3HMGcUdoOXxqOVm8jRyw@mail.gmail.com> <20180112163946.GE21977@gate.crashing.org> <CAK8P3a39=PVpwiSk_3CjRnYBawhXqMatHKSsHCd2KHCgR+Zmyg@mail.gmail.com> <20180112204154.GM21977@gate.crashing.org> <CAK8P3a2YVVseBFNoDbwOtqR3-JHFuZ-WZD6-PzztNTO_X_soaw@mail.gmail.com> <20180112214111.GQ21977@gate.crashing.org> <CAK8P3a3XKwrVpXH9=8n1=qAKtqHE+1sh6OhaJ_39GZcWSP-j=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        kbuild test robot <fengguang.wu@intel.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:41653 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965133AbeALWLL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 17:11:11 -0500
Content-Disposition: inline
In-Reply-To: <CAK8P3a3XKwrVpXH9=8n1=qAKtqHE+1sh6OhaJ_39GZcWSP-j=Q@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 12, 2018 at 10:45:31PM +0100, Arnd Bergmann wrote:
> > I guess you could enable the _x routines whenever you use ubsan?  Ubsan
> > will cause much bigger code growth than the handful of insns in those
> > routines?
> 
> Right, that could work, too. My patch that Herbert merged intentionally
> used -Os also for non-UBSAN builds because it turned out to
> be much faster (see gcc PR83651),

"Much"?

-Os is *slower* with 8.0, 5% faster with 7.2, 4% faster with 7.1,
slower with 7.0 and 6.3.  Your numbers, #c1.

Anf this is the generic code of course, which is slow anyway (not to
mention insecure).

> but we could revert that back
> to the default and only use the -Os for UBSAN, essentially
> addressing only PR83356 but not PR83651.


Segher
