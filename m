Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B632C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 02:04:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 090A02075A
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 02:04:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbhAPCEy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jan 2021 21:04:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbhAPCEx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jan 2021 21:04:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEE172075A;
        Sat, 16 Jan 2021 02:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610762653;
        bh=5dXRYBkL+CiH3zZlZjKfB4oSmzR121Y4SCWkoDT8rag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ekoBFIQ9a8+wl4kZFppT+7D8RTMkOBh+XpIjg2e1p6U2+gNHPvAk+8Sjn0qUYk/24
         rS9RkRbVKN5ue8mXq/ZzxeQmBgJ1RCn4FEI8D+fFw2lKPCzkMFo2E2mQnom7UyuZf8
         iJvIv0Yky0MehqL2bBnAwQIvaZbG76gigk9UctbTY7paEpdQNobrqPXR5erAlamZNb
         PsJTDL5DBJS189sHzP+SxG/r6T1eAlpTK7vtwMBvp6KP4L9+9yvSP1cpbs2D15jK4t
         vWZh0Cto47ZytlDHSlhzVtjv3cMG+DlRlxy+X9yOx3d8IqGtBuIL4dl3vK51Uznwaq
         0vECKaUJI9+Vg==
Date:   Fri, 15 Jan 2021 18:04:11 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     "Dey, Megha" <megha.dey@intel.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, wajdi.k.feghali@intel.com,
        greg.b.tucker@intel.com, robert.a.kasten@intel.com,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, ilya.albrekht@intel.com,
        kyung.min.park@intel.com, Tony Luck <tony.luck@intel.com>,
        ira.weiny@intel.com
Subject: Re: [RFC V1 3/7] crypto: ghash - Optimized GHASH computations
Message-ID: <YAJJmzWm3rPcdxMs@gmail.com>
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <1608325864-4033-4-git-send-email-megha.dey@intel.com>
 <CAMj1kXGhGopfg19at5N_9q89-UA4irSgMULyDXg+dKhnbRrCZQ@mail.gmail.com>
 <dfb5f2e0-027d-2b9c-aec7-313ff0275381@intel.com>
 <83d87dec-dd76-1ddc-1e20-4bf1c7db7918@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83d87dec-dd76-1ddc-1e20-4bf1c7db7918@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 15, 2021 at 04:20:44PM -0800, Dave Hansen wrote:
> On 1/15/21 4:14 PM, Dey, Megha wrote:
> > Also, I do not know of any cores that implement PCLMULQDQ and not AES-NI.
> 
> That's true, bit it's also possible that a hypervisor could enumerate
> support for PCLMULQDQ and not AES-NI.  In general, we've tried to
> implement x86 CPU features independently, even if they never show up in
> a real CPU independently.

We only add optimized implementations of crypto algorithms if they are actually
useful, though.  If they would never be used in practice, that's not useful.

- Eric
