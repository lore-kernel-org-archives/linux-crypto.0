Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D99C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 08:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8D91218A5
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 08:08:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OoOli8X+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbfCOIIz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 04:08:55 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:39396 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbfCOIIy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 04:08:54 -0400
Received: by mail-oi1-f196.google.com with SMTP id b4so6615033oif.6
        for <linux-crypto@vger.kernel.org>; Fri, 15 Mar 2019 01:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7WQoXypAXrxybsmQKtSam1AksL633abiOo+v7tB9icc=;
        b=OoOli8X+AjcDBY/pignwFI1RAA/JcTstIp2mVK8arIpkznltMOuelK/K2h6dN8dZcd
         yJ9uF6W2lVSvPpOqxq6LWGIdOkiurIaX9p0i7UYuh40F/z7lvyt4vxfqEut6SnbktxMo
         9gdT5UAjFBMd26mGuImxOKlq1f2UfqKPxPTjwk/8Wqi8jTbsLPfCCZt3Z1BNAl2UH7X5
         kcOlEI0dw6JDN3pyisEVknZnLziH46GqYyMoGPLh1FLqRpKWzzeARgcnqgL+7Lgt9TiA
         UZ9lBGG2V13S3H4Dw+WQR38qlzlROOMNyOgsipa36M7MDBhnPiMmYYjNdYUmRa2rp/qY
         rChQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7WQoXypAXrxybsmQKtSam1AksL633abiOo+v7tB9icc=;
        b=Yb4EpvPlD+PJTLbTbHo9Jvs273+xNOAspmg0qjNPka7KHediBEbeFG5MuPFCWp7rk3
         bWxbe1cTNrW9H0KTHFDAyEO3pchnJLwkezz4797OnGJpw4IOUs0w5vVUQDHjg3WBuaFU
         ++aCYQXMAvkvHqFK+fbrmbrdomPwywGfAjJ0ytYZX2r9iA4iZbrjH2e5ZRtZqxzkXB4N
         NRUJiwv4AMMbLyPqNayEo1azVPN9BQPtE7QQsvAzEEny7cNBTBsqrY8Tg+9pI4aFdMr2
         jFrTemCKU2PQFbdGXgoZgxU7I+3SXG67e38rmGbwUcprCxxNrC5vFEIRM2XxugMKO7Kw
         J2LQ==
X-Gm-Message-State: APjAAAU+KWDMkK1N3Cq2reBUCyRIKfkWRHqhROhEAFug/X7rrtANLisy
        XbtPBcTv6WPpYik/H44zF3mibP3zmGZfRcnkCMBRqg==
X-Google-Smtp-Source: APXvYqwD9/V79jVE6AWGOYI7YpP5atpGo/lt/mCJGIGvQDCiaVnT4fXCq5oqkOzrmht8+JTjoN3DJr7nuRHVX45Zft8=
X-Received: by 2002:aca:bc0b:: with SMTP id m11mr777925oif.41.1552637333930;
 Fri, 15 Mar 2019 01:08:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190315040239.24705-1-vakul.garg@nxp.com> <20190315040239.24705-2-vakul.garg@nxp.com>
In-Reply-To: <20190315040239.24705-2-vakul.garg@nxp.com>
From:   Chris Spencer <spencercw@gmail.com>
Date:   Fri, 15 Mar 2019 08:08:42 +0000
Message-ID: <CAGUNXRRPMwQJ4Zx_1z0k52Ri2sZQTsYVTZztkVrdbrSvRm9AHg@mail.gmail.com>
Subject: Re: [PATCH 1/3] crypto: caam/jr - Remove spinlock for output job ring
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vakul,

On Fri, 15 Mar 2019 at 04:05, Vakul Garg <vakul.garg@nxp.com> wrote:
> For each job ring pair, the output ring is processed exactly by one cpu
> at a time under a tasklet context (one per ring). Therefore, there is no
> need to protect a job ring's access & its private data structure using a
> lock. Hence the lock can be removed.
>
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>

This comment in caam_jr_dequeue doesn't really make sense anymore:
/* Stash callback params for use outside of lock */

Since the lock has been removed you could probably get away with just
invoking the user callback immediately which would simplify the code a
little.

Thanks,
Chris
