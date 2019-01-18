Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EE9C43387
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jan 2019 06:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5241A2087E
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jan 2019 06:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1547794262;
	bh=1rr2Jz/fQkwt2Il67J0sj5BgStMYgTxGjU8bWFKmvF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Tc0CdVxrCXLhx5SKmZPDT4ixPlinyzEy6XHJzvgY5LUXGzMfHgnu6B/Oh8ktLDK6D
	 vfHsNha/9iAcclILmeO4eYIyEb92+2aYbjhqpQuCwd+wlSB/V5vCm9WySRkQOaKbfK
	 MxVa/AKIy4MRlnyFIu+esNxemLZJ5VE3L61BXX9c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfARGvB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jan 2019 01:51:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:44314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbfARGvB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 01:51:01 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F1FE20652;
        Fri, 18 Jan 2019 06:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1547794261;
        bh=1rr2Jz/fQkwt2Il67J0sj5BgStMYgTxGjU8bWFKmvF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FShB/LN0FdOEUFxU0x9akHgQu52sZ3N2vJ+Dn1HlYNJ+j4zIcN62wpU/h+KebllNH
         wLe2DswzhRlqDpLzVBCW9ttf6lwfyoOw9HSEMxariCE6SXtHqIN+eq2mEFim00J1jc
         4D2w+VtSRK5Xvg5QvGGYAGI9jo3Rk8l35EYi447U=
Date:   Fri, 18 Jan 2019 07:50:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Subject: Re: [patch 3/9] crypto: morus - Cleanup license mess
Message-ID: <20190118065058.GA9727@kroah.com>
References: <20190117231416.111952141@linutronix.de>
 <20190117231501.068505479@linutronix.de>
 <CAOMZO5CsTiQV78d6ZvUBwzzU9iF8ZnCpp_O7VBrvxstZ6kNNRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAOMZO5CsTiQV78d6ZvUBwzzU9iF8ZnCpp_O7VBrvxstZ6kNNRg@mail.gmail.com>
User-Agent: Mutt/1.11.2 (2019-01-07)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190118065058.Glku-4ONiF0DnbHJSn0GKMkaWFT6b0B9D09KNzcMZ_Y@z>

On Thu, Jan 17, 2019 at 10:26:07PM -0200, Fabio Estevam wrote:
> On Thu, Jan 17, 2019 at 9:17 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > --- a/include/crypto/morus1280_glue.h
> > +++ b/include/crypto/morus1280_glue.h
> > @@ -1,15 +1,10 @@
> > -/* SPDX-License-Identifier: GPL-2.0 */
> > +/* SPDX-License-Identifier: GPL-2.0-or-later */
> 
> Shouldn't this be: /* SPDX-License-Identifier: GPL-2.0+ */ ?
> 
> At least this is the form documented in Documentation/process/license-rules.rst:
> 
> " License identifiers for licenses like [L]GPL with the 'or later' option
>    are constructed by using a "+" for indicating the 'or later' option.::
> 
>       // SPDX-License-Identifier: GPL-2.0+"

Either works, please see LICENSES/preferred/GPL-2.0

Personally, I think we should stick with the "+" version as that is the
much more prevalent use in the kernel at the moment, but it's Thomas's
call, not mine.

thanks,

greg k-h
