Return-Path: <SRS0=zZ2Z=US=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BC4EC43613
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 21:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67381208CA
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Jun 2019 21:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfFSVmi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Jun 2019 17:42:38 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfFSVmi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Jun 2019 17:42:38 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3BB16147E78D9;
        Wed, 19 Jun 2019 14:42:35 -0700 (PDT)
Date:   Wed, 19 Jun 2019 17:42:34 -0400 (EDT)
Message-Id: <20190619.174234.2210089047219514238.davem@davemloft.net>
To:     ard.biesheuvel@linaro.org
Cc:     netdev@vger.kernel.org, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jbaron@akamai.com, cpaasch@apple.com, David.Laight@aculab.com,
        ycheng@google.com
Subject: Re: [PATCH net-next v2 1/1] net: fastopen: robustness and
 endianness fixes for SipHash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619065510.23514-2-ard.biesheuvel@linaro.org>
References: <20190619065510.23514-1-ard.biesheuvel@linaro.org>
        <20190619065510.23514-2-ard.biesheuvel@linaro.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 14:42:36 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 19 Jun 2019 08:55:10 +0200

> +	ctx->key[0] = (siphash_key_t){
> +		get_unaligned_le64(primary_key),
> +		get_unaligned_le64(primary_key + 8)
> +	};

Please just use normal assignment(s), because not only does this warn
it looks not so nice.

Thanks.
