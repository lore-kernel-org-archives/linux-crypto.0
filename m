Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754ECC433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Oct 2022 21:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiJGVnJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Oct 2022 17:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJGVnH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Oct 2022 17:43:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D3411C6E9
        for <linux-crypto@vger.kernel.org>; Fri,  7 Oct 2022 14:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665178985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G87IKnTFlRlP5ZA/YM0aUFdTmppoFiXpaMJaSdjq7DA=;
        b=TwCSt4Wm5IFN4/uWg+5x8XfwJqB/MgTcYa4RLPW5exKs51zGRga57HqULW0ezEtpJH+ynE
        FzpjcG+pRGJMYhBq/15mirjsWbuVev7NdHPJZ/WxHGPEg8V579sCoctjGW3rv2L32xfg/X
        lerCA+dJSYHiUrj1VfkkcMlvh20iC/4=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-f-zJBHUDM52STC87gld7og-1; Fri, 07 Oct 2022 17:43:04 -0400
X-MC-Unique: f-zJBHUDM52STC87gld7og-1
Received: by mail-oi1-f199.google.com with SMTP id bg13-20020a056808178d00b003540e5f75b7so3395548oib.7
        for <linux-crypto@vger.kernel.org>; Fri, 07 Oct 2022 14:43:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G87IKnTFlRlP5ZA/YM0aUFdTmppoFiXpaMJaSdjq7DA=;
        b=YyU8LPPNu+vwVndiR54LyFjWROD9UWQRagKSDeiz/DOPik+1k4HWri4GmWp7ipjxQ2
         ZjUVG9ODDakTKwktjrWJvI03s9wvLBOPm+puBJCHLgjJUg60LxGRqT3Jm8irq2w2crRU
         w73SAgVe3YdFB+bCBYlYqGmRYnHtwv3EmkzwUYKww6e/kJmNR+K7UYVmtKv9Vr06g7aL
         pAdaBqzXh34rDIT+WTb/SugdiXKGCXV87Sk0jkH22x7UQoGP79V4PrxC3SSIj8qpGH6c
         VnO92PnoYP5j+4yH66VtLxlv+zbSr15GR/AboACzdIL7iohtf1vPUEXOU9ZJRQB+zJg8
         aY2g==
X-Gm-Message-State: ACrzQf0XYMSBqbGzuOTjjUSefR4fbxZYYW42LlhMr/GAkOyP0kGL56eK
        tKhn53mURVFh4ItXkjwrV/p4qNfLAKh+p91l5TVc8KET0XjrvqwsjQygDpVkDBWacfql/R/7Z79
        lTYl8xCwUUHxgCYdy9tFUXxSG
X-Received: by 2002:a05:6870:9107:b0:132:b47e:2c76 with SMTP id o7-20020a056870910700b00132b47e2c76mr9271728oae.203.1665178982291;
        Fri, 07 Oct 2022 14:43:02 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7T1AloyETxY3BAZyZfMe6U/mXW2p2VpMBIVV621kKpq04eX/S6hmYsylQdmGFWsqrPrhuWaQ==
X-Received: by 2002:a05:6870:9107:b0:132:b47e:2c76 with SMTP id o7-20020a056870910700b00132b47e2c76mr9271682oae.203.1665178980604;
        Fri, 07 Oct 2022 14:43:00 -0700 (PDT)
Received: from ?IPv6:2804:1b3:a801:9473:d360:c737:7c9c:d52b? ([2804:1b3:a801:9473:d360:c737:7c9c:d52b])
        by smtp.gmail.com with ESMTPSA id f13-20020a056830204d00b006594674d4ddsm1768654otp.44.2022.10.07.14.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 14:43:00 -0700 (PDT)
Message-ID: <b23b08274ccff99fb341ea272e968f72c2e289ce.camel@redhat.com>
Subject: Re: [PATCH v1 1/1] crypto/pcrypt: Do not use isolated CPUs for
 callback
