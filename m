Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 052C3EDE999
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Sep 2023 08:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbjINIvj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Sep 2023 04:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbjINIvi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Sep 2023 04:51:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71741BEA
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:51:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F47DC433C8
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 08:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694681494;
        bh=SlOZA2ase7BWhItInKW++A2ourC/kqoavmP2GMeou30=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=kvPbjmbPMahq1JQpHn5C8V1NrLgogkednPTH8qzPRrhjfTtVMRRCgUcXCveOT6yUf
         5dMBELScy7Hvd0dTwbqGLD2QKns6qMA6sdmYWBvUZH/U2PMQtb3Sn0u+Zl+XQcREHd
         LH4kA4wHTpcU1fV/Y0alBp9vGwwF+mcGqNctrkcr8SFFb+SVfrUzyK74+Vr+2DdghS
         S+72j9CZfWDmM9oAScqlosaeDAN+SttEw2omPKxRCEVPVFIWMGcZJJSJWJMIgaAqP9
         PwlXq3wvddoijARDWYNVvGaEPX4mDp/+WFPjW0Y+AuqsAcYcPjraisUPL/mzJD/fjg
         9V/+lDDKw/mmw==
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2bf66a32f25so10159191fa.2
        for <linux-crypto@vger.kernel.org>; Thu, 14 Sep 2023 01:51:34 -0700 (PDT)
X-Gm-Message-State: AOJu0YzfiCPfwj4SNMZ1k6zDWZ2zc951BT4HaGu1rkBttrK5En6QAAPx
        NbikNZxoZ14N1vARTiAH+aB3eGFvTTy/ze8EtTs=
X-Google-Smtp-Source: AGHT+IHm4XtKN06YjPh+aAZpa5wFGXiljqrSHwVknpaQwbH8gSWJdQYcE0dssFIn2MBHnjQ/3wragOfniKAjJlx5qBo=
X-Received: by 2002:a05:651c:8f:b0:2bf:9576:afd4 with SMTP id
 15-20020a05651c008f00b002bf9576afd4mr4106176ljq.16.1694681492675; Thu, 14 Sep
 2023 01:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230914082828.895403-1-herbert@gondor.apana.org.au>
In-Reply-To: <20230914082828.895403-1-herbert@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 14 Sep 2023 10:51:21 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
Message-ID: <CAMj1kXHLZ8kZWL3npQRavdzjRtv_uiRKmKDeXaQhhy3m4LvK+w@mail.gmail.com>
Subject: Re: [PATCH 0/8] crypto: Add lskcipher API type
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 14 Sept 2023 at 10:28, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This series introduces the lskcipher API type.  Its relationship
> to skcipher is the same as that between shash and ahash.
>
> This series only converts ecb and cbc to the new algorithm type.
> Once all templates have been moved over, we can then convert the
> cipher implementations such as aes-generic.
>
> Ard, if you have some spare cycles you can help with either the
> templates or the cipher algorithm conversions.  The latter will
> be applied once the templates have been completely moved over.
>
> Just let me know which ones you'd like to do so I won't touch
> them.
>

Hello Herbert,

Thanks for sending this.

So the intent is for lskcipher to ultimately supplant the current
cipher entirely, right? And lskcipher can be used directly by clients
of the crypto API, in which case kernel VAs may be used directly, but
no async support is available, while skcipher API clients will gain
access to lskciphers via a generic wrapper (if needed?)

That makes sense but it would help to spell this out.

I'd be happy to help out here but I'll be off on vacation for ~3 weeks
after this week so i won't get around to it before mid October. What I
will do (if it helps) is rebase my recent RISC-V scalar AES cipher
patches onto this, and implement ecb(aes) instead (which is the idea
IIUC?)
