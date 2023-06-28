Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82B30EB64D7
	for <linux-crypto@archiver.kernel.org>; Wed, 28 Jun 2023 22:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbjF1WPs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 28 Jun 2023 18:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbjF1WPo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Jun 2023 18:15:44 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92AAB273B
        for <linux-crypto@vger.kernel.org>; Wed, 28 Jun 2023 15:15:27 -0700 (PDT)
Received: from fsav113.sakura.ne.jp (fsav113.sakura.ne.jp [27.133.134.240])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 35SMFPmr083961;
        Thu, 29 Jun 2023 07:15:25 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav113.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp);
 Thu, 29 Jun 2023 07:15:25 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp)
Received: from [192.168.1.6] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 35SMFORC083952
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 29 Jun 2023 07:15:25 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <ada9b995-8d67-0375-f153-b434d48bd253@I-love.SAKURA.ne.jp>
Date:   Thu, 29 Jun 2023 07:15:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] net: tls: enable __GFP_ZERO upon tls_init()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>, glider@google.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+828dfc12440b4f6f305d@syzkaller.appspotmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Aviad Yehezkel <aviadye@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <0000000000008a7ae505aef61db1@google.com>
 <20200911170150.GA889@sol.localdomain>
 <c16e9ab9-13e0-b911-e33a-c9ae81e93a8d@I-love.SAKURA.ne.jp>
 <20230628140317.756e61d3@kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <20230628140317.756e61d3@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2023/06/29 6:03, Jakub Kicinski wrote:
> On Wed, 28 Jun 2023 22:48:01 +0900 Tetsuo Handa wrote:
>> syzbot is reporting uninit-value at aes_encrypt(), for block cipher assumes
>> that bytes to encrypt/decrypt is multiple of block size for that cipher but
>> tls_alloc_encrypted_msg() is not initializing padding bytes when
>> required_size is not multiple of block cipher's block size.
> 
> Sounds odd, so crypto layer reads beyond what we submitted as 
> the buffer? I don't think the buffer needs to be aligned, so
> the missing bits may well fall into a different (unmapped?) page.

Since passing __GFP_ZERO to skb_page_frag_refill() hides this problem,
I think that crypto layer is reading up to block size when requested
size is not multiple of block size.

> 
> This needs more careful investigation. Always zeroing the input 
> is just covering up the real issue.

Since block cipher needs to read up to block size, someone has to initialize
padding bytes. I guess that crypto API caller is responsible for allocating
and initializing padding bytes, otherwise such crypto API caller will fail to
encrypt/decrypt last partial bytes which are not multiple of cipher's block
size.

Which function in this report is responsible for initializing padding bytes?

