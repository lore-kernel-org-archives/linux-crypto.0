Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B544C64EC4
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Mar 2023 11:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbjCCL5V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Mar 2023 06:57:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCCL5T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2023 06:57:19 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1695D773
        for <linux-crypto@vger.kernel.org>; Fri,  3 Mar 2023 03:57:18 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id u3-20020a4ad0c3000000b0052541ef0bafso380116oor.5
        for <linux-crypto@vger.kernel.org>; Fri, 03 Mar 2023 03:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google; t=1677844638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u98Ss8tAQ9VElZRSWV8UR9Qk7Tg0zOIdLlJYmBxynas=;
        b=jfL95YA8y5itMCDnzJGik1tLz4XYXJDoXuO5pQtehMGKZ2jUFgb+NlH6uzjYBp1PRX
         hFsixDIBN3GnQigvDm0SDiLKwgxuOJyjA0yL3OLNgrbzeF+o3yd65/dqb+P0vKGFHOpk
         jSQT1Jt1Qij/vdNSVVk8icAJ3b4Rvpp93zvmwq4u25nty7YgAXFSccAziyweSc2L04Cu
         PeuSWuDz7/y+Z693rZ9f2Rncy7hkyFqvqTtz/LeEfMItArQMTztY/2UcFdHx/QtGLQtJ
         4BXJL1+4Ky7Aas3cJHsSXeU2a7d3usPf7H10ysSl5h4e8Hv2gImt9YE6BENLhdX/wp0T
         6u/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677844638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u98Ss8tAQ9VElZRSWV8UR9Qk7Tg0zOIdLlJYmBxynas=;
        b=DB18HrP4LnBj2YJdKOrY3KGezx8ZUyBrRUiEHHBsz0GjSBEGl3sK3IvxMun8sPlbd5
         D6vfNEMRerkrO570jLjelCnnPOitOT+qrCRLxX5JkWqmaCZDIe/p0v3CG4BGSxamrIO4
         lwtNK+8l1jW1ECA5qzxOhVcSeWVMumXdjQrOu8pQlgRQYkDsISp+1xkoP7UTNifUIwp0
         lj+bbQpG4zcsy0ncfh42o1lakhTjCIoRxexj/TGXxO02u2lX4HVRopeVOXrRDVWEHHy/
         Yn4rFjnCUHaWs1Ez2dG2OcOvzPxdiu7xPvMvGJDSW2BiAQaAJwzReOhWBd2eTxYOvzXF
         WR2Q==
X-Gm-Message-State: AO0yUKVxj4rsPBhVma2o6GcTzbcvrICAqXyqGKbwwruVb8x7BN52GKpG
        ofUUNAI3PL4YCqhLw3bwK9frpYchxrUiPv3mGM58Ww==
X-Google-Smtp-Source: AK7set/ocFw0ey8rwseexbbsGXOfwjdJL9k1kiPCAdmMzUuQuD6Nbal/wBc8frB2SvM2qL80fR9lqbDFGzp81gS72VA=
X-Received: by 2002:a4a:956e:0:b0:525:6065:95c9 with SMTP id
 n43-20020a4a956e000000b00525606595c9mr653680ooi.0.1677844638088; Fri, 03 Mar
 2023 03:57:18 -0800 (PST)
MIME-Version: 1.0
References: <20230302194235.1724-1-mario.limonciello@amd.com> <20230302194235.1724-10-mario.limonciello@amd.com>
In-Reply-To: <20230302194235.1724-10-mario.limonciello@amd.com>
From:   Grzegorz Bernacki <gjb@semihalf.com>
Date:   Fri, 3 Mar 2023 12:57:07 +0100
Message-ID: <CAA2Cew7emsVMmKk1jz+XYnYKJasZ3w35jh-+8TFTG5UCD88eHA@mail.gmail.com>
Subject: Re: [PATCH v2 9/9] crypto: ccp: Add doorbell register offset
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>,
        Rijo-john.Thomas@amd.com, Thomas.Lendacky@amd.com,
        herbert@gondor.apana.org.au, John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Mario,

It won't work as expected since the Skyrim device has a different
offset of cmdresp_reg, which is 0x10a40 and doorbell is actually
0x10a24. I apologize for giving you the wrong values.
thanks,
greg

czw., 2 mar 2023 o 20:43 Mario Limonciello <mario.limonciello@amd.com>
napisa=C5=82(a):
>
> The PSP in Skyrim uses i2c arbitration with a doorbell.
> Add this offset so that the communication can work.
>
> Link: Link: https://lore.kernel.org/linux-i2c/20220916131854.687371-3-jsd=
@semihalf.com/
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v1->v2:
>  * New patch
> ---
>  drivers/crypto/ccp/sp-pci.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 18aa902eb5ce..a4efcaee43d8 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -365,6 +365,7 @@ static const struct platform_access_vdata pa_v1 =3D {
>         .cmdresp_reg            =3D 0x10570,      /* C2PMSG_28 */
>         .cmdbuff_addr_lo_reg    =3D 0x10574,      /* C2PMSG_29 */
>         .cmdbuff_addr_hi_reg    =3D 0x10578,      /* C2PMSG_30 */
> +       .doorbell_reg           =3D 0x10a40,      /* C2PMSG_80 */
>  };
>
>  static const struct psp_vdata pspv1 =3D {
> --
> 2.34.1
>
