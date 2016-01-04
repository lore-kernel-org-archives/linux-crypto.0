From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH 1/2] crypto: af_alg - Add nokey compatibility path
Date: Mon, 4 Jan 2016 13:33:54 +0100
Message-ID: <568A66B2.4090307@gmail.com>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com> <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de> <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au> <5688ED04.4090802@gmail.com>
 <20160104043518.GA4411@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160104043518.GA4411@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


On 01/04/2016 05:35 AM, Herbert Xu wrote:
> On Sun, Jan 03, 2016 at 10:42:28AM +0100, Milan Broz wrote:
>>
>> yes, basically it prepares socket()/bind()/accept() and then it calls setkey once.
>> (I'll try to fix in next releases to call setkey first though.)
> 
> OK please try these two patches (warning, totally untested).

Well, it is not much better.

I had to apply another two patches that are not mentioned and are not in your tree yet
before it:
  crypto: af_alg - Disallow bind_setkey_... after accept(2)
  crypto: use-after-free in alg_bind

then it at least compiles correctly.

skcipher works, But I still see two compatibility problems:

- hmac() is now failing the same way (SETKEY after accept())
(I initially tested without two patches above, these are not in linux-next yet.)
This breaks all cryptsetup TrueCrypt support (and moreover all systems if
kernel crypto API is set as a default vcrypto backend - but that's not default).

- cipher_null before worked without setkey, now it requires to set key
(either before or after accept().
This was actually probably bad workaround in cryptsetup, anyway it will now cause
old cryptsetup-reencrypt tool failing with your patches.
(Try "cryptsetup benchmark -c cipher_null-ecb". I am not sure what to do here,
but not requiring setkey for "cipher" that has no key internally seems ok for me...)

As I said, I'll fix it in cryptsetup upstream but we are breaking  a lot of existing systems.
Isn't there better way, how to fix it?

Milan
