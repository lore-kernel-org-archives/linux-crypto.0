From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Tue, 20 Jan 2015 04:54:44 +0100
Message-ID: <2151453.hYZ6xmSv8n@tauon>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <1490816.1NddvTAE2F@tauon> <20150120033704.GB10814@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59561 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbbATDyw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2015 22:54:52 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S10E44> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Tue, 20 Jan 2015 04:54:47 +0100
In-Reply-To: <20150120033704.GB10814@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 20. Januar 2015, 14:37:05 schrieb Herbert Xu:

Hi Herbert,

>On Tue, Jan 20, 2015 at 04:35:41AM +0100, Stephan Mueller wrote:
>> This in turn would then turn the __driver implementation into a full
>> GCM implementation. That would mean that we should rename it from
>> __driver into gcm(aes) / gcm-aesni.
>
>No you shouldn't because it'll fail in interrupt context where
>you cannot use those special instructions.

How would the fail manifest itself? If algif_aead would be present, user 
space could use the __driver implementation regardless of a setkey or 
authsize callback by simply calling encrypt/decrypt. Would the error be 
limited to that caller only?
>
>The whole point of this setup is to use accelerated instructions
>where possible, and otherwise fall back to a separate thread
>where we can do so safely.

Thanks for clarification.
>
>Cheers,


Ciao
Stephan
