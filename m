Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E255EECAAD3
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Sep 2022 15:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbiISPJN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Sep 2022 11:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiISPJL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2022 11:09:11 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFA41FCE4
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 08:09:09 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a26so36482980ejc.4
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 08:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=29Q13qvIrzikJw/fUgHdsSOAwHmgeU1WfwREQ1Cge1Y=;
        b=lwxdIbe5BjxF0HFPnwF9Ofpvu0luMg35Ct6ff/AF8HWxyNhmnKGYXO+mANg2sK0aRp
         zDmKcO1OJAa/tYrxnxzBvTsVbyoz/6hGfgwWltTQlppuEsv2vmOuV0C99/+dJ3qo1nuD
         nT6doWb23QqnDbH824dGANTgN7MsuOFdOTvQQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=29Q13qvIrzikJw/fUgHdsSOAwHmgeU1WfwREQ1Cge1Y=;
        b=oU3Z2hEX+Um7zesy8YL8nImW+j9VgN5G8S1aPcFQJbliSf6p8qruBYHDYn0HEFRnGV
         CBhngsftxADyHWmExfd4jHz7lAUDC0zKnGFPdDuGIOdEN0hJxGC/P5hgcqKsHij5GnhG
         bYJlcs/rCaIc5t0/EqrC9u1+/vGF068wwSuY+gSgb73Ev4lbL8S6qrKSzEq7x22MhBCz
         7o0frMhisoENg/BXI8xn/JL+K2k4Um0UkbXHOYneGnL+h7bN22IMrSU8DqRCaGQDI3fL
         m83rDZSHNGTUsEz64XE34FejWd+TSoj5Kke4C3HpyLybdgbZn33TvEY3TcLnWOg65Vx9
         JoyQ==
X-Gm-Message-State: ACrzQf2BODPmBDEbVZsP+kEH49DsRfmcnWQtfKVSpy7JnZGZdzr5jSzP
        Ok/uP7bqVbyk2ODuoijSHVYRtGFkvnYl2yY8
X-Google-Smtp-Source: AMsMyM68SlImpfPQkp8zH1fdU8c6MKPCFdiNutVrGQ5eIhAUIvicf2UtAG3SFKsN9FJM7uF33yFq9Q==
X-Received: by 2002:a17:907:980e:b0:77a:6958:5aa1 with SMTP id ji14-20020a170907980e00b0077a69585aa1mr13760115ejc.232.1663600147415;
        Mon, 19 Sep 2022 08:09:07 -0700 (PDT)
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id d15-20020a170906304f00b00772b5835c12sm15606171ejd.23.2022.09.19.08.09.07
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Sep 2022 08:09:07 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id y3so65279753ejc.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 08:09:07 -0700 (PDT)
X-Received: by 2002:a05:651c:17a7:b0:261:c0b1:574b with SMTP id
 bn39-20020a05651c17a700b00261c0b1574bmr5541662ljb.40.1663599802963; Mon, 19
 Sep 2022 08:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220915002235.v2.1.I7c0a79e9b3c52584f5b637fde5f1d6f807605806@changeid>
 <CAHmME9rhunb05DEnc=UfGr8k9_LBi1NW2Hi0OsRbGwcCN2NzjQ@mail.gmail.com>
In-Reply-To: <CAHmME9rhunb05DEnc=UfGr8k9_LBi1NW2Hi0OsRbGwcCN2NzjQ@mail.gmail.com>
From:   Sven van Ashbrook <svenva@chromium.org>
Date:   Mon, 19 Sep 2022 11:03:11 -0400
X-Gmail-Original-Message-ID: <CAM7w-FXHWzcN1Y7pwb6+1KA6A2oZRrfpOJdWFVWjRvjbp+DEOg@mail.gmail.com>
Message-ID: <CAM7w-FXHWzcN1Y7pwb6+1KA6A2oZRrfpOJdWFVWjRvjbp+DEOg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] random: move add_hwgenerator_randomness()'s wait
 outside function
To:     Dominik Brodowski <linux@dominikbrodowski.net>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Olivia Mackall <olivia@selenic.com>,
        Alex Levin <levinale@google.com>,
        Andrey Pronin <apronin@google.com>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Stephen Boyd <swboyd@google.com>,
        Rajat Jain <rajatja@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Petr Mladek <pmladek@suse.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 16, 2022 at 10:51 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> The other thing that occurred to me when reading this patch in context
> of the other one is that this sleep you're removing here is not the
> only sleep in the call chain. Each hwrng driver can also sleep, and
> many do, sometimes for a long time, blocking until there's data
> available, which might happen after minutes in some cases. So maybe
> that's something to think about in context of this patchset -- that
> just moving this to a delayed worker might not actually fix the issue
> you're having with sleeps.
>

This is an excellent point. A look at tpm2_calc_ordinal_duration()
reveals that tpm_transmit() may block for 300s at a time. So when
we are using a WQ_FREEZABLE delayed_work, the PM may have to wait
for up to 300s when draining the wq on suspend. That will introduce
a lot of breakage in suspend/resume.

Dominik: in light of this, please proceed with your patch, without
rebasing it onto mine.

+ tpm maintainers Peter Huewe and Jarkko Sakkinen, a quick recap of
the problem:

- on ChromeOS we are seeing intermittent suspend/resume errors+warnings
  related to activity of the core's hwrng_fillfn. this kthread keeps
  runningduring suspend/resume. if this happens to kick off an bus (i2c)
  transaction while the bus driver is in suspend, this triggers
  a "Transfer while suspended" warning from the i2c core, followed by
  an error return:

i2c_designware i2c_designware.1: Transfer while suspended
tpm tpm0: i2c transfer failed (attempt 1/3): -108
[ snip 10s of transfer failed attempts]

- in 2019, Stephen Boyd made an attempt at fixing this by making the
  hwrng_fillfn kthread freezable. But a freezable thread requires
  different API calls for scheduling, waiting, and timeout. This
  generated regressions, so the solution had to be reverted.

https://patchwork.kernel.org/project/linux-crypto/patch/20190805233241.220521-1-swboyd@chromium.org/

- the current patch attempts to halt hwrng_fillfn during suspend by
  converting it to a self-rearming delayed_work. The PM drains all
  work before going into suspend. But, the potential minute-long
  blocking delays in tpm make this solution infeasible.

Peter and Jarkko, can you think of a possible way forward to eliminate
the warnings+errors?

-Sven
