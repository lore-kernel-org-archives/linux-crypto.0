From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC v5 4/4] crypto: add tests vectors for RSA
Date: Mon, 15 Jun 2015 23:26:58 -0700
Message-ID: <557FC1B2.1090603@intel.com>
References: <20150615201831.15697.57738.stgit@tstruk-mobl1> <20150615201853.15697.45868.stgit@tstruk-mobl1> <20150616003741.GA18212@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, smueller@chronox.de, richard@nod.at,
	steved@redhat.com, qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45135 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbbFPG1V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Jun 2015 02:27:21 -0400
In-Reply-To: <20150616003741.GA18212@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/15/2015 05:37 PM, Herbert Xu wrote:
>>  config CRYPTO_MANAGER
>> >  	tristate "Cryptographic algorithm manager"
>> >  	select CRYPTO_MANAGER2
>> > +	select CRYPTO_AKCIPHER
> Please add this to CRYPTO_MANAGER2 instead.

This causes a recursive dependency error

crypto/Kconfig:115:error: recursive dependency detected!
crypto/Kconfig:115:	symbol CRYPTO_MANAGER2 default value contains CRYPTO_ALGAPI
crypto/Kconfig:34:	symbol CRYPTO_ALGAPI is selected by CRYPTO_AKCIPHER
crypto/Kconfig:94:	symbol CRYPTO_AKCIPHER is selected by CRYPTO_MANAGER2
