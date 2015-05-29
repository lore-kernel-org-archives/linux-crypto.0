From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: algif_aead - Switch to new AEAD interface
Date: Fri, 29 May 2015 23:32:09 +0200
Message-ID: <1459394.UYHQzFnBPg@tachyon.chronox.de>
References: <20150527092441.GA27913@gondor.apana.org.au> <20150529132840.GA20596@gondor.apana.org.au> <4167986.EDUjNpGSba@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58352 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756266AbbE2VcP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 17:32:15 -0400
In-Reply-To: <4167986.EDUjNpGSba@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 29. Mai 2015, 16:50:50 schrieb Stephan Mueller:

Hi Herbert,

> 
> Do we really need to copy in and copy out unneeded data? That sounds very
> inefficient. Besides, can't we leave it to user space to build the right
> memory structure? I.e. if user space wants in-place operation, it needs to
> ensure that the one buffer is sufficient for the requested operation (i.e.
> that the requirements for src lengths and dst lengths are covered).

Please disregard my comment for the memory structure -- using IOVECs, 
userspace is free to format the memory layout as necessary.

PS: I tested all code paths that I see for the new algif_aead and it works 
with the code currently in your tree. Please disregard the discussion around 
code changes.

-- 
Ciao
Stephan
