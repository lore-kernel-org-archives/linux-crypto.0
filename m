Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94453C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Mar 2022 04:33:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232170AbiCWEe7 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Mar 2022 00:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCWEe4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Mar 2022 00:34:56 -0400
X-Greylist: delayed 1371 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 21:33:26 PDT
Received: from gateway31.websitewelcome.com (gateway31.websitewelcome.com [192.185.143.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136035D5F2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 21:33:24 -0700 (PDT)
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway31.websitewelcome.com (Postfix) with ESMTP id 96B1942093
        for <linux-crypto@vger.kernel.org>; Tue, 22 Mar 2022 23:10:32 -0500 (CDT)
Received: from 162-215-252-75.unifiedlayer.com ([208.91.199.152])
        by cmsmtp with SMTP
        id WsKOnH9Gzdx86WsKOn1cUB; Tue, 22 Mar 2022 23:10:32 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=roeck-us.net; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:
        To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BZKkdo1sSVKxfV6q1iBgWqA7GO4OH2toIRNkvBXIVJQ=; b=criNZPJ6YjDcgtnTv9SiV9ePxq
        5AgWDQ4b6G7azJqOJiWHrFLIAHe9+chGbQR/hDP92fKcw7QhnNv5Uk0Dpb8wKSxHH8Nly6eXA0Tx6
        /zDULqUQlbWLBC/GHI7SCIH/cf1QnBtVcXzKJ3rNtfwlbxS6gz72FgEgPgCp1VgmtwQcmDHkJodOb
        A4Mi9zZdq23n7GcykfDqc4ymOmnT2vUWY91hvbOMf8u4XhaANqbR9pnMc3HMQG2xbEAfQhJNVNJeI
        TWA1gy2L94sDWV+/aIpaQoZPSE97Au2fsEt00IX7M0JcvEaRH29ZrNMN3KlIXfspZEeB2/2pnQmME
        eh0Ej1kg==;
Received: from 108-223-40-66.lightspeed.sntcca.sbcglobal.net ([108.223.40.66]:57620 helo=localhost)
        by bh-25.webhostbox.net with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@roeck-us.net>)
        id 1nWsKN-001pSg-Um; Wed, 23 Mar 2022 04:10:32 +0000
Date:   Tue, 22 Mar 2022 21:10:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Harsha <harsha.harsha@xilinx.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] cacheflush.h: Add forward declaration for struct folio
Message-ID: <20220323041030.GA2968769@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-BWhitelist: no
X-Source-IP: 108.223.40.66
X-Source-L: No
X-Exim-ID: 1nWsKN-001pSg-Um
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 108-223-40-66.lightspeed.sntcca.sbcglobal.net (localhost) [108.223.40.66]:57620
X-Source-Auth: guenter@roeck-us.net
X-Email-Count: 3
X-Source-Cap: cm9lY2s7YWN0aXZzdG07YmgtMjUud2ViaG9zdGJveC5uZXQ=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 23, 2022 at 03:35:10PM +1200, Herbert Xu wrote:
> On Tue, Mar 22, 2022 at 06:13:27AM -0700, Guenter Roeck wrote:
> > On Wed, Mar 09, 2022 at 03:20:01PM +1200, Herbert Xu wrote:
> > > This patch turns the new SHA driver into a tristate and also allows
> > > compile testing.
> > > 
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> > This results in:
> > 
> > Building s390:allmodconfig ... failed
> > --------------
> > Error log:
> > In file included from drivers/crypto/xilinx/zynqmp-sha.c:6:
> > include/linux/cacheflush.h:12:46: error: 'struct folio' declared inside parameter list will not be visible outside of this definition or declaration [-Werror]
> >    12 | static inline void flush_dcache_folio(struct folio *folio)
> 
> This should be fixed in cacheflush.h:
> 
> ---8<---
> The struct folio is not declared in cacheflush.h so we need to
> provide a forward declaration as otherwise users of this header
> file may get warnings.
> 
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Fixes: 522a0032af00 ("Add linux/cacheflush.h")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
> 
> diff --git a/include/linux/cacheflush.h b/include/linux/cacheflush.h
> index fef8b607f97e..a6189d21f2ba 100644
> --- a/include/linux/cacheflush.h
> +++ b/include/linux/cacheflush.h
> @@ -4,6 +4,8 @@
>  
>  #include <asm/cacheflush.h>
>  
> +struct folio;
> +
>  #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
>  #ifndef ARCH_IMPLEMENTS_FLUSH_DCACHE_FOLIO
>  void flush_dcache_folio(struct folio *folio);
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
