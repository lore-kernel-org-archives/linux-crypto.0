Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C11C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 09:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D6542489F
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 09:28:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=web.de header.i=@web.de header.b="IRjtq/gY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgFUJ2T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 05:28:19 -0400
Received: from mout.web.de ([212.227.15.3]:44297 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729573AbgFUJ2S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 05:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1592731683;
        bh=k+nctZszWHVXTeaUOOM+Rahgb3xT+byFYUzyhWax3Cw=;
        h=X-UI-Sender-Class:To:Cc:Subject:From:Date;
        b=IRjtq/gYBdYyfuU4dzz3mCe28n3PsSfu5gpxO4+sVFyO281SOJlHeehwFsSCH09+9
         MYNtEY7BvHSl/cxgVTUL+iB0FL5jiV6jwHW4tYR/6sNx6NfUSrUL7skHByO3kSTE7H
         GBHBPesLKkCCkSkfs0Gf9UV0Jp3XmbDrmsZ3wQZ0=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.131.145.213]) by smtp.web.de (mrweb001
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MLy84-1jo3Gp0Tm8-007kPu; Sun, 21
 Jun 2020 11:28:03 +0200
To:     Gilad Ben-Yossef <gilad@benyossef.com>,
        linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ofir Drang <ofir.drang@arm.com>
Subject: Re: [PATCH 1/3] crypto: ccree: fix resource leak on error path
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <3a4ddd15-e8a9-33fb-007a-d50137c378a6@web.de>
Date:   Sun, 21 Jun 2020 11:28:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:PWH2kdPCZGr0dW4y2otajdtaVleRJFwuONJz6E9A9XAm1HlWaA/
 O9k+IrMPeCCFulq/nPs5jdz0+mN6AIaXjc6u2KcQ3FbwVyiH9Khz8NrEbm8l85sZonp7CnT
 gstlo9YnSRDpfj5/ifoNsHlgNkFPYIiVBwy+0WTMWpPz5695RLFAN16rwh/yMbLnp1+k2gK
 syVzyeHrEPn/+bg61tboA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ufOXC5f9xU8=:I7FPBQZcQI5QAON2XgyAd4
 3TX1JHZPSnQ7F7UWWCu+pTk81oz+LAdE9nI4IKqfyTjPY4RhPSLAraHhNnS7fmoyBiU8TwvZb
 u3Zt+STPHWCpamkONnymZh/2Peb7t+weXVYXoirTRc/7YMdEJ7bLx0Rt/AToXNOX+DRXneVAo
 PGNDlKMaZRoqPTSd+iHaiJ0mf1avzGbsF0nJhbyYmr8dsb6Ns7VNiFBJ2Ad2OXqpcgRTUvh88
 oB0cXMP6dr5GCRPF0y7Rw1DYbuXPC2lGcJuFwT3+ll+VscGZc2rdHVDpt0IV7KMf6Of5uO5vf
 atY+BMv0quOb+CHDWkw3yoixGfBo8uUl7yVOFfUEwdPkD8t2faA9kywG8d4JxmWtcM9zqYye4
 nhgfUEH47/ilscWp9ey0K6LQwKOBWxoE2hJw66pgWw9iqiFyifOqD6cwBDbHdUSdd9kAaAoMm
 XcAx7lhMV446JtQVDzEq3Ta1G6Je4sddh3QzAnvgxb1lz7/vHYy+KL8D+UYX6lh4dlMD2FWx2
 vN+FRfB1k6oN1KhqDY9C6JOe/+xDj7fr/0OWe8wY4h1iTeJSeSlDIExMj+Sn8wvPBMKl22+oG
 gWdJP/YKwsPLCmFKsSPO8iTX5pc+syJdPRAxZdb6eNn3CHezOG4utYAoScQ4737ur8FVHNdIw
 2w1UsF/2uJaaef/qnAxV+efcz5Vt9hBGYjPBAP0c88dj9wPU84tFBYum30F4FIMucnlmV8r8g
 Wnid6uf4O10AeRnj0E4/c4W/K4f3ZviLYGf8Sm36RfJwUX1ZLKy66BpBoNFj/XQqctKF4E7fr
 Zpb+8qQHZmt+CbXzPziHMu66J7pargah1mznq0VaCBosO0tpdiP4Y1rVaYNuBYoHw+GA1yGEj
 wpHY4LpGUTjWXEMyuTCz67RnquW7cirN1SrD3c40uIz1ziy805ZCkRCkqIMMRYTkRc48At/Ue
 KQWA/qFVAPViZG6wkJnsdk1Hv8/X5TYv9hEtJswUr2z9NI89T3T5JbjlKRyN6ZY9LJBnNpCvq
 fQBv6SARVSaMuxjQaK1cg4e+mbFN3+sAmKUz7l/GE1iCf71QBScqjkGfI1Ykhloa8ytx4/SxS
 r3UHJ26zau3cxCqzgr9IlPx8HXYaajgk4kxnSl5bs48WoxBNCAkn25KL1lY3JnqfP22jZOYXd
 YKkduy5t5fLb3ZKLWC6mSr6nD/yrXrpLdsCBLBmvaCgn2RcLlsXjpz+fiComRcN/y2vtDbKTm
 mUim32+wdeddm4bJg
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Fix a small resource leak on the error path of cipher processing.

Would you like to add the tag =E2=80=9CFixes=E2=80=9D to the commit messag=
e?


=E2=80=A6
> +++ b/drivers/crypto/ccree/cc_cipher.c
=E2=80=A6
> @@ -190,21 +198,19 @@  static int cc_cipher_init(struct crypto_tfm *tfm)
=E2=80=A6
> -	return rc;
> +out_key:
> +	kfree(ctx_p->user.key);
> +out_shash:
> +	crypto_free_shash(ctx_p->shash_tfm);
=E2=80=A6

How do you think about to replace the prefix =E2=80=9Cout=E2=80=9D by =E2=
=80=9Cfree=E2=80=9D in these labels?

Regards,
Markus
