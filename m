Return-Path: <SRS0=USLa=UP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5132C31E47
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 01:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7CB21841
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 01:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560648060;
	bh=ILfkvkhvR5kBTHKQRd9CP7kBdnCdDWWQwSD0Bla6rOo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iOMrGi9cuLU+Y7maVNvqztomdWg6lDrhma09/zZuIxxpmWG/pT2tzrq0t2Y/yUJuy
	 lkoZaiibTZIo9/PrHGalIgOJF8QOzEMJ6hB7c6W3dKhYRaatCrsGPvVKrJ8SFnc5Bk
	 zwvBfzy1ohZRGadfHq90fUvfHIk47rNx3lOL8Aj4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfFPBU6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 15 Jun 2019 21:20:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbfFPBU6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 15 Jun 2019 21:20:58 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90F4D2183F;
        Sun, 16 Jun 2019 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560648057;
        bh=ILfkvkhvR5kBTHKQRd9CP7kBdnCdDWWQwSD0Bla6rOo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LlvnrTwOJNe2uGlUTwLO1kLFEk7R4pCGtpQvTfmRZHXL5tX5OZRGtCGDQ4EriK/el
         BPrgK0PwC7SdPWB+QOKptIGwxwIJSXsSVZ7fa1Y5OQTxoQPJHh4BuuxM4I47moAiMX
         2S+57ROskCG4zK2j7VpvlAkGLo/8vc1Jy91k1+Aw=
Date:   Sat, 15 Jun 2019 18:20:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [PATCH v3] wusb: switch to cbcmac transform
Message-ID: <20190616012056.GA698@sol.localdomain>
References: <20190615091745.3100-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190615091745.3100-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 15, 2019 at 11:17:45AM +0200, Ard Biesheuvel wrote:
> The wusb code takes a very peculiar approach at implementing CBC-MAC,
> by using plain CBC into a scratch buffer, and taking the output IV
> as the MAC.
> 
> We can clean up this code substantially by switching to the cbcmac
> shash, as exposed by the CCM template. To ensure that the module is
> loaded on demand, add the cbcmac template name as a module alias.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
> v3: - add missing #include to fix build error spotted by kbuild test robot
> v2: - use finup()/digest() where possible, and process b0+b1 using a single
>       call to update()
>     - make 'stv_hsmic_hs' static const and remove comment regarding GCC 4.1
> 
> NOTE: I don't have any hardware to test this, but the built-in selftest
>       still passes.
>  
>  crypto/ccm.c                  |   1 +
>  drivers/usb/wusbcore/crypto.c | 169 +++++---------------
>  2 files changed, 45 insertions(+), 125 deletions(-)
> 

drivers/usb/wusbcore/Kconfig also needs to be updated:

diff --git a/drivers/usb/wusbcore/Kconfig b/drivers/usb/wusbcore/Kconfig
index 12e89189ca7d..2ec17d6af1f8 100644
--- a/drivers/usb/wusbcore/Kconfig
+++ b/drivers/usb/wusbcore/Kconfig
@@ -6,9 +6,7 @@ config USB_WUSB
 	tristate "Enable Wireless USB extensions"
 	depends on UWB
         select CRYPTO
-        select CRYPTO_BLKCIPHER
-        select CRYPTO_CBC
-        select CRYPTO_MANAGER
+        select CRYPTO_CCM
         select CRYPTO_AES
 	help
 	  Enable the host-side support for Wireless USB.

> diff --git a/drivers/usb/wusbcore/crypto.c b/drivers/usb/wusbcore/crypto.c
> index edb7263bff40..9ee66483ee54 100644
> --- a/drivers/usb/wusbcore/crypto.c
> +++ b/drivers/usb/wusbcore/crypto.c

Other than that, this patch looks correct.  There are a massive number of things
that need to be cleaned up in this code, but I guess we don't really care since
as Greg said, this driver is planned to be removed anyway.  (It also seems the
wireless USB specification is no longer available at usb.org.)  So I'm not going
to bother being very picky...

- Eric
