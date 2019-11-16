Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5F3C43215
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 16:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 228C120874
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 16:09:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="bS92H15s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730390AbfKPQJO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:09:14 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34925 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731008AbfKPQJM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 11:09:12 -0500
Received: by mail-pl1-f193.google.com with SMTP id s10so6857780plp.2
        for <linux-crypto@vger.kernel.org>; Sat, 16 Nov 2019 08:09:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=rbbVOSmMuRnIGDknBjXXfC0fBPASDKYoYUrmo5eNFgM=;
        b=bS92H15s+5qWORaPy/KpGyd9SsgC655KqQYuSsU9pKNGfk9SJTLqRih+4XIq+ZkOS2
         +/poIX3KAggHJsmIL0jJM+EurfmUKZRoJ9Bb5rc9SAaN4mUnuVL0u4psU6cMne+FN7vp
         37n6UpKt+0TZ3XSqaIb7jbEgq6pL0UEzQ6MkRCpb5Id5hwADu+fONtfsT2zYci08+irc
         miWPM6cogv/xFmoqjRR41ZkQlbnm7Oql0Oxp4oS3u9d+DJyiLsEyCDgbacdlxGsCwHWr
         ZGwZtccBiL2U/y9DsrLyrdaGrRPsceSG8ipedytZVQBCAmEN0NK/dNnPTzzBSvM1VLxH
         9XgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=rbbVOSmMuRnIGDknBjXXfC0fBPASDKYoYUrmo5eNFgM=;
        b=Do44xrM8ciDOr/T3trL6Sks76Mt0ef6rbVJne1PefmG5MVl4kOv89Ovse+08jBlTGS
         rZy7GohVHtFO93kJQNU+u5Fd5kKm217YUwy4QO3mgUk794ADuKw+kJEtJB2KfYDyzfRq
         hWP0IDK0S+7YTHcEyvBfjBufEs7BhzAzeksIoSGvV3p2FJliRbmM+dvZEcC8IlKDe2Ez
         D85vYUe76Fekd1GTfXPP+AnZui9RF7WbhjuZVGFItCd1ssWebMBjO8o/S8Hnns6L82tX
         dNYcEYj0l/ah43OFjsNoW6luFzoG/NdM2x1d23PFEyyWnBlbX1IG67677fpseWla+ijr
         Ez/Q==
X-Gm-Message-State: APjAAAWB4v5br1JfFf37zheKKGjDKkOiABaNRbwSl8blekYz50WzztiV
        qf9vFAcn0FWQk7EV/dI9V4oTSw==
X-Google-Smtp-Source: APXvYqzE6Pi8rl2FiPhLgHMfAfWxumnilALnvG8Q4I2VlRDOhJtY5abcO5MMFPuq46JoQGSuS01GjA==
X-Received: by 2002:a17:90b:3015:: with SMTP id hg21mr27434228pjb.96.1573920552189;
        Sat, 16 Nov 2019 08:09:12 -0800 (PST)
Received: from ?IPv6:2601:646:c200:1ef2:28e6:fc7a:c382:8b6f? ([2601:646:c200:1ef2:28e6:fc7a:c382:8b6f])
        by smtp.gmail.com with ESMTPSA id r33sm13936396pjb.5.2019.11.16.08.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2019 08:09:11 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v25 10/12] LRNG - add TRNG support
Date:   Sat, 16 Nov 2019 08:09:09 -0800
Message-Id: <DDB907EA-3FCC-40C7-B55B-A84BC77FD7A1@amacapital.net>
References: <5390778.VeFRgus4bQ@positron.chronox.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Nicolai Stange <nstange@suse.de>,
        "Peter, Matthias" <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>
In-Reply-To: <5390778.VeFRgus4bQ@positron.chronox.de>
To:     =?utf-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
X-Mailer: iPhone Mail (17A878)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chronox.de> wro=
te:
>=20
> =EF=BB=BFThe True Random Number Generator (TRNG) provides a random number
> generator with prediction resistance (SP800-90A terminology) or an NTG.1
> (AIS 31 terminology).
>=20

...

> The secondary DRNGs seed from the TRNG if it is present. In addition,
> the /dev/random device accesses the TRNG.
>=20
> If the TRNG is disabled, the secondary DRNGs seed from the entropy pool
> and /dev/random behaves like getrandom(2).

As mentioned before, I don=E2=80=99t like this API.  An application that, fo=
r some reason, needs a TRNG, should have an API by which it either gets a TR=
NG or an error. Similarly, an application that wants cryptographically secur=
e random numbers efficiently should have an API that does that.  With your d=
esign, /dev/random tries to cater to both use cases, but one of the use case=
s fails depending on kernel config.

I think /dev/random should wait for enough entropy to initialize the system b=
ut should not block after that. A TRNG should have an entirely new API that i=
s better than /dev/random.
