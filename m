Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 654B2C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47ADA61054
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhKLSv7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 13:51:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235605AbhKLSvx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 13:51:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05D1560E93;
        Fri, 12 Nov 2021 18:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636742942;
        bh=YmH3uZL6HOSiiJdhCMQvEPnVa+dQmUYAqOdfe8etO40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p2aNHWBqogD/obtWOsZdEnt9UV5fymTX7Gr32uZ+toY3uW/mOMmNJyFAfWntCJqTC
         WkoPZfcC9DVYCqe+P6Ebx29CFbqFOe3mVRrlGmLsZn749T0AGjk5+jro1pSpefS08V
         UXeUpSCL7gJ4tCYC6MetpfpFMAB/GzPgDGL+/cxmtpjCgRnOccO6d7vyir8C0Wwqh6
         6lgGdWd20zOUeDZ9KOr/TgcvtTlM/WnayKC7n1ILz/e7taEAPpWl7JAHCBJralvZS4
         C5ILIO4EZK+QcadztyzApuYhSR3NXtfQZDezN6+2vWYCIQHu6v5l4GvYcWJDRsCmL8
         Ox/hj1kpuXU/A==
Date:   Fri, 12 Nov 2021 10:49:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     dhowells@redhat.com, ak@tempesta-tech.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH Strawman] crypto: Handle PEM-encoded x.509 certificates
Message-ID: <YY63HENw3fjowWH0@gmail.com>
References: <163673838611.45802.5085223391786276660.stgit@morisot.1015granger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163673838611.45802.5085223391786276660.stgit@morisot.1015granger.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 12, 2021 at 12:39:52PM -0500, Chuck Lever wrote:
> This enables "# cat cert.pem | keyctl padd asymmetric <keyring>"
> 
> Since prep->data is a "const void *" I didn't feel comfortable with
> pem_decode() simply overwriting either the pointer or the contents
> of the provided buffer. A secondary buffer is therefore allocated,
> and then later freed by .free_preparse.
> 
> This compiles, but is otherwise untested. I'm interested in opinions
> about this approach.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Why?  You can easily convert PEM to DER in userspace, for example with a command
like 'openssl x509 -in cert.pem -out cert.der -outform der'.  There's no need
for the kernel to do it.

- Eric
