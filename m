Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415E0C4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 06:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C50206DD
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 06:55:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="n6u081Jq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgJBGzP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 02:55:15 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:23164 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJBGzP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 02:55:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1601621713;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=dG3VsnJVeZhSi88eTw1lFhyXDWSG0bJwarleuLQpKFA=;
        b=n6u081JqROnb/24iw8fW+sXZ7jMXAfnCR8IGMvpO1+6RW4MDfPlPWyctAwHrPw9TxW
        VIZDn/JYhq4gKh2ODHwwGrQJ5AEt0LClbYshHl5plkoETyWensKVaM44MHHMCInoRNHE
        CVisftjBByjFNAaDifLNF9QqNkXiyn/JCYeO0LSMQHpQrffZx+8EliHs+8dUlMKAu8iD
        YeQHuo9bEQcG9fXEkMxadVq0eUjdUY7PIVO1TNxyt8X9W7oOLDs4sV1iFhpNTuwLK86N
        F9sVw9ymlmMXgnO69+17YtMtScNLEVt20D0oXb8gW78v5lK2W+rpF6JD178UDd+KUjDE
        kq9Q==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x2wdNs6neUFoh7cs3k0="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 47.1.9 AUTH)
        with ESMTPSA id 602bfdw926t79aM
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 2 Oct 2020 08:55:07 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     linux-riscv@lists.infradead.org, kernel-team@android.com,
        kernel test robot <lkp@intel.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: get_cycles from modular code in jitterentropy, was Re: [PATCH] clocksource: clint: Export clint_time_val for modules
Date:   Fri, 02 Oct 2020 08:55:04 +0200
Message-ID: <3059805.eeVPZ7aKPO@tauon.chronox.de>
In-Reply-To: <20201002064905.GA27115@infradead.org>
References: <20200930065617.934638-1-palmerdabbelt@google.com> <20201002064905.GA27115@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 2. Oktober 2020, 08:49:05 CEST schrieb Christoph Hellwig:

Hi Christoph,

> On Tue, Sep 29, 2020 at 11:56:18PM -0700, Palmer Dabbelt wrote:
> > clint_time_val will soon be used by the RISC-V implementation of
> > random_get_entropy(), which is a static inline function that may be used
> > by
> > modules (at least CRYPTO_JITTERENTROPY=m).
> 
> At very least this needs to be an EXPORT_SYMBOL_GPL.  But I really don't
> think modules have any business using get_cycles, so I'd much rather
> fix CRYPTO_JITTERENTROPY to be required to be build in.

Changing CRYPTO_JITTERENTROPY from tistate to bool should be no problem.

I will provide a patch.

Ciao
Stephan


