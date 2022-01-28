Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596CCC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 00:39:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241595AbiA1Aj3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 19:39:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59640 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbiA1Aj1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 19:39:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 750F861CFB
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jan 2022 00:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909F5C340E4
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jan 2022 00:39:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="p7oyz+pT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1643330365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K09cSswOaOomBlsUXqZXJml62uYBKJZ3fgzSleVoUpA=;
        b=p7oyz+pTicIlm9O0q/MwDpENkwF6pxwjyu89zUWDXZqFRG6bumnvDkgxWLtzmEGLrSWBjG
        R8FyN2A6zIOH4JfD/7mveqZcb/f9b2pJUIoB7K7+weAOBd2wqIkJMAKYVn0NhzF46kEC82
        F0kvRn8maBBC9F+M9iuRusbLuQmejP4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ef2061a0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 28 Jan 2022 00:39:24 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id p5so13640338ybd.13
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 16:39:24 -0800 (PST)
X-Gm-Message-State: AOAM5334BAYiGvy2g042NhJ6RW7iAg8gwYaCHL8ae8RXHFw498Q5kPL7
        l4U08SEbYK9kj3bcs0NQygJgScrME6qo/MGk7Lo=
X-Google-Smtp-Source: ABdhPJw3utCdcpkdAQz3mowjbA2jIVVvkzYFE5qDwthkNbzKbY/iDT4xbdXgmYm9xIpvbNRcRvC+4Swd0zfI+2Npnnw=
X-Received: by 2002:a25:2284:: with SMTP id i126mr8513327ybi.245.1643330363431;
 Thu, 27 Jan 2022 16:39:23 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:6254:b0:129:4164:158b with HTTP; Thu, 27 Jan 2022
 16:39:22 -0800 (PST)
In-Reply-To: <CACXcFmkTiiS3M5B6RtyG=oD9+CqncFR6kQX1SZHvVNshVe=vKQ@mail.gmail.com>
References: <CACXcFmkhWDwJ2AwpBFnyYrM-YXDgBfFyCeJsmMux3gM8G+Gveg@mail.gmail.com>
 <YfLtrrB+140KkiN0@sol.localdomain> <CACXcFmkTiiS3M5B6RtyG=oD9+CqncFR6kQX1SZHvVNshVe=vKQ@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 28 Jan 2022 01:39:22 +0100
X-Gmail-Original-Message-ID: <CAHmME9pyj-ejZn8KpVKqhELYB=-5bVYTeNhLk4SZOnBM1zeidA@mail.gmail.com>
Message-ID: <CAHmME9pyj-ejZn8KpVKqhELYB=-5bVYTeNhLk4SZOnBM1zeidA@mail.gmail.com>
Subject: Re: RFC random(4) We don't need no steenking ...
To:     Sandy Harris <sandyinchina@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Denker <jsd@av8n.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 1/28/22, Sandy Harris <sandyinchina@gmail.com> wrote:
>
> Even in blake,
> every iteration except the first applies the transform to
> arbitrary somewhat random data.

No. The compression function uses the IV always, to break potential symmetries.

If you have a concrete idea, please just send a patch with good argumentation.
