From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: AF_ALG: handle 0 lengths in af_alg_make_sg
Date: Sat, 01 Apr 2017 19:46:39 +0200
Message-ID: <2164576.cSnkze5bYl@positron.chronox.de>
References: <2380853.MJYDG7HQLD@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58732 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751804AbdDARqn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2017 13:46:43 -0400
In-Reply-To: <2380853.MJYDG7HQLD@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 1. April 2017, 17:04:28 CEST schrieb Stephan Müller:

Hi Herbert,

> Hi Herbert,
> 
> If you concur with the patch, I think it should go to 4.11 as well as
> to stable.

After checking this issue again, I see that it is not triggerable in the 
current code as the different af_alg users make sure that this function is not 
called with 0.

I only triggered this issue during experimenting with the algif_skcipher and 
algif_aead revamp as requested by you. During those experiments, I invoked 
af_alg_make_sg with a len = 0.

Thus, this patch is not applicable for stable and 4.11.

Yet, I would suggest to consider this patch as a safeguard for any potential 
programming errors.

Ciao
Stephan
