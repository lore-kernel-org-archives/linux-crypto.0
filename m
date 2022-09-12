Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D998C6FA83
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Sep 2022 09:38:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiILJig (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Sep 2022 05:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiILJig (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Sep 2022 05:38:36 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B6C33421
        for <linux-crypto@vger.kernel.org>; Mon, 12 Sep 2022 02:38:34 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id e187so5620257ybh.10
        for <linux-crypto@vger.kernel.org>; Mon, 12 Sep 2022 02:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=L26glTbFhqAmwvfLLP9peidpMtq2KDp3MGd0AfFzlJ4=;
        b=ZEpIn2HtG2HD8p3ywDU8Xj2OEJnAn2M5TVkMh4TkO+hrzK3FhHYhH9x2O0wh8RpBOt
         0sWLkOzEeNirwPLV4SSN8SBzy1KG1Zs3miE8YEewo8J82BXQfmTpxftPjt7DvFBLFpku
         IgYQambqUdcTaOkAjtffjNNjbK0r1IaBYcLmmCfifFLkRyzTVXBcDsrSftjxG1nFruhj
         O9ii3s17UArG5vTchSscaMwN2ttpASZI5XAJhqZ5p51kBf8Memy0EI+IzCi+a0ERBYjv
         fuwTcWTK46JGcU5NRJJTNXwwIGc2boLtrVokLltVT123B39AY2lsrAOQdLQxxp5zE53P
         2LsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=L26glTbFhqAmwvfLLP9peidpMtq2KDp3MGd0AfFzlJ4=;
        b=MTixWCGCM2b4mNxefbg4LJMNWYyims73PSUL8NdV8mKwPOvSbZryqDPdxq9cttn6hp
         M6LSHJIo+BMyDPYUVezhq5VUmgfNQiU0E52Iw/zESMo+wfaERijvaXefi1mKr67JlZM6
         99vDMQ1zgVxlyIw/o5i3thv1S9lPK9Nm95D15sVxY/Rk6TPTzv2+zFNfAOk+QeP03bCm
         zZjORx90Cg2KNFesNPyL+U7vTIrv+qtn2sPxd+X4YobYMAjEe0iDSGmXIiCMPkQrhYLw
         MgGtNyAzD0sU4Ejgb8jkJhxPrklYBXqGFK/W6VS/jbtN37NdtokiMO3eAsMwBC5pzLet
         9WkA==
X-Gm-Message-State: ACgBeo3Hk/Woqn/rFL1qhJ0GQiDXLmYO9peysyzrgIK7ne8YSjw9EOJJ
        GOcE1VMjRp5Ay73P4cCoV7kYEl02rY4xUqtJDI65Sw==
X-Google-Smtp-Source: AA6agR44Kb/ZTH8MwLVWVX/wXVm1Xd2iJRoCm/rTR4YKiKsJi58ZRTRubmn0n8qiN/GfteNcMvUdlROvRXUBCjLgC1Q=
X-Received: by 2002:a25:d784:0:b0:6aa:167e:90bb with SMTP id
 o126-20020a25d784000000b006aa167e90bbmr20854352ybg.549.1662975513102; Mon, 12
 Sep 2022 02:38:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220906202017.5093fd23@canb.auug.org.au> <YxfFzGObDWsylCK+@quark>
 <CAG_fn=UcWy+gbYLDM2WQZ=BZuVRML17KJ0L+=zsSg7+yDo4oGA@mail.gmail.com> <20220907134107.bcb8b9c22b9ae517e3b43711@linux-foundation.org>
In-Reply-To: <20220907134107.bcb8b9c22b9ae517e3b43711@linux-foundation.org>
From:   Alexander Potapenko <glider@google.com>
Date:   Mon, 12 Sep 2022 11:37:56 +0200
Message-ID: <CAG_fn=V1utoSbPK6Jhnzyy3Fj47k1YS1DZc5M094Bp1GpP5kFQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the mm tree with the crypto tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Robert Elliott <elliott@hpe.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 7, 2022 at 10:41 PM Andrew Morton <akpm@linux-foundation.org> w=
rote:
>
> On Wed, 7 Sep 2022 11:18:24 +0200 Alexander Potapenko <glider@google.com>=
 wrote:
>
> > What's the best way to handle this? Send another patch series? Or
> > maybe just an update for "crypto: kmsan: disable accelerated configs
> > under KMSAN"?
>
> I'd prefer the minimal update, please.

As a heads-up, I mailed "x86: crypto: kmsan: revert !KMSAN
dependencies" and "crypto: x86: kmsan: disable accelerated configs in
KMSAN builds" last week. No rush though, guess you're busy with LPC
this week.


--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
