Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86CE2C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Dec 2020 23:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53A42229CA
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Dec 2020 23:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgLUXVd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Dec 2020 18:21:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:47956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgLUXVd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Dec 2020 18:21:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4897F229CA;
        Mon, 21 Dec 2020 23:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608592852;
        bh=aZrad35uWEsEtzj4Xjsa9EmwCyRExTsKrZ2byjpw+XI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GlXbYWutbfR5ZwOBAiMh8CCDoAVJniVxQ1Ca2pjv1v8yiC1ndOqTLVKU4pZU5jmyv
         zM4gCsasrI2K1zvyjJnlgCcLKxnw3nvTbvir+8v1UcPwZa0uVqdykBb5cXfixLl6aD
         RrdQbmSf56XS/nI5Om08R9sq5kFz1b8LlHrO6TFvQW4jgNZjqoleAAtSiBVoxUyRgX
         NJseY5YXHJ2X0nnZ97bUadl3XMpvmep8Y2XXimNQtOC1NMmvcTQQZmaq2/13ztzJ52
         tockDDm5A0RtAJlptiF95iusL1TzHAdb4MN4HSFttUr/ysRYKriXmqptLMLF0rLfnu
         HQvim89zlIkNg==
Date:   Mon, 21 Dec 2020 15:20:50 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Megha Dey <megha.dey@intel.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, dave.hansen@intel.com,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        tony.luck@intel.com, ira.weiny@intel.com, x86@kernel.org
Subject: Re: [RFC V1 0/7] Introduce AVX512 optimized crypto algorithms
Message-ID: <X+Et0ubPcBVZOURL@sol.localdomain>
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 18, 2020 at 01:10:57PM -0800, Megha Dey wrote:
> Optimize crypto algorithms using VPCLMULQDQ and VAES AVX512 instructions
> (first implemented on Intel's Icelake client and Xeon CPUs).
> 
> These algorithms take advantage of the AVX512 registers to keep the CPU
> busy and increase memory bandwidth utilization. They provide substantial
> (2-10x) improvements over existing crypto algorithms when update data size
> is greater than 128 bytes and do not have any significant impact when used
> on small amounts of data.
> 
> However, these algorithms may also incur a frequency penalty and cause
> collateral damage to other workloads running on the same core(co-scheduled
> threads). These frequency drops are also known as bin drops where 1 bin
> drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bin
> drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200Mhz)
> are observed on the Icelake server.
> 

Do these new algorithms all pass the self-tests, including the fuzz tests that
are enabled when CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?

- Eric
