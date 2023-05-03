Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDD0C77B78
	for <linux-crypto@archiver.kernel.org>; Wed,  3 May 2023 10:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjECKW1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 May 2023 06:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjECKW0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 May 2023 06:22:26 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DB70E43;
        Wed,  3 May 2023 03:22:25 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pu9cg-004hJW-Em; Wed, 03 May 2023 18:22:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 03 May 2023 18:22:11 +0800
Date:   Wed, 3 May 2023 18:22:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+726dc8c62c3536431ceb@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, olivia@selenic.com,
        syzkaller-bugs@googlegroups.com, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: Re: [syzbot] [crypto?] KCSAN: data-race in random_recv_done /
 virtio_read (3)
Message-ID: <ZFI102tIiZFiZNK4@gondor.apana.org.au>
References: <00000000000050327205f9d993b2@google.com>
 <CACT4Y+awU85RHZjf3+_85AvJOHghoOhH3c9E-70p+a=FrRDYkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+awU85RHZjf3+_85AvJOHghoOhH3c9E-70p+a=FrRDYkg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 21, 2023 at 04:52:13PM +0200, Dmitry Vyukov wrote:
>
> Here this:
> 
> size = min_t(unsigned int, size, vi->data_avail);
> memcpy(buf, vi->data + vi->data_idx, size);
> vi->data_idx += size;
> vi->data_avail -= size;
> 
> runs concurrently with:
> 
> if (!virtqueue_get_buf(vi->vq, &vi->data_avail))
>     return;
> vi->data_idx = 0;
> 
> I did not fully grasp how/where vi->data is populated, but it looks
> like it can lead to use of uninit/stale random data, or even to out of
> bounds access, say if vi->data_avail is already updated, but
> vi->data_idx is not yet reset to 0. Then concurrent reading will read
> not where it's supposed to read.

This appears to be a genuine bug.  I'll look into it.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
