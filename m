Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB62BC11D24
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 05:17:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A73A2208E4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 05:17:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgBUFRO (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 00:17:14 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:5324 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbgBUFRO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 00:17:14 -0500
Received: from [10.193.191.44] (ayushsawal.asicdesigners.com [10.193.191.44])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01L5H3OK009192;
        Thu, 20 Feb 2020 21:17:04 -0800
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        vinay.yadav@chelsio.com
Subject: Re: [RFC][PATCH] almost certain bug in
 drivers/crypto/chelsio/chcr_algo.c:create_authenc_wr()
To:     viro@zeniv.linux.org.uk, Herbert Xu <herbert@gondor.apana.org.au>
References: <20200215061416.GZ23230@ZenIV.linux.org.uk>
 <CAEopUdxRUoMo+uGgiFLWz8NsM1eL7CnkV7gY5PypxrG_nzhNWw@mail.gmail.com>
From:   Ayush Sawal <ayush.sawal@chelsio.com>
Message-ID: <db4ee9c7-400e-5932-8708-581d91b38385@chelsio.com>
Date:   Fri, 21 Feb 2020 10:47:01 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAEopUdxRUoMo+uGgiFLWz8NsM1eL7CnkV7gY5PypxrG_nzhNWw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2/15/2020 11:45 AM, Al Viro wrote:

>
>         kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) 
> << 4)
>                 - sizeof(chcr_req->key_ctx);
> can't possibly be endian-safe.  Look: ->key_ctx_hdr is __be32.  And
> KEY_CONTEXT_CTX_LEN_V is "shift up by 24 bits".  On little-endian hosts it
> sees
>         b0 b1 b2 b3
> in memory, inteprets that into b0 + (b1 << 8) + (b2 << 16) + (b3 << 24),
> shifts up by 24, resulting in b0 << 24, does ntohl (byteswap on l-e),
> gets b0 and shifts that up by 4.  So we get b0 * 16 - sizeof(...).
>
> Sounds reasonable, but on b-e we get
> b3 + (b2 << 8) + (b1 << 16) + (b0 << 24), shift up by 24,
> yielding b3 << 24, do ntohl (no-op on b-e) and then shift up by 4.
> Resulting in b3 << 28 - sizeof(...), i.e. slightly under b3 * 256M.
>
> Then we increase it some more and pass to alloc_skb() as size.
> Somehow I doubt that we really want a quarter-gigabyte skb allocation
> here...
>
> Note that when you are building those values in
> #define  FILL_KEY_CTX_HDR(ck_size, mk_size, d_ck, opad, ctx_len) \
>                 htonl(KEY_CONTEXT_VALID_V(1) | \
>                       KEY_CONTEXT_CK_SIZE_V((ck_size)) | \
>                       KEY_CONTEXT_MK_SIZE_V(mk_size) | \
>                       KEY_CONTEXT_DUAL_CK_V((d_ck)) | \
>                       KEY_CONTEXT_OPAD_PRESENT_V((opad)) | \
>                       KEY_CONTEXT_SALT_PRESENT_V(1) | \
>                       KEY_CONTEXT_CTX_LEN_V((ctx_len)))
> ctx_len ends up in the first octet (i.e. b0 in the above), which
> matches the current behaviour on l-e.  If that's the intent, this
> thing should've been
>         kctx_len = (KEY_CONTEXT_CTX_LEN_G(ntohl(aeadctx->key_ctx_hdr)) 
> << 4)
>                 - sizeof(chcr_req->key_ctx);
> instead - fetch after ntohl() we get (b0 << 24) + (b1 << 16) + (b2 << 
> 8) + b3,
> shift it down by 24 (b0), resuling in b0 * 16 - sizeof(...) both on 
> l-e and
> on b-e.
>
> PS: when sparse warns you about endianness problems, it might be worth 
> checking
> if there really is something wrong.  And I don't mean "slap __force 
> cast on it"...
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk 
> <mailto:viro@zeniv.linux.org.uk>>
> ---
> diff -urN a/drivers/crypto/chelsio/chcr_algo.c 
> b/drivers/crypto/chelsio/chcr_algo.c
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -2351,7 +2351,7 @@ static struct sk_buff *create_authenc_wr(struct 
> aead_request *req,
>         snents = sg_nents_xlen(req->src, req->assoclen + req->cryptlen,
>                                CHCR_SRC_SG_SIZE, 0);
>         dst_size = get_space_for_phys_dsgl(dnents);
> -       kctx_len = (ntohl(KEY_CONTEXT_CTX_LEN_V(aeadctx->key_ctx_hdr)) 
> << 4)
> +       kctx_len = (KEY_CONTEXT_CTX_LEN_G(ntohl(aeadctx->key_ctx_hdr)) 
> << 4)
>                 - sizeof(chcr_req->key_ctx);
>         transhdr_len = CIPHER_TRANSHDR_SIZE(kctx_len, dst_size);
>         reqctx->imm = (transhdr_len + req->assoclen + req->cryptlen) <


This was a genuine bug, thanks a lot for pointing it out and providing
the fix.We are checking other sparse warns in our files, and soon we
will fix the warnings.

Thanks,
Ayush

