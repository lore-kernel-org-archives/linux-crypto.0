From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v8 6/6] crypto: AF_ALG - add support for key_id
Date: Tue, 5 Jul 2016 13:27:04 -0700
Message-ID: <e011a955-70c1-0419-9e2d-dea75d319da3@intel.com>
References: <146672252642.23101.15972023870303797249.stgit@tstruk-mobl1.ra.intel.com>
 <146672255872.23101.10938182451423661314.stgit@tstruk-mobl1.ra.intel.com>
 <alpine.OSX.2.20.1606291104130.37168@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, herbert@gondor.apana.org.au,
	smueller@chronox.de, linux-api@vger.kernel.org,
	marcel@holtmann.org, linux-kernel@vger.kernel.org,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	dwmw2@infradead.org, davem@davemloft.net
To: Mat Martineau <mathew.j.martineau@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:60535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbcGEU1G (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Jul 2016 16:27:06 -0400
In-Reply-To: <alpine.OSX.2.20.1606291104130.37168@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Mat,
On 06/29/2016 11:43 AM, Mat Martineau wrote:
>> +    ret = verify_signature(key, &sig);
>> +    if (!ret) {
>> +        req->dst_len = sizeof(digest);
> 
> I think you fixed the BUG_ON() problem but there's still an issue with
> the handling of the digest. Check the use of sig->digest in
> public_key_verify_signature(), it's an input not an output. Right now it
> looks like 20 uninitialized bytes are compared with the computed digest
> within verify_signature, and then the unintialized bytes are copied to
> req->dst here.
> 
> With some modifications to public_key_verify_signature you could get the
> digest you need, but I'm not sure if verification with a hardware key
> (like a key in a TPM) can or can not provide the digest needed. Maybe
> this is why the verify_signature hook in struct asymmetric_key_subtype
> is optional.
> 
>> +        scatterwalk_map_and_copy(digest, req->dst, 0, req->dst_len, 1);
>> +    } 

So it looks like the only thing that we need to return to the user in
this case is the return code. Do you agree?
Thanks,
-- 
TS
