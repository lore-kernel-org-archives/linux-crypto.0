Return-Path: <SRS0=WqbL=AT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D6CC433E0
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 16:19:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EDB3207C4
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jul 2020 16:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594225148;
	bh=ILofiPLbQqaWS+EUL/qahZP/Sgv6I/5/9ddjVJu3z74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=XR8mfLsyAWXtC5tvWpeIbYL8d48zw0IWv32AFkg0jTGgdQntJIN39tYIju+pG0U3d
	 G+ZaFSdCHKqYQSLax2+Bc1r1adGlVfLLEoyZc+tWkAWB7uxXaiNG9AG78LXDr8MrQs
	 q1myDW26FCQJe0A1odJzAT35lu0DAixf2fJKFEOE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgGHQTI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jul 2020 12:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728148AbgGHQTH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jul 2020 12:19:07 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67C6620786;
        Wed,  8 Jul 2020 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594225147;
        bh=ILofiPLbQqaWS+EUL/qahZP/Sgv6I/5/9ddjVJu3z74=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gqcYK4YPaZVgpxOdesnQg6qr68/5KFc1IC8si4P4Zm+fcuJF/Nt5u0PBTlqgSBP6I
         pC8pjT4rCULlt3eifdd/QVpw5GadZqR7WyjgqhkZbNBUww4i3pxCWeG7cpQh1BYnej
         uwTjlaIXP64aq/2S5dtk1KDys5uMJVkOy3uhKiXk=
Date:   Wed, 8 Jul 2020 09:19:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, Martin Willi <martin@strongswan.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: x86/chacha-sse3 - use unaligned loads for state
 array
Message-ID: <20200708161906.GA4557@sol.localdomain>
References: <20200708091118.1389-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200708091118.1389-1-ardb@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 08, 2020 at 12:11:18PM +0300, Ard Biesheuvel wrote:
> Due to the fact that the x86 port does not support allocating objects
> on the stack with an alignment that exceeds 8 bytes, we have a rather
> ugly hack in the x86 code for ChaCha to ensure that the state array is
> aligned to 16 bytes, allowing the SSE3 implementation of the algorithm
> to use aligned loads.
> 
> Given that the performance benefit of using of aligned loads appears to
> be limited (~0.25% for 1k blocks using tcrypt on a Corei7-8650U), and
> the fact that this hack has leaked into generic ChaCha code, let's just
> remove it.
> 
> Cc: Martin Willi <martin@strongswan.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Eric Biggers <ebiggers@google.com>
