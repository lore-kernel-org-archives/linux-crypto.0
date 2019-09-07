Return-Path: <SRS0=JhmS=XC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0DAC43331
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 17:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B59C218AE
	for <linux-crypto@archiver.kernel.org>; Sat,  7 Sep 2019 17:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JIU69Gj2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbfIGRxp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 Sep 2019 13:53:45 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43674 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfIGRxp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Sep 2019 13:53:45 -0400
Received: by mail-wr1-f65.google.com with SMTP id q17so4931963wrx.10;
        Sat, 07 Sep 2019 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YKzGXNoMiVxlqUxjXu5q/1sB2Sa9HHIsJwOXqdFSK2c=;
        b=JIU69Gj2coPhLQ8h1Nf0FifUpIaP/2YUh/DZqI+EYnKebBIjEvpNnmE2atBKfaDgr1
         dIL0Oi7VSCbGp0Fh2AR9sHkXMfWxl1IcAj5ncZZhah1yhDiTdwF4XoEWqh4zCzl5ecYY
         QdkQGYPUNcztydTqmwakzmdMhvRp7CufSU7jvpqlZp7W6hPTn9+bC3aZW150tI0awCXW
         P22JNJcg6l25VlJEAEajstYzekutPS6SlHe6B/31RlCjw5d/1HTSCZ/6e5bIt5/QKKeb
         h38iCIFUM/84QaD5YqDhAVu4V+t/p6Sk6ZENpp4z5SIrJFfK9VqFlv0vmwnQMMfM0Clo
         Ob7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YKzGXNoMiVxlqUxjXu5q/1sB2Sa9HHIsJwOXqdFSK2c=;
        b=uAzLsUWpkYSLCcYA/r+oCbSyRlogLmcAPkVeBjLZQtFv1D0myYCauDyxaphXOZgqYY
         QMqckA6rPKzDPGoTV7hA6arO7z/HFA/bGz7cygH0s61zhfLu3X5jn6O01m8aekyNoWGW
         Qn09DjcsgD49rcs4aqEp3y/vVPE44nYySec654XnyHnkWfn3d8ixQfnRBisLcX13ucvM
         x5y7AqsKwrq73kkGoujQo1Vg/Y8xlq4nuhyyedohWLHpLfiZveCwIvtoM9U4DUhEK6wa
         hQff0cQlFocZk5D7kcS3qG7JhFAH5mpBgw4P0eJtUZPMV3+BZxu3JWSuz/dQeJaSaRm+
         EiGQ==
X-Gm-Message-State: APjAAAXzRbqWXrKlOD4vtX8kqBlepjmeNGYqI4vJ7ycjMQAFunjlPE25
        56OwuTRxS41OzjYjHo/ofis=
X-Google-Smtp-Source: APXvYqwON0QZyTc/slBAnXZF2MVpu7fDOpaczP7dIghDSrGZbOPHtlEMfx9Sldugsdu+L5p1uFGQjQ==
X-Received: by 2002:a5d:6585:: with SMTP id q5mr11363959wru.162.1567878822899;
        Sat, 07 Sep 2019 10:53:42 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id p23sm5778566wma.18.2019.09.07.10.53.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 Sep 2019 10:53:42 -0700 (PDT)
Date:   Sat, 7 Sep 2019 19:53:40 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 1/9] crypto: Add allwinner subdirectory
Message-ID: <20190907175340.GA2628@Red>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-2-clabbe.montjoie@gmail.com>
 <20190907035453.urfqmdg3kg4kbtgc@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907035453.urfqmdg3kg4kbtgc@flea>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 07, 2019 at 06:54:53AM +0300, Maxime Ripard wrote:
> On Fri, Sep 06, 2019 at 08:45:43PM +0200, Corentin Labbe wrote:
> > Since a second Allwinner crypto driver will be added, it is better to
> > create a dedicated subdirectory.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  MAINTAINERS                      | 6 ++++++
> >  drivers/crypto/Kconfig           | 2 ++
> >  drivers/crypto/Makefile          | 1 +
> >  drivers/crypto/allwinner/Kconfig | 6 ++++++
> 
> I guess it would make sense to move the sun4i driver there too?
> 
Yes it is planned.
I will add this move patch in the next iteration.

Regards
