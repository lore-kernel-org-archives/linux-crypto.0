Return-Path: <SRS0=b5ak=PZ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.166]:14069 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbfAQLem (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 06:34:42 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Kalyani Akula <kalyani.akula@xilinx.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kalyani Akula <kalyania@xilinx.com>,
        Sarat Chand Savitala <saratcha@xilinx.com>
Subject: Re: [RFC PATCH 4/5] crypto: Adds user space interface for ALG_SET_KEY_TYPE
Date: Thu, 17 Jan 2019 12:34:27 +0100
Message-ID: <4735882.YQOrfzxm5S@tauon.chronox.de>
In-Reply-To: <1547708541-23730-5-git-send-email-kalyani.akula@xilinx.com>
References: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com> <1547708541-23730-5-git-send-email-kalyani.akula@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 17. Januar 2019, 08:02:20 CET schrieb Kalyani Akula:

Hi Kalyani,

> ALG_SET_KEY_TYPE requires caller to pass the key_type to be used
> for AES encryption/decryption.
> 
> Sometimes the cipher key will be stored in the
> device's hardware. So, there is a need to specify
> the information about the key to use for AES operations.
> 
> In Xilinx ZynqMP SoC, below key types are available
> 
> 1. Device key, which is flashed in the HW.
> 
> 2. PUF KEK, which can be regenerated using the
>    helper data programmed in the HW.
> 
> 3. User supplied key.
> 
> So to choose the AES key to be used, this patch adds key-type attribute.

You expose your particular driver interface to user space. So, user space 
would need the details of you driver to know what to set. If another driver 
has such key type support, user space would need to know about that, too. I do 
not think this is a wise idea.

If we are going to have such a keytype selection, there must be a common user 
space interface for all drivers. I.e. define common key types the drivers then 
can map to their particular key type interface.

Besides, seem to be more a key handling issue. Wouldn't it make sense to 
rather have such issue solved with key rings than in the kernel crypto API?

Ciao
Stephan
