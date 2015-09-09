From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [PATCH 4/8] crypto: akcipher - Changes to asymmetric key API
Date: Wed, 9 Sep 2015 20:53:23 +0200
Message-ID: <CAOq732KAFJdrb=CV3K2k9yd4Wo5dAUWMCmzyvva+xvT-n8Z46g@mail.gmail.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
	<3897798.9eVMxC27Hh@tauon.atsec.com>
	<55F05E68.1010205@intel.com>
	<12219786.VJTHR804Rs@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:32965 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbbIISxY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 14:53:24 -0400
Received: by wiclk2 with SMTP id lk2so2182044wic.0
        for <linux-crypto@vger.kernel.org>; Wed, 09 Sep 2015 11:53:23 -0700 (PDT)
In-Reply-To: <12219786.VJTHR804Rs@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On 9 September 2015 at 18:41, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 9. September 2015, 09:29:28 schrieb Tadeusz Struk:
>>>> + * @key:   BER encoded public key
>>>
>>> DER encoded?
>>
>>It is BER (Basic Encoding Rules), which is also valid DER (Distinguished
>>Encoding Rules)
>
> I was just mentioning that since the ASN.1 structure now is equivalent to
> OpenSSL and what DER specifies. I just wanted to suggest to allow readers to
> establish a connection between OpenSSL DER encoded keys and the keys we use
> here.

Shouldn't the BER/DER requirement be only mentioned in rsa.c?  For
other asymmetric key ciphers there may, in theory, be a completely
different established key encoding and no point in using DER on top.

Also a question regarding .get_len: for RSA with padding the minimum
dest buffer length depends on the input.  What is that call supposed
to return in that case?

Best regards
