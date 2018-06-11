From: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v11 06/13] crypto: aesni: add minimal build option for
 SGX LE
Date: Mon, 11 Jun 2018 08:24:41 -0700
Message-ID: <1528730681.9779.42.camel@intel.com>
References: <20180608171216.26521-1-jarkko.sakkinen@linux.intel.com>
         <20180608171216.26521-7-jarkko.sakkinen@linux.intel.com>
         <00750c65-27b5-7851-19f5-9a712686dfb2@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: nhorman@redhat.com, npmccallum@redhat.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
        <linux-kernel@vger.kernel.org>
To: Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        x86@kernel.org, platform-driver-x86@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00750c65-27b5-7851-19f5-9a712686dfb2@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, 2018-06-08 at 10:27 -0700, Dave Hansen wrote:
> On 06/08/2018 10:09 AM, Jarkko Sakkinen wrote:
> > 
> > --- a/arch/x86/crypto/aesni-intel_asm.S
> > +++ b/arch/x86/crypto/aesni-intel_asm.S
> > @@ -45,6 +45,8 @@
> >  #define MOVADQ	movaps
> >  #define MOVUDQ	movups
> >  
> > +#ifndef AESNI_INTEL_MINIMAL
> > +
> >  #ifdef __x86_64__
> >  
> >  # constants in mergeable sections, linker can reorder and merge
> > @@ -133,6 +135,8 @@ ALL_F:      .octa 0xffffffffffffffffffffffffffffffff
> >  #define keysize 2*15*16(%arg1)
> >  #endif
> >  
> > +#endif /* AESNI_INTEL_MINIMAL */
> > +
> I'd really prefer that these get moved into a separate file rather than
> a scattered set of #ifdefs.  This just seem fragile to me.
> 
> Can we have a "aesni-intel_asm-minimal.S"?  Or, at least bunch the
> minimal set of things *together*?

A separate file doesn't seem appropriate because there is no criteria
for including code in the "minimal" build beyond "this code happens to
be needed by SGX".  I considered having SGX somewhere in the define
but opted for AESNI_INTEL_MINIMAL on the off chance that the minimal
build was useful for something other than SGX.

I'm not opposed to bunching the minimal stuff together, my intent was
simply to disturb the code as little as possible.
