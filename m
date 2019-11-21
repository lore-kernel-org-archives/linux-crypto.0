Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11521C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 12:00:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D201120872
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 12:00:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VAxXx/g6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKUMAd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 07:00:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30958 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726342AbfKUMAd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 07:00:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574337632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5rBJ14foXXsUIH3cvZz1qwUhkNTdgEVQ2KMu92pgrc=;
        b=VAxXx/g6G2/5yob3nkKbfgY7nzXpsbdXNHpGn4p+AtNgJogRAk7l49720zcXPhmGblHnyx
        a0R6mwgEjPhvPOvmWNoiTRuEVFHSPoHPLu0xZ+knzIa0X6Ca56dw+qZ8vxURic9+AR+Ola
        cdQO6bDWi/Ai6AAMRG6NGv7tmMkW+rI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-85-7sTIQrgiPp6y8xFm0Wu0Mg-1; Thu, 21 Nov 2019 07:00:30 -0500
Received: by mail-lf1-f71.google.com with SMTP id j16so860414lfk.2
        for <linux-crypto@vger.kernel.org>; Thu, 21 Nov 2019 04:00:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=x7Br6MUt5GIrekmwoW3W/dVDofzaSmCZ4ehtQgntfJg=;
        b=Cjvw/Ip2tr+15bHFu7kHZg86IFmmKp+PFfVbGXXqlAyBE9dhSc8jTnNpx5munHM4vQ
         AhVjx+LtnEKjNB8itW9fAllAe5mK/jv7wKGfGcK/UmBqCibBLwIIOH+SAeRyeUXrnt23
         sksEZOuDcTp5Os+obkPiezpZ0iddnR8PYdS04aQ6tMt1TPiRkiUd38gA33Xnq4IzYh5l
         R10ZZF6fVsrSxmZBTH8HBrg/mOcf5WlCIvlkWhX8ZKz7VwpJtHFOLOZ0DwxbBmB9tchT
         w0w2Cfrs3PRqp+5HrBGGxObch2LPOPoJbZKtB544DbAg6eLHC6SJ2bArOOC7uCNLD7gG
         iNiA==
X-Gm-Message-State: APjAAAV0n+Phftoh21Q8kmffRQA87ykbW/GDarVygD5qhRgdeWjLrAOX
        oKuqmF1zJbNx0qwGoY358bf4oZfgQMcqPm3z1o1OzEhJCP+pGmbQ4Ry6PkCYKIL/cWYq84hn1KU
        n/7L5/mEuxGFrmKvYCm6CX6ym
X-Received: by 2002:ac2:4a71:: with SMTP id q17mr7003190lfp.179.1574337629216;
        Thu, 21 Nov 2019 04:00:29 -0800 (PST)
X-Google-Smtp-Source: APXvYqwoeKMb/g8JM/lXuuI1qNoHv9YuoiOe6iH1WkPLFXbg9oIhgY0S6Dx/PfPzgSPCEeKonyhh5w==
X-Received: by 2002:ac2:4a71:: with SMTP id q17mr7003168lfp.179.1574337628964;
        Thu, 21 Nov 2019 04:00:28 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id k25sm1144384ljg.22.2019.11.21.04.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Nov 2019 04:00:27 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C838A1818BA; Thu, 21 Nov 2019 13:00:26 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH RFC net-next] net: WireGuard secure network tunnel
In-Reply-To: <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com>
References: <20191120203538.199367-1-Jason@zx2c4.com> <877e3t8qv7.fsf@toke.dk> <CAHmME9rmFw7xGKNMURBUSiezbsBEikOPiJxtEu=i2Quzf+JNDg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 21 Nov 2019 13:00:26 +0100
Message-ID: <87lfs9782t.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: 7sTIQrgiPp6y8xFm0Wu0Mg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> writes:

>> > +     MAX_QUEUED_INCOMING_HANDSHAKES =3D 4096, /* TODO: replace this w=
ith DQL */
>> > +     MAX_STAGED_PACKETS =3D 128,
>> > +     MAX_QUEUED_PACKETS =3D 1024 /* TODO: replace this with DQL */
>>
>> Yes, please (on the TODO) :)
>>
>> FWIW, since you're using pointer rings I think the way to do this is
>> probably to just keep the limits in place as a maximum size, and then
>> use DQL (or CoDel) to throttle enqueue to those pointer rings instead of
>> just letting them fill.
>>
>> Happy to work with you on this (as I believe I've already promised), but
>> we might as well do that after the initial version is merged...
>
> I've actually implemented this a few times, but DQL always seems too
> slow to react properly, and I haven't yet been able to figure out
> what's happening. Let's indeed work on this after the initial version
> is merged. I think this change, and several more like it, will be the
> topic of some interesting discussions. But that doesn't need to happen
> /now/ I don't think.

Agreed. Let's wait until the initial version is merged and use that as a
base to benchmark against... :)

-Toke

