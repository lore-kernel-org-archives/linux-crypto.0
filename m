Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909B1C47437
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 01:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6AC5F23770
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Dec 2020 01:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405873AbgLKOSR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:18:17 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:13927 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392467AbgLKORr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 09:17:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1607696095;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:From:
        Subject:Sender;
        bh=BeWQGq5OH45QSmctQUr/hmfG243Im2dTgq5QSkZowP4=;
        b=rQphjxf9Kci7gq2g6WL9AW3VEk8Ldj3eIvZkjHZ5BxKatBo9kCwmmc4XgSLnaKwCst
        ocj/9wK9L0HfcOtBkwKAB/RozERKajPO/L63k1LZRkEdNRV1ls4uNon0/I70kxF2iQ7A
        dNX+EJdcnb7P3RLpQrI++oZS/Lc9Uxv+M09SKn30HjnGSYQomxzqSBzgkB4Hol7Kjqr/
        VSO4olqeUpOx/qeoK/VsCz9pp1JBvp7eVYT1fgYraMhahsITYv2GJkQ0aIydEzdf9cBd
        as+MA8/dE3aSQ8hqQf8kSXsZPDRAOJmYvVhhraYtMUo2A88P1kV/GSLbN73G2v7KqPl+
        gZ7g==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHev6G4xuq1eJ0Y="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.7.1 DYNA|AUTH)
        with ESMTPSA id L0a6acwBBEEX0rx
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 11 Dec 2020 15:14:33 +0100 (CET)
Message-ID: <00235d6da9beddd365217aeb8add986c615762bc.camel@chronox.de>
Subject: Re: [PATCH v4 5/5] crypto: hisilicon/hpre - add 'CURVE25519'
 algorithm
From:   Stephan Mueller <smueller@chronox.de>
To:     Meng Yu <yumeng18@huawei.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, xuzaibo@huawei.com,
        wangzhou1@hisilicon.com, linux-kernel@vger.kernel.org
Date:   Fri, 11 Dec 2020 15:14:33 +0100
In-Reply-To: <1607668234-46130-6-git-send-email-yumeng18@huawei.com>
References: <1607668234-46130-1-git-send-email-yumeng18@huawei.com>
         <1607668234-46130-6-git-send-email-yumeng18@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, den 11.12.2020, 14:30 +0800 schrieb Meng Yu:
>   
> +/* curve25519 */
> +static u64 curve25519_g_x[] = { 0x0000000000000009, 0x0000000000000000,
> +                               0x0000000000000000, 0x0000000000000000 };
> +static u64 curve25519_p[] = { 0xffffffffffffffed, 0xffffffffffffffff,
> +                               0xffffffffffffffff, 0x7fffffffffffffff };
> +static u64 curve25519_a[] = { 0x000000000001DB41, 0x0000000000000000,
> +                               0x0000000000000000, 0x0000000000000000 };
> +static const struct ecc_curve ecc_25519 = {
> +       .name = "curve25519",
> +       .g = {
> +               .x = curve25519_g_x,
> +               .ndigits = 4,
> +       },
> +       .p = curve25519_p,
> +       .a = curve25519_a,
> +};

With this definition, I am not sure whether ecc_is_pubkey_valid_partial would
work correctly. At least it *seems* that there would be a NULL-pointer
dereference in vli_add with the undefined .b value. Did you test and can you
confirm?

Thanks
Stephan


