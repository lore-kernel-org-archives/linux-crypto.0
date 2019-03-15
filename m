Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92207C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 09:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6803F21872
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 09:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbfCOJnL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 05:43:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:56024 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726886AbfCOJnL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 05:43:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6B674AE17;
        Fri, 15 Mar 2019 09:43:10 +0000 (UTC)
Date:   Fri, 15 Mar 2019 10:43:08 +0100
From:   Petr Vorel <pvorel@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     ltp@lists.linux.it, linux-crypto@vger.kernel.org
Subject: Re: [LTP] [PATCH 2/6] crypto/af_alg01: new regression test for hmac
 nesting bug
Message-ID: <20190315094308.GC4990@dell5510>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20190221053026.18489-1-ebiggers@kernel.org>
 <20190221053026.18489-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221053026.18489-3-ebiggers@kernel.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric,

> +static void run(void)
> +{
> +	/* try several different unkeyed hash algorithms */
> +	static const char * const hash_algs[] = {
> +		"md5", "md5-generic",
> +		"sha1", "sha1-generic",
> +		"sha224", "sha224-generic",
> +		"sha256", "sha256-generic",
> +		"sha3-256", "sha3-256-generic",
> +		"sha3-512", "sha3-512-generic",
> +	};
> +	size_t i;
FYI: We usually use struct tcase with .tcnt = ARRAY_SIZE(tcases)
instead of for loop, but it's only a minor detail.

> +
> +	for (i = 0; i < ARRAY_SIZE(hash_algs); i++)
> +		test_with_hash_alg(hash_algs[i]);
> +}
> +
> +static struct tst_test test = {
> +	.test_all = run,
> +};


Kind regards,
Petr
