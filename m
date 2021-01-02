Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC07C433DB
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 21:13:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 542F720799
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Jan 2021 21:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbhABVNI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Jan 2021 16:13:08 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:37102 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726667AbhABVNH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Jan 2021 16:13:07 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kvoBs-0008W2-On; Sun, 03 Jan 2021 08:12:01 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 03 Jan 2021 08:12:00 +1100
Date:   Sun, 3 Jan 2021 08:12:00 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
Cc:     davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        TimGuo-oc@zhaoxin.com, CooperYan@zhaoxin.com,
        QiyuanWang@zhaoxin.com, HerryYang@zhaoxin.com,
        CobeChen@zhaoxin.com, SilviaZhao@zhaoxin.com
Subject: Re: [PATCH] crypto: x86/crc32c-intel - Don't match some Zhaoxin CPUs
Message-ID: <20210102211200.GA1750@gondor.apana.org.au>
References: <1608028091-29439-1-git-send-email-TonyWWang-oc@zhaoxin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608028091-29439-1-git-send-email-TonyWWang-oc@zhaoxin.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 15, 2020 at 06:28:11PM +0800, Tony W Wang-oc wrote:
> The driver crc32c-intel match CPUs supporting X86_FEATURE_XMM4_2.
> On platforms with Zhaoxin CPUs supporting this X86 feature, when
> crc32c-intel and crc32c-generic are both registered, system will
> use crc32c-intel because its .cra_priority is greater than
> crc32c-generic.
> 
> When doing lmbench3 Create and Delete file test on partitions with
> ext4 enabling metadata checksum, found using crc32c-generic driver
> could get about 20% performance gain than using the driver crc32c-intel
> on some Zhaoxin CPUs.
> 
> This case expect to use crc32c-generic driver for these Zhaoxin CPUs
> to get performance gain, so remove these Zhaoxin CPUs support from
> crc32c-intel.
> 
> Signed-off-by: Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>
> ---
>  arch/x86/crypto/crc32c-intel_glue.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)

This does not seem to address the latest comment from hpa.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
