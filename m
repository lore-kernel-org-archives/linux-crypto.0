From: Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] crypto: caam - fix JR platform device subsequent (re)creations
Date: Mon, 3 Apr 2017 10:52:28 -0500
Message-ID: <CAL_JsqL2f3m4P1Ftec0Foa43U5tkv2aPGcHR_kNLdS=YDKmgww@mail.gmail.com>
References: <CAL_JsqLHEycZLaxLZcAnDS4gp6D8xQDpgZXV1g3dokzF_EeQtQ@mail.gmail.com>
 <20170403151204.27488-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Dan Douglass <dan.douglass@nxp.com>,
        Ruchika Gupta <ruchika.gupta@nxp.com>
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753963AbdDCPwx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Apr 2017 11:52:53 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
        by mail.kernel.org (Postfix) with ESMTP id D124720155
        for <linux-crypto@vger.kernel.org>; Mon,  3 Apr 2017 15:52:51 +0000 (UTC)
Received: from mail-yb0-f170.google.com (mail-yb0-f170.google.com [209.85.213.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07B1A20123
        for <linux-crypto@vger.kernel.org>; Mon,  3 Apr 2017 15:52:50 +0000 (UTC)
Received: by mail-yb0-f170.google.com with SMTP id l201so27127074ybf.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Apr 2017 08:52:49 -0700 (PDT)
In-Reply-To: <20170403151204.27488-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 3, 2017 at 10:12 AM, Horia Geantă <horia.geanta@nxp.com> wrote:
> The way Job Ring platform devices are created and released does not
> allow for multiple create-release cycles.
>
> JR0 Platform device creation error
> JR0 Platform device creation error
> caam 2100000.caam: no queues configured, terminating
> caam: probe of 2100000.caam failed with error -12
>
> The reason is that platform devices are created for each job ring:
>
>         for_each_available_child_of_node(nprop, np)
>                 if (of_device_is_compatible(np, "fsl,sec-v4.0-job-ring") ||
>                     of_device_is_compatible(np, "fsl,sec4.0-job-ring")) {
>                         ctrlpriv->jrpdev[ring] =
>                                 of_platform_device_create(np, NULL, dev);
>
> which sets OF_POPULATED on the device node, but then it cleans these up:
>
>         /* Remove platform devices for JobRs */
>         for (ring = 0; ring < ctrlpriv->total_jobrs; ring++) {
>                 if (ctrlpriv->jrpdev[ring])
>                         of_device_unregister(ctrlpriv->jrpdev[ring]);
>         }
>
> which leaves OF_POPULATED set.
>
> Use of_platform_populate / of_platform_depopulate instead.
> This allows for a bit of driver clean-up, jrpdev is no longer needed.
>
> Logic changes a bit too:
> -exit in case of_platform_populate fails, since currently even QI backend
> depends on JR; true, we no longer support the case when "some" of the JR
> DT nodes are incorrect
> -when cleaning up, caam_remove() would also depopulate RTIC in case
> it would have been populated somewhere else - not the case for now
>
> Fixes: 313ea293e9c4d ("crypto: caam - Add Platform driver for Job Ring")
> Reported-by: Russell King <rmk+kernel@armlinux.org.uk>
> Suggested-by: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Acked-by: Rob Herring <robh@kernel.org>
