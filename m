Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2D46C4360C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B9D61457
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbhELVIF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245050AbhELTNB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 15:13:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10BA461006;
        Wed, 12 May 2021 19:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620846712;
        bh=OYsxcWeekp828YfaCh6Kfwv4L7JFwCxqEclFG+gGImw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Zb8nC3BGHB7KoLaqDOaGd0M4MgbZtU7l5kTlibUSbQFSm1s6psyqjbtYosNJsCs6B
         bUUC5BD85e1dMlyN6iO3/bTS3ADWueizqBewFLX2/PUQZ6UNjVS+40EZbsv/oqhXXb
         6Bc5y3ZyaZrEG9a2IabLtmBsUtbuKLMcZ8Xla3p8KDdRVX2F9GmORBwgL8dousszWP
         WM6X7U0bKsW7RUuObNlTBBlc/VEyaOSSYcPUXsNIh85p5JsolKEKIS+AsLXY6+9xXu
         fyzTITve5J91gt1wd0szCe0OQs7nHZudw7EZifRdmyXihpjcxaPjcSqjLfefUy701O
         v5NMyS2N1plLA==
Date:   Wed, 12 May 2021 12:11:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hongbo Li <herbert.tencent@gmail.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, dhowells@redhat.com,
        jarkko@kernel.org, tianjia.zhang@linux.alibaba.com,
        herberthbli@tencent.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] crypto: add eddsa support for x509
Message-ID: <YJwodhUpsdBbknLo@gmail.com>
References: <1620828254-25545-1-git-send-email-herbert.tencent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620828254-25545-1-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 12, 2021 at 10:04:07PM +0800, Hongbo Li wrote:
> From: Hongbo Li <herberthbli@tencent.com>
> 
> This series of patches add support for x509 cert signed by eddsa,
> which is described in RFC8032 [1], currently ed25519 only.

It would be helpful to explain how this is related to the kernel's existing
Curve25519 support.

- Eric
