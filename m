Return-Path: <SRS0=z9QW=ZB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A9BC43331
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 05:03:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8378A21882
	for <linux-crypto@archiver.kernel.org>; Sat,  9 Nov 2019 05:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbfKIFD5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 9 Nov 2019 00:03:57 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:39805 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725788AbfKIFD5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 9 Nov 2019 00:03:57 -0500
Received: from callcc.thunk.org (96-72-102-169-static.hfc.comcastbusiness.net [96.72.102.169] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xA953rLL018550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 9 Nov 2019 00:03:54 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 20A1B4202FD; Sat,  9 Nov 2019 00:03:53 -0500 (EST)
Date:   Sat, 9 Nov 2019 00:03:53 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Frederick Gotham <cauldwell.thomas@gmail.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: Remove PRNG from Linux Kernel
Message-ID: <20191109050353.GD23325@mit.edu>
References: <XnsAB01A0BBA9FB8fgotham@195.159.176.226>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <XnsAB01A0BBA9FB8fgotham@195.159.176.226>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 08, 2019 at 03:48:02PM -0000, Frederick Gotham wrote:
> 
> There cannot be any software-based psuedo-random number generators on my 
> device, and so far I've removed three of them:
> 
> (1) The built-in PRNG inside OpenSSL
> (2) The Intel RDRAND engine inside OpenSSL
> (3) The simulator library that goes with the tpm2tss engine for OpenSSL 
> (tcti-mssim)

Why must there not be a "pseudo-random number generator"?  Who made
that rule?  What is the goal of not allowing such a thing?

Note that in general, most people would not refer to such things as a
"PRNG", but a Cryptographic Random Number Generator (CRNG).  And in
general, it's considered a very good thing put a CRNG in front of a
hardware random number generator for several reasons:

  (1) Hardware random number generators, including TPM-based RNG's are
      slow, and

  (2) using a hardware RNG directly means you are investing all of
      your trust in the hardware RNG --- and hardware RNG have been known to
      have their share of insecurities.

What makes you so sure that the you can trust the implementation of
the TPM's random number generator?

Far better is to mix multiple entropy sources together, so that if one
happens to be insecure, or has failed in some way, you still will have
protection from the other entropy sources.

> I need to remove the PRNG from the Linux kernel and replace it with something 
> that interfaces directly with the TPM2 chip.
> 
> Has this been done before?

As far as I know, no, because most people would consider this a
Really, REALLY, **REALLY** bad idea.  Note that the TPM2 chip has a
very slow connection to the main CPU, and there are many applications
which will need session keys at a high rate (for example, opening
multiple https connections when browsing a web page), for which the
TPM2 would be totally unsuited.

If you really want to use the TPM2 chip, there are userspace libraries
which will access it directly, and you can see how slow and painful
using the TPM chip really would be....

						- Ted
