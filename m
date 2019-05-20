Return-Path: <SRS0=w/0I=TU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E64C1C04AAC
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 12:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE40620645
	for <linux-crypto@archiver.kernel.org>; Mon, 20 May 2019 12:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="Yx6LH/QB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733119AbfETMxA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 20 May 2019 08:53:00 -0400
Received: from mail-vk1-f194.google.com ([209.85.221.194]:36871 "EHLO
        mail-vk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733219AbfETMSC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 May 2019 08:18:02 -0400
Received: by mail-vk1-f194.google.com with SMTP id j124so297905vkb.4
        for <linux-crypto@vger.kernel.org>; Mon, 20 May 2019 05:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5kXQ6vS4Br8b/GkN8FOpSIOl9zcEW2Y4KrZy5M2Bkl4=;
        b=Yx6LH/QBl9AFZ1DfZ3Mwi+k36+t6Xj5HfRu5wUC6OlUof7wTBotOL3t1bRiVkZ1XTr
         kBXZTpQ/OMpZ0PkZskacBuBO2xAWvS17siok2nvGgnQD5AxPW+ZcXuad/XakbtWYtZvo
         T1belaPyupntkOEmLZRAwYRX7ttz5yM5rcFeASiVLucqVMNXDoWD60wcCK1JRV2Pt33l
         zTQckKj8Ho2tFI8GH4rgB1WREuRPozYS2ZflbTJOLmVCHoaMvQ6tA5n6eZCAc0iirkSi
         ObdBdoTbsVEk3SwqddZ7u53K3WRIyN+H/ew9oeBvwTVzKBwPOh4O2bJOTNJWfTDGWCms
         QOKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5kXQ6vS4Br8b/GkN8FOpSIOl9zcEW2Y4KrZy5M2Bkl4=;
        b=kBxiEbyuELVmVjbtZ3WkiG8+7uAqI9dHM6dSfLU55Vu1pvYlkt4hZFfqIX6klYfv+Z
         EZhsrVvayOB5gQVhX9kWJTHFZqQRgOdpD+rRpWVlnow/9q71DrDG/9hw8HX14up5Gl4K
         wRKl4e2pZ89FHj2iJO9WqRUDIH4tGdMcrchkNvuGgs6BQaHCFD+VYjEQzJgKQOBLyfiK
         jnAAE6E3FxnqkwA3nSo/ApJ74UaICaH+H8/9amSh6Mv6I9Mkwm/+ClfhjJgZ81wnfX8H
         L8bu7Y6ZRttsl/NLTELkY3kPwEcOq5bxrW5H+D5Cvg8J4CYYoxzx/H+m53aQiuzKwXop
         bXJA==
X-Gm-Message-State: APjAAAWnkScCxEjkB5WGkw6q6Fx7kOSAhwD29A9WUagKafDVXGWNZvPE
        9j8zk5h6LjE+qraD1a34K6D3L+BCsmlpYNjlTOUnIw==
X-Google-Smtp-Source: APXvYqz3r+hI9oibZ9dmSgzGJipU45wIDIXpfO13g+0ueygZn7O/8r1kzEQ38a+qqAQTN6Mb/8jTggg0KGPxm80/Rh8=
X-Received: by 2002:a1f:2e8e:: with SMTP id u136mr6454712vku.1.1558354681339;
 Mon, 20 May 2019 05:18:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190520115025.16457-1-gilad@benyossef.com> <20190520115025.16457-2-gilad@benyossef.com>
 <20190520120903.GB13524@kroah.com>
In-Reply-To: <20190520120903.GB13524@kroah.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 20 May 2019 15:17:48 +0300
Message-ID: <CAOtvUMedfV_Zb4Y7YW7nmv2LUfQPfgGixmaOj7VFasHKmApwkg@mail.gmail.com>
Subject: Re: [STABLE PATCH 1/2] crypto: ccree: zap entire sg on aead request unmap
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 20, 2019 at 3:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, May 20, 2019 at 02:50:23PM +0300, Gilad Ben-Yossef wrote:
> > We were trying to be clever zapping out of the cache only the required
> > length out of scatter list on AEAD request completion and getting it
> > wrong.
> >
> > As Knuth said: "when in douby, use brute force". Zap the whole length o=
f
> > the scatter list.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > ---
> >  drivers/crypto/ccree/cc_buffer_mgr.c | 18 ++----------------
> >  1 file changed, 2 insertions(+), 16 deletions(-)
>
> This does not apply on top of my latest 4.19 tree with the current
> pending queue applied, nor does it apply to 5.1 or 5.0.
>
> How about waiting a few days and resending after I do the next round of
> stable updates, so you can rebase on top of them easier?

Yes, will do.

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
