From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v1 1/1] crypto: algif_compression - User-space interface for compression
Date: Fri, 21 Apr 2017 17:50:19 +0200
Message-ID: <1869148.qqR7Ib7PBA@tauon.chronox.de>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com> <1503555.c1mqzxcg8O@positron.chronox.de> <CACVarETMxEzAhDvHkuSVqaqxRN_SLc9pY0mmVeOT1N8PbcTf5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "akamaluddin@cavium.com" <akamaluddin@cavium.com>,
        pathreya@cavium.com, mchalla@cavium.com
To: abed mohammad kamaluddin <abedamu@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59136 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1424966AbdDUT2X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Apr 2017 15:28:23 -0400
In-Reply-To: <CACVarETMxEzAhDvHkuSVqaqxRN_SLc9pY0mmVeOT1N8PbcTf5g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 21. April 2017, 17:42:10 CEST schrieb abed mohammad kamaluddin:

Hi abed,

> Hi Stephan,
> 
> On Tue, Apr 18, 2017 at 3:42 PM, Stephan Müller <smueller@chronox.de> wrote:
> > Am Donnerstag, 13. April 2017, 20:34:54 CEST schrieb Abed Kamaluddin:
> > 
> > May I propose that you look into the patches for skcipher and aead
> > regarding memory handling updates that are currently discussed. There you
> > will find the sendmsg code with two parts:
> > 
> > 1. checking of the input data of cmsg and setting the ctx respectively.
> > 
> > 2. the big while loop for getting all user space data
> > 
> > I guess you have seen that I would like to consolidate the algif
> > implementations once the memory handling patch is in and agreed on. My
> > plan
> > is: Bullet 1 will be private to the algif implementation, so leave your
> > code. Bullet 2 will be moved into a common service function. Thus, may I
> > propose that you simply copy the entire while loop with the same TX data
> > structures into your sendmsg code. This way you do not have the mentioned
> > limit.
> > 
> > Also, simply copy the sendpage code from the patch set to support splice/
> > vmsplice.
> 
> Thanks for the suggestions and helpful pointers, I will rework the
> patch and incorporate these, hoping that the compression interface
> will be exported. These changes would also remain unaffected by any
> changes to the acomp interface.

Just diff the just RFCed algif_kpp with the proposed patch set for 
algif_skcipher and algif_aead. There you will see that 80% of all code is 
identical (if you disregard the different namespace). And that is the code I 
am referring to.
> 
> Thanks
> Abed (Cavium)
> Regards,



Ciao
Stephan
