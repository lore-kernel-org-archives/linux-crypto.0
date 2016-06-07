From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] hwrng: chaoskey - Add support for Araneus Alea I USB
 RNG
Date: Tue, 7 Jun 2016 18:53:45 +0800
Message-ID: <20160607105345.GE520@gondor.apana.org.au>
References: <1464952388-2405-1-git-send-email-bob.ham@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-usb@vger.kernel.org,
	Keith Packard <keithp@keithp.com>,
	Matt Mackall <mpm@selenic.com>,
	Clemens Ladisch <clemens@ladisch.de>,
	Greg KH <gregkh@linuxfoundation.org>
To: Bob Ham <bob.ham@collabora.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36747 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094AbcFGKyL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2016 06:54:11 -0400
Content-Disposition: inline
In-Reply-To: <1464952388-2405-1-git-send-email-bob.ham@collabora.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 03, 2016 at 12:13:06PM +0100, Bob Ham wrote:
> Two patches to add support for the Araneus Alea I USB RNG to the
> chaoskey driver.  The first simply includes the Alea I as a device,
> the second fixes an issue with the timeout on the first read.
> 
> Bob Ham (2):
>   hwrng: chaoskey - Add support for Araneus Alea I USB RNG
>   hwrng: chaoskey - Fix URB warning due to timeout on Alea
> 
>  drivers/usb/misc/Kconfig    | 11 ++++++-----
>  drivers/usb/misc/chaoskey.c | 21 +++++++++++++++++++--
>  2 files changed, 25 insertions(+), 7 deletions(-)

Both applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
