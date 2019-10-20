Return-Path: <SRS0=dHFS=YN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC50CA9EA9
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Oct 2019 08:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F28C222BD
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Oct 2019 08:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfJTIbd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Oct 2019 04:31:33 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:52135 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJTIbd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Oct 2019 04:31:33 -0400
Received: from d.localdomain (unknown [77.173.248.2])
        (Authenticated sender: out@gert.gr)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 0D938240009;
        Sun, 20 Oct 2019 08:31:26 +0000 (UTC)
From:   Gert Robben <t2@gert.gr>
Subject: Re: [PATCH] crypto: geode-aes - convert to skcipher API and make
 thread-safe
To:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     linux-geode@lists.infradead.org,
        Florian Bezdeka <florian@bezdeka.de>,
        Jelle de Jong <jelledejong@powercraft.nl>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <20191011045132.159422-1-ebiggers@kernel.org>
Message-ID: <2762ac41-dc60-2d6b-ccbd-732e0098822b@gert.gr>
Date:   Sun, 20 Oct 2019 10:31:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011045132.159422-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: nl-NL
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Op 11-10-2019 om 06:51 schreef Eric Biggers:
> From: Eric Biggers <ebiggers@google.com>
> 
> The geode AES driver is heavily broken because it stores per-request
> state in the transform context.  So it will crash or produce the wrong
> result if used by any of the many places in the kernel that issue
> concurrent requests for the same transform object.
> 
> This driver is also implemented using the deprecated blkcipher API,
> which makes it difficult to fix, and puts it among the drivers
> preventing that API from being removed.
> 
> Convert this driver to use the skcipher API, and change it to not store
> per-request state in the transform context.
> 
> Fixes: 9fe757b0cfce ("[PATCH] crypto: Add support for the Geode LX AES hardware")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> NOTE: I don't have the hardware to test this patch.  Anyone who does,
> please check whether it passes CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, and
> whether it still works for anything else you're using it for.

Yes, it seems to work on ALIX 2C2 on Linux 5.4-rc3.
No errors in /proc/crypto and dmesg, including 
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS.
I also tried (among other things) simultaneous openssl + dm-crypt 
benchmarks.
Those reach the higher speeds and give no errors.
Thanks!
Gert
