From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: Problem with RSA test from testmgr
Date: Wed, 1 Mar 2017 18:15:13 -0800
Message-ID: <122aa2a3-e478-1a68-083a-273ceabaf2fb@intel.com>
References: <20170228155953.GA1732@Red> <1836837.jAzr4JNxJu@tauon.atsec.com>
 <20170228164553.GA2155@Red> <9482066.IEBbAWS9B8@positron.chronox.de>
 <20170301120414.GA18217@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:6196 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753511AbdCBCPi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Mar 2017 21:15:38 -0500
In-Reply-To: <20170301120414.GA18217@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,
On 03/01/2017 04:04 AM, Corentin Labbe wrote:
>> I would think the issue is that the OpenSSL BIGNUM lib has some issues: when 
>> calculating m^e mod n, m has to be equal to the key size. The kernel's MPI 
>> code handles the case where m is smaller than the key size.
>>
>> Note, in your code below, ptext is the 8 bytes from ptext_ex plus trailing 
>> zeroes whereas the kernel uses just the 8 bytes.
>>
>> It seems that your implementation has the same issue.
>>
>> What about the following test: change vector->m to be 64 bytes (i.e. 
>> RSA_size(key) in size in testmgr.h and check the output of crypto/rsa.c, 
>> openssl's output with the app below and your RSA hardware.
> I got the following:
> 
> [    1.086228] alg: akcipher: encrypt test failed. Invalid output
> [    1.092196] 00000000: 6e 7c 8a 75 e7 30 80 d1 5e ab 9b db a2 cf ed db
> [    1.098882] 00000010: c9 b2 db 43 bd 9a b9 75 27 f3 73 d9 73 b7 81 8c
> [    1.105524] 00000020: 49 e8 45 fc 43 44 f5 6d f0 f7 b8 f2 ae 6b ae 49
> [    1.112090] 00000030: 1b 8e 50 c6 88 4e 99 09 78 14 f2 5d 99 c3 7f f9
> [    1.118747] alg: akcipher: test 1 failed for rsa-generic, err=-22
> (Exactly the output of my hardare and openssl test)
> 
> So the problem is just that my hardware does not handle non-padded data.

The difference between openssl's RSA_private_decrypt() and the akcipher api
is that openssl only takes only one size, flen, for both src and dst buffers,
so in your test app you need to do something like this:

	memset(ptextp, 0, 256);
	memcpy(ptextp + 64 - 8, ptext_ex, plen);

	key = RSA_new();

	key->n = BN_bin2bn(n, sizeof(n)-1, key->n);
	key->e = BN_bin2bn(e, sizeof(e)-1, key->e);

	num = RSA_public_encrypt(RSA_size(key), ptextp, ctext, key, RSA_NO_PADDING);

The akcipher API has separate sizes for both the src and dst. It is the length of the
scatterlist in the akcipher_request. If a HW can't handle different buffers lengths
then its driver needs to add the padding internally.

Thanks,
-- 
Tadeusz
