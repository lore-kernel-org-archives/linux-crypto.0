Return-Path: <SRS0=tkOt=CC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1023C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 08:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B768520738
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Aug 2020 08:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgHXI3m convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Aug 2020 04:29:42 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:38798 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726037AbgHXI3k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Aug 2020 04:29:40 -0400
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-138-5TvUt1XsPpyGpCaE1czwzg-1; Mon, 24 Aug 2020 09:29:37 +0100
X-MC-Unique: 5TvUt1XsPpyGpCaE1czwzg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Mon, 24 Aug 2020 09:29:36 +0100
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Mon, 24 Aug 2020 09:29:36 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Yang Shen' <shenyang39@huawei.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "xuzaibo@huawei.com" <xuzaibo@huawei.com>,
        "wangzhou1@hisilicon.com" <wangzhou1@hisilicon.com>
Subject: RE: [PATCH RESEND 04/10] crypto: hisilicon/zip - replace 'sprintf'
 with 'scnprintf'
Thread-Topic: [PATCH RESEND 04/10] crypto: hisilicon/zip - replace 'sprintf'
 with 'scnprintf'
Thread-Index: AQHWecS3Jx83/+rMLUuKUpSHllsCl6lG7Xzg
Date:   Mon, 24 Aug 2020 08:29:36 +0000
Message-ID: <d1102aca2bdc4df4acc31d8b082cacce@AcuMS.aculab.com>
References: <1598238709-58699-1-git-send-email-shenyang39@huawei.com>
 <1598238709-58699-5-git-send-email-shenyang39@huawei.com>
In-Reply-To: <1598238709-58699-5-git-send-email-shenyang39@huawei.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: aculab.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Yang Shen
> Sent: 24 August 2020 04:12
> 
> Replace 'sprintf' with 'scnprintf' to avoid overrun.
> 
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>
> ---
>  drivers/crypto/hisilicon/zip/zip_main.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index df1a16f..1883d1b 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -428,7 +428,7 @@ static ssize_t hisi_zip_ctrl_debug_read(struct file *filp, char __user *buf,
>  		return -EINVAL;
>  	}
>  	spin_unlock_irq(&file->lock);
> -	ret = sprintf(tbuf, "%u\n", val);
> +	ret = scnprintf(tbuf, HZIP_BUF_SIZE, "%u\n", val);

Should that be sizeof (tbuf).

>  	return simple_read_from_buffer(buf, count, pos, tbuf, ret);
>  }
> 
> @@ -514,13 +514,16 @@ static int hisi_zip_core_debug_init(struct hisi_qm *qm)
>  	struct debugfs_regset32 *regset;
>  	struct dentry *tmp_d;
>  	char buf[HZIP_BUF_SIZE];
> -	int i;
> +	int i, ret;
> 
>  	for (i = 0; i < HZIP_CORE_NUM; i++) {
>  		if (i < HZIP_COMP_CORE_NUM)
> -			sprintf(buf, "comp_core%d", i);
> +			ret = scnprintf(buf, HZIP_BUF_SIZE, "comp_core%d", i);
>  		else
> -			sprintf(buf, "decomp_core%d", i - HZIP_COMP_CORE_NUM);
> +			ret = scnprintf(buf, HZIP_BUF_SIZE, "decomp_core%d",
> +					i - HZIP_COMP_CORE_NUM);
> +		if (!ret)
> +			return -ENOMEM;

and that is just so wrong - did you even try to test
the 'buffer too small' code path?

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

