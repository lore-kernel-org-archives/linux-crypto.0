From: Cosar Dindar <cosardindar@gmail.com>
Subject: Re: [RESEND,PATCH v4 3/3] crypto : stm32 - Add STM32F4 CRC32 support
Date: Thu, 3 Aug 2017 11:44:17 +0300
Message-ID: <20170803084417.GA81719@osboxes>
References: <1500280056-46251-1-git-send-email-cosardindar@gmail.com>
 <20170803054423.GA11926@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
        alexandre.torgue@st.com, fabien.dessenne@st.com,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34087 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdHCIo3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Aug 2017 04:44:29 -0400
Content-Disposition: inline
In-Reply-To: <20170803054423.GA11926@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 03, 2017 at 01:44:23PM +0800, Herbert Xu wrote:
> On Mon, Jul 17, 2017 at 11:27:36AM +0300, Cosar Dindar wrote:
> > This patch adds CRC (CRC32 Crypto) support for STM32F4 series.
> > 
> > As an hardware limitation polynomial and key setting are not supported.
> > They are fixed as 0x4C11DB7 (poly) and 0xFFFFFFFF (key).
> > CRC32C Castagnoli algorithm is not used.
> > 
> > Signed-off-by: Cosar Dindar <cosardindar@gmail.com>
> > Reviewed-by: Fabien Dessenne <fabien.dessenne@st.com>
> 
> This patch doesn't apply anymore.  Please rebase.
> 
> Thanks,

OK, I'll rebase and send a new patch including new changes.

Thanks, 

Best Regards,
 
Cosar.

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
