From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 2/4] crypto: aesni - Enable one-sided zero copy for gcm(aes) request buffers
Date: Wed, 31 Jan 2018 08:50:46 +0100
Message-ID: <1935859.ZlltK3QyAt@tauon.chronox.de>
References: <20180123201916.102134-1-junaids@google.com> <20180123201916.102134-3-junaids@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        andreslc@google.com, davem@davemloft.net, gthelen@google.com,
        ebiggers3@gmail.com
To: Junaid Shahid <junaids@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59070 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752998AbeAaHus (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 02:50:48 -0500
In-Reply-To: <20180123201916.102134-3-junaids@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 23. Januar 2018, 21:19:14 CET schrieb Junaid Shahid:

Hi Junaid,

> gcmaes_encrypt/decrypt perform zero-copy crypto if both the source and
> destination satisfy certain conditions (single sglist entry located in
> low-mem or within a single high-mem page). But two copies are done
> otherwise, even if one of source or destination still satisfies the
> zero-copy conditions. This optimization is now extended to avoid the
> copy on the side that does satisfy the zero-copy conditions.

The patch I pointed you and you nicely integrated was accepted by Herbert into 
the current tree. This implies that your patch will not apply cleanly any 
more.

May I suggest to rebase it to the current code?

Ciao
Stephan
