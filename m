Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC24C07E9B
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 17:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A947160FDB
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 17:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239768AbhGSQa4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 12:30:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:36742 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354624AbhGSQaW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 12:30:22 -0400
Received: from gate.crashing.org (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 16JH4N2o028857;
        Mon, 19 Jul 2021 12:04:23 -0500
Received: (from segher@localhost)
        by gate.crashing.org (8.14.1/8.14.1/Submit) id 16JH4Mln028856;
        Mon, 19 Jul 2021 12:04:22 -0500
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date:   Mon, 19 Jul 2021 12:04:22 -0500
From:   Segher Boessenkool <segher@kernel.crashing.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Salah Triki <salah.triki@gmail.com>, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, paulus@samba.org,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        davem@davemloft.net
Subject: Re: [PATCH] replace if with min
Message-ID: <20210719170422.GO1583@gate.crashing.org>
References: <20210712204546.GA1492390@pc> <20210719181205.Horde.xU8C00MIRgjqhZQ3-RrANw8@messagerie.c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210719181205.Horde.xU8C00MIRgjqhZQ3-RrANw8@messagerie.c-s.fr>
User-Agent: Mutt/1.4.2.3i
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 19, 2021 at 06:12:05PM +0200, Christophe Leroy wrote:
> Salah Triki <salah.triki@gmail.com> a écrit :
> >Replace if with min in order to make code more clean.

> >--- a/drivers/crypto/nx/nx-842.c
> >+++ b/drivers/crypto/nx/nx-842.c
> >@@ -134,8 +134,7 @@ EXPORT_SYMBOL_GPL(nx842_crypto_exit);
> > static void check_constraints(struct nx842_constraints *c)
> > {
> > 	/* limit maximum, to always have enough bounce buffer to decompress 
> > 	*/
> >-	if (c->maximum > BOUNCE_BUFFER_SIZE)
> >-		c->maximum = BOUNCE_BUFFER_SIZE;
> >+	c->maximum = min(c->maximum, BOUNCE_BUFFER_SIZE);
> 
> For me the code is less clear with this change, and in addition it  
> slightly changes the behaviour. Before, the write was done only when  
> the value was changing. Now you rewrite the value always, even when it  
> doesn't change.

In both cases the compiler can decide to either write it more often than
strictly needed, depending on what it thinks best (and it usually has
better estimates than the programmer).  The behaviour is identical (and
the generated machine code is as well, in my testing).

The field name "maximum" is not the best choice, which makes the code
read a bit funny ("the min of max"), but the comment makes things pretty
clear.


Segher
