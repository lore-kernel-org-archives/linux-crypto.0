Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57466C432C3
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 16:39:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 246EB21843
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 16:39:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="wnZy8evR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfKPQjo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:39:44 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33663 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfKPQjn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 11:39:43 -0500
Received: by mail-pf1-f196.google.com with SMTP id c184so8167217pfb.0
        for <linux-crypto@vger.kernel.org>; Sat, 16 Nov 2019 08:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=baFVrojrXCU0yRQX8zzQpXbVeTLI6it5XVnKzDWGFEo=;
        b=wnZy8evROpflNivMbM3XfyHf+F288ag9TlBBZT1ulah3vgNe2y0XzIKLgUGANhA0nj
         XYKCpAFd7ZBl85svUdskJcNPrjrYOFJq94xaiSK56YM08ZOd3K0hmVcDZ5YVzsiWxQ7g
         MPKi/orY1DXtK5RfOIzDyejAtERb5dSJn3CPN2eEoaWrqt8kL2Iuoop1gIvngrrM3Bbe
         Qsd339qG7PhXRbRwO7D/GLt46Vpy4eMnSp+djf5Uyj1dMEbwazTF9yQmO5bjKRach+Z1
         Wi5X0pdG0V8cwOcqWG1NqNtqx4LWKQzPAj5KIvGFEHwr0clUE/7+sKL0kVKw1rOWQiiY
         bqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=baFVrojrXCU0yRQX8zzQpXbVeTLI6it5XVnKzDWGFEo=;
        b=KxolB2aPsItk6N7+0Flu1NauKIakvwcGnrHtbDXBh1UH+cQK3acLrbZRSeB2nlL4lF
         cM4NCnB9aXjnubKbzbg5USseg3pyqmEuQVtdhJIBQjJW+98H1nBb6WMEVyEpgIxM7NQc
         3j8Nno8tW+QqPXZyWhfCVDu1qx2e1H88h2c/eVjrkHJu8Xejqb1MkyDBzxqbGCGXpW2D
         RVNibw44XdIRJDc4pT7ZzJXitYfBCsjNnChqDNiOeQHKukeusSOJv0TCbWDlPuMjkenn
         CBirHDB0qjABRoLMQSwyG82yzb/IKT7Rkz5NTTVT+4h3NuvKCOC9gWHaVLjYddZPZ7/F
         h/vw==
X-Gm-Message-State: APjAAAVb99/4RRGy6CzQN3vgy8VduK03wCXGAI7+xstPTVEZ0nM6USj6
        DDs5eJ2iEuGcSZTVp2m66OgQhQ==
X-Google-Smtp-Source: APXvYqxtPfEBfPnCI+okXowfh9uevVFooZfx5A/bj+ufGg+W+XUGO9bt65c6VbvFC6awKFuJnHC95Q==
X-Received: by 2002:a62:6044:: with SMTP id u65mr24458707pfb.227.1573922383178;
        Sat, 16 Nov 2019 08:39:43 -0800 (PST)
Received: from ?IPv6:2600:1010:b01b:e50d:6d7c:21:d243:910c? ([2600:1010:b01b:e50d:6d7c:21:d243:910c])
        by smtp.gmail.com with ESMTPSA id t8sm12965228pjr.25.2019.11.16.08.39.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2019 08:39:42 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Andy Lutomirski <luto@amacapital.net>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v25 03/12] LRNG - /proc interface
Date:   Sat, 16 Nov 2019 08:39:40 -0800
Message-Id: <4EB89769-7A2C-4A03-A832-9A0539DD3336@amacapital.net>
References: <2476454.l8LQlgn7Hv@positron.chronox.de>
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
In-Reply-To: <2476454.l8LQlgn7Hv@positron.chronox.de>
To:     =?utf-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
X-Mailer: iPhone Mail (17A878)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


> On Nov 16, 2019, at 1:40 AM, Stephan M=C3=BCller <smueller@chronox.de> wro=
te:
>=20
> =EF=BB=BFThe LRNG /proc interface provides the same files as the legacy
> /dev/random. These files behave identically. Yet, all files are
> documented at [1].

Why?

