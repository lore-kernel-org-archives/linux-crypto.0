Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F074C433FE
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 02:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF8C061BFB
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Nov 2021 02:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhKQCkI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 21:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhKQCkH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 21:40:07 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB3AC061570;
        Tue, 16 Nov 2021 18:37:09 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r8so1524180wra.7;
        Tue, 16 Nov 2021 18:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=84bwccpitw3E7eUvjhkQQ7YB4ZtXSTIWeJRPNLrJpLg=;
        b=VwZHGMX9MfdoSjuIFvTOEyAg6FYK7zoadvSf6ZO6Pks4cyh0eQQqiEe9zSPqfp/lhB
         UsqPd6rDgWY0w3NdKjMfsM9secPaou920qTDAVMo08Wv1GuEyssYEbkaJ9aaSgT3pEx6
         ZrSjP6PuX9OgOoIBW55he0sLvjlb6QJpSar3FNit+7KbhUzKIC2IgaVSmfS60OM2tMmL
         m9NI1NdDoXbGzk95z535huSRp6kYWm9yDDz+KN4hHqdg89EpKBw46mKAO93miXCHw5Z3
         cUJLzRhKT1CVEZkPrqUpEBJe9NrdOmVg4ppunw8UhGpYvMHelzx7lFGouTdt6UQZ4ZBf
         N9Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=84bwccpitw3E7eUvjhkQQ7YB4ZtXSTIWeJRPNLrJpLg=;
        b=5haO0Dl2MI/SJdQE0PhUgldSiHt2dGF6CguOKWDZqBP6q2sPqJ3gF3m6cePjgcPY0B
         +9pczeG3mBR0ZtEy6MY9Fg3WCsTkvDMQlyydPrWO9g7sB2EqfiOycflLk2uN7IAX6fVN
         tPf+p2LczPuuqNV+I0wHg0Y007Npi/1Kwt92C/FIqllpx3XU3AyxP3BSTiduFxyHp3BD
         J+YYJLSfh0YxU7agC65BMR5hMKqfvWacTpaxhf5cPUEsBL5b4GXM5ksBA1rEBaAzNR1j
         bS8eAb8DBkRmWSqcV0vCBXjHvlnR62sn+SeX7AcUodHRPKjoo10oAMnQb4LBEtOXxjgR
         r+JA==
X-Gm-Message-State: AOAM530Sd5r6Gb/7IAcix5MwesyYfFxX0WyG2UOs7azi9tlpZtIZRmNr
        Ltx2eHYaxbTUpR5hYKei3e41DDboGF0wKTnPa9ig8K3R9JI=
X-Google-Smtp-Source: ABdhPJwG/kCT0gypegtv4csawQG1+SWH8yztXcrapfInpmVfLsWTvaPNGfOgJqa4ToU8mXnZYqB0ZuYxQYrAMwHwPKU=
X-Received: by 2002:a5d:40cf:: with SMTP id b15mr3965830wrq.161.1637116628372;
 Tue, 16 Nov 2021 18:37:08 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFmkO0g2YRjvfknKXr_ZnJaMg2cpvOsLq=h1ZcB=hg9NK8w@mail.gmail.com>
 <03183ae9-3dd3-b0da-31e6-c186b2bfcfcc@csgroup.eu>
In-Reply-To: <03183ae9-3dd3-b0da-31e6-c186b2bfcfcc@csgroup.eu>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Wed, 17 Nov 2021 10:36:55 +0800
Message-ID: <CACXcFmmNjSNMm4WjKUENhfzq7TrTF7eOzx5fCXQHgg9wQSu5cA@mail.gmail.com>
Subject: Re: [PATCH 0/8] memset() in crypto code
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> wrote:

> I see no point in doing 8 separate patches that all have the same
> subject and the exact same light description.
>
> I think it would be better to have a single patch with all the changes,
> and use the cover letter description as description for that patch.

It seemed better to me to have separate patches because there
are 8 files involved, possibly each with a different maintainer.

Likely I should have gone further & included the filenames in
the subject: lines & maintainer addresses in cc:
