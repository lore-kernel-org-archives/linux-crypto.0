Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9473C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Jan 2022 10:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243288AbiATKoJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Jan 2022 05:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbiATKoH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Jan 2022 05:44:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13923C061574
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jan 2022 02:44:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEA2DB81CED
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jan 2022 10:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD9C340E7
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jan 2022 10:44:04 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="IIO89rxT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642675442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/ktRISTze90HfYrBY79kDXHU6AOhD5iNBUDGBysB5Go=;
        b=IIO89rxT2sZE1Wcaa+qDZKD40VA1YerVYmkEcvObKPlXMAhIFNNoJnfvZPWWvTaxrPCYMc
        akcqlqQ7Kmuk8D7e93NdHjKr2tzra0izgqwEdpD2aOKB1xHYNDVUdEYkC8nzGuS8e5lDpz
        ZDdvH/uyTNacCdJ7RTzm2RSfy2IGBjc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 130e39f2 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 20 Jan 2022 10:44:01 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id g14so16405700ybs.8
        for <linux-crypto@vger.kernel.org>; Thu, 20 Jan 2022 02:44:01 -0800 (PST)
X-Gm-Message-State: AOAM532oJNFBAFVg6TkMNXlTVHJDcW59OKTIEvdx8I+Z+0YJSKtvDLBX
        z9AfRCbxFRM/XGH96AEHkoB1Ox01m+WT8dYdPWA=
X-Google-Smtp-Source: ABdhPJwX1Hu53+ecYY4HM14b5JvHwXFD52vQocpjoSqFlrPo+VTznfSipiakU26S31/i+VaoaYcsxCwmL/FJHqgMSSM=
X-Received: by 2002:a25:f90d:: with SMTP id q13mr46708462ybe.32.1642675440789;
 Thu, 20 Jan 2022 02:44:00 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:209:b0:11c:1b85:d007 with HTTP; Thu, 20 Jan 2022
 02:44:00 -0800 (PST)
In-Reply-To: <CACXcFm=67TU=wy-WdkpiGnSm2M-E5__z=ACTzCmOkiGijrWNOg@mail.gmail.com>
References: <CACXcFm=67TU=wy-WdkpiGnSm2M-E5__z=ACTzCmOkiGijrWNOg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Jan 2022 11:44:00 +0100
X-Gmail-Original-Message-ID: <CAHmME9rG=82E3y_eNJSVZVfS_9FENw-heJ_Vr0BAaAMDGz3zBw@mail.gmail.com>
Message-ID: <CAHmME9rG=82E3y_eNJSVZVfS_9FENw-heJ_Vr0BAaAMDGz3zBw@mail.gmail.com>
Subject: Re: random(4) question
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We copy out half not because we don't trust the hash function but so
that we don't export part of what we're feeding back into the mixer.
