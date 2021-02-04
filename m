Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE2DC433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 16:00:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEFEC61477
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 16:00:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237589AbhBDQAl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 11:00:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:38516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237279AbhBDQAA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 11:00:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E102961477;
        Thu,  4 Feb 2021 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612454360;
        bh=VNqcEDt8Zreb5i6SAVqO2ZC/dbmMeeu5CNyA6xfGbSY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tWgQrE8MM0nu1QtIP1ffhUPqvkkEd2O658aSFmnvWhkexewcMOfEsTRW0Tjqwfhjh
         g6bcICEYkHjX6xn2VbH+wjUlpC6qe+hgV3q6yc6wNpfmqsNW4ZVrl0e2PKa3Y5mF2S
         m1lvqMaSCVN3MnYhSodP3YgWAqXtrj0vBGXxOKos=
Date:   Thu, 4 Feb 2021 16:59:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] random: fix the RNDRESEEDCRNG ioctl
Message-ID: <YBwZ1a0VIdpTDNuD@kroah.com>
References: <20210112192818.69921-1-ebiggers@kernel.org>
 <YBiEJ9Md60HjAWJg@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YBiEJ9Md60HjAWJg@sol.localdomain>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 01, 2021 at 02:43:51PM -0800, Eric Biggers wrote:
> On Tue, Jan 12, 2021 at 11:28:18AM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
> > doesn't make sense.  Reseed it from the input_pool instead.
> > 
> > Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
> > Cc: stable@vger.kernel.org
> > Cc: linux-crypto@vger.kernel.org
> > Cc: Andy Lutomirski <luto@kernel.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Theodore Ts'o <tytso@mit.edu>
> > Reviewed-by: Jann Horn <jannh@google.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > Andrew, please consider taking this patch since the maintainer has been
> > ignoring it for 4 months
> > (https://lkml.kernel.org/lkml/20200916041908.66649-1-ebiggers@kernel.org/T/#u).
> 
> Ping.

Given the lack of response, I'll take this now...

thanks,
greg k-h
