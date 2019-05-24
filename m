Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB356C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E1D7217D7
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 08:49:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E+NjpSCb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389475AbfEXIto (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 04:49:44 -0400
Received: from mail-it1-f174.google.com ([209.85.166.174]:38235 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389448AbfEXIto (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 04:49:44 -0400
Received: by mail-it1-f174.google.com with SMTP id i63so12659842ita.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 01:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=onQfdHTLJnYhFxGsgmPk2zn9SdgeqSxolC4z5ERiI/A=;
        b=E+NjpSCb2yPFWGnRXN/hlAuv1y9EcJBU2UVMDZ+pmLTbWLs0jW49olLEAXSYnjOjmz
         C1CDBZKeL5Vu5hckfO4QQ7slaJLCoqFtfMOf5ShS3Q2OoMespWPKwX8mu+JoSna3PeDo
         ca1Ki0JvI6Ls3474YrNAHycUsGnfjxFN3oA6ud+YUloDM0UKuWA1mwmihj6YvUuGRlT5
         nDxUw0gzOf82sF4JrlpzEm+mzeTBphgVmNIyn5vi2/je0ZvaXQ8aqFOzJlGX9WE1ULXo
         cDzWIzkcv5Wl/0gCoVENrc/OJT2sMc9PtQKtJ820rs2uJfCErfmDb3TIJKUsttcO/5iu
         c10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=onQfdHTLJnYhFxGsgmPk2zn9SdgeqSxolC4z5ERiI/A=;
        b=AHWBwgrJyHyQfSZiyd1olAOtk8yhYlXnc8PGL+2EgtBRMTGzbDgN5KMsgUf74rnL3M
         d/VZ3gzorUOyszWkMMLsQf62FfQjEPW+CzzzQMl6YCiQucTnEoPnim+jTctaK9oV55FQ
         RkR8BeQRhWSwvg+vuReY9hp09+8c7wvjx0Or0oScXVvBu462SwJ32HQkC636Y9zj47wJ
         0+zepy6qYxWPX5KKvOpDjvYR6SHpupvx1LmfClOPQokI92GDjYlAGcHeZ4ZblvIYmI+G
         1uAfxYibcLwGqxWL6N3ECk6kGZEFZ/e5mdz9FE+PIuORXrIfSQ9bMhAPu4GeEVsaKmz4
         SzkA==
X-Gm-Message-State: APjAAAW44+0LYsHxDc7B47F96kpaAr8T8/PXHtg/VkdwbUspQv8KbEjq
        L5TWdEVS1yAsZdCDVM0MNgTvFaKk/6BTFR+8cw4=
X-Google-Smtp-Source: APXvYqzomZmFa49cFGALuksPeGUrxAEhP1ERex/z2CbJFfCz6DPA+S/dqMpvy/URbP1CSn0QJUqMslbOK0H5rg8FwF0=
X-Received: by 2002:a02:5143:: with SMTP id s64mr15880870jaa.54.1558687783913;
 Fri, 24 May 2019 01:49:43 -0700 (PDT)
MIME-Version: 1.0
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com> <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com> <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com> <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
In-Reply-To: <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Fri, 24 May 2019 04:49:09 -0400
Message-ID: <CAH8yC8nBDa438QsJvs91CGV-e+-j9UxnB2pQ6-KAy0jV3EXj-w@mail.gmail.com>
Subject: Re: another testmgr question
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, May 24, 2019 at 4:47 AM Christophe Leroy
<christophe.leroy@c-s.fr> wrote:
> ...
> > As I already mentioned in another thread somewhere, this morning in the
> > shower I realised that this may be useful if you have no expectation of
> > the length itself. But it's still a pretty specific use case which was
> > never considered for our hardware. And our HW doesn't seem to be alone in
> > this.
> > Does shaXXXsum or md5sum use the kernel crypto API though?
>
> The ones from libkcapi do (http://www.chronox.de/libkcapi.html)

And they can be loaded into OpenSSL through the afalg interface.

Lots of potential uses cases. I would not cross my fingers no one is using them.

Jeff
