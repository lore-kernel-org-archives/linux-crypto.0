Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0ADC3DA6E
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Dec 2022 05:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiLQFFN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Dec 2022 00:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbiLQFFK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Dec 2022 00:05:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E40D680B5
        for <linux-crypto@vger.kernel.org>; Fri, 16 Dec 2022 21:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671253454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5U9JSWe0Cb7QSDp7wHEROQEZPSJHdB4ZZYbZ5fNUQg=;
        b=PJS2tJvZ7sfsDo06erro7arLgUYWUlS0v2vrPAq9fSbSMdCValj7blEi3SEMKfDc6fLdIZ
        j34a5NlrNsKlsDtd6rA0HvWEOa9RdFbfAatqOPQHms5M/vf2d7ezhL6XT7jEgsAMQTvaHq
        DVdCYaB9H4zzzC6Yznyh/T5tdPj/ZDw=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-541-KwulQmg5MH-QgMgphHYabA-1; Sat, 17 Dec 2022 00:04:13 -0500
X-MC-Unique: KwulQmg5MH-QgMgphHYabA-1
Received: by mail-oi1-f198.google.com with SMTP id s28-20020a056808209c00b00360d1531764so708916oiw.12
        for <linux-crypto@vger.kernel.org>; Fri, 16 Dec 2022 21:04:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U5U9JSWe0Cb7QSDp7wHEROQEZPSJHdB4ZZYbZ5fNUQg=;
        b=nrwdtCiVz1e1FhRERJ+SL4q9H0XNfcivmS5RdJuY3jaAmoRKWgCACiAsuQ0QLHwfiV
         YCsrixymhRui1/XfwDtWOX2L1LMSzHroT2qhTdWrejok0ks3MYKSDXatzWGoZm1YLfmC
         KBxKCY5EMncOxJswP3lkOWWF/JQ9NOK0eZGRmlY00TVx79qnxnyGvPtctn90XGGEN3cf
         WYwh6QE53BYYXJQMm6FcLaHJJJ1UVv+90DFy1j+jtvUnKKgG0Q7jFyDkAB6LPR7r0bZt
         p1GoNPSuu31kGhcbAZE9LsVOXVPWan+TTp4fa4mxNGPc2fH4y8tf1sid6Eg3pzfHnY9d
         BCrw==
X-Gm-Message-State: ANoB5pmPUsw0nvuGRiZZu1I6DLHShWrEBGom+fLkWkSVTH1qmxW4cLL4
        mfsyJUTPy21bbYVHv/wTR/HjYgnaM6TxqqVPsEOmvJ98xhMrt/kwmteRkAH6QziNa6KrBoZwfSz
        Xj70oAA0V0grezZ7Xudkzh+c4
X-Received: by 2002:a05:6830:26c3:b0:670:6c81:6e55 with SMTP id m3-20020a05683026c300b006706c816e55mr17070806otu.3.1671253452560;
        Fri, 16 Dec 2022 21:04:12 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7OcKfeIWpJo8DQSSLbUY371A1pSB8JS42w8afRBefYfX8GfTKt9XdbGTUa3+d37ndPA7Huog==
X-Received: by 2002:a05:6830:26c3:b0:670:6c81:6e55 with SMTP id m3-20020a05683026c300b006706c816e55mr17070784otu.3.1671253452251;
        Fri, 16 Dec 2022 21:04:12 -0800 (PST)
Received: from ?IPv6:2804:1b3:a803:128a:7e6a:b702:e62d:3eea? ([2804:1b3:a803:128a:7e6a:b702:e62d:3eea])
        by smtp.gmail.com with ESMTPSA id g17-20020a9d6b11000000b00660e833baddsm1768808otp.29.2022.12.16.21.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 21:04:11 -0800 (PST)
Message-ID: <5bf73d21c03d4a642eb81de35544a4d6cfa9294c.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] sched/isolation: Improve documentation
From:   Leonardo =?ISO-8859-1?Q?Br=E1s?= <leobras@redhat.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Date:   Sat, 17 Dec 2022 02:04:03 -0300
In-Reply-To: <20221129115439.GA1715045@lothringen>
References: <20221013184028.129486-1-leobras@redhat.com>
         <20221013184028.129486-3-leobras@redhat.com>
         <20221129115439.GA1715045@lothringen>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 2022-11-29 at 12:54 +0100, Frederic Weisbecker wrote:
> On Thu, Oct 13, 2022 at 03:40:27PM -0300, Leonardo Bras wrote:
> > Improve documentation on housekeeping types and what to expect from
> > housekeeping functions.
> >=20
> > Signed-off-by: Leonardo Bras <leobras@redhat.com>
> > ---
> >  include/linux/sched/isolation.h | 25 ++++++++++++++++---------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isol=
ation.h
> > index 762701f295d1c..9333c28153a7a 100644
> > --- a/include/linux/sched/isolation.h
> > +++ b/include/linux/sched/isolation.h
> > @@ -7,18 +7,25 @@
> >  #include <linux/tick.h>
> > =20
> >  enum hk_type {
> > -	HK_TYPE_TIMER,
> > -	HK_TYPE_RCU,
> > -	HK_TYPE_MISC,
> > -	HK_TYPE_SCHED,
> > -	HK_TYPE_TICK,
> > -	HK_TYPE_DOMAIN,
> > -	HK_TYPE_WQ,
> > -	HK_TYPE_MANAGED_IRQ,
> > -	HK_TYPE_KTHREAD,
> > +	HK_TYPE_TIMER,		/* Timer interrupt, watchdogs */
>=20
> More precisely:
>=20
>      /* Unbound timer callbacks */
>=20
> > +	HK_TYPE_RCU,		/* RCU callbacks */
>=20
> More generally, because it's more than just about callbacks:
>=20
>      /* Unbound RCU work */

Both updated, thanks!

Out of curiosity, what does 'Unbound' means in this context?

>=20
> > +	HK_TYPE_MISC,		/* Minor housekeeping categories */
> > +	HK_TYPE_SCHED,		/* Scheduling and idle load balancing */
> > +	HK_TYPE_TICK,		/* See isolcpus=3Dnohz boot parameter */
>=20
> Yes or nohz_full=3D
>=20
> > +	HK_TYPE_DOMAIN,		/* See isolcpus=3Ddomain boot parameter*/
> > +	HK_TYPE_WQ,		/* Work Queues*/
>=20
>   /* Unbound workqueues */
>=20
> > +	HK_TYPE_MANAGED_IRQ,	/* See isolcpus=3Dmanaged_irq boot parameter */
> > +	HK_TYPE_KTHREAD,	/* kernel threads */
>=20
>   /* Unbound kernel threads */
>=20
>=20
> >  	HK_TYPE_MAX
> >  };
> > =20
> > +/* Kernel parameters like nohz_full and isolcpus allow passing cpu num=
bers
> > + * for disabling housekeeping types.
> > + *
> > + * The functions bellow work the opposite way, by referencing which cp=
us
> > + * are able to perform the housekeeping type in parameter.
> > + */
>=20
> *below
>=20
> Thanks!

Done, done, done, done.
Thanks a lot for reviewing!

Best regards,
Leo

>=20
> > +
> >  #ifdef CONFIG_CPU_ISOLATION
> >  DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
> >  int housekeeping_any_cpu(enum hk_type type);
> > --=20
> > 2.38.0
> >=20
>=20

