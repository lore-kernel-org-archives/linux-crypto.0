From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Fri, 24 Jun 2016 09:27:12 +0200
Message-ID: <733379976.TmXhNiYQ9x@positron.chronox.de>
References: <20160622101432.GA30454@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:38120 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbcFXH1P (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 03:27:15 -0400
In-Reply-To: <20160622101432.GA30454@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 22. Juni 2016, 18:14:32 schrieb Herbert Xu:

Hi Herbert,

Something breaks with this patch set in public_key_verify_signature

I get tons of these:

[    1.838720] PKCS#7 signature not signed with a trusted key


Furthermore, my CAVS testing with public_key_verify_signature always EINVAL.

SigGen using the kernel crypto API interfaces work though.

Ciao
Stephan
