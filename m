Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD74BC04A95
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Oct 2022 05:26:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiJYF0u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 Oct 2022 01:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiJYF0t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Oct 2022 01:26:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A05BBE1D
        for <linux-crypto@vger.kernel.org>; Mon, 24 Oct 2022 22:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B4D3B81A49
        for <linux-crypto@vger.kernel.org>; Tue, 25 Oct 2022 05:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9CFC433D7;
        Tue, 25 Oct 2022 05:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666675606;
        bh=kqvGHt/BCrkmvLxTLp2QkpfPx7FX3mrc2G3lHv+b7wE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m0SIos9BRNYogJssDVTRxljzXZdESTR8RgnU6YslvF4/tXAE2wWC7zwFmu0ya/8et
         G5wCrXssUDlJpQtdAUUS/G388yUwvBVgibwahQfz+9OcTPBv16s9b9uN/DKw7xJGac
         XniLcYUwX/ToH3akOWhkYyvQ+mCPDotDF1TL28MdXcZDiDvQe/OZ2aI+YKriOUHBpN
         ctYl/WaY/4pnTWhjVoKnH+FUdw28g+RH6agzFv8LJC9ks3xF03nScECL8lzjMXQCJp
         Xuoqgw7ZSrlP4CTR3oec+T6SZ6hrfK2CDIsevNfuiLL8kTaPVgIhJL0FtGorQFxTLN
         sboZVww2xntyg==
Date:   Mon, 24 Oct 2022 22:26:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        keescook@chromium.org, jason@zx2c4.com, nikunj@amd.com
Subject: Re: [PATCH v4 1/3] crypto: move gf128mul library into lib/crypto
Message-ID: <Y1dzlHpVQZo46ESu@sol.localdomain>
References: <20221024063052.109148-1-ardb@kernel.org>
 <20221024063052.109148-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024063052.109148-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Oct 24, 2022 at 08:30:50AM +0200, Ard Biesheuvel wrote:
> +config CRYPTO_GF128MUL
> +	tristate

This should be renamed to CRYPTO_LIB_GF128MUL, to make it consistent with all
the other CRYPTO_LIB_* options.  (It could be a separate patch, though.)

- Eric
