Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EABC43219
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 11:34:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiJULeH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 07:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiJULdm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 07:33:42 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64FC261ADB
        for <linux-crypto@vger.kernel.org>; Fri, 21 Oct 2022 04:33:33 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1olqGj-004djE-M0; Fri, 21 Oct 2022 19:33:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Oct 2022 19:33:30 +0800
Date:   Fri, 21 Oct 2022 19:33:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Harliman Liem <pliem@maxlinear.com>
Cc:     atenart@kernel.org, linux-crypto@vger.kernel.org,
        linux-lgm-soc@maxlinear.com, pvanleeuwen@rambus.com
Subject: Re: [PATCH v2 0/3] crypto: inside-secure: Add Support for MaxLinear
 Platform
Message-ID: <Y1KDircdZFIJq4pN@gondor.apana.org.au>
References: <cover.1664247167.git.pliem@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1664247167.git.pliem@maxlinear.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 27, 2022 at 11:10:07AM +0800, Peter Harliman Liem wrote:
> Hi,
> 
> I have been utilizing inside-secure driver on MaxLinear
> SoC platform (which has eip197 hardware inside).
> 
> One issue I found is that I needed to flip the endianness
> in eip197_write_firmware() function, which for reason I am
> not aware is using big-endian.
> The firmware that I have is clearly using little-endian,
> and unfortunately I do not have access to Marvell platform
> to do more investigation or comparison there.
> I have also tried to look for clues in Inside-Secure's
> hardware/firmware documentation, without success.
> 
> Thus, assuming each vendor may use different endian format,
> on these patch set I add support for little-endian firmware
> (default remains big-endian). MaxLinear platform can then
> utilize the option, which is implemented as soc data.
> 
> An alternative to this would be implementing the option
> as a new device-tree property, but for now I assume we do
> not need that since each platform endianness should be
> fixed, and will not vary per board/hardware.
> 
> Please help review.
> 
> Thanks!
> 
> v2:
>  Revert directory change for generic case.
>  Add missing driver data change in pci_device_id.
>  Rename data struct to safexcel_priv_data.
>  Rework endianness selection code casting, to fix warning caught by kernel test robot.
>  Rename mxl version string to eip197 'c'.
> 
> Peter Harliman Liem (3):
>   crypto: inside-secure - Expand soc data structure
>   crypto: inside-secure - Add fw_little_endian option
>   crypto: inside-secure - Add MaxLinear platform
> 
>  drivers/crypto/inside-secure/safexcel.c | 69 ++++++++++++++++++-------
>  drivers/crypto/inside-secure/safexcel.h | 10 +++-
>  2 files changed, 59 insertions(+), 20 deletions(-)
> 
> -- 
> 2.17.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
