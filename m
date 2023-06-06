Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B71AC7EE24
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 08:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbjFFIeb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 04:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235673AbjFFIe2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 04:34:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 931B810D1
        for <linux-crypto@vger.kernel.org>; Tue,  6 Jun 2023 01:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686040332;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IdoGUsAWfHDr2wQyL6tJs6W/yiY+jfIRUSQEw3HixAk=;
        b=ZYHxLwbH6Eo3CiTYgzkeM767ZyZe4epmS1Rk4bE763FLqC+cMbQfJrKTYIeUoh+zTXJ1//
        esSaycNAyjHwuVdJVKwr/q3zMivNemUaEfecmZcI2lpqXiQ/MzeU1QscYdqFc4fYzm/dbf
        RF2R7buoHKiHGbX+FN3D+W/uiti2B2o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-s59MHvYFO1qcCVersDxmyg-1; Tue, 06 Jun 2023 04:32:11 -0400
X-MC-Unique: s59MHvYFO1qcCVersDxmyg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f602cec801so12057405e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 06 Jun 2023 01:32:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686040330; x=1688632330;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IdoGUsAWfHDr2wQyL6tJs6W/yiY+jfIRUSQEw3HixAk=;
        b=kXLamR58YCMLmLoxnKJJ3xq4nFl98Cm7fdn/hVwQzarRo7bnn4jIzU1GHUvd9iuUg7
         PW5D/zUoAqpkIvpM4+hmhd0VP/klcS8yeg+aA9lXWSYZ950n7FUnkO4Mak77kfiuALoo
         0dSMPf4p7V1qHIftqKy7T6OVJeJKnaU6Gt1gLVFDo14VVZ+4g6LTJ7cEimby7wD/AEYl
         bP2EZ53Kt4UkIAJYy580Pq0Bz903wGDsNO1TnoWPSwscBfFrhOV8W2vLdShORV0Be+Dm
         N4yeTDZyuAS4hTNQc1sccblcsqug/wo4sPll38wfudzLFwYL33LtqcFH51aIMTn2PLeL
         P8xA==
X-Gm-Message-State: AC+VfDyeES/6bVEX3J13xm7ktjkPs3pF+dYIH/4mSmFexCr8QfNst1oE
        14McnYcz0uUY9ZX18qZNLbvWSq4U/Elyg18ykRBwjEkAYBhM096zl2oBEkIQ2QhBxF7HrXWGsxE
        2aIFmNVw+y0SgVkIowPtr5mNk
X-Received: by 2002:a05:600c:1551:b0:3f1:7490:e595 with SMTP id f17-20020a05600c155100b003f17490e595mr1691947wmg.2.1686040330271;
        Tue, 06 Jun 2023 01:32:10 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5mpfcPs5jilgFaHL8M4M0PoskD/r9L0dayDg39w3cIqXFW0pL1ZX8Qj4pnjveyA/vuspDHPQ==
X-Received: by 2002:a05:600c:1551:b0:3f1:7490:e595 with SMTP id f17-20020a05600c155100b003f17490e595mr1691926wmg.2.1686040330004;
        Tue, 06 Jun 2023 01:32:10 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id v10-20020a1cf70a000000b003f41bb52834sm16803885wmh.38.2023.06.06.01.32.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 01:32:09 -0700 (PDT)
Message-ID: <649f4d8d5e96b3c8e39ab56487888fe86e543066.camel@redhat.com>
Subject: Re: [PATCH net-next v2 08/10] crypto: af_alg: Support
 MSG_SPLICE_PAGES
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-crypto@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date:   Tue, 06 Jun 2023 10:32:08 +0200
In-Reply-To: <822308.1685619312@warthog.procyon.org.uk>
References: <bd2750e52b47af1782233e254114eb8d627f1073.camel@redhat.com>
         <20230530141635.136968-1-dhowells@redhat.com>
         <20230530141635.136968-9-dhowells@redhat.com>
         <822308.1685619312@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 2023-06-01 at 12:35 +0100, David Howells wrote:
> Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> > > +	if ((msg->msg_flags & MSG_SPLICE_PAGES) &&
> > > +	    !iov_iter_is_bvec(&msg->msg_iter))
> > > +		return -EINVAL;
> > > +
> > ...
> > It looks like the above expect/supports only ITER_BVEC iterators, what
> > about adding a WARN_ON_ONCE(<other iov type>)?
>=20
> Meh.  I relaxed that requirement as I'm now using tools to extract stuff =
from
> any iterator (extract_iter_to_sg() in this case) rather than walking the
> bvec[] directly.  I forgot to remove the check from af_alg.  I can add an
> extra patch to remove it.  Also, it probably doesn't matter for AF_ALG si=
nce
> that's only likely to be called from userspace, either directly (which wi=
ll
> not set MSG_SPLICE_PAGES) or via splice (which will pass a BVEC).  Intern=
al
> kernel code will use crypto API directly.

Thank you for the clarification, I got lost a bit. The patch LGTM as
is.

>=20
> > Also, I'm keeping this series a bit more in pw to allow Herbert or
> > others to have a look.

@Herbert, the series LGTM, I think we should apply it. If you have any
concerns, please voice them soon!

Thanks,

Paolo

