Return-Path: <SRS0=PFiu=AH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EED5C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 15:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F84E20702
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Jun 2020 15:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QHSRrY0d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgFZPSN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Jun 2020 11:18:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52988 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726878AbgFZPSM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Jun 2020 11:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593184691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KhyzVywFi03LMkGFE6YU3ix+rjL9u5JtHjzF89C3iwg=;
        b=QHSRrY0dIfJbA3UqF3cyR6vr1rgEMinv/gy5UCNg4gF7UcTdP1mGsCnFhHBgIZWODI5dn5
        OLzjRSlmhAszCVjrvFDd3Y88pkfPoN7jaq3h+FshycLfOBEYkyfVZ0Z/bqG4IZxvGQXFtv
        IHAhH4c78Wiee9tvkhPpvWujX7c5zxc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-BpksQRLTM9a38lmnoLB9TQ-1; Fri, 26 Jun 2020 11:18:04 -0400
X-MC-Unique: BpksQRLTM9a38lmnoLB9TQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9775418FE866;
        Fri, 26 Jun 2020 15:18:02 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 814FC5C557;
        Fri, 26 Jun 2020 15:17:58 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 05QFHwaF013492;
        Fri, 26 Jun 2020 11:17:58 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 05QFHuir013488;
        Fri, 26 Jun 2020 11:17:56 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 26 Jun 2020 11:17:56 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Herbert Xu <herbert@gondor.apana.org.au>
cc:     Eric Biggers <ebiggers@kernel.org>,
        Mike Snitzer <msnitzer@redhat.com>,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Milan Broz <mbroz@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
        George Cherian <gcherian@marvell.com>,
        Wei Xu <xuwei5@hisilicon.com>, Zaibo Xu <xuzaibo@Huawei.com>
Subject: Re: [PATCH 1/3] crypto: pass the flag CRYPTO_ALG_ALLOCATES_MEMORY
In-Reply-To: <20200626044534.GA2870@gondor.apana.org.au>
Message-ID: <alpine.LRH.2.02.2006261109520.11899@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2006091259250.30590@file01.intranet.prod.int.rdu2.redhat.com> <20200610010450.GA6449@gondor.apana.org.au> <alpine.LRH.2.02.2006100756270.27811@file01.intranet.prod.int.rdu2.redhat.com> <20200610121106.GA23137@gondor.apana.org.au>
 <alpine.LRH.2.02.2006161052540.28052@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2006161101080.28052@file01.intranet.prod.int.rdu2.redhat.com> <20200616173620.GA207319@gmail.com> <alpine.LRH.2.02.2006171107220.18714@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.2006171108440.18714@file01.intranet.prod.int.rdu2.redhat.com> <20200626044534.GA2870@gondor.apana.org.au>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Fri, 26 Jun 2020, Herbert Xu wrote:

> On Wed, Jun 17, 2020 at 11:09:28AM -0400, Mikulas Patocka wrote:
> >
> > Index: linux-2.6/include/linux/crypto.h
> > ===================================================================
> > --- linux-2.6.orig/include/linux/crypto.h
> > +++ linux-2.6/include/linux/crypto.h
> > @@ -97,9 +97,18 @@
> >  #define CRYPTO_ALG_OPTIONAL_KEY		0x00004000
> >  
> >  /*
> > + * The driver may allocate memory during request processing, so it shouldn't be
> > + * used in cases where memory allocation failures aren't acceptable, such as
> > + * during block device encryption.
> > + */
> > +#define CRYPTO_ALG_ALLOCATES_MEMORY	0x00008000
> > +
> > +/*
> >   * Don't trigger module loading
> >   */
> > -#define CRYPTO_NOLOAD			0x00008000
> > +#define CRYPTO_NOLOAD			0x00010000
> > +
> > +#define CRYPTO_ALG_INHERITED_FLAGS	(CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY)
> 
> Any reason why you need to renumber NOLOAD? If not please keep
> the existing values.

There is no hard reason for that. CRYPTO_NOLOAD is a "virtual" flag that 
could be only present in crypto algorithm requests and I thought that the 
intention was that the virtual flags go after real flags. If you don't 
want to change existing flags, there is no problem with that.

Mikulas

> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> 

