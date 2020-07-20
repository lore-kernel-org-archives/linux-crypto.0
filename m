Return-Path: <SRS0=2iMm=A7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF054C433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 17:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B673A20702
	for <linux-crypto@archiver.kernel.org>; Mon, 20 Jul 2020 17:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="pzniIhTw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730298AbgGTRmv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 Jul 2020 13:42:51 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.83]:32068 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729786AbgGTRmu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Jul 2020 13:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1595266969;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ZZkjsjjG5xVVGmOSvaZulXwonBdu0/RYzHnYnFpsr/E=;
        b=pzniIhTw2b8GU7N+Bzb5PtKIjZ1HYOHpmJrT7dLSSGcH9ZgqSzJQtYALbqOi67BIfs
        hXcHabROOR2X7W3Y0Adr04Diosy/OOykVZLJXzigXeCYI5ZGwU4XWEYaNNzsWt3MSrIq
        ajqxrr2D0DLz2Jfxi8jcODvGm1b6QflVPT+xTkfXOni5wDnYYtZVwqCv/0J7QNSPj6tO
        QhIdD5dZsWsdzysJIosUA1mvLGo74lTfQSXkklrxkSHHydoEJ2pVYIMPhyllfX9KtSAZ
        3KA3J5EkXzu8/IvgVgTWRbWs4w/yUaJ82YSa3l8mueebxFPK54qglH2KQgIQKUhzDyRh
        G8Vw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJPScHiDh"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6KHgjUPj
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 20 Jul 2020 19:42:45 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, Elena Petrova <lenaptr@google.com>
Cc:     Elena Petrova <lenaptr@google.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] crypto: af_alg - add extra parameters for DRBG interface
Date:   Mon, 20 Jul 2020 19:42:44 +0200
Message-ID: <20725987.EfDdHjke4D@positron.chronox.de>
In-Reply-To: <20200716164028.1805047-1-lenaptr@google.com>
References: <CABvBcwY44BPa+TaDwxWaEogpg3Kdkq8o9cR5gSqNGF-o6d3jrw@mail.gmail.com> <20200716164028.1805047-1-lenaptr@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Donnerstag, 16. Juli 2020, 18:40:28 CEST schrieb Elena Petrova:

Hi Elena,

> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 56527c85d122..312fdb3469cf 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -46,6 +46,7 @@ struct af_alg_type {
>  	void *(*bind)(const char *name, u32 type, u32 mask);
>  	void (*release)(void *private);
>  	int (*setkey)(void *private, const u8 *key, unsigned int keylen);
> +	int (*setentropy)(void *private, const u8 *entropy, unsigned int len);
>  	int (*accept)(void *private, struct sock *sk);
>  	int (*accept_nokey)(void *private, struct sock *sk);
>  	int (*setauthsize)(void *private, unsigned int authsize);
> @@ -123,7 +124,7 @@ struct af_alg_async_req {
>   * @tsgl_list:		Link to TX SGL
>   * @iv:			IV for cipher operation
>   * @aead_assoclen:	Length of AAD for AEAD cipher operations
> - * @completion:		Work queue for synchronous operation
> + * @wait:		Wait on completion of async crypto ops

What is this change about? I am not sure it relates to the changes above.

>   * @used:		TX bytes sent to kernel. This variable is used to
>   *			ensure that user space cannot cause the kernel
>   *			to allocate too much memory in sendmsg operation.
> diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h


Ciao
Stephan


