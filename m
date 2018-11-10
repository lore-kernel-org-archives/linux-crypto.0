Return-Path: <SRS0=6FdY=NV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbeKKBDF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Nov 2018 20:03:05 -0500
Date: Sat, 10 Nov 2018 07:17:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Eric Anholt <eric@anholt.net>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-rpi-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: Re: [PATCH 03/17] hw_random: bcm2835-rng: Switch to SPDX identifier
Message-ID: <20181110151743.GA24408@kroah.com>
References: <1541861476-6778-1-git-send-email-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541861476-6778-1-git-send-email-stefan.wahren@i2se.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 10, 2018 at 03:51:16PM +0100, Stefan Wahren wrote:
> Adopt the SPDX license identifier headers to ease license compliance
> management. While we are at this fix the comment style, too.
> 
> Cc: Lubomir Rintel <lkundrak@v3.sk>
> Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
> ---
>  drivers/char/hw_random/bcm2835-rng.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
