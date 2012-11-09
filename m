From: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v3 1/7] ARM: OMAP2xxx: hwmod: Convert SHAM crypto
 device data to hwmod
Date: Fri, 9 Nov 2012 10:00:31 -0800
Message-ID: <20121109180031.GQ6801@atomide.com>
References: <1352257033-32495-1-git-send-email-mgreer@animalcreek.com>
 <1352257033-32495-2-git-send-email-mgreer@animalcreek.com>
 <CALLzPKY7TCFe0yvpwJFNf8U2=h4k1Jcb8g9Q0UpGM8qv2FcSwg@mail.gmail.com>
 <20121109170703.GA13898@animalcreek.com>
 <alpine.DEB.2.00.1211091709000.20703@utopia.booyaka.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Mark A. Greer" <mgreer@animalcreek.com>,
	"Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, rmk+kernel@arm.linux.org.uk,
	khilman@deeprootsystems.com
To: Paul Walmsley <paul@pwsan.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211091709000.20703@utopia.booyaka.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Paul Walmsley <paul@pwsan.com> [121109 09:13]:
> On Fri, 9 Nov 2012, Mark A. Greer wrote:
> 
> > On Fri, Nov 09, 2012 at 06:10:20PM +0200, Kasatkin, Dmitry wrote:
> >
> > > Why not using macros as it was before?
> > > 
> > > OMAP24XX_SEC_SHA1MD5_BASE
> > 
> > I am following the precedent set in the existing code of that file
> > which uses the actual address instead of a macro (except for uart).
> > 
> > I have no preference but I believe that is how Paul prefers it.
> > 
> > Paul?
> 
> My upstream prefers the raw addresses, I believe, under the rationale that 
> it allows the macro definitions to be removed from arch/arm/mach-omap2.  
> This reduces the total number of lines of code in that directory - and 
> this is currently an overriding concern of my upstreams.
> 
> So, yes the address format in your patch is fine.

Yes that should be the only place where that address is defined.
If OMAP24XX_SEC_SHA1MD5_BASE is used in multiple locations, then
it makes sense to define it in some local header.

Regards,

Tony
