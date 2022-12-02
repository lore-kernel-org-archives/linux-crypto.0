Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D23C47088
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Dec 2022 10:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiLBKKr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Dec 2022 05:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiLBKJu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Dec 2022 05:09:50 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEBCCCFD3
        for <linux-crypto@vger.kernel.org>; Fri,  2 Dec 2022 02:09:49 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id z192so5496321yba.0
        for <linux-crypto@vger.kernel.org>; Fri, 02 Dec 2022 02:09:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uE3RHUY4qDJsuTo1Mm2gm/Dk1gjThhPaW9LXX2ZWWSs=;
        b=EPaBrLkZ4fkUP8uopzdMzRKYOxEwG5iHDTNXIJo6PgmsZRA1iyJoLIYSxqm2silPbP
         newFWO815fXH4pW6+LlOBAbMLwouTSaU0vTKvV/sJOBzWqo/1G8v/STzmF56u1Exm+AH
         aZ4UVCOu7TgFAM2r+hlUrtQOfkRp1XnEYX7eup1XBXJBTTRKaVdrH3DhCWsat7R90TGX
         iwR7K7HI4vZO6bkWLbtvGlTxlexPWlM93Y+wuXspHHmMw1IM85Zj/OOx98p+NHHZkzw2
         1oPbxzYORPuHQ4AWyG0tLc20X8uOiDPg6uo8c+9OHrdpOdfYyxVhyJEWAFRcgMWL4ETz
         D8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uE3RHUY4qDJsuTo1Mm2gm/Dk1gjThhPaW9LXX2ZWWSs=;
        b=nDaNF8rY10ikBJeygn0acUq97DE6A2rJzBKwh+/9oQKYiDu8e6v0PlTs8u4BwfIq5g
         pIBBJFzgom+YCAr29BIuBNvXckXQ/LXPbstc1xt5RnzFpORIREJFOTjgdzxHSBw+fAC0
         FaC0eqtIw1/zIiSYRvQSkG4/wzv1lKf6MQ5bOS2G1Q9biFoTyvgQlCmqtpcFrTTpag61
         /U4B7WSIjr0GoNc9zutB1kd6crujbt7UfkbM0qHeD1qXNp/D8MZa7GMHtnkWidMVmxpR
         su/BcaL2GwgOyebuosg+uM+olDYEv/HZ0wKPy1tKDeT8/0s3BujeqAtCzY5n2hZRh88Q
         u8Xw==
X-Gm-Message-State: ANoB5pkejXanxoy46RFpIIxf5+Ykmd6ZtqinVxkHMSXiIFAMi7yd+1Hk
        TzAl8aagolrMGQzolCUzFXoCfuOZMgrGV2wSYNORlw==
X-Google-Smtp-Source: AA0mqf4qrHnBmItNuN2Sb8T6ME/Nzligux3z6GGs7/pyfkazZNenMyaJVS5oU7yFwrZZj6rTT6rkfz5IGFlDRxsKREA=
X-Received: by 2002:a5b:505:0:b0:6e6:6f6e:95ff with SMTP id
 o5-20020a5b0505000000b006e66f6e95ffmr47433566ybp.582.1669975789182; Fri, 02
 Dec 2022 02:09:49 -0800 (PST)
MIME-Version: 1.0
References: <20221128195651.322822-1-Jason@zx2c4.com> <9793c74f-2dd0-d510-d8b6-b475e34f3587@leemhuis.info>
 <Y4nJe+XMoNwTVjlh@zx2c4.com>
In-Reply-To: <Y4nJe+XMoNwTVjlh@zx2c4.com>
From:   =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>
Date:   Fri, 2 Dec 2022 11:09:38 +0100
Message-ID: <CAOtMz3P0e=8bR2RsxPB0EfsbW0CrvtasHOPgCRb2xQrr+m9yYw@mail.gmail.com>
Subject: Re: [PATCH v3] char: tpm: Protect tpm_pm_suspend with locks
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Jarkko Sakkinen <jarkko@kernel.org>, peterhuewe@gmx.de,
        stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        linux-integrity@vger.kernel.org, jgg@ziepe.ca,
        gregkh@linuxfoundation.org, arnd@arndb.de, rrangel@chromium.org,
        timvp@google.com, apronin@google.com, mw@semihalf.com,
        upstream@semihalf.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Jason,

Thanks for taking care of this!

Re 2/3 and 3/3 as you mentioned earlier, will get back to this when I
have some bandwidth and send it separately.

Best Regards,
Jan


pt., 2 gru 2022 o 10:46 Jason A. Donenfeld <Jason@zx2c4.com> napisa=C5=82(a=
):
>
> Thanks for handling this, Thorsten. I had poked Jarkko about this
> earlier this week, but he didn't respond. So I'm glad you're on the case
> now getting this in somewhere. Probably this should make it to rc8, so
> there's still one week left of testing it.
>
> Jason
