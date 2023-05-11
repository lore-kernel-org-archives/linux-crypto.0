Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E37FAC77B7C
	for <linux-crypto@archiver.kernel.org>; Thu, 11 May 2023 15:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237978AbjEKPLs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 May 2023 11:11:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238220AbjEKPLr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 May 2023 11:11:47 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A9010A
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2023 08:11:45 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e9e14a558f8ab-33164ec77ccso538935ab.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2023 08:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683817905; x=1686409905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UO/D1O1faXkPbB/YMuRgtGeWgLWeF6P7NdI3zyMJJGM=;
        b=XhaSE+lWv6BPmJa70xMSgNcyarLI2AGHV1jYvcKnNz9PIvlzWF7TJAO6RRSEauBG5C
         mHocJ9FkazVh/RC8YlLltsRIF6E/HFUMEVqcZC0nz4BzWa1aOPqJmP2MEFVvJvfREnoH
         3CQV1APFAyKXLKEYK2ES1XdEvZgjI3XhPWXlZgzxzXgECE+pN/QzkIzKRfw7Di7tNlCb
         JJz00jTvXfTeUqTQZmylsf/59UL05Z3UqfgdFQJorm2my9o8VBk3CrBRBUNycCpHwnlH
         yW4lmJHI1iuf9WdKDiAfa5NvEfJ9LC6cQ6CAOwh37aai0IgmqfLLDFXZlhhcYHkPWNhm
         rHMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683817905; x=1686409905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UO/D1O1faXkPbB/YMuRgtGeWgLWeF6P7NdI3zyMJJGM=;
        b=fqnOzCu/jy974T1uAoUieZHsTAdIwfpp+9i5JWddjTUAqtgnlXuq4hleNzvuAkTQy+
         kmcYBwyhuP0v9hL237TCp/TGIPxiPkj4USAdlrFdGI0/kuxjvSkli7rKRFxYcIuBcK+c
         MvB7ZLDevQQMBUUd3tPVleK3pOT0bWsbOBEzpCQLCQBY6msgQpBc1AXgxtV3Zz0RqCA1
         2n/sMxw8GHoXXUQWpR32a3OaryhFuL0JWdvl9L773bkvEcnTv7zYqyxkTbvfd7JFYDVL
         LZMr4J9G/dOOUeis6rXV3V0YzpX5NHWLeOqrAEo+vmLwoQtvRvvEqodterWlGlOo3Tgq
         lSOA==
X-Gm-Message-State: AC+VfDzph5Ox9oEtUpYWm1LqZmyi47gAUaP2atpRXXPpgX89s3HqZW/5
        g0EjFGeeAhwgI2BsMZ74DRe4+JpSb+pToEojiLA/pQ==
X-Google-Smtp-Source: ACHHUZ4oa0frYOKWPg9acQ16moL6Vkv9jmlV7/tRR3KKVJcA8x+8hlKHubV/wDzwwLxNeTETfBWH8vbMo2pR62YvD9Y=
X-Received: by 2002:a05:6e02:1c4a:b0:335:5940:5ca6 with SMTP id
 d10-20020a056e021c4a00b0033559405ca6mr276338ilg.13.1683817904890; Thu, 11 May
 2023 08:11:44 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000050327205f9d993b2@google.com> <CACT4Y+awU85RHZjf3+_85AvJOHghoOhH3c9E-70p+a=FrRDYkg@mail.gmail.com>
 <ZFI9bHr1o2Cvdebp@gondor.apana.org.au> <ede92183-bef3-78a7-abae-335c6c5cca1e@linaro.org>
 <ZFMsvxW+pEZA2EZ7@gondor.apana.org.au> <41ddc20d-8675-d8bc-18c6-2a26f0d6b104@linaro.org>
 <20230505040134.GA883142@mit.edu> <CACT4Y+ZnTRf5BocMZZCkUva+VddOMXYGu13iWo6+3sopZzh5hQ@mail.gmail.com>
 <ZFi5FfjVpxLEk48A@mit.edu>
In-Reply-To: <ZFi5FfjVpxLEk48A@mit.edu>
From:   Aleksandr Nogikh <nogikh@google.com>
Date:   Thu, 11 May 2023 17:11:33 +0200
Message-ID: <CANp29Y6ppu5Bi103VnrO+DrnqU2KSQ4eREbJbG22FCeBAMCP4g@mail.gmail.com>
Subject: Re: [PATCH] hwrng: virtio - Fix race on data_avail and actual data
To:     "Theodore Ts'o" <tytso@mit.edu>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Tudor Ambarus <tudor.ambarus@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot <syzbot+726dc8c62c3536431ceb@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, olivia@selenic.com,
        syzkaller-bugs@googlegroups.com, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ted,

On Mon, May 8, 2023 at 11:06=E2=80=AFAM Theodore Ts'o <tytso@mit.edu> wrote=
:
>
> On Mon, May 08, 2023 at 07:33:39AM +0200, Dmitry Vyukov wrote:
> > A link like this may work for syzbot instead of the Reported-by tag
> > (may work out of the box, but need to double check if we start to use
> > this):
> >
> > Link: https://syzkaller.appspot.com/bug?extid=3D726dc8c62c3536431ceb
> >
> > Or similarly this may work:
> >
> > Reported-by: https://syzkaller.appspot.com/bug?extid=3D726dc8c62c353643=
1ceb
> > I think the parsing code mostly looks for the hash.
> >
> > This was proposed, but people said that they need links to lore and
> > don't want links to syzkaller dashboard. So this was rejected at the
> > time.
>
> I think the "Reported-by: " line should continue to contain an e-mail,
> since that way "git send-email" will automatically include a Cc: to
> the mailing list address so that the syzbot page for the report will
> contain a link to the page.
>
> What *would* be useful would be a search box on the top-level
> https://syzkaller.appspot.com where you could either enter an e-mail
> address like:
>
>         syzbot+726dc8c62c3536431ceb@syzkaller.appspotmail.com
>
> or the syzbot report title e.g.:
>
>        KCSAN: data-race in random_recv_done / virtio_read (3)
>
> or just a function name:
>
>         sys_quotactl_fd
>
> The search box could just push the text to google.com with
> "site:syzkaller.appspot.com", which should mostly do the right thing.

Thanks for the suggestion! I've filed
https://github.com/google/syzkaller/issues/3892

>
> Also, it would also be nice if all of the URL links on the
> syzkaller.appspot.com used the id form of the URL.  That is, to use
>
> https://syzkaller.appspot.com/bug?extid=3D6c73bd34311ee489dbf5
>
> instead of:
>
> https://syzkaller.appspot.com/bug?id=3D32c54626e170a6b327ca2c8ae4c1aea666=
a8c20b
>
> The extid form of the URL is shorter, and having a consistency so that
> the primary URL is the extid would reduce confusion.  The web site
> will need to continue to support the id form of the URL since there
> are quite a few of those URL's in mailing list archives and git commit
> descriptions.
>
> It also would be useful if there was a way to translate from the extid
> hash to the id hash, so that it's possible to search for the extid and
> id forms of the URL --- since the URL aliasing means that for a
> developer trying to do code archeology and web searches, that we need
> to search for both URL forms for past syzbot reports.  (But if we can
> avoid the aliasing confusion moving forward, that would be **really**
> nice.)

I've just sent a PR [1] so that URLs from bug lists on the web
dashboard use the extid=3D instead of the id=3D parameter. Hopefully this
will reduce the confusion.

[1] https://github.com/google/syzkaller/pull/3891

--=20
Aleksandr

>
> Cheers,
>
>                                                 - Ted
