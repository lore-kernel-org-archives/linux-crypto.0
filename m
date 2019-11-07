Return-Path: <SRS0=gVpy=Y7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE9EC5DF60
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Nov 2019 20:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FFB92166E
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Nov 2019 20:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lixom-net.20150623.gappssmtp.com header.i=@lixom-net.20150623.gappssmtp.com header.b="er3oh261"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfKGUxN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Nov 2019 15:53:13 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40519 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfKGUxN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Nov 2019 15:53:13 -0500
Received: by mail-io1-f68.google.com with SMTP id p6so3847160iod.7
        for <linux-crypto@vger.kernel.org>; Thu, 07 Nov 2019 12:53:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lixom-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rA5BF9v4ZThyajmII5ge2gdIpEkUZ9BxSgBgVhHF100=;
        b=er3oh261iMbwiX8Afq6ri7awa7QMbDXPG9fBlGzXsBWHKWHgtz+Zom1Rr7CWfE//Ff
         66rENayMZEEp6+YB8RexMR7pBaM5HXuYFoe54Dt36HIiov2r9j6ArjxMk6pOO5Or6WOk
         ca7bzw+x++ysNpURufJxz3pZXV4/V/oPGhbLF5JoTss32pN4odeytidqmCj4jVB2CVMw
         VXK9cc7AXBDiuXWI18/emxailuBRhh4aTtHClGY93LaEKsZf+lCRCkY7kv7Pewo27l9K
         qyJihKp2OMDq4vULMcVUlFTPhaElR87LHj86iGEHBRquFTdr63S76WPCe4D596hQotjD
         +xbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rA5BF9v4ZThyajmII5ge2gdIpEkUZ9BxSgBgVhHF100=;
        b=YhJuUHX1fgCnnSNNebPfHYYUi/hjdM0VsSKr1aFPNxj9OY6n5+hPBK7nbRe8uJ5rfT
         XL/8Ep2Zr4PnWQ8UCUfGnN+SxGcb+NEYosuI5qLJOIeboU3WEfrLl0RV+xr63m6JqOfr
         9LffwAINYYQJ3iaqboWvAIjw9OWtWQrCryqA9YooxGJ/LEQa6bYQYkcG8kPF+iM1Zm7A
         z6Xd8G79mt8tVDWa2q0xcgfkkzuVLJZ86sUF+neBXrwn6kSTfPzQMM2eWwIeXB9ZFqbV
         ocj6HytCNT3UjXPjflQOFO0zoTquqX+G2AruHIfQauNoPTKPLlUmrUwh6Gw6OqqZPanL
         pnkg==
X-Gm-Message-State: APjAAAW2nRruTnCUy1YTrRSpef3//3veljTKYUjxWybHPjEyq+ZfhmlU
        OniTg8RP9VDfciGgqOp56aS3AC19q8X8sd15Li1GnHZnoN+J9qsp
X-Google-Smtp-Source: APXvYqzJjKLaVnfZEqq+xqv7dZPLzZh6wegHzZyoQ0Tnotoa/bw4/+IV6FdVYkfIDnawx5ieS0+p1hvzR8BJ5xfwXXI=
X-Received: by 2002:a6b:6509:: with SMTP id z9mr5494612iob.123.1573159992665;
 Thu, 07 Nov 2019 12:53:12 -0800 (PST)
MIME-Version: 1.0
References: <1572610909-91857-1-git-send-email-wangzhou1@hisilicon.com>
In-Reply-To: <1572610909-91857-1-git-send-email-wangzhou1@hisilicon.com>
From:   Olof Johansson <olof@lixom.net>
Date:   Thu, 7 Nov 2019 12:53:01 -0800
Message-ID: <CAOesGMiBK_Nc-hNDaomNWF7Ni0WZreLM1bgi5YsGihPVjk9RYw@mail.gmail.com>
Subject: Re: [PATCH] crypto: hisilicon - replace #ifdef with IS_ENABLED for CONFIG_NUMA
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 1, 2019 at 5:25 AM Zhou Wang <wangzhou1@hisilicon.com> wrote:
>
> Replace #ifdef CONFIG_NUMA with IS_ENABLED(CONFIG_NUMA) to fix kbuild error.
>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> Reported-by: kbuild test robot <lkp@intel.com>

Acked-by: Olof Johansson <olof@lixom.net>

Confirmed that this also fixes riscv allmodconfig build breakage on
linux-next. Herbert, can you pick it up so we keep -next building?
Thanks!



-Olof
