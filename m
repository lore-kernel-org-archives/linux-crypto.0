Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52089C4360C
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 03:12:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26F272084D
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 03:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571022747;
	bh=MHmXU7Z+CCRowV2JYFNfdnZaYrqxM0CDEvfMrWGpSec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=FxR8BOd3d/gUI1oJybaF0cI5NANn0EcCYs2lv3Yz2E/AQpUn9f+nhWxvLk2QRmP1a
	 pPPHH4QcmwSK0JpT2aVakHHORv7yaqqvxWhLawZvJrejiEFhGa/Y5rLgB9daSJUJjw
	 GtMX6y8YXBYcD4DQOBjJKJTRepuU/GVIh7DAR4j8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729706AbfJNDM0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 23:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729621AbfJNDMZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 23:12:25 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 78AEA2083B;
        Mon, 14 Oct 2019 03:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571022744;
        bh=MHmXU7Z+CCRowV2JYFNfdnZaYrqxM0CDEvfMrWGpSec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KZcbrxYQJxAI9iNIzB9VFNHRaP4dgyguSWSEb/hXNQlgr85xpIzlLtRbeOt/mKNd0
         g0GJOfos5GoMufW7arCNXDvxAwsc8mnsRZrqf4FEg7JuZiIryojfIu8hXGPicRCSn3
         qR2grlTasyXXmRypHa1AryG7ahnCyokLYEqFpwLg=
Date:   Sun, 13 Oct 2019 20:12:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jamie Heilman <jamie@audible.transient.net>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes - convert to skcipher API
Message-ID: <20191014031222.GC10007@sol.localdomain>
Mail-Followup-To: Jamie Heilman <jamie@audible.transient.net>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <20191013041741.265150-1-ebiggers@kernel.org>
 <20191013232050.GA3266@audible.transient.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013232050.GA3266@audible.transient.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Oct 13, 2019 at 11:20:51PM +0000, Jamie Heilman wrote:
> Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Convert the VIA PadLock implementations of AES-ECB and AES-CBC from the
> > deprecated "blkcipher" API to the "skcipher" API.  This is needed in
> > order for the blkcipher API to be removed.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > 
> > This is compile-tested only, as I don't have this hardware.
> > If anyone has this hardware, please test it with
> > CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.
> 
> Well I gave it a spin on my Esther system against 5.3.6 but results
> were somewhat obscured by the fact I seem to have other problems with
> modern kernels (I'd been running Greg's 4.19 series on this system
> which doesn't have the extra tests you wanted) on this hardware to the
> tune of (from an unpatched 5.3.6):
> 
>  Loading compiled-in X.509 certificates
>  ------------[ cut here ]------------
>  WARNING: CPU: 0 PID: 1 at crypto/rsa-pkcs1pad.c:539 pkcs1pad_verify+0x2d/0xf4
>  Modules linked in:
>  CPU: 0 PID: 1 Comm: swapper Tainted: G                T 5.3.6 #2
>  Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080014  06/01/2009
>  EIP: pkcs1pad_verify+0x2d/0xf4
>  Code: 57 56 53 89 c3 83 7b 1c 00 74 0e 68 c8 7a 46 c1 e8 48 43 ec ff 0f 0b eb 13 8b 53 24 85 d2 75 17 68 c8 7a 46 c1 e8 33 43 ec ff <0f> 0b 59 b8 ea ff ff ff e9 b2 00 00 00 8b 73 10 b8 ea ff ff ff 8b
>  EAX: 00000024 EBX: f124a3c0 ECX: 00000100 EDX: c14fab54
>  ESI: 00000000 EDI: f124a3c0 EBP: f106bd58 ESP: f106bd48
>  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068 EFLAGS: 00010246
>  CR0: 80050033 CR2: 00000000 CR3: 0158c000 CR4: 000006b0
>  Call Trace:
>   public_key_verify_signature+0x1ff/0x26b
>   x509_check_for_self_signed+0x9f/0xb8
>   x509_cert_parse+0x149/0x179
>   x509_key_preparse+0x1a/0x16d
>   ? __down_read+0x26/0x29
>   asymmetric_key_preparse+0x35/0x56
>   key_create_or_update+0x121/0x330
>   load_system_certificate_list+0x77/0xc5
>   ? system_trusted_keyring_init+0x4f/0x4f
>   do_one_initcall+0x7b/0x158
>   kernel_init_freeable+0xd7/0x156
>   ? rest_init+0x6d/0x6d
>   kernel_init+0x8/0xd0
>   ret_from_fork+0x33/0x40
>  ---[ end trace 1ec5d41c10bd49a3 ]---
>  Problem loading in-kernel X.509 certificate (-22)
> 
> That said, I get this issue with or without your patch, so I assume
> it's unrelated, and probably something with c7381b01287240ab that
> introduced that WARN_ON.  Anyways, I'll have to run a real bisection
> on that when I have the time.

Yes, that's something unrelated.  It looks to be a bug caused by recent changes
to the asymmetric keys subsystem, triggered by not having some hash algorithm
built into the kernel (probably SHA-256).  I recommend starting a new thread for
that with:

	David Howells <dhowells@redhat.com>
	Vitaly Chikunov <vt@altlinux.org>
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
	keyrings@vger.kernel.org
	linux-crypto@vger.kernel.org

> 
> I built a patched 5.3.6 with none of the crypto bits modularized and
> you can find that dmesg and config at:
> 
> http://audible.transient.net/~jamie/k/skcipher.config-5.3.6
> http://audible.transient.net/~jamie/k/skcipher.dmesg
> 

Great, I don't see any test failures in the log.  Just to double check, you had
applied both Ard's patch and this one, right?:

	crypto: geode-aes - switch to skcipher for cbc(aes) fallback
	crypto: geode-aes - convert to skcipher API and make thread-safe

- Eric
