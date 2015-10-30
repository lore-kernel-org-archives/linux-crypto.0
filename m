From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: algif_hash - Only export and import on sockets with data
Date: Sat, 31 Oct 2015 00:45:47 +0100
Message-ID: <2587504.xtsMOV5mei@myon.chronox.de>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com> <3576256.SqRabKS4lK@tauon.atsec.com> <20151030121651.GA23757@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Harsh Jain <harshjain.prof@gmail.com>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34484 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbbJ3Xpx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Oct 2015 19:45:53 -0400
In-Reply-To: <20151030121651.GA23757@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 30. Oktober 2015, 20:16:51 schrieb Herbert Xu:

Hi Herbert,

> 
> setkey should be needed as the subsequent accept will all be based
> on the same parent fd, meaning that they will all use a single tfm.
> 
> Please try the following patch.

Testing complete: patch solves the oops and allows to successfully perform 
HMAC even when having subsequent accepts and operating on those subsequent 
accepts.

-- 
Ciao
Stephan
