From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH 1/2] Crypto: Add support for 192 & 256 bit keys to
 AESNI RFC4106
Date: Mon, 03 Mar 2014 14:23:14 -0800
Message-ID: <1393885394.27116.113.camel@schen9-DESK>
References: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA61ADC6@USEA-EXCH7.na.uis.unisys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Guilford <james.guilford@intel.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>
To: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11738 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbaCCWXU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Mar 2014 17:23:20 -0500
In-Reply-To: <62FCA75CAF88C148AA5FC0EC0E4321C70127AA61ADC6@USEA-EXCH7.na.uis.unisys.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2014-02-28 at 17:00 -0600, McCaffrey, Timothy M wrote:
> These patches fix the RFC4106 implementation in the aesni-intel module so it supports 192 & 256 bit keys.
> Since AVX was recently added to this module, and this patch only affects the SSE implementation, changes 
> were also made to use the SSE version if key sizes other than 128 are specified.
> 
> RFC4106 specifies that 192 & 256 bit keys must be supported (section 8.4).
> 
> Also, this should fix Strongswan issue 341 where the aesni module needs to be unloaded if 256 bit keys are used:
> http://wiki.strongswan.org/issues/341
> 
> This patch has been tested with Sandy Bridge and Haswell processors.  With 128 bit keys and 
> input buffers > 512 bytes a slight performance degradation was noticed (~1%), 

We may need to test this further on our side to make sure that there 
is no more than 1% of performance degradation for the 128 bit key case,
which is the most used one.

Thanks.

Tim
>
> input buffers 
> less than 512 bytes there was no performance impact.  Compared to 128 bit keys,
> 256 bit key size performance is approx. .5 cycles per byte slower on Sandy Bridge, 
> and .37 cycles per byte slower on Haswell (vs. SSE code).
> 
> This patch has also been tested with StrongSwan IPSec connections where it worked correctly.
> 
> I created this diff from a git clone of crypto-2.6.git.  
> 
> Any questions, please feel free to contact me.
> 
