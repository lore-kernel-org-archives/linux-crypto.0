Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3ECEC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 16:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E9F7215EA
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 16:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfKHQAF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 11:00:05 -0500
Received: from 195-159-176-226.customer.powertech.no ([195.159.176.226]:44012
        "EHLO blaine.gmane.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727701AbfKHQAE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 11:00:04 -0500
Received: from list by blaine.gmane.org with local (Exim 4.89)
        (envelope-from <glkc-linux-crypto@m.gmane.org>)
        id 1iT6g6-000y3O-13
        for linux-crypto@vger.kernel.org; Fri, 08 Nov 2019 17:00:02 +0100
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-crypto@vger.kernel.org
From:   Frederick Gotham <cauldwell.thomas@gmail.com>
Subject: Remove PRNG from Linux Kernel
Date:   Fri, 8 Nov 2019 15:48:02 -0000 (UTC)
Message-ID: <XnsAB01A0BBA9FB8fgotham@195.159.176.226>
User-Agent: Xnews/5.04.25
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Has anyone yet removed the random number generator entirely from the Linux 
kernel?

I'm currently working on an embedded x86_64 project, and I'm interfacing 
witht the TPM2 chip.

There cannot be any software-based psuedo-random number generators on my 
device, and so far I've removed three of them:

(1) The built-in PRNG inside OpenSSL
(2) The Intel RDRAND engine inside OpenSSL
(3) The simulator library that goes with the tpm2tss engine for OpenSSL 
(tcti-mssim)

The only software-based random-number generator left on my device is inside 
the Linux kernel (i.e. the one that feeds /dev/random).

I do realise that there are tools like 'rng-tools' for feeding a hardware 
generator into the entropy pool for "/dev/random" -- but this simply isn't 
good enough for my project.

I need to remove the PRNG from the Linux kernel and replace it with something 
that interfaces directly with the TPM2 chip.

Has this been done before?

