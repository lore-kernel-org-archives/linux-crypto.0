From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Allow ecb(cipher_null) in FIPS mode
Date: Fri, 21 Apr 2017 20:56:09 +0200
Message-ID: <9105605.SAXsSHs1iB@tauon.chronox.de>
References: <20170421121820.GA14381@gondor.apana.org.au> <8205294.2qxUD6mCvD@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>, linux-crypto@vger.kernel.org
To: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59130 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424278AbdDUS4Q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 14:56:16 -0400
In-Reply-To: <8205294.2qxUD6mCvD@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 21. April 2017, 17:25:41 CEST schrieb Stephan Müller:

Hi,

> 
> Acked-by: Stephan Müller <smueller@chronox.de>

Just for the records: for FIPS 140-2 rules, cipher_null is to be interpreted 
as a memcpy on SGLs. Thus it is no cipher even though it sounds like one.

cipher_null is also needed for seqiv which is required for rfc4106(gcm(aes)), 
which is an approved cipher. Also, it is needed for authenc() which uses it 
for copying the AAD from src to dst.

That said, cipher_null must not be used for "encryption" operation but rather 
for handling data that is not subjected to FIPS 140-2 rules.

Ciao
Stephan
