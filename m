From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: alg_test question
Date: Wed, 03 Nov 2010 14:17:31 +0200
Message-ID: <4CD152DB.5070601@nokia.com>
References: <Pine.GSO.4.64.1011021041010.23172@well.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Mark Allyn <allyn@well.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:56746 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014Ab0KCMQ7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Nov 2010 08:16:59 -0400
In-Reply-To: <Pine.GSO.4.64.1011021041010.23172@well.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Mark,

cryptomgr_test call it like

    err = alg_test(param->driver, param->alg, type, CRYPTO_ALG_TESTED);

tcrypt_test:
    ret = alg_test(alg, alg, 0, 0);


- Dmitry


On 02/11/10 19:42, ext Mark Allyn wrote:
> What is the mask parameter for in the alg_test function? Also what is the 
> type?
>
> Better still, is there any documentation on how to use the alg_test 
> function?
>
> Thanks
>
> Truly,
>
> Mark Allyn
> Portland, Oregon
> www.allyn.com
> 971-563-7588
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   
