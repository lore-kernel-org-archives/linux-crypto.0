Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BD5AC76195
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Mar 2023 16:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjC0QrE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Mar 2023 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC0QrD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Mar 2023 12:47:03 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BDF2698
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 09:47:02 -0700 (PDT)
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EA6233FFEB
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 16:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1679935618;
        bh=dnwNY1277mN3/tMvV/2wrgLdhuMzkawp9ZPzDMrskro=;
        h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
         MIME-Version:Content-Type;
        b=cHiU6SdsHngwMW0LPlzmhI8L0n2nFPanaugNvW5d9c7qsO9xaY8PsWmfu4dDMyqKC
         3bxeD9GoIAT3gvxlr5WwG83fBiLALZfRsjRk6pHmrWujRAHIFDZpZ4oili8keg0oW+
         6MnJ1FP/A3owAhGb3FwnLqclYHUqleXKJ9E8QLzGEwp8ESIRZLkOjY1zko/2le7DQF
         BZn7PLp8rVWKuiwrKnO5NxAgPLp3epSyvrXfKShuQWMhOBz1ZKSrEJZRnnQfAV2KsC
         xC+sV1b2QIdtYWIhiNl980Q6Dhymk2OosnzVMmUFaVM7ClFuHjGvg0qk/gpHWyU8n5
         bEgcdQD9X86ng==
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-177bf70751bso5491245fac.16
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 09:46:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679935616;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dnwNY1277mN3/tMvV/2wrgLdhuMzkawp9ZPzDMrskro=;
        b=Swi0TSGBeTX/eYPgya4ilEgiArkYVxFMJNuUSf+KtyrcY4Pz7PTHl2j51jMyKV2Fu6
         SO91DXpcB6C3eXjD8p5eFmoVUfUX+9q4fMY58OJB5juRnbvz+zArQygFxujpBRgMxrsA
         +u9at2KjWUk4C87nujXb4kRPJK+kW8sEnx15mku/0r8EExr1tS8UkB8Ci0ubcbJfzSH8
         rlDpQ9pljkV2eDYX+LuwrJYm6RfHibwDVpRBezieDcC1wOdGt4IpTVXaWrnLNNZlPiaz
         UEcmc+eE5KF7p8XBqa2/LPu2l1179DaBLE7z7z0CTbX99LLh0FayoLFkeHwX2RK+m19U
         av4g==
X-Gm-Message-State: AAQBX9cF51a7b+w80c5tH5DzXEPURZGZ9zMcxhvm9L8hOpSAD2VTxBSc
        tQ7lDVT7ZUngZfVmDFa9KwmsuKx6QzEMqf+vX/V6lNO9xSobd7+vdvxsjcA2Pb4D74lypYe8UvY
        OUE4A1ndqibvakzV5pyWW4bz4+nj1Z/tGcfzs1UQNh9PGJPqT
X-Received: by 2002:a05:6830:615:b0:6a1:535f:b095 with SMTP id w21-20020a056830061500b006a1535fb095mr37942oti.18.1679935616549;
        Mon, 27 Mar 2023 09:46:56 -0700 (PDT)
X-Google-Smtp-Source: AKy350YzCaVqAP3Jt4SXwUkhpY4ZoyjeqjEWHSQOkKc8CEBxkJLNANioZjPoLdcYKPtoV9g06eP8vA==
X-Received: by 2002:a05:6830:615:b0:6a1:535f:b095 with SMTP id w21-20020a056830061500b006a1535fb095mr37936oti.18.1679935616296;
        Mon, 27 Mar 2023 09:46:56 -0700 (PDT)
Received: from canonical.com ([177.188.140.13])
        by smtp.gmail.com with ESMTPSA id b7-20020a9d7547000000b0069fb8bfb4f3sm4438410otl.77.2023.03.27.09.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 09:46:55 -0700 (PDT)
References: <12194787.O9o76ZdvQC@positron.chronox.de>
 <4478169.LvFx2qVVIh@positron.chronox.de>
User-agent: mu4e 1.9.22; emacs 29.0.60
From:   Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
To:     Stephan =?utf-8?Q?M=C3=BCller?= <smueller@chronox.de>
Cc:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        Vladis Dronov <vdronov@redhat.com>
Subject: Re: [PATCH v4] crypto: jitter - permanent and intermittent health
 errors
Date:   Mon, 27 Mar 2023 13:40:07 -0300
In-reply-to: <4478169.LvFx2qVVIh@positron.chronox.de>
Message-ID: <87fs9qnnuq.fsf@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


It looks good to me too.

I also did a quick smoke test using AF_ALG and I didn't find any issues.

Average of 10 runs doing a million reads of 8, 32, 64 and 128 bytes each
time with drbg_nopr_sha256.

Without the patch:

bsize  count    total (secs)  user (secs)  system (secs)
8      1000000  3,739         0,483        3,247
32     1000000  3,835         0,49         3,337
64     1000000  4,652         0,502        4,14
128    1000000  6,3           0,562        5,73

With the patch:

bsize  count    total (secs)  user (secs)  system (secs)
8      1000000  3,376         0,429        2,936
32     1000000  3,361         0,422        2,927
64     1000000  4,072         0,446        3,614
128    1000000  5,439         0,424        4,981

Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

--
Regards,
Marcelo
