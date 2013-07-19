From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
Date: Fri, 19 Jul 2013 16:37:13 -0700
Message-ID: <1374277033.22432.384.camel@schen9-DESK>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
	 <2493652.fjZLqTL8IF@vostro.rjw.lan>
	 <1374257329.22432.382.camel@schen9-DESK>
	 <4295105.1txhDL4OOg@vostro.rjw.lan> <20130719231630.GC1701@kroah.com>
	 <51E9C9E5.2060602@zytor.com>  <20130719232459.GA18039@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	ak <ak@linux.intel.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20130719232459.GA18039@gondor.apana.org.au>
Sender: linux-acpi-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 2013-07-20 at 09:24 +1000, Herbert Xu wrote:
> On Fri, Jul 19, 2013 at 04:21:09PM -0700, H. Peter Anvin wrote:
> >
> > The issue here seems to be the dynamic binding nature of the crypto
> > subsystem.  When something needs crypto, it will request the appropriate
> > crypto module (e.g. crct10dif), which may race with detecting a specific
> > hardware accelerator based on CPUID or device information (e.g.
> > crct10dif_pclmul).
> > 
> > RAID has effectively the same issue, and we just "solved" it by
> > compiling in all the accelerators into the top-level module.
> 
> I think for crypto the simplest solution is to not do CPUID-based
> loading.  Then crypto users will simply load the module alias which
> causes modprobe to load all modules providing that alias.
> 
> Cheers,

Herbert,

I've tried the module alias approach (see my earlier mail with patch) 
but it didn't seem to load things properly.  Can you check to see if 
there's anything I did incorrectly.

Tim

