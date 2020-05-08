Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8395BC38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 12:22:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6FFE21582
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 12:22:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="J1/pClVd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgEHMWF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 08:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726636AbgEHMWF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 08:22:05 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBD4C05BD43
        for <linux-crypto@vger.kernel.org>; Fri,  8 May 2020 05:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588940522;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=bFyYGmK8UjPyN+lzQZ16AihFcLQCLox1f86SkATnLrs=;
        b=J1/pClVdqSqZgTB4PmDk8xEv6BkGmjZv5JXe6b+et+ZoOP3j6HqKeJNSb8lUs0SBm8
        CZAEnppYm48hhk9BSO38VR3xAvX5H4MyuiVHTmlFo1DMCUfK4PSsGupRFuY5x9YBSsUh
        zGgjVSxQ69APclTCZ7DDjwA+0dfbMpS+/MTVIfj9rDANc/6lmP0vjutVAISsVTIViihV
        UVPEB3kUIhuXyA8UnFU7Oy0BN1g48HatboLzBp3xtwSDUZRfgPyFIpWMqCCQ+TPDK/MA
        qSZEpuPBVweQ5nAWZ87MKL/wo/Ou3EA8ioKP2wjF4vvkho5DWdbe+6bLsAmJuke8Ne6u
        5CTQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSfJdtJ"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w48CM2Qes
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 8 May 2020 14:22:02 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Alexander Dahl <ada@thorsis.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: jitterentropy_rng on armv5 embedded target
Date:   Fri, 08 May 2020 14:22:02 +0200
Message-ID: <8028774.qcRHhbuxM6@tauon.chronox.de>
In-Reply-To: <2049720.SxWqT2AVQ6@ada>
References: <2567555.LKkejuagh6@ada> <6309135.Bj5FvMsAKG@tauon.chronox.de> <2049720.SxWqT2AVQ6@ada>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 8. Mai 2020, 14:17:25 CEST schrieb Alexander Dahl:

Hi Alexander,

> > > If so, then how is it supposed to be set up?
> > 
> > It is intended for in-kernel purposes (namely to seed its DRBG).
> 
> Okay and DRBG has nothing to do with /dev/random ?

Nope, it is used as part of the kernel crypto API and its use cases.

> Then where do the random
> numbers for that come from (in the current or previous kernels without your
> new lrng)?

The DRBG is seeded from get_random_bytes and the Jitter RNG.


Ciao
Stephan


