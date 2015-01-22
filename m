From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: aesni: add setkey for driver-gcm-aes-aesni
Date: Thu, 22 Jan 2015 22:20:30 +0100
Message-ID: <1876694.bQrN48MF7q@tauon>
References: <2587101.YvN0IxRmOH@tachyon.chronox.de> <40625395.stBBYbAQtz@tachyon.chronox.de> <54C1403D.1010608@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60109 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbbAVVUi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Jan 2015 16:20:38 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S118EE> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Thu, 22 Jan 2015 22:20:34 +0100
In-Reply-To: <54C1403D.1010608@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 22. Januar 2015, 10:23:57 schrieb Tadeusz Struk:

Hi Tadeusz,

>On 01/20/2015 05:25 PM, Stephan Mueller wrote:
>>> Rather than adding a bogus setkey function, please fix this mess
>>> properly by moving the top-level setkey function into the __driver
>>> one where it should be.  Compare with how we handle it in the
>>> ablk_helper which is pretty much the same thing.
>> 
>> Tadeusz, are you working on that update or shall I have a look?
>
>Hi,
>No, I thought that the agreement was that we don't want to allow user
>space to use these helpers directly, right? Am I missing something?


That would be correct. But if I understood Herbert correctly, he is 
creating a patch that disables these service ciphers for general usage.

Ciao
Stephan
