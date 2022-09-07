Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C75C38145
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Sep 2022 20:41:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiIGUlQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Sep 2022 16:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiIGUlO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2022 16:41:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8133CBD1FC;
        Wed,  7 Sep 2022 13:41:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A34BFB81CA7;
        Wed,  7 Sep 2022 20:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBF4C433C1;
        Wed,  7 Sep 2022 20:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662583268;
        bh=ip4FhAL88dfCpkKLdUPKOtJ/fePqxLFukBySnd+5JiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B8yutk6z0KFP856caiJPQVqzv+7KZtfZ6/f2ZuAhYYlEVGr8sW4LLTc5Bowp1DoUV
         cA6tKkfx3Cg3LKCvYzvSZw/WxlYQomRhyBQkNbQcnm5CGIRZWS7+K/GnI8nhnFVNkF
         j5aKSxsr33jm4FDnAqdhSkdMZn1uPz9R+5vraNzs=
Date:   Wed, 7 Sep 2022 13:41:07 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Alexander Potapenko <glider@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Robert Elliott <elliott@hpe.com>
Subject: Re: linux-next: manual merge of the mm tree with the crypto tree
Message-Id: <20220907134107.bcb8b9c22b9ae517e3b43711@linux-foundation.org>
In-Reply-To: <CAG_fn=UcWy+gbYLDM2WQZ=BZuVRML17KJ0L+=zsSg7+yDo4oGA@mail.gmail.com>
References: <20220906202017.5093fd23@canb.auug.org.au>
        <YxfFzGObDWsylCK+@quark>
        <CAG_fn=UcWy+gbYLDM2WQZ=BZuVRML17KJ0L+=zsSg7+yDo4oGA@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 7 Sep 2022 11:18:24 +0200 Alexander Potapenko <glider@google.com> wrote:

> What's the best way to handle this? Send another patch series? Or
> maybe just an update for "crypto: kmsan: disable accelerated configs
> under KMSAN"?

I'd prefer the minimal update, please.
