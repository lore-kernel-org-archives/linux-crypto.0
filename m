Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3439C4320A
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Aug 2021 10:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C8D611F2
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Aug 2021 10:04:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232850AbhHWKFj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Aug 2021 06:05:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53448 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233281AbhHWKFg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Aug 2021 06:05:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629713093;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZVPIU8NNXPfKmqVprwC6Sa9EH/JMJh/SLnA+Ky4RwYA=;
        b=eXZyhh5cPkeEQeKaU+VEwHg7wn964yrzkZVG4T9fXSqhH1fX/z/CgI0t8EG36xNysSIZ+n
        gOYz4lDxYeqPbYer01V6eKxMLtjtSQ44yMQlhpnTT5PSCBNQOc3ZnNyISTnb5LbbwQm2mj
        X+OOFdX1HpZW8sylPposARZojcHJBEw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-7pHlgsMyM3uQMyMN3iVffQ-1; Mon, 23 Aug 2021 06:04:50 -0400
X-MC-Unique: 7pHlgsMyM3uQMyMN3iVffQ-1
Received: by mail-ed1-f70.google.com with SMTP id bx23-20020a0564020b5700b003bf2eb11718so8461722edb.20
        for <linux-crypto@vger.kernel.org>; Mon, 23 Aug 2021 03:04:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=ZVPIU8NNXPfKmqVprwC6Sa9EH/JMJh/SLnA+Ky4RwYA=;
        b=TLOgwU+14BPKsRi+it8d4rSiAyCmaqJXNuWxvZJhXme7Pt355ZejcY3/aVquJs1Prl
         +tfuCj63YCWYPBnlUZl73yAZj28jjgxoIMY3dVJbARtFqnlBUG65I1yoEJnHwdu6O0gX
         TpPFWgvctLpJ3AeAiB6t4nWxHsqn/qQW9jXpKge+Hhg3gssfT72d67M/et+B/wlMUFEk
         Ooc1pMCw+R/T91lO2IMKj7Gd1g4oMGhOnR8/VbUebRbfoQ2kx9Y+wgX8PwsEhR7VnNfA
         eefeTgGux+xHQfBJw73LTEjHbydjXdYNAAEoFF0keVGSbj9rJwE39D/GONjD0dKi5pRU
         DyBw==
X-Gm-Message-State: AOAM531+oGO9yraZHtTwHfb19lTNllLDb8Wi+c2OU+2XsbwDMcInQJXj
        7O+4zGeJjau/P8AP9j+SoMVMLzAEGnvSDAbtaTZvfD8hyrADJXdCtbTvxS76FEXUIHRnI9M8dEk
        m945JvAAxki0on+4IJvTnY18q
X-Received: by 2002:a17:906:4c8c:: with SMTP id q12mr35162581eju.254.1629713089601;
        Mon, 23 Aug 2021 03:04:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzjsjnh/ETL6kdkurIpoZaLbR0ZcQV40DD8wO23Rb00gR9ggtaPgNcFoyLUzI9wHB9MGNSs+g==
X-Received: by 2002:a17:906:4c8c:: with SMTP id q12mr35162558eju.254.1629713089418;
        Mon, 23 Aug 2021 03:04:49 -0700 (PDT)
Received: from m8.users.ipa.redhat.com ([93.56.160.10])
        by smtp.gmail.com with ESMTPSA id gw24sm7109080ejb.66.2021.08.23.03.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Aug 2021 03:04:49 -0700 (PDT)
Message-ID: <627872ec0f8cc52a06f8f58598f96b72b5b9645a.camel@redhat.com>
Subject: Re: Building cifs.ko without any support for insecure crypto?
From:   Simo Sorce <simo@redhat.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Date:   Mon, 23 Aug 2021 06:04:48 -0400
In-Reply-To: <CAN05THS27h9QFpNuVVQmqz8k8_SKD8V8TbzZVYxco7S86i0zWA@mail.gmail.com>
References: <YRXlwDBfQql36wJx@sol.localdomain>
         <CAN05THSm5fEcnLKxcsidKPRUC6PVLCkWMBZUW05KNm4uMJNHWw@mail.gmail.com>
         <YRbT7IbSCXo4Dl0u@sol.localdomain>
         <CAN05THScNOVh5biQnqM8YDOvNid4Dh=wZS=ObczzmSEpv1LpRw@mail.gmail.com>
         <YRrkhzOARiT6TqQA@gmail.com>
         <CAMj1kXH93HU5SNUDLpn+c0ryJUYWpRKVXeoPK8jPOSwiS3_79A@mail.gmail.com>
         <CAN05THS27h9QFpNuVVQmqz8k8_SKD8V8TbzZVYxco7S86i0zWA@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2021-08-19 at 13:43 +1000, ronnie sahlberg wrote:
