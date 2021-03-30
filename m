Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BA4C433C1
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 01:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E91619A5
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 01:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhC3B0N (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Mar 2021 21:26:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:36656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhC3BZo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Mar 2021 21:25:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA698619A9;
        Tue, 30 Mar 2021 01:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617067544;
        bh=w7ObvpJq/R4KO4NDJ46mZajafTPZzB7iT11D4SOoreY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=isj9eWZA0rzplJp8vDf8D9RqN6Ek217KBPdQjMSgnOHxVKlcR7/XeC+I6hE83lcNM
         Dl8s7I/P9ajE0YfLnpcCBanZu06FMPHO60hKA6nmiL0ahm53fG308WFNVTAZsgpaWo
         7pam3qTALqXNrxif7vJDz4FbBzD5WZ4SWgUXipDhtzZAEzmrUm4NVq2zwVaO/de7sn
         AEtUJAVEgPjminveogdry0CXJ4Cd6Weg7lBJhYgkrx0G/KOIMi0LCdjh+30Vt734MT
         ZOB3ZRFM2gfKhC2WEI+OtauTSG53vyRnrDdjfVO8sSEX17fnxDAmluDOAUSqd6cuJq
         yGyKnrqAoQ0Qw==
Date:   Mon, 29 Mar 2021 18:25:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: v5.12.0-rc5: the kernel panics if FIPS mode is on
Message-ID: <YGJ+FrwrSRyvMHoF@gmail.com>
References: <MW2PR2101MB0892C9A8BF670DEC3628CFAFBF7E9@MW2PR2101MB0892.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB0892C9A8BF670DEC3628CFAFBF7E9@MW2PR2101MB0892.namprd21.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 29, 2021 at 09:56:18PM +0000, Dexuan Cui wrote:
> Hi all,
> The v5.12.0-rc5 kernel (1e43c377a79f) panics with fips=1.
> 
> Please refer to the below panic call-trace. The kernel config file and
> the full kernel messages are also attached.
> 
> Is this a known issue?
> 
> Thanks,
> -- Dexuan
> 
>          Starting dracut pre-udev hook...
> [    7.260424] alg: self-tests for sha512-generic (sha512) passed
> [    7.265917] alg: self-tests for sha384-generic (sha384) passed
> [    7.272426] alg: self-tests for sha512-ssse3 (sha512) passed
> [    7.276500] alg: self-tests for sha384-ssse3 (sha384) passed
> [    7.281722] alg: self-tests for sha512-avx (sha512) passed
> [    7.286579] alg: self-tests for sha384-avx (sha384) passed
> [    7.291631] alg: self-tests for sha512-avx2 (sha512) passed
> [    7.296950] alg: self-tests for sha384-avx2 (sha384) passed
> [    7.321040] alg: self-tests for sha3-224-generic (sha3-224) passed
> [    7.330291] alg: self-tests for sha3-256-generic (sha3-256) passed
> [    7.335918] alg: self-tests for sha3-384-generic (sha3-384) passed
> [    7.341508] alg: self-tests for sha3-512-generic (sha3-512) passed
> [    7.381918] alg: self-tests for crc32c-intel (crc32c) passed
> [    7.396694] alg: self-tests for crct10dif-pclmul (crct10dif) passed
> [    7.453515] alg: self-tests for ghash-clmulni (ghash) passed
> [    7.469558] alg: self-tests for des3_ede-asm (des3_ede) passed
> [    7.475355] alg: self-tests for ecb-des3_ede-asm (ecb(des3_ede)) passed
> [    7.481361] alg: self-tests for cbc-des3_ede-asm (cbc(des3_ede)) passed
> [    7.488656] alg: self-tests for des3_ede-generic (des3_ede) passed
> [    7.304930] dracut-pre-udev[502]: modprobe: ERROR: could not insert 'padlock_aes': No such device
> [    7.579580] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
> [    7.606547] alg: self-tests for sha1 (sha1) passed
> [    7.610624] alg: self-tests for ecb(des3_ede) (ecb(des3_ede)) passed
> [    7.615746] alg: self-tests for cbc(des3_ede) (cbc(des3_ede)) passed
> [    7.638067] alg: self-tests for ctr(des3_ede-asm) (ctr(des3_ede)) passed
> [    7.644781] alg: self-tests for ctr(des3_ede) (ctr(des3_ede)) passed
> [    7.653810] alg: self-tests for sha256 (sha256) passed
> [    7.658945] alg: self-tests for ecb(aes) (ecb(aes)) passed
> [    7.663493] alg: self-tests for cbc(aes) (cbc(aes)) passed
> [    7.668421] alg: self-tests for xts(aes) (xts(aes)) passed
> [    7.672389] alg: self-tests for ctr(aes) (ctr(aes)) passed
> [    7.692973] alg: self-tests for rfc3686(ctr-aes-aesni) (rfc3686(ctr(aes))) passed
> [    7.699446] alg: self-tests for rfc3686(ctr(aes)) (rfc3686(ctr(aes))) passed
> [    7.730149] alg: skcipher: failed to allocate transform for ofb(aes): -2
> [    7.735959] Kernel panic - not syncing: alg: self-tests for ofb(aes) (ofb(aes)) failed in fips mode!
> [    7.736952] CPU: 13 PID: 560 Comm: modprobe Tainted: G        W         5.12.0-rc5+ #3
> [    7.736952] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS 090008  12/07/2018
> [    7.736952] Call Trace:
> [    7.736952]  dump_stack+0x64/0x7c
> [    7.736952]  panic+0xfb/0x2d7
> [    7.736952]  alg_test+0x42d/0x460
> [    7.736952]  ? __kernfs_new_node+0x175/0x1d0
> [    7.736952]  do_test+0x3248/0x57ea [tcrypt]
> [    7.736952]  do_test+0x1f2c/0x57ea [tcrypt]
> [    7.736952]  ? 0xffffffffc031d000
> [    7.736952]  tcrypt_mod_init+0x55/0x1000 [tcrypt]

It looks like your userspace is using tcrypt.ko to request that the kernel test
"ofb(aes)", but your kernel doesn't have CONFIG_CRYPTO_OFB enabled so the test
fails as expected.  Are you sure that anything changed on the kernel side
besides the kconfig you are using?  It looks like this was always the behavior
when tcrypt.ko is used to test a non-existing algorithm.

Is your userspace code intentionally trying to test "ofb(aes)", or is it
accidental?

- Eric
