Return-Path: <SRS0=tFxg=4K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EA4C35669
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:44:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D7B8206EF
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Feb 2020 01:44:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgBVBoJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 20:44:09 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:52296 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727614AbgBVBoJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 20:44:09 -0500
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1j5Jpt-00034P-GV; Sat, 22 Feb 2020 12:44:06 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 22 Feb 2020 12:44:05 +1100
Date:   Sat, 22 Feb 2020 12:44:05 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     viro@zeniv.linux.org.uk, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, vinay.yadav@chelsio.com
Subject: Re: [RFC][PATCH] almost certain bug in
 drivers/crypto/chelsio/chcr_algo.c:create_authenc_wr()
Message-ID: <20200222014405.GA19322@gondor.apana.org.au>
References: <20200215061416.GZ23230@ZenIV.linux.org.uk>
 <CAEopUdxRUoMo+uGgiFLWz8NsM1eL7CnkV7gY5PypxrG_nzhNWw@mail.gmail.com>
 <db4ee9c7-400e-5932-8708-581d91b38385@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <db4ee9c7-400e-5932-8708-581d91b38385@chelsio.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 21, 2020 at 10:47:01AM +0530, Ayush Sawal wrote:
> On 2/15/2020 11:45 AM, Al Viro wrote:
> 
> > 
> >         kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr))
> > << 4)
> >                 - sizeof(chcr_req->key_ctx);
> > can't possibly be endian-safe.  Look: ->key_ctx_hdr is __be32.  And
> > KEY_CONTEXT_CTX_LEN_V is "shift up by 24 bits".  On little-endian hosts it
> > sees
> >         b0 b1 b2 b3
> > in memory, inteprets that into b0 + (b1 << 8) + (b2 << 16) + (b3 << 24),
> > shifts up by 24, resulting in b0 << 24, does ntohl (byteswap on l-e),
> > gets b0 and shifts that up by 4.  So we get b0 * 16 - sizeof(...).
> > 
> > Sounds reasonable, but on b-e we get
> > b3 + (b2 << 8) + (b1 << 16) + (b0 << 24), shift up by 24,
> > yielding b3 << 24, do ntohl (no-op on b-e) and then shift up by 4.
> > Resulting in b3 << 28 - sizeof(...), i.e. slightly under b3 * 256M.
> > 
> > Then we increase it some more and pass to alloc_skb() as size.
> > Somehow I doubt that we really want a quarter-gigabyte skb allocation
> > here...
> > 
> > Note that when you are building those values in
> > #define  FILL_KEY_CTX_HDR(ck_size, mk_size, d_ck, opad, ctx_len) \
> >                 htonl(KEY_CONTEXT_VALID_V(1) | \
> >                       KEY_CONTEXT_CK_SIZE_V((ck_size)) | \
> >                       KEY_CONTEXT_MK_SIZE_V(mk_size) | \
> >                       KEY_CONTEXT_DUAL_CK_V((d_ck)) | \
> >                       KEY_CONTEXT_OPAD_PRESENT_V((opad)) | \
> >                       KEY_CONTEXT_SALT_PRESENT_V(1) | \
> >                       KEY_CONTEXT_CTX_LEN_V((ctx_len)))
> > ctx_len ends up in the first octet (i.e. b0 in the above), which
> > matches the current behaviour on l-e.  If that's the intent, this
> > thing should've been
> >         kctx_len = (KEY_CONTEXT_CTX_LEN_G(ntohl(aeadctx->key_ctx_hdr))
> > << 4)
> >                 - sizeof(chcr_req->key_ctx);
> > instead - fetch after ntohl() we get (b0 << 24) + (b1 << 16) + (b2 << 8)
> > + b3,
> > shift it down by 24 (b0), resuling in b0 * 16 - sizeof(...) both on l-e
> > and
> > on b-e.
> > 
> > PS: when sparse warns you about endianness problems, it might be worth
> > checking
> > if there really is something wrong.  And I don't mean "slap __force cast
> > on it"...
> > 
> > Signed-off-by: Al Viro <viro@zeniv.linux.org.uk
> > <mailto:viro@zeniv.linux.org.uk>>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
