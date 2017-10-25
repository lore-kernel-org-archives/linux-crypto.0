From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [PATCH] tpm: Move Linux RNG connection to hwrng
Date: Wed, 25 Oct 2017 13:37:07 -0600
Message-ID: <20171025193707.GA998@obsidianresearch.com>
References: <20171024184235.GC1806@obsidianresearch.com>
 <CANc+2y5q78g1Ow1JQ7kO0SkPrgNtbRV=COkB4YLHbSraTQH7aQ@mail.gmail.com>
 <20171025185817.hoalqzud3646yuy7@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Matt Mackall <mpm@selenic.com>,
        David Safford <safford@us.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from quartz.orcorp.ca ([184.70.90.242]:49231 "EHLO quartz.orcorp.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751522AbdJYThS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2017 15:37:18 -0400
Content-Disposition: inline
In-Reply-To: <20171025185817.hoalqzud3646yuy7@linux.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 25, 2017 at 08:58:17PM +0200, Jarkko Sakkinen wrote:
> On Wed, Oct 25, 2017 at 08:15:09PM +0530, PrasannaKumar Muralidharan wrote:
> > > +       if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM))
> > > +               return 0;
> > 
> > Can #ifndef CONFIG_HW_RANDOM_TPM be used instead? That way an if
> > condition can be avoided.
> 
> Nope. There is no reason to avoid the if-condition. Compiler will take
> care of it. IS_ENABLED() macro is available just for the purpose Jason
> is using it.
> 
> > > +       char tpm_hwrng_name[64];
> > > +       struct hwrng tpm_hwrng;
> > > +
> > 
> > Can this also be put inside the #ifdef?
> 
> Yes. It should be inside #ifdef.

Then we need #idefs in the .c code, IS_ENABLED is not enough :\ I
don't think the few bytes matters enough to bother.

Jason
