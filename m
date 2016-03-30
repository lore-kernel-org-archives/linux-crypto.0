From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v3 7/7] crypto: AF_ALG - add support for key_id
Date: Wed, 30 Mar 2016 10:19:43 -0700
Message-ID: <56FC0AAF.3000404@intel.com>
References: <20160330005734.25410.28829.stgit@tstruk-mobl1>
 <20160330005649.25410.70508.stgit@tstruk-mobl1>
 <14284.1459355506@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, smueller@chronox.de,
	linux-api@vger.kernel.org, marcel@holtmann.org,
	linux-kernel@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org,
	davem@davemloft.net
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:10495 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbcC3RZI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 30 Mar 2016 13:25:08 -0400
In-Reply-To: <14284.1459355506@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,
On 03/30/2016 09:31 AM, David Howells wrote:
>> +	keyring = request_key(&key_type_asymmetric, key_name, NULL);
>> > +
>> > +	err = -ENOKEY;
>> > +	if (IS_ERR(keyring))
>> > +		goto out;
>> > +
>> > +	pkey = keyring->payload.data[asym_crypto];
> NAK.  This is liable to crash in future.  You may not assume that you know
> what keyring->payload.data[asym_crypto] points to.
> 
> You may not use struct public_key outside of crypto/asymmetric_key/.  It's the
> internal data of the software subtype.  I'll move it out of the global header
> to remove the temptation;-).
> 
> You must use accessor functions such as verify_signature().  Feel free to add
> further accessor functions such as query_asym_capabilities(),
> create_signature(), encrypt_blob() and decrypt_blob() or something like that.

Thanks for your response. I thought that the public_key_query_sw_key(pkey)
check was enough for now.
I'll remove public_key stuff from af_alg and add the accessors.
Thanks,
-- 
TS
