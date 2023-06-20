Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46761EB64DB
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Jun 2023 20:12:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbjFTUMN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Jun 2023 16:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjFTUML (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Jun 2023 16:12:11 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794A1DC
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 13:12:10 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-666ecb21f86so3982182b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 20 Jun 2023 13:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687291930; x=1689883930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7mZw/sH51+Uar7fU1OzH0F4S7kdt3jyea8NkuZO28Fc=;
        b=ACC8bD/ipJx7pFzTlJOQa4nyrUG0GCpU0e6G0XEoriY8gcAwE7ALynO0pU1O0kgraM
         CkjuTcns0qiLbR847qdCQpfBleJWKbiMFilCJpuB4SKzHaW73B6qWlc5+edSEeylFROW
         zHY2Wg+k+MboEax1G49d1ghl0fO8gG1GE+MFA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687291930; x=1689883930;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7mZw/sH51+Uar7fU1OzH0F4S7kdt3jyea8NkuZO28Fc=;
        b=X/L32EqyVKk+GYQLX9gOi6MFmm6taUnlB9b+la6BOYK7HFg3fD0Ul/zxvwEJYg/4HT
         cHcNrIKVfn2LHVfK84Aki0qRqFHbqP7fSSJ4SKybEjsirnbWQOU9XczdqOQTBpDpb3fc
         0t/FJ+sZ1yD0Rv7+QzA7VMAvmYkjQ7vALm+xyrdqrkqWF2Ah0i9v8fQRIVur7PKxE7tj
         ZJxcPh9WK2QMf30WjOTkZpbTDdzoR8Wf3ba7hP1QYlxt/HVdJduFdfZWKGjcsYVRcJUO
         lw0YTRZSQHLflSyU42FSEriI4jm2mpY0lCK5Mnu09MKco8tR36YdRuQQ1uQqP4Yemgt3
         Eu8g==
X-Gm-Message-State: AC+VfDzuKUnLpWTMJqvBx+sQBhwN7R5ApUZ/vhP7cIUXlkDmzZx0waLQ
        uqoP8LeX9Xj50Y+QLMGmUzXc6g==
X-Google-Smtp-Source: ACHHUZ476FchPEseFt3P2/D+fre3+HimYul2bkAmS8gzNZ1hQn6cmMersQMwS8bCAUAN42ovupcufw==
X-Received: by 2002:a05:6a21:6daa:b0:105:12ab:878f with SMTP id wl42-20020a056a216daa00b0010512ab878fmr16307871pzb.56.1687291930016;
        Tue, 20 Jun 2023 13:12:10 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id r23-20020a634417000000b005143448896csm1761874pga.58.2023.06.20.13.12.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 13:12:09 -0700 (PDT)
Date:   Tue, 20 Jun 2023 13:12:08 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Azeem Shaikh <azeemshaikh38@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-hardening@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: Replace strlcpy with strscpy
Message-ID: <202306201311.862B05981F@keescook>
References: <20230620200832.3379741-1-azeemshaikh38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230620200832.3379741-1-azeemshaikh38@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 20, 2023 at 08:08:32PM +0000, Azeem Shaikh wrote:
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since return value of -errno
> is used to check for truncation instead of sizeof(dest).
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Thanks for fixing up the variable type. (And thank you Eric for catching
the signedness problem!)

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
