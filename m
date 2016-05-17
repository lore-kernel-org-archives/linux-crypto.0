From: Gary R Hook <ghook@amd.com>
Subject: Re: Typos and RSA
Date: Tue, 17 May 2016 17:46:44 -0500
Message-ID: <573B9F54.7050006@amd.com>
References: <573B8BA3.8020902@amd.com>
 <1468644.THAbu50UCt@positron.chronox.de>
 <ae33e745-feca-c588-015d-bf2b4ca461f0@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	<linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0072.outbound.protection.outlook.com ([157.56.111.72]:27382
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752218AbcEQWq7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 May 2016 18:46:59 -0400
In-Reply-To: <ae33e745-feca-c588-015d-bf2b4ca461f0@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Thanks so much.

There are exactly 3 references to that symbol (in my freshly pulled copy 
of cryptodev-2.6).
testmgr.c precipitates my questions, and public_key.c doesn't actually 
provide any content
in the source input buffer, neither modulus nor plaintext. Thus, it 
doesn't clarify things
either.

But I truly appreciate your attention.

So I'll go ahead and ask, because I did look at the two areas mentioned 
by Stephan, but
neither seem to clarify (to my admittedly ignorant eyes... I'm a real 
newbie on crypto here)
usage.

Here's my question:

The source input (as set via akcipher_request_set_crypt()) to akcipher 
is supposed to be
the modulus + plaintext. testmgr hands this in via a scatterlist with 2 
elements, wherein
the first is the modulus, the second the payload. The source length 
however, appears to
be the aggregate length of these two elements. Okay, good enough.

Since the API provides no information about the modulus length, one 
might guess that the
only way to ascertain the separate lengths of the two parts is to read 
the values from
the scatterlist structures. I get that the key (exponent) length is what 
really matters,
but the source input fields are clearly of arbitrary and unequal length.

So please forgive my ignorance, but I'm not seeing it: how do we 
decompose the two parts
of src and get their lengths? What can we expect on the receiving end of 
the encrypt
function with respect to the source data structure? A two-element 
scatterlist? Or...?
What can we conclude from the calls made in do_test_rsa() in testmgr.c, 
vs the call in
public_key_verify_signature() in public_key.c re: invocation and 
provided data.

Any clarification is greatly appreciated.

Gary


On 05/17/2016 05:18 PM, Tadeusz Struk wrote:
> On 05/17/2016 03:16 PM, Stephan Mueller wrote:
>>> I am working on hooking up RSA functionality to the akcipher API. It appears
>>>> that no other code, to date, uses this API. Can anyone confirm or deny that
>>>> conclusion?
>> This is not correct. The asymmetric key API uses that code. So does the module
>> signing code.
> Also you can have a look at testmgr.c for examples.
> "git grep crypto_alloc_akcipher" is also useful.
>
> Thanks,
