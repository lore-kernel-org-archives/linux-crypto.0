From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 4/8] crypto: akcipher - Changes to asymmetric key API
Date: Wed, 9 Sep 2015 09:29:28 -0700
Message-ID: <55F05E68.1010205@intel.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <20150909161520.2828.35852.stgit@tstruk-mobl1>
 <3897798.9eVMxC27Hh@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47455 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753428AbbIIQbY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:31:24 -0400
In-Reply-To: <3897798.9eVMxC27Hh@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,
On 09/09/2015 09:25 AM, Stephan Mueller wrote:
>> >+#if 0
>> > static int do_test_rsa(struct crypto_akcipher *tfm,
>> > 		       struct akcipher_testvec *vecs)
>> > {
>> >@@ -1975,6 +1976,7 @@ static int alg_test_akcipher(const struct alg_test_desc
>> >*desc, crypto_free_akcipher(tfm);
>> > 	return err;
>> > }
>> >+#endif
> Just to check: is the ifdef 0 intentional?

Yes, it is otherwise it will break the build. It is enabled in subsequent patch.

>> + * @key:	BER encoded public key
> DER encoded?
> 

It is BER (Basic Encoding Rules), which is also valid DER (Distinguished Encoding Rules)

Regards
T
