Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BCF6C77B73
	for <linux-crypto@archiver.kernel.org>; Sat, 27 May 2023 00:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236867AbjE0Asf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 May 2023 20:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjE0Ase (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2023 20:48:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19D3F187
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 17:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685148463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X9b3vzINIXR1anUzVhEr78wZfx7TKxIm6CwvQnMGeGU=;
        b=jDSXvIsWfFKzFQptBOU16nQa/jV7WqFbqEPTYNEjjZfzZBTZ5gz77EX/D3q+76ILtKKlYB
        +C5/JPeF5IS+OSkK1WpNeAHpzHbp6g3P1h3/gFWwRmZRYCYj/0ny1TdAlgNJhr1Kq+uk+0
        PcJpvf7N798bLHZMNfRsBQkQZZkt/EM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-dz_aewWCM6-VGDnxkWOAnA-1; Fri, 26 May 2023 20:47:42 -0400
X-MC-Unique: dz_aewWCM6-VGDnxkWOAnA-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3f51ea554a8so8962291cf.2
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 17:47:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685148462; x=1687740462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9b3vzINIXR1anUzVhEr78wZfx7TKxIm6CwvQnMGeGU=;
        b=fVCAgpsPLrWsVPGL6q39qb9tvaQPjwmLRUmkUzMV7j5g5CMPiX0c9zkdPMTayoqIND
         EqY9Aca9Z2e6/qM4e+C2ZrbObjXaXbM2Wc4yiqCGJhBfdHIw5z3DmhMJYpLbulzSKS0M
         52HLNxL3o3ZNHdQCIogj7N5kMD6pYPQ1QzBig031iE4Do+s7CXCLenRBkS9OTAWjsetU
         yXyrjN6S3dfl/7nxhqLf9na8l6+HAHBdDQ7yZhQJIdLGauOtmt+YqOp0y/8kye2+AdcD
         3VnOT/7ywir+2ucVKAtjjzegEDP6jLDRx3TX5sZ60TNgiJHqlBzFwRItgR+hGSOBZIr7
         j8oQ==
X-Gm-Message-State: AC+VfDwkZF0bGD1veud0XcTquYo6le9CofM+ikbHhykcJjL0aI2dh2I8
        SwTocBuAcgqZltF7MQOE7AO2/ect2VUN/LN2/cCNA2adw8VpSMmsEvia+OR1I64p5FuK/YgYNx4
        t7yezpkkqZgniV5FqjEr6dqSOuo79DfgV52GxyK+j
X-Received: by 2002:a05:622a:86:b0:3f6:a490:49c0 with SMTP id o6-20020a05622a008600b003f6a49049c0mr3648199qtw.49.1685148461907;
        Fri, 26 May 2023 17:47:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6HF6ptc85/qFKOadVoNN128ATBRgixZ9TzgK4szV2iFc9QcAgqllIS1WAphW/kC0r338Dd24DCMx6ic7EY3KQ=
X-Received: by 2002:a05:622a:86:b0:3f6:a490:49c0 with SMTP id
 o6-20020a05622a008600b003f6a49049c0mr3648186qtw.49.1685148461651; Fri, 26 May
 2023 17:47:41 -0700 (PDT)
MIME-Version: 1.0
References: <20221013184028.129486-1-leobras@redhat.com> <20221013184028.129486-5-leobras@redhat.com>
In-Reply-To: <20221013184028.129486-5-leobras@redhat.com>
From:   Leonardo Bras Soares Passos <leobras@redhat.com>
Date:   Fri, 26 May 2023 21:47:30 -0300
Message-ID: <CAJ6HWG62EgsivTKFUwwtSEsozY40PO8CD9P9wP7=NfYwhpBbnw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] crypto/pcrypt: Do not use isolated CPUs for callback
To:     Steffen Klassert <steffen.klassert@secunet.com>,
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
        Paolo Abeni <pabeni@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Friendly ping
(for this single patch)

On Thu, Oct 13, 2022 at 3:41=E2=80=AFPM Leonardo Bras <leobras@redhat.com> =
wrote:
>
> Currently pcrypt_aead_init_tfm() will pick callback cpus (ctx->cb_cpu)
> from any online cpus. Later padata_reorder() will queue_work_on() the
> chosen cb_cpu.
>
> This is undesired if the chosen cb_cpu is listed as isolated (i.e. using
> isolcpus=3D... or nohz_full=3D... kernel parameters), since the work queu=
ed
> will interfere with the workload on the isolated cpu.
>
> Make sure isolated cpus are not used for pcrypt.
>
> Signed-off-by: Leonardo Bras <leobras@redhat.com>
> ---
>  crypto/pcrypt.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index 9d10b846ccf73..0162629a03957 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -16,6 +16,7 @@
>  #include <linux/kobject.h>
>  #include <linux/cpu.h>
>  #include <crypto/pcrypt.h>
> +#include <linux/sched/isolation.h>
>
>  static struct padata_instance *pencrypt;
>  static struct padata_instance *pdecrypt;
> @@ -175,13 +176,15 @@ static int pcrypt_aead_init_tfm(struct crypto_aead =
*tfm)
>         struct pcrypt_instance_ctx *ictx =3D aead_instance_ctx(inst);
>         struct pcrypt_aead_ctx *ctx =3D crypto_aead_ctx(tfm);
>         struct crypto_aead *cipher;
> +       const cpumask_t *hk_wq =3D housekeeping_cpumask(HK_TYPE_WQ);
>
>         cpu_index =3D (unsigned int)atomic_inc_return(&ictx->tfm_count) %
> -                   cpumask_weight(cpu_online_mask);
> +                   cpumask_weight_and(hk_wq, cpu_online_mask);
>
> -       ctx->cb_cpu =3D cpumask_first(cpu_online_mask);
> +       ctx->cb_cpu =3D cpumask_first_and(hk_wq, cpu_online_mask);
>         for (cpu =3D 0; cpu < cpu_index; cpu++)
> -               ctx->cb_cpu =3D cpumask_next(ctx->cb_cpu, cpu_online_mask=
);
> +               ctx->cb_cpu =3D cpumask_next_and(ctx->cb_cpu, hk_wq,
> +                                              cpu_online_mask);
>
>         cipher =3D crypto_spawn_aead(&ictx->spawn);
>
> --
> 2.38.0
>

