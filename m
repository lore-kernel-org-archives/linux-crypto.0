From: abed mohammad kamaluddin <abedamu@gmail.com>
Subject: Re: algif for compression?
Date: Fri, 16 Dec 2016 19:41:23 +0530
Message-ID: <CACVarEQ5B8AJDCuL7o91KibLYgukBN2R03C_7qbpNTA94RsMug@mail.gmail.com>
References: <CACVarETuTx40WFD5TRUCwiYv5r3SEvhuJHpGjqPsz90qVZsYKA@mail.gmail.com>
 <20161210081014.GA32746@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34869 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755619AbcLPOUn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 16 Dec 2016 09:20:43 -0500
Received: by mail-wm0-f54.google.com with SMTP id a197so35161915wmd.0
        for <linux-crypto@vger.kernel.org>; Fri, 16 Dec 2016 06:20:42 -0800 (PST)
In-Reply-To: <20161210081014.GA32746@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

>
> The compression interface is currently in a state of flux.  We
> should make it settle down first before exporting it to user-space.
>
> For a start it would be good to actually switch IPsec/IPcomp over
> to the new compression interface.

Thanks Herbert. Are there timelines or  ongoing efforts for moving
IPcomp/Ipsec to use acomp? Or any proposals that have been or need to
be taken up in this regard.

Thanks,
Abed
