Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FC6ECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 16 Sep 2022 11:01:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiIPLB6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 16 Sep 2022 07:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232041AbiIPLBY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Sep 2022 07:01:24 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E35DABD52
        for <linux-crypto@vger.kernel.org>; Fri, 16 Sep 2022 03:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=sBnxnXLeNFOE4b7P2iyYGQ99QyOJH5VtMOnyzeAT2/g=; b=bycNPdrv9Kipm5QaX0zobgjqzb
        sxFyWysz07NXuMrjVhu5++UxsKlrsUYltfi4H85hyUeXq9asBYIsfHamnAY0nvThjNfZR+3fivTtn
        em9BaVRxdTEMgkBVvkelg98N0wk/hXeJrafUOnxE4s8iMeuwu5P242JZRQ8yhtyX+BvMHFTZxj/1J
        nwET1Sj/yH3aBIuVXlWd03zEe313ssOHDMLVuqZQIYfCHRQNgIlcgQIsVyGNWxzPXy/7dcRWdbCnL
        oIeoqSsUIgkxbb8oEdFG5KhTi2pQbcHLuakGEGfrMf5HD3ZW8fHVaRrnqRq/6Wz/75tuBI05059Ur
        nGT7ETng==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oZ8xj-0027UQ-9B; Fri, 16 Sep 2022 10:52:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B716B30013F;
        Fri, 16 Sep 2022 12:52:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6DE532BAB86FD; Fri, 16 Sep 2022 12:52:41 +0200 (CEST)
Date:   Fri, 16 Sep 2022 12:52:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, jussi.kivilinna@iki.fi, elliott@hpe.com
Subject: Re: [PATCH v3 2/3] crypto: aria-avx: add AES-NI/AVX/x86_64/GFNI
 assembler implementation of aria cipher
Message-ID: <YyRVeS5h2GxZn04g@hirez.programming.kicks-ass.net>
References: <20220905094503.25651-1-ap420073@gmail.com>
 <20220905094503.25651-3-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905094503.25651-3-ap420073@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 05, 2022 at 09:45:02AM +0000, Taehee Yoo wrote:

> +.align 8
> +SYM_FUNC_START_LOCAL(__aria_aesni_avx_crypt_16way)

  https://lkml.kernel.org/r/20220915111144.248229966@infradead.org

Please remove all these random .align statements (for text).

