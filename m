Return-Path: <SRS0=9Mwu=SN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5993C10F13
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 11:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 962E62133D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Apr 2019 11:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="fppicgAR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbfDKLII (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 07:08:08 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:35018 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbfDKLII (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 07:08:08 -0400
Received: by mail-vs1-f67.google.com with SMTP id d8so3231112vsp.2
        for <linux-crypto@vger.kernel.org>; Thu, 11 Apr 2019 04:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c9Qj+ChkJP2yKNlvd72cgUvQFhtEvP3Mx6WmQtUDTCA=;
        b=fppicgARMOmSKRyt6cxfMCYlK20oRzQYt0nvNMWq0Wd7TRlbyxAYLHyBrPDY8oypYM
         +WHnm8N45GTJAxQWvayLu8JTAv8/kgOR6/OgnryLHqC7yPE1XRrnblU5cDCEjoKskwKw
         FwgAEu3F6TIXFlQjppIfGOnVM/yn5tVey8hU6avbBIBMdQ+Dz55ZQA0tV7iNuEEXQjQa
         W9NNvNhuqIxQgYWSoYGIRDHptk/FOmR4iFTJ2HfEiUM4htIqdT4lLPO9DJX5e0BEW3lR
         XJ02K91VSEqa9jqWzNPkKZgGaUWZXAXn2p5ClltpVCrf9nr1WPVeqO37o4oDOwK0zqAv
         oS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c9Qj+ChkJP2yKNlvd72cgUvQFhtEvP3Mx6WmQtUDTCA=;
        b=QfvP+l+UC3gjmjQjg0EMF7SkES3kmNNUEPQnatr3008mL/cZOtEfIhU6GYTe55ZzAY
         vb2M/aGP6dEjdrGeOAmP6kYOatLfZyHHoD6zuriDBdw+utTY7xfA333wm1rQDQuvs6tL
         aWjyd0FXEiExxrxGJ71wFxde3jNcdJzThTSbaGiJ/iU9igRPnEAMwaJ8To0O1FzqCkK+
         1d5fs3UWcmsfx+IIeONzi9muc7ZYXXlUip+qJc8LFlLhk8tiHTu/3uZU/K1YcdB8XB4Q
         MQwdTnkpjxlq66Pd2aQL5Mp4n7Txk4Z3ADBob/HoI9jeDzC0E2rXTHPY9EV6TAJvaVqb
         pzCQ==
X-Gm-Message-State: APjAAAVn9tU3Z+KdJN6EDJ0UNGfEdlZFVoy95DsB12kRXz1FwNLf0WW9
        /AYclnjFtGwFxW9rpik+cfuqjYVxj+HWKE0o4KAFj44nzfg=
X-Google-Smtp-Source: APXvYqzphDnga6YZdorcu6nTSkbIHp+4qDNDvyLNwsJiHW5MeZq3EXt8/CHh+IU7GVQyp9IuTSV6e/XeVnBO2RUfsdQ=
X-Received: by 2002:a67:f256:: with SMTP id y22mr11189697vsm.19.1554980886963;
 Thu, 11 Apr 2019 04:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190411084707.h56mz2z7jxusnr7u@gondor.apana.org.au> <E1hEVQI-0006mq-Kd@gondobar>
In-Reply-To: <E1hEVQI-0006mq-Kd@gondobar>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 11 Apr 2019 14:07:56 +0300
Message-ID: <CAOtvUMfXxEy1Jz351MKyriMjOVByZgATCjudB0rL7DrGBEHCHg@mail.gmail.com>
Subject: Re: [PATCH 10/24] crypto: ccree - Forbid 2-key 3DES in FIPS mode
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

[ Resent because gmail decided suddenly to send HTML email... ]

On Thu, Apr 11, 2019 at 11:51 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This patch forbids the use of 2-key 3DES (K1 == K3) in FIPS mode.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thank you Herbert!
Gilad
