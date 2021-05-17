Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32286C433B4
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 21:34:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10CAD61285
	for <linux-crypto@archiver.kernel.org>; Mon, 17 May 2021 21:34:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245149AbhEQVgB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 17:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232924AbhEQVgB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 17:36:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7484D61263;
        Mon, 17 May 2021 21:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621287284;
        bh=bLqR0ycSJjK3kwjoIQdiqU24f66TkyRBFt3e5ONdI1k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mF+QXjowhpfX8kxSq7lsuRZHrvO0S4RLsR3yre1g2raXdSlYJ7DHAusukBnGuPcSI
         wQdl7vnxYbmpoo42wi2VqtG/l/FbJ3Z9XOGHdZY4G/8ot/1WJsLsW8bI4n3VulC2VK
         m7KtMLqbT7x8jKAp+isWgE10XiLeeTGZLVIuYm3YZt4KLjzUp8L3IV8rSy7ZL4Sz+R
         CC/7pOPtckJrmWa3rOTJQQX7z8RTFp2KE4049uM+BjFGIiBgiVPEJkpmWngDDfabYN
         k7JXKMcUbknnmv/PrNC+WZJW8JclujQZEs5fFIcOBG5/DkUEXii3k2EF7sdU0nahoH
         WKBqHFc8AqHHA==
Date:   Mon, 17 May 2021 14:34:43 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Chang S. Bae" <chang.seok.bae@intel.com>
Cc:     tglx@linutronix.de, mingo@kernel.org, bp@suse.de, luto@kernel.org,
        x86@kernel.org, herbert@gondor.apana.org.au,
        dan.j.williams@intel.com, dave.hansen@intel.com,
        ravi.v.shankar@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 10/11] crypto: x86/aes-kl - Support AES algorithm
 using Key Locker instructions
Message-ID: <YKLhc6HX9+JunQ/X@gmail.com>
References: <20210514201508.27967-1-chang.seok.bae@intel.com>
 <20210514201508.27967-11-chang.seok.bae@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210514201508.27967-11-chang.seok.bae@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 14, 2021 at 01:15:07PM -0700, Chang S. Bae wrote:
> 
> Included are methods for ECB, CBC, CTR, and XTS modes. They are not
> compatible with other implementations as referencing an encrypted form
> only.

Your code uses the standard algorithm names like cbc(aes), which implies that it
is compatible with the standard cbc(aes).  So which is it -- compatible or not
compatible -- and if it isn't compatible, what is the expected use case?

- Eric
