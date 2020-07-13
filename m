Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7208EC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 20:01:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4521E20674
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 20:01:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="sT/erWJm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgGMUBF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 16:01:05 -0400
Received: from mout.web.de ([217.72.192.78]:37451 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbgGMUBE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 16:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1594670434;
        bh=RujGpsAVt1AAWe0k3hAKmDKccNye6ezpvLYitw8/poA=;
        h=X-UI-Sender-Class:Cc:Subject:From:To:Date;
        b=sT/erWJm+P1PYhypKOREYCG6UGokcw7C9x66xKHzyV0e9OArJPjsDyXLXTt/R3b7i
         nqcC7/h8T9m8+/vlRun2+os5SOMyzRoUgRQ01eBMvDGA4v1AZ1UMSEjyc45NTjvyTh
         7d5RZQGHJ5jqQ/pTaoYD1cEseLCmIlVpG92qGBkw=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([2.243.120.168]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LZedc-1kZaRC1wWC-00lWWK; Mon, 13
 Jul 2020 22:00:34 +0200
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: Re: [PATCH 2/2] Crypto/chcr: Fix some pr_xxx messages
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
To:     Christophe Jaillet <christophe.jaillet@wanadoo.fr>,
        linux-crypto@vger.kernel.org
Message-ID: <bc539dfe-969f-7593-81ef-56b736150e25@web.de>
Date:   Mon, 13 Jul 2020 22:00:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:KMLFfuAxtnx2fPMy8OvMaheZYMeyyDHD2Hl5r7sv7PtRSDYfAsO
 QiCh2t7L1xsO2I213HvAoXjYsVzsVx8QENQJBEeAmHs7MSNffeFi0hnh6bBDgCG0PH4UY1c
 WcscvRhKWKYBya+Js762ts1LO4fmVk1SxEoHTMdPW8PY7ArDj4I+5pw5+2Qz7NrpepNQ9qo
 5v96V/47NHHg+xgZD5dZg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Xgj6ChgEQrA=:mvGTuBywLgYdgrp0CGPt28
 B8xx+IlEIg7q9+6MYynw+D9hNmAeksed/uDMRAaPnKIXrYl1Buskg7ekXz4LuGQo5Uc669pKQ
 Aq4y6Y+7K7gxBnprSDTy7m9BynbO5TLjIoIm/nM9ee8mBOQ5el6xQaBd2RxB39zqBK/wwF9P1
 MhXMiLufO5qTA/aJRE1uGZy2hOu9zP3WFI2pD+lA+T7Ak6icjzMoXjD7N+bkzICUvZ6F5+0Lj
 esLcchE4//0TyUTkzB6X0G4jKvWQ43NIFK4ZMjQqrLZC0FtdalNM8D+Jjn4kfB4FekFMuengP
 HFJX61VFdH06oo3jHD4kNBOnE1/9lCQDEBQCV75wxUxAtsIjA3cbpYQdlatxVoQfRKRDSKZZa
 9i7M1bG6qG51RSY4g6+aI4bcaZMcciVY+akKdItxgmPA6mMSgYEEVRxwTj7pHQ+lBkusCrqae
 G7PNkf2MIpzLqntQJIUXHMZaJcJcf0ixh4rcb6E/0VxlMjr4O5dZHeh4lY1Qa7d5axYtTQ9RZ
 rESmoNquJFjGv5bQ7c8bsr35o/PfRfeX0+Uy5GoBsLL9n94G7J28s4SlmxWDnpwWQyidLZJ/Z
 p+rlHNp7WhPgJy2z+36pvmEKv5UNmZuLzdBqOjKryRgvS/x2zQJFLlo4SzCrxItZjXZSr9Hta
 hMZu901a1RsFvQ/zUvGbojACQpRZ6SFwaqqlh7QWIEiyDxOLfVvwS1q8StgEmFuTOLVntl7Qb
 my1Cjf5oAFMCgYawC8xPkSo4BeIO4mqCZG2VMXm7MijPDi8wxy+mPELY6Ya7fLvlIljB3CFHO
 EqqGy9PqWcOM5mbN0k/eFyq5IqYiPh4g4JMgbPyVvf4T47vzNWGbwhZrN5uuskqsAtxHd6D6c
 BHNKB4rF07IDTJEw8iOjTOGTYEv8NaDnSmRg/oGVTn4ZyiWwsEf/akdahi1bx1k4Qdez5hzb6
 6bVmXNk+qx2mmYayubms8UCvPy40QlTqs8TUMy/t+hVkHe9X8ZJC9zc2oG6ua6woXO+O1dLYX
 yO/PvtVSUQzDY9uSTdv0gSNMf39OmzUgJL79Z20sYZtOS3vO2HNFoT4JJaEyZaIUHfG944M9U
 EYly6VJ3JmME4P0CP5e/X4F2iL7yku3nro4bNtpwYuQcfJ7YpW7lT7Bg5ya2KM1OG5330SUEn
 Y4CsCcIvaVMmHqQUHtRVzDRkWL7MlEz3fTkyLqa9tpkpTJ9P0X9boilbyirr1kl4Ng7iOL76k
 Y4aBBtBsHomvoiSGBITFfRPqIteGJZ2cmgpJHTA==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

=E2=80=A6
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -1224,7 +1224,7 @@ static int chcr_handle_cipher_resp(struct skcipher=
_request *req,
>  	wrparam.bytes =3D bytes;
>  	skb =3D create_cipher_wr(&wrparam);
>  	if (IS_ERR(skb)) {
> -		pr_err("chcr : %s : Failed to form WR. No memory\n", __func__);
> +		pr_err("%s : Failed to form WR. No memory\n", __func__);
>  		err =3D PTR_ERR(skb);
>  		goto unmap;
>  	}

I suggest to omit also a space character before the colon in such format s=
trings.

+		pr_err("%s: Failed to form WR. No memory\n", __func__);


Would you like to apply any further fine-tuning around affected error mess=
ages?

Regards,
Markus
