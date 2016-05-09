From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: pkcs1pad_verify_complete: decoding missing?
Date: Mon, 9 May 2016 12:31:21 -0700
Message-ID: <5f4797dd-323e-ca0b-3559-4b0ac4a4ac0b@intel.com>
References: <5061410.3QzdTXsEjv@positron.chronox.de>
 <10395258.qUa3tSVhS8@tauon.atsec.com>
 <ee26539d-0447-d9cc-a2d7-370cfe05781a@intel.com>
 <1867642.XvlejD3yXB@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:3000 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbcEITc1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 May 2016 15:32:27 -0400
In-Reply-To: <1867642.XvlejD3yXB@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/09/2016 12:24 PM, Stephan Mueller wrote:
> Am Montag, 9. Mai 2016, 12:17:21 schrieb Tadeusz Struk:
> 
> Hi Tadeusz,
> 
>> On 05/09/2016 12:02 PM, Stephan Mueller wrote:
>>> One followup: is the final memcmp() between the decrypted hash and the
>>> hash of the message implemented in the RSA verify code path? At least I
>>> do not see it right away.
>>
>> It's in line #549
> 
> Do you rather mean line 535? If yes, how would I provide the message digest to 
> the verify function?
> 
> Please note that at the main driver of my question is 
> https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/asymmetric_keys/public_key.c#n143
> where the caller implements the memcmp().
> 

Sorry, I misread your question. Yes, the final data comparison needs to be done by the user.
We don't have the original msg (or its digest) in the context of the verify operation.
The only thing we are given is the encrypted message (and the key to decrypt it).
And you are right, in this case it is done in:
https://git.kernel.org/cgit/linux/kernel/git/herbert/cryptodev-2.6.git/tree/crypto/asymmetric_keys/public_key.c#n143 
Thanks,
-- 
TS
