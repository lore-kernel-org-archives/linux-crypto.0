Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04FDFCA0ECD
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Sep 2023 21:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353873AbjIKVvV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Sep 2023 17:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbjIKNG6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Sep 2023 09:06:58 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C413DE6
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 06:06:52 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-68fb71ded6dso860291b3a.0
        for <linux-crypto@vger.kernel.org>; Mon, 11 Sep 2023 06:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1694437612; x=1695042412; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:reply-to:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UC0qFPbWeIAnNY2crnDoiyfH4L4DNcPUzmyIOiPmNaw=;
        b=Nc6pxsYSDhU2XR53fLm2q5bivwl1huFVoTDg52/c4uVC1Q4RiQ9q9g2QPkMnMqN1GQ
         GEfauhXqPUBDQrQ7zcalT/yhOgzL0HpEKL9zCTmpcfSuu/mP/88A2Y+RUrkrAIJKwBc4
         NdR2ope/qfoBVlSMEoY1fdLB6yMzojnmYkS6EVoWtMlj3v6aghj8Rz3ZUWCtI/yVuVvi
         BjkLg7tWsdLgdn/dNFG2F/WTdDXNneYDwtjYBl28sHRtlEGrN+1J/w+dAkLMwUVPOG2W
         oWFcmsPw0V6g9Jg2VMirRPPxKVtm+ieF5yM5hy9zQB6QQ6quIRxLhND/+xRnaX7QaIJm
         cPOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694437612; x=1695042412;
        h=to:references:message-id:content-transfer-encoding:reply-to:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UC0qFPbWeIAnNY2crnDoiyfH4L4DNcPUzmyIOiPmNaw=;
        b=AzDAkWa/WGjKdU5Ih/icBBug4eMW/Lqi54sFNmATSZRDzovJJ1fvtYgXS78LT5J7H6
         PDOyTOr+QdvWmonUoMoB5rz553CbftoVez3Cqr81sf6GH28hyX1TQLJZ+0fE8qgLesZo
         CjSY1/9aG+ugmJwN4JQiasb+HqjvXXEZaalL2vOkQ1mz9PZ5AxkV81F9Uu80YxjAEogB
         aBCseh0g/Q6msGkr8hPovwizFXM5QydZoTxn2kCsPgc3c0qW1r73aV8ubVdIm6HucpyA
         zBYqHuEW/6vL916pxlRJ7yXw7HgL+vlsKaurFi+6mf6qcIuzyRMQxsW6+C+T4uJYmt37
         g/fg==
X-Gm-Message-State: AOJu0Yz2n0qrSN8Lf/4r/3j+FTGPKUuuqLS4ZKMRx0HvpNeXBP4TfN8M
        jpUclwhgzOIaMPFZ8sZj/FhUHw==
X-Google-Smtp-Source: AGHT+IHHHsd8mK5/qRvQGb/rxDKfPMV90hFOs3PpoPszjaiqIs9Gy83oAs6eYTFLtxvjaV6gsb9LYA==
X-Received: by 2002:a05:6a00:22c2:b0:68e:2c3a:8775 with SMTP id f2-20020a056a0022c200b0068e2c3a8775mr9544336pfj.33.1694437612188;
        Mon, 11 Sep 2023 06:06:52 -0700 (PDT)
Received: from ?IPv6:2402:7500:4dc:9c7e:4872:7ce3:318e:18f5? ([2402:7500:4dc:9c7e:4872:7ce3:318e:18f5])
        by smtp.gmail.com with ESMTPSA id s21-20020a62e715000000b0068991abe1desm5787400pfh.176.2023.09.11.06.06.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Sep 2023 06:06:51 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.7\))
Subject: Re: [PATCH v4 10/12] RISC-V: crypto: add Zvkned accelerated AES
 encryption implementation
From:   Jerry Shih <jerry.shih@sifive.com>
In-Reply-To: <20230721054036.GD847@sol.localdomain>
Date:   Mon, 11 Sep 2023 21:06:47 +0800
Cc:     Heiko Stuebner <heiko@sntech.de>, palmer@dabbelt.com,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        conor.dooley@microchip.com, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        christoph.muellner@vrull.eu,
        Heiko Stuebner <heiko.stuebner@vrull.eu>
Reply-To: 20230721054036.GD847@sol.localdomain
Content-Transfer-Encoding: quoted-printable
Message-Id: <CCA32056-CCE2-4FB5-8CFC-62444CDDA89F@sifive.com>
References: <20230711153743.1970625-1-heiko@sntech.de>
 <20230711153743.1970625-11-heiko@sntech.de>
 <20230721054036.GD847@sol.localdomain>
To:     Eric Biggers <ebiggers@kernel.org>
X-Mailer: Apple Mail (2.3445.9.7)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Jul 21, 2023, at 13:40, Eric Biggers <ebiggers@kernel.org> wrote:

> I'm looking forward to having direct support for these AES modes, =
especially the
> modes needed for storage encryption: XTS, and CBC or CTS!  None of =
these AES
> modes is actually implemented in this patch yet, though, so they can't =
be
> claimed in the kconfig help text yet.  This patch is just a starting =
point, as
> it just adds support for the bare AES block cipher ("aes" in the =
crypto API).
>=20
> (BTW, I'm much more interested in, say, AES-XTS support than SM4 =
support, which
> this patchset does include.  SM4 is a "national pride cipher" which is =
somewhat
> of a niche thing.  I suppose there are already people pushing it for =
RISC-V
> though, as they are everywhere else, so that's to be expected...)
>=20

We have further optimization for RISC-V platform in OpenSSL PR[1]. It =
will include
AES with CBC, CTR, and XTS mode. Comparing to the generic AES =
implementation,
the specialized AES-XTS one have about 3X performance improvement using
OpenSSL benchmark tool. If OpenSSL accepts that PR, we will create the
corresponding patch for Linux kernel.

[1]
https://github.com/openssl/openssl/pull/21923

-Jerry
