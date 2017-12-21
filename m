From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: ccree: fix type mismatch warning
Date: Thu, 21 Dec 2017 18:14:05 +0100
Message-ID: <20171221171405.GA24378@kroah.com>
References: <20171221133139.1968427-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, devel@driverdev.osuosl.org,
        Derek Robson <robsonde@gmail.com>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Suniel Mahesh <sunil.m@techveda.org>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34432 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751828AbdLUROF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Dec 2017 12:14:05 -0500
Content-Disposition: inline
In-Reply-To: <20171221133139.1968427-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 21, 2017 at 02:31:20PM +0100, Arnd Bergmann wrote:
> __dump_byte_array used to be hidden, but is now visible to the compiler
> and causes a harmless warning:
> 
> drivers/staging/ccree/ssi_driver.c:82:6: error: conflicting types for '__dump_byte_array'
> drivers/staging/ccree/ssi_driver.c: In function '__dump_byte_array':
> drivers/staging/ccree/ssi_driver.c:89:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Werror=format=]
> 
> This changes the prototype in the header to match that of the actual
> function on all architectures, and the format string to match the
> argument.
> 
> Fixes: 3f268f5d6669 ("staging: ccree: turn compile time debug log to params")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/ccree/ssi_driver.c | 2 +-
>  drivers/staging/ccree/ssi_driver.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Should already be fixed, sorry.

greg k-h
