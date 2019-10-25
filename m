Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76127CA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 09:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A17921D7B
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 09:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ox4psQ+D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730221AbfJYJeE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 05:34:04 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36183 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbfJYJeE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 05:34:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id w18so1514344wrt.3
        for <linux-crypto@vger.kernel.org>; Fri, 25 Oct 2019 02:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nj5N0cwuIEfdMyg4o69ezEPhKqrHPL5y4BGXRPhXkhM=;
        b=Ox4psQ+D9Aon5jdFqP9hZAU82dvvqpHrYlyw1U71YdGwg1ruw6T2nWCIDV4SZumlwX
         NZ50aLRBjXgS1ghIkZsObVYJ62kO9cvgpblReUZhnmntfLFV0tc6BiJQ9XyR02IB6r9u
         /Q5mpSe9QXoW9+9u5R43BJbM/yHZ0JjD0H2GSLc1VG7zCILBp809QfnMmNGinZmYnmKk
         o/LMQpNWraMOwpVTCvuO40hRfXkaamdRFPRKoUX1gA4pPqBRRiQpznj5xEcwnwCeFu7F
         Fy+KAVNBkiqo+vb6X+kweV2j8YipD6rKUqTvqJTVe+njLmcFoehYsFtf856upd7U2TfA
         gskw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nj5N0cwuIEfdMyg4o69ezEPhKqrHPL5y4BGXRPhXkhM=;
        b=avEVKv28D6GGu2SAf6+fODCw6pWMrpXKhm2ZJVebmmR20fGevMll0kXbSDefTm5HTg
         wbXCO5QYuQXEy6MdCWtebxcyddhgNjscMBabHECooRzLnyk0lk/pCaTQuVn12Rk2Y/Qp
         HO2EkR3vTMfS5xcZj+Pt5Vt+Hw15T9ZisqJthd9q0JmsAb4wtyl0HQV/86eLPdmlcnbl
         qy4Pa0dzcIWiYfjtByRtQqS7arVv0v8SSY06eKXQvpSMdy/SxYcp3alpNpgeUKxJxs21
         j+KasQ9cbppNsfqULv/8X0z+nPZ5Q/AucEeWNcB4BSduZ5JCsmfYJc4+Myb4lQ6mDPZr
         nBmg==
X-Gm-Message-State: APjAAAXxGLbjwNNxCBTO1vVuzrHU8FqfE0jo2C678sa4tQDCZTp3fueF
        jrcawoD+ZCNksNf8dzzHzNCN66qAdY59WnXbz7PKxXGMOqGJ+Q==
X-Google-Smtp-Source: APXvYqx/qJsN2qz7jYls/SoGQQO+isaqWDMB07jXtWfBz9ISudc2jhfrz0asa6LRApcE6FDYxSoqV1eqqsfc1d1djcM=
X-Received: by 2002:adf:f685:: with SMTP id v5mr2135586wrp.246.1571996042197;
 Fri, 25 Oct 2019 02:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <78b1532c-f8bf-48e4-d0a7-30ea0137d408@huawei.com>
In-Reply-To: <78b1532c-f8bf-48e4-d0a7-30ea0137d408@huawei.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 25 Oct 2019 11:33:59 +0200
Message-ID: <CAKv+Gu_MVe8mEeC-fVVbbLfUv-rEEk5_eoxfHjTCMgAFmSHrJw@mail.gmail.com>
Subject: Re: [PATCH] crypto: qat - remove redundant condition accel_dev->is_vf
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "hushiyuan@huawei.com" <hushiyuan@huawei.com>,
        "linfeilong@huawei.com" <linfeilong@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 25 Oct 2019 at 09:24, Yunfeng Ye <yeyunfeng@huawei.com> wrote:
>
> Warning is found by the code analysis tool:
>   "Redundant condition: accel_dev->is_vf"
>
> So remove the redundant condition accel_dev->is_vf.
>
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> ---
>  drivers/crypto/qat/qat_common/adf_dev_mgr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
> index 2d06409bd3c4..b54b8850fe20 100644
> --- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
> +++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
> @@ -196,7 +196,7 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
>         atomic_set(&accel_dev->ref_count, 0);
>
>         /* PF on host or VF on guest */
> -       if (!accel_dev->is_vf || (accel_dev->is_vf && !pf)) {
> +       if (!accel_dev->is_vf || !pf) {

I disagree with this change. There is no bug here, and the way the
condition is formulated self-documents the code, i.e.,

IF NOT is_vf
OR (is_vf BUT NOT pf)

Using an automated tool to reduce every boolean expression to its
minimal representation doesn't seem that useful to me, since the
compiler is perfectly capable of doing that when generating the object
code.




>                 struct vf_id_map *map;
>
>                 list_for_each(itr, &accel_table) {
> @@ -292,7 +292,7 @@ void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev,
>                        struct adf_accel_dev *pf)
>  {
>         mutex_lock(&table_lock);
> -       if (!accel_dev->is_vf || (accel_dev->is_vf && !pf)) {
> +       if (!accel_dev->is_vf || !pf) {
>                 id_map[accel_dev->accel_id] = 0;
>                 num_devices--;
>         } else if (accel_dev->is_vf && pf) {
> --
> 2.7.4
>
