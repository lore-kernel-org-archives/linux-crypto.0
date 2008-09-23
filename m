From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: hifn_795x in Linux-2.6.27-rc7
Date: Tue, 23 Sep 2008 21:39:30 +0400
Message-ID: <20080923173930.GA4357@2ka.mipt.ru>
References: <48D7D84B.9020507@psycast.de> <20080923165521.GA26513@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dimitri Puzin <max@psycast.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:39753 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYIWRkU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Sep 2008 13:40:20 -0400
Content-Disposition: inline
In-Reply-To: <20080923165521.GA26513@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 23, 2008 at 08:55:21PM +0400, Evgeniy Polyakov (johnpol@2ka.mipt.ru) wrote:
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index 81f3f95..b288bbd 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -2593,7 +2593,7 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return err;
>  	pci_set_master(pdev);
>  
> -	err = pci_set_dma_mask(pdev, DMA_32BIT_MASK);
> +	err = pci_set_dma_mask(pdev, DMA_64BIT_MASK);
>  	if (err)
>  		goto err_out_disable_pci_device;

Actually not, I checked documentation, and although HIFN claims to have
some kind of 64 bit support, all addresses are 32-bit wide only, so I
really wonder if HIFN supports 64 bit.
There is no remapping or address mask parameter in the crypto stack,
so that it would not try to provide page to the devices, which do not
support it.

-- 
	Evgeniy Polyakov
