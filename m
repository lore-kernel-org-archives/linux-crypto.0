Return-Path: <SRS0=VBnc=TV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FC2C04AAF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 11:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12CA021773
	for <linux-crypto@archiver.kernel.org>; Tue, 21 May 2019 11:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfEULCq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 May 2019 07:02:46 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39183 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbfEULCp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 May 2019 07:02:45 -0400
Received: by mail-ot1-f66.google.com with SMTP id r7so15921965otn.6
        for <linux-crypto@vger.kernel.org>; Tue, 21 May 2019 04:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xmbbl4/yPbmW/5hzHhWa8vSxB1+EqtnQJCpZ6Rh1wME=;
        b=r2P35ngJQddHDb4uejfb0rZKATDLrhS1V8Gm+6HngsZlMuza5ZJDH/HIZVsIQgaQ0K
         iVJ9Mj1KV0RMzHXhaPT0eI2gOYbKhFh/3n6TEHxD+Gj74qvnwaQTJcv5h9gbxPFNZ1Xm
         jMgp0dIFBuiRannDZ7VIM3s4zytnpCRHN99/GMZ8Z5gpOvdhzjcXiQFiHfCG9c4yd37R
         dLaNbHxoYsayS2v4lhnr5sZicmvrigBHl0c4vnq9izJod2/rBAro/bqjsQ8WIfMUqfnu
         5anXgIHze0BnPVlmdvbcdYOwzkT4zCABQUbry3I0UYWEK/Up9oDMKSIbhC5IvJLgK1Hu
         LKQg==
X-Gm-Message-State: APjAAAWDM1PZD8kRGOaS8d1Zx9/Vp4ceFhhDFV0ZI/Y3N8E8PBgWq2pp
        NK8tTvjBXc8PdL3fNTAIN4NprMCVkUgv6qAuBQ22iQ==
X-Google-Smtp-Source: APXvYqyMVJOHqzpVFlzUh6iYMBzNgHe3iskmeKSAa4z0tzhyZMrV2/JSf7fxJUnKMJDHM4obJ9Q243qu0PgSD7wF8A0=
X-Received: by 2002:a9d:6a8a:: with SMTP id l10mr47398758otq.197.1558436565213;
 Tue, 21 May 2019 04:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190521100034.9651-1-omosnace@redhat.com> <A3BC3B07-6446-4631-862A-F661FB9D63B9@holtmann.org>
In-Reply-To: <A3BC3B07-6446-4631-862A-F661FB9D63B9@holtmann.org>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Tue, 21 May 2019 13:02:34 +0200
Message-ID: <CAFqZXNtCNG2s_Rk_v332HJA5HVXsJYXDsyzfTNgSU_MJ-mMByA@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - implement keyring support
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        keyrings@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Milan Broz <gmazyland@gmail.com>,
        Ondrej Kozina <okozina@redhat.com>,
        Daniel Zatovic <dzatovic@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Marcel,

On Tue, May 21, 2019 at 12:48 PM Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Ondrej,
>
> > This patch adds new socket options to AF_ALG that allow setting key from
> > kernel keyring. For simplicity, each keyring key type (logon, user,
> > trusted, encrypted) has its own socket option name and the value is just
> > the key description string that identifies the key to be used. The key
> > description doesn't need to be NULL-terminated, but bytes after the
> > first zero byte are ignored.
>
> why use the description instead the actual key id? I wonder if a single socket option and a struct providing the key type and key id might be more useful.

I was basing this on the approach taken by dm-crypt/cryptsetup, which
is actually the main target consumer for this feature (cryptsetup
needs to be able to encrypt/decrypt data using a keyring key (possibly
unreadable by userspace) without having to create a temporary dm-crypt
mapping, which requires CAP_SYSADMIN). I'm not sure why they didn't
just use key IDs there... @Milan/Ondrej, what was you motivation for
using key descriptions rather than key IDs?

-- 
Ondrej Mosnacek <omosnace at redhat dot com>
Software Engineer, Security Technologies
Red Hat, Inc.
