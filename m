Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D4DCC2D0C2
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 12:47:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F12206DA
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 12:47:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="d0AW4pGf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfLaMrs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 31 Dec 2019 07:47:48 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:13684 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfLaMrs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 31 Dec 2019 07:47:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1577796466;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=aBhOARcicbiRL8oIBJ+zhmMwQC2n51nOUXKMXbfqIgA=;
        b=d0AW4pGfNoDeecge16zecgATfisMCcLbCO2IxKNy5xSXetbSEUfFITwClsYqEzEMps
        gENALpGj4fNLztNBqLAwYk6hVVNewbQesOVkotFLcxrUSdNYo0Jl087niWw4nbwIkBJX
        3SWZkKUrvYDi/kgFNzA3mg4yVRJJwwAzvVIa6D4qIWjlCNszm2Vnpan6ZPf6EXOlvS/T
        sp+H0kwud2ux99rl6jzzcf3UWHw0ACCuAtvAZa9Nw7PffNpacyqar62B5WzHwvJZYEt1
        G4OdfGcmIMOQMywLWtiwMUWrK++4DSDgBVlSy9bf+Eue8CjaOMsmERgGqiIrmC6UlnQK
        v7ZQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDbIPScmBEU"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.1.3 DYNA|AUTH)
        with ESMTPSA id e09841vBVClkPmc
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 31 Dec 2019 13:47:46 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Mohan Marutirao Dhanawade <mohand@xilinx.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Hardware TRNG driver framework selection criteria
Date:   Tue, 31 Dec 2019 13:47:45 +0100
Message-ID: <64323166.GGM4aZ99Nc@tauon.chronox.de>
In-Reply-To: <CH2PR02MB60403861414CF41EBCD4C71FB6270@CH2PR02MB6040.namprd02.prod.outlook.com>
References: <CH2PR02MB60404BC572AFE710C2AFF42CB6270@CH2PR02MB6040.namprd02.prod.outlook.com> <CH2PR02MB60403861414CF41EBCD4C71FB6270@CH2PR02MB6040.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 30. Dezember 2019, 09:40:30 CET schrieb Mohan Marutirao Dhanawade:

Hi Mohan,

> Hi everyone,
> 
> I am writing Linux driver to support TRNG hardware module for Xilinx SoC. I
> am seeing two frameworks - crypto framework and hw_random (char driver)
> which can be used to write driver for TRNG. Can someone please educate me
> on what criteria is to be used to decide which framework to use for TRNG
> (Crypto framework / hw_random char driver)?

The crypto API RNG framework is used to implement deterministic RNGs which in 
turn need seending from a noise source.

The HW RNG framework is used for accessing RNGs which have their own noise 
source and provide random data with appropriate entropy. These RNGs are 
available via /dev/hwrng.
> 
> Regards,
> Mohan
> This email and any attachments are intended for the sole use of the named
> recipient(s) and contain(s) confidential information that may be
> proprietary, privileged or copyrighted under applicable law. If you are not
> the intended recipient, do not read, copy, or forward this email message or
> any attachments. Delete this email message and any attachments immediately.



Ciao
Stephan


