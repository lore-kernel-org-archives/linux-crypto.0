Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96C0FC433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 07:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53A4160241
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 07:02:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbhD2HDm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 03:03:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237080AbhD2HDl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 03:03:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B662D61449;
        Thu, 29 Apr 2021 07:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619679775;
        bh=W50UPCGmhSxla0N2Zhz2YehaFX5O6TzNoFx/hf0HXlI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IE30e1BAipdXzeeMvx4+MYuW7LWqijpc0nOv1zsI9b/Y8wC8TCmd9kpCWKXqEMvCQ
         NIE8LKqZFaCZ+I0SqGZavIyN2bVGkcOe7UOqEuL9rJ55wLql3j7DNMdKmwTKxOpL5V
         ASKZQbSQrViktg8tioupdSto3xdlMLpFWgZgcGwU=
Date:   Thu, 29 Apr 2021 09:02:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Revert "crypto: cavium/nitrox - add an error message to
 explain the failure of pci_request_mem_regions"
Message-ID: <YIpaHeGoX02ndgGn@kroah.com>
References: <YIkTi9a3nnL50wMq@kroah.com>
 <20210429001834.liqriwtjetecfnr6@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429001834.liqriwtjetecfnr6@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 29, 2021 at 08:18:34AM +0800, Herbert Xu wrote:
> On Wed, Apr 28, 2021 at 09:49:31AM +0200, Greg Kroah-Hartman wrote:
> > This reverts commit 9fcddaf2e28d779cb946d23838ba6d50f299aa80 as it was
> > submitted under a fake name and we can not knowingly accept anonymous
> > contributions to the repository.
> > 
> > This commit was part of a submission "test" to the Linux kernel
> > community by some "researchers" at umn.edu.  As outlined at:
> > 	https://www-users.cs.umn.edu/%7Ekjlu/papers/full-disclosure.pdf
> > it was done so as an attempt to submit a known-buggy patch to see if it
> > could get by our review.  However, the submission turned out to actually
> > be correct, and not have a bug in it as the author did not understand
> > how the PCI driver model works at all, and so the submission was
> > accepted.
> > 
> > As this change is of useless consequence, there is no loss of
> > functionality in reverting it.
> > 
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  drivers/crypto/cavium/nitrox/nitrox_main.c | 1 -
> >  1 file changed, 1 deletion(-)
> > 
> > Herbert, I will be taking this as part of my larger "revert buggy patch
> > submissions from umn.edu" tree, so no need for you to take this in your
> > tree at this point in time, I just wanted to give you a heads up as to
> > what is happening here.
> 
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Wonderful, thanks for the review.

greg k-h
