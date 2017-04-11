From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Fwd: [linux-next:master 7274/8070] undefined reference to `crypto_alloc_shash'
Date: Tue, 11 Apr 2017 12:56:16 +0200
Message-ID: <2872138.dZQKejMMtt@tauon.chronox.de>
References: <1827882.yksAJm9a6v@positron.chronox.de> <1883619.lA7a8XQHvy@tauon.chronox.de> <20170411105000.GA12081@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58912 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752674AbdDKK4S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Apr 2017 06:56:18 -0400
In-Reply-To: <20170411105000.GA12081@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 11. April 2017, 12:50:00 CEST schrieb Herbert Xu:

Hi Herbert,

> I see the problem.  When you select CRYPTO_HASH you must also
> select CRYPTO.

Thank you very much.

I will prepare a patch.

Ciao
Stephan
