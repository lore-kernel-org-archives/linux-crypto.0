Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 993C4E8181D
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Sep 2023 05:21:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbjIZFVZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Sep 2023 01:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjIZFVN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Sep 2023 01:21:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869621B3;
        Mon, 25 Sep 2023 22:21:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D771BC433C9;
        Tue, 26 Sep 2023 05:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695705661;
        bh=IkHjnktKldZibBZypBimCY9b32eN5qfQ3sPlP4a4HjA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ctQ3HMDIAhsOfmFDdVBGNnXBdrsroQ74YczJIgr5ZJFlyk0uHq4iVid9mOT5/h55C
         tIIYI2rSmtEOoUsQXnQbfTcKAWUYaI4lcJNB+tt4EaVZuFhc6ygXwc07uPgOKY8K+i
         65oWvjVKTEkoJLilcp6hVsA4jmOx544l+Yj6czrDml+9wyd7zhSr7x1M7Mx841FH12
         AMioTBYOFyGn/aQY/YxSjsn2K9tXk+4MsC3xYOqSh2MmIY4RuF/q/fP/QRTIKJswUm
         m6arh5krW6HJE6EaZmbovq7eFfNkY6Osl9rjOXpg94hgB3cYXdPB47QdHNziwWFu32
         a2aSE5VH7oIeQ==
Date:   Mon, 25 Sep 2023 22:20:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net, x86@kernel.org
Subject: Re: [PATCH 2/3] crypto: x86/aesni - Correct the data type in struct
 aesni_xts_ctx
Message-ID: <20230926052059.GC3118@sol.localdomain>
References: <20230925151752.162449-1-chang.seok.bae@intel.com>
 <20230925151752.162449-3-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230925151752.162449-3-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 25, 2023 at 08:17:51AM -0700, Chang S. Bae wrote:
> Currently, every field in struct aesni_xts_ctx is defined as a byte
> array of the same size as struct crypto_aes_ctx. This data type
> is obscure and the choice lacks justification.
> 
> To rectify this, update the field type in struct aesni_xts_ctx to
> match its actual structure.
> 
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: x86@kernel.org
> Cc: linux-kernel@vger.kernel.org
> Link: https://lore.kernel.org/all/ZFWQ4sZEVu%2FLHq+Q@gmail.com/

Please put the "Link" directly after the Suggested-by to make it clear that the
link is for the suggestion.  Thanks!

- Eric
