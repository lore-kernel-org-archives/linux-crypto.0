Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD972C04EBD
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 16:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 76205205F4
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 16:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LNPKtxV6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76205205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbeJPXzX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:55:23 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42052 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbeJPXzX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:55:23 -0400
Received: by mail-ot1-f65.google.com with SMTP id c23so21288007otl.9;
        Tue, 16 Oct 2018 09:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FDLZo9l/xRzePUe8QmqWdaAbSy5V7DikxcBpS9I/SUY=;
        b=LNPKtxV6m4kl2I0rTuoD+y9FWsJwxBK/naWTBpZQKmLxfZevu26TP4C0pO6tKQINDt
         CIyRHq/QwI+lq1MIUOWPOSPepsnB93l2YqHL8FdVfDoQXSfHGl5/ntfhEectQjAGxbzn
         RCkGbaKzXFm002mZ2NLIoL7tQMtinKR6AihJ/s4XDFSrbXIsW++ZC3zi2jbdQcfl7m/+
         2CIWzZb2M0/7ghpewP0uwd6P8VIFFCvyPH7/4/kwg2O+sjYfFUmWf7D9nBUafxrg98/O
         ugHhM5I87GpeUaDhK68iR+0Ou1MCDtWEKJjYUXYwbevvA+q7b7hvrHcaeo++o7JQTypS
         SPfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDLZo9l/xRzePUe8QmqWdaAbSy5V7DikxcBpS9I/SUY=;
        b=cHr4gD2xjx+9MUBi74UX16e+LhhENSZ0ydGPiDNAmzTs0h/cqcCiiukpRxcTtd0cs4
         nizSOIjWgq3uySYKIa2fzd5gl1hIL3SSNGvHZdOE6Q1sR5xzqBPCU9oQTScrZSKeo3a0
         I8pIF4rHKXJ6pJUGpTM3pEmFgvfDdjYDUBub6Bxns+zgqkA37Eg+zkvusooF4z8qVDqu
         clSTUt1HWfPZx8ldDCFA9idiWpRV1Hirmv9RCyaUbQ+oKM+wnvC70g3aBJ3fcMps8yLQ
         nhBErP3Qpg/TgsJQ8Cm2DSU4h+OiZBNVNIK2QGHQWtKmfXJANWxi5rIJwC6cSp33ibUC
         lBXg==
X-Gm-Message-State: ABuFfohsbdNTBuG39NbahCDU+l4EvvNcpEVqfL6hgb9zs+gzFpDm2b0/
        aIDo0PGaJ/gqVju5BQRxjPMOdBe6Yy2kGQLizrsOrg==
X-Google-Smtp-Source: ACcGV60zm5KdcsZ7+NQhqCyCd4MZ4INfG/F5DqDaYMPULicb4rHDwPfMxgkGplN8f//QThU/Jo9JNMUQCsG24r1E/UE=
X-Received: by 2002:a9d:5122:: with SMTP id c31mr3914017oth.255.1539705856346;
 Tue, 16 Oct 2018 09:04:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539705285.git.leonard.crestez@nxp.com> <ef03e230d0bb76d830c123bc47e6bd6e7bf17826.1539705286.git.leonard.crestez@nxp.com>
In-Reply-To: <ef03e230d0bb76d830c123bc47e6bd6e7bf17826.1539705286.git.leonard.crestez@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 16 Oct 2018 13:04:24 -0300
Message-ID:
 <CAOMZO5A+Uc5in-PXnfe+XoFMtRmCxGOryXE9=mjB+aRHo+ZBEQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] ARM: dts: imx6ull: Add dcp node
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016160424.EgjG7iJyNgvKZNxwSPiZq9MK1-T1JCdR58FdQKbZ90Q@z>

On Tue, Oct 16, 2018 at 12:59 PM Leonard Crestez
<leonard.crestez@nxp.com> wrote:
>
> The DCP block on 6ull has no major differences other than requiring
> explicit clock enabling.
>
> Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>

Reviewed-by: Fabio Estevam <festevam@gmail.com>
