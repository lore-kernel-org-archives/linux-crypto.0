Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31474C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Apr 2022 12:08:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378387AbiDTMLQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Apr 2022 08:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352716AbiDTMLP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Apr 2022 08:11:15 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A1B3FBE1;
        Wed, 20 Apr 2022 05:08:30 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 21so2023151edv.1;
        Wed, 20 Apr 2022 05:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lptHMHNd+ScUKuWl5/8SwvwIgfn4FN1iUnreSYZVnhE=;
        b=KFvaUy2ImpPtYrZu5D1FENi5KXRUr+3TF1P+jAK8bh7kMDramrZS0iTogxFF07IN7N
         UvEZ685bkw0/aDh9cijBhlXly8ZYKLDSYINdM3ZLdYVoaq4Rr5JLhpcDkttbSSlXlTd3
         /BsO8NFEcc5Blp/Z/24PgVbGo7ANSkMDDV1odxmrd3sf3iBB8tv5HNPGhO3deDbmBJlV
         WjJBHNGYeHSwJh16gnRzz9ESdRSde9/yeM8YY+5cmQGrd7KyZ6nc5vvDUjvPtiWASuRp
         YqPIjLxTku3LM+4b1wLmuSTx/l44o0rQo3NBr1WWA0Tx0u0w8mxc0zopJ3y0R/BlhkIX
         Q7DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lptHMHNd+ScUKuWl5/8SwvwIgfn4FN1iUnreSYZVnhE=;
        b=5M1uT+ZYBcM3jlwKAT4LrBDAq24YrYvhdRIAIi+R8MjUGzYjgm26mAQfnxXyXHUHs+
         nsrd7bhzXZXJGEgUc0dsuv4oVwq0qUBxb169A69PjqBosGvTYRwN90g0solTC853fgBq
         utOiWN+HL350HM5I+JxIQInHBBx1f3HliccQhI/8mVfBSEm+QxZt/dMexOSLG1ZehG9e
         pcr5vc+YGReiPGMAPEs+RBl2zoLtva8s3KLqz6PdvkX37vKtRkQN4VBdk+OCPkpTmomL
         xDkfS74vjswkhP3p7EViRRvAZHcQ5wJNOzpwKS1Fx4efbCDHEqvtYomfQINUkebX4IyL
         8KLQ==
X-Gm-Message-State: AOAM531LpLphtxvnQHSDlLxYkPaGm52fUlOT/f5/1je1pNuHEplewd9V
        V4NJ8BSprHRumH+I5DQawq6HJA2jApl6ls2Q2Bw=
X-Google-Smtp-Source: ABdhPJwRET8r1MQZzGGrQkb0juXyiesspodWW0S94Yj5o3/2+PuCtjnX/U1Oy3cu/ruepfpdp6LrLU42nuBThUoZqQ4=
X-Received: by 2002:a05:6402:f29:b0:424:27d:3a7d with SMTP id
 i41-20020a0564020f2900b00424027d3a7dmr7858018eda.155.1650456508590; Wed, 20
 Apr 2022 05:08:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220419114444.586113-1-festevam@gmail.com> <VI1PR04MB5342FB22BDAF3163C7C8ECD9E7F59@VI1PR04MB5342.eurprd04.prod.outlook.com>
 <AS8PR04MB8948B99965ECED11AEE35D2FF3F59@AS8PR04MB8948.eurprd04.prod.outlook.com>
In-Reply-To: <AS8PR04MB8948B99965ECED11AEE35D2FF3F59@AS8PR04MB8948.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 20 Apr 2022 09:08:17 -0300
Message-ID: <CAOMZO5CR9XFVXgMqkws-RbjjLfo-XvxHLOZGqB9+=CSoDK6w9Q@mail.gmail.com>
Subject: Re: [EXT] [PATCH v4] crypto: caam - fix i.MX6SX entropy delay value
To:     Vabhav Sharma <vabhav.sharma@nxp.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Fabio Estevam <festevam@denx.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Vabhav,

On Wed, Apr 20, 2022 at 8:34 AM Vabhav Sharma <vabhav.sharma@nxp.com> wrote:

> There is nothing like extended entropy delay and function name seems to be incorrect, The software test were run offline across ranges of temperature, voltage and process to determine the correct entropy delay.
> However, value of 12000 is determined by running said test across voltage and temperature only for iMX6SX.

Ok, I did as you suggested and sent a v5.

Just realized that I forgot to add you on Cc. Sorry about that.

Thanks
