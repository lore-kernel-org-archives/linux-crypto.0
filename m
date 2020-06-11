Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEC1DC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 04:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F402075F
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 04:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgFKEFv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 00:05:51 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33304 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgFKEFu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 00:05:50 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jjETI-00033l-Ig; Thu, 11 Jun 2020 14:05:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2020 14:05:44 +1000
Date:   Thu, 11 Jun 2020 14:05:44 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.8
Message-ID: <20200611040544.GA27603@gondor.apana.org.au>
References: <20190916084901.GA20338@gondor.apana.org.au>
 <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au>
 <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au>
 <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200408061513.GA23636@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408061513.GA23636@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push contains a number of fixes to the omap and nitrox drivers.

The following changes since commit 58ca0060ec4e51208d2eee12198fc55fd9e4feb3:

  crypto: hisilicon - fix driver compatibility issue with different versions of devices (2020-05-28 17:27:52 +1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to 320bdbd816156f9ca07e5fed7bfb449f2908dda7:

  crypto: cavium/nitrox - Fix 'nitrox_get_first_device()' when ndevlist is fully iterated (2020-06-04 22:06:26 +1000)

----------------------------------------------------------------
Christophe JAILLET (1):
      crypto: cavium/nitrox - Fix 'nitrox_get_first_device()' when ndevlist is fully iterated

Tero Kristo (7):
      crypto: omap-aes - avoid spamming console with self tests
      crypto: omap-sham - force kernel driver usage for sha algos
      crypto: omap-crypto - fix userspace copied buffer access
      crypto: omap-sham - huge buffer access fixes
      crypto: omap-sham - fix very small data size handling
      crypto: omap-aes - prevent unregistering algorithms twice
      crypto: omap-sham - add proper load balancing support for multicore

 drivers/crypto/cavium/nitrox/nitrox_main.c |   4 ++--
 drivers/crypto/omap-aes-gcm.c              |   1 -
 drivers/crypto/omap-aes.c                  |   8 ++++++--
 drivers/crypto/omap-crypto.c               |  10 ++++++++--
 drivers/crypto/omap-sham.c                 | 101 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------------------------------------------
 5 files changed, 74 insertions(+), 50 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
