From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: BUG: Seems un-initialed dst pointer received from algif_aead when outlen is zero
Date: Tue, 21 Mar 2017 16:00:04 +0100
Message-ID: <1593289.epxWzXFfWH@positron.chronox.de>
References: <CAFXBA==w7CK_CiiVC37NN8=7p7=a=18sNd5VTnUkDCozrMvT+w@mail.gmail.com> <3894659.2TbsNqkGul@tauon.atsec.com> <CAFXBA==5EOXOJV4UFaG+1AxAmuEo9PzFKsHe25YTMa8LGfKkkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58198 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756962AbdCUPAv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 11:00:51 -0400
In-Reply-To: <CAFXBA==5EOXOJV4UFaG+1AxAmuEo9PzFKsHe25YTMa8LGfKkkQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. März 2017, 14:23:31 CET schrieb Harsh Jain:

Hi Harsh,

> Yes, Driver can figure out when to discard dst SGL but for that Driver
> has to put checks before accessing dst SGL. Isn't better if AF_ALG
> sends NULL for dst SGL.

With the code in [1], the first longer patch is planned to be merged after the 
memory management changes are agreed upon. That patch contains:

+               /* chain the areq TX SGL holding the tag with RX SGL */
+               if (!last_rsgl) {
+                       /* no RX SGL present (e.g. only authentication) */
+                       sg_init_table(areq->first_rsgl.sgl.sg, 2);
+                       sg_chain(areq->first_rsgl.sgl.sg, 2, areq->tsgl);
+               } else {
+                       /* RX SGL present */
+                       struct af_alg_sgl *sgl_prev = &last_rsgl->sgl;
+
+                       sg_unmark_end(sgl_prev->sg + sgl_prev->npages - 1);
+                       sg_chain(sgl_prev->sg, sgl_prev->npages + 1, areq-
>tsgl);
+               }


This code snipped would exactly do what you want: the SGL is always 
initialized. Besides, the code will do an in-place cipher operation.

https://www.spinics.net/lists/linux-crypto/msg24343.html

Ciao
Stephan
