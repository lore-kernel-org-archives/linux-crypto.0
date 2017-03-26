From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 6/7] crypto: aes - split off shared AES tables and key
 expansion routines
Date: Sun, 26 Mar 2017 15:50:35 -0400 (EDT)
Message-ID: <alpine.LFD.2.20.1703261542360.2304@knanqh.ubzr>
References: <1490554148-10953-1-git-send-email-ard.biesheuvel@linaro.org> <1490554148-10953-7-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        ebiggers3@gmail.com
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:38879 "EHLO
        mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbdCZTui (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 26 Mar 2017 15:50:38 -0400
Received: by mail-it0-f44.google.com with SMTP id y18so33296654itc.1
        for <linux-crypto@vger.kernel.org>; Sun, 26 Mar 2017 12:50:37 -0700 (PDT)
In-Reply-To: <1490554148-10953-7-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 26 Mar 2017, Ard Biesheuvel wrote:

> [...]
> +static const u32 rco_tab[10] = { 1, 2, 4, 8, 16, 32, 64, 128, 27, 54 };

You could consider using u8 for this table. This is a tiny space saving 
and normally it shouldn't make the runtime any slower on most 
architectures.


Nicolas
