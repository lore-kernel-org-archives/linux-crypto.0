From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
Date: Thu, 18 Jul 2013 16:08:14 -0700
Message-ID: <1374188894.22432.354.camel@schen9-DESK>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
	 <1374098936.22432.322.camel@schen9-DESK>
	 <201307180347.r6I3l5e9077577@www262.sakura.ne.jp>
	 <1374181200.22432.350.camel@schen9-DESK>  <51E8696A.7090406@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, ak <ak@linux.intel.com>,
	rjw@rjwysocki.net
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59796 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759084Ab3GRXIL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jul 2013 19:08:11 -0400
In-Reply-To: <51E8696A.7090406@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2013-07-19 at 00:17 +0200, Rafael J. Wysocki wrote:
> On 7/18/2013 11:00 PM, Tim Chen wrote:
> > On Thu, 2013-07-18 at 12:47 +0900, Tetsuo Handa wrote:
> >> Tim Chen wrote:
> >>>>> Your approach is quite complicated.  I think something simpler like the
> >>>>> following will work:
> >>>> We cannot benefit from PCLMULQDQ. Is it acceptable for you?
> >>>
> >>> The following code in crct10dif-pclmul_glue.c
> >>>
> >>> static const struct x86_cpu_id crct10dif_cpu_id[] = {
> >>>          X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
> >>>          {}
> >>> };
> >>> MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
> >>>
> >>> will put the module in the device table and get the module
> >>> loaded, as long as the cpu support PCLMULQDQ. So we should be able
> >>> to benefit.
> >> Excuse me, how can crct10dif-pclmul.ko get loaded automatically?
> >> Did you test CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m with below debug message?
> > The code:
> >
> > static const struct x86_cpu_id crct10dif_cpu_id[] = {
> >           X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
> >           {}
> > };
> > MODULE_DEVICE_TABLE(x86cpu, crct10dif_cpu_id);
> >
> > causes the following line to be added to modules.alias file:
> >
> > alias x86cpu:vendor:*:family:*:model:*:feature:*0081* crct10dif_pclmul
> >
> > This should cause udev to load the crct10dif_pclml module when cpu
> > support the PCLMULQDQ (feature code 0081).  I did my testing during
> > development on 3.10 and the module was indeed loaded.
> >
> > However, I found that the following commit under 3.11-rc1 broke
> > the mechanism after some bisection.
> >
> > commit ac212b6980d8d5eda705864fc5a8ecddc6d6eacc
> > Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Date:   Fri May 3 00:26:22 2013 +0200
> >
> >      ACPI / processor: Use common hotplug infrastructure
> >      
> >      Split the ACPI processor driver into two parts, one that is
> >      non-modular, resides in the ACPI core and handles the enumeration
> >      and hotplug of processors and one that implements the rest of the
> >      existing processor driver functionality.
> >      
> > Rafael, can you check and see if this can be fixed so those optimized
> > crypto modules for Intel cpu that support them can be loaded?
> 
> I think this is an ordering issue between udev startup and the time when 
> devices are registered.

Something that can be fixed?

> 
> I wonder what happens if you put those modules into the initramfs image?

Under initramfs image's /lib/modules/3.11.0-rc1/kernel/arch/x86/crypto
directory?  Any files in /lib/modules/3.11.0-rc1/modules.* need to be
modified?

Tim
