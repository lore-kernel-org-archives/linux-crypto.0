Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E44C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Apr 2022 10:03:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388051AbiDUKGK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Apr 2022 06:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235671AbiDUKGJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Apr 2022 06:06:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1B2A225C47
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 03:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650535395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3vq86JCoV+C9mqU7b1xTiv86MtelUtShbMIhjJUfw1o=;
        b=BKO+688cDStPykeI2+/IdI83fmBeJlQ2YEpzJ1H9KMziLaYzXCpnQWUlbPhZkGx7Oghgkp
        GuYB+2D/uwm6FpfPwJr/oQNTRfxDYQAgsz8c70jcRFYlanp3iOD6Ebm1mha9fTned32roS
        +ryP8Q1YVqOsPcxOLqA5iKMTxNvEzXs=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-Z0KCrevQMYSzieclOpheLw-1; Thu, 21 Apr 2022 06:03:13 -0400
X-MC-Unique: Z0KCrevQMYSzieclOpheLw-1
Received: by mail-ej1-f69.google.com with SMTP id sb12-20020a1709076d8c00b006efa121ff38so2243254ejc.16
        for <linux-crypto@vger.kernel.org>; Thu, 21 Apr 2022 03:03:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3vq86JCoV+C9mqU7b1xTiv86MtelUtShbMIhjJUfw1o=;
        b=IfMJVK5BNDPoEvAkKkv2pvnE43yL+HGcuhbsQ6cEELn8tSwfQkX8hXiD5QRathAnNg
         cixkmnfckCvIpwaxsrPejeMudUa2Rt0ydTWt1RpHdfoIvuZPiyD3t9lMlUmP/eyzyuzx
         Zzyeq08ILMfHFaEnlQzOwZ3NhBOtiNXeco2kiYnVDRMH9B1qiDsX2KZNbGMgSk2VgvZR
         gQsura14TMamkC2GrHT/BcmitJByS+p3MiesMYQ/d/9QSbjO1hfQzS3W5sHG+XebTADl
         Lj33hCQ8ETp8LCAY5NOS1oWDl2yxM13uU0gqo6WBWYFzMWVC2VYxy5ytO1uVy+zW+SdX
         SrgA==
X-Gm-Message-State: AOAM530zDCi0qbJpqVCwtSjY8E7C+kyKeNh4kkPK3pkaqXMC49ckTRyc
        G1j2kUwxQw+B7No+bShVAtKso90Z4Ag6oWbZ8Zfwrb7iGOFxIebCTf3U5zLjtI61Lj8Y2EzEVA3
        lq2qEB1+ddg7KupehTae2hcJHfaxonjqsHNXDm03L
X-Received: by 2002:aa7:cc02:0:b0:411:487e:36fe with SMTP id q2-20020aa7cc02000000b00411487e36femr28151585edt.338.1650535392826;
        Thu, 21 Apr 2022 03:03:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx22YA5KZkNZRsKrQK63lKlMUWFkiMYZjR3oC031zsx7RXTsV6IvSw8sKZUCnChK6go16jMM5+1Tiq6ih81uUw=
X-Received: by 2002:aa7:cc02:0:b0:411:487e:36fe with SMTP id
 q2-20020aa7cc02000000b00411487e36femr28151563edt.338.1650535392596; Thu, 21
 Apr 2022 03:03:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220413141606.8261-1-vdronov@redhat.com> <YmErJGiTYjlOus5D@gondor.apana.org.au>
In-Reply-To: <YmErJGiTYjlOus5D@gondor.apana.org.au>
From:   Vlad Dronov <vdronov@redhat.com>
Date:   Thu, 21 Apr 2022 12:03:01 +0200
Message-ID: <CAMusb+TSLV11mhVNh3EMcs2p9CTJH8uHdE-bum9vWryHjJWiCw@mail.gmail.com>
Subject: Re: [PATCH 0/2] hwrng: cn10k - Optimize random number generator driver
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Joseph Longever <jlongever@marvell.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 21, 2022 at 12:00 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> All applied.  Thanks.

Thanks a ton, Herber!

Best regards,
Vladis

