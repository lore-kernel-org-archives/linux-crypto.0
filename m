Return-Path: <SRS0=TLUI=DM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7290CC4363A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 008262068D
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Oct 2020 06:40:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Q6sQmNeX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgJEGke (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Oct 2020 02:40:34 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:14262 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgJEGke (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Oct 2020 02:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1601880032;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=BfPJTkHJ25aT4xHJTt8bqUqo6Mmt7owb63RplAlMbz0=;
        b=Q6sQmNeXAk8G1J0FDlQF03ZyjoIjvoEBOM2MmK7wCRScluNxjE3U3K51hIeJeRpWG8
        6XtikIQfxeBi54qMX8FZYKVXwHTFSHNr3GtyXDKP1TBYQ+dqsKu+2KsySLFLu3GaAf/O
        ErCic+mJhUYhKXuONdcekE3tm7j03Qz/VBvh40fEyPkmdVGbGINSWUV2NkucMaPD8MFQ
        7IzgxIMTj0MmpnQWSys3LEsJCogQjxRCJlCOkZRCXgBHh0FXFHo0Iiyc8pQP3D62LpDZ
        6Lbf3e/12TmQuFSpc5Vm2YhNx+aQWKRkzFjNJDI5jcSeDnEqKMRN6frzPcQGLmv4DAGI
        ZBZw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x2wdNs6neUFoh7cs3k0="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.2.1 AUTH)
        with ESMTPSA id C0b627w956eQB0K
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 5 Oct 2020 08:40:26 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Christoph Hellwig <hch@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Palmer Dabbelt <palmerdabbelt@google.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        Android Kernel Team <kernel-team@android.com>,
        kernel test robot <lkp@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: jitterentropy - bind statically into kernel
Date:   Mon, 05 Oct 2020 08:40:25 +0200
Message-ID: <2588700.mWSkj6HvKX@tauon.chronox.de>
In-Reply-To: <CAMj1kXFC=6G1pqFAcjASrKJfzguO3k9Rv-7NsmTaX8qNre5TGw@mail.gmail.com>
References: <20200930065617.934638-1-palmerdabbelt@google.com> <20201005061918.GB1856@infradead.org> <CAMj1kXFC=6G1pqFAcjASrKJfzguO3k9Rv-7NsmTaX8qNre5TGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 5. Oktober 2020, 08:24:46 CEST schrieb Ard Biesheuvel:

Hi Ard,

> If jitterentropy is a special case, we could put a alternate
> non-'static inline' version of random_get_entropy() in the core
> kernel, and only export it if JITTER_ENTROPY is built as a module in
> the first place. But I'd prefer it if jitterentropy switches to an API
> that is suitable for driver consumption.

Which API do you have in mind? In user space, I use 
clock_gettime(CLOCK_REALTIME) which also considers the clock source.

Thanks
Stephan


