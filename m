From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: RSA/MPI handling issues and keyctl access to public key keyrings
Date: Wed, 11 May 2016 14:11:13 -0700
Message-ID: <a3d967dd-697c-e20d-3a57-c53fc161bd05@intel.com>
References: <268bb9cd-08ca-aae9-5b12-91d8c0195bc1@intel.com>
 <7781.1462785198@warthog.procyon.org.uk>
 <2114.1462974956@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: "Zaborowski, Andrew" <andrew.zaborowski@intel.com>,
	"keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11916 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbcEKVMN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 17:12:13 -0400
In-Reply-To: <2114.1462974956@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/11/2016 06:55 AM, David Howells wrote:
> Tadeusz Struk <tadeusz.struk@intel.com> wrote:
> 
>>>  (2) rsa-pkcs1pad needs to indicate what the maximum content size is, given
>>>      the minimum possible padding for the specified hash type (ie. a
>>>      particular OID).
>>
>> The user needs to use crypto_akcipher_maxsize(tfm) to get the required buffer
>> size for a given key.
>> We do check if the buffer if big enough to accommodate padding and hash info.
>> This is needed in sign and encrypt operations, and in both cases we check it,
>> sign:
>> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/rsa-pkcs1pad.c#n434
>> and encrypt:
>> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/rsa-pkcs1pad.c#n252
> 
> Can you supply a way to find out the reduced size from the padding?
> 

Hi David,
What exactly do you want to do? For the verify operation we don't know the
reduced size before the operation. We only figure it out after we decrypt
the message and then the req->dst_len gets the actual size of the message
without padding.
Thanks,
-- 
TS
