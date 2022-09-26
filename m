Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEDAAC6FA82
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Sep 2022 22:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiIZWCA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Sep 2022 18:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiIZWBr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Sep 2022 18:01:47 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BD8E3EDF
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2022 15:01:43 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q9so7744301pgq.8
        for <linux-crypto@vger.kernel.org>; Mon, 26 Sep 2022 15:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=jyUZYtxAtN1iTCX6RvQjDGcCuH9kvS5eYzROcFEThqY=;
        b=MzGhAq5OFEs2Jw3eI9RLQ+YxWhJkO64hQtgKbJilL0PzjLuQEVe9C+/uRy4PdTG8tz
         bG/i1MUi6O6fNF6xlb8WrrVfZWKq91jRdsDITIW/6qF8KZWGb0TzYKKhR/KIZDGttILa
         jSjcZeLBLVxe8wgx2SPAqVZWq/GXhl8HuDA9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=jyUZYtxAtN1iTCX6RvQjDGcCuH9kvS5eYzROcFEThqY=;
        b=clsZ5i3RmJv6ERC//3LA1KlMR4VFommvBpbC7q/GBhZtb5WuHvGE/iWaEq8fnTtxsa
         w24mJnMDmd3iQ/r7OGHN99F4lkRw2/Ukgliq5nkBEl3hKF3dsXjvvqgtKTiOzuSXiDOg
         otVvjlpB4WuYhGx2lDO96gZulf8e0oOf7WoeBKvrNWytXh7l3rObb0MejqOybBdDFoZN
         nr8410vQb7naQxgC3f+Iwhru0hFFxI3+IOvywHfRbQ3lgJMTfvBKvrexr5eN3YUuKzfA
         7Rvmf9Ttpfnc+Ne9PliZx9vvMugH7Khv6eXju8B+WkOe+JliLZ462l7TBVtb65fvHsBL
         5n0Q==
X-Gm-Message-State: ACrzQf1drJCWdudiLA5dMBJe2OOyqgP9m0WSwGmsdlJRjp6qZwtOwSzZ
        Lo7q1h+QiJzfM4fgEa4QkSbmc3Avicu96g==
X-Google-Smtp-Source: AMsMyM74ae4NJ4uEWNYiyk2e2ui6FrMQMT3qMJP8N0KnVh3xSmJR82MhWuJadxiI/Ex1FCEuybYffw==
X-Received: by 2002:a63:91c8:0:b0:438:d55c:4484 with SMTP id l191-20020a6391c8000000b00438d55c4484mr21974518pge.157.1664229702792;
        Mon, 26 Sep 2022 15:01:42 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f1-20020a170902684100b00173cfb184c0sm11728552pln.32.2022.09.26.15.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 15:01:42 -0700 (PDT)
Date:   Mon, 26 Sep 2022 15:01:41 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] crypto: talitos - Replace zero-length arrays with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <202209261501.D540C881@keescook>
References: <YzIdiQLXup1qtf6l@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzIdiQLXup1qtf6l@work>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 26, 2022 at 04:45:45PM -0500, Gustavo A. R. Silva wrote:
> Zero-length arrays are deprecated and we are moving towards adopting
> C99 flexible-array members, instead. So, replace zero-length arrays
> declarations in anonymous union with the new DECLARE_FLEX_ARRAY()
> helper macro.
> 
> This helper allows for flexible-array members in unions.
> 
> Link: https://github.com/KSPP/linux/issues/193
> Link: https://github.com/KSPP/linux/issues/216
> Link: https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
