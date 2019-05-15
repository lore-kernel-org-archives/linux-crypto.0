Return-Path: <SRS0=YWhG=TP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A58C04E53
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:17:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 295D22084A
	for <linux-crypto@archiver.kernel.org>; Wed, 15 May 2019 13:17:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ne24CFod"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfEONRX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 May 2019 09:17:23 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:43346 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfEONRX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 May 2019 09:17:23 -0400
Received: by mail-lf1-f44.google.com with SMTP id u27so1957617lfg.10
        for <linux-crypto@vger.kernel.org>; Wed, 15 May 2019 06:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HW2O4QMC+jQXSo/k3GWLfGlycWXAm73s2xUMXkOH4HQ=;
        b=ne24CFodzNkiUMhgPpVZxMhXeK7CPFzlLAzlUTuMHqq5TFjRYWdIODE8bH6MkWIn4F
         y3DK1Xmpr1TUmIJVQh+qA+hqzXyjXbULjg4UiJk68RQnlMkmwzYj9k3XWj9xGJ8xEb2D
         /prmPAuJIB/pmnpfgjVIMwQvS04fIp0cOMSQXFYU7pTpNDhDjqP/0VYwlamO+qN/9ZO4
         7izeVA6JsP+7p5KsV/kighL+jbDW+ma1PXxtlgNJByoR+ZpwWFfSfxem0zj9e+adIAaD
         grXKFa4fMijdslugGaY/SmYBqmNxjQJ6O8fVW9kyhORAMSYJvfvTIqD+hLeutP1H9tLU
         gG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HW2O4QMC+jQXSo/k3GWLfGlycWXAm73s2xUMXkOH4HQ=;
        b=WN5WOvzxLVma2dlrOMW3PCwpolWuhd/nwvABlR8PxRQa7irMY2vOf6Fs6jqV/AWBtD
         A4uOZyaEtvy9c0GxN4lE6yohNB3QaOf6Nj0yDSMhIn11H2AfOcW+CxlWp+kwOe9EUpYj
         z6b9cM5NOz3Eo79ZMYNpRbfiu88Mo9iRYcB5vemPBl3pl4n6SvYtt4ou6kNdUMvtrCZV
         OfLBmum+UyZQe2TMT7+YPuDIXvn9M/T2htdk+o6+AYnP5CXXUvTS0jrz8cDmdpOaw6kV
         TOoLvWMAgSsGVV33IwkB17LyJcsYUu2/dSIbXxh/JnUZAxZaXRHrjNGnsMaer4tgpcaR
         tKvQ==
X-Gm-Message-State: APjAAAXVGbPwxedqi8WWJv+KwhyWJX3E0qL+cpG+sytaeWMASTxc1/gl
        vHdRJ6LkEeH8BvxsQpHHmFu8kHV+bd7vZp3/1s4=
X-Google-Smtp-Source: APXvYqxKkpZxcKijx9joX9Sdk7yUfVXppWCXH/qayHSeFGjQbSlI8BhsmdPE1GiN9Ec3RUziNLijY4p/yjBPz/CQowg=
X-Received: by 2002:a19:c746:: with SMTP id x67mr19920906lff.152.1557926241426;
 Wed, 15 May 2019 06:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190515130746.cvhkxxffrmmynfq3@pengutronix.de>
In-Reply-To: <20190515130746.cvhkxxffrmmynfq3@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 15 May 2019 10:17:19 -0300
Message-ID: <CAOMZO5CJvcipPNY6TXnwwET2fc=zaP3Dj3HPT-zfZpzfqHkeHQ@mail.gmail.com>
Subject: Re: ctr(aes) broken in CAAM driver
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Sascha,

On Wed, May 15, 2019 at 10:09 AM Sascha Hauer <s.hauer@pengutronix.de> wrote:
>
> Hi,
>
> ctr(aes) is broken in current kernel (v5.1+). It may have been broken
> for longer, but the crypto tests now check for a correct output IV. The
> testmgr answers with:
>
> alg: skcipher: ctr-aes-caam encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
>
> output IV is this, which is the last 16 bytes of the encrypted message:
> 00000000: 1e 03 1d da 2f be 03 d1 79 21 70 a0 f3 00 9c ee
>
> It should look like this instead, which is input IV + 4:
> 00000000: f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd ff 03
>
> I have no idea how to fix this as I don't know how to get the output IV
> back from the CAAM. Any ideas?

Is this problem similar to this one?
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg37512.html
