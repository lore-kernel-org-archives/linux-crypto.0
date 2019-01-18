Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEA8C43387
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jan 2019 00:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F3AD20823
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jan 2019 00:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTgvSGaK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbfARA0S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jan 2019 19:26:18 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:45676 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfARA0S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 19:26:18 -0500
Received: by mail-ot1-f48.google.com with SMTP id 32so12848540ota.12;
        Thu, 17 Jan 2019 16:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/4qz3k273AUqayn063tmJ7Wyqn5N71fj5che6XhgWc=;
        b=MTgvSGaKK+p7ClgFCL7wVM3Db7x2iP3lAnnTxLIvodlyGD9WNMN8FWct9d7qlzzx2D
         6RUFFFAGFDY4bAksKwKiYAhQvpSfN5vEvxPM2Ct/BF5nRpocvjzAg+5YLdrrw+cZtS+5
         FVbZU5d5QjffR6jzXSCq0jVk1nXfTvd7mI9tSEBKKcvwrtmezNU2+kd8Yb3wEZwg2cvF
         jSDq1HzVouiVJ/oGi9gB2NVVWUyTTwNVTygj4aLwZwfNdqpT2875fdPbp3R7aGweyHeK
         xhtox8DVcCR+eFzlluIIKhu3KwIg59J0TGOnpt0XJw7/ymN4FtMMGZBE3sR+yL419BH7
         VdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/4qz3k273AUqayn063tmJ7Wyqn5N71fj5che6XhgWc=;
        b=Eg7M284/hOOUGycrkGP7UmPT3GAvM7Kj0vXrM6WvcPeg+z3BWQZANRdyr9N++OJcJQ
         xZXQDLYGhjce41Hiv4OKM7NV6xE1xEjwzw1v477Ylkqc1pKuc5HtEzR95JdtGh6sD5Pv
         weEHbOJCB3tcGBUQyzOXG6gtz9glxUd89WooBt/6hv0AdBtwo6S5HtayzbvcURW6Mbya
         plC8o1MATBiDpik2HH+/g1LZtUO8P3pV1uyk7q5yU+z4bB4gOnpWYVlGRtt5ZzQPVajN
         Lra2HgvwtFZKFW/YByBxbsFgNpo+r37KTi4NK6JMTtlT8ymmgvlzQsttHhwhOZO/cSWM
         IWbQ==
X-Gm-Message-State: AJcUukdM74+nHMMapJ0RTAhUOEtGXS7zEBqS4ICHxz93S4UolpRaD5dH
        b7MgyuF9NxpzSMsDM3tUHYljvdKI6yVUWs3niiE=
X-Google-Smtp-Source: ALg8bN5vtwCA8vh/vLRpRj6k/ia93apWErXTlIAvMna//YkQ9Xa13ariSTxW4922X0gxogm70K/hk1y9O5ZXrRDSgBI=
X-Received: by 2002:a9d:77d4:: with SMTP id w20mr9996114otl.196.1547771177473;
 Thu, 17 Jan 2019 16:26:17 -0800 (PST)
MIME-Version: 1.0
References: <20190117231416.111952141@linutronix.de> <20190117231501.068505479@linutronix.de>
In-Reply-To: <20190117231501.068505479@linutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 17 Jan 2019 22:26:07 -0200
Message-ID:
 <CAOMZO5CsTiQV78d6ZvUBwzzU9iF8ZnCpp_O7VBrvxstZ6kNNRg@mail.gmail.com>
Subject: Re: [patch 3/9] crypto: morus - Cleanup license mess
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Ondrej Mosnacek <omosnacek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20190118002607.2kYBBlReJyG1mIj3Jj1WdfWdJDrzFEN8JJUEdLcjrqU@z>

On Thu, Jan 17, 2019 at 9:17 PM Thomas Gleixner <tglx@linutronix.de> wrote:

> --- a/include/crypto/morus1280_glue.h
> +++ b/include/crypto/morus1280_glue.h
> @@ -1,15 +1,10 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> +/* SPDX-License-Identifier: GPL-2.0-or-later */

Shouldn't this be: /* SPDX-License-Identifier: GPL-2.0+ */ ?

At least this is the form documented in Documentation/process/license-rules.rst:

" License identifiers for licenses like [L]GPL with the 'or later' option
   are constructed by using a "+" for indicating the 'or later' option.::

      // SPDX-License-Identifier: GPL-2.0+"
