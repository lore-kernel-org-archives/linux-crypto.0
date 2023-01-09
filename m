Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69ADC5479D
	for <linux-crypto@archiver.kernel.org>; Mon,  9 Jan 2023 11:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjAILyW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 Jan 2023 06:54:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236722AbjAILyI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 Jan 2023 06:54:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A4FDEFB
        for <linux-crypto@vger.kernel.org>; Mon,  9 Jan 2023 03:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673265194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZT+C8iVlMW2cC5v0WiwtfPl4IXfefK4BJ9hDx37N9LU=;
        b=i4yMLNOdi90/qwZxFPOLO30MFDDzAVdjo22fOi4BmPQUUBR9bts6Qu3aNZw73Wuc9UMeUz
        /M/Is1gZTZKZiJKmZvHNLjCABKvOtBWj+9R5ROA5XFm2TCSiBKjo81YnLp3lnqA9SrndKZ
        vctwZ9Vpe7in96VfuYvMluKBW27A/lA=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-1-uZDcvlBANtS8R5Vq1GdeZA-1; Mon, 09 Jan 2023 06:53:11 -0500
X-MC-Unique: uZDcvlBANtS8R5Vq1GdeZA-1
Received: by mail-qv1-f71.google.com with SMTP id c10-20020a05621401ea00b004c72d0e92bcso5054042qvu.12
        for <linux-crypto@vger.kernel.org>; Mon, 09 Jan 2023 03:53:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZT+C8iVlMW2cC5v0WiwtfPl4IXfefK4BJ9hDx37N9LU=;
        b=4IVzSYGR3+iSMqSSyZak17+tsJb/PoKrXOzs3z19r/G/fwmo34QVJSvRHXmgGB6xT9
         xx2CKbUJ1pXMcvybDcnVa3BNO1ihNEOpeBMwfnnbqqLrKuBmdEla1lNiIbthOtyf46Mf
         cru/W5me/j7kw3JUqd0aedcvKEyusN57a6FOJd6D2uyv7kFt51zVQ+ZRtk3hr4E0ejMS
         Mar0Vnju6GE+ihVGOjd2MmPy/dzCfLkLsNxfL+6ZjjTfPBDwUK6iIXqBLaHdGGvqkdwo
         QrImATBCuyos/5gqNic6eLvpj+YkxgWJcg2cuM2L6OJxpLAWvRxuPxu8NP6ChfZTU6PU
         U//Q==
X-Gm-Message-State: AFqh2kqvHja68bvEVd5FLP+VL7tsA1bOxRMFRuFpKQxPwCSEVphutI8c
        hhaJTr2q6Z/zzfB6/NqOofvhomzhSQCp8gxzXw6ZydoKbEWOHCK81eJDE+7/PdiDltM28+Dg3Hg
        0LnAOnaOm7OORIA3imPpZ7vtGAyovW6oySrf5LJ8l
X-Received: by 2002:a05:622a:2282:b0:3ab:c8c6:51ba with SMTP id ay2-20020a05622a228200b003abc8c651bamr731548qtb.597.1673265190901;
        Mon, 09 Jan 2023 03:53:10 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsAv8CBtPDy6ySW2hwbwq/T3ofuZmSkH3vcnnckU1rf3jtPGqFKt6eK17aWte1O2YYiK22atrD351JpSj7wAPo=
X-Received: by 2002:a05:622a:2282:b0:3ab:c8c6:51ba with SMTP id
 ay2-20020a05622a228200b003abc8c651bamr731544qtb.597.1673265190648; Mon, 09
 Jan 2023 03:53:10 -0800 (PST)
MIME-Version: 1.0
References: <20230109021502.682474-1-koba.ko@canonical.com>
In-Reply-To: <20230109021502.682474-1-koba.ko@canonical.com>
From:   Vladis Dronov <vdronov@redhat.com>
Date:   Mon, 9 Jan 2023 12:52:59 +0100
Message-ID: <CAMusb+SK3SPOijFw2wkivXQbhaJfe1Fhd0XNNv95soZdBP4eRA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccp - Failure on re-initialization due to
 duplicate sysfs filename
To:     Koba Ko <koba.ko@canonical.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

This looks good to me, thanks, Koba:

Reviewed-by: Vladis Dronov <vdronov@redhat.com>

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

