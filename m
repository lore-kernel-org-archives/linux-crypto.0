From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: AES-NI: slower than aes-generic?
Date: Thu, 26 May 2016 14:20:19 -0400
Message-ID: <CACXcFmnFn_BDv_xLra-gfSTsOP-diTwtvU4_TndLAv+WuXG4DQ@mail.gmail.com>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Stephan Mueller <stephan.mueller@atsec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:36174 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbcEZSUU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 May 2016 14:20:20 -0400
Received: by mail-io0-f171.google.com with SMTP id f8so58051450ioe.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 May 2016 11:20:19 -0700 (PDT)
In-Reply-To: <1567400.ZMFoPuCv2K@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <stephan.mueller@atsec.com> wrote:

> for the DRBG and the LRNG work I am doing, I also test the speed of the DRBG.
> The DRBG can be considered as a form of block chaining mode on top of a raw
> cipher.
>
> What I am wondering is that when encrypting 256 16 byte blocks, I get a speed
> of about 170 MB/s with the AES-NI driver. When using the aes-generic or aes-
> asm, I get up to 180 MB/s with all else being equal. Note, that figure
> includes a copy_to_user of the generated data.

Why are you using AES? Granted, it is a reasonable idea, but when Ted
replaced the non-blocking pool with a DBRG, he used a different cipher
(I think chacha, not certain) and I think chose not to use the crypto
library implementation to avoid kernel bloat.

So he has adopted on of your better ideas. Why not follow his
lead on how to implement it?
