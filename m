From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v2] crypto: algif_skcipher - Require setkey before
 accept(2)
Date: Sun, 3 Jan 2016 10:42:28 +0100
Message-ID: <5688ED04.4090802@gmail.com>
References: <CACT4Y+YOwOfRHOwJ=FA9aaL2cZ-PRhTvd_mCzxx2nnN_L3tygw@mail.gmail.com>
 <5687BA0F.3020104@gmail.com> <5687E19E.2070801@gmail.com>
 <1647086.cdlVYfuqk1@myon.chronox.de> <56883096.1020009@gmail.com>
 <20160103013126.GA30385@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Dmitry Vyukov <dvyukov@google.com>, syzkaller@googlegroups.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kcc@google.com, glider@google.com,
	edumazet@google.com, sasha.levin@oracle.com, keescook@google.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35208 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbcACJmc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jan 2016 04:42:32 -0500
In-Reply-To: <20160103013126.GA30385@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/03/2016 02:31 AM, Herbert Xu wrote:
> On Sat, Jan 02, 2016 at 09:18:30PM +0100, Milan Broz wrote:
>>
>> But I cannot change thousands of cryptsetup installations that are actively using that code.
>> This is clear userspace breakage which should not happen this way.
> 
> I'll try to add some compatibility code for your case, assuming
> your modus operandi is accept(2) followed by a single setkey before
> proceeding to encryption/decryption.

Hi,

yes, basically it prepares socket()/bind()/accept() and then it calls setkey once.
(I'll try to fix in next releases to call setkey first though.)

I am doing exactly the same for AF_ALG HMAC (hmac(<hash>) key,
does this requirement for order if accept/setkey applies there as well?
(It is not enforced yet.)

Anyway, you can easily simulate that skcipher API call just with running "cryptsetup benchmark"
(with accept() patch it will print N/A for all ciphers while without patch it measures some
more-or-less magic performance numbers :)

> 
>> (Moreover it still doesn't work for cipher_null that has min/max key size 0.)
> 
> Setkey works just fine on cipher_null.

Yes, it works if ALG_SET_KEY is set to zero-length key.
I just re-introduced old bug to code, sorry.

Thanks!
Milan
