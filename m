From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 4/8] crypto: akcipher - Changes to asymmetric key API
Date: Wed, 9 Sep 2015 09:44:59 -0700
Message-ID: <55F0620B.5080007@intel.com>
References: <20150909161454.2828.70445.stgit@tstruk-mobl1>
 <3897798.9eVMxC27Hh@tauon.atsec.com> <55F05E68.1010205@intel.com>
 <12219786.VJTHR804Rs@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:9385 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbbIIQqr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Sep 2015 12:46:47 -0400
In-Reply-To: <12219786.VJTHR804Rs@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/09/2015 09:41 AM, Stephan Mueller wrote:
>> >It is BER (Basic Encoding Rules), which is also valid DER (Distinguished
>> >Encoding Rules)
> I was just mentioning that since the ASN.1 structure now is equivalent to 
> OpenSSL and what DER specifies. I just wanted to suggest to allow readers to 
> establish a connection between OpenSSL DER encoded keys and the keys we use 

Since DER is a valid BER it will work for both.
