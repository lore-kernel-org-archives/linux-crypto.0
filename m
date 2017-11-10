From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: algif_aead - skip SGL entries with NULL page
Date: Fri, 10 Nov 2017 10:24:46 +0100
Message-ID: <94396256.4fNdfnqFXK@positron.chronox.de>
References: <3016707.l0K91qkPze@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42226 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750835AbdKJJYs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 04:24:48 -0500
In-Reply-To: <3016707.l0K91qkPze@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 10. November 2017, 08:29:40 CET schrieb Stephan Müller:

Hi,

> The TX SGL may contain SGL entries that are assigned a NULL page. This
> may happen if a multi-stage AIO operation is performed where the data
> for each stage is pointed to by one SGL entry. Upon completion of that
> stage, af_alg_pull_tsgl will assign NULL to the SGL entry.
> 
> The NULL cipher used to copy the AAD from TX SGL to the destination
> buffer, however, cannot handle the case where the SGL starts with an SGL
> entry having a NULL page. Thus, the code needs to advance the start
> pointer into the SGL to the first non-NULL entry.
> 
> This fixes a crash visible on Intel x86 32 bit using the libkcapi test
> suite.

This one still has an issue with zero input. I will send a fix shortly.

Ciao
Stephan
