From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
Date: Sat, 20 Jul 2013 13:01:43 +0200
Message-ID: <9823557.ylACl3Z50l@vostro.rjw.lan>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp> <6518656.400qriFEKQ@vostro.rjw.lan> <8043923.9cbosS4r2b@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	ak <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <8043923.9cbosS4r2b@vostro.rjw.lan>
Sender: linux-acpi-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Saturday, July 20, 2013 11:51:55 AM Rafael J. Wysocki wrote:
> On Saturday, July 20, 2013 05:06:29 AM Rafael J. Wysocki wrote:
> > On Saturday, July 20, 2013 02:00:44 AM Rafael J. Wysocki wrote:
> > > On Friday, July 19, 2013 04:16:30 PM Greg Kroah-Hartman wrote:
> > > > On Fri, Jul 19, 2013 at 11:38:04PM +0200, Rafael J. Wysocki wrote:
> > > > > Alas, this is not the one I'd like to apply.
> > > > > 
> > > > > With that patch applied, new device objects are created to avoid binding the
> > > > > processor driver directly to the cpu system device objects, because that
> > > > > apparently confuses udev and it starts to ignore the cpu modalias once the
> > > > > driver has been bound to any of those objects.
> > > > > 
> > > > > I've verified in the meantime that this indeed is the case.
> > > > > 
> > > > > A link to the patch in question: https://patchwork.kernel.org/patch/2830561/
> > > > > 
> > > > > Greg, I asked you some time ago whether or not it was possible for udev to stop
> > > > > autoloading modules that matched the cpu modalias after a driver had been bound
> > > > > to the cpu system device objects and you said "no".  However, this time I can
> > > > > say with certainty that that really is the case.  So, the question now is
> > > > > whether or not we can do anything in the kernel to avoid that confusion in udev
> > > > > instead of applying the patch linked above (which is beyond ugly in my not so
> > > > > humble opinion)?
> > > > 
> > > > udev isn't doing any module loading, 'modprobe' is just being called for
> > > > any new module alias that shows up in the system, and all of the drivers
> > > > that match it then get loaded.
> > > 
> > > The problem is that that doesn't happen when a driver is bound to the
> > > cpu system device objects.  modprobe is just not called for modules that
> > > match the cpu modalias in that case.
> > > 
> > > If I call modprobe manually for any of the modules in question, it loads
> > > and works no problem.
> > 
> > OK, I know what's up.  udev has no rule that would allow it to load stuff on
> > the basis of MODALIAS if DRIVER is set in the event properties.
> > 
> > So, the following rule needs to be added to udev rules for things to work
> > as before:
> > 
> > DRIVER=="processor", ENV{MODALIAS}=="?*", IMPORT{builtin}="kmod load $env{MODALIAS}"
> > 
> > To be precise, I added a file called 80-drivers.rules to /etc/udev/rules.d/
> 
> Well, that wasn't a good idea, because the original 80-drivers.rules didn't
> work then, but I renamed the new file (in /etc/udev/rules.d/) to 80-cpu.rules
> and put this line (alone) into it:
> 
> ACTION="add", SUBSYSTEM=="cpu", ENV{MODALIAS}=="?*", IMPORT{builtin}="kmod load $env{MODALIAS}"

I made a mistake in the above, which should be:

ACTION=="add", SUBSYSTEM=="cpu", ENV{MODALIAS}=="?*", IMPORT{builtin}="kmod load $env{MODALIAS}"

sorry about that.

> After that change everything works happily again.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
