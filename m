Return-Path: <SRS0=IhKu=RA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AEC5C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 14:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE7AE20842
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Feb 2019 14:36:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TdiUoz2q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfBYOg6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 09:36:58 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42754 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727391AbfBYOg6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 09:36:58 -0500
Received: by mail-oi1-f193.google.com with SMTP id s16so7382411oih.9
        for <linux-crypto@vger.kernel.org>; Mon, 25 Feb 2019 06:36:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LE4nFV/lShcG5n6ifHhAC431+DZBJ5evgV6dJi7QG8o=;
        b=TdiUoz2qffaJn/CKFuzjpqjo5DjpdUfce4fJcyF6dqdVbBxTcDIht764WfseUXx0o2
         gTX0w2nV2UabzHl1lw5CoLafk+kb8OGRwXwKxEF5KFKIVi/TJbyAWn4Ot+XoRlGoVDcQ
         HlXGFl8IKFWug8p9SX+aVs8LVjGEuruDbynQ4p00dI5Y0bnPc0dHxDgQhQnWn2Sk5e5j
         JhzeSbiTrX0oyROc49lXlHRZKx4BdVJuoIUMwNgTF4zLOmcfWws/o0l4BGC9cQ+1h6Hi
         khWCdqn56PhM9MT9x0VNN17TbMeG3oCiX6e4KNdOo7W7lfzdbPl+EXEoo5XRXX7wXDp5
         SJCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LE4nFV/lShcG5n6ifHhAC431+DZBJ5evgV6dJi7QG8o=;
        b=mDfNIXWIExmQPpMiZdPns0LIqelOoG9TYSo/8rrHEgaTog9v2d72VPNOEkrtRR+ea8
         YCPiX8J6KNDytLjwEzlSZ+ZEDIO0ocJK3K07Bo4c0IYdf415htIHFGthJAf/0E6a6VEJ
         KIBUjIArvNkIRaURT6/8CO0cWEkJRYpkVFv7aM9US55Gjaudj49JtkfTmPw2r0YQRPlR
         F8+yZgx6jBYVkwUSBBbgNad51Dpwv2h/z9wHBLNdgK/0IkFBTfRE9L/Iq0cs+4IqfkkH
         iFKfClxQ6NLp8jiXnj9rl4tUhi8oAoHUJB0gjm+bJ4dSE1tUFp4RppdobZdRHlbYTZfJ
         M+Bw==
X-Gm-Message-State: AHQUAuaizuiD9lWlbj4dLOrY6BXRm9ygIajPNjdWI6u3sSgMUPtiEbD4
        tm1ajsGrwn/svm4yUbyeaISkDqmv3GR/CxoT+UU=
X-Google-Smtp-Source: AHgI3IaZqxhmZ51CsHCB1seHlHhnheMznNrieMVVUurZUXYWa7vIURRRM7fRRg92O4fGJbENDi4o103TxvGBfcwLSOU=
X-Received: by 2002:aca:a90f:: with SMTP id s15mr11483257oie.42.1551105415307;
 Mon, 25 Feb 2019 06:36:55 -0800 (PST)
MIME-Version: 1.0
References: <20190222100613.2290-1-christopher.spencer@sea.co.uk>
 <20190222100613.2290-5-christopher.spencer@sea.co.uk> <VI1PR0402MB34851F1E7021F16B45F74E55987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34851F1E7021F16B45F74E55987A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Chris Spencer <spencercw@gmail.com>
Date:   Mon, 25 Feb 2019 14:36:43 +0000
Message-ID: <CAGUNXRTvXVU7vRicF=mR7xxCj=p+Sqj3aNnL2TezLZXhHFkvzA@mail.gmail.com>
Subject: Re: [RFC 4/4] crypto: caam - use job ring for RNG instantiation
 instead of DECO
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 25 Feb 2019 at 14:22, Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 2/22/2019 12:07 PM, spencercw@gmail.com wrote:
> > From: Chris Spencer <christopher.spencer@sea.co.uk>
> >
> > This is required to support the i.MX8.
> >
> Why exactly is this required?
> You should provide more details.

I don't know. :) These changes were made in [1], although the change
is actually described in [2] where it says: "Use a Job ring for RNG
instantiation rather than DECO, even for i.MX6/7 families." This does
indeed seem to be necessary to get it to work, but I can only
speculate why.

The original commit which added the run_descriptor_deco0 function [3]
states "[...] and another function that performs the running of the
said descriptor using the DECO debug mechanism." My best guess is that
the DECO debug mechanism is no longer available so it has to go via
the job ring.

> Strictly related to the implementation, why is the code moved to a new file?
> Please do not shuffle the code without providing a good reason.

This was done in an attempt to keep it reasonably close to the changes
in the downstream driver. The file was moved in [1] with the
description "Move the code related to RNG instanciation to another
file to ease comprehension."

The RNG initialisation code is not really needed in ctrl.c anymore
since it is only used in jr.c, so moving it out seems sensible.

Thanks,
Chris

[1] https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam/inst_rng.c?h=imx_4.14.78_1.0.0_ga&id=5fd8fe866172c38e8cd07741d98d79b995f05bc9
[2] https://source.codeaurora.org/external/imx/linux-imx/commit/drivers/crypto/caam/ctrl.c?h=imx_4.14.78_1.0.0_ga&id=afa53c2c96a54b4432a26372e3b5e7dbccbb9671
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/crypto/caam/ctrl.c?id=04cddbfe6b5f334aa337a1a9797eb8914822f2f8
