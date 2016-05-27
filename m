From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: Could this be applied to random(4)?
Date: Fri, 27 May 2016 16:09:53 -0400
Message-ID: <CACXcFmm1q-Z3JSE79m5ak-a+tO50uQNUPwvq_ueei_b19qycJw@mail.gmail.com>
References: <CACXcFm=Feh_V_AMMYwdAjx4SiVh1eSeQnu1eujjv4S6-LD9Pag@mail.gmail.com>
	<1536831.omfD4HBPSy@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	John Denker <jsd@av8n.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37268 "EHLO
	mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbcE0URN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 16:17:13 -0400
Received: by mail-it0-f42.google.com with SMTP id z123so2771144itg.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2016 13:17:12 -0700 (PDT)
In-Reply-To: <1536831.omfD4HBPSy@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 27, 2016 at 2:30 PM, Stephan Mueller <smueller@chronox.de> wrote:

> This document describes extractors. Those extractors are intended to combine
> *independent* sources with weak entropy.
>
> None of our sources we have in add_*_randomness are independent.

No, but it would be easy to get two independent sources, interrupts
and some sort of timer jitter thing as in my maxwell, your jitter
driver, havege, ...
