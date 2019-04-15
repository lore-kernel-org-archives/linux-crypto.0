Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F1CFC10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 05:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56FC6206B7
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 05:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbfDOFMy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 01:12:54 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:47613 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbfDOFMx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 01:12:53 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 44jGpq4m4lz9s4V;
        Mon, 15 Apr 2019 15:12:51 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 2/3] crypto: nx - don't abuse shash MAY_SLEEP flag
In-Reply-To: <20190415003709.1531-3-ebiggers@kernel.org>
References: <20190415003709.1531-1-ebiggers@kernel.org> <20190415003709.1531-3-ebiggers@kernel.org>
Date:   Mon, 15 Apr 2019 15:12:51 +1000
Message-ID: <87wojvua0c.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:
> From: Eric Biggers <ebiggers@google.com>
>
> The nx driver uses the MAY_SLEEP flag in shash_desc::flags as an
> indicator to not retry sending the operation to the hardware as many
> times before returning -EBUSY.  This is bogus because (1) that's not
> what the MAY_SLEEP flag is for, and (2) the shash API doesn't allow
> failing if the hardware is busy anyway.

Can you elaborate a bit on that 2nd point? What is the driver meant to
do if the hardware is busy or out to lunch? Retry forever?

> For now, just make it always retry the larger number of times.  This
> doesn't actually fix this driver, but it at least makes it not use the
> shash_desc::flags field anymore.  Then this field can be removed, as no
> other drivers use it.

This looks fine to me, thanks for fixing it up.

cheers
