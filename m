Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B3AC31E5B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 18:22:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91F5920863
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 18:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560882177;
	bh=FeFEL4h8WMaZKvRw/ukJJSHxRh2DhieP7uMMhayKQEs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=xtkPDNXGdQtHNaJDQttVgLTqkxxfcfUAp5dd3U6CVlakCfIDd/x/MiWQZh8OufOIU
	 +4J/z5fE6meDoFMv0QTYDZKGOV8mZRZGc/pFwXYlK+ls0AxfeDBn49wirfElx570ll
	 fT5HSO978O1WgkdKrh3OQlXGrw7cTn3J2JO/r0mI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbfFRSW5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 14:22:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbfFRSW4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 14:22:56 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17F762147A;
        Tue, 18 Jun 2019 18:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560882176;
        bh=FeFEL4h8WMaZKvRw/ukJJSHxRh2DhieP7uMMhayKQEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wWOb8juWXxMcvKvP46Cl+rBThjOgQBu+PsMIonWIBchIpX2mpXJ1Ays+Dhf1wWGpl
         ro75YM4TjF9CcYSWt42hbIG1dmiAzh6+rNooITeh8EVTDpa+/FTUZjjHzWfxZU+cbq
         g8pTrXPpK6f+rqd1oS3wSQO88ypf6Rby1YZN4oxU=
Date:   Tue, 18 Jun 2019 11:22:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        herbert@gondor.apana.org.au, edumazet@google.com,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jbaron@akamai.com, cpaasch@apple.com, David.Laight@aculab.com,
        ycheng@google.com
Subject: Re: [PATCH 2/2] net: fastopen: use endianness agnostic
 representation of the cookie
Message-ID: <20190618182253.GK184520@gmail.com>
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
 <20190618093207.13436-3-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618093207.13436-3-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 18, 2019 at 11:32:07AM +0200, Ard Biesheuvel wrote:
> Use an explicit little endian representation of the fastopen
> cookie, so that the value no longer depends on the endianness
> of the system. This fixes a theoretical issue only, since
> fastopen keys are unlikely to be shared across load balancing
> server farms that are mixed in endiannes, but it might pop up
> in validation/selftests as well, so let's just settle on little
> endian across the board.
> 
> Note that this change only affects big endian systems.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  include/linux/tcp.h     |  2 +-
>  net/ipv4/tcp_fastopen.c | 16 ++++++++--------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 

What about the TCP_FASTOPEN_KEY option for setsockopt and getsockopt?  Those
APIs treat the key as an array of bytes (let's say it's little endian), so
doesn't it need to be converted to/from the CPU endianness of siphash_key_t?

- Eric
