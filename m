Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4939FC2B9F4
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 23:22:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13678610A5
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Jun 2021 23:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhFQXY2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Jun 2021 19:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhFQXY1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jun 2021 19:24:27 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3343DC061574
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 16:22:19 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id h12so6254226pfe.2
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jun 2021 16:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:subject:to:cc:references:in-reply-to:mime-version
         :message-id:content-transfer-encoding;
        bh=qOGxnA+w295Zfdqp/3EIV/boS8jDDN3t7281bqtmFyk=;
        b=ir87RIq6aaUio14CEQu9Dg1UaOAcsDflyOo8FkKXldN9ZoQ6I5wCPknP5NKvSLrgZ8
         t8BYa+PWl82kqVa54W6ujKqy6QJ7UZBzBSfX+Nj7eS9ic5bV8Tc4UwlmeHIDGsDa06zP
         w/+oD6UxaC7Jgppy2kI84XBk2XlYkFZaf9rKObE58oUt2H5+ugOphi/86/uv+GM1HtEz
         JCzQ0h8IproccM3LZvzrvOQ/BSuNYeiqCf5xd6YYbxNaB96z+vZQ3Y74R1tlwTWPoTSv
         11o64cpOt78exCXXsHQ2pqcboPNq4B8oCD5VHFMyRmTpvkLusvMKANhSPbWx2oF9rapL
         arVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:subject:to:cc:references:in-reply-to
         :mime-version:message-id:content-transfer-encoding;
        bh=qOGxnA+w295Zfdqp/3EIV/boS8jDDN3t7281bqtmFyk=;
        b=AI+eFvpz7+e9fjFsmctKV2bh2SNW8tMnDdPdnXjfu/9qVddA5unC4ch/64zusOxUDu
         wPGfx0jyL8BnyZjCkzdvk787bc5KyVAC9n2bbhniwt2xhe2MlxYskYy2kgWuHm501UlY
         hmZ/OgqYqxPY4gBH7JuswMjkoihkTw/NhQaSgXGwOr+BWXA6NX5nbo2gZkct1liFLm7P
         l9+R9042WvFi5E1fYuK41nZWvUvWC4KMOIh9fJh1MqZee0rT/44K1f72qFHbsR1cyTl1
         09HaSJSsFb+91hKAWfUQguW9rx6/kHxHDkEHWbBeEW/L76LrVTmwFG4k8zJLGtui7Ntx
         Sjow==
X-Gm-Message-State: AOAM533Jw5Chjh/IE5jg7PXhG6HIRgnFLzb56W3fMOUf0EbMFl78Jk3s
        1cwAvSQ1AUz2i7LRZY/6yHo=
X-Google-Smtp-Source: ABdhPJwE60/Y4E6j3nji1MEMxB2Cct2NTycPxkX9/ObI/VKAnysIJ+z0vJFNrcQ/kCJ6yBi7kXnvpQ==
X-Received: by 2002:a63:f13:: with SMTP id e19mr6955047pgl.112.1623972138656;
        Thu, 17 Jun 2021 16:22:18 -0700 (PDT)
Received: from localhost (60-242-147-73.tpgi.com.au. [60.242.147.73])
        by smtp.gmail.com with ESMTPSA id b65sm6087820pfa.32.2021.06.17.16.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 16:22:18 -0700 (PDT)
Date:   Fri, 18 Jun 2021 09:22:13 +1000
From:   Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH v6 12/17] powerpc/pseries/vas: Integrate API with
 open/close windows
To:     Haren Myneni <haren@linux.ibm.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au
Cc:     haren@us.ibm.com, hbabu@us.ibm.com
References: <827bf56dce09620ebecd8a00a5f97105187a6205.camel@linux.ibm.com>
        <e8d956bace3f182c4d2e66e343ff37cb0391d1fd.camel@linux.ibm.com>
In-Reply-To: <e8d956bace3f182c4d2e66e343ff37cb0391d1fd.camel@linux.ibm.com>
MIME-Version: 1.0
Message-Id: <1623971609.844odc55aw.astroid@bobo.none>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Excerpts from Haren Myneni's message of June 18, 2021 6:36 am:
>=20
> This patch adds VAS window allocatioa/close with the corresponding
> hcalls. Also changes to integrate with the existing user space VAS
> API and provide register/unregister functions to NX pseries driver.
>=20
> The driver register function is used to create the user space
> interface (/dev/crypto/nx-gzip) and unregister to remove this entry.
>=20
> The user space process opens this device node and makes an ioctl
> to allocate VAS window. The close interface is used to deallocate
> window.
>=20
> Signed-off-by: Haren Myneni <haren@linux.ibm.com>

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

Unless there is some significant performance reason it might be simplest
to take the mutex for the duration of the allocate and frees rather than=20
taking it several times, covering the atomic with the lock instead.

You have a big lock, might as well use it and not have to wonder what if=20
things race here or there.

But don't rework that now, maybe just something to consider for later.

Thanks,
Nick

