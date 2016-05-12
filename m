From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: Re: [RFC PATCH 5/8] KEYS: Provide software public key query function
 [ver 3]
Date: Thu, 12 May 2016 10:01:05 -0700 (PDT)
Message-ID: <alpine.OSX.2.20.1605120933350.23376@mjmartin-mac01.local>
References: <alpine.OSX.2.20.1605111624090.16566@mjmartin-mac01.local> <20160511142152.4743.14414.stgit@warthog.procyon.org.uk> <20160511142230.4743.12500.stgit@warthog.procyon.org.uk> <25139.1463048363@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:13593 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450AbcELRBa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 May 2016 13:01:30 -0400
In-Reply-To: <25139.1463048363@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On Thu, 12 May 2016, David Howells wrote:

> Mat Martineau <mathew.j.martineau@linux.intel.com> wrote:
>
>>> +	len = crypto_akcipher_maxsize(tfm);
>>> +	info->key_size = len * 8;
>>> +	info->max_data_size = len;
>>> +	info->max_sig_size = len;
>>> +	info->max_enc_size = len;
>>> +	info->max_dec_size = len;
>>
>> If len > UINT16_MAX, should UINT16_MAX be reported as the max size? Similar
>> question for len*8 and key_size.
>
> key_size is 32 bits, but the other sizes are all 16 bits, so you would need a
> 524288-bit key to exceed their capacity.  I'm not sure that's likely anytime
> soon, but should I just make all the sizes 32-bit anyway?

Given that cryto_akcipher_maxsize() returns an int and keyctl_pkey_query 
is part of the userspace API, I support bumping the sizes to 32-bit.

--
Mat Martineau
Intel OTC
