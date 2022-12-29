Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8235C3DA7A
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Dec 2022 21:17:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234009AbiL2VRF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Dec 2022 16:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234212AbiL2VQs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Dec 2022 16:16:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF65A1AE
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2022 13:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672348561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RbbKKCG1Xyq1vtML62Lc3iWFrkbMdarR9zQ1HGXJi6w=;
        b=D1omf6Wg6oCB/e4l2sFQnDt7MpNRI/uX/KFkfzgzpKiu7SXyGF8nr/fyTpBG6lVL7+5fE8
        bpEVAxlxT+uPtqrK03vmlS7pyQSeNZfI0O4V/aHZ/JuL8552c7Co2t9WMElnyYEuTBFjqf
        Iracx/3guQk6TdW92LtiJxw1GSCicjE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-523-Fpszd3jwOBO1I-QcuVgNBg-1; Thu, 29 Dec 2022 16:15:55 -0500
X-MC-Unique: Fpszd3jwOBO1I-QcuVgNBg-1
Received: by mail-qv1-f72.google.com with SMTP id a15-20020ad441cf000000b004c79ef7689aso10535147qvq.14
        for <linux-crypto@vger.kernel.org>; Thu, 29 Dec 2022 13:15:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RbbKKCG1Xyq1vtML62Lc3iWFrkbMdarR9zQ1HGXJi6w=;
        b=LCeBIBZl1S62OW7prKfi0ZBdggqulCmF8C2V06uQpd5vDZNqRmGP1h9+8e8qvEQ3Jp
         rnUMb9/NgwM9G0D8scIQaS1EFpOpCGGj62/We9YPhWID+aU14xSuCq1527pUfNc42NZD
         Fubzjjk4V+WAVXHrYbZYElNorlWSnpXinpbU25cackdKdNitEQEvVhZ5OQF+3Dy9ldOi
         mb76talGKOYaTkjVwOp2UcRMGTIBVrmjnEW058Fw8D2NvQFxWGsUCMcStTNlXx909yWn
         bjRBIudyby6XcrD2X0vQs3UqDsa5aPzM+nyrAD9Ma4WY8eUxlYFNvyZ13VqhGxELEEqp
         7Gkg==
X-Gm-Message-State: AFqh2kq+krVyjW12y0fHcxruina98ZaxXNZqRu2VJGiZK44H+mmsAVTV
        Jdd/6j79Q1Br2NM5GMK8YG4O/6tI0HyfwuRZR7cHj9SX7r7Bi5hrJrEbUFLDjE5AnqLsJCWpne1
        uMPG8MNeA5NBmGaY5mOamhtulrCBsIl5F4nazLA68
X-Received: by 2002:a37:b843:0:b0:6ff:8aef:d886 with SMTP id i64-20020a37b843000000b006ff8aefd886mr896777qkf.453.1672348554322;
        Thu, 29 Dec 2022 13:15:54 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv8OGe/F/Uu4oZtGoWYTO/HtUS4b5b2xWQiR0GjbYnWvXuR5xLvbKvMlENNl+GbFlgA7XwHYM6lXA/RFAm87pk=
X-Received: by 2002:a37:b843:0:b0:6ff:8aef:d886 with SMTP id
 i64-20020a37b843000000b006ff8aefd886mr896774qkf.453.1672348554067; Thu, 29
 Dec 2022 13:15:54 -0800 (PST)
MIME-Version: 1.0
References: <20221229203708.13628-1-vdronov@redhat.com> <20221229203708.13628-7-vdronov@redhat.com>
 <Y64AQg+W0SGsYUDY@sol.localdomain>
In-Reply-To: <Y64AQg+W0SGsYUDY@sol.localdomain>
From:   Vladis Dronov <vdronov@redhat.com>
Date:   Thu, 29 Dec 2022 22:15:43 +0100
Message-ID: <CAMusb+RXTtfa5Ez+_vsYuDwyNc_U9pRRAQHcJycoiX1g=c3_GQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] crypto: testmgr - allow ecdsa-nist-p256 and -p384
 in FIPS mode
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Nicolai Stange <nstange@suse.de>,
        Elliott Robert <elliott@hpe.com>,
        Stephan Mueller <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 29, 2022 at 10:02 PM Eric Biggers <ebiggers@kernel.org> wrote:
> ... skip ...
> Please don't add my Reviewed-by to patches I didn't review.  I only gave
> Reviewed-by on "[PATCH 2/6] crypto: xts - drop xts_check_key()".  I didn't look
> at the other patches in the series much, as I'm not very interested in them.
>
> - Eric

My bad. I'm sorry for misunderstanding and this traffic and mess. Let me send v3
with your review tag for the patch 2/6 only.

Best regards,
Vladis

