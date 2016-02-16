From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: implement DH primitives under akcipher API
Date: Tue, 16 Feb 2016 12:29:33 -0800
Message-ID: <56C386AD.9070403@intel.com>
References: <1455526915-23104-1-git-send-email-salvatore.benedetto@intel.com>
 <20160216201939.GB11908@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22817 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932079AbcBPUdm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 15:33:42 -0500
In-Reply-To: <20160216201939.GB11908@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/16/2016 12:19 PM, Herbert Xu wrote:
> On Mon, Feb 15, 2016 at 09:01:55AM +0000, Salvatore Benedetto wrote:
>> > Implement Diffie-Hellman primitives required by the scheme under the
>> > akcipher API. Here is how it works.
>> > 1) Call set_pub_key() by passing DH parameters (p,g) in PKCS3 format
>> > 2) Call set_priv_key() to set your own private key (xa) in raw format
>> > 3) Call decrypt() without passing any data as input to get back the
>> >    public part which will be computed as g^xa mod p
>> > 4) Call encrypt() by passing the counter part public key (yb) in raw format
>> >    as input to get back the shared secret calculated as zz = yb^xa mod p
>> > 
>> > A test is included in the patch. Test vector has been generated with
>> > openssl
>> > 
>> > Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> Who is going to use this?

OpenSSL via PF_ALG. The plan for this is to accelerate TLS handshakes in HW.
This is an RFC to get your opinion on the usage of the API.
Are you ok with the approach?
Thanks,

-- 
TS
