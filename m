Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA15C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 19:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D4D2405B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 19:25:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395333AbgLKRom (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:44:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395330AbgLKRoj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 12:44:39 -0500
Date:   Fri, 11 Dec 2020 09:43:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607708639;
        bh=7nRRic/cUXS9Hr120HkaEBHl46oBlU5a4nWuOWcPCFM=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=MEsY9jZz2eeaM+mnf1yXNs0NqEbEnR/tGlBxqTngG/GgPHKPMN2KGA1wIt0eILUXH
         LJWYJhD4xe8YcXtKtrL+/zHYaAFgHr9pE9ccJtQjBaotXOQKVhoCbN2n8tQQ8uSIhj
         xiecXbJf+DaemV3DdBQR74EYj7fRiyBQ3Pq0lqv59XZG3tjiwVPTd1m8MfPhiS971z
         xC9YAFxmFHFe6g2TmrYLNq38X2wZKnpm0XORAeI6OJDXKZpHbVu7RsYE7RoNwwUfct
         aJXCmwDhgqIEr40Hliycj8/QkthUgjnBY9GicG65BsHMwzJaKLU9GqgKm+Wrg/5ibd
         75JgQIgXoVnOA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, TimGuo-oc@zhaoxin.com,
        CooperYan@zhaoxin.com, QiyuanWang@zhaoxin.com,
        HerryYang@zhaoxin.com, CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
Message-ID: <X9Ov3RWDpUik7gXo@sol.localdomain>
References: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607686144-2604-1-git-send-email-TonyWWang-oc@zhaoxin.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 11, 2020 at 07:29:04PM +0800, Tony W Wang-oc wrote:
> The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
> On platforms with Zhaoxin CPUs supporting this X86 feature, When
> crc32c-intel and crc32c-generic are both registered, system will
> use crc32c-intel because its .cra_priority is greater than
> crc32c-generic. This case expect to use crc32c-generic driver for
> some Zhaoxin CPUs to get performance gain, So remove these Zhaoxin
> CPUs support from crc32c-intel.
> 
> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>

Does this mean that the performance of the crc32c instruction on those CPUs is
actually slower than a regular C implementation?  That's very weird.

- Eric
