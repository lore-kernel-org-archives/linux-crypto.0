From: Tadeusz Struk <tstruk@gmail.com>
Subject: Re: [RFC PATCH 5/8] KEYS: Provide software public key query function
 [ver 3]
Date: Wed, 11 May 2016 17:17:10 -0700
Message-ID: <92771fa9-e5a8-2721-519b-f91da21deb3e@gmail.com>
References: <20160511142152.4743.14414.stgit@warthog.procyon.org.uk>
 <20160511142230.4743.12500.stgit@warthog.procyon.org.uk>
 <alpine.OSX.2.20.1605111624090.16566@mjmartin-mac01.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34793 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbcELASY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 May 2016 20:18:24 -0400
In-Reply-To: <alpine.OSX.2.20.1605111624090.16566@mjmartin-mac01.local>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/11/2016 04:50 PM, Mat Martineau wrote:
> 
>> +    len = crypto_akcipher_maxsize(tfm);
>> +    info->key_size = len * 8;
>> +    info->max_data_size = len;
>> +    info->max_sig_size = len;
>> +    info->max_enc_size = len;
>> +    info->max_dec_size = len;
> 
> If len > UINT16_MAX, should UINT16_MAX be reported as the max size? Similar question for len*8 and key_size.

Hi Mat,
Since all the operations performed are mod key->n the output will never be bigger
than size of pkey->n, which is the return value from crypto_akcipher_maxsize(tfm)
for a given key.
Thanks,
-- 
TS
