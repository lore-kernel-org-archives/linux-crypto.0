Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C003BC433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 11:51:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99A862083B
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 11:51:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfHOLvc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 07:51:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57174 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726120AbfHOLvc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 07:51:32 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hyEHx-00033L-ON; Thu, 15 Aug 2019 21:51:29 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hyEHt-0007RZ-RP; Thu, 15 Aug 2019 21:51:25 +1000
Date:   Thu, 15 Aug 2019 21:51:25 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCHv4 0/4] crypto: inside-secure - broaden driver scope
Message-ID: <20190815115125.GA28602@gondor.apana.org.au>
References: <1565077586-27814-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565077586-27814-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 06, 2019 at 09:46:22AM +0200, Pascal van Leeuwen wrote:
> This is a first baby step towards making the inside-secure crypto driver
> more broadly useful. The current driver only works for Marvell Armada HW
> and requires proprietary firmware, only available under NDA from Marvell,
> to be installed. This patch set allows the driver to be used with other
> hardware and removes the dependence on that proprietary firmware.
> 
> changes since v1:
> - changed dev_info's into dev_dbg to reduce normal verbosity
> - terminate all message strings with \n
> - use priv->version field strictly to enumerate device context
> - fixed some code & comment style issues
> - removed EIP97/197 references from messages
> - use #if(IS_ENABLED(CONFIG_PCI)) to remove all PCI related code
> - use #if(IS_ENABLED(CONFIG_OF)) to remove all device tree related code
> - do not inline the minifw but read it from /lib/firmware instead
> 
> changes since v2:
> - split off removal of alg to engine mapping code into separate patch
> - replaced some constants with nice defines
> - added missing \n to some error messages
> - removed some redundant parenthesis
> - aligned some #if's properly
> - added some comments to clarify code
> - report error on FW load for unknown HW instead of loading EIP197B FW
> - use readl_relaxed() instead of readl() + cpu_relax() in polling loop
> - merged patch "fix null ptr dereference on rmmod for macchiatobin" here
> - merged patch "removed unused struct entry"
> 
> changes since v3:
> - reverted comment style from generic back to network
> - changed prefix "crypto_is_" to "safexcel_" for consistency
> 
> Pascal van Leeuwen (4):
>   crypto: inside-secure - make driver selectable for non-Marvell
>     hardware
>   crypto: inside-secure - Remove redundant algo to engine mapping code
>   crypto: inside-secure - add support for PCI based FPGA development
>     board
>   crypto: inside-secure - add support for using the EIP197 without
>     vendor firmware
> 
>  drivers/crypto/Kconfig                         |  12 +-
>  drivers/crypto/inside-secure/safexcel.c        | 744 +++++++++++++++++--------
>  drivers/crypto/inside-secure/safexcel.h        |  43 +-
>  drivers/crypto/inside-secure/safexcel_cipher.c |  11 -
>  drivers/crypto/inside-secure/safexcel_hash.c   |  12 -
>  drivers/crypto/inside-secure/safexcel_ring.c   |   3 +-
>  6 files changed, 573 insertions(+), 252 deletions(-)

This patch series fails to apply on the current cryptodev tree.

Please rebase.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
