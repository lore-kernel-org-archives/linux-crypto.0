Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44FF5C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Mar 2022 11:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbiCVLxe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Mar 2022 07:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbiCVLxe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Mar 2022 07:53:34 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C679C8022A;
        Tue, 22 Mar 2022 04:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=ICO8QLdF8rNYnzw8DSMsOxFhYEACv8Kuke0Oxt90GBI=; b=C/jYrxaSH5dLOo1+9mPYvLtNmO
        mCwOPHc8/Xh4DMvHUKT1gPJOA2qhnOsoE2AFgvnd8TIAhMBcTmQSONxEx3SKbvx9STKilU69YNC1U
        hRT8Aw4exgTJxk1p+7Z7sNMi1jV0uY8Tcr6Dh7fUJPsBW8/OswuZztb1KrvMKTVKWJObcBnEC9yDf
        mQZFK+9U9g2OnPYbLJ9vfzOdiXk5wvl1vRTAP1gnkle/tHc8Z+sie6kFdJD6+5jabMS+UXNvb1f3P
        +I5Zl5kJ+bu3WWPMTvoBIo6W5ZrLlDvNE4Kv7ADnpci8u3rfOkCfaWPFfb15633bHx7uZ1TCuu41E
        RTfie4sA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nWd3I-00BYZy-U9; Tue, 22 Mar 2022 11:51:53 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B8DEC3001CD;
        Tue, 22 Mar 2022 12:51:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id A0A582C63BAE1; Tue, 22 Mar 2022 12:51:50 +0100 (CET)
Message-ID: <20220322114809.381992456@infradead.org>
User-Agent: quilt/0.66
Date:   Tue, 22 Mar 2022 12:48:09 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        linux-crypto@vger.kernel.org, ebiggers@google.com,
        herbert@gondor.apana.org.au, Jason@zx2c4.com,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH 0/2] crypto objtool cleanup
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

two small patches that fix objtool reports on x86 crypto asm. The first
(chacha) is independent and could go through the crypto tree if desired. The
second is a fix for a commit that currently still lives in tip/x86/core and
should go there.

