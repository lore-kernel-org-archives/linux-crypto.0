From: Stephan Mueller <smueller@chronox.de>
Subject: Re: chacha counters in random.c
Date: Mon, 10 Oct 2016 05:34:28 +0200
Message-ID: <9777512.vL8nZQ0s3r@positron.chronox.de>
References: <20161009171627.cr7eunq4h2rnj5s4@m.mifar.in>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org
To: Sami Farin <s@mifar.in>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48138 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbcJJDfy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Oct 2016 23:35:54 -0400
In-Reply-To: <20161009171627.cr7eunq4h2rnj5s4@m.mifar.in>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 9. Oktober 2016, 20:16:27 CEST schrieb Sami Farin:

Hi Sami,

> commit e192be9d9a30555aae2ca1dc3aad37cba484cd4a
> 
> +       chacha20_block(&crng->state[0], out);
> +       if (crng->state[12] == 0)
> +               crng->state[13]++;
> 
> Did you mean
> +       if (++crng->state[12] == 0)

Please see chacha20_block at the end:

        state[12]++;

I would guess that this is the increment you are looking for.

Ciao
Stephan
