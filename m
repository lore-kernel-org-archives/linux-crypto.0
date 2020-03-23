Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7EADC4332E
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 08:36:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 877362072D
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 08:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bg5dByMq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbgCWIgA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 04:36:00 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37841 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727534AbgCWIf7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 04:35:59 -0400
Received: by mail-pj1-f67.google.com with SMTP id o12so2014120pjs.2
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2020 01:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :user-agent:message-id:content-transfer-encoding;
        bh=jQgBNOBetT+Yt9L1iBVToV2z/HpT1STYDN2GnLPUbZ8=;
        b=bg5dByMqk4E50hNtbCGMlTCXC+I0n8bJZ9aiwyEplK2n7k9vgIaCOpIo3QClPkMKz/
         85ciSI97m1kFKD05Ooad8bX73r+jiCvd0EAaoODmKHv1dABp3eMmND+0KJQTpnQEaiFs
         +IEUliXpab40z/XgujvQTd47DVYDSCAXLtVNfaEpx31AP9Tc5m0tueizkvs+mktm4I18
         mvLFQ5GxeLFZVlSgkMiqIgLjNOECvpJWrh5xEb+/I5YREitAWtiunmnjm3EIo5cu+v3u
         +H/oybtYojuw+y4tVERBq0gOsQ5ZDwxGBDqY2BrUtwYyoSyW4R7d0Ejx6aqufybfYHqb
         iwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:user-agent:message-id:content-transfer-encoding;
        bh=jQgBNOBetT+Yt9L1iBVToV2z/HpT1STYDN2GnLPUbZ8=;
        b=SgKn9Y6iSGypWokWwEcowc7Ez4IAHI7YXyhOoI/OVSx7RgoC4equMQOd8dt3mx02+7
         DBfSMdxzku9/Pj0pQWA1indob1xH2T+uVTqXtwi8DUdZ80H7B6RvAaWZRvpY5e2T9GIW
         F/L5vG5Il7G5bCw+ZEPPeTXw/Inp8ElPad7MGlKq1lv+Bhp1jLcEYdCG/OLEcGD6bsJ4
         XAkfQKHGLJ+QVJa66XhSCWiWrePUmKwRU5fDqVXbjSjl5WywQ/wMi8Bs4CZhesQpeS+F
         BEYqriHcb2zjLlxDY/IyBsGo0DavC39Fm97Es19slttS2ITXoYwP92V9l25FBBjkrqIV
         IK4w==
X-Gm-Message-State: ANhLgQ1cZa/QkcTKs047kSi9FoPaGJvc6IdrUWrnG/cM4xlOazFo9cwL
        bM5zFRmTakaRi2UjRJq/Zj0=
X-Google-Smtp-Source: ADFU+vtupVzZlv9Wxpzbv3+cZe0iswidB3CHNo7sIqsXoz8TGh6+KBE0yoI525zLJ1j5YLwnlRkUkw==
X-Received: by 2002:a17:90a:a795:: with SMTP id f21mr23950941pjq.29.1584952559231;
        Mon, 23 Mar 2020 01:35:59 -0700 (PDT)
Received: from localhost (14-202-190-183.tpgi.com.au. [14.202.190.183])
        by smtp.gmail.com with ESMTPSA id h132sm12937462pfe.118.2020.03.23.01.35.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 01:35:58 -0700 (PDT)
Date:   Mon, 23 Mar 2020 18:32:12 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v3 9/9] Documentation/powerpc: VAS API
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mikey@neuling.org, mpe@ellerman.id.au, sukadev@linux.vnet.ibm.com
References: <1583540877.9256.24.camel@hbabu-laptop>
        <1583541541.9256.50.camel@hbabu-laptop>
In-Reply-To: <1583541541.9256.50.camel@hbabu-laptop>
MIME-Version: 1.0
User-Agent: astroid/0.15.0 (https://github.com/astroidmail/astroid)
Message-Id: <1584950507.6q5ilutvon.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Haren Myneni's on March 7, 2020 10:39 am:
>=20
> Power9 introduced Virtual Accelerator Switchboard (VAS) which allows
> userspace to communicate with Nest Accelerator (NX) directly. But
> kernel has to establish channel to NX for userspace. This document
> describes user space API that application can use to establish
> communication channel.

Agree with Daniel this is good documentation.

But I don't see mention of the word 'signal' anywhere. The signal stuff
is one of the trickiest parts this code being added. It would be great if
that could be documented and even with example code or at least a
description of why it's required and can't be done some other way.

Does something like io_uring require signals in such cases?

Thanks,
Nick
=
