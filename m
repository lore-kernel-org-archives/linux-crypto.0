Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BA1C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 19:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245751AbiCWTbR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 15:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiCWTbR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 15:31:17 -0400
Received: from isilmar-4.linta.de (isilmar-4.linta.de [136.243.71.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1D6888FB;
        Wed, 23 Mar 2022 12:29:45 -0700 (PDT)
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
X-isilmar-external: YES
Received: from owl.dominikbrodowski.net (owl.brodo.linta [10.2.0.111])
        by isilmar-4.linta.de (Postfix) with ESMTPSA id 12CD6201407;
        Wed, 23 Mar 2022 19:29:43 +0000 (UTC)
Received: by owl.dominikbrodowski.net (Postfix, from userid 1000)
        id 832E980631; Wed, 23 Mar 2022 20:29:36 +0100 (CET)
Date:   Wed, 23 Mar 2022 20:29:36 +0100
From:   Dominik Brodowski <linux@dominikbrodowski.net>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Theodore Ts'o <tytso@mit.edu>,
        Graham Christensen <graham@grahamc.com>
Subject: Re: [PATCH] random: treat bootloader trust toggle the same way as
 cpu trust toggle
Message-ID: <Yjt1IHpxCOJ4/MhC@owl.dominikbrodowski.net>
References: <20220323041123.146459-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323041123.146459-1-Jason@zx2c4.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Tue, Mar 22, 2022 at 10:11:23PM -0600 schrieb Jason A. Donenfeld:
> If CONFIG_RANDOM_TRUST_CPU is set, the RNG initializes using RDRAND.
> But, the user can disable (or enable) this behavior by setting
> `random.trust_cpu=0/1` on the kernel command line. This allows system
> builders to do reasonable things while avoiding howls from tinfoil
> hatters. (Or vice versa.)
> 
> CONFIG_RANDOM_TRUST_BOOTLOADER is basically the same thing, but regards
> the seed passed via EFI or device tree, which might come from RDRAND or
> a TPM or somewhere else. In order to allow distros to more easily enable
> this while avoiding those same howls (or vice versa), this commit adds
> the corresponding `random.trust_bootloader=0/1` toggle.
> 
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Graham Christensen <graham@grahamc.com>
> Link: https://github.com/NixOS/nixpkgs/pull/165355
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>

Thanks,
	Dominik
