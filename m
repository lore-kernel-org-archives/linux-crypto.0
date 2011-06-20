From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] Feed entropy pool via high-resolution clocksources
Date: Sun, 19 Jun 2011 17:01:07 -0700
Message-ID: <4DFE8DC3.9020105@zytor.com>
References: <4DF77BBC.8090702@redhat.com> <1308071629.15617.127.camel@calx> <4DF7C1CD.4060504@redhat.com> <1308087902.15617.208.camel@calx> <4DF7E5FB.3080907@redhat.com> <1308093142.15617.233.camel@calx> <4DFBAF75.30505@zytor.com> <1308342487.15617.552.camel@calx> <4DFD2972.7020603@zytor.com> <20110619133843.GA2900@neilslaptop.think-freely.org> <20110619150758.GB14723@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Matt Mackall <mpm@selenic.com>,
	Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
	"Venkatesh Pallipadi (Venki)" <venki@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steve Grubb <sgrubb@redhat.com>,
	Fenghua Yu <fenghua.yu@intel.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:44441 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870Ab1FTABl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Jun 2011 20:01:41 -0400
In-Reply-To: <20110619150758.GB14723@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/19/2011 08:07 AM, Herbert Xu wrote:
> On Sun, Jun 19, 2011 at 09:38:43AM -0400, Neil Horman wrote:
>>
>> It sounds to me like, if its desireous to bypass the entropy pool, then we
>> should bypass the /dev/random path altogether.  Why not write a hwrng driver
>> that can export access to the rdrand instruction via a misc device.
> 
> I presume the rdrand instruction can be used from user-space
> directly.
> 

Yes, it can.

Again, RDRAND is not suitable for /dev/random (as opposed to
/dev/urandom users.)  /dev/urandom is used both by user space (and here
the only reason to hook it up to /dev/urandom is compatibility with
existing userspace; we are working separately to enabling user space
users like OpenSSL to use RDRAND directly) and by kernel users via the
internal APIs.

/dev/random as far as I can tell is only ever fed to userspace, however,
the guarantees that it is at least supposed to give are very, very
strict.  RDRAND do not fulfill those criteria, but we should be able to
use it as part of its implementation.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