> On Wed, Aug 18, 2021 at 9:44 PM Ard Biesheuvel <ardb@kernel.org> wrote:
> > 
> > On Tue, 17 Aug 2021 at 00:19, Eric Biggers <ebiggers@kernel.org> wrote:
> > > 
> > > On Sun, Aug 15, 2021 at 08:38:23PM +1000, ronnie sahlberg wrote:
> > > > 
> > > > What are the plans here? To just offer the possibility to disable all
> > > > these old crypto and hashes on a local kernel compile?
> > > > Or is the plan to just outright remove it from the kernel sources?
> > > > 
> > > > If the first, I think that could possible be done for cifs. I think a
> > > > lot of the security minded larger enterprises already may be disabling
> > > > both SMB1 and also NTLM on serverside, so they would be fine.
> > > > 
> > > > For the latter, I think it would be a no-go since aside from krb5
> > > > there are just no other viable authentication mechs for smb.
> > > 
> > > Removing the code would be best, but allowing it to be compiled out would be the
> > > next best thing.
> > > 
> > > > TL;DR
> > > > If NTLMSSP authentication is disabled, there are no other options to
> > > > map a share than using KRB5
> > > > and setting up the krb5 infrastructure. And thus smaller sites will
> > > > not be able to use CIFS :-(
> > > > So while I think it is feasible to add support to cifs.ko to
> > > > conditionally disable features depending in a kernel compile (no SMB1
> > > > if des/rc4 is missing, no NTLM if rc4/md4/md5 is missing)  I don't
> > > > think it is feasible to disable these by default.
> > > > I will work on making it possible to build cifs.ko with limied
> > > > functionality when these algorithms are disabled though.
> > > 
> > > FWIW, the way this came up is that the Compatibility Test Suite for Android 11
> > > verifies that CONFIG_CRYPTO_MD4 isn't set.  The reason that test got added is
> > > because for a short time, CONFIG_CRYPTO_MD4 had accidentally been enabled in the
> > > recommended kernel config for Android.  Since "obviously" no one would be using
> > > a completely broken crypto algorithm from 31 years ago, when fixing that bug we
> > > decided to go a bit further and just forbid it from the kernel config.
> > > 
> > > I guess we'll have to remove that test for now (assuming that CONFIG_CIFS is to
> > > be allowed at all on an Android device, and that the people who want to use it
> > > don't want to use kerberos which is probably the case).
> > > 
> > > It is beyond ridiculous that this is even an issue though, given that MD4 has
> > > been severely compromised for over 25 years.
> > > 
> > > One thing which we should seriously consider doing is removing md4 from the
> > > crypto API and moving it into fs/cifs/.  It isn't a valid crypto algorithm, so
> > > anyone who wants to use it should have to maintain it themselves.
> > > 
> > 
> > +1 to moving the md4 code into fs/cifs, so that the CIFS maintainers
> > can own it and phase it out on their own schedule, and prevent its
> > inadvertent use in other places.
> 
> Ok, let me summarize the status and what I think we will need to do in cifs.
> 
> DES
> ---
> Removal of DES is not controversial since this only affects SMB1.
> SMB2 has been around since 2006 and it is starting to become viable to at least
> disable the SMB1 protocol by default today.
> There are still servers that only support SMB1 but they are becoming rare.
> I think also Microsoft Windows default to disable (but not remove)
> SMB1 by default
> on some configurations today.
> 
> I am proposing that we remove the hard dependency to DES and instead
> make it a soft dependency to "do not build SMB1 if DES is missing".
> 
> MD4/MD5/ARC4
> ----------------------
> These are all used together in NTLMSSP authentication today, including
> in the very latest
> versions of the protocol. This is the only authentication mechanism
> available in cifs
> aside from the "extended" kerberos 5 protocol that ActiveDirectory implements.
> As such the vast majority of clients rely on this when accessing SMB servers.
> 
> ARC4 is technically possible to remove since it is only used in the
> final stage for KEY_EXCHANGE
> when negotiating the session key. It could be removed but it would
> make NTLMSSP weaker.
> But if we have to move other crypto into fs/cifs anyway we can just as
> well copy ARC4 into fs/cifs.
> 
> MD4 is used to create a hash, which is then one of the inputs into
> MD5-HMAC for the core part of the
> NTLMSSP authentication so we would need private versions of at least
> md4 to be copied to fs/cifs as well.
> 
> I am proposing that we fork both ARC4 and MD4 and host private
> versions of these in fs/cifs.

Another way to handle this part is to calculate the hash in userspace
and handle the kernel just the hashes. This would allow you to remove
MD4 from the kernel. I guess it would break putting a password on the
kernel command line, but is that really a thing to do? Kernels do not
boot from cifs shares so you can always use userspace tools (or pass
hexed hashes directly on the command line in a pinch).

> I have patches for both DES removal and forking ARC4 prepared for linux-cifs.
> MD4 will require more work since we use it via the crypto_alloc_hash()
> api but we will do that too.
> 
> What about MD5? Is it also scheduled for removal? if so we will need
> to fork it too.

MD5 is still used for a ton of stuff, however it may make sense to
consider moving it in /lib and our of /lib/crypto as it is not usable
in cryptographic settings anymore anyway.

HTH,
Simo.

> -- ronnie
> 

-- 
Simo Sorce
RHEL Crypto Team
Red Hat, Inc




