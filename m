Return-Path: <SRS0=Ahx1=BA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656DCC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 12:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36C7620717
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jul 2020 12:35:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vLLnf6t5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgGUMfz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jul 2020 08:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbgGUMfz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jul 2020 08:35:55 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AE92C061794;
        Tue, 21 Jul 2020 05:35:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b9so10209140plx.6;
        Tue, 21 Jul 2020 05:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gCQik/w6NvDdgNRdHXsXwHB1wNmqYh2Zx4LCsjaGWiI=;
        b=vLLnf6t5/T2tqBlgQAYehbNEpNHSpijVkc2zu4ZRcx6T+cMqS1wGL9f9IP4ap4t2fM
         M06DIM+6dvXOmdBK0DXen4OMwV4f/OcLYpz6SvRPUTf49H4Y8e3bzAwJvkaudVxw13/v
         SottDmIgB1aI6EoJY7Ms5Z5Je4IMhECiSBxiiwKOB7TXK3sbdnvIxYHaVkQZO/gIgrZ9
         rgPUBBwsUqVPIer8GXRJ2zLe2OPjG2Mby4hY1ZjMmo2RYjNEBnhhB9wQqu6Rf1oUGgJ3
         jEBTWGfAa9i6z1WhkRIVdxzal18h9RxddQb2K1+EVyq59E1eMRPmT/sRFIPr/e9hK9LH
         gWhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gCQik/w6NvDdgNRdHXsXwHB1wNmqYh2Zx4LCsjaGWiI=;
        b=TJF+iQrJeMoqogcymYAPr6tcJj1PczegZZcHBimyvArSeYBIGW6JuZjYU6FQl+NIR5
         gr1ZduMsh1YCRMwum2ClDEiBSkcSCkJDIaIm/13+Gz2TVlgoO1rUrn2vCOhGMV9ehczC
         tuq9TQ/GKZ9YQqerbyFuw+GQHafaJDGz9vaDoksGajnC4aSQhZjtTcTVso32AhEze8oF
         pq7HxlYEZb5/bFZ/6SgBgZYPYdpk4W+0wBivxUEq2xlcybwyxZlxuE77AyPFTlCBdjb2
         Pcs4y74SwotQL/M/XpXMlMzeAlzQlDP6e9tnrXkDWY8ZVt4bPAa/1uEHUhiS9O/l3zT/
         rjjA==
X-Gm-Message-State: AOAM532LCRcCX7wSENN9YRPrPBFaWvEOKwP5/eQhjbliOyvVEfw6xXz2
        zLhFuxdtL0tsacpPEw430xU=
X-Google-Smtp-Source: ABdhPJymd9DtK/2SkX4MtHN9+uSyoq9kDhMgE8/1XnEKsQ9TtAeeFWXz2uSNqVGGr3IdOKocLxm7zg==
X-Received: by 2002:a17:90a:750:: with SMTP id s16mr4534280pje.218.1595334954155;
        Tue, 21 Jul 2020 05:35:54 -0700 (PDT)
Received: from gmail.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id j13sm3180858pjz.8.2020.07.21.05.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 05:35:53 -0700 (PDT)
Date:   Tue, 21 Jul 2020 18:04:25 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1] crypto: ccp: sp-pci: use generic power management
Message-ID: <20200721123425.GA81853@gmail.com>
References: <20200721123146.81710-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200721123146.81710-1-vaibhavgupta40@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Patch is Compile-tested only.
