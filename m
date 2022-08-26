Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BF6BECAAA3
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Aug 2022 04:48:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244040AbiHZEsc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Aug 2022 00:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244728AbiHZEs3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Aug 2022 00:48:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407D3CE45E;
        Thu, 25 Aug 2022 21:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2FE261211;
        Fri, 26 Aug 2022 04:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EECC433D6;
        Fri, 26 Aug 2022 04:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661489307;
        bh=sKi6Oxk6oL7e9NswJoJsx+lkC8U41lRM2+MDm7W5b/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qpRzscZt5g9e0DvVVwBfVxpZpVFd7RIq7S6uTG/4ovqQutA+9LTvMb7eaWh3uKLWI
         Ui5tTyoGwsaAUa/r9EFh+Ww5e/LoKRBYCrUA9J3hLZlJWap87AA7rsllD58Hwzaxez
         5Im3GpItWJ+KhGz1ASiojs5FhrXvChdx3EjRuCYLto+FgQAtpp5kQ/k5QdmchJvDs2
         nmGQTk8LxSdEWdhGoaKxukv1kOQE08Or0hFwDE5wTaFzX8/sxASD8ImeUWnlr9fzQV
         OYGs3Rg+cNhH0zCzba6EE6FAVCaafpJPHEdf/gWTp2RY31HBUDEguDYroB7Q+DO6Cs
         6nZZW1peN8z2w==
Date:   Thu, 25 Aug 2022 21:48:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "Jason A . Donenfeld " <Jason@zx2c4.com>,
        "Justin M. Forbes" <jforbes@fedoraproject.org>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 2/3] crypto: lib - move __crypto_xor into utils
Message-ID: <YwhQmcgPpe2fpx86@sol.localdomain>
References: <20220725183636.97326-1-ebiggers@kernel.org>
 <20220725183636.97326-3-ebiggers@kernel.org>
 <YwhPtnL6yVG0K2Lo@sol.localdomain>
 <YwhQIRVc60u4B9Bs@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwhQIRVc60u4B9Bs@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 26, 2022 at 12:46:25PM +0800, Herbert Xu wrote:
> On Thu, Aug 25, 2022 at 09:44:38PM -0700, Eric Biggers wrote:
> .
> > Herbert, any chance that you could send my patch series to Linus without waiting
> > for the next merge window, so that it can be backported?
> 
> Sure, which patch fixes this?
> 

The one I'm commenting on (patch 2 of 3).  But patch 1 is needed as a
prerequisite.

- Eric
