From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [PATCH v2] KEYS: add SP800-56A KDF support for DH
Date: Fri, 5 Aug 2016 09:08:59 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1608050858270.69454@mjmartin-mac01.local>
References: <2239809.KsND40bFeW@positron.chronox.de> <alpine.OSX.2.20.1608041258050.55029@mjmartin-mac01.local> <7993056.4BOhkDi2U3@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:36748 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759807AbcHEQJC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 12:09:02 -0400
In-Reply-To: <7993056.4BOhkDi2U3@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Fri, 5 Aug 2016, Stephan Mueller wrote:

> Am Donnerstag, 4. August 2016, 13:41:58 CEST schrieb Mat Martineau:
>
> Hi Mat,
>
>>> +
>>> +long keyctl_dh_compute(struct keyctl_dh_params __user *params,
>>> +		       char __user *buffer, size_t buflen,
>>> +		       struct keyctl_kdf_params __user *kdf)
>>> +{
>>> +	struct keyctl_kdf_params kdfcopy;
>>> +
>>> +	if (!kdf)
>>> +		return __keyctl_dh_compute(params, buffer, buflen, NULL);
>>> +
>>> +	if (copy_from_user(&kdfcopy, kdf, sizeof(kdfcopy)) != 0)
>>> +		return -EFAULT;
>>> +
>>> +	return __keyctl_dh_compute(params, buffer, buflen, &kdfcopy);
>>
>> I'd find this more readable if there was one call to __keyctl_dh_compute.
>
> When trying to implement it, I think that it would even be more confusing,
> because we need a conditional in any case. Do you like
>
> return __keyctl_dh_compute(params, buffer, buflen, (kdf) ? &kdfcopy : NULL);
>
> better than the already presented code? Besides, this would now imply that we
> have two conditionals instead of one.

Another approach that uses one conditional is to add a struct 
keyctl_kdf_params* variable and assign it in the conditional block. Maybe 
that's not much of a win, it's up to you.

--
Mat Martineau
Intel OTC
