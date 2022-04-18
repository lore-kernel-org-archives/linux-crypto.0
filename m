Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79E8C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Apr 2022 19:39:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiDRTlz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Apr 2022 15:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbiDRTlz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Apr 2022 15:41:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8BF522B18;
        Mon, 18 Apr 2022 12:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E31D60E17;
        Mon, 18 Apr 2022 19:39:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA664C385A7;
        Mon, 18 Apr 2022 19:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650310754;
        bh=AbxVf+7jcuV5QIoBysMgSF50hqQeyLxUm06G4wHRIkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iVkV6Fk1yLH11i4LUH1lECsemTWLh8XpSZ1G27KLxSshaR75zZDFMMNMjH9jIC9WU
         MRymmlXKIhsa4NUu7eCZSl5Q56NxH1GpvyQFUG3jgyqkncvYVT/MPuyoQMy5mSgRcz
         G3Gn5pAVgXUydiWOOiuzBZ0+P40BPgdlNcEZLXdSuU1P4koS0CdrPtTBZI5EM/z8Md
         VPepnZZGIzRQFNU7UiCWcvwycydcYbrqRqBqgMa1Hph6PfOun5DnD/tVkRkLRYj2/R
         ErtFGxiU3DaiuoB7e4NnEKJLhDXmAKJW6153av0rWMEJ2San7xDjWbRFGWZQNrAEHB
         uvqTqYT9oNN0Q==
Date:   Mon, 18 Apr 2022 12:39:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] random: document crng_fast_key_erasure() destination
 possibility
Message-ID: <Yl2+YfuFNQzhFVbP@sol.localdomain>
References: <20220418192344.1510712-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418192344.1510712-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 18, 2022 at 09:23:44PM +0200, Jason A. Donenfeld wrote:
> This reverts 35a33ff3807d ("random: use memmove instead of memcpy for
> remaining 32 bytes"), which was made on a totally bogus basis. The thing
> it was worried about overlapping came from the stack, not from one of
> its arguments, as Eric pointed out.
> 
> But the fact that this confusion even happened draws attention to the
> fact that it's a bit non-obvious that the random_data parameter can
> alias chacha_state, and in fact should do so when the caller can't rely
> on the stack being cleared in a timely manner. So this commit documents
> that.
> 
> Reported-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>

... but one nit below:

> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 3a293f919af9..87302e85759f 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -318,6 +318,13 @@ static void crng_reseed(bool force)
>   * the resultant ChaCha state to the user, along with the second
>   * half of the block containing 32 bytes of random data that may
>   * be used; random_data_len may not be greater than 32.
> + *
> + * The returned ChaCha state contains within it a copy of the old
> + * key value, at index 4, so that state should always be zeroed
> + * out immediately after using in order to maintain forward secrecy.
> + * If that state cannot be erased in a timely manner, then it is

"that state" => "this state" or "the state" in the two places above, otherwise
the first sentence can be misparsed (as "So that, state" rather than "So, that
state").

- Eric
