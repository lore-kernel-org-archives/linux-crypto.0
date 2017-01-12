From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v4 2/3] drivers: crypto: Add the Virtual Function driver for CPT
Date: Thu, 12 Jan 2017 12:19:38 +0100
Message-ID: <1970611.axXSiX4HVh@positron.chronox.de>
References: <1484132211-917-1-git-send-email-george.cherian@cavium.com> <1522639.tMShRcNLPc@positron.chronox.de> <58776428.1060308@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: George Cherian <george.cherian@cavium.com>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        david.daney@cavium.com, clabbe.montjoie@gmail.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: George Cherian <gcherian@caviumnetworks.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55460 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbdALLTx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Jan 2017 06:19:53 -0500
In-Reply-To: <58776428.1060308@caviumnetworks.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 12. Januar 2017, 16:40:32 CET schrieb George Cherian:

Hi George,

> > 
> > Sure, please do not forget to invoke xts_verify_key.
> 
> Should I be using xts_check_key or xts_verify_key?

Both are identical except for the input parameter -- the one requires 
crypto_skcipher, the other crypto_tfm. Depending what pointer you have handy 
in your setkey function, you would use the most appropriate one.

Ciao
Stephan
