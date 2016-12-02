From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: Crash in crypto mcryptd
Date: Fri, 02 Dec 2016 10:30:26 -0800
Message-ID: <1480703426.3064.55.camel@linux.intel.com>
References: <alpine.LRH.2.02.1612011819540.27565@file01.intranet.prod.int.rdu2.redhat.com>
         <1480643222.3064.52.camel@linux.intel.com>
         <20161202070658.GA18690@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        Milan Broz <mbroz@redhat.com>,
        Megha Dey <megha.dey@linux.intel.com>
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50327 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753617AbcLBSa2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2016 13:30:28 -0500
In-Reply-To: <20161202070658.GA18690@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 2016-12-01 at 23:06 -0800, Eric Biggers wrote:
> On Thu, Dec 01, 2016 at 05:47:02PM -0800, Tim Chen wrote:
> > 
> > On Thu, 2016-12-01 at 19:00 -0500, Mikulas Patocka wrote:
> > > 
> > > Hi
> > > 
> > > There is a bug in mcryptd initialization.
> > > 
> > > This is a test module that tries various hash algorithms. When you load 
> > > the module with "insmod test.ko 'alg=mcryptd(md5)'", the machine crashes.
> > I don't think your test setup is right.  The mcryptd supports only multi-buffer
> > algorithm.  I don't think there is such an implementation for md5.
> > 
> > Please refer to arch/x86/crypto/sha1-mb 
> > multi-buffer implementation of sha1 to see the proper
> > setup and usage with mcryptd.  You can also run tcrypt test to
> > exercise this code.
> > 
> > Tim
> No, mcryptd must not crash the kernel if it's passed the wrong algorithm.

That's true.  We should detect the case when mcryptd is being passed invalid
argument and not crash.  We'll take a look at it.

Tim
