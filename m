Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C990C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Nov 2021 21:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhKVVKQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Nov 2021 16:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbhKVVKO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Nov 2021 16:10:14 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD92C061574;
        Mon, 22 Nov 2021 13:07:07 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so967399pjb.4;
        Mon, 22 Nov 2021 13:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ne8hkoWG0z2fDBhpIIupmgnbEkE/DtgxjBNf8x/I1ZI=;
        b=lXWMk6Wjl5CMUHIvg0r73HhVJsbq/QN8TLifNL32x7cNbyufn8nmU67jQ6SAuDmVYO
         r8t9J7wMV6i+ZiEWRaaiUr+ghJjrpFPHiKIHAIeMTfMjwnG2EgFjkBUqjyE2k2sMylq7
         qEiCrM/YouNW64juivQY8KsySImO49gS3BznhkcnNs5zSKnG3grQ91iiL7g73oz/N+NG
         66kPDP5/z4GbRumdAc4MtZ5ROvSLtI1qSvIwER0dKRwKOoXKsxk+P0fAiwFW+atf+nG7
         IDQNGA75G8B8Ccu1SG7XgtnBPEC7dvVB7lAijNaVkBSvBCYZfqsQbG3ezr0PRX8JK/UA
         vgvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ne8hkoWG0z2fDBhpIIupmgnbEkE/DtgxjBNf8x/I1ZI=;
        b=CHO1uOiUaDkV/rehAgPEN5OXHVZ2tvHdpATJag28/x7JZ2oVIhO+t3SWWAgv4U4D6Y
         dAbtDMyfiYULfN3xuv66jrM5DVvMXhhVUmu0+KtJPaklNbii7uQ/GcdauRdqMVCLsCpP
         eESKbVAgNj1B5qyEUG9Ki6lw3CkgDwupLJfDO5gJY3ARt/xov8iOrqZc52e+jyEgQYgq
         AX+B4yu6Z0mTKOEJEmQq1Hrk6al9t3vVkhC+/GczLGV1g3wugfB4PZMQ5ZqgrM0ctg7f
         Ekmzhz8r4dvppCQ4FRZC/h6ljE4mYBVsGyyd166/NTg9CKA3I/hvkcEsp3p3h4p/GPKx
         Ql9Q==
X-Gm-Message-State: AOAM530x27vU506G6EKc4KB5C+M2+woHgy/a5RxzB/hAYk3e2uwCMk55
        mdi1QLipQiqt1E11bpIP09GmjlFUrOocSRpmI9g=
X-Google-Smtp-Source: ABdhPJwEHBACB+R4qQ+skgD90UCbRuqqP0i1P0ZOMuyRFt938zIEwoMPkKF9v0KyodZzEKV+CXy6Zz8JdL44aUgvR98=
X-Received: by 2002:a17:90b:180b:: with SMTP id lw11mr36716938pjb.108.1637615227027;
 Mon, 22 Nov 2021 13:07:07 -0800 (PST)
MIME-Version: 1.0
References: <2036923.9o76ZdvQCi@positron.chronox.de> <2560758.ogP2UNPRoF@tauon.chronox.de>
 <YZsyZua9T8DD6JF5@kroah.com> <11035663.0FQYWtqqoJ@tauon.chronox.de>
 <YZs+5ZGc1G5O3vF5@kroah.com> <afdf9c4a4005f6aeaded9e976c48160933f3c447.camel@redhat.com>
In-Reply-To: <afdf9c4a4005f6aeaded9e976c48160933f3c447.camel@redhat.com>
Reply-To: noloader@gmail.com
From:   Jeffrey Walton <noloader@gmail.com>
Date:   Mon, 22 Nov 2021 16:06:55 -0500
Message-ID: <CAH8yC8niN=q-pD4B3OU9zj84GN-vfi=T_aLq9V3sLTZ-mRP_GQ@mail.gmail.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
To:     Simo Sorce <simo@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephan Mueller <smueller@chronox.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Tso Ted <tytso@mit.edu>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 22, 2021 at 10:10 AM Simo Sorce <simo@redhat.com> wrote:
>
> On Mon, 2021-11-22 at 07:55 +0100, Greg Kroah-Hartman wrote:
> > On Mon, Nov 22, 2021 at 07:42:02AM +0100, Stephan Mueller wrote:
> > > ...
> > > I will leave the representatives from the distros to chime in and point to
> > > these patches.
> >
> > Then why not work with the distros to get these changes merged into the
> > kernel tree?  They know that keeping things out-of-the-tree costs them
> > time and money, so why are they keeping them there?
>
> I can speak for my distro.
> We have not proposed them because they are hacks, we know they are
> hacks, and we know they are not the long term solution.
> Yet we have no better way (in our products, today) so far to deal with
> these issues because what is needed is an effort like LRNG (does not
> have to be this specific implementation), because hacks will not cut it
> in the long term.

Kernel support for FIPS validated crypto would be very useful, IMHO.

Currently most folks I know and consult with use CentOS because CentOS
is free and includes the FIPS canister for OpenSSL. Several folks I
know and consult with don't have a solution because they use Debian
derivatives, like Ubuntu. They use Ubuntu because Ubuntu offers the
image processing packages they need out of the box.

Moving the validated crypto into the kernel would be useful since all
distros can provide it without the need for one-off patches.

What I am less clear about.... NIST is only one standard body, and not
everyone trusts the US. There are other bodies that should probably be
represented, like KISA. So the big question becomes, how does the
kernel offer "approved" crypto for different consumers? (where
"approved" means blessed by some agency like NIST or KISA).

Jeff
