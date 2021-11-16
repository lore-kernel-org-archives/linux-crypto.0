Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A75EFC433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 13:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F74260EE0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 13:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbhKPNFg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 08:05:36 -0500
Received: from pegase2.c-s.fr ([93.17.235.10]:37269 "EHLO pegase2.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236469AbhKPNFc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 08:05:32 -0500
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
        by localhost (Postfix) with ESMTP id 4HtmS96gnmz9sSD;
        Tue, 16 Nov 2021 14:02:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
        by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id k0lLfgbTW02j; Tue, 16 Nov 2021 14:02:33 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase2.c-s.fr (Postfix) with ESMTP id 4HtmS95sz3z9sS6;
        Tue, 16 Nov 2021 14:02:33 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B64088B77A;
        Tue, 16 Nov 2021 14:02:33 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id lWkZgdczF1MK; Tue, 16 Nov 2021 14:02:33 +0100 (CET)
Received: from [192.168.234.8] (unknown [192.168.234.8])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 610B78B763;
        Tue, 16 Nov 2021 14:02:33 +0100 (CET)
Message-ID: <03183ae9-3dd3-b0da-31e6-c186b2bfcfcc@csgroup.eu>
Date:   Tue, 16 Nov 2021 14:02:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/8] memset() in crypto code
Content-Language: fr-FR
To:     Sandy Harris <sandyinchina@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
References: <CACXcFmkO0g2YRjvfknKXr_ZnJaMg2cpvOsLq=h1ZcB=hg9NK8w@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <CACXcFmkO0g2YRjvfknKXr_ZnJaMg2cpvOsLq=h1ZcB=hg9NK8w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 16/11/2021 à 12:20, Sandy Harris a écrit :
> Fairly often we want to clear some memory in crypto code; it holds
> things we are done using and do not want to leave lying around where
> an enemy might discover them. Typical examples are crypto keys or
> random numbers we have generated and used for output.
> 
> The obvious way to do this is with memset(address,0,bytes) but there
> is a problem with that; because we are done using that memory, the
> compiler may optimise away the "useless" memset() call. Using
> memzero_explicit(address,bytes) instead solves the problem; that
> function is designed to resist the optimisation.
> 
> There are well over 100 memset() calls in .c files in the crypto and
> security directories. I looked at them all and found about a dozen in
> eight files that I thought should be changed to memzero_explicit().
> Here they are as patches 1 to 8 in this series.
> 
> I did read some code & think moderately carefully, but I do not know
> the code deeply & it is possible I have made some errors. I think
> false positives (making unnecessary changes) are more likely than
> false negatives (not catching necessary changes).
> 

I see no point in doing 8 separate patches that all have the same 
subject and the exact same light description.

I think it would be better to have a single patch with all the changes, 
and use the cover letter description as description for that patch.

Christophe
