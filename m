Return-Path: <SRS0=mRc+=YG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D98C4360C
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 23:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9104E2067B
	for <linux-crypto@archiver.kernel.org>; Sun, 13 Oct 2019 23:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728946AbfJMX2O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Oct 2019 19:28:14 -0400
Received: from audible.transient.net ([24.143.126.66]:56456 "HELO
        audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728782AbfJMX2O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Oct 2019 19:28:14 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Oct 2019 19:28:14 EDT
Received: (qmail 2909 invoked from network); 13 Oct 2019 23:20:51 -0000
Received: from cucamonga.audible.transient.net (192.168.2.5)
  by canarsie.audible.transient.net with QMQP; 13 Oct 2019 23:20:51 -0000
Received: (nullmailer pid 2705 invoked by uid 1000);
        Sun, 13 Oct 2019 23:20:51 -0000
Date:   Sun, 13 Oct 2019 23:20:51 +0000
From:   Jamie Heilman <jamie@audible.transient.net>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes - convert to skcipher API
Message-ID: <20191013232050.GA3266@audible.transient.net>
References: <20191013041741.265150-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191013041741.265150-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Convert the VIA PadLock implementations of AES-ECB and AES-CBC from the
> deprecated "blkcipher" API to the "skcipher" API.  This is needed in
> order for the blkcipher API to be removed.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This is compile-tested only, as I don't have this hardware.
> If anyone has this hardware, please test it with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y.

Well I gave it a spin on my Esther system against 5.3.6 but results
were somewhat obscured by the fact I seem to have other problems with
modern kernels (I'd been running Greg's 4.19 series on this system
which doesn't have the extra tests you wanted) on this hardware to the
tune of (from an unpatched 5.3.6):

 Loading compiled-in X.509 certificates
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 1 at crypto/rsa-pkcs1pad.c:539 pkcs1pad_verify+0x2d/0xf4
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper Tainted: G                T 5.3.6 #2
 Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS 080014  06/01/2009
 EIP: pkcs1pad_verify+0x2d/0xf4
 Code: 57 56 53 89 c3 83 7b 1c 00 74 0e 68 c8 7a 46 c1 e8 48 43 ec ff 0f 0b eb 13 8b 53 24 85 d2 75 17 68 c8 7a 46 c1 e8 33 43 ec ff <0f> 0b 59 b8 ea ff ff ff e9 b2 00 00 00 8b 73 10 b8 ea ff ff ff 8b
 EAX: 00000024 EBX: f124a3c0 ECX: 00000100 EDX: c14fab54
 ESI: 00000000 EDI: f124a3c0 EBP: f106bd58 ESP: f106bd48
 DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068 EFLAGS: 00010246
 CR0: 80050033 CR2: 00000000 CR3: 0158c000 CR4: 000006b0
 Call Trace:
  public_key_verify_signature+0x1ff/0x26b
  x509_check_for_self_signed+0x9f/0xb8
  x509_cert_parse+0x149/0x179
  x509_key_preparse+0x1a/0x16d
  ? __down_read+0x26/0x29
  asymmetric_key_preparse+0x35/0x56
  key_create_or_update+0x121/0x330
  load_system_certificate_list+0x77/0xc5
  ? system_trusted_keyring_init+0x4f/0x4f
  do_one_initcall+0x7b/0x158
  kernel_init_freeable+0xd7/0x156
  ? rest_init+0x6d/0x6d
  kernel_init+0x8/0xd0
  ret_from_fork+0x33/0x40
 ---[ end trace 1ec5d41c10bd49a3 ]---
 Problem loading in-kernel X.509 certificate (-22)

That said, I get this issue with or without your patch, so I assume
it's unrelated, and probably something with c7381b01287240ab that
introduced that WARN_ON.  Anyways, I'll have to run a real bisection
on that when I have the time.

I built a patched 5.3.6 with none of the crypto bits modularized and
you can find that dmesg and config at:

http://audible.transient.net/~jamie/k/skcipher.config-5.3.6
http://audible.transient.net/~jamie/k/skcipher.dmesg

Hope that helps.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
