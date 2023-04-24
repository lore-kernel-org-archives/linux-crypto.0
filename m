Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAEDC6FD18
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Apr 2023 00:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjDXAJG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Apr 2023 20:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDXAJF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Apr 2023 20:09:05 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D4410FA;
        Sun, 23 Apr 2023 17:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=be8ZuVxBLCXQ/rvtqMtkSVgFOWYV/d7Ni7V/Z3tuim4=; b=P1Kx8rJupqS+NoQHayDQUbrwCr
        kf87ihAnX5u9K9BaqE4NpDDDvELJE1jzOwPKb2OP5weF6wrIXtb/QgaJFJ48j4i6qqKBw+s9cu4ZY
        6Hhoe1ZGF0AZBJBO5rxOL8wt9Lk//3IdYvtP2NPd+pDppxlQP4FmFfA5e5CwWInYXkIPk8z/SZxbr
        0vIol+8uJX9EinkOYREL8NpnTbE6vSinnZ8244hvWiYjaQherJsxcQFPWRXsq/b9VHV8OAoBeVduu
        Jp+cAbbtggHbBrolOPNOHjEzBiVx2E+oD727+k0ZSpxZLeaXVlgEHky7Tn2MeaTUTy6yhMEM/qBLN
        MkITZ7ug==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pqjlM-00ExOS-0J;
        Mon, 24 Apr 2023 00:09:01 +0000
Message-ID: <b58dc77c-c975-46cf-581c-368d9a87ae64@infradead.org>
Date:   Sun, 23 Apr 2023 17:08:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] crypto: engine - Fix typo in struct crypto_engine_op doc
Content-Language: en-US
To:     David Yang <mmyangfl@gmail.com>, linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20230423235532.2729539-1-mmyangfl@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230423235532.2729539-1-mmyangfl@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi--

On 4/23/23 16:55, David Yang wrote:
> There is a redundant underscore in prepare_request. Remove it.
> 
> Signed-off-by: David Yang <mmyangfl@gmail.com>
> ---
>  include/crypto/engine.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/crypto/engine.h b/include/crypto/engine.h
> index ae133e98d813..b9e76ed4085b 100644
> --- a/include/crypto/engine.h
> +++ b/include/crypto/engine.h
> @@ -78,7 +78,7 @@ struct crypto_engine {
>  
>  /*
>   * struct crypto_engine_op - crypto hardware engine operations
> - * @prepare__request: do some prepare if need before handle the current request
> + * @prepare_request: do some prepare if need before handle the current request

    * @prepare_request: do some preparation if needed before handling the current request

>   * @unprepare_request: undo any work done by prepare_request()
>   * @do_one_request: do encryption for current request
>   */

Thanks.
-- 
~Randy
