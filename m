From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: key retention service: DH support
Date: Tue, 24 May 2016 09:22:22 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605240851210.7071@tmhoole-mobl2.amr.corp.intel.com>
References: <1884439.7dZQH0lY4q@tauon.atsec.com> <27639.1464073468@warthog.procyon.org.uk> <28895.1464074381@warthog.procyon.org.uk> <2025704.nsKCcck7Ux@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, mathew.j.martineau@linux.intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:12346 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbcEXQWZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 May 2016 12:22:25 -0400
In-Reply-To: <2025704.nsKCcck7Ux@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Tue, 24 May 2016, Stephan Mueller wrote:

> Am Dienstag, 24. Mai 2016, 08:19:41 schrieb David Howells:
>
> Hi David,
>
>> Stephan Mueller <smueller@chronox.de> wrote:
>>> The KDF patches are fully tested. All that would be needed on the key
>>> retention side after the shared secret generation are the following calls:
>>>
>>> kdf = crypto_alloc_rng(NAME, 0, 0);
>>>
>>> crypto_rng_reset(kdf, <shared_secret>, sizeof(<shared_secret>));
>>>
>>> crypto_rng_generate(kdf, LABEL, sizeof(LABEL), outbuf, outbuflen);
>>>
>>> NAME would be the KDF type such as "kdf_ctr(hmac(sha256))"
>>>
>>> LABEL would be an arbitrary string defined by the key service (e.g.
>>> "LxKeyRet").
>>
>> So there wouldn't be a change to the DH keyctl (including functional)?
>
> Assuming that the LABEL and/or the KDF name are not configurable by user
> space, the only potential difference I would see is that a user could ask for
> the length of the output data.

KDF transformations would be extremely useful, but transforming the DH 
output using a KDF needs to be configurable. There are enough different 
uses for DH that it's important to have access to the raw values.

Since the KDF patches are not yet merged, I'm not sure of the best way to 
accomodate the future feature. We could future-proof KEYCTL_DH_COMPUTE by 
adding a 5th arg, an optional pointer to KDF configuration (NAME and 
LABEL). Or a separate KEYCTL_DH_COMPUTE_KDF command can be added later.

--
Mat Martineau
Intel OTC
