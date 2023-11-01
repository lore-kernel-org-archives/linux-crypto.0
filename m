Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B42C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Nov 2023 12:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbjKAMsS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Nov 2023 08:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235137AbjKAMsS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Nov 2023 08:48:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D500613D
        for <linux-crypto@vger.kernel.org>; Wed,  1 Nov 2023 05:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698842843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L18jqjZ/YFC+R7qqPrcdbK+tbLtkdiO++O5gj8jOKcw=;
        b=PdmLmuX6e69O76KMBg86YgHverjauZuoC/N1zRpeGJlDHCtTZ8bF2/SDvxWDpVlx7tg1JL
        GECrIokmRQ/9QQ8FfoF6adpa16b3r4jpXGvRQooGPr7M9uWpF8bkW9DlcZXDMQaeokqRAv
        /5Xhp1AuWIiAOiyJxygO3LBxbFHhDoc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-9Mgdi-T9MmaKi_n3PhP7mA-1; Wed, 01 Nov 2023 08:47:20 -0400
X-MC-Unique: 9Mgdi-T9MmaKi_n3PhP7mA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7035E811E8F;
        Wed,  1 Nov 2023 12:47:19 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D9A24C1290F;
        Wed,  1 Nov 2023 12:47:18 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
        id C096130C2A86; Wed,  1 Nov 2023 12:47:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id BDD333FB77;
        Wed,  1 Nov 2023 13:47:18 +0100 (CET)
Date:   Wed, 1 Nov 2023 13:47:18 +0100 (CET)
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
cc:     Yureka <yuka@yuka.dev>, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com, Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [REGRESSION] dm_crypt essiv ciphers do not use async driver
 mv-aes-cbc anymore
In-Reply-To: <070dd167-9278-42fa-aef5-66621a602fd3@leemhuis.info>
Message-ID: <518e373e-673e-82a-24ff-b9e8b3927c85@redhat.com>
References: <53f57de2-ef58-4855-bb3c-f0d54472dc4d@yuka.dev> <20230929224327.GA11839@google.com> <070dd167-9278-42fa-aef5-66621a602fd3@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Wed, 1 Nov 2023, Linux regression tracking (Thorsten Leemhuis) wrote:

> > #regzbot introduced: b8aa7dc5c753
> 
> BTW: Eric, thx for this.
> 
> Boris, Arnaud, Srujana, and Mikulas, could you maybe comment on this? I
> understand that this is not some everyday regression due to deadlock
> risk, but it nevertheless would be good to get this resolved somehow to
> stay in line with our "no regressions" rule.
> 
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)

Hi

The driver drivers/crypto/marvell/cesa/cipher.c uses GFP_ATOMIC 
allocations (see mv_cesa_skcipher_dma_req_init). So, it is not really safe 
to use it for dm-crypt.

GFP_ATOMIC allocations may fail anytime (for example, they fill fail if 
the machine receives too many network packets in a short timeframe and 
runs temporarily out of memory). And when the GFP_ATOMIC allocation fails, 
you get a write I/O error and data corruption.

It could be possible to change it to use GFP_NOIO allocations, then we 
would risk deadlock instead of data corruption. The best thing would be to 
convert the driver to use mempools.

Mikulas

