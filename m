Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65575C388F7
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 01:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3938E22256
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 01:12:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421067AbgJZBMK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Oct 2020 21:12:10 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:46848 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1421066AbgJZBMK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Oct 2020 21:12:10 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kWr3H-000693-8l; Mon, 26 Oct 2020 12:12:00 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 26 Oct 2020 12:11:59 +1100
Date:   Mon, 26 Oct 2020 12:11:59 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT PULL] Crypto Fixes for 5.10
Message-ID: <20201026011159.GA2428@gondor.apana.org.au>
References: <20200803044024.GA6429@gondor.apana.org.au>
 <20200830223304.GA16882@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200830223304.GA16882@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus:

This push fixes a regression in x86/poly1305.

The following changes since commit 3093e7c16e12d729c325adb3c53dde7308cefbd8:

  X.509: Fix modular build of public_key_sm2 (2020-10-08 16:39:14 +1100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus 

for you to fetch changes up to c3a98c3ad5c0dc60a1ac66bf91147a3f39cac96b:

  crypto: x86/poly1305 - add back a needed assignment (2020-10-24 09:38:32 +1100)

----------------------------------------------------------------
Eric Biggers (1):
      crypto: x86/poly1305 - add back a needed assignment

 arch/x86/crypto/poly1305_glue.c | 1 +
 1 file changed, 1 insertion(+)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
