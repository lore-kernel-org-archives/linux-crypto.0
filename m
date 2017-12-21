From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH RFC 1/3] crypto: Prevent to register duplicate cra_driver_name
Date: Thu, 21 Dec 2017 07:27:31 +0100
Message-ID: <40918176.d7CsG1ORth@tauon.chronox.de>
References: <1513800567-12764-1-git-send-email-clabbe@baylibre.com> <1513800567-12764-2-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:44260 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750871AbdLUG2I (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 01:28:08 -0500
In-Reply-To: <1513800567-12764-2-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 20. Dezember 2017, 21:09:25 CET schrieb Corentin Labbe:

Hi Corentin,

> Each crypto algorithm "cra_name" can have multiple implementation called
> "cra_driver_name".
> If two different implementation have the same cra_driver_name, nothing
> can easily differentiate them.
> Furthermore the mechanism for getting a crypto algorithm with its
> implementation name (crypto_alg_match() in crypto/crypto_user.c) will
> get only the first one found.
> 
> So this patch prevent the registration of two implementation with the
> same cra_driver_name.

Have you seen that happen? The driver_name should be an unambiguous name that 
is unique throughout all crypto implementations.

If you have seen a duplication, then this duplication should be fixed.

Ciao
Stephan
