Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4BE9C43616
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9754C613D6
	for <linux-crypto@archiver.kernel.org>; Wed, 12 May 2021 21:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbhELVIF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 May 2021 17:08:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377829AbhELTJH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 May 2021 15:09:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D76D613B6;
        Wed, 12 May 2021 19:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620846478;
        bh=9tzq3KareNXLPsUGQDHhUWecJWu+s31dttPCApTFklo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BlS2TabeEJDSG+mszE/kwo8vfZGyM6POZm8ZxPY7oz47X+oganSAQ5Rr8AaT63AJJ
         PRYtICFvRoY0wE/BZFpEekEm3FwmhWrrbzG554uIkYJMKFtuK0pKrnqcAuzyAWUN1e
         UNQZFIkcFMcAsWz2xBNmWSichRVi4t8bNxS3Jr9jzro8nOT3WehP4yguYEuTGqr1DG
         58zN8Il2H97LcUV482asvUiFDR/Lw/vaPoG78gl9SepXC2XHIkUvGDcRh8ORO+fcgl
         ZPgPnvb2cwS/ALc2mtf7wSB/H+GnU/9foUDmwHF8if/jnx3WO+73vT6xEQHtzlY+07
         6BkLTD8eIJKKA==
Date:   Wed, 12 May 2021 12:07:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Hongbo Li <herbert.tencent@gmail.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, dhowells@redhat.com,
        jarkko@kernel.org, tianjia.zhang@linux.alibaba.com,
        herberthbli@tencent.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] lib/mpi: use kcalloc in mpi_resize
Message-ID: <YJwnjMQcdKD3Fn25@gmail.com>
References: <1620828254-25545-1-git-send-email-herbert.tencent@gmail.com>
 <1620828254-25545-3-git-send-email-herbert.tencent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1620828254-25545-3-git-send-email-herbert.tencent@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 12, 2021 at 10:04:09PM +0800, Hongbo Li wrote:
> From: Hongbo Li <herberthbli@tencent.com>
> 
> We should set the additional space to 0 in mpi_resize().
> So use kcalloc() instead of kmalloc_array().
> 
> Signed-off-by: Hongbo Li <herberthbli@tencent.com>

Is this fixing something, and if so what?

- Eric
