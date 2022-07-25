Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C797C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 13:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235503AbiGYN0M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 09:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235507AbiGYN0L (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 09:26:11 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA517614F
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 06:26:10 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b10so10449754pjq.5
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 06:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ub7Jm7xVeiVXdiE/MTDklMnRqIlrehUSb1rrC7mzHfo=;
        b=RG2zPm2uLQgLXDwYaVDd//S7cD5Bjp73KEE5wHGg9ilTe7Z0Os5soDHzC957UhL2ux
         /ZNfb9t/SLTRoEtvRs/W1QhQYsEVII53L8oGjO4tZvP2FOj2zoyElmU5YxbH+gaDvzPF
         zVjdnblMgUU1EQBbuWrcjcyn+Hz66oNU4W4ydYw0HyKBlO1fDTwqARYZXGkTnnmoI/2i
         u4t9T7GO4h9ZIUKgoV9BfMVV9rYhXltnQRzAtHsfrvhS0zkNaICJJRWewsIP5+L8XUAy
         MGGbtUvQG1hMUns0AOBlW2BOgrLozP6R4hYDWKbQZ1SlTEsg4kD7WLKvM8aOyeO42oXs
         m9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ub7Jm7xVeiVXdiE/MTDklMnRqIlrehUSb1rrC7mzHfo=;
        b=Jvoo6bEWwSyFHnvVx+KYhHgGG8WHSWV2gUMUPCOgg7/9b7WRcQw9EeZ0qyQXDh+FAA
         co3zu+sCFzugYiAfSctYar8GxUFpw81/jm0XVsGGyf6nF0Yo9Jvhud3CD4l3HL7UULb+
         WRr9ZNzhPmoWrXP1X+yez0D64jUtLcXUCNAvmzND0rD6D9lC9psRq1EKPuAQggX3Ap60
         TpAxHBXDiP2IhXn1ngGkF8mcmhu0x9Isfse4ayOTkVnqx8MufzQUEGkjLBiYPDpXFXPB
         1Lg8VCnHWC+jJClZNBILJtWHP/iX5PYIAJTXfWUJe22s9qqRbfefBDN1j5qsXKANz531
         awTA==
X-Gm-Message-State: AJIora/yQH8lwk6vQlU+PfKTVG+WZUCGyiZpxxubeITIfg3LDYk8bJNP
        JyB2bnS5eNxoCzp2PLcBrjBRmTlwH2gKHhWlzWJQfmel
X-Google-Smtp-Source: AGRyM1tOEXouZdo6YTpIdz/RcZ+HgbGPOBjx0+Gtt9w84buNpYV72y/nZ25YTsi1QRMI1IZjwbH9mog8JbB4y4sLjx4=
X-Received: by 2002:a17:90b:4aca:b0:1f0:3395:6432 with SMTP id
 mh10-20020a17090b4aca00b001f033956432mr31308778pjb.19.1658755570298; Mon, 25
 Jul 2022 06:26:10 -0700 (PDT)
MIME-Version: 1.0
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
 <87bktdsdrk.fsf@oldenburg.str.redhat.com> <Yt54x7uWnsL3eZSx@zx2c4.com>
In-Reply-To: <Yt54x7uWnsL3eZSx@zx2c4.com>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Mon, 25 Jul 2022 09:25:58 -0400
Message-ID: <CAH8yC8n2FM9uXimT71Ej0mUw8TsDR-2RRQaN_DJ2g=UG_TBKWA@mail.gmail.com>
Subject: Re: arc4random - are you sure we want these?
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 25, 2022 at 7:08 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>  ...
> > The performance numbers suggest that we benefit from buffering in user
> > space.
>
> The question is whether it's safe and advisable to buffer this way in
> userspace. Does userspace have the right information now of when to
> discard the buffer and get a new one? I suspect it does not.

I _think_ the sharp edge on userspace buffering is generator state.
Most generator threat models I have seen assume the attacker does not
know the generator's state. If buffering occurs in the application,
then it may be easier for an attacker to learn of the generator's
state. If buffering occurs in the kernel, then generator state should
be private from an userspace application's view.

Jeff
