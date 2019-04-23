Return-Path: <SRS0=ov1/=SZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E0CAC10F03
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 20:20:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDC25208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 20:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BOI/MwZt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfDWUUc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:20:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:34102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfDWUUc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Apr 2019 16:20:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Al/P6FnnMt+FG9pNNKh5XSfhEIGYqFQcARjIduUFosA=; b=BOI/MwZtlezbzRQJAHb8SRihK
        D6afJdvdg9LkpOJH6MUrPFz+8UdJmc7BEJii9s8onW7mCU0h6vjaHKK4SRivfEclxI0EOgl4oR/x6
        ZJ+SNZp5AHnKXHyEXMibANVFh6e1uDkZBVQxHR7CtM/WAUCcoflQlVLARq1bq+MmIJmt2uSQHOykj
        yGkO4oFQ5FnriidqKS6ZGduXYv8sBIsiw/7Mx3K2lJF2G9ptBRhKruG9kQnJG3Tr2UrW42koS6Ttj
        1Jp5tawps2hKByg+T717zqcQu5TJnsfNyWTaE58nlR1yC/kb9ciDcu/eU4zwjQ86Rdy53J7J5/cxz
        l71twcX2g==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hJ1u3-0003bw-Gv; Tue, 23 Apr 2019 20:20:31 +0000
Subject: Re: [PATCH] crypto: ecrdsa - select ASN1 and OID_REGISTRY for EC-RDSA
To:     Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>
References: <20190423162954.7859-1-vt@altlinux.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3b74a3e8-d915-8ff3-186f-c5a774d00bc3@infradead.org>
Date:   Tue, 23 Apr 2019 13:20:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190423162954.7859-1-vt@altlinux.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/23/19 9:29 AM, Vitaly Chikunov wrote:
> Fix undefined symbol issue in ecrdsa_generic module when ASN1
> or OID_REGISTRY aren't enabled in the config by selecting these
> options for CRYPTO_ECRDSA.
> 
> ERROR: "asn1_ber_decoder" [crypto/ecrdsa_generic.ko] undefined!
> ERROR: "look_up_OID" [crypto/ecrdsa_generic.ko] undefined!
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

My tools would prefer to see the diff at one tree level higher:


> ---
>  crypto/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git crypto/Kconfig crypto/Kconfig

  diff --git a/crypto/Kconfig b/crypto/Kconfig

for any spelling of a and b.


> index 4446833f6eca..3d056e7da65f 100644
> --- crypto/Kconfig
> +++ crypto/Kconfig

  --- a/crypto/Kconfig
  +++ b/crypto/Kconfig

> @@ -264,6 +264,8 @@ config CRYPTO_ECRDSA
>  	select CRYPTO_ECC
>  	select CRYPTO_AKCIPHER
>  	select CRYPTO_STREEBOG
> +	select OID_REGISTRY
> +	select ASN1
>  	help
>  	  Elliptic Curve Russian Digital Signature Algorithm (GOST R 34.10-2012,
>  	  RFC 7091, ISO/IEC 14888-3:2018) is one of the Russian cryptographic
> 


-- 
~Randy
