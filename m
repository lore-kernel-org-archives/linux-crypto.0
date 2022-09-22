Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D769EC54EE9
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Sep 2022 14:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiIVOCA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiIVOB5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2022 10:01:57 -0400
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8DDC8899;
        Thu, 22 Sep 2022 07:01:55 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 437E220135C;
        Thu, 22 Sep 2022 14:01:53 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 152038052E; Thu, 22 Sep 2022 15:35:52 +0200 (CEST)
Date:   Thu, 22 Sep 2022 15:35:52 +0200
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] random: use hwgenerator randomness more frequently at
 early boot
Message-ID: <YyxkuK5K8x35vSzI@owl.dominikbrodowski.net>
References: <20220904101753.3050-1-linux@dominikbrodowski.net>
 <20220920135456.2766285-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920135456.2766285-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Tue, Sep 20, 2022 at 03:54:58PM +0200 schrieb Jason A. Donenfeld:
> From: Dominik Brodowski <linux@dominikbrodowski.net>
> 
> Mix in randomness from hw-rng sources more frequently during early
> boot, approximately once for every rng reseed.
> 
> Signed-off-by: Dominik Brodowski <linux@dominikbrodowski.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Dominik - I incorporated the refactoring mentioned on the mailing list.
> Hopefully this is okay with you. Holler if I got something wrong! -Jason

Thanks for picking it up! Looks good.

Thanks,
	Dominik
