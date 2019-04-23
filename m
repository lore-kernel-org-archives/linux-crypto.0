Return-Path: <SRS0=ov1/=SZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BE8C282E1
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 15:22:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3FF821852
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 15:22:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="D4JBzrxm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727831AbfDWPWn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Apr 2019 11:22:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59566 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfDWPWn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Apr 2019 11:22:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NMVuLKMVPe43Kq/vQum4B86CrfQwF1HlTDnDbD6D+Ic=; b=D4JBzrxmf1cKvBr7K3398UBi4
        AWchBA6mOKSNIzLvFd71S6XVLl6m78AaZ3LX7ybPxQd7oqR1Ud6qcClfo8HijdKA2gWsaZvrPstVx
        a376pGd1ZhTLNBJepPyK0pFTVIicOc4TouggTvNG1TO4EiztR9dZhZ0pW+vptlVwEHx2oHNXzLMcA
        iDoz6c7eDvNh346TkONbFumxAXuKQCKn95JhHiO6Qym80/xhhd11nYVFSRV2PKtuWX+ok/yYqLbCQ
        6zE+FSSRj9Z0Tznu7vF1QKZIElPIxG1S7YbYmZ1kJAt3JewuASaOsIEjA9n3oLXec8hEuGPU8lB2J
        esSUu4rPA==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hIxFp-0001f4-Iv; Tue, 23 Apr 2019 15:22:41 +0000
Subject: Re: linux-next: Tree for Apr 23 (crypto/ecrdsa)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vitaly Chikunov <vt@altlinux.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
References: <20190423202832.49cdf5bc@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ea752c71-b41f-47f5-290b-3a31bb0e96df@infradead.org>
Date:   Tue, 23 Apr 2019 08:22:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190423202832.49cdf5bc@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 4/23/19 3:28 AM, Stephen Rothwell wrote:
> Hi all,
> 
> News: there will be no linux-next release on Thursday April 25.
> 
> Changes since 20190418:
> 

on i386 or x86_64:

ERROR: "asn1_ber_decoder" [crypto/ecrdsa_generic.ko] undefined!
ERROR: "look_up_OID" [crypto/ecrdsa_generic.ko] undefined!


Do you need a failing config file?

thanks.
-- 
~Randy
