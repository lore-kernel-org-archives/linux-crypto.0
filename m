Return-Path: <SRS0=YnV0=NF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 026CBC46475
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Oct 2018 15:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A175720834
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Oct 2018 15:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="uAjDZ6G0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A175720834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbeJZAS7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Oct 2018 20:18:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbeJZAS7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Oct 2018 20:18:59 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93B6A2085B;
        Thu, 25 Oct 2018 15:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540482338;
        bh=s5ORNzyjhQwRuAcy+X8ueZL9DxX3TcueONuZcBa6o9c=;
        h=References:In-Reply-To:From:Date:Subject:To:From;
        b=uAjDZ6G08RDf9NOMreAXGaJXpYRLojrK6F8uoA1kvNR8u7fgZF/gDtzOl1kMlb1ky
         7+zoq4PwJEyaJeIAktMgOZUGfGDW7eecuDZ72Lo/RgcBZxK8c3MNp3+wcun/DIs8KI
         uaLgxYHr/Icl7P16lkUJAaC/+NioHp5hY/RRDSb4=
Received: by mail-qt1-f176.google.com with SMTP id p24-v6so4479699qtq.0;
        Thu, 25 Oct 2018 08:45:38 -0700 (PDT)
X-Gm-Message-State: AGRZ1gJtWTmA+pVf47Lyd0W2U8hcyPsjCzRxyx3yw53CMmsvq0Owno1c
        tEWs0c6PrNPe+KXs+KtbyqUe5kfaeknogMYYIg==
X-Google-Smtp-Source: AJdET5f++OqiyIovvsYh3/noYpbuSvCdh1UgH0Dy4lkrXNuTFD2IoCTb5HZDD1pon95cvIeLUkHCT2RB6f0c8ww+3aI=
X-Received: by 2002:a0c:8c86:: with SMTP id p6-v6mr2078232qvb.246.1540482337738;
 Thu, 25 Oct 2018 08:45:37 -0700 (PDT)
MIME-Version: 1.0
References: <1539789476-6098-1-git-send-email-anilc@codeaurora.org>
 <1539789476-6098-4-git-send-email-anilc@codeaurora.org> <20181025145548.GA30244@bogus>
 <20181025152856.GD4970@thunk.org>
In-Reply-To: <20181025152856.GD4970@thunk.org>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 25 Oct 2018 10:45:25 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+26Avcb2cQHKKAnrf=H4J=jMfv6sxsqxdMnFZMUdUDLA@mail.gmail.com>
Message-ID:
 <CAL_Jsq+26Avcb2cQHKKAnrf=H4J=jMfv6sxsqxdMnFZMUdUDLA@mail.gmail.com>
Subject: Re: [PATCH 3/3] crypto: qce: ice: Add support for Inline Crypto Engine
To:     "Theodore Ts'o" <tytso@mit.edu>,
        AnilKumar Chimata <anilc@codeaurora.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "open list:ARM/QUALCOMM SUPPORT" <linux-soc@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181025154525.BnpsV1ZQYyE4KtdPGp5ve9JBz_jMfB7n5mO1e2bR4X8@z>

On Thu, Oct 25, 2018 at 10:29 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Thu, Oct 25, 2018 at 09:55:48AM -0500, Rob Herring wrote:
> > > +Introduction:
> > > +=============
> > > +Storage encryption has been one of the most required feature from security
> > > +point of view. QTI based storage encryption solution uses general purpose
> > > +crypto engine. While this kind of solution provide a decent amount of
> > > +performance, it falls short as storage speed is improving significantly
> > > +continuously. To overcome performance degradation, newer chips are going to
> > > +have Inline Crypto Engine (ICE) embedded into storage device. ICE is supposed
> > > +to meet the line speed of storage devices.
> >
> > Is ICE part of the storage device or part of the host as the binding
> > suggests?
>
> My understanding is that for this particular instantiation, the Inline
> Crypto Engine is located on the SOC.

Mine too, but that is not what this doc says.

> However, from the perspective of generic kernel support, the inline
> crypto support could be implemented on the SOC, or in the host bus
> adaptor, or as a "bump in the wire", or on the storage device.  And
> whatever abstract interface in the block layer should be able to
> support all of these cases.

Yes, certainly.

Rob
