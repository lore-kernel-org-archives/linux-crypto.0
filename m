Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C52CC433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Nov 2021 03:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E865610A8
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Nov 2021 03:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhKNDDt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Nov 2021 22:03:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231720AbhKNDDt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Nov 2021 22:03:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD96561027;
        Sun, 14 Nov 2021 03:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636858855;
        bh=XAC1XC/D/WksC2VDhN6qPDy7CcX2RxawAhkEJO6q5Pg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=caWiX3I8SusPhyzWYyM3mLjD4BIcmqhMkdL9XDV02OMf8NqXABtoNOj8Ui19taFn0
         ryYhqzRbcGPnPPkHxg8DPF+2QQRB+nMDp0sd5nQZzr3aDj8IE84ANxX5Etxgw6vgXZ
         YABPyWIEvdmV5s8Bf61To333vbO1n4uZBrB4KrxEy4aOaflD7gIJT27w2M8cgrOz+6
         /jNcjsAhOUwt1Vhr6Z8kxPc7UhxlyjxTju5W1u/mJlgHzbKVWOkcSqFgXSY0uXwJrB
         +K0FgL2aejnk91rvpEMxwpXIWcEsWMd3WShgS08YcfRoCVcrmjB2ePOeNsPF2HHvgX
         63ZNExjBKKYRg==
Date:   Sat, 13 Nov 2021 19:00:54 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     David Howells <dhowells@redhat.com>,
        Alexander Krizhanovsky <ak@tempesta-tech.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH Strawman] crypto: Handle PEM-encoded x.509 certificates
Message-ID: <YZB75rDM9zoo4vXh@sol.localdomain>
References: <163673838611.45802.5085223391786276660.stgit@morisot.1015granger.net>
 <YY63HENw3fjowWH0@gmail.com>
 <46C06033-B65B-473A-91F1-584878354C72@oracle.com>
 <YZBD6MukiZXKgLo3@sol.localdomain>
 <202C4936-FE6A-4422-A9BF-7DF47EF8BCC6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202C4936-FE6A-4422-A9BF-7DF47EF8BCC6@oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Nov 14, 2021 at 02:34:07AM +0000, Chuck Lever III wrote:
> > Adding kernel UAPIs expands the kernel's attack surface, causing security
> > vulnerabilities.  It also increases the number of UAPIs that need to be
> > permanently supported.  It makes no sense to add kernel UAPIs for things that
> > can be easily done in userspace.
> > 
> > They work well as April Fools' jokes, though:
> > https://lore.kernel.org/r/1459463613-32473-1-git-send-email-richard@nod.at
> > Perhaps you meant to save your patch for April 1?
> 
> That remark is uncalled for and out of line. Perhaps you just
> don't know what "strawman" means or why someone would post
> unfinished code to ask for direction. I'll mark that down to
> your inexperience.
> 
> Interestingly, I don't see you listed as a maintainer in this
> area:
> 
> $ scripts/get_maintainer.pl crypto/asymmetric_keys/
> David Howells <dhowells@redhat.com> (maintainer:ASYMMETRIC KEYS)
> Herbert Xu <herbert@gondor.apana.org.au> (maintainer:CRYPTO API)
> "David S. Miller" <davem@davemloft.net> (maintainer:CRYPTO API)
> keyrings@vger.kernel.org (open list:ASYMMETRIC KEYS)
> linux-crypto@vger.kernel.org (open list:CRYPTO API)
> linux-kernel@vger.kernel.org (open list)
> $
> 
> I actually /have/ talked with one of these maintainers, and he
> suggested PEM decoding under add_key(2) would be appropriate and
> valuable. It actually wasn't my idea. I shall credit his idea in
> the next version of this patch so there won't be any further
> confusion.

It's not appropriate to add UAPIs with no regards for increasing the kernel's
attack surface, especially for things that can easily be done in userspace.  The
kernel community is already struggling with thousands of syzbot reports and
constant security vulnerabilites.  I understand that your patch is not yet
finished, but it doesn't really matter; this is no need for this patch at all as
you can just convert PEM => DER in userspace.

PEM decoding is just some data processing which can be implemented in userspace
in any programming language, so it's not fundamentally different from
sys_leftpad().  So in my opinion the comparison is relevant.

- Eric
