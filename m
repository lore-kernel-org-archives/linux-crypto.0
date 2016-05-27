From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Could this be applied to random(4)?
Date: Fri, 27 May 2016 20:30:51 +0200
Message-ID: <1536831.omfD4HBPSy@tauon.atsec.com>
References: <CACXcFm=Feh_V_AMMYwdAjx4SiVh1eSeQnu1eujjv4S6-LD9Pag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	John Denker <jsd@av8n.com>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34942 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbcE0Say (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 14:30:54 -0400
In-Reply-To: <CACXcFm=Feh_V_AMMYwdAjx4SiVh1eSeQnu1eujjv4S6-LD9Pag@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 27. Mai 2016, 13:38:05 schrieb Sandy Harris:

Hi Sandy,

> A theoretical paper on getting provably excellent randomness from two
> relatively weak input sources.
> https://www.sciencenews.org/article/new-technique-produces-real-randomness

This document describes extractors. Those extractors are intended to combine 
*independent* sources with weak entropy.

None of our sources we have in add_*_randomness are independent.

In addition, I am not sure why this research is so hyped. I think that the 3-
source extractor described in [1] is more efficient and easier to implement

[1] "Extracting Randomness Using Few Independent Sources" by Boaz Barak, 
Russell Impagliazzo, Avi Wigderson

Ciao
Stephan
