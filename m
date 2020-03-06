Return-Path: <SRS0=LFd7=4X=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285B5C10DCE
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 20:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F088B206CC
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Mar 2020 20:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BoDSQ8+z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCFUtP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Mar 2020 15:49:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44064 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726090AbgCFUtN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Mar 2020 15:49:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583527752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vnq654icNMC3OPciKhsbNTJjnPlwkjnJ6PM6ZwzuRt4=;
        b=BoDSQ8+zWviWWWVEp6YvBv+utspByJKFns2RI0bRjEWNQE4sNZd+uzlyinEU6lKIwXjYD/
        qeeZt/7tbQSdnKUlxZNbwldXPmYGjUjh82oUv7Z5KBC3i3a/zHngMd5AUXu9ymNe7DbhQd
        dUhg7LGppHIY/HU75RZ1WoxZ8zRrs3U=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-2Z-QhHiFMDiUKyg5WMbJ5g-1; Fri, 06 Mar 2020 15:49:08 -0500
X-MC-Unique: 2Z-QhHiFMDiUKyg5WMbJ5g-1
Received: by mail-il1-f200.google.com with SMTP id d2so2450607ilf.19
        for <linux-crypto@vger.kernel.org>; Fri, 06 Mar 2020 12:49:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vnq654icNMC3OPciKhsbNTJjnPlwkjnJ6PM6ZwzuRt4=;
        b=ABqatW60FFeDhBVJw1JPDelpxnkhgzW+xIm4Xt4XSSTRQf7WzbdeLCWDxTaNj0uXNl
         qxcyfcvH2OhfrDNhc2HP69W6N0TktQSmUMaspmj07yqtBllM1m9MwxcdDPKOyPArLQlt
         VBEWy/UFdc6AegAtnuuGZB5ELcFsR31dW9PlTL9sMhFCvREoJpRtEsbDgyb6+wTdj2rf
         Z+Cp9q1xlUbBwdi0fVtVOhC1jeAOPukN1KSW8EPfeKVs39vtWyBLCIV1UWotXp06+m7R
         ITOjbeWTBsVnDnalOMSyc5EyM1oTI6tC9EmZibIyMah8aVzeBsGmpFKPy23w5t85WgbZ
         NggQ==
X-Gm-Message-State: ANhLgQ1Fad9Hk09hSvBBQkOaJ4Dt8pJ5P2IMHBUwYUiWMu/RwuF+WZ8K
        YO0sXAiHk/Sj26feE+J+9NfWfYfGfSDIgVsl9XSu9x4Wf9FSyO3fweuYs+eeE+JoC7IvUhmSiDe
        LzIDRLTy36H6GGQ1iSr0QMtthIszQdN+0Ff/8eQ7g
X-Received: by 2002:a92:bb93:: with SMTP id x19mr4950275ilk.304.1583527748221;
        Fri, 06 Mar 2020 12:49:08 -0800 (PST)
X-Google-Smtp-Source: ADFU+vuvo2iGyk+ibtmVDUTdwqXvKVvixks2GLwbkE+VjCSp2qcV2nb/q6bheS6OfL3JOE3orHdl1mjXyKrLN9a056M=
X-Received: by 2002:a92:bb93:: with SMTP id x19mr4950241ilk.304.1583527747749;
 Fri, 06 Mar 2020 12:49:07 -0800 (PST)
MIME-Version: 1.0
References: <20200306172010.1213899-1-ckuehl@redhat.com>
In-Reply-To: <20200306172010.1213899-1-ckuehl@redhat.com>
From:   Nathaniel McCallum <npmccallum@redhat.com>
Date:   Fri, 6 Mar 2020 15:48:57 -0500
Message-ID: <CAOASepNfDLFw_uxbB59hg7B8Rmfaroj9NB8Gw82SFrSOaPbtMQ@mail.gmail.com>
Subject: Re: [PATCH 0/1] crypto: ccp: use file mode for sev ioctl permissions
To:     Connor Kuehl <ckuehl@redhat.com>
Cc:     "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        "Hook, Gary" <gary.hook@amd.com>, erdemaktas@google.com,
        rientjes@google.com, "Singh, Brijesh" <brijesh.singh@amd.com>,
        Bandan Das <bsd@redhat.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 6, 2020 at 12:20 PM Connor Kuehl <ckuehl@redhat.com> wrote:
>
> Some background:
>
> My team is working on a project that interacts very closely with
> SEV so we have a layer of code that wraps around the SEV ioctl calls.
> We have an automated test suite that ends up testing these ioctls
> on our test machine.
>
> We are in the process of adding this test machine as a dedicated test
> runner in our continuous integration process. Any time someone opens a
> pull request against our project, this test runner automatically checks
> that code out and executes the tests.
>
> Right now, the SEV ioctls that affect the state of the platform require
> CAP_SYS_ADMIN to run. This is not a capability we can give to an
> automated test runner, because it means that anyone who would like to
> contribute to the project would be able to run any code they want (for
> good or evil) as CAP_SYS_ADMIN on our machine.
>
> This patch replaces the check for CAP_SYS_ADMIN with a check that can
> still be easily controlled by an administrator with the file permissions
> ACL. This way access to the device can still be controlled, but without
> also assigning such broad system privileges at the same time.
>
> Connor Kuehl (1):
>   crypto: ccp: use file mode for sev ioctl permissions
>
>  drivers/crypto/ccp/sev-dev.c | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
>
> --
> 2.24.1
>

One additional note is that this permission structure is more flexible
for general SEV usage anyway, and isn't special-case for our usage.
Currently, the SEV admin commands are mostly limited to public key
certificate management. I would imagine that it would be desirable to
have a sev-admin account which can automate the certificate management
without having CAP_SYS_ADMIN for the rest of the system. So we believe
this patch has broader applicability than just our corner case.

