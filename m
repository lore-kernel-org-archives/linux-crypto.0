Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C48BC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Nov 2021 05:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352390AbhKZFg1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Nov 2021 00:36:27 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:57146 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351992AbhKZFe1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Nov 2021 00:34:27 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mqTpE-0008Qm-3U; Fri, 26 Nov 2021 13:31:08 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mqTpB-0004YK-E4; Fri, 26 Nov 2021 13:31:05 +0800
Date:   Fri, 26 Nov 2021 13:31:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nicolai Stange <nstange@suse.de>
Cc:     Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        "David S. Miller" <davem@davemloft.net>,
        Torsten Duwe <duwe@suse.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] crypto: DRBG - improve 'nopr' reseeding
Message-ID: <20211126053105.GA17477@gondor.apana.org.au>
References: <20211115141809.11420-1-nstange@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211115141809.11420-1-nstange@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 15, 2021 at 03:18:03PM +0100, Nicolai Stange wrote:
> Hi all,
> 
> v1 can be found here:
> 
>   https://lore.kernel.org/r/20211025092525.12805-1-nstange@suse.de
> 
> The changes between v1 and v2 are summarized below.
> 
> 
> Cover letter reproduced 1:1 from v1:
> 
> This patchset aims at (hopefully) improving the DRBG code related to
> reseeding from get_random_bytes() a bit:
> - Replace the asynchronous random_ready_callback based DRBG reseeding
>   logic with a synchronous solution leveraging rng_is_initialized(). This
>   move simplifies the code IMO and, as a side-effect, would enable DRBG
>   users to rely on wait_for_random_bytes() to sync properly with
>   drbg_generate(), if desired. Implemented by patches 1-5/6.
> - Make the 'nopr' DRBGs to reseed themselves every 5min from
>   get_random_bytes(). This achieves at least kind of a partial prediction
>   resistance over the time domain at almost no extra cost. Implemented
>   by patch 6/6, the preceding patches in this series are a prerequisite
>   for this.
> 
> Tested with and without fips_enabled in a x86_64 VM, both with
> random.trust_cpu=on and off. As confirmed with a couple of debugging
> printks() (added for testing only, not included in this series), DRBGs
> have been instantiated with and without rng_is_initialized() evaluating
> to true each during my tests and the patched DRBG reseeding code worked as
> intended in either case.
> 
> Applies to current herbert/cryptodev-2.6.git master.
> 
> 
> Changes between v1 and v2:
> - 4/6: remove redundant goto statement, spotted by Stephan.
> 
> For the unmodified rest, I added Stephan's Reviewed-bys he granted in
> reply to v1.
> 
> Many thanks for your comments and remarks!
> 
> Nicolai
> 
> Nicolai Stange (6):
>   crypto: DRBG - prepare for more fine-grained tracking of seeding state
>   crypto: DRBG - track whether DRBG was seeded with
>     !rng_is_initialized()
>   crypto: DRBG - move dynamic ->reseed_threshold adjustments to
>     __drbg_seed()
>   crypto: DRBG - make reseeding from get_random_bytes() synchronous
>   crypto: DRBG - make drbg_prepare_hrng() handle jent instantiation
>     errors
>   crypto: DRBG - reseed 'nopr' drbgs periodically from
>     get_random_bytes()
> 
>  crypto/drbg.c         | 143 +++++++++++++++++++++---------------------
>  include/crypto/drbg.h |  11 +++-
>  2 files changed, 80 insertions(+), 74 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
