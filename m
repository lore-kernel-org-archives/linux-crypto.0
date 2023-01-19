Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD0BC46467
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 05:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjATF3V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 00:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjATF2p (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 00:28:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4F046D40
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 21:23:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B813B823F7
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 14:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD919C43398
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674137113;
        bh=cWZER9RVFSYIVQ+GvR+NYQUQ3OoWM6/H0pMET0zgWxw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mmIzOr1ZYdToFCznwlFVn0UHZx79y6rZiLhiWF3ZTYsba9/Vu5EaKv3uxjTGZR4G8
         f8aumzpqV/xvnzLivJCN/WqtnmBrC7TbnRvQgZI1l6DeI0Vvku1zx6xKWdnoqtvf/M
         U702VoYivROawvFyO+/xlkyFjewUfL9fhEV+pczTglo4x3aSleMf7E0fOT0hHChYtk
         Cp2BSoBfdUFzdktgrhw2AidVxPZDs1/xu2Pp3niTxdafhHqmMewaq+E9x3usACyrdr
         7KywzH/vXhTyiPzSCVRv890PKjAA1LUlkZbClilcZXlHgD3VKV07KoQnHN+F5aB9I0
         00zcEdc7kmr0Q==
Received: by mail-lj1-f173.google.com with SMTP id s22so2196904ljp.5
        for <linux-crypto@vger.kernel.org>; Thu, 19 Jan 2023 06:05:13 -0800 (PST)
X-Gm-Message-State: AFqh2kqRI45j2TC1CuvOVLeza+cOuzIHVJOMqqqEOUpEQn/m6UHt/+/Y
        fty6/CTbsRpKTFz2tigmf6n6bqCAzPRs66OJNrM=
X-Google-Smtp-Source: AMrXdXvX5TbHPsvC0y5fB3FIwUE1lRIWsli6EmD/1Sr8zqUN6Dtot0SRMPOONq09tBwiJw9cY3KzcGdBJq7922aem/E=
X-Received: by 2002:a2e:8783:0:b0:289:7fc6:e1d with SMTP id
 n3-20020a2e8783000000b002897fc60e1dmr576624lji.69.1674137111719; Thu, 19 Jan
 2023 06:05:11 -0800 (PST)
MIME-Version: 1.0
References: <20221214171957.2833419-1-ardb@kernel.org> <CAMj1kXG_btjHUVpN9m5NoBdFv=3JWt-piPx_u40KTv70CC-sRQ@mail.gmail.com>
 <Y8TEqNJuEmWE5Tg/@gondor.apana.org.au> <CAMj1kXExpt4U64ncX6wSU_0zLNNQGiP3RFGNbAXwpuBjeV=fPg@mail.gmail.com>
 <Y8UFjlyFqg+uddZ5@gondor.apana.org.au>
In-Reply-To: <Y8UFjlyFqg+uddZ5@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 19 Jan 2023 15:04:59 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGSkNROwP4NqEixMS1hw0qf3a_-b6AFacX1-=5mwG-yoQ@mail.gmail.com>
Message-ID: <CAMj1kXGSkNROwP4NqEixMS1hw0qf3a_-b6AFacX1-=5mwG-yoQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: Accelerated GCM for IPSec on ARM/arm64
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 16 Jan 2023 at 09:06, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Jan 16, 2023 at 08:40:09AM +0100, Ard Biesheuvel wrote:
> >
> > Will you be taking the rest of the series? (patches #2 - #4). Or we
> > might defer this to v6.4 entirely it if makes things easier. (The
> > other changes really shouldn't go through the ARM tree)
>
> I had assumed they were dependent.  But they do seem to make sense
> on their own so yes I can certainly take patches 2-4.
>

Excellent, thanks.

Patch #1 has been picked up by Russell, so please pick up the rest.

-- 
Ard.
