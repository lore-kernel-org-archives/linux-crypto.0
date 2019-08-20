Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7156EC3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:29:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F7C20656
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:29:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FapWINcp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbfHTU3U (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:29:20 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43066 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730618AbfHTU3U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:29:20 -0400
Received: by mail-io1-f65.google.com with SMTP id 18so14950813ioe.10;
        Tue, 20 Aug 2019 13:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=6qXb3+hkNMLokNbmTsp+ObVF0F8sjhOp4GiAYlV6riw=;
        b=FapWINcpbfTZ7UsJb/RlukZqqcIV1FVnESoBlEBwGB7TFPLwfKoXQpusi9gIN9XWDs
         nRi28QbUJ++5GcrC524pDsRJCDrTPbAT1IWULg1ST6eiiyc050z7bkOCJgsvVGIuXhRp
         gM/w67h+FSQ3JXCI8YXx9eEZ0M7DPziQByz/zuShlA3BM4cBBDDAYlML3AvwZcIrjlDU
         uwUL0KClJRQ2OisKv1rqJwCppzUT+EO+c1J0AXaKSIHGSBCdEWHm/8AFWvxCPbgX70mz
         ziYmPdkDS3mYjqOUTgZNNOboIXjlx3BTXXtImkkshc6oZMzmlq3YEYSec18NU1zXoYJb
         Ew2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=6qXb3+hkNMLokNbmTsp+ObVF0F8sjhOp4GiAYlV6riw=;
        b=lfstOBpVRH5SEZRdV6abhJ/ve74avjjwq5azmUuE7NS83TPd0E01JO7Mjw9619Jg2T
         ktulOOrlGs3cjcpLhZICwU+zJp/D6oTDBc98M8khsyyF1SqK6bFqOk2MXbijOrCJZgTD
         kq5kDuBlcAhUwPAkeCCEZYSGwN/53ocmVrXXdjdchq/cIlxnimz6eXugleEoWcvgE+70
         +Z7y6ZTlAb8JQjmLh4T1yC66SP9yxX+mDs54iylH6yMYzcgfFMsGYOel4+X6rfDSILFX
         6heUBGmhe/Znieo2kw41igr2TxS+25CDvzdnnx/Mq52XdGuQ8UwBm/CPgjb79e2eVDQt
         azQg==
X-Gm-Message-State: APjAAAWk8aRQaA5idD+fiWVYAjU6bWm/rewE9IniH+0Q7txh4L8gtSak
        JhGCk3mAMl7y6i6OrgG5arCP/qRpuUTv/2AtLvY=
X-Google-Smtp-Source: APXvYqxMUioSlImyCRLbkJuFjkcI+OqNzU5slZDniWJefqW4ZaPyuq4O4QUo+14sHbcyMfMBzeDaNnDSeb3OpBIIPcE=
X-Received: by 2002:a5e:8e08:: with SMTP id a8mr17306812ion.94.1566332959424;
 Tue, 20 Aug 2019 13:29:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190820202402.24951-1-andrew.smirnov@gmail.com> <20190820202402.24951-14-andrew.smirnov@gmail.com>
In-Reply-To: <20190820202402.24951-14-andrew.smirnov@gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 20 Aug 2019 13:29:07 -0700
Message-ID: <CAHQ1cqFWEmJsE1XrUBVvGqp-aEy5HE6GO18DX+y0kOGsc7PbMw@mail.gmail.com>
Subject: Re: [PATCH v8 13/16] crypto: caam - select DMA address size at runtime
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 20, 2019 at 1:24 PM Andrey Smirnov <andrew.smirnov@gmail.com> w=
rote:
>
> i.MX8 mScale SoC still use 32-bit addresses in its CAAM implmentation,
> so we can't rely on sizeof(dma_addr_t) to detemine CAAM pointer
> size. Convert the code to query CTPR and MCFGR for that during driver
> probing.
>
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> Cc: Chris Spencer <christopher.spencer@sea.co.uk>
> Cc: Cory Tusar <cory.tusar@zii.aero>
> Cc: Chris Healy <cphealy@gmail.com>
> Cc: Lucas Stach <l.stach@pengutronix.de>
> Cc: Horia Geant=C4=83 <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Leonard Crestez <leonard.crestez@nxp.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/crypto/caam/caampkc.c     |  8 +++----
>  drivers/crypto/caam/ctrl.c        |  5 +++-
>  drivers/crypto/caam/desc_constr.h | 10 ++++++--
>  drivers/crypto/caam/intern.h      |  2 +-
>  drivers/crypto/caam/pdb.h         | 16 +++++++++----
>  drivers/crypto/caam/pkc_desc.c    |  8 +++----
>  drivers/crypto/caam/regs.h        | 40 +++++++++++++++++++++++--------
>  7 files changed, 63 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/crypto/caam/caampkc.c b/drivers/crypto/caam/caampkc.=
c
> index 5b12b232ee5e..83f96d4f86e0 100644
> --- a/drivers/crypto/caam/caampkc.c
> +++ b/drivers/crypto/caam/caampkc.c
> @@ -17,13 +17,13 @@
>  #include "sg_sw_sec4.h"
>  #include "caampkc.h"
>
> -#define DESC_RSA_PUB_LEN       (2 * CAAM_CMD_SZ + sizeof(struct rsa_pub_=
pdb))
> +#define DESC_RSA_PUB_LEN       (2 * CAAM_CMD_SZ + SIZEOF_RSA_PUB_PDB)
>  #define DESC_RSA_PRIV_F1_LEN   (2 * CAAM_CMD_SZ + \
> -                                sizeof(struct rsa_priv_f1_pdb))
> +                                SIZEOF_RSA_PRIV_F1_PDB)
>  #define DESC_RSA_PRIV_F2_LEN   (2 * CAAM_CMD_SZ + \
> -                                sizeof(struct rsa_priv_f2_pdb))
> +                                SIZEOF_RSA_PRIV_F2_PDB)
>  #define DESC_RSA_PRIV_F3_LEN   (2 * CAAM_CMD_SZ + \
> -                                sizeof(struct rsa_priv_f3_pdb))
> +                                SIZEOF_RSA_PRIV_F3_PDB)
>  #define CAAM_RSA_MAX_INPUT_SIZE        512 /* for a 4096-bit modulus */
>
>  /* buffer filled with zeros, used for padding */
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index 47b92451756f..4b7f95f64e34 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -602,7 +602,10 @@ static int caam_probe(struct platform_device *pdev)
>         caam_imx =3D (bool)imx_soc_match;
>
>         comp_params =3D rd_reg32(&ctrl->perfmon.comp_parms_ms);
> -       caam_ptr_sz =3D sizeof(dma_addr_t);
> +       if (comp_params & CTPR_MS_PS && rd_reg32(&ctrl->mcr) & MCFGR_LONG=
_PTR)

Horia:

As I previously mentioned, i.MX8MQ SRM I have doesn't document MCFGR
bits related to this. If you don't mind, please double check that
using MCFGR_LONG_PTR here is correct.

Thanks,
Andrey Smirnov
