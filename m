Return-Path: <SRS0=prwg=BQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5147C433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CA22206C3
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Aug 2020 17:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="DsaoMsJc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgHFRiU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:38:20 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:40206 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728326AbgHFRiT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Aug 2020 13:38:19 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 076Hc3MU004811;
        Thu, 6 Aug 2020 12:38:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1596735483;
        bh=vwXPIie4Fk6NjQ/oTOiMgA8dv5Jnoh1p121aYz5W/yw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=DsaoMsJckoXFsaEmYn8B94hkGNDatRz1JX8v7sH3x1Bgq6l6Pat4766+ruXBNkVN5
         g7iGs3rjUT4vNR23ZOgpiBZWQgCoXPMnW+1riXVqFvDExpumLqMg1f+cT4LOrgvbCi
         nxz4O4WheCTJDVZfTbFtGT5ydc+1MAJsRvtXuXzU=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 076Hc2Sw003462;
        Thu, 6 Aug 2020 12:38:03 -0500
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 6 Aug
 2020 12:38:03 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 6 Aug 2020 12:38:03 -0500
Received: from [10.250.160.6] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 076HbvKU024262;
        Thu, 6 Aug 2020 12:37:59 -0500
Subject: Re: [PATCH -next] crypto: sa2ul: add Kconfig selects to fix build
 error
To:     Randy Dunlap <rdunlap@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
CC:     Tero Kristo <t-kristo@ti.com>
References: <6e04b405-7369-ff04-a2dd-aa7c561e13d6@infradead.org>
From:   "J, KEERTHY" <j-keerthy@ti.com>
Message-ID: <ce215b73-4c76-648f-f19d-46930e73a5ed@ti.com>
Date:   Thu, 6 Aug 2020 23:07:56 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <6e04b405-7369-ff04-a2dd-aa7c561e13d6@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 8/6/2020 9:24 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> sa2ul.c uses sha{1,256,512}_zero_message_hash, so select the
> Kconfig symbols that provide those, like other crypto drivers do.
> 
> Fixes this build error:
> 
> ld: drivers/crypto/sa2ul.o: in function `sa_sha_digest':
> sa2ul.c:(.text+0x2b25): undefined reference to `sha512_zero_message_hash'

Thanks for catching this.

Reviewed-by: Keerthy <j-keerthy@ti.com>

> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: Randy Dunlap <rdunlap@infradead.org> # 2020-07-29
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: Tero Kristo <t-kristo@ti.com>
> Cc: Keerthy <j-keerthy@ti.com>
> ---
>   drivers/crypto/Kconfig |    3 +++
>   1 file changed, 3 insertions(+)
> 
> --- linux-next-20200806.orig/drivers/crypto/Kconfig
> +++ linux-next-20200806/drivers/crypto/Kconfig
> @@ -873,6 +873,9 @@ config CRYPTO_DEV_SA2UL
>   	select CRYPTO_AES
>   	select CRYPTO_AES_ARM64
>   	select CRYPTO_ALGAPI
> +	select CRYPTO_SHA1
> +	select CRYPTO_SHA256
> +	select CRYPTO_SHA512
>   	select HW_RANDOM
>   	select SG_SPLIT
>   	help
> 
