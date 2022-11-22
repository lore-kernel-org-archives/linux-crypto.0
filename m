Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E4AAC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Nov 2022 10:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbiKVK74 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Nov 2022 05:59:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiKVK7y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2022 05:59:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9EB9220F6
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 02:59:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7449761648
        for <linux-crypto@vger.kernel.org>; Tue, 22 Nov 2022 10:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC099C433C1;
        Tue, 22 Nov 2022 10:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669114792;
        bh=++eaJv9pN8ioCV3+hBro6IyODUnTix3i66PRQmp8UDc=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=JVIWPU1ddng5hiYYNadkHd/oaMR4mXBdoDO+ORO8/FhmSFAEZypS6RBJXUxN8dVE4
         f9g/+yR43J2vvn6RSdcwB6mqyZ4Yqd5dMk+KQ+cxgDNOa5A0nVLdaHR7yC9ncnnYjX
         orARZjXCOO5Mv3BWC22+ador28Y2jUxwTXnfz9zvFYa0B/VpsMkuk/IEnN1FXktGVM
         ApHi4B28njgTiDNIgVSi9MbHXcyrF+zeoK/X+jnUbTMUwKn5ogoGHJwWfn7XcWcwnr
         hWbFT/4R+CjQKev+syOwmPEhijzF85MIx5S+V+y6eb1TI+Zoxi9eknzVZeFLE4jBmr
         Ek00mLHgBRKEA==
Date:   Tue, 22 Nov 2022 11:59:51 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Andrej Shadura <andrew.shadura@collabora.co.uk>
Subject: Re: [PATCH] hwrng: u2fzero - account for high quality RNG
In-Reply-To: <Y3yrSFel+sK5Fvqx@zx2c4.com>
Message-ID: <nycvar.YFH.7.76.2211221159190.6045@cbobk.fhfr.pm>
References: <20221119134259.2969204-1-Jason@zx2c4.com> <nycvar.YFH.7.76.2211221122220.6045@cbobk.fhfr.pm> <Y3yrSFel+sK5Fvqx@zx2c4.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 22 Nov 2022, Jason A. Donenfeld wrote:

> > This should probably go via Herbert's tree, because it depends on some
> > changed handling for the zero quality field.

OK, I will drop it. At least Herbert can include Andrej's ack :)

-- 
Jiri Kosina
SUSE Labs

