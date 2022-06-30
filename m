Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F066C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 30 Jun 2022 07:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbiF3HXt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 30 Jun 2022 03:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiF3HXs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 30 Jun 2022 03:23:48 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA132B277
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 00:23:47 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g20-20020a17090a579400b001ed52939d72so1916859pji.4
        for <linux-crypto@vger.kernel.org>; Thu, 30 Jun 2022 00:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=kPj3DJDPahvvDxF0DURO3tVx6ujFEvydZkmaEtn28Rg=;
        b=QaORBQDDJbzqP4G6eVt9wELj+P4mgfHQNbLnVJgBIr0oOT2IpfcB69NR4a8tF0lLlm
         xIo3PekLAOXHFpK5nvAyRJ9SFX7IncdUll2plBAhu2VUIzOxIjU2WrVQR3g0J/Q1G+XP
         E1XgCr4X7QjaSDCnQhaDjlU6yqNeqktMMAeBVqXDzofKyQJysj/hjACRLJdcCYZyMLNA
         HSME5+ytZjhdNCmisSCGj6yLEPy/G1qRQutlUhWqBu/QxP5DzHZuzkXWsJj0wKI3DRKq
         dHBSe4L7BjyKabfr4OV1WLA4Q1ifFMQpKL7gOZc9zPHNRUn19foJrvOGYg6ISHcA//4H
         qvaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=kPj3DJDPahvvDxF0DURO3tVx6ujFEvydZkmaEtn28Rg=;
        b=htQUkx5JEUk9/XhleRVkjtjp1y+0rp0q54JamUwounNLb635nKQ0xnjb0r3v8TjwXw
         N44+3NUZTYz8ayUlV9Y0h+lf1lZLz7D9GQcNuEs5pOMWRCt/5iIpG+R02uk11GnqP7Mu
         9H9/mFAonp7Vk6t//HMrmTHCn5RKEFUdCDmJ1HOHyln1bt4i7Ll47QCbTlKGHk0eo09L
         +e9XKqYp3yobfA8yfypBIpW4yJ+dkpYC79ajWAzw4sxR57S26RK2xyuWyiBpn4TONPWR
         W+kdvgJscXGzzfLFh9wWx1WQqS7TFmg9wFdkSeql21fkUNPTBAQ4Ub9CfWJsQJqOKmml
         cZSQ==
X-Gm-Message-State: AJIora9DjGz0aNygJybHhzx0NietTfD+Sa+9+WxtWOUkHw57SBCmh6mV
        wR/7rIdfm/rkaAYYNPfg9HXxPQ==
X-Google-Smtp-Source: AGRyM1vf2H5neloO5d3aKoFxRUFceQx95p3IxJsndYQCU7U17oceCA7Hfne4ZjMjm8r2qoDz4TLHiQ==
X-Received: by 2002:a17:902:d706:b0:16b:960e:e689 with SMTP id w6-20020a170902d70600b0016b960ee689mr10659856ply.24.1656573827047;
        Thu, 30 Jun 2022 00:23:47 -0700 (PDT)
Received: from ?IPv6:fdbd:ff1:ce00:422:15e6:97a:66d6:17ac? ([2404:9dc0:cd01::a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7960d000000b00525161431f5sm12758307pfg.36.2022.06.30.00.23.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jun 2022 00:23:46 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [External] [PATCH v2 0/4] virtio-crypto: support ECDSA algorithm
From:   Lei He <helei.sig11@bytedance.com>
In-Reply-To: <Yr1JvG1aJUp4I/fP@gondor.apana.org.au>
Date:   Thu, 30 Jun 2022 15:23:39 +0800
Cc:     Lei He <helei.sig11@bytedance.com>, davem@davemloft.net,
        dhowells@redhat.com, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        berrange@redhat.com, pizhenwei@bytedance.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C7191BC8-5BE0-47CB-A302-735BBD1CBED0@bytedance.com>
References: <20220623070550.82053-1-helei.sig11@bytedance.com>
 <Yr1JvG1aJUp4I/fP@gondor.apana.org.au>
To:     Herbert Xu <herbert@gondor.apana.org.au>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> On Jun 30, 2022, at 2:59 PM, Herbert Xu <herbert@gondor.apana.org.au> =
wrote:
>=20
> On Thu, Jun 23, 2022 at 03:05:46PM +0800, Lei He wrote:
>> From: lei he <helei.sig11@bytedance.com>
>>=20
>> This patch supports the ECDSA algorithm for virtio-crypto.
>=20
> Why is this necessary?
>=20

The main purpose of this patch is to offload ECDSA computations to =
virtio-crypto dev.
We can modify the backend of virtio-crypto to allow hardware like Intel =
QAT cards to=20
perform the actual calculations, and user-space applications such as =
HTTPS server=20
can access those backend in a unified way(eg, keyctl_pk_xx syscall).

Related works are also described in following patch series:
=
https://lwn.net/ml/linux-crypto/20220525090118.43403-1-helei.sig11@bytedan=
ce.com/

> Thanks,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

