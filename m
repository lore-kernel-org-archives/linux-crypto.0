From: "cloudy.linux" <cloudy.linux@gmail.com>
Subject: Re: RFC: support for MV_CESA with IDMA or TDMA
Date: Fri, 15 Jun 2012 09:40:28 +0800
Message-ID: <4FDA928C.6030601@gmail.com>
References: <20120612113941.GA14757@gondor.apana.org.au> <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50242 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab2FOBkx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jun 2012 21:40:53 -0400
Received: by eeit10 with SMTP id t10so756397eei.19
        for <linux-crypto@vger.kernel.org>; Thu, 14 Jun 2012 18:40:52 -0700 (PDT)
In-Reply-To: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 2012-6-13 1:17, Phil Sutter wrote:
> Hi,
>
> The following patch series adds support for the TDMA engine built into
> Marvell's Kirkwood-based SoCs as well as the IDMA engine built into
> Marvell's Orion-based SoCs and enhances mv_cesa.c in order to use it for
> speeding up crypto operations. The hardware contains a security
> accelerator, which can control DMA as well as crypto engines. It allows
> for operation with minimal software intervention, which the following
> patches implement: using a chain of DMA descriptors, data input,
> configuration, engine startup and data output repeat fully automatically
> until the whole input data has been handled.
>
> The point for this being RFC is lack of hardware on my side for testing
> the IDMA support. I'd highly appreciate if someone with Orion hardware
> could test this, preferably using the hmac_comp tool shipped with
> cryptodev-linux as it does a more extensive testing (with bigger buffer
> sizes at least) than tcrypt or the standard kernel-internal use cases.
>
> Greetings, Phil
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I would like to have a try on those patches. But what version of kernel 
should I apply those patches on?

Thanks.
