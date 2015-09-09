From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 4/8] crypto: akcipher - Changes to asymmetric key API
Date: Wed, 09 Sep 2015 18:41:26 +0200
Message-ID: <12219786.VJTHR804Rs@tauon.atsec.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1> <3897798.9eVMxC27Hh@tauon.atsec.com> <55F05E68.1010205@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33827 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438AbbIIQlb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:41:31 -0400
In-Reply-To: <55F05E68.1010205@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 9. September 2015, 09:29:28 schrieb Tadeusz Struk:

Hi Tadeusz,

>>> + * @key:	BER encoded public key
>> 
>> DER encoded?
>
>It is BER (Basic Encoding Rules), which is also valid DER (Distinguished
>Encoding Rules)

I was just mentioning that since the ASN.1 structure now is equivalent to 
OpenSSL and what DER specifies. I just wanted to suggest to allow readers to 
establish a connection between OpenSSL DER encoded keys and the keys we use 
here.


Ciao
Stephan
