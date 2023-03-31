Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DEDDC76196
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 19:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjCaT3K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 15:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCaT3J (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 15:29:09 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BCE20335
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:29:09 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id m5so16858055uae.11
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 12:29:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1680290948; x=1682882948;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nkeRp6lZuw2oE9ccSgxZK71jO5cGE2tSZwW3ZkFdEqk=;
        b=jsmTyKyyOdeTa5k7uiNpZZ4BupnT3Eb1Y0GOkElSaDZ5R28muawvLbT9aENaCtUfUw
         5jhEJ60yvufKtwaRTRXpE4iCdnathQ5eSPgJ52snsgOx3JoV9nvOv0PMZcxjHLodpmLq
         u3+uWIh/fs7Rrpbz7N8lR0Od+VmKEbHSr2TPk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680290948; x=1682882948;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nkeRp6lZuw2oE9ccSgxZK71jO5cGE2tSZwW3ZkFdEqk=;
        b=y+6iLHuPeIRwrig6dgfKr8GXTh3aKIfIc243qJmVh+r8ZDrQdQv+3YlrZTFb6bS7qv
         rrSqZibI1qf9KnOgEVC0+6J004cZB+5c6BFMCXd2FrlbvSTUWN0Vrfsmpwh5Mw8YKmua
         ux+IUzCKk67X0CJmSWLxk6y4Nzz+YnQjyUY96QxlIxa2MKTGb3DlEr6ptepdlFSfWOSM
         Ag67LMoKybP/LZJtO/EEZVksN0gMh/ZCrGs3pzSOMYxpzkpvmxXyAz3h8eyGkuL/xfGI
         ClUbdGDhIj2HnfjcESiyA5JxQbSwX9nU0jDj9rjK3RUCeRQ4VtS1ScePPTviTt9LsXaj
         UU0A==
X-Gm-Message-State: AAQBX9dOWRC93D++6mMaq8lm1DDmp/joE2Rk4Rr7LL03BZz/jxRzI+xY
        GbE0YuSRO7uCd/+crScAcEhrUCYjZ+9b+gcy93m9qg==
X-Google-Smtp-Source: AKy350Ymw3sFG2MNM86EWmDocGroeGyN5wMNlvYa018MthB6WfkObD8wqVo2i2XWXlj5Lv63/Ca+Wv/pf0WI7CeYMsk=
X-Received: by 2002:a1f:944e:0:b0:436:998e:a71e with SMTP id
 w75-20020a1f944e000000b00436998ea71emr15140047vkd.3.1680290948102; Fri, 31
 Mar 2023 12:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230329220753.7741-1-mario.limonciello@amd.com> <20230329220753.7741-2-mario.limonciello@amd.com>
In-Reply-To: <20230329220753.7741-2-mario.limonciello@amd.com>
From:   Mark Hasemeyer <markhas@chromium.org>
Date:   Fri, 31 Mar 2023 13:28:57 -0600
Message-ID: <CANg-bXCyH3X8SLOW_dNTTwrO7RO-6PuP8jZFNKAin=HJBD7yTA@mail.gmail.com>
Subject: Re: [PATCH v7 1/6] crypto: ccp: Drop extra doorbell checks
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
