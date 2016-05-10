From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v5 0/3] Key-agreement Protocol Primitives (KPP) API
Date: Tue, 10 May 2016 09:02:31 +0200
Message-ID: <6917609.BxtCJBuMZE@positron.chronox.de>
References: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55098 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922AbcEJHC0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 May 2016 03:02:26 -0400
In-Reply-To: <1462830041-7582-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 9. Mai 2016, 22:40:38 schrieb Salvatore Benedetto:

Hi Salvatore,

> Hi Herb,
> 
> the following patchset introduces a new API for abstracting key-agreement
> protocols such as DH and ECDH. It provides the primitives required for
> implementing the protocol, thus the name KPP (Key-agreement Protocol
> Primitives).
> 
> Regards,
> Salvatore
> 
> Changes from v4:
> * If fips_enabled is set allow only P256 (or higher) as Stephan suggested

Thank you.

What I am wondering though is whether the kernel crashes in FIPS mode with 
this implementation as follows: there are test vectors for P192 which seem(?) 
to be called unconditionally. In FIPS mode, we do not have P192 and the ECC 
code returns an error when using this curve. Thus, wouldn't the self test fail 
for P192?

Now, in FIPS mode, panic() is called when a self test fails.


Ciao
Stephan
