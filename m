From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 4/5] tsc: wire up entropy generation function
Date: Tue, 14 Jun 2011 13:00:32 -0500
Message-ID: <1308074432.15617.136.camel@calx>
References: <1308002818-27802-1-git-send-email-jarod@redhat.com>
	 <1308002818-27802-5-git-send-email-jarod@redhat.com>
	 <BANLkTin=BkfyPjaWRc1rfTWU34NLdn7FLgY6yUbSrjzPpx7Gmg@mail.gmail.com>
	 <4DF690E4.1060004@zytor.com> <4DF6ADD0.6080607@borg.org>
	 <4DF6BDB4.2060201@zytor.com>  <4DF75688.2050509@borg.org>
	 <1308062037.15617.71.camel@calx>  <4DF79EF1.3010004@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Venkatesh Pallipadi <venki@google.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	Suresh Siddha <suresh.b.siddha@intel.com>
To: Kent Borg <kentborg@borg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([173.11.57.241]:34382 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1FNSAg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2011 14:00:36 -0400
In-Reply-To: <4DF79EF1.3010004@borg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2011-06-14 at 13:48 -0400, Kent Borg wrote:
> Matt Mackall wrote:
>  > Kent Borg wrote:
>  >>So network entropy is being eradicated, and nothing is being done to
>  >>replace it.
>  >
>  >Nothing is being done is a more accurate summary of the situation.
> 
> 
> So the feature-removal-schedule.txt entry about IRQF_SAMPLE_RANDOM is 
> obsolete?
> 
> (Then the trend from three network drivers to ten network drivers should 
> be accelerated and restore we should restore the deleted instances of 
> IRQF_SAMPLE_RANDOM??)
> 
> 
> -kb, the Kent who sees network adapter interrupt timing as a usually 
> good source of entropy.

It's a great source of potential entropy, a bad source of guaranteed
entropy. The current RNG tries to do accounting on the latter.
Accounting on the former is extremely suspect.

-- 
Mathematics is the supreme nostalgia of our time.
