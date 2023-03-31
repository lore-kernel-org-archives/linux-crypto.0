Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A6E0C761A6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 19:29:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbjCaT3o (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCaT3o (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 15:29:44 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E91D20335
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:29:43 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id i22so16876341uat.8
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680290982; x=1682882982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nkeRp6lZuw2oE9ccSgxZK71jO5cGE2tSZwW3ZkFdEqk=;
        b=X7GQ3vC66U9gz9UKunrb9Cre/IMkVznLMyYFgIQoVAxbyQY4vTYhuhmA2k3tfmqYee
         0LbX7lId1tFsK1owk2nydnV17xAh9x3XezhwtQqzyGNu+8Tp81HoidQRNvrvKThhiTkh
         Crlb++sW/O1f+yNcbcWvesh2mVjGz5urwn2ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680290982; x=1682882982;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nkeRp6lZuw2oE9ccSgxZK71jO5cGE2tSZwW3ZkFdEqk=;
        b=AAKK4b0Bsf4IVtcULUPCB8p0jeZt06v+Lh6sgWOffVZKruT0bqO4t1bh9PlI/n/jcC
         FM0IXTb72d8F40DmEE4KXaSJVghOvUuId3FMfIg8awKxbHlO6ezFdyPrzM8EuSkkw5AD
         z19Sc+wV4PA+1sERtwLLLjOa2P5h2CSk54cF/5sLgWPhT1Lii1y8yUsXHNCEJIJi90sz
         56Fn0dNbRx6M/Vc+2jZx0cvBBRnGswWaiODBUGQMX2WRT50uWZW0zePtDS6GXpZo4VGf
         ekFX2dDVB3OkK7P7BG8baKIrSmmdkB2IaCFub39Kumit6VqZWddjgOZ0Ws9tE/wBaSm2
         hVMA==
X-Gm-Message-State: AAQBX9eYFAH7wePxR3EOL9L5jHgO6rexjgGP+Jx21VFSLeEBBlQEZ/v+
        BNevcRPw3OJ//Aqz4W7F0E7wh+vEVQzTO2Hk3Bu9xw==
X-Google-Smtp-Source: AKy350ZI8+x8V76aORHqljangOkbwMyJ7k9+bO6cD/qS6MBwGLxNCVzh1a61XK+QDEebi60pzPtz/OpBaNyBcLI3q4c=
X-Received: by 2002:a05:6130:215:b0:688:d612:2024 with SMTP id
 s21-20020a056130021500b00688d6122024mr22017553uac.2.1680290982611; Fri, 31
 Mar 2023 12:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <20230329220753.7741-1-mario.limonciello@amd.com> <20230329220753.7741-4-mario.limonciello@amd.com>
In-Reply-To: <20230329220753.7741-4-mario.limonciello@amd.com>
From:   Mark Hasemeyer <markhas@chromium.org>
Date:   Fri, 31 Mar 2023 13:29:32 -0600
Message-ID: <CANg-bXBLWLamLYf7TAAk+wiP5WVK2HWb-x12Yvw3Siq4nQq=EQ@mail.gmail.com>
Subject: Re: [PATCH v7 3/6] crypto: ccp: Return doorbell status code as an argument
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Felix Held <Felix.Held@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Reviewed-by: Mark Hasemeyer <markhas@chromium.org>
