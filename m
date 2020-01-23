Return-Path: <SRS0=jQAN=3M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B96BCC2D0DB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 19:43:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E8E821D7D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jan 2020 19:43:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gh0EoNYf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728984AbgAWTnG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jan 2020 14:43:06 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40630 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728809AbgAWTnG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jan 2020 14:43:06 -0500
Received: by mail-wr1-f65.google.com with SMTP id c14so4466851wrn.7;
        Thu, 23 Jan 2020 11:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dds72xgWKk6o4+6RF9ICr9VA37gAfeq0HCAWVx4roNo=;
        b=gh0EoNYfpzt+FKAeojTAmwIs5wsrYAAZSSDmmC2GJf2qJ3IA+n6Wo4oc7H9mZEq+WN
         92mxyp9Au491zkGp5deDQoiYzk3GKr6+6KdEHbvkygeVG2SG0G62+3k3uS08TeK4qYg9
         guDMpFyFrUEmxJDYxKjzMGUhVrvPpJExe3oOTj4TRtJSuB50Ab1mzA76pTuiBgZfrrZy
         wZ6cCeWrz524A6t0xzPuL2gsenA9WoQxlZJfuWWfNkkrxYF/rzgubPR4fq0aNUG8PQCD
         0dsZmYL4UUwF1aD5Wrc2FMNxC/GjNhjx6L4O2aNVYDaUA+2Ll00HRVZP2jasrQKJUQoA
         Z+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dds72xgWKk6o4+6RF9ICr9VA37gAfeq0HCAWVx4roNo=;
        b=RrhG1qgifTv0j/fF/JntwtWJ8SOVxgsCNnwkuvI5yaZJ88UB7iT30/aU5pa3RUZEhi
         oxjtLMm+fTyClsUecGCtrt70ur+lUYHkHR0pTM66oDwMbocdrkX6CVp1mCLPHtP3ztx/
         K0X2tcLCon9gf+CxoRGSxipWeXyeVnOHzyQmRI/8JbTbjD45339eTpoeV/znxym//CIY
         HLt5yaKmpyvMTbPQnZvPYtPWEYFDrvakkbvq80SqPtn5nkzFG7XP5TZ2sLDs6Of62u66
         HygIKK0EUcx3CD++cDXcZTfKcubUDelDyOhbYU2eHVdndUQhRqq4hdBXhwmGhBfBCeWM
         92MA==
X-Gm-Message-State: APjAAAXggwSLUh5R6PRoNuI7+WyITPlIuYHBtxs7DM9DRdt/0bdKHws0
        B8eLG/Yu9GObFcYuWXEQxOw=
X-Google-Smtp-Source: APXvYqxt5f3eYFuQxjf4RPRQpOEQzuXprxI1Bhvc8hZm/4OoV1ujnCC6oOGpAfOi9d3uDRj1iEVEQQ==
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr20265640wrk.53.1579808584533;
        Thu, 23 Jan 2020 11:43:04 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id e12sm4233451wrn.56.2020.01.23.11.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 11:43:03 -0800 (PST)
Date:   Thu, 23 Jan 2020 20:43:01 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH v4 0/9] crypto: caam - backlogging support
Message-ID: <20200123194301.GA20198@Red>
References: <1579523048-21078-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1579523048-21078-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 20, 2020 at 02:23:59PM +0200, Iuliana Prodan wrote:
> Integrate crypto_engine framework into CAAM, to make use of
> the engine queue.
> Added support for SKCIPHER, HASH, RSA and AEAD algorithms.
> This is intended to be used for CAAM backlogging support.
> The requests, with backlog flag (e.g. from dm-crypt) will be
> listed into crypto-engine queue and processed by CAAM when free.
> 
> While here, I've also made some refactorization.
> Patches #1 - #4 include some refactorizations on caamalg, caamhash
> and caampkc.
> Patch #5 changes the return code of caam_jr_enqueue function
> to -EINPROGRESS, in case of success, -ENOSPC in case the CAAM is
> busy, -EIO if it cannot map the caller's descriptor.
> Patches #6 - #9 integrate crypto_engine into CAAM, for
> SKCIPHER/AEAD/RSA/HASH algorithms.
> 
> ---
> Changes since V3:
> 	- update return on ahash_enqueue_req function from patch #9.
> 
> Changes since V2:
> 	- remove patch ("crypto: caam - refactor caam_jr_enqueue"),
> 	  that added some structures not needed anymore;
> 	- use _done_ callback function directly for skcipher and aead;
> 	- handle resource leak in case of transfer request to crypto-engine;
> 	- update commit messages.
> 
> Changes since V1:
> 	- remove helper function - akcipher_request_cast;
> 	- remove any references to crypto_async_request,
> 	  use specific request type;
> 	- remove bypass crypto-engine queue, in case is empty;
> 	- update some commit messages;
> 	- remove unrelated changes, like whitespaces;
> 	- squash some changes from patch #9 to patch #6;
> 	- added Reviewed-by.
> ---
> 
> Iuliana Prodan (9):
>   crypto: caam - refactor skcipher/aead/gcm/chachapoly {en,de}crypt
>     functions
>   crypto: caam - refactor ahash_done callbacks
>   crypto: caam - refactor ahash_edesc_alloc
>   crypto: caam - refactor RSA private key _done callbacks
>   crypto: caam - change return code in caam_jr_enqueue function
>   crypto: caam - support crypto_engine framework for SKCIPHER algorithms
>   crypto: caam - add crypto_engine support for AEAD algorithms
>   crypto: caam - add crypto_engine support for RSA algorithms
>   crypto: caam - add crypto_engine support for HASH algorithms
> 
>  drivers/crypto/caam/Kconfig    |   1 +
>  drivers/crypto/caam/caamalg.c  | 416 ++++++++++++++++++-----------------------
>  drivers/crypto/caam/caamhash.c | 341 ++++++++++++++++-----------------
>  drivers/crypto/caam/caampkc.c  | 187 +++++++++++-------
>  drivers/crypto/caam/caampkc.h  |  10 +
>  drivers/crypto/caam/caamrng.c  |   4 +-
>  drivers/crypto/caam/intern.h   |   2 +
>  drivers/crypto/caam/jr.c       |  37 +++-
>  drivers/crypto/caam/key_gen.c  |   2 +-
>  9 files changed, 523 insertions(+), 477 deletions(-)
> 

