Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9C6C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 15:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbiDMPmr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 11:42:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiDMPmq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 11:42:46 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B152841F83
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 08:40:25 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id a8so2450495ljq.5
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 08:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tgBA8s4Eh6rvde/t7B0/fiNRuz5n6J6jdeQ265aYyH8=;
        b=kpmOrV+KZsPfrkWLBVvU4FwmIyr5wmmpmnDQAUsPiQQOu16NkeZ2WtuBiM882G6/VU
         A6IyFgCWKc7DSGfE4MdQa1eczopD6TLLAIsjH4fnvhiIoRPkdVCl/92a4jVosMZOnVvb
         bTsEKLTuk/zR7e+Do+VVY0voHVMqBsnvtFViju+GZc0XutmNUncDv+N+pwW3K+ZZkA1Z
         y7SBT+/fdHZUPctOpOR/m1oD0SfcuBD7/N8kub9/clKXEeDyPGEouM3iu3OUJdnSmj1b
         U6oezOy5k6nJWprUM1vzUZp5ykPBOy7tUoN93D76aB2uqOFX6ldZbWpMm4ziIHaa2hdX
         JqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tgBA8s4Eh6rvde/t7B0/fiNRuz5n6J6jdeQ265aYyH8=;
        b=2YT0mBFxLBNUKqf0uq7PQ9P6f+75Ra2PPAMJHYAnbw6hX5efTsJtBkFQJUcNtS3wnA
         Ty2/2yTCiwbLMlM1jbwFc7Z65POthq2hoCknn3jUPL5qLQIdMlFMvWtwpvWgIm8dq9bG
         BwkWiJIdfjhfGEyVcwnVmyHlLntXRkcX3og2nQOR3njIO9hSPOJRbFkrtvN/N9AkvvI0
         pYYL9xoiQh9ELJ+nfbbSkg9SR6+W/PBKnlgRE61LL1oZPYeMQpfOyWipJWhJ0GOlSLHg
         6FlEhcll0T3M3vXsAaO32CmHY1aMLQUslCA0GuN5z7yXjYqhKAWdr/NPyGNd5cBAm4jT
         V0LA==
X-Gm-Message-State: AOAM530ytcm5UuL7Ysku+DglCZt9pK1LENp2UiWX58qBBht2ObpmOzp2
        lhw7k/MV8ZtJLqaaFuOz1Ih8thR0FO56KacBvnkJmw==
X-Google-Smtp-Source: ABdhPJxu82n1pQGboxGAUFIx7eeNpvAi4IMWEu1/u0r+gRGn56uFNSTXMnC3B4J/Y4WX0o0oIE2ZIbpRG7C0pPASMwM=
X-Received: by 2002:a2e:9017:0:b0:24b:6502:d63c with SMTP id
 h23-20020a2e9017000000b0024b6502d63cmr8831954ljg.426.1649864423326; Wed, 13
 Apr 2022 08:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220411180006.4187548-1-jackyli@google.com>
In-Reply-To: <20220411180006.4187548-1-jackyli@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 13 Apr 2022 09:40:12 -0600
Message-ID: <CAMkAt6rzVmi6iFM_phsCEtb1c-r2PYL9SYwSGX6JqWARnDWgWw@mail.gmail.com>
Subject: Re: [PATCH] crypto: ccp - Fix the INIT_EX data file open failure
To:     Jacky Li <jackyli@google.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Marc Orr <marcorr@google.com>, Alper Gun <alpergun@google.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 11, 2022 at 12:00 PM Jacky Li <jackyli@google.com> wrote:
>
> There are 2 common cases when INIT_EX data file might not be
> opened successfully and fail the sev initialization:
>
> 1. In user namespaces, normal user tasks (e.g. VMM) can change their
>    current->fs->root to point to arbitrary directories. While
>    init_ex_path is provided as a module param related to root file
>    system. Solution: use the root directory of init_task to avoid
>    accessing the wrong file.
>
> 2. Normal user tasks (e.g. VMM) don't have the privilege to access
>    the INIT_EX data file. Solution: open the file as root and
>    restore permissions immediately.
>
> Signed-off-by: Jacky Li <jackyli@google.com>

Reviewed-by: Peter Gonda <pgonda@google.com>

Agreed about the fixes tag.
