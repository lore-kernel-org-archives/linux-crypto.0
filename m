From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2] crypto: shash - Fix zero-length shash ahash digest crash
Date: Mon, 09 Oct 2017 17:52:48 +0200
Message-ID: <3972541.GrDicMXGHY@positron.chronox.de>
References: <3874163.dZU00zCVt8@positron.chronox.de> <1629795.0592ersqdG@positron.chronox.de> <20171009153002.GA7963@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34828 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755061AbdJIPww (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Oct 2017 11:52:52 -0400
In-Reply-To: <20171009153002.GA7963@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 9. Oktober 2017, 17:30:02 CEST schrieb Herbert Xu:

Hi Herbert,

> The shash ahash digest adaptor function may crash if given a
> zero-length input together with a null SG list.  This is because
> it tries to read the SG list before looking at the length.
> 
> This patch fixes it by checking the length first.

The patch fixes the issue.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: Stephan Müller<smueller@chronox.de>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Stephan Müller <smueller@chronox.de>

Ciao
Stephan