Hello

I have tested this serie on a imx8mn-ddr4-evk and get the follwing crash:
[   34.367787] Unable to handle kernel paging request at virtual address cccccccccccccccc
[   34.375715] Mem abort info:
[   34.378506]   ESR = 0x96000004
[   34.381572]   EC = 0x25: DABT (current EL), IL = 32 bits
[   34.386888]   SET = 0, FnV = 0
[   34.389948]   EA = 0, S1PTW = 0
[   34.393091] Data abort info:
[   34.395978]   ISV = 0, ISS = 0x00000004
[   34.399816]   CM = 0, WnR = 0
[   34.402781] [cccccccccccccccc] address between user and kernel address ranges
[   34.409922] Internal error: Oops: 96000004 [#1] PREEMPT SMP
[   34.415492] Modules linked in: ctr des_generic caam_jr(+) caamhash_desc caamalg_desc rng_core authenc libdes fsl_imx8_ddr_perf snvs_pwrkey rtc_snvs caam error imx_cpufreq_dt
[   34.430977] CPU: 2 PID: 267 Comm: cryptomgr_test Not tainted 5.5.0-rc7-next-20200122-00009-geed96b480af6 #39
[   34.440799] Hardware name: NXP i.MX8MNano DDR4 EVK board (DT)
[   34.446542] pstate: 60000005 (nZCv daif -PAN -UAO)
[   34.451337] pc : __kmalloc+0xc4/0x290
[   34.454997] lr : __kmalloc+0x48/0x290
[   34.458655] sp : ffff800011b0b740
[   34.461965] x29: ffff800011b0b740 x28: 0000000000000002 
[   34.467275] x27: 0000000000000080 x26: ffff800010c4b598 
[   34.472584] x25: 0000000000000cc0 x24: ffff00007b79b000 
[   34.477894] x23: 000000000000ac02 x22: ffff800008c5c254 
[   34.483203] x21: 0000000000000dc1 x20: cccccccccccccccc 
[   34.488512] x19: ffff00007d404200 x18: 0000000000000002 
[   34.493821] x17: 0000000008080040 x16: 0000000008182040 
[   34.499131] x15: 0000000002004800 x14: 0000000000000000 
[   34.504440] x13: 0000000000000000 x12: 0000000300000017 
[   34.509749] x11: fffffe0001ca2702 x10: 0000000000000000 
[   34.515058] x9 : 0000000000000000 x8 : ffff8000115e98c8 
[   34.520368] x7 : ffff800011776000 x6 : 0000000000000000 
[   34.525677] x5 : 000000000000ac02 x4 : 0000000000000011 
[   34.530986] x3 : 0000000000000002 x2 : 0000000000000000 
[   34.536295] x1 : ffff00007aaaf000 x0 : 0000000000000001 
[   34.541606] Call trace:
[   34.544051]  __kmalloc+0xc4/0x290
[   34.547377]  skcipher_edesc_alloc+0x154/0xab0 [caam_jr]
[   34.552607]  skcipher_encrypt+0x58/0x118 [caam_jr]
[   34.557397]  crypto_skcipher_encrypt+0x40/0x70
[   34.561839]  test_skcipher_vec_cfg+0x254/0x768
[   34.566279]  test_skcipher_vec+0xfc/0x148
[   34.570285]  alg_test_skcipher+0xc0/0x1e8
[   34.574294]  alg_test.part.32+0xb0/0x378
[   34.578214]  alg_test+0x3c/0x68
[   34.581354]  cryptomgr_test+0x44/0x50
[   34.585015]  kthread+0x118/0x120
[   34.588241]  ret_from_fork+0x10/0x18
[   34.591818] Code: d5384101 b9402262 b9401020 11000400 (f8626a98) 
[   34.597910] ---[ end trace 3e4862893c99a748 ]---

Regards
