Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2046BC43215
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 10:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB1D72089F
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 10:29:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G0lDyO0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfKUK3W (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 05:29:22 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:41332 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726197AbfKUK3W (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 05:29:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574332162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9X1E0mPwcgFWQfrAV192xVl6AHfJK9mk2N8XSWyhdc=;
        b=G0lDyO0PmhCDN8jRJJyn911GzV0W9GZvwWoShmF7/ZpzLzLucvQVSIgGNFeO3ftF9rNacU
        uSigUA0hEZcA5QP+LRNF1QUCdDpJ19JG9QctDsFZHgPPNZQUqt6GavChaBZUMKTBw03Gk5
        /qTwV0Jyn+Psk6gzxij4qltYAFIyJcM=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-d2UgjTnFN9-xBOesawV21A-1; Thu, 21 Nov 2019 05:29:20 -0500
Received: by mail-lj1-f198.google.com with SMTP id y17so464549ljm.16
        for <linux-crypto@vger.kernel.org>; Thu, 21 Nov 2019 02:29:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ucqBuN/GyC2pdnb4QcrvifWl2PtH/4rDjAh47h8mEbo=;
        b=Zet7jHH9qvM59VB+BmoCBtlbyURn95L3HxDfWdj5dhzwKgTLPDW3Fko38rQwiOP6ur
         L4e7mV8+D3kPT8poHFJERaGOUsvljmDRzTqw+JZ6A1AKG5/EA2ks0sGRue7ivEorDl3v
         50KOQAcMhff9Jdie/Lq+9MvekO4W0pgZWdx+iyEZe8GKuU8b4CfbcdWaG9G6ITJHXmrh
         FOz5G3dv0qYL6MoJds2ZxdQNzSCaM1aeZQOanieImKEo09E9iaXSfRyagxCz9T9SMDTQ
         sn/BjyE7B8W47OEk5fS6IGQ5azosoUNS1SmdaF9eWYzoRnHt0Rheb81+Ddot8Day59hH
         owkQ==
X-Gm-Message-State: APjAAAXgRny56LFBu+Y2neUwk0f7J5Gezxx4+WxrgdwcOEyuEfTC6vPY
        WGQKjw2Vt0ojjnefGs4WPmxqDrvYOKPfi9NjPBAWsDswwVV6ZgztQe+MRZHmSjxrSmgBb2nqlQf
        ijLSRvlJ1tbZsKqEGZTSX/dwY
X-Received: by 2002:a05:651c:390:: with SMTP id e16mr6751318ljp.196.1574332158700;
        Thu, 21 Nov 2019 02:29:18 -0800 (PST)
X-Google-Smtp-Source: APXvYqwad1vM01fCMQKOMxvi3SDsPF4W318bJWsoMeOqcAfg1It54CDiNRVixFQOF/1CZYdfjRHvyw==
X-Received: by 2002:a05:651c:390:: with SMTP id e16mr6751297ljp.196.1574332158521;
        Thu, 21 Nov 2019 02:29:18 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id 141sm1013079ljj.37.2019.11.21.02.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 02:29:17 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CE1A11818B9; Thu, 21 Nov 2019 11:29:16 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <thoiland@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
In-Reply-To: <20191120203538.199367-1-Jason@zx2c4.com>
References: <20191120203538.199367-1-Jason@zx2c4.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 21 Nov 2019 11:29:16 +0100
Message-ID: <877e3t8qv7.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: d2UgjTnFN9-xBOesawV21A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

> RFC Note:
>   This is a RFC for folks who want to play with this early, because
>   Herbert's cryptodev-2.6 tree hasn't yet made it into net-next. I'll
>   repost this as a v1 (possibly with feedback incorporated) once the
>   various trees are in the right place. This compiles on top of the
>   Frankenzinc patchset from Ard, though it hasn't yet received suitable
>   testing there for me to call it v1 just yet. Preliminary testing with
>   the usual netns.sh test suite on x86 indicates it's at least mostly
>   functional, but I'll be giving things further scrutiny in the days to
>   come.

Hi Jason

Great to see this! Just a few small comments for now:

> +/*
> + * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rig=
hts Reserved.
> + */

Could you please get rid of the "All Rights Reserved" (here, and
everywhere else)? All rights are *not* reserved: this is licensed under
the GPL. Besides, that phrase is in general dubious at best:
https://en.wikipedia.org/wiki/All_rights_reserved

> +=09MAX_QUEUED_INCOMING_HANDSHAKES =3D 4096, /* TODO: replace this with D=
QL */
> +=09MAX_STAGED_PACKETS =3D 128,
> +=09MAX_QUEUED_PACKETS =3D 1024 /* TODO: replace this with DQL */

Yes, please (on the TODO) :)

FWIW, since you're using pointer rings I think the way to do this is
probably to just keep the limits in place as a maximum size, and then
use DQL (or CoDel) to throttle enqueue to those pointer rings instead of
just letting them fill.

Happy to work with you on this (as I believe I've already promised), but
we might as well do that after the initial version is merged...

-Toke

