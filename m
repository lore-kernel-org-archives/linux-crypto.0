Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6377DC433FF
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 15:01:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 352DC20C01
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 15:01:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="SBHVFkT0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733114AbfHFPBD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 11:01:03 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35396 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732976AbfHFPBC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 11:01:02 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so7674pgv.2
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 08:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:from:cc:to:user-agent:date;
        bh=Eb02brmqmP+bKn8o/CtSlhtLL2DjYzWXI1dJoOmHVws=;
        b=SBHVFkT04CnXj2BzqKjwe15XXW+whxMdICKRznLSFSSDLqu/XcqTiMcL3OlDamrzbi
         wrXD0KtHM3gbNfHtiHorbQ5EXVuXky4q/SuT1jGnUelEQECP0tNPHCuRwvIdol8jaCln
         ZLdL3bwpiool6mLFTfz5u4UHCWCPxVGbsYG60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:from:cc:to
         :user-agent:date;
        bh=Eb02brmqmP+bKn8o/CtSlhtLL2DjYzWXI1dJoOmHVws=;
        b=MEuPk3mIgYPzD2QGHyd4bB+fqL3lso3iMueYrD1mEqMF3eAMCn0UY3/HFfGtf8TIkn
         P8EC5z2MPZ1/i6Sex3aIVlfMZtd/Ai1ULtUyKSlftpBuV3HCEhRbOmmHbxJ2xhk3ZxNH
         DFLut/RB8xTuQGCxsAkKr7eicRYh0o+ksQ9oZdqbIzXZxq9nHssjaXyvV//pIHaWOTb+
         MQaeV7norh0n1pdw5WKd5hCykU9bP0fZdngiJySMJMY1AjrTTgpy/X345KgO7w6nJu7b
         ZfOOaQfgl1Fy2G88FG1dgEOW8unlhubpDowc0eY+JZ5h9mhUYLOKcHtUCxjGcfOBAzdg
         hJfQ==
X-Gm-Message-State: APjAAAWyqdksZa6yOgaatsDbi4ijQy/0q2Sz9AtNCx+gCHuCmGX2BwUa
        UuQBOc7lFcl9Ze6sO1vRJPEkXw==
X-Google-Smtp-Source: APXvYqwDRt60hsXVQabJLS4rgQ72yXCj7Ne3Ts2ec9WePAq9tfC3jtA2eAeI3eEjWxFyxqb4+7eRyg==
X-Received: by 2002:a63:2004:: with SMTP id g4mr3265246pgg.97.1565103662068;
        Tue, 06 Aug 2019 08:01:02 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id o14sm18400492pjp.19.2019.08.06.08.01.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 08:01:01 -0700 (PDT)
Message-ID: <5d49962d.1c69fb81.6e0a5.148a@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190805233241.220521-1-swboyd@chromium.org>
References: <20190805233241.220521-1-swboyd@chromium.org>
Subject: Re: [PATCH v3] hwrng: core: Freeze khwrng thread during suspend
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andrey Pronin <apronin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Alexander Steffen <Alexander.Steffen@infineon.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
User-Agent: alot/0.8.1
Date:   Tue, 06 Aug 2019 08:01:00 -0700
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Stephen Boyd (2019-08-05 16:32:41)
> The hwrng_fill() function can run while devices are suspending and
> resuming. If the hwrng is behind a bus such as i2c or SPI and that bus
> is suspended, the hwrng may hang the bus while attempting to add some
> randomness. It's been observed on ChromeOS devices with suspend-to-idle
> (s2idle) and an i2c based hwrng that this kthread may run and ask the
> hwrng device for randomness before the i2c bus has been resumed.
>=20
> Let's make this kthread freezable so that we don't try to touch the
> hwrng during suspend/resume. This ensures that we can't cause the hwrng
> backing driver to get into a bad state because the device is guaranteed
> to be resumed before the hwrng kthread is thawed.
>=20
> Cc: Andrey Pronin <apronin@chromium.org>
> Cc: Duncan Laurie <dlaurie@chromium.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Alexander Steffen <Alexander.Steffen@infineon.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---

Sorry, forgot to add

Fixes: be4000bc4644 ("hwrng: create filler thread")

