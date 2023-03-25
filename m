Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5310BC6FD1F
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Mar 2023 14:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjCYOqB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Mar 2023 10:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjCYOqA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Mar 2023 10:46:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A695AF31
        for <linux-crypto@vger.kernel.org>; Sat, 25 Mar 2023 07:45:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679755513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P3wI73F5NrWC541iZLBNtRH4JahD9rlIWrqZXmkzEXA=;
        b=ObiboKN5AicD4+v9lck3NVTs9ExEjN1XRgO7oUOTdErQOtdr8A9Ki31wVEm6QOBCET3LZr
        jslMIAM/BbDANl6RhdU7jBbGHUzv64c+exfNv0zUl01dxEBjoYaSDFibdm6EwXLlzTDrqU
        o2k/uEC4TQWNYEiWSqAl0Z+PTWO0bgM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-7-_Kv3DJpHMwyGslwUdsmO3A-1; Sat, 25 Mar 2023 10:45:12 -0400
X-MC-Unique: _Kv3DJpHMwyGslwUdsmO3A-1
Received: by mail-qv1-f70.google.com with SMTP id dg8-20020a056214084800b005acc280bf19so2101717qvb.22
        for <linux-crypto@vger.kernel.org>; Sat, 25 Mar 2023 07:45:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679755511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P3wI73F5NrWC541iZLBNtRH4JahD9rlIWrqZXmkzEXA=;
        b=U3ZbBaRtUdwIypYy1B5sZPuDEvRTCTmrj3rIV4AFT3iW3255N1cjDx0s5GX6F/meY5
         3XEW+5USu2cj3O4wtmq9wcHm2/oW12Iutzalp/QsFYHy0oN8oupOhOLpWBurQQjul2dW
         aWdx0aGmRCtq41b/+DKkNfsgNjZ9MD/xIpguzHFFpF486UXm0tTxgCM5IwCXMeaGmOAR
         4tWVAgio24Isw9wti4AM61h9t8pTV6UZmnM3/STqLivl8sJwYgxUdAp7eweEb+s48PJr
         abulKBQcIiF9Qnwuaik3qNUKTf1+RScG9yjLDhKPls/ZE5nXLqFt2ZqXOLzcRsR8KSj0
         Qncg==
X-Gm-Message-State: AO0yUKV/DUBR7xNyxiNbsMXWOVb6CjRH1E1OM8utyvTR6DFsG8v7kgzP
        HKJUd+ta2+LH2qdKUPALx8HqDnQ95DAXJM+zcAbeLR1PZQxDQ5Fm3xKSIn9K3dF/t/6zA8hjFEn
        McSp2mJbIHEdPDcf+mEFZl0JPkh+iTqiZ+SPckBYBQL//SgPbRfw=
X-Received: by 2002:a05:620a:24d0:b0:746:bd8a:37ff with SMTP id m16-20020a05620a24d000b00746bd8a37ffmr1364633qkn.9.1679755511299;
        Sat, 25 Mar 2023 07:45:11 -0700 (PDT)
X-Google-Smtp-Source: AK7set8XFUBOoReIxxhA+jtQunK58lE3h4vuNjs63HgKPkGfgxMrHqT1R3Lh7D5QDzhZ8grhZuzCJJOPGkAKdMoRaHE=
X-Received: by 2002:a05:620a:24d0:b0:746:bd8a:37ff with SMTP id
 m16-20020a05620a24d000b00746bd8a37ffmr1364630qkn.9.1679755511031; Sat, 25 Mar
 2023 07:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <5915902.lOV4Wx5bFT@positron.chronox.de> <20230324174709.21533-1-vdronov@redhat.com>
 <7502351.DBV9aYCCVu@tauon.chronox.de>
In-Reply-To: <7502351.DBV9aYCCVu@tauon.chronox.de>
From:   Vladis Dronov <vdronov@redhat.com>
Date:   Sat, 25 Mar 2023 15:44:59 +0100
Message-ID: <CAMusb+RsaSdztEgUMO=JD-ZcJ19v41r1Mw0oY-CUgtJTr+FzTg@mail.gmail.com>
Subject: Re: [PATCH v3] Jitter RNG - Permanent and Intermittent health errors
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi, Stephan,

On Fri, Mar 24, 2023 at 6:56=E2=80=AFPM Stephan Mueller <smueller@chronox.d=
e> wrote:
>
> Thank you very much. I have fixed it in my local copy, but will wait for
> another bit in case there are other reports.

A couple of more suggestions, if I may. These are really small,
I'm suggesting them just due to a sense of perfection.

1) A patch name. All the patches in this area look like
"crypto: jitter - <lowercase letters>". Probably a patch name could be
adjusted as "crypto: jitter - permanent and intermittent health errors"?

2) You use panic("Jitter RNG permanent health test failure\n") in your
patch. With that, probably, jent_panic() could be removed, since
nothing is using it, couldn't it?

Best regards,
Vladis

