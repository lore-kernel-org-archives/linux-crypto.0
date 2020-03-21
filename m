Return-Path: <SRS0=8vbj=5G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3802C4332B
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Mar 2020 15:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB97020776
	for <linux-crypto@archiver.kernel.org>; Sat, 21 Mar 2020 15:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584805427;
	bh=rsgPusoppoGA9FjACWtOW9RDJE5WZe0r1xgblC5k9yI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=l9BkQKwks8FBxhliidw4JQr43iHZNq/7uABML8tee5TohJqpGcxKWX+Hd4bZSL5+o
	 VaXU3glJeL9X9YxsnFFGNgSyv1K648KP0elbF7Rx0rx2LmL7mnsZ8hTb4NGOT6LqLD
	 /JRLlvcuze9/Ft8wCUm0tWJ32aRJU1VJZkiG/6xw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgCUPnq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 Mar 2020 11:43:46 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33359 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgCUPnq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Mar 2020 11:43:46 -0400
Received: by mail-lf1-f67.google.com with SMTP id c20so6866142lfb.0
        for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2020 08:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6mvwA32asdU1LyqLjErxGo+uq/oR1vS7M/3Q5oXzKH4=;
        b=VdNJMvCSSTsnq7g5CcQorBBg8/QNzPG0SI25ZC9mlA4yRDxSRin81KqSSwTGYigX13
         s1UnVZb7biIxD4a9mpr69/OBuShp8JRKuf9UsbJn+aIgepCqiixt+2H9CXNvtRyDymLq
         0lbZdf43mg+2qHlv8Iae19hCw9u/4EijQwtZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6mvwA32asdU1LyqLjErxGo+uq/oR1vS7M/3Q5oXzKH4=;
        b=CxF20ruwOM6ocJ3Wpmn8XS692RuY+nFvW6lruXDb9QDbaetSE4iIQij5lyOcZsHWXS
         2yVVjiCXu0EDW9ACvprxfnWNr60L898N10XYfzzEijC7Mw0H+x0oX2Xmsb+ET0ZIj9FT
         29znxVkElnfrZMrzHSbqiPzbT8VJ7srZZWwPnNlrOKQeZ0wdVf7dsSx5k0EJU2d78iia
         PWVOutTgpMK1Y/DnzHLKU19EjPflZ9jgjFWH1pO+70xfH+uZYaEGY0ss/oKXkmGjOYPE
         OQ3VTP7KJNKU0bnDLWK2ItoK7TwKuuqkaJKpNbxRCZS2Xw/KxopwZVtH1b+xhZXZXURX
         h4CA==
X-Gm-Message-State: ANhLgQ0Z+1Dbpiuy6RED0+VA1GBAmNoVOugEPrXECHJ8BsnItRvCUNMI
        RCKx8dly643gDRq4I/lSEs8A53RVTgo=
X-Google-Smtp-Source: ADFU+vvVkaa9WSihV+J+EXENmioESnTkQINmSO8p0FXYPv7yr5lC+RGSVpf3k6SVVI+HfXBQHmburg==
X-Received: by 2002:a19:2353:: with SMTP id j80mr7926549lfj.4.1584805421655;
        Sat, 21 Mar 2020 08:43:41 -0700 (PDT)
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com. [209.85.167.44])
        by smtp.gmail.com with ESMTPSA id j21sm5438925lji.93.2020.03.21.08.43.40
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Mar 2020 08:43:40 -0700 (PDT)
Received: by mail-lf1-f44.google.com with SMTP id a28so6827616lfr.13
        for <linux-crypto@vger.kernel.org>; Sat, 21 Mar 2020 08:43:40 -0700 (PDT)
X-Received: by 2002:ac2:5203:: with SMTP id a3mr8371335lfl.152.1584805419698;
 Sat, 21 Mar 2020 08:43:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190916084901.GA20338@gondor.apana.org.au> <20190923050515.GA6980@gondor.apana.org.au>
 <20191202062017.ge4rz72ki3vczhgb@gondor.apana.org.au> <20191214084749.jt5ekav5o5pd2dcp@gondor.apana.org.au>
 <20200115150812.mo2eycc53lbsgvue@gondor.apana.org.au> <20200213033231.xjwt6uf54nu26qm5@gondor.apana.org.au>
 <20200224060042.GA26184@gondor.apana.org.au> <20200312115714.GA21470@gondor.apana.org.au>
 <CAHk-=wjbTF2iw3EbKgfiRRq_keb4fHwLO8xJyRXbfK3Q7cscuQ@mail.gmail.com> <CAHmME9pME41uHvhu5f_JGZbUNCuG0YVgRkBUQF9wtTO6YnMijw@mail.gmail.com>
In-Reply-To: <CAHmME9pME41uHvhu5f_JGZbUNCuG0YVgRkBUQF9wtTO6YnMijw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 21 Mar 2020 08:43:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjGaHhVKyxBYCcw41j84ic1GbyAuGfN7nA9zCJyHZTw2Q@mail.gmail.com>
Message-ID: <CAHk-=wjGaHhVKyxBYCcw41j84ic1GbyAuGfN7nA9zCJyHZTw2Q@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Fixes for 5.6
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 20, 2020 at 4:54 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Funny, I always thought it was like that "for a good reason" that I
> just didn't know about -- assumedly something having to do with a
> difference between config time and compile time.

No, there _is_ a "good reason", but it is simply "hysterical raisins".

All scripting used to be done in Makefiles, for the simple reason that
GNU make supported all those shell escapes. The Kconfig language did
not.

The whole "shell escape in Kconfig" is relatively recent, and so we
still have old code (and people) used to the build-time makefile rules
rather than those newfangled Kconfig things.

Of course "relatively recent" is about two years by now. It's not like
we did it yesterday.

Anyway, your conversion patches look fine to me. I'm obviously not
taking them for 5.6, but if they go into -next and get some testing,
I'd love to have that cleanup in 5.7.

                 Linus
