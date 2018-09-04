From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86 - remove SHA multibuffer routines and mcryptd
Date: Tue, 4 Sep 2018 11:17:31 +0800
Message-ID: <20180904031731.ehi2jzx3retkhyql@gondor.apana.org.au>
References: <20180822085144.4872-1-ard.biesheuvel@linaro.org>
 <a877e275-4dd7-6580-2351-db8d3a4ba1a2@linux.intel.com>
 <1535411993.3516.4.camel@megha-Z97X-UD7-TH>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        ebiggers@google.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
To: Megha Dey <megha.dey@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1535411993.3516.4.camel@megha-Z97X-UD7-TH>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 27, 2018 at 04:19:53PM -0700, Megha Dey wrote:
> On Mon, 2018-08-27 at 15:28 -0700, Tim Chen wrote:
> > On 08/22/2018 01:51 AM, Ard Biesheuvel wrote:
> > > As it turns out, the AVX2 multibuffer SHA routines are currently
> > > broken [0], in a way that would have likely been noticed if this
> > > code were in wide use. Since the code is too complicated to be
> > > maintained by anyone except the original authors, and since the
> > > performance benefits for real-world use cases are debatable to
> > > begin with, it is better to drop it entirely for the moment.
> > > 
> > > [0] https://marc.info/?l=linux-crypto-vger&m=153476243825350&w=2
> > 
> > Sorry I was out of the loop for a while and haven't been following
> > the code too closely.
> > 
> > Megha is maintaining the code now.  Before we pull the code,
> > please give us a chance to fix it first.
> > 
> > Thanks.
> > 
> > Tim
> > 
> 
> Hi,
> 
> I am working to find a fix for these corner cases. If possible, we would
> like to fix the issues instead of removing the code altogether.

I think it has taken way too long to fix these issues.  The fact
that these issues have existed for so long also means that hardly
anyone uses these mb algorithms.

So I think it is best if we remove everything and then add them
back after a proper review process.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
