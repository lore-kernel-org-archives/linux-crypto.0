Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD31C3A5A7
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 03:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiLBDSV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Dec 2022 22:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiLBDSU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Dec 2022 22:18:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264FBAE4CA;
        Thu,  1 Dec 2022 19:18:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C3A6B82070;
        Fri,  2 Dec 2022 03:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9C4C433D6;
        Fri,  2 Dec 2022 03:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669951097;
        bh=LC2B3mgW44PPrtgOhskq90zZMgQ/Pg+gQ+L5Hg3ns3g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nv/oclSwCClssggORMrseuTQXq7sWK9pJn2B0OMRPx1cdoA2AFQTmEtLFC+yTNa73
         8wunAZTpMDXO2ZRRrvS4DGfkwGhPB08R7OO7Mi9xS9dOnU4dkqBuTg69z1M437paCA
         3x5BtfckCB8z6pKMPHW5J3HJWy/fW/B3HwYwokrOGpaFXrtxT6U8eYC9DSxYPM9hpk
         BClMggV51/q77Y8TrgZKKbTyg2M44ogpA2iERicRk9QIjZ46vZyXNql+1oidc/3ssp
         zpfSbn5AdAHhOe3IHjRwx2O5g+eBSz5abnC4evaoO+5p2mUcMksebJD0SAsXyOzqq3
         n7x8XuXUTi4mQ==
Date:   Thu, 1 Dec 2022 19:18:15 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pankaj Gupta <pankaj.gupta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v2] crypto/caam: Avoid GCC constprop bug warning
Message-ID: <Y4ludwin631WFhcG@sol.localdomain>
References: <20221202010410.gonna.444-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202010410.gonna.444-kees@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 01, 2022 at 05:04:14PM -0800, Kees Cook wrote:
> GCC 12 appears to perform constant propagation incompletely(?) and can
> no longer notice that "len" is always 0 when "data" is NULL. Expand the
> check to avoid warnings about memcpy() having a NULL argument:

Is there a gcc option to turn off the "memcpy with NULL and len=0 is undefined
behavior" thing?  It's basically a bug in the C standard.

Note that the kernel already uses options that make other types of undefined
behavior defined: -fno-strict-overflow, -fno-strict-aliasing, and
-fno-delete-null-pointer-checks.

- Eric
