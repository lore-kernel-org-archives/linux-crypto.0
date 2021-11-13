Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C97FFC433EF
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Nov 2021 23:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9736B61163
	for <linux-crypto@archiver.kernel.org>; Sat, 13 Nov 2021 23:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbhKMXEy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 13 Nov 2021 18:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:50592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229988AbhKMXEy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 13 Nov 2021 18:04:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76A6761152;
        Sat, 13 Nov 2021 23:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636844521;
        bh=NmRM6yovSAsjx9sFuLYoEkOxqWEy8yw0t+32Fr9QIjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A8XHyOZPLeKIF5+SspReGPzg6OWHeKY9bswbsZG04O1UR4pw5XRV609ziUmwHVN9o
         lKxYk9eYyGifHOuopWrDoz/o8i9vdqAuf9IxJuaf8rO6TLkuU1llA5UNZlcXPb4iK4
         9Prm+wawTDODCrMqq3ZqB1Kw7mi2MnETIp6BhgnOM9278f32YnHa3DotOBUbDmmoVE
         cWpUSpaG9LlxO3CEw6HbnWlFTumojtu4wRekHadJQ8qHP1/11J5mmwbA1RXMrlGXuv
         Adkohix/6AqLlj2Y77/+qwVJG9eJGHiP9C9kEgIea0Xln6o8On/reWF3zt0ujpwvVm
         7v7WtrNbPBtqA==
Date:   Sat, 13 Nov 2021 15:02:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     David Howells <dhowells@redhat.com>,
        Alexander Krizhanovsky <ak@tempesta-tech.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH Strawman] crypto: Handle PEM-encoded x.509 certificates
Message-ID: <YZBD6MukiZXKgLo3@sol.localdomain>
References: <163673838611.45802.5085223391786276660.stgit@morisot.1015granger.net>
 <YY63HENw3fjowWH0@gmail.com>
 <46C06033-B65B-473A-91F1-584878354C72@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C06033-B65B-473A-91F1-584878354C72@oracle.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Nov 13, 2021 at 07:12:44PM +0000, Chuck Lever III wrote:
> 
> Certainly, the kernel could include a single set of base64 encoders
> and decoders that can be used by all in-kernel consumers. See for
> example net/ceph/armor.c and fs/crypto/fname.c .

Not really, there are many variants of Base64 and different policy decisions
that can be made: the chosen character set, whether to pad or not pad, whether
to allow whitespace, how to handle invalid characters, how to handle invalid
padding, whether to nul-terminate, and so on.  There's lots of room for bugs and
incompatibilities.

> 
> Because PEM decoding does not require any policy decisions, and
> because the kernel already has at least two existing partial
> base64 implementations, I'm not aware of a technical reason a
> system call like add_key(2) should not to accept PEM-encoded
> asymmetric key material.

Adding kernel UAPIs expands the kernel's attack surface, causing security
vulnerabilities.  It also increases the number of UAPIs that need to be
permanently supported.  It makes no sense to add kernel UAPIs for things that
can be easily done in userspace.

They work well as April Fools' jokes, though:
https://lore.kernel.org/r/1459463613-32473-1-git-send-email-richard@nod.at
Perhaps you meant to save your patch for April 1?

- Eric
