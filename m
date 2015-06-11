From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: drbg - Add select on sha256
Date: Thu, 11 Jun 2015 03:37:38 +0200
Message-ID: <7796083.9xmz0KqbMC@tachyon.chronox.de>
References: <20150611005510.GA9267@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46202 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798AbbFKBhv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 21:37:51 -0400
In-Reply-To: <20150611005510.GA9267@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 11. Juni 2015, 08:55:10 schrieb Herbert Xu:

Hi Herbert,

> The hash-based DRBG variants all use sha256 so we need to add a
> select on it.

Would that be sufficient? We can have SHA1, SHA384 and SHA512 with the current 
drbg_cores[] too.

-- 
Ciao
Stephan
