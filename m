Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6435C433F5
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Jan 2022 00:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiAEAaH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:30:07 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58968 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233341AbiAEAaG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 4 Jan 2022 19:30:06 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1n4uBg-0006FS-Bl; Wed, 05 Jan 2022 11:29:57 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 05 Jan 2022 11:29:56 +1100
Date:   Wed, 5 Jan 2022 11:29:56 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Peter Gonda <pgonda@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        David Rientjes <rientjes@google.com>, kbuild-all@lists.01.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Marc Orr <marcorr@google.com>
Subject: Re: [PATCH] crypto: fix semicolon.cocci warnings
Message-ID: <YdTmhCzAzX29PJxj@gondor.apana.org.au>
References: <20211218132541.GA80986@65b4fbea3a32>
 <YcU+ZNqZ+pNv06QL@gondor.apana.org.au>
 <CAMkAt6rreu0X6DFENqYAAJ_JMEWoS8cvgf7bDhzgFxAnZturrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMkAt6rreu0X6DFENqYAAJ_JMEWoS8cvgf7bDhzgFxAnZturrg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 04, 2022 at 02:14:16PM -0700, Peter Gonda wrote:
>
> Herbert I see the patches I sent here:
> https://patchwork.kernel.org/project/linux-crypto/list/?series=591933&state=%2A&archive=both.

I meant the bot's patch.

> Are you asking for this bot to resend? Or should I send a fix up patch
> if that's easier.

If you could resend the bot's fix up patch that would be great.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
