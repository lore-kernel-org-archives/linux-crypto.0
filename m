From: Sami Farin <s@mifar.in>
Subject: Re: chacha counters in random.c
Date: Mon, 10 Oct 2016 08:35:15 +0300
Message-ID: <20161010053515.j2vfju7fzdghx5hs@m.mifar.in>
References: <20161009171627.cr7eunq4h2rnj5s4@m.mifar.in>
 <9777512.vL8nZQ0s3r@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mifar.in ([46.101.129.31]:60822 "EHLO mifar.in"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750910AbcJJFfS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Oct 2016 01:35:18 -0400
Content-Disposition: inline
In-Reply-To: <9777512.vL8nZQ0s3r@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 10, 2016 at 05:34:28 +0200, Stephan Mueller wrote:
> Am Sonntag, 9. Oktober 2016, 20:16:27 CEST schrieb Sami Farin:
> 
> Hi Sami,
> 
> > commit e192be9d9a30555aae2ca1dc3aad37cba484cd4a
> > 
> > +       chacha20_block(&crng->state[0], out);
> > +       if (crng->state[12] == 0)
> > +               crng->state[13]++;
> > 
> > Did you mean
> > +       if (++crng->state[12] == 0)
> 
> Please see chacha20_block at the end:
> 
>         state[12]++;
> 
> I would guess that this is the increment you are looking for.

Oh yeah, there it is.

-- 
Do what you love because life is too short for anything else.
