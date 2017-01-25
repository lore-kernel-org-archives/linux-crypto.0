From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: doc - Fix hash export state information
Date: Wed, 25 Jan 2017 17:18:05 +0100
Message-ID: <5671933.EqcuFpxzUF@tauon.atsec.com>
References: <1485359706-7184-1-git-send-email-rabin.vincent@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Rabin Vincent <rabinv@axis.com>
To: Rabin Vincent <rabin.vincent@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55638 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751008AbdAYQSJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Jan 2017 11:18:09 -0500
In-Reply-To: <1485359706-7184-1-git-send-email-rabin.vincent@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 25. Januar 2017, 16:55:06 CET schrieb Rabin Vincent:

Hi Rabin,

> From: Rabin Vincent <rabinv@axis.com>
> 
> The documentation states that crypto_ahash_reqsize() provides the size
> of the state structure used by crypto_ahash_export().  But it's actually
> crypto_ahash_statesize() which provides this size.

ack for the statesize documentation addition.

In addition, can you please add crypto_ahash_statesize to Documentation/
crypto/api-digest.rst.

nack - The documentation is quite right for reqsize: it returns the *request 
data structure* size as documented.

Ciao
Stephan
