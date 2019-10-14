Return-Path: <SRS0=VKJi=YH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D37A0C47404
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E700E20673
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Oct 2019 05:41:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="f9sb8iKS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbfJNFlJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 01:41:09 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.24]:34636 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfJNFlJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 01:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1571031664;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=it3SjtxvX4RATE7IY+m+rQ5b++70cacxlHSrzkepVy0=;
        b=f9sb8iKSb6M3HUQlNWdB0O3LJjRCg7Sb9lWE6+d51cCmm5/ZjW1N72TQjpvhTWBQp5
        tSlkIrvbPvTi6C/Xq47ZmNINS5tl5tEdfMg28dbbLfiNn+WgCLVFgYI8q6DJl4bIseyi
        AEYNjf1IFZV6LMwysUmJn2HpVqCT1ok5THiYJEhVI/MtTZkkLgD8pJX5d0XUTOC9dlRy
        HQQnDZ1o1StajPs3sDncbjJVPZ0PnunbSqbim8IyYxQ4c5iiOsyVc/2G7ii914peLUKR
        1C/NBHBFBiTDs0NObnh3aDFp/JxF7IspSlcBXNcoW69zinv7GqUoNe0MetiPvthB66hx
        NjWQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJ/Sc+iAB"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.28.0 DYNA|AUTH)
        with ESMTPSA id I003a5v9E5f4VIJ
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 14 Oct 2019 07:41:04 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Gleb Pomykalov <gleb@lancastr.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: EIP97 kernel failure with af_alg/libaio
Date:   Mon, 14 Oct 2019 07:41:03 +0200
Message-ID: <12396681.Xx2HXIOQZG@tauon.chronox.de>
In-Reply-To: <CALbZx5WSonqQTuPSLDpDkdCfyj76Fht5EXtN2gF9H5=_qeA9rg@mail.gmail.com>
References: <CALbZx5WSonqQTuPSLDpDkdCfyj76Fht5EXtN2gF9H5=_qeA9rg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 13. Oktober 2019, 10:49:07 CEST schrieb Gleb Pomykalov:

Hi Gleb,

> Hello,
> 
> I'm trying to make EIP97 work on Mediatek mtk7623n (Banana PI R2). The
> kernel version is 4.14.145. My tests uses af_alg in libaio mode, and
> encrypts the data. For smaller blocks it works just fine, but if I
> increase the size I'm getting the kernel error (it fails on 8k block
> and larger, 4k works fine):
> 

Can you please send the exact invocation sequence? The backtrace initially 
does not hint to any AF_ALG-specific issue.

Ciao
Stephan


