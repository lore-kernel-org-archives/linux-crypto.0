Return-Path: <SRS0=5F7Z=YA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3D7C4740A
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 09:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 345042133F
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Oct 2019 09:02:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="TvdiuuCb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfJGJC0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Oct 2019 05:02:26 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.53]:10957 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727262AbfJGJC0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Oct 2019 05:02:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1570438944;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=bXlqJ63e6LUpN8n6tn96qpQIMttI/LHCSLhxx+auGzE=;
        b=TvdiuuCbNeRCjxXEdE7Iz7qwSkGhiun7mmwvbgfBZJ9E4VTq858X2ACxYyEG4OzHun
        UUdf1nYD6ujDYxKOs4S7tSU4L7vRxvQ3S3YxIUuYB9QNakuYgLjKSftIKSQYpR9ZBkn1
        hbuSFSJzpljF+DgarZShjRyXi4J0cwBKvpsL0QvhnQIYxXk8ZNE4Tgg3IV1t/o+DmytP
        idR/4USLNpUz7X7AcysCpvPN/Gy1HmSpNYua2OvVQHJf9WC9YFf03V/NR/pYxpZFdy/z
        rnxmpfM35+NBEmwm//eH+6QbGsZEP+uDJNjIx4rPaYh0uVKonJAfgu9AyEg+nbOWoEW9
        QrhQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/SfP6I9"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.28.0 DYNA|AUTH)
        with ESMTPSA id I003a5v978xJybi
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 7 Oct 2019 10:59:19 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH 5.4 regression fix] x86/boot: Provide memzero_explicit
Date:   Mon, 07 Oct 2019 10:59:19 +0200
Message-ID: <65461301.CAtk0GNLiE@tauon.chronox.de>
In-Reply-To: <20191007085501.23202-1-hdegoede@redhat.com>
References: <20191007085501.23202-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 7. Oktober 2019, 10:55:01 CEST schrieb Hans de Goede:

Hi Hans,

> The purgatory code now uses the shared lib/crypto/sha256.c sha256
> implementation. This needs memzero_explicit, implement this.
> 
> Reported-by: Arvind Sankar <nivedita@alum.mit.edu>
> Fixes: 906a4bb97f5d ("crypto: sha256 - Use get/put_unaligned_be32 to get
> input, memzero_explicit") Signed-off-by: Hans de Goede
> <hdegoede@redhat.com>
> ---
>  arch/x86/boot/compressed/string.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/boot/compressed/string.c
> b/arch/x86/boot/compressed/string.c index 81fc1eaa3229..511332e279fe 100644
> --- a/arch/x86/boot/compressed/string.c
> +++ b/arch/x86/boot/compressed/string.c
> @@ -50,6 +50,11 @@ void *memset(void *s, int c, size_t n)
>  	return s;
>  }
> 
> +void memzero_explicit(void *s, size_t count)
> +{
> +	memset(s, 0, count);

May I ask how it is guaranteed that this memset is not optimized out by the 
compiler, e.g. for stack variables?
> +}
> +
>  void *memmove(void *dest, const void *src, size_t n)
>  {
>  	unsigned char *d = dest;



Ciao
Stephan


