Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCD3C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 19:16:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B196F20855
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 19:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfKTTQg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 14:16:36 -0500
Received: from ms.lwn.net ([45.79.88.28]:46812 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfKTTQg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 14:16:36 -0500
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 8CF884A2;
        Wed, 20 Nov 2019 19:16:35 +0000 (UTC)
Date:   Wed, 20 Nov 2019 12:16:34 -0700
From:   Jonathan Corbet <corbet@lwn.net>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/4] padata: update documentation
Message-ID: <20191120121634.6d989088@lwn.net>
In-Reply-To: <20191120185412.302-2-daniel.m.jordan@oracle.com>
References: <20191120185412.302-1-daniel.m.jordan@oracle.com>
        <20191120185412.302-2-daniel.m.jordan@oracle.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Nov 2019 13:54:09 -0500
Daniel Jordan <daniel.m.jordan@oracle.com> wrote:

> Remove references to unused functions and update to reflect the new
> struct padata_shell.
> 
> Fixes: 815613da6a67 ("kernel/padata.c: removed unused code")
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/padata.txt | 50 +++++++++++++++++++++-------------------
>  1 file changed, 26 insertions(+), 24 deletions(-)

This all seems fine - it's better than not doing it - but can I put in a
request or two?

 - This document is already formatted as RST, and your changes continue
   that.  Can we please move it to Documentation/core-api/padata.rst and
   add it to the TOC tree there?  Then it can become part of our formatted
   docs.

 - The padata code seems to be nicely equipped with kerneldoc comments; it
   would be awfully nice to pull them into the document directly rather
   than replicating the API there.  (Why does the document do that now?
   Blame the bozo who originally wrote it :)  That would make the document
   more complete and easier to maintain going forward.

For added goodness we could stick in an SPDX tag while we're at it.

Thanks,

jon