From:   Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 07 Oct 2022 18:42:57 -0300
In-Reply-To: <Yz1/TVUV+KnLvodg@fuller.cnet>
References: <20221004062536.280712-1-leobras@redhat.com>
         <Yz1/TVUV+KnLvodg@fuller.cnet>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2022-10-05 at 09:57 -0300, Marcelo Tosatti wrote:
> On Tue, Oct 04, 2022 at 03:25:37AM -0300, Leonardo Bras wrote:
> > Currently pcrypt_aead_init_tfm() will pick callback cpus (ctx->cb_cpu)
> > from any online cpus. Later padata_reorder() will queue_work_on() the
> > chosen cb_cpu.
> >=20
> > This is undesired if the chosen cb_cpu is listed as isolated (i.e. usin=
g
> > isolcpus=3D... kernel parameter), since the work queued will interfere =
with
> > the workload on the isolated cpu.
> >=20
> > Make sure isolated cpus are not used for pcrypt.
> >=20
> > Signed-off-by: Leonardo Bras <leobras@redhat.com>
> > ---
> >  crypto/pcrypt.c | 10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> > index 9d10b846ccf73..9017d08c91a8d 100644
> > --- a/crypto/pcrypt.c
> > +++ b/crypto/pcrypt.c
> > @@ -16,6 +16,7 @@
> >  #include <linux/kobject.h>
> >  #include <linux/cpu.h>
> >  #include <crypto/pcrypt.h>
> > +#include <linux/sched/isolation.h>
> > =20
> >  static struct padata_instance *pencrypt;
> >  static struct padata_instance *pdecrypt;
> > @@ -175,13 +176,16 @@ static int pcrypt_aead_init_tfm(struct crypto_aea=
d *tfm)
> >  	struct pcrypt_instance_ctx *ictx =3D aead_instance_ctx(inst);
> >  	struct pcrypt_aead_ctx *ctx =3D crypto_aead_ctx(tfm);
> >  	struct crypto_aead *cipher;
> > +	struct cpumask non_isolated;
> > +
> > +	cpumask_and(&non_isolated, cpu_online_mask, housekeeping_cpumask(HK_T=
YPE_DOMAIN));
>=20
> Since certain systems do not use isolcpus=3Ddomain, so please use a flag
> that is setup by nohz_full=3D, for example HK_FLAG_MISC:
>=20
> static int __init housekeeping_nohz_full_setup(char *str)
> {
>         unsigned long flags;
>=20
>         flags =3D HK_FLAG_TICK | HK_FLAG_WQ | HK_FLAG_TIMER | HK_FLAG_RCU=
 |
>                 HK_FLAG_MISC | HK_FLAG_KTHREAD;
>=20
>         return housekeeping_setup(str, flags);
> }
> __setup("nohz_full=3D", housekeeping_nohz_full_setup);

Oh, sure.=C2=A0
Since we are talking about WorkQueues, I think it makes sense to pick
HK_FLAG_WQ.=20

>=20
> Also, shouldnt you use cpumask_t ?/

Yeah, I think so.=C2=A0
I was quick to choose the 'struct cpumask' because all functions would oper=
ate
in this variable type, but yeah, I think it makes sense to have this variab=
le
being opaque here.

>=20
> Looks good otherwise.
>=20
> Thanks!

Thank you for reviewing!=20

Leo

>=20
>=20
> > =20
> >  	cpu_index =3D (unsigned int)atomic_inc_return(&ictx->tfm_count) %
> > -		    cpumask_weight(cpu_online_mask);
> > +		    cpumask_weight(&non_isolated);
> > =20
> > -	ctx->cb_cpu =3D cpumask_first(cpu_online_mask);
> > +	ctx->cb_cpu =3D cpumask_first(&non_isolated);
> >  	for (cpu =3D 0; cpu < cpu_index; cpu++)
> > -		ctx->cb_cpu =3D cpumask_next(ctx->cb_cpu, cpu_online_mask);
> > +		ctx->cb_cpu =3D cpumask_next(ctx->cb_cpu, &non_isolated);
> > =20
> >  	cipher =3D crypto_spawn_aead(&ictx->spawn);
> > =20
> > --=20
> > 2.37.3
> >=20
> >=20
>=20

