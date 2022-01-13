Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE8EC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Jan 2022 13:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiAMNar (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Jan 2022 08:30:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55048 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235181AbiAMNaq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Jan 2022 08:30:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642080645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gvHWAt4pFJMvbqSfBskw1CokGwtuUo9iIrW7YGw4dXU=;
        b=jU1KuGrFfwjCA7ZiAQktpfdD0HGe8GsjUktYMkYIUy1THCGwm5tro4jBs69Y5ya+r5xRy8
        t3uqZ/x3zZKa2WU6SHnLQy99OxuFdY1f96sMvlQEGLRRq+hJmj+temStWROXTYjVeDa2wZ
        PttpQDcW/AuszmXgYe4Qt6t03u942vQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-103-HsrlJKc0ONuFmS93GNHb4Q-1; Thu, 13 Jan 2022 08:30:44 -0500
X-MC-Unique: HsrlJKc0ONuFmS93GNHb4Q-1
Received: by mail-ed1-f70.google.com with SMTP id r8-20020a05640251c800b003f9a52daa3fso5306664edd.22
        for <linux-crypto@vger.kernel.org>; Thu, 13 Jan 2022 05:30:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=gvHWAt4pFJMvbqSfBskw1CokGwtuUo9iIrW7YGw4dXU=;
        b=xUxM/8dErSjqxHXu2yHluiZrVSs2HSUuMl5WgxgTtO0eI3RJeESn9EP7H9I/tnVoZB
         aHsNjdM7t4T3lze2GBpgo2oUAus0GpQhmOfK404E9EHPlilBd8uN+9koRqQA+1NYcOl3
         Ka0qbhoN6SmHOTUUiJYdmgfI1tmK9/nZILehdVT4JypVzDZXm+NwGau7O1IKrajSkIR1
         fI/uE7+cVnKnTmNtPmYF5npUlFKj1dLmKUtbi30xt0KaTEhvDgK60J/6q30WCBe74Om2
         1Sr6Og2rHzyA2kZb2iXo9/OkFDudUNkYVwMOJwpNgaFgSDaX+Qx/mSlI4wT6VZ+358TM
         BQCA==
X-Gm-Message-State: AOAM530KZBPUmA/FD2iKSPTOQw0xFeCO7Vg973gTris5qrO8FyWgFS0a
        GI2fGkImsjZ8SZWzqbBYM7VcvcpVNl+J+Gy+F6S0tuoouSpKAc6fCs4XdpRdjeNZmlJYFf9kVvk
        AeMAtqsDR8kc6MGq7cIQag5Yk
X-Received: by 2002:a17:906:58c8:: with SMTP id e8mr3412818ejs.444.1642080642976;
        Thu, 13 Jan 2022 05:30:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxu95cph8hLalPlDqvObhZKkMQqq8qJHdmzUV5r02GaDVvKx4qtduJCMZBnrcroKY6zd3i3vg==
X-Received: by 2002:a17:906:58c8:: with SMTP id e8mr3412797ejs.444.1642080642532;
        Thu, 13 Jan 2022 05:30:42 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id f18sm1210968edf.95.2022.01.13.05.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jan 2022 05:30:41 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1AC681802D8; Thu, 13 Jan 2022 14:30:40 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        hideaki.yoshifuji@miraclelinux.com
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address
 calculation
In-Reply-To: <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com>
References: <20220112131204.800307-1-Jason@zx2c4.com>
 <20220112131204.800307-3-Jason@zx2c4.com> <87r19cftbr.fsf@toke.dk>
 <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
 <CAMj1kXGz7_98B_b=SJER6-Q2g-nOT5X3cfN=nfhYoH0eHep5bw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 13 Jan 2022 14:30:39 +0100
Message-ID: <87ilung3uo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ard Biesheuvel <ardb@kernel.org> writes:

> On Thu, 13 Jan 2022 at 12:15, Hannes Frederic Sowa
> <hannes@stressinduktion.org> wrote:
>>
>> Hello,
>>
>> On 13.01.22 00:31, Jason A. Donenfeld wrote:
>> > On 1/13/22, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>> >> However, if we make this change, systems setting a stable_secret and
>> >> using addr_gen_mode 2 or 3 will come up with a completely different
>> >> address after a kernel upgrade. Which would be bad for any operator
>> >> expecting to be able to find their machine again after a reboot,
>> >> especially if it is accessed remotely.
>> >>
>> >> I haven't ever used this feature myself, though, or seen it in use. S=
o I
>> >> don't know if this is purely a theoretical concern, or if the
>> >> stable_address feature is actually used in this way in practice. If it
>> >> is, I guess the switch would have to be opt-in, which kinda defeats t=
he
>> >> purpose, no (i.e., we'd have to keep the SHA1 code around
>>
>> Yes, it is hard to tell if such a change would have real world impact
>> due to not knowing its actual usage in the field - but I would avoid
>> such a change. The reason for this standard is to have stable addresses
>> across reboots. The standard is widely used but most servers or desktops
>> might get their stable privacy addresses being generated by user space
>> network management systems (NetworkManager/networkd) nowadays. I would
>> guess it could be used in embedded installations.
>>
>> The impact of this change could be annoying though: users could suddenly
>> lose connectivity due to e.g. changes to the default gateway after an
>> upgrade.
>>
>> > I'm not even so sure that's true. That was my worry at first, but
>> > actually, looking at this more closely, DAD means that the address can
>> > be changed anyway - a byte counter is hashed in - so there's no
>> > gurantee there.
>>
>> The duplicate address detection counter is a way to merely provide basic
>> network connectivity in case of duplicate addresses on the network
>> (maybe some kind misconfiguration or L2 attack). Such detected addresses
>> would show up in the kernel log and an administrator should investigate
>> and clean up the situation. Afterwards bringing the interface down and
>> up again should revert the interface to its initial (dad_counter =3D=3D =
0)
>> address.
>>
>> > There's also the other aspect that open coding sha1_transform like
>> > this and prepending it with the secret (rather than a better
>> > construction) isn't so great... Take a look at the latest version of
>> > this in my branch to see a really nice simplification and security
>> > improvement:
>> >
>> > https://git.zx2c4.com/linux-dev/log/?h=3Dremove-sha1
>>
>> All in all, I consider the hash produced here as being part of uAPI
>> unfortunately and thus cannot be changed. It is unfortunate that it
>> can't easily be improved (I assume a separate mode for this is not
>> reasonable). The patches definitely look like a nice cleanup.
>>
>> Would this be the only user of sha_transform left?
>>
>
> The question is not whether but when we can/will change this.
>
> SHA-1 is broken and should be removed at *some* point, so unless the
> feature itself is going to be obsolete, its implementation will need
> to switch to a PRF that fulfils the requirements in RFC7217 once SHA-1
> ceases to do so.
>
> And I should also point out that the current implementation does not
> even use SHA-1 correctly, as it omits the finalization step. This may
> or may not matter in practice, but it deviates from crypto best
> practices, as well as from RFC7217

Right, but that implies we need to work on a transition mechanism. For
newly deployed systems changing the hash is obviously fine, it's the
"reboot and you have a new address" problem.

We could introduce new values to the addr_gen_mode? I.e. values of 4 and
5 would be equivalent to 2 and 3 (respectively), but with the new
hashing algorithm? And then document that 2 and 3 are considered
deprecated to be removed at some point in the future...

-Toke

