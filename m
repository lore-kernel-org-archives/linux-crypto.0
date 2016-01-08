From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 1/2] crypto: af_alg - Add nokey compatibility path
Date: Fri, 8 Jan 2016 19:21:12 +0100
Message-ID: <568FFE18.6090900@gmail.com>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com> <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de> <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au> <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au> <568A66B2.4090307@gmail.com>
 <20160108124851.GA5425@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com,
	Ondrej Kozina <okozina@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38307 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbcAHSVR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Jan 2016 13:21:17 -0500
In-Reply-To: <20160108124851.GA5425@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/08/2016 01:48 PM, Herbert Xu wrote:
> On Mon, Jan 04, 2016 at 01:33:54PM +0100, Milan Broz wrote:
>>
>> - hmac() is now failing the same way (SETKEY after accept())
>> (I initially tested without two patches above, these are not in linux-next yet.)
>> This breaks all cryptsetup TrueCrypt support (and moreover all systems if
>> kernel crypto API is set as a default vcrypto backend - but that's not default).
> 
> Yes algif_hash would need the same compatibility patch and I'm
> working on that.

Ok, I fixed this already.

> 
>> - cipher_null before worked without setkey, now it requires to set key
>> (either before or after accept().
>> This was actually probably bad workaround in cryptsetup, anyway it will now cause
>> old cryptsetup-reencrypt tool failing with your patches.
>> (Try "cryptsetup benchmark -c cipher_null-ecb". I am not sure what to do here,
>> but not requiring setkey for "cipher" that has no key internally seems ok for me...)
> 
> Is cipher_null actually used in production or is this just a
> benchmark? Using the kernel crypto API to perform no encryption
> sounds crazy.

Except benchmarks (I do not care about this) we use cipher_null in cryptsetup-reencrypt
when adding encryption in-place (plaintext-only device is converted
to LUKS, cipher_null is used during conversion for original plainext device,
then offline converted to some real cipher with key).
(It reuses the same logic as re-encryption, IOW volume key change.)

So it is used in production but just for this specific case.

Thanks,
Milan
