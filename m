Return-Path: <SRS0=N13L=BB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50917C433E2
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 04:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3807D207BB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jul 2020 04:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgGVE5r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jul 2020 00:57:47 -0400
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:38800 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbgGVE5r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jul 2020 00:57:47 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 47E931829508C;
        Wed, 22 Jul 2020 04:57:46 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: milk10_2f0383b26f33
X-Filterd-Recvd-Size: 2811
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf18.hostedemail.com (Postfix) with ESMTPA;
        Wed, 22 Jul 2020 04:57:44 +0000 (UTC)
Message-ID: <b545eb4e3f2b4b676959e4666ef536f2691041eb.camel@perches.com>
Subject: [PATCH] Makefile.extrawarn: Move sign-compare from W=2 to W=3
From:   Joe Perches <joe@perches.com>
To:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org
Date:   Tue, 21 Jul 2020 21:57:43 -0700
In-Reply-To: <11ac49bc33546ef9ebc4120878206bd882667d8a.camel@perches.com>
References: <1595358391-34525-1-git-send-email-clabbe@baylibre.com>
         <1595358391-34525-17-git-send-email-clabbe@baylibre.com>
         <11ac49bc33546ef9ebc4120878206bd882667d8a.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This -Wsign-compare compiler warning can be very noisy
and most of the suggested conversions are unnecessary.

Make the warning W=3 so it's described under the
"can most likely be ignored" block.

Signed-off-by: Joe Perches <joe@perches.com>
---
On Tue, 2020-07-21 at 14:32 -0700, Joe Perches wrote:
> On Tue, 2020-07-21 at 19:06 +0000, Corentin Labbe wrote:
> > This patch fixes the warning:
> > warning: comparison of integer expressions of different signedness: 'int' and 'long unsigned int' [-Wsign-compare]
> 
> I think these do not really need conversion.
> Are these useful compiler warnings ?

Perhaps move the warning from W=2 to W=3 so
it's described as "can most likely be ignored"

 scripts/Makefile.extrawarn | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
index 62c275685b75..95e4cdb94fe9 100644
--- a/scripts/Makefile.extrawarn
+++ b/scripts/Makefile.extrawarn
@@ -66,7 +66,6 @@ KBUILD_CFLAGS += -Wnested-externs
 KBUILD_CFLAGS += -Wshadow
 KBUILD_CFLAGS += $(call cc-option, -Wlogical-op)
 KBUILD_CFLAGS += -Wmissing-field-initializers
-KBUILD_CFLAGS += -Wsign-compare
 KBUILD_CFLAGS += -Wtype-limits
 KBUILD_CFLAGS += $(call cc-option, -Wmaybe-uninitialized)
 KBUILD_CFLAGS += $(call cc-option, -Wunused-macros)
@@ -87,6 +86,7 @@ KBUILD_CFLAGS += -Wpacked
 KBUILD_CFLAGS += -Wpadded
 KBUILD_CFLAGS += -Wpointer-arith
 KBUILD_CFLAGS += -Wredundant-decls
+KBUILD_CFLAGS += -Wsign-compare
 KBUILD_CFLAGS += -Wswitch-default
 KBUILD_CFLAGS += $(call cc-option, -Wpacked-bitfield-compat)
 


