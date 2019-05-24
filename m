Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5279C072B5
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 10:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7880B20856
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 10:54:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="uuOGo+IA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390699AbfEXKy1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 06:54:27 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:41257 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390680AbfEXKy1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 06:54:27 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 459NXx10D0z9v2l5;
        Fri, 24 May 2019 12:54:25 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=uuOGo+IA; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id aTU46ZUojyhj; Fri, 24 May 2019 12:54:25 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 459NXw73syz9v2l4;
        Fri, 24 May 2019 12:54:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558695265; bh=pphUiu97LBODKLNcJrIM9T+r2noKdopyNPJuHbDkR9M=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=uuOGo+IALXYa6b3BmMjRdzo5rlUkaGHI+CkiLr/g0BsoVDr2jvHjr+0VznyTsuvNo
         vTfdcKHlvaDe64fURklQImFfwwNSebFa/8PmMeDdN3izUKwihLzNkcDiGsXJxSYgqV
         Cccu68eKB4rNHTznNV+kVBBF9MwYM1eS1L3oYyhc=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3193A8B7B1;
        Fri, 24 May 2019 12:54:26 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id XPMOnd9bQOIK; Fri, 24 May 2019 12:54:26 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 16BE78B79E;
        Fri, 24 May 2019 12:54:26 +0200 (CEST)
Subject: Re: another testmgr question
To:     Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523234853.GC248378@gmail.com>
 <AM6PR09MB3523CFCFE42A33621FE4ACC3D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <907eb6a5-dc76-d5ee-eccf-e7bd426a0868@c-s.fr>
 <AM6PR09MB3523D9D6D249701D020A3D74D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu_Pxv97rpt7Ju0EdtFnXqp3zoYfHtm1Q51oJSGEAZmyDA@mail.gmail.com>
 <AM6PR09MB3523A8A4BEDDF2B59A7B9A09D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <CAKv+Gu-4c-zoRfMyL8wjQWO2BWNBR=Q8o3=CjNDarNcda-DvFQ@mail.gmail.com>
 <CGME20190524101331epcas3p2f26e2f0abe56056992646e798a26470c@epcas3p2.samsung.com>
 <AM6PR09MB3523E18FC16E2FFA117127D2D2020@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <1786cc8d-187d-e3ce-376b-e728263b1e68@partner.samsung.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <18b2004a-e1df-9bbc-1833-98c09dd89bf8@c-s.fr>
Date:   Fri, 24 May 2019 12:54:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1786cc8d-187d-e3ce-376b-e728263b1e68@partner.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 24/05/2019 à 12:43, Kamil Konieczny a écrit :
> On 24.05.2019 12:13, Pascal Van Leeuwen wrote:
>>> True. Those are the "other" reasons - besides acceleration - to use hardware
>>> offload which we often use to sell our IP.
>>> But the honest story there is that that only works out for situations
>>> where there's enough work to do to make the software overhead for actually
>>> starting and managing that work insignificant. [...]
> 
> Hmm, is there any HW which support hash of zero-len message ?
> 

As far as I can see, TALITOS SEC2 does.

Christophe
