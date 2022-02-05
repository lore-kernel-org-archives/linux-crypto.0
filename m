Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F1DC433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 18:00:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237831AbiBESAu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Feb 2022 13:00:50 -0500
Received: from isilmar-4.linta.de ([136.243.71.142]:58540 "EHLO
        isilmar-4.linta.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiBESAu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Feb 2022 13:00:50 -0500
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 02D3D20135E;
        Sat,  5 Feb 2022 18:00:47 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 2CD38802AE; Sat,  5 Feb 2022 19:00:30 +0100 (CET)
Date:   Sat, 5 Feb 2022 19:00:30 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 4/5] random: always wake up entropy writers after
 extraction
Message-ID: <Yf67Ppx5yDothW6d@owl.dominikbrodowski.net>
References: <20220205160118.252698-1-Jason@zx2c4.com>
 <20220205160118.252698-5-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220205160118.252698-5-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sat, Feb 05, 2022 at 05:01:17PM +0100 schrieb Jason A. Donenfeld:
> Now that POOL_BITS == POOL_MIN_BITS, we must unconditionally wake up
> entropy writers after every extraction. Therefore there's no point of
> write_wakeup_threshold, so we can move it to the dustbin of unused
> compatibility sysctls. While we're at it, we can fix a small comparison
> where we were waking up after <= min rather than < min.
> 
> Suggested-by: Eric Biggers <ebiggers@kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

	Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks,
	Dominik
