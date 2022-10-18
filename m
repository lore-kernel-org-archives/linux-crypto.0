Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E3BC4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Oct 2022 20:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiJRULL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiJRULK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Oct 2022 16:11:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BEECE10
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 13:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1FAE616DB
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 20:11:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB161C433C1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 20:11:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pWU3y7qs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1666123863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=evRBq0+AilEgJWq9ibFNPVIJgd/AU5Ef/s3FkXbx+Mo=;
        b=pWU3y7qs0i2XN0KxrsLbANOjWbp7LV4zU7qguzs5jXIsiIS/1D5BvoMxiQeTOZdGhQdXfl
        WPTdCUM2v2KhFawsc8dNn22U5xQaop7d/+U4wlKkR44GBoZ/SyY488K2PV43ksA9peaTQV
        bMr7oNm8ckuH5GCLNm/ZrSv4l7++82s=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 204d60b5 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Tue, 18 Oct 2022 20:11:03 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id 63so15890688vse.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Oct 2022 13:11:03 -0700 (PDT)
X-Gm-Message-State: ACrzQf0URpF7WO0Lh6FI67qye/ZnFovcxc3s3eeEBE33RY5C8ejS65c5
        5ujWibF1GczeGWsiVcgqP1K++D8qzBzESJul1lI=
X-Google-Smtp-Source: AMsMyM6j0SUJk0HKkHg7t2ANXs42YZmZTkWTIVY95PzAqENqv45A0dlqgIdff0WCK0eB9cwQDUmHkOMhBJFdkyJKJ9Y=
X-Received: by 2002:a67:c297:0:b0:3a7:5f0c:54c4 with SMTP id
 k23-20020a67c297000000b003a75f0c54c4mr2737138vsj.76.1666123861774; Tue, 18
 Oct 2022 13:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221018200422.179372-1-ardb@kernel.org>
In-Reply-To: <20221018200422.179372-1-ardb@kernel.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 18 Oct 2022 14:10:50 -0600
X-Gmail-Original-Message-ID: <CAHmME9pPNxQthg6sMThdRswWc-um17OcPuhLWO+r=1jXrEDd5g@mail.gmail.com>
Message-ID: <CAHmME9pPNxQthg6sMThdRswWc-um17OcPuhLWO+r=1jXrEDd5g@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] crypto: Add GCM-AES implementation to lib/crypto
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, keescook@chromium.org,
        ebiggers@kernel.org, herbert@gondor.apana.org.au, nikunj@amd.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 18, 2022 at 2:04 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Provide a generic library implementation of GCM-AES which can be used

Every place else in the world, this is called AES-GCM. Can we stick
with the convention?
