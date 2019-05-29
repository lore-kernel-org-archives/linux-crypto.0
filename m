Return-Path: <SRS0=BCrf=T5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61C70C28CC2
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 20:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 381212414B
	for <linux-crypto@archiver.kernel.org>; Wed, 29 May 2019 20:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726547AbfE2UVx convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 May 2019 16:21:53 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:51094 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2UVx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 May 2019 16:21:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 88A716094C2D;
        Wed, 29 May 2019 22:21:51 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 24hfumFRIBin; Wed, 29 May 2019 22:21:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C61C1608F45A;
        Wed, 29 May 2019 22:21:50 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Kr72C4w85Hpw; Wed, 29 May 2019 22:21:50 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 91789608310E;
        Wed, 29 May 2019 22:21:50 +0200 (CEST)
Date:   Wed, 29 May 2019 22:21:50 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     david <david@sigma-star.at>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Message-ID: <1331220190.73461.1559161310462.JavaMail.zimbra@nod.at>
In-Reply-To: <4256916.YlTHG9RRyR@tauon.chronox.de>
References: <729A4150-93A0-456B-B7AB-6D3A446E600E@sigma-star.at> <4256916.YlTHG9RRyR@tauon.chronox.de>
Subject: Re: Can an ahash driver be used through shash API?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.8_GA_3025 (ZimbraWebClient - FF60 (Linux)/8.8.8_GA_1703)
Thread-Topic: Can an ahash driver be used through shash API?
Thread-Index: fv0HWCAwwyF4N+CFCRcqKsO36yU5mA==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Stephan,

----- Ursprüngliche Mail -----
>> I've seen that it does actually work the other way around, since
>> crypto_init_shash_ops_async() in crypto/shash.c takes care of translating
>> calls from ahash to shash and that's how the *-generic drivers are usable
>> through the ahash API.
> 
> The crypto_alloc_shash will only identify cipher implementations that were
> registered with the CRYPTO_ALG_TYPE_SHASH flag. That flag is set when a cipher
> is registered using crypto_register_shash.
> 
> Thus, ciphers registered with crypto_register_ahash will not bear this flag
> and thus will not be found by the allocation function.

is there a reason why we don't emulate the synchronous functionality
in the crypto API layer if a driver implements only the async interface?

Or is it just a matter of -ENOPATCH? :)

Thanks,
//richard
