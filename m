Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAC53C54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 21:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbiI0VSc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 17:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiI0VSa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 17:18:30 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C74F1E45AE
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 14:18:27 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id p5so12280596ljc.13
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 14:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=OmYNRzFMKJg0OyAuB77/XhpBp7MwX4VcB6Kd+dpdO80=;
        b=r/Mgw0A7OEw2ux8sKiYHHQX7y4wneOmkxesB+/JrmX2qUr8uUbmtoklbhn1owvSkv+
         2DXf7JtXwyU8AQhGpBIKzxyy+vRT+j+W1BbxhJJUbe38QwXAA0Kg6d6yYcm5Zl8Ve8oh
         g1kWtNyo1FIkaqVc6DLa+BGXl2mamOwnNN+NA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=OmYNRzFMKJg0OyAuB77/XhpBp7MwX4VcB6Kd+dpdO80=;
        b=Fq2kVyN8yQPjr6o6ufaqRXeTn4eJFbxxXDaxcbdpM44TMZ5Z/ZTfoYaVxEaARP3DOQ
         SiTC9EEDoWl8HBFASJpMUFPRY/5YcKm6eX29G6L3iYnvpC4YqlBBweJszfBNTFV1UPkV
         UvDsPFGqaevysgRQFvbrsxQdCHNIQ0EB80VznWvySOc7VYj8e6jt1fKMejBUc5tf/eZQ
         MqjR604kl5c1asTlIT2yO5VudohfpnFk8pbiTkEZPe1Ivzpw0VxWuZ1+Aeri8Q0n+WZ3
         qRKVl+I/6NrksxKyALgJGjLULMaBCBJ3tiz7+beIcDqz2VF7pjKzMIZp8m7tyw4v/XPh
         kXdw==
X-Gm-Message-State: ACrzQf1MBln8Aye2HA9V9/mFmFWB9XqaU+8TH4jeyTJ4VTbPuS1zZirw
        gAWcZ0Oko/gcTtKJy2dnbCj1hVRfgheGpFMRldQaXQ==
X-Google-Smtp-Source: AMsMyM5dzzDbnjhYYT7fA5GWa++PnB2rHG64xmcsP0eoUowqUv5Pl9QK2szq2+7eaiwYPLfXSWcLrHxSWdOchBXWIY4=
X-Received: by 2002:a2e:be24:0:b0:26d:9942:dfe with SMTP id
 z36-20020a2ebe24000000b0026d99420dfemr4405229ljq.16.1664313505235; Tue, 27
 Sep 2022 14:18:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220908200036.2034-1-ignat@cloudflare.com> <Yy6wqqVpUCeQKrdh@gondor.apana.org.au>
In-Reply-To: <Yy6wqqVpUCeQKrdh@gondor.apana.org.au>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 27 Sep 2022 22:18:14 +0100
Message-ID: <CALrw=nG3UUL9e37AnFq3Q25-ApW+EHAfWNJDw+pwE0vNLUtxrA@mail.gmail.com>
Subject: Re: [PATCH 0/4] crypto: add ECDSA signature support to key retention service
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Howells <dhowells@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        lei he <helei.sig11@bytedance.com>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 24, 2022 at 8:24 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Sep 08, 2022 at 09:00:32PM +0100, Ignat Korchagin wrote:
> > Kernel Key Retention Service[1] is a useful building block to build secure
> > production key management systems. One of its interesting features is
> > support for asymmetric keys: we can allow a process to use a certain key
> > (decrypt or sign data) without actually allowing the process to read the
> > cryptographic key material. By doing so we protect our code from certain
> > type of attacks, where a process memory memory leak actually leaks a
> > potentially highly sensitive cryptographic material.
> >
> > But unfortunately only RSA algorithm was supported until now, because
> > in-kernel ECDSA implementation supported signature verifications only.
> >
> > This patchset implements in-kernel ECDSA signature generation and adds
> > support for ECDSA signing in the key retention service. The key retention
> > service support was taken out of a previous unmerged patchset from Lei He[2]
> >
> > [1]: https://www.kernel.org/doc/html/latest/security/keys/core.html
> > [2]: https://patchwork.kernel.org/project/linux-crypto/list/?series=653034&state=*
> >
> > Ignat Korchagin (2):
> >   crypto: add ECDSA signature generation support
> >   crypto: add ECDSA test vectors from RFC 6979
> >
> > lei he (2):
> >   crypto: pkcs8 parser support ECDSA private keys
> >   crypto: remove unused field in pkcs8_parse_context
> >
> >  crypto/Kconfig                        |   3 +-
> >  crypto/Makefile                       |   4 +-
> >  crypto/asymmetric_keys/pkcs8.asn1     |   2 +-
> >  crypto/asymmetric_keys/pkcs8_parser.c |  46 +++-
> >  crypto/ecc.c                          |   9 +-
> >  crypto/ecdsa.c                        | 373 +++++++++++++++++++++++++-
> >  crypto/ecprivkey.asn1                 |   6 +
> >  crypto/testmgr.c                      |  18 ++
> >  crypto/testmgr.h                      | 333 +++++++++++++++++++++++
> >  include/crypto/internal/ecc.h         |  11 +
> >  10 files changed, 788 insertions(+), 17 deletions(-)
> >  create mode 100644 crypto/ecprivkey.asn1
> >
> > --
> > 2.36.1
>
> I need acks for patches 3-4 from David.  Thanks!

Should I resend patches 1-2 here and maybe 3-4 to the linux-keyrings
mailing list?

> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Ignat
