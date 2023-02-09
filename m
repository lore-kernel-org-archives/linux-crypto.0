Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BBB0C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Feb 2023 22:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjBIWqp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Feb 2023 17:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjBIWqp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Feb 2023 17:46:45 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F5A2D47
        for <linux-crypto@vger.kernel.org>; Thu,  9 Feb 2023 14:46:43 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so7906830pjq.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Feb 2023 14:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9g2yQtWzAVH6ZOpDsD/Sskemui/XDqoYgj9fWj/hkxU=;
        b=Fcjg1IeCP5a42XMH+PhI6FfYg/ZEC4FgpEwO2V6GvMNyMrvAcl9kKvcS01KBHSx82+
         OZZKtrI7t5/KX66FOK/1hHFW0nVKD4IBJf/vEIg9028FjBGjeq+MxlG8wtJRbGXCe8Zv
         ssz7dnJgd1z50RC8sOXXUWNvCagc3zNzWh7y6NFro6FvBBXOx3hjqr8K9oWb616ub3vD
         nXXLKpIF4/k+oT2CQZYhei6jOVDegdDoUAyaqgD8+2AB3UMhfTdFu+tjTrdWCiYHd/UC
         /CDS2BY/9+s5PZrlNrGdQPNrWzw61I1u1EAxVPSdCY2ZXwyX7YgR1ABL5UcgKsWMwx8r
         KwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9g2yQtWzAVH6ZOpDsD/Sskemui/XDqoYgj9fWj/hkxU=;
        b=Sk9XbrvVNx3eK7llnqr/nJ2aAdYNruzkN8tAZXg8QyPbr9LT9uC2dT5U1mbe46dLGO
         sMUULTXiC+1RCOfFiF0TsJVrqcq7CCkpPmSIYrr6UdUnjrr1MvrDHMlYymyyGd9g3txn
         ce3brZzdl5FkDhFkc4sMOKo1ff7ZEqwsy+iUkjwYzn5Q0jdtGO11j7acbxcFLgk2bW5E
         ARjTkuJ2hsrBKQ0Biq6c7lo8tTXaQ86iQmMR+Y7/LsloMyfWI59wJHXrs9J7CP9tL/ZC
         DRcbDKM2zLCyiZlmPhGZSesOePzN6E56Bp6D/2gUs8gDpDGXF6fC8sC0vX75z6aAcJmN
         1yYw==
X-Gm-Message-State: AO0yUKWukcDqNsPW3DESg+L/PFCqgqa0GwJTGuSJgWbfLe4cZWjKjT0k
        +9GcNrGJYnCha3HaFeo8+DAwCUfp7D1cxiFApeVr
X-Google-Smtp-Source: AK7set+5+CGbyUdx+XEn7CyiOAlZsrmdC59etIZEgrVyrqoicPNTGQjjG1Gn3JnsMH+LPETc4+h+vPAftTT77wQ7BnQ=
X-Received: by 2002:a17:902:70c4:b0:198:ff55:2ef3 with SMTP id
 l4-20020a17090270c400b00198ff552ef3mr3307989plt.27.1675982803339; Thu, 09 Feb
 2023 14:46:43 -0800 (PST)
MIME-Version: 1.0
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-3-roberto.sassu@huaweicloud.com> <Y64XB0yi24yjeBDw@sol.localdomain>
 <d2a54ddec403cad12c003132542070bf781d5e26.camel@huaweicloud.com>
 <857eedc5ad18eddae7686dca63cf8c613a051be4.camel@huaweicloud.com> <Y+VBMQEwPTPGBIpP@gmail.com>
In-Reply-To: <Y+VBMQEwPTPGBIpP@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 9 Feb 2023 17:46:32 -0500
Message-ID: <CAHC9VhTYeqCB8roaNvWUYJeKPwT35ixJ8MMXBe0v0+a9o8CXWw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] KEYS: asymmetric: Copy sig and digest in public_key_verify_signature()
To:     David Howells <dhowells@redhat.com>
Cc:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 9, 2023 at 1:53 PM Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Feb 09, 2023 at 11:49:19AM +0100, Roberto Sassu wrote:
> > On Fri, 2023-01-27 at 09:27 +0100, Roberto Sassu wrote:
> > > On Thu, 2022-12-29 at 14:39 -0800, Eric Biggers wrote:
> > > > On Tue, Dec 27, 2022 at 03:27:40PM +0100, Roberto Sassu wrote:
> > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > >
> > > > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > > > mapping") checks that both the signature and the digest reside in the
> > > > > linear mapping area.
> > > > >
> > > > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > > > stack support") made it possible to move the stack in the vmalloc area,
> > > > > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > > > > adjacent pages.
> > > > >
> > > > > Always make a copy of the signature and digest in the same buffer used to
> > > > > store the key and its parameters, and pass them to sg_init_one(). Prefer it
> > > > > to conditionally doing the copy if necessary, to keep the code simple. The
> > > > > buffer allocated with kmalloc() is in the linear mapping area.
> > > > >
> > > > > Cc: stable@vger.kernel.org # 4.9.x
> > > > > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > > > > Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
> > > > > Suggested-by: Eric Biggers <ebiggers@kernel.org>
> > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > ---
> > > > >  crypto/asymmetric_keys/public_key.c | 38 ++++++++++++++++-------------
> > > > >  1 file changed, 21 insertions(+), 17 deletions(-)
> > > >
> > > > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > >
> > > Hi David
> > >
> > > could you please take this patch in your repo, if it is ok?
> >
> > Kindly ask your support here. Has this patch been queued somewhere?
> > Wasn't able to find it, also it is not in linux-next.
> >
>
> The maintainer of asymmetric_keys (David Howells) is ignoring this patch, so
> you'll need to find someone else to apply it.  Herbert Xu, the maintainer of the
> crypto subsystem, might be willing to apply it.  Or maybe Jarkko Sakkinen, who
> is a co-maintainer of the keyrings subsystem (but not asymmetric_keys, for some
> reason; should that change?).

It is problematic that David isn't replying to this.  I have no idea
if it will work, but I just reached out to him to see if I can draw
his attention back to this ...

--
paul-moore.com
