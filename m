Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA36CC43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 06:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FAD520850
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 06:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbfCYGAs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 02:00:48 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:39034 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729373AbfCYGAs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 02:00:48 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id B052F72CCAC;
        Mon, 25 Mar 2019 09:00:44 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 3C4914A4AE9;
        Mon, 25 Mar 2019 09:00:43 +0300 (MSK)
Date:   Mon, 25 Mar 2019 09:00:41 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Subject: Re: Should we consider removing Streebog from the Linux Kernel?
Message-ID: <20190325060041.wl23bncqjab7dj5c@altlinux.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
References: <20190325044550.GI5675@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190325044550.GI5675@mit.edu>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Theodore,

On Mon, Mar 25, 2019 at 12:45:50AM -0400, Theodore Ts'o wrote:
> Given the precedent that has been established for removing the SPECK

As far as I know Speck is removed because:

| commit 578bdaabd015b9b164842c3e8ace9802f38e7ecc
| Author: Jason A. Donenfeld <Jason@zx2c4.com>
| Date:   Tue Aug 7 08:22:25 2018 +0200
|
|   crypto: speck - remove Speck
|
|   These are unused, undesired, and have never actually been used by
|   anybody. The original authors of this code have changed their mind about
|   its inclusion. While originally proposed for disk encryption on low-end
|   devices, the idea was discarded [1] in favor of something else before
|   that could really get going. Therefore, this patch removes Speck.
|
|   [1] https://marc.info/?l=linux-crypto-vger&m=153359499015659

None of these arguments apply to Streebog.

Thanks,


> cipher from the kernel, I wonder if we should be removing Streebog on
> the same basis, in light of the following work:
> 
> 	https://who.paris.inria.fr/Leo.Perrin/pi.html
> 	https://tosc.iacr.org/index.php/ToSC/article/view/7405
> 
> Regards,
> 
> 						- Ted
> 
> -----------
> 
> >From the Cryptography mailing list on metzdowd.com:
> 
> From: "perrin.leo@gmail.com" <perrin.leo@gmail.com>
> Subject: [Cryptography] New Results on the Russian S-box
> 
> Hello everyone,
> 
> I have recently sent an e-mail to the CFRG mailing list about my results
> on the S-box shared by both of the latest Russian standards in symmetric
> crypto and I have been told that it might interest the subscribers of
> this mailing list.
> 
> In a paper that I am about to present at the Fast Software Encryption
> conference, I describe what I claim to be the structure used by the
> S-box of the hash function Streebog and the block cipher Kuznyechik.
> Their authors never disclosed their design process---and in fact claimed
> that it was generated randomly. I established that it is not the case.
> More worryingly, the structure they used has a very strong algebraic
> structure which, in my opinion, demands a renewed security analysis in
> its light. Overall, I would not recommend using these algorithms until
> their designers have provided satisfactory explanations about their
> S-box choice.
