From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: ccree: fix __dump_byte_array() declaration
 mismatch
Date: Thu, 21 Dec 2017 18:12:58 +0100
Message-ID: <20171221171258.GA24041@kroah.com>
References: <1513793768-11051-1-git-send-email-clabbe@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: gilad@benyossef.com, linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe@baylibre.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34118 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751446AbdLURM7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 12:12:59 -0500
Content-Disposition: inline
In-Reply-To: <1513793768-11051-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 20, 2017 at 06:16:08PM +0000, Corentin Labbe wrote:
> This patch corrects the type of the size argument in __dump_byte_array()
> from unsigned long to size_t as done only in drivers/staging/ccree/ssi_driver.c
> 
> This fix also a build error:
> drivers/staging/ccree/ssi_driver.c:82:6: error: conflicting types for '__dump_byte_array'
> 
> Fixes: 3f268f5d6669 ("staging: ccree: turn compile time debug log to params")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  drivers/staging/ccree/ssi_driver.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

There's another warning here that Arnd's patches fixes, yet yours
didn't, so I'm going to take his patch, sorry.

greg k-h
