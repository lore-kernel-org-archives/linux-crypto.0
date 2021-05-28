Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE2BCC4708C
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 06:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7CB0613D1
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 06:07:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbhE1GJ2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 02:09:28 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:18183 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235005AbhE1GJ1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 02:09:27 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622181888; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=FhUn1Q58cZq49c79zFXau2b9FqHoMJswXwm4iJuvrqiD3dIYc9RE2K7lgQACUzoEso
    QHFw6tbucoZvCghjSEO+FbhW3hOP9AS0hYYZuv1OTqYKbiNlMm2KnGS3XglteIO0T95r
    NfH35YxjBTbrobv9zPDNon3qjB42ujjAHd/Q91rlShHPFJw2C9hVy5fO/I1tHfKJvs1Z
    Ry7JFQFkn3PlEXywj1W7B2cS0HKz2uMKt+PMedD91yEnz2GQn56vOHIqt5H+IimgZfB0
    AnD/k1izM2SjAfST1cGXeBifbSvshFBDNF1Rzg1W1WnDVrRjwOX6iHDXNNlrQMJIQ7rO
    oAQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1622181888;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=gWmFG7oG6qtY2QVKiNxgiaFmpIb8N+W6XlWAARy8VDA=;
    b=KcQhzp0cRjQZx5T9dy/EkyklQyVcLpy0n1HFrFDuU/FUrJqj/mrhw8WlBK/wtebjwi
    /431+PBaVO02PfNOoYs3NmcdmkKSFPr4shYOCzBFmLuBgE3Y3fpwgxhGg+fWLNTReet7
    pBq835XL6piul826fTzQrLbfYH4CZYm9eb/g5JsrNXjBSVvVTteVcij/ZcP2NKbeceKe
    t5RxRNlbd0K/GEnVcXtB+uelkq8sPM4Bb17XMb3YgfNBJtYR2bXh5wYewj8RqIJbXjbO
    6MNixhaEx0a8DzpN/RbGkxqnpAlQTPiewsmIky5uj8br4tG9Ynlx1wj+cqAbB1W5WjxI
    11PQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1622181888;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=gWmFG7oG6qtY2QVKiNxgiaFmpIb8N+W6XlWAARy8VDA=;
    b=D7fDBv52YIiOAxeBqHa48208C5P0ldtBuBlCoUvk0nFuszzoE4dLE+Br4QNYRoyPrE
    BjeX7bg+lowICtpjpFD/d+okZq6159L9wIZhPaN8SlQdkVftkvXOwr19TfNaDfFdzqrx
    0vk+kpOd2rlsG+OYDg5q7F4STBy0LieljS5IpWfxpWYzaFO1QiIx1f43PnsNjNBX33Df
    7C8VHCW6SwQuqEriBOhIGjaoe5xsQI4mWWMQHmBqA+/CnXNNSixrVLu7kWZk2FDlwJX0
    f5scbJGa2ltofbqB9MsnikMn/2jXrjn7zlEe3t8Ii8HurYQSj0/t5nDWXkXaWSfpzUT/
    WRdw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIfScuAh3"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.26.3 DYNA|AUTH)
    with ESMTPSA id R0123ax4S64k2Ou
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 28 May 2021 08:04:46 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, Willy Tarreau <w@1wt.eu>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>
Subject: Re: [PATCH v40 01/13] Linux Random Number Generator
Date:   Fri, 28 May 2021 08:04:45 +0200
Message-ID: <2921350.VP03N2d09h@positron.chronox.de>
In-Reply-To: <202105280808.AgyBCLBL-lkp@intel.com>
References: <2939683.iCPfFBJNGb@positron.chronox.de> <202105280808.AgyBCLBL-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 28. Mai 2021, 02:41:09 CEST schrieb kernel test robot:

Hi,

> All errors (new ones prefixed by >>):
> >> drivers/char/lrng/lrng_chacha20.c:32:8: error: structure variable
> >> 'chacha20' with 'latent_entropy' attribute has a non-integer field
> >> 'block'
>       32 | struct chacha20_state chacha20 __latent_entropy;
> 
>          |        ^~~~~~~~~~~~~~

Thanks for the notification.

I think this is a false-positive discussed before. __latent_entropy is 
seemingly allowed for an entire linear buffer as seen in the declaration of 
the variable input_pool_data in driver/char/random.c which is an array of u32.

The struct chacha20_state is a linear buffer of u32 words. 

struct chacha20_block {
        u32 constants[4];
        union {
                u32 u[CHACHA_KEY_SIZE_WORDS];
                u8  b[CHACHA_KEY_SIZE];
        } key;
        u32 counter;
        u32 nonce[3];
};

Therefore it should be identical to the aforementioned example. The 
__latent_entropy marker therefore seems to be appropriate for this structure.

Ciao
Stephan


