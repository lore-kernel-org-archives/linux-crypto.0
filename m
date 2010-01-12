From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Crypto test results unused?
Date: Tue, 12 Jan 2010 18:55:07 +0100
Message-ID: <m37hrn1a4k.fsf@intrepid.localdomain>
References: <20100112111439.GA31504@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:33570 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab0ALRzL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jan 2010 12:55:11 -0500
In-Reply-To: <20100112111439.GA31504@gondor.apana.org.au> (Herbert Xu's
	message of "Tue, 12 Jan 2010 22:14:39 +1100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.apana.org.au> writes:

>> On little-endian IXP4xx 3 hardware-assisted algorithms fail (due to
>> apparently unrelated bug which I will take care of). It seems the kernel
>> is still using these failing algorithms (my debugging code adds extra
>> fields to the /proc output):
>
> How did you determine that it was still being used? When a kernel
> user requests for an algorithm the system is supposed to skip
> anything which failed the self-test.

cat /proc/crypto shows "selftest: unknown" for those failed tests. I
don't know if that means it's used, but I'd expect "failed" or something
like that. Maybe it's simply a problem in /proc/crypto output.

> CRYPTO_ALG_DEAD is used to mark algorithms deleted from the
> system.  However, we don't delete algorithms just because they
> fail the self-test.  They remain in the system so you can come
> back and diagnose the problem.  They just aren't used by anyone.

Great.

Currently the /proc/crypto contains:

- for passed tests: "selftest: passed" (which is of course right)

- for failed tests: "selftest: unknown" (which is a surprise for me):

alg: skcipher: Test 1 failed on encryption for ecb(des)-ixp4xx
00000000: 01 23 45 67 89 ab cd e7

name         : ecb(des)
driver       : ecb(des)-ixp4xx
module       : ixp4xx_crypto
priority     : 300
refcnt       : 1
selftest     : unknown
type         : ablkcipher
async        : yes
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 0
geniv        : <default>

- for routines without a test: "selftest: passed" (which isn't true
  either)

alg: No test for authenc(hmac(md5),cbc(des)) (authenc(hmac(md5),cbc(des))-ixp4xx)

name         : authenc(hmac(md5),cbc(des))
driver       : authenc(hmac(md5),cbc(des))-ixp4xx
module       : ixp4xx_crypto
priority     : 300
refcnt       : 1
selftest     : passed
type         : aead
async        : yes
blocksize    : 8
ivsize       : 8
maxauthsize  : 16
geniv        : <built-in>

I think we need a way to differentiate between "really unknown" and
"failed", do we need another flag for it?
-- 
Krzysztof Halasa
