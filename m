Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D78BC48BE0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23A40613EA
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbhFKJzu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 05:55:50 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:10413 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbhFKJzu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 05:55:50 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1623405218; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=QkmovniKg3cI3qm9DgV+6FIpCkW+o4naucTn2DHpI9ybHtPAxdZtHR39d1d5luVedW
    cYuX8yqeg1C7QVnj5YNDxT5H72h9TGRhyuf39XVFwKvCh/LXkojMGJh9G5wuNzikpxT+
    XkXSmigVz2HNtc3xyWUC3oXC77O4guXzqpTgU/t1YMpXXknxUA2zep3FHXNz2Wkc39kh
    MCXqSOVmoA+KX9FFISRw+sz11WumBskVrZGSsu6VtPhg2uBU3DMhsyReigrZtERi9bZe
    V/cEkHvBBVzWwb9ezk/Jph3IPnZDA37u0nSIjmtTWdUml5zWant6RUl5PBQQPCrvBKSt
    FywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1623405218;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=BXAhtAPokhqTkai6LEBId7hEOAA+vsYnofNAm8LFndc=;
    b=ZiXN2yEhFQp9FZsfCoAjlvDAgLJP4dqbm2zUs3o7YznpTVlP7y9QyB5iqHRwGZuZ9k
    L6gZKxqQSvW06jGCUcM0oEwbvHJ5klyntAOowleGLEgkAcFjrX9/VTIYF4CzqL1B5bxS
    4KxKjY8Z3PzaQPUaL5AtRyOF9L0V3a1VcAd2NupNF7gNZYaQJtMaLwwCy4bnmuNPkYVI
    7Bn3q23DEko9dMWvFqJkBf7dhuvc8nrRVY/rwNNMZCj7sSpSKGxyVFbBElqiIsY8o+MF
    DYIQy53L/CxIOryToINrF1c7MxtbDGdms8rDmSG/tcB8LUmhPEbaEVQCRt2JFgJN/06U
    N9lQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1623405218;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:To:From:Subject:Message-ID:Cc:Date:From:
    Subject:Sender;
    bh=BXAhtAPokhqTkai6LEBId7hEOAA+vsYnofNAm8LFndc=;
    b=QwkpuA0v0uJCAeZ12VNgB/9zZzyubZaqj2JuzZKcLvjrrgpIDwY0gDGFXo5+cUV+vc
    CCsi4Vjk3VsnGmeAcwz8cwT+RN/zH2PZ+PAuSUUQULN8+Jw75kBQuI0kRxB6a03WbH72
    RozhK/wNWu7swa9qiIQ1XXsvMvxTYIsHRICxMGg0af9qaNa+S0Hjf0sEOdSEqPZ9MrwY
    tQUgX2bxFNdQi18AZAbrmX0tfJ4JJglDMgLmF+70AYF24Xgpg5zR4Fcg+uvgxM3HPJQF
    Y2pQ5rjWLGUEKfyJMHr/xpWc9Nff9KSqp0Uh7UX2zxNkDugAYNGhLcEYTIlhSWpJ5ivS
    X3Wg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJSlCkMdYMUE="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.27.2 DYNA|AUTH)
    with ESMTPSA id z03662x5B9rceIO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 11 Jun 2021 11:53:38 +0200 (CEST)
Message-ID: <a790ee77f0f60fb8ded486e84a003d816f28f370.camel@chronox.de>
Subject: Re: Lockless /dev/random - Performance/Security/Stability
 improvement
From:   Stephan Mueller <smueller@chronox.de>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ted Ts'o <tytso@mit.edu>, John Denker <jsd@av8n.com>,
        Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 11 Jun 2021 11:53:37 +0200
In-Reply-To: <1744453.HlSabMDqgd@positron.chronox.de>
References: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
         <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
         <1744453.HlSabMDqgd@positron.chronox.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, dem 11.06.2021 um 07:59 +0200 schrieb Stephan Müller:
> Am Freitag, 11. Juni 2021, 05:59:52 CEST schrieb Sandy Harris:
> 
> Hi Sandy,

Hi Sandy,

Please apologize and disregard my email. I erroneously thought you are
referring to the LRNG work.

I did not want to hijack any discussion.

(but it gave me a good input :-) )

Sorry
Stephan


