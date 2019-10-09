Return-Path: <SRS0=7GLU=YC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67627ECE58D
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 09:23:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FEB421848
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 09:23:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="jIaRctw+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbfJIJXS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Oct 2019 05:23:18 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:32468 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbfJIJXS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Oct 2019 05:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1570612996;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=DMs7x1lyo+EAQpd7qhadPK8XBz5Wdyy6DbTWfKuq6nI=;
        b=jIaRctw+0NL+aO/6MGb6KzYfgd+vkuus+GBg4Kb2mWs0TFTL94++AYVd3qMTkBOApb
        lxM2UunOTSymVPkGyLrMcRbuhOwoL3gpd/HIMPOjWS3U9PEiHo3S+kL1GYDWADBvh0bW
        tb4+cRl+3I/qS4cgoJdBVgKfoXpWnUNXuUXSq6+DOCLNNO1JU5pW6cpID9TjWx5fBT0Y
        EBkIJfyPucd5b1pDUQYsf3RB/A17CY91j/pjM1ilW71UD8xkKuZNDCHoojnmuA2bBDjm
        8/x1a301dHC6Ub96fbTlwWCHWXOFgVOCKXbuyjfhwSTRlhH2u5dC3JgtnuOBHBSV6qXL
        OElQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJ/SczDZM"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.28.0 DYNA|AUTH)
        with ESMTPSA id I003a5v999MuB0j
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 9 Oct 2019 11:22:56 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Ben Dooks <ben.dooks@codethink.co.uk>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH] crypto: jitter - add header to fix buildwarnings
Date:   Wed, 09 Oct 2019 11:22:56 +0200
Message-ID: <2519389.eumGI5PgG6@tauon.chronox.de>
In-Reply-To: <20191009091256.12896-1-ben.dooks@codethink.co.uk>
References: <20191009091256.12896-1-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Mittwoch, 9. Oktober 2019, 11:12:56 CEST schrieb Ben Dooks:

Hi Ben,

> Fix the following build warnings by adding a header for
> the definitions shared between jitterentropy.c and
> jitterentropy-kcapi.c. Fixes the following:
> 
> crypto/jitterentropy.c:445:5: warning: symbol 'jent_read_entropy' was not
> declared. Should it be static? crypto/jitterentropy.c:475:18: warning:
> symbol 'jent_entropy_collector_alloc' was not declared. Should it be
> static? crypto/jitterentropy.c:509:6: warning: symbol
> 'jent_entropy_collector_free' was not declared. Should it be static?
> crypto/jitterentropy.c:516:5: warning: symbol 'jent_entropy_init' was not
> declared. Should it be static? crypto/jitterentropy-kcapi.c:59:6: warning:
> symbol 'jent_zalloc' was not declared. Should it be static?
> crypto/jitterentropy-kcapi.c:64:6: warning: symbol 'jent_zfree' was not
> declared. Should it be static? crypto/jitterentropy-kcapi.c:69:5: warning:
> symbol 'jent_fips_enabled' was not declared. Should it be static?
> crypto/jitterentropy-kcapi.c:74:6: warning: symbol 'jent_panic' was not
> declared. Should it be static? crypto/jitterentropy-kcapi.c:79:6: warning:
> symbol 'jent_memcpy' was not declared. Should it be static?
> crypto/jitterentropy-kcapi.c:93:6: warning: symbol 'jent_get_nstime' was
> not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Reviewed-by: Stephan Mueller <smueller@chronox.de

Ciao
Stephan


