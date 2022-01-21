Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E2CC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Jan 2022 19:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbiAUTvW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jan 2022 14:51:22 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57690 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiAUTvV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jan 2022 14:51:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4167614D6
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jan 2022 19:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB56C340E1;
        Fri, 21 Jan 2022 19:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642794680;
        bh=8BmhUZ0IpHZYhILT7YzhRJy+4bo2IwVID8v7pOcNti4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c+qr8tGUIyA6rTB+LSYTav7qcMnTeRS83rqVVbJsWKlgMmyrB+z+7r6ZICFVQSJIY
         uXtrz1jT+29Accnc8R0twQHmrCrNzHIHHfWsVkhq1QCiM10cYeNGnUOp8VaVyUZfU7
         TK8Tza7VaLnayAV6va6z/UtxBoL9U2LqHFiecQ5LoNIR0BrE+SJNoKLfLKyLSV6cLs
         NbYKXm4lQsg+z6K92hgMlFXDQobrYx683tRaPN1/1OisX11PgGccnXVuoIoxA5LAQg
         MYAePXEPxUXnwar+qAC1LKmIqgN487yeaFI4Igt1wLxaHxQ8rYzdz9CwMewFl+bJNe
         CJzMBJ38morGw==
Date:   Fri, 21 Jan 2022 11:51:18 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        arnd@arndb.de
Subject: Re: [PATCH] crypto: memneq: avoid implicit unaligned accesses
Message-ID: <YesOtoqUf5XLQWd5@sol.localdomain>
References: <20220119093109.1567314-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220119093109.1567314-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 19, 2022 at 10:31:09AM +0100, Ard Biesheuvel wrote:
> The C standard does not support dereferencing pointers that are not
> aligned with respect to the pointed-to type, and doing so is technically
> undefined behavior, even if the underlying hardware supports it.
> 
> This means that conditionally dereferencing such pointers based on
> whether CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y is not the right thing
> to do, and actually results in alignment faults on ARM, which are fixed
> up on a slow path. Instead, we should use the unaligned accessors in
> such cases: on architectures that don't care about alignment, they will
> result in identical codegen whereas, e.g., codegen on ARM will avoid
> doubleword loads and stores but use ordinary ones, which are able to
> tolerate misalignment.
> 
> Link: https://lore.kernel.org/linux-crypto/CAHk-=wiKkdYLY0bv+nXrcJz3NH9mAqPAafX7PpW5EwVtxsEu7Q@mail.gmail.com/
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/memneq.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
