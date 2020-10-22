Return-Path: <SRS0=kAoH=D5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688ABC388F7
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 04:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02C1B2244C
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Oct 2020 04:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603342793;
	bh=WvVuJz+/4YZGALIbT2NQSAijT0f64qk3O8quVRu9xfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FrJvczbJa4hfqpnddUUNxHfeAeC11EJ01ABu7lV8YD8BBpZ0s39CzS/6bPtBpHA7t
	 frOEKyNOKlO3yqgzqaeX9nWCHBd/8K0xEDR0b/kxrcBuRBFWs2Wv/Cl20WJIJv1pkP
	 rX7Sjq1olBRuW4jPHboYWRGfLMYbrxRQk5Go39vY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507675AbgJVE7w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Oct 2020 00:59:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2507674AbgJVE7w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Oct 2020 00:59:52 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6229E223C7;
        Thu, 22 Oct 2020 04:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603342791;
        bh=WvVuJz+/4YZGALIbT2NQSAijT0f64qk3O8quVRu9xfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t8F2EKxXInosJwT1lFMui9knEKRSU4hD4DoGrnxfzUdcpXtgnWfnxqGJySfQ8tMA6
         5cvQ9IET7TZDpV3r3ppH7QB6IYQz13DhAQA8DvCGKGFJsh0FN67txrWYesmt7kVQGq
         JZqRskcDZdyhTqYOUMmiXZ5e8vV26144iZrQdSq8=
Date:   Wed, 21 Oct 2020 21:59:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/6] crypto: lib/sha256 - Clear W[] in sha256_update()
 instead of sha256_transform()
Message-ID: <20201022045949.GF857@sol.localdomain>
References: <20201020203957.3512851-1-nivedita@alum.mit.edu>
 <20201020203957.3512851-4-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020203957.3512851-4-nivedita@alum.mit.edu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 20, 2020 at 04:39:54PM -0400, Arvind Sankar wrote:
> The temporary W[] array is currently zeroed out once every call to
> sha256_transform(), i.e. once every 64 bytes of input data. Moving it to
> sha256_update() instead so that it is cleared only once per update can
> save about 2-3% of the total time taken to compute the digest, with a
> reasonable memset() implementation, and considerably more (~20%) with a
> bad one (eg the x86 purgatory currently uses a memset() coded in C).
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>
