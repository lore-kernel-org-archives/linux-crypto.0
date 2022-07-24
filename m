Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F83C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jul 2022 16:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiGXQX6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jul 2022 12:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGXQX6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jul 2022 12:23:58 -0400
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE959101FC
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 09:23:56 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id bn9so1951121wrb.9
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jul 2022 09:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=svB60sUCcIdDUmN/ANw2EHITe3q/XGnKpYM9mFFORZw=;
        b=AcvBsEd0NqdX3vqWHjzoZTHocfv36l2fvFJ0xhKAMa4v+Ww1+5bXzVO+HiTDMUMpTs
         Qc9K/iph3pTb700uaJmHF694g9dBWFaL9YHtjd0jlzMz1JxyH3/j5oHDPph+f2nr55Cw
         qSUXQayHzRg4KaT6VDftnVI4L9Ln6YPVFz7WOMH3zFeoj2KmaJAwd1Satjg+5skWL/+y
         5+jWH86WMADhM48rjPoWX+dMyTw7HOp0NAi9P+9qewltemt86fMhydAj/nr0tajcbD7a
         iK2WadktSo7IDjd+fK5HhTFlZeGx1aWaMeewttqoD2qsMeJ9p7L1HrNATMEmmU1B0uFz
         tI6g==
X-Gm-Message-State: AJIora//BWj/sdYp/hM8ehb8btEV8ZKZLvA+hJH3v1wCaNn731lYj/e0
        EWsOmiTcoMAQV8NF/WLPVd6JLvJA+e3gmFe6IspAKw==
X-Google-Smtp-Source: AGRyM1unWAmYECx9gY9kCn/EzNrJW084yN2ir/8W7buOuPd90b/nCvl4nFtIwc2j5tiq5D0b1k0TGdQs7OTk76rsXBs=
X-Received: by 2002:a5d:59c6:0:b0:21e:86fe:fcc6 with SMTP id
 v6-20020a5d59c6000000b0021e86fefcc6mr1741702wry.139.1658679835174; Sun, 24
 Jul 2022 09:23:55 -0700 (PDT)
MIME-Version: 1.0
References: <YtwgTySJyky0OcgG@zx2c4.com> <Ytwg8YEJn+76h5g9@zx2c4.com>
 <CAPBLoAdtEcpJg7sZQ7+z7HeCQzAs7Am7ep9GBFuBGxUeC3NyEw@mail.gmail.com> <Ytx9WW4Z90lx8MQt@zx2c4.com>
In-Reply-To: <Ytx9WW4Z90lx8MQt@zx2c4.com>
From:   =?UTF-8?Q?Cristian_Rodr=C3=ADguez?= <crrodriguez@opensuse.org>
Date:   Sun, 24 Jul 2022 12:23:43 -0400
Message-ID: <CAPBLoAc+PozfZ4TJ_j-LANLw4gHbVzkpm+Wzu5QTWdumaut_xQ@mail.gmail.com>
Subject: Re: arc4random - are you sure we want these?
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     libc-alpha@sourceware.org,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Florian Weimer <fweimer@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>, jann@thejh.net,
        Michael@phoronix.com, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 23, 2022 at 6:59 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> Doesn't getrandom() already basically have this quality?

In current kernels. yes. problems with old kernels remain..The syscall
overhead being too high for some use cases is still a remaining
problem,
if that was overcomed it could be used literally for everything,
including simulations and other stuff.
