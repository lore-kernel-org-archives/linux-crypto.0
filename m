From: dean gaudet <dean@arctic.org>
Subject: Re: [PATCH -mm crypto] AES: x86_64 asm implementation optimization
Date: Sat, 3 May 2008 23:25:27 -0700 (PDT)
Message-ID: <alpine.DEB.1.10.0805032323580.27385@twinlark.arctic.org>
References: <1207723262.18313.37.camel@caritas-dev.intel.com> <20080416073108.GA13494@Chamillionaire.breakpoint.cc> <1208333949.4322.5.camel@caritas-dev.intel.com> <20080416184016.GA21365@Chamillionaire.breakpoint.cc> <1208403403.4322.27.camel@caritas-dev.intel.com>
 <20080423223221.GB16683@Chamillionaire.breakpoint.cc> <1209093077.20936.24.camel@caritas-dev.intel.com> <20080429221225.GA5280@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Huang, Ying" <ying.huang@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Adam J. Richter" <adam@yggdrasil.com>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	mingo@elte.hu, tglx@linutronix.de
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753544AbYEDGZk@vger.kernel.org>
In-Reply-To: <20080429221225.GA5280@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

one of the more important details in evaluating these changes would be the 
family/model/stepping of the processors being microbenchmarked... could 
you folks include /proc/cpuinfo with the results?

also -- please drop the #define for R16 to %rsp ... it obfuscates more 
than it helps anything.

thanks
-dean

On Wed, 30 Apr 2008, Sebastian Siewior wrote:

> * Huang, Ying | 2008-04-25 11:11:17 [+0800]:
> 
> >Hi, Sebastian,
> Hi Huang,
> 
> sorry for the delay.
> 
> >I changed the patches to group the read or write together instead of
> >interleaving. Can you help me to test these new patches? The new patches
> >is attached with the mail.
> The new results are attached.
> 
> >
> >Best Regards,
> >Huang Ying
> 
> Sebastian
> 
