From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Sun, 19 Jun 2011 08:07:58 -0700
Message-ID: <20110619150758.GB14723@gondor.apana.org.au>
References: <4DF77BBC.8090702@redhat.com> <1308071629.15617.127.camel@calx> <4DF7C1CD.4060504@redhat.com> <1308087902.15617.208.camel@calx> <4DF7E5FB.3080907@redhat.com> <1308093142.15617.233.camel@calx> <4DFBAF75.30505@zytor.com> <1308342487.15617.552.camel@calx> <4DFD2972.7020603@zytor.com> <20110619133843.GA2900@neilslaptop.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Mackall <mpm@selenic.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Grubb <sgrubb@redhat.com>,
	Fenghua Yu <fenghua.yu@intel.com>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33591 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab1FSPI1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2011 11:08:27 -0400
Content-Disposition: inline
In-Reply-To: <20110619133843.GA2900@neilslaptop.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 19, 2011 at 09:38:43AM -0400, Neil Horman wrote:
>
> It sounds to me like, if its desireous to bypass the entropy pool, then we
> should bypass the /dev/random path altogether.  Why not write a hwrng driver
> that can export access to the rdrand instruction via a misc device.

I presume the rdrand instruction can be used from user-space
directly.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
