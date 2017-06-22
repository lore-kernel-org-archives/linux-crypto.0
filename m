From: Kyle McMartin <kyle@infradead.org>
Subject: Re: [PATCH 1/1] cavium: Add firmware for CNN55XX crypto driver.
Date: Thu, 22 Jun 2017 12:09:36 -0700
Message-ID: <20170622190936.GL13400@bombadil.infradead.org>
References: <20170616142226.3950-1-Jampala.Srikanth@cavium.com>
 <20170616142226.3950-2-Jampala.Srikanth@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Sreerama.Gadam@cavium.com, linux-firmware@kernel.org
To: Srikanth Jampala <Jampala.Srikanth@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47806 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751953AbdFVTJk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 15:09:40 -0400
Content-Disposition: inline
In-Reply-To: <20170616142226.3950-2-Jampala.Srikanth@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 16, 2017 at 07:52:26PM +0530, Srikanth Jampala wrote:
> This patchset adds the firmware for CNN55XX cryto driver,
> supports Symmetric crypto operations.
> 
> The version of the firmware is v07.
> 
> Signed-off-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
> ---
>  WHENCE        |   9 +++++++++
>  cnn55xx_se.fw | Bin 0 -> 27698 bytes

any chance i could convince you to put this in a cavium/ subdirectory?

--kyle
