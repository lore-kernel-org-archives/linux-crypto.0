Return-Path: <SRS0=lOaP=W5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0649BC3A59B
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Sep 2019 09:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2AB120644
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Sep 2019 09:05:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="VPPv9Hkk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbfIBJF0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Sep 2019 05:05:26 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:22573 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730308AbfIBJF0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Sep 2019 05:05:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1567415121;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=PdyLS7N7QHu+lSOKHmnQSTNeXM0u9qkzU1qvZUNp5o8=;
        b=VPPv9HkkVvtlwKVv/hbXVCYkeOXP3uoaRNNciel1TjOY/BKF0TK7A9pREQpRAmeiBJ
        qskqpf1b1iAV3BWnyJt4A/CTZXD4R7U7ucFasFM4iumr0fyqxcYdXFLjFRZLCesfXVF0
        ZOlOXR0b+Z4XwxouHhgqbh7KnTQM0HeuFghqJVU+kcaUIMqMDkWIMzDo3FkJXPwecXU4
        4c6daXGy3icwjJ1TkIfa3+UV2kFgczCVx7zT36hOY/845wOv2Q+c9svi8093ES0usWhX
        8y3jfHqSZFwwzbvZDaF47DnTP6LEeLN3ieZG3VphqIT+mMJS4gkip45aJe1t96PQvb+u
        FrAA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zmwdN52krmXIc+RZmA=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.27.0 AUTH)
        with ESMTPSA id t0367bv8295LVNo
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Mon, 2 Sep 2019 11:05:21 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: How to use nonce in DRBG functions.
Date:   Mon, 02 Sep 2019 11:05:19 +0200
Message-ID: <4456652.e1v30m9lHF@tauon.chronox.de>
In-Reply-To: <TU4PR8401MB0544172FD34CD6FB6F2269CBF6BF0@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
References: <TU4PR8401MB0544172FD34CD6FB6F2269CBF6BF0@TU4PR8401MB0544.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 1. September 2019, 20:52:24 CEST schrieb Bhat, Jayalakshmi 
Manjunath:

Hi Jayalakshmi,

> Hi All,
> 
> I am trying to implement DRBG CAVS test harness function for Linux Kernel
> crypto DRBG with the following requirements. 1.	Derivate function is
> enabled.
> 	2.	prediction resistance is not enabled
> 	3.	Entropy input length is 256
> 	4.	Nonce length is 256
> 	5.	Mode is AES-CTR 256
> 	6.	Reseed is supported
> 	7.	Intended use generate.
> 
> Thus inputs are
> 	1.	Entropy Input
> 	2.	Nonce
> 	3.	Entropy Additional Input
> 
> Flow goes something like below
> 	drbg_string_fill(&testentropy, test->entropy, test->entropylen);
> 	drbg_string_fill(&pers, test->pers, test->perslen);
> 	ret = crypto_drbg_reset_test(drng, &pers, &test_data);
> 	drbg_string_fill(&addtl, test->addtla, test->addtllen);
> 	ret = crypto_drbg_get_bytes_addtl(drng, buf, test->expectedlen, 
&addtl);
> 
> I am not finding a way to input nonce. Please can anyone tell me how to
> input nonce.

The entropy string for the DRBG is the CAVS entropy concatenated with the 
nonce as defined in SP800-90A for each instantiate process of each DRBG.
> 
> Regards,
> Jayalakshmi



Ciao
Stephan


