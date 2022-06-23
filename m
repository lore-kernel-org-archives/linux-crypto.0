Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36F70C43334
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jun 2022 07:15:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiFWHPJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jun 2022 03:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiFWHPI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jun 2022 03:15:08 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E934F45AC3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 00:15:07 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id jb13so3806119plb.9
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jun 2022 00:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2fI43SgyXceOE9zJuFaxscU7pPU4YThRfpSv6XVaZh4=;
        b=IP86r/di3Erug6zTbnaX/BM7fD2d8A1n7YJvlMk6qwRC5UKhm+qLDDqT5mSdhfa5+f
         1YjM3NQXEtEVWbsScEqKAPuRNVeZ9xhPebMkB/7eHe47GJDFyTsDgFhibCdxT5e5X9DD
         /OWwmqPICJcPG0279OlAszoVv1b4Q9szNB80gznG2k1tHKdZwCECYiofGc8CLgVDr7ED
         dJV6Bki1ZO55jwxKnKwhqfGWlwHpQ8gr++2+myBzyKmxWFQ8y31fDF91jxoVajh7FAcv
         7EuoYhRvxI3kj/m8eCAuZYD3dUxoW3hJaP+o+ky2Tz+/PN8zxsvPPyVQWXDgesFPFRLt
         BYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2fI43SgyXceOE9zJuFaxscU7pPU4YThRfpSv6XVaZh4=;
        b=0W5Wk17EQDPwbeWaRYRCbClLGQv1LeKc8RmkvHbXlapLtnfS7hBCX4K2cmvAFgUbks
         HO4F8FoXrw+aHXI0Nwf7OZV10meClnMZsY4gTMwJTeJdQF9lYfv4qxNuqSzDKz1AJqKm
         zc6UvkfJn/sXghy5HoCUMVUVB8btNdxpJnDZMQdJbRPTHgDO9TIQhDJgFZj1B74IWwcf
         uZpVRHVPuwSvHaL+Fb4o/+KpLvHh++pEbQIptNmc6QGjLY8027aDqVuMOdRFxPWuNT8H
         ZS3riaTF+9oz0mD0oM6W59FpVsTBHfSXGROomk9ieJNb0tTpF62k8uB7mcxm3XalpDUS
         ExYg==
X-Gm-Message-State: AJIora/95GGmXzAFuuFdAB18pXSk4tPl/2fTYA64ElWMZj5LPt+xGdks
        781/96AT0WVHsGGDaaOHxP1n2A==
X-Google-Smtp-Source: AGRyM1sVBSI+J5e/NtyVYmcNmQAKSOR6dZFz8jauZugXqSLa3BhAyJuXENsDC+KVKVF3KveRUa37Ow==
X-Received: by 2002:a17:902:e383:b0:16a:1cee:70c0 with SMTP id g3-20020a170902e38300b0016a1cee70c0mr21718522ple.131.1655968507523;
        Thu, 23 Jun 2022 00:15:07 -0700 (PDT)
Received: from n254-073-104.byted.org ([139.177.225.234])
        by smtp.gmail.com with ESMTPSA id g2-20020a63ad02000000b003fd1deccd4dsm14493181pgf.59.2022.06.23.00.15.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Jun 2022 00:15:07 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v2 1/4] crypto: fix the calculation of max_size for ECDSA
From:   =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>
In-Reply-To: <20220623061500.78331-1-helei.sig11@bytedance.com>
Date:   Thu, 23 Jun 2022 15:15:02 +0800
Cc:     =?utf-8?B?5L2V56OK?= <helei.sig11@bytedance.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        berrange@redhat.com, pizhenwei@bytedance.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B31AF851-9029-43DC-A9F2-BA0B3FBB0AD2@bytedance.com>
References: <20220623061500.78331-1-helei.sig11@bytedance.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        dhowells@redhat.com
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



> On Jun 23, 2022, at 2:14 PM, Lei He <helei.sig11@bytedance.com> wrote:
>=20
> From: lei he <helei.sig11@bytedance.com>
>=20
>  * asn1_encode_tag() - add a tag for optional or explicit value
> =E2=80=94=20
> 2.20.1
>=20

Sorry for accidentally separating cover-letter and pacthes, it has been =
resent, and please ignore this email.=
