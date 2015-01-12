From: "McCaffrey, Timothy M" <Timothy.McCaffrey@unisys.com>
Subject: RE: Crypto: Add support for 192 & 256 bit keys to AESNI RFC4106 -
 resubmission
Date: Mon, 12 Jan 2015 16:38:40 +0000
Message-ID: <fa3bab503be64741bb7c7d31f129df13@US-EXCH13-4.na.uis.unisys.com>
References: <Pine.WNT.4.64.1501112342160.7768@Fly3>
 <20150112060651.GA9726@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"tim.c.chen@linux.intel.com" <tim.c.chen@linux.intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Timothy McCaffrey <timcaffrey420@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.bemta12.messagelabs.com ([216.82.251.6]:45326 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbbALR06 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2015 12:26:58 -0500
In-Reply-To: <20150112060651.GA9726@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, January 12, 2015 1:07 AM, Herbert Xu wrote:
>On Sun, Jan 11, 2015 at 11:48:08PM -0500, Timothy McCaffrey wrote:
>>
>> This patch has been tested with Sandy Bridge and Haswell processors.  With 128
>> bit keys and input buffers > 512 bytes a slight performance degradation was
>> noticed (~1%).  For input buffers of less than 512 bytes there was no
>> performance impact.  Compared to 128 bit keys, 256 bit key size performance
>> is approx. .5 cycles per byte slower on Sandy Bridge, and .37 cycles per 
>> byte slower on Haswell (vs. SSE code).

>Thanks Tim!

>While I think your patch should definitely be applied to the
>current GCM implementation, longer term I'd like to see some
>justification why we're adding these optimizations in the form
>of gcm-aesni rather than ghash-avx and ctr-aesni.

>Is there any reason why these optimizations can't be added to
>the standalone ghash or ctr(aes)? Or for that matter is there
>some fundamental synergy that I'm not seeing that you would only
>get by putting these into gcm-aesni?

>If the answers are no and no, then I'd like to see all these
>optimizations migrated over to ghash and ctr(aes) and then we
>can simply remove gcm-aesni.

This is not so much an optimization as a bug fix.  There was some optimizations (redundant loading of registers) that I did to offset the added code necessary to support 192/256 bit keys, but besides that I restrained myself :)

Fixing it here means that the AVX/AVX2 implementations do not have to be fixed, things will just fall back to the SSE implementation.

I believe that the root cause of this problem is that these kind of algorithms do not have an entry in the table specifying key sizes they support, If they did then the code would have fallen back to aes-ctr/ghash automatically, and the strongswan bug listed wouldn't exist.

I wrote this patch because we needed the performance for 256 bit keys.  The AVX/AVX2 versions do not provide a big improvement (when you consider the overhead of IPSec frame handling), and this version will work on older platforms (Westmere, Sandy Bridge) and the new low power Bay Trail platforms.

As far as why:  the original idea was to compute the AES-CTR and the ghash in parallel, thus getting one of them for (almost) free.  This does work as advertised.  I have not looked at the aesni-ghash code, but I think the aes-ctr code is already pretty streamlined.  Any optimizations done in gcm-aesni are going to be specific to these two algorithms being interleaved more efficiently.

	- Tim
