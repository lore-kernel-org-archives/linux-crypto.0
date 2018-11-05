Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:24089 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbeKESVL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 13:21:11 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: mark cts(cbc(aes)) as FIPS allowed
Date: Mon, 05 Nov 2018 09:50:12 +0100
Message-ID: <2578248.XAorIH2ink@tauon.chronox.de>
In-Reply-To: <1541325924-14777-1-git-send-email-gilad@benyossef.com>
References: <1541325924-14777-1-git-send-email-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Sonntag, 4. November 2018, 11:05:24 CET schrieb Gilad Ben-Yossef:

Hi Gilad,

> As per Sp800-38A addendum from Oct 2010[1], cts(cbc(aes)) is
> allowed as a FIPS mode algorithm. Mark it as such.
> 
> [1] https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final

There are several types of CTS approaches. Only three of those are listed in 
the SP800-38A addendum. The source code only refers to some RFCs.

Did you check whether the CTS implementation matches one or more of the types 
listed in the addendum? If yes, may I suggest to add a small statement in the 
code noting this fact?

Thanks a lot.

Ciao
Stephan
