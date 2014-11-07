From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for userspace
Date: Fri, 07 Nov 2014 10:53:58 -0800
Message-ID: <545D1546.1020308@intel.com>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1> <20141106195953.13328.77022.stgit@tstruk-mobl1> <20141107025607.GA9474@gondor.apana.org.au> <545C3FDB.4010106@intel.com> <20141107040531.GA9865@gondor.apana.org.au> <545C5786.4030205@intel.com> <20141107053105.GA17825@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28918 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213AbaKGS4a (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2014 13:56:30 -0500
In-Reply-To: <20141107053105.GA17825@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 11/06/2014 09:31 PM, Herbert Xu wrote:
> On Thu, Nov 06, 2014 at 09:24:22PM -0800, Tadeusz Struk wrote:
>>
>> What about aead? Using my algif_qat I can build a single request to HW
>> that preforms both encryption and authentication in one go, ever for
>> things like aes-cbc-hmac-sha1. This allows me to get great performance
>> of authenticated encryption from user space.
> 
> aead is simpler as it's already part of the API so we just need to
> add algif_aead.
> 
> Cheers,
> 

For the asymmetric crypto below are the operations and algorithms the
QAT HW can accelerate.

* DH:
1. Diffie-Hellman phase 1 operations as defined in the PKCS #3 standard.
2. Diffie-Hellman phase 2 operations as defined in the PKCS #3 standard.

* DSA:
1. Generate DSA P Parameter - performs FIPS 186-3 Appendix A.1.1.2 steps
11.4 (c = X mod 2q) and 11.5 (p = X - (c - 1)), and 11.7 (Test whether p
is prime)
2. Generate DSA G Parameter - performs FIPS 186-3 Appendix A.2.1, steps
1 (e = (p - 1)/q), 3 g = h^e mod p, and 4
3. Generate DSA Y Parameter - performs FIPS 186-3 section 4.1 (y = g^x
mod p)
4. Generate DSA R Signature - performs FIPS 186-3 Section 4.6: r = (g^k
mod p) mod q
5. Generate DSA S Signature - performs FIPS 186-3 Section 4.6: s =
(k^-1(z + xr)) mod q
6. Generate DSA R and S Signatures - performs FIPS 186-3 Section 4.6: r
= (g^k mod p) mod q, s = (k^-1(z + xr)) mod q
7. Verify DSA R and S signatures - performs FIPS 186-3 Section 4.7:
 w = (s')^-1 mod q
 u1 = (zw) mod q
 u2 = ((r')w) mod q
 v = (((g)^u1 (y)^u2) mod p) mod q

* RSA:
1. Generate RSA keys - as specified in the PKCS #1 V2.1 standard
2. Perform the RSA encrypt (verify) primitive
3. Perform the RSA decrypt (sign) primitive

* EC:
1. Elliptic Curve Point Multiplication as defined in ANSI X9.63 Annex D.3.2
2. Elliptic Curve Point Verification as defined in ANSI X9.62 Annex
A.4.2 steps a, b and c.
3. ECDH Point Multiplication as defined in ANSI X9.63 2001 section 5.4
4. ECDSA generate signature R as per ANSI X9.62 2005 section 7.3
5. ECDSA generate signature S as per ANSI X9.62 2005 section 7.3.
6. ECDSA generate signature R & S as per ANSI X9.62 2005 section 7.3.
7. ECDSA Verify as per ANSI X9.62 2005 section 7.4

* The QAT HW can also perform modular exponentiation operation: r =
(base ^ exponent) mod modulus, and modular inversion operation: r =
(1/A) mod modulus

* It can also probabilistically test if a number is prime using GCD,
Fermat, Miller-Rabin, and Lucas testing methods using all combinations
of these methods:
(1x GCD) + (1x Fermat) + (up to 50x Miller-Rabin rounds) + (1x Lucas)

* and it can also accelerate SSL, TLS and TLSv2 key generation and MGF1
as per RFC3447, and Extended Mask Generation Function.

Are you planning to add all of these to the API?
Maybe it will be easier to add a generic af_alg_type e.g "af_direct" for
the HW drivers to use to implement HW specific functionality for the
stuff that is not yet (or never will) on the API?
I can try to put something together.
Regards,
Tadeusz
