Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77686C43334
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Jul 2022 15:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiGSP1V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Jul 2022 11:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239517AbiGSP1I (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Jul 2022 11:27:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73FAA50735
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 08:27:07 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t2-20020a17090a4e4200b001f21572f3a4so316835pjl.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 Jul 2022 08:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7BFIgUumD/kmYA1pmYkKFh/T9Z0odVvpxKmd7kFvmds=;
        b=p0vbyaqg8b7QFy3eBMSaHlXf9z9XE0n+e14lNNj1gZpq49P69UF7JOMI2ROL/j+ujq
         +gZHfIHFE/7zg/iPBZtLcSmvKojE1oqsL/+5TwruTQzkQpMGT4Ji8QHQCL6U1QA3U32i
         ZyKfUMAC8QgAwtjeq2dRlUdhtfHbR1bApY1aozNezDNFEI10cO96GBdrKfd9J0fIYVTQ
         6etqQKX03zuvAuv+SLJKW1+TfwfmR4q6ztMN94P2S7hH55RyVE1koH9xoCQAXzFObsmc
         EMpacVkF3ldoF7xO5EeLIpSYY2LmUNjaTcuchwgfQkl7UvtF/EHIU05MVKDrFCYXPTNi
         maWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7BFIgUumD/kmYA1pmYkKFh/T9Z0odVvpxKmd7kFvmds=;
        b=MIIGVYhkEitXrwAMlAx7I66UtPsxgRx/Ma5MeqiUaU0FQLX6QBMcAgR3W3Q2kxeRVe
         VQggQLHb8mGnPXBQyvD6s92Xphg/IMqjNOI/nZEXpgI/7dFS+Qn0XeF4vmB+ySXqFYiY
         dPJ/aGKxLHv0b6mdfYNMge15pLjYJOUG09dbj8mKj69nch2IsBGXrBR+oJdOr2nXBesL
         fBtu2NSViTH6+9PNbhbxdaDcCeE7smdiPhVXhfbvDtw9NQdpz11m4xbqvrb2zTAmZNmG
         cUXBuo5nHJ4dS+f1y0LqDc9aJBHaswrdjGQj2oYCglyDKbljfM9d3QaN86o5uPfFrTNV
         crRw==
X-Gm-Message-State: AJIora91rK9XYfJVJSVWyKqj3XnoxMRosUWdsrvfYPqwnfC49jMFmSbH
        Gx0slS945PWHwZZ2vVeKs9lU/4Rbc4D2mg==
X-Google-Smtp-Source: AGRyM1vPbVu018sIn9j876XrLkEuv9R90ykTUif3VyJk91roiLtg2J50PgHRbmglm8ZG4JQ3oBG3Cw==
X-Received: by 2002:a17:902:e54b:b0:16c:38e5:a9b7 with SMTP id n11-20020a170902e54b00b0016c38e5a9b7mr33883192plf.66.1658244426810;
        Tue, 19 Jul 2022 08:27:06 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id a3-20020a170902ecc300b0016be4d78792sm11725651plh.257.2022.07.19.08.27.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 08:27:06 -0700 (PDT)
Message-ID: <856b44ba-23fc-4661-9afb-6b0487133e34@gmail.com>
Date:   Wed, 20 Jul 2022 00:27:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [bug report] crypto: aria - Implement ARIA symmetric cipher
 algorithm
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-crypto@vger.kernel.org
References: <YtZn9YdHZDDBWzoC@kili>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <YtZn9YdHZDDBWzoC@kili>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dan,
Thank you so much for your report!

On 7/19/22 17:14, Dan Carpenter wrote:
 > Hello Taehee Yoo,
 >
 > The patch e4e712bbbd6d: "crypto: aria - Implement ARIA symmetric
 > cipher algorithm" from Jul 4, 2022, leads to the following Smatch
 > static checker warning:
 >
 > crypto/aria.c:69 aria_set_encrypt_key() error: buffer overflow 'ck' 4 
<= 4
 > crypto/aria.c:70 aria_set_encrypt_key() error: buffer overflow 'ck' 4 
<= 5
 > crypto/aria.c:71 aria_set_encrypt_key() error: buffer overflow 'ck' 4 
<= 6
 > crypto/aria.c:72 aria_set_encrypt_key() error: buffer overflow 'ck' 4 
<= 7
 > crypto/aria.c:86 aria_set_encrypt_key() error: buffer overflow 'ck' 4 
<= 8
 > crypto/aria.c:87 aria_set_encrypt_key() error: buffer overflow 'ck' 4 
<= 9
 > crypto/aria.c:88 aria_set_encrypt_key() error: buffer overflow 'ck' 4 
<= 10
 > crypto/aria.c:89 aria_set_encrypt_key() error: buffer overflow 'ck' 4 
<= 11
 >
 > crypto/aria.c
 >      19 static void aria_set_encrypt_key(struct aria_ctx *ctx, const 
u8 *in_key,
 >      20                                  unsigned int key_len)
 >      21 {
 >      22         const __be32 *key = (const __be32 *)in_key;
 >      23         u32 w0[4], w1[4], w2[4], w3[4];
 >      24         u32 reg0, reg1, reg2, reg3;
 >      25         const u32 *ck;
 >      26         int rkidx = 0;
 >      27
 >      28         ck = &key_rc[(key_len - 16) / 8][0];
 >
 > key_rc is declared like this:
 >
 > static const u32 key_rc[5][4] = {
 >
 >      29
 >      30         w0[0] = be32_to_cpu(key[0]);
 >      31         w0[1] = be32_to_cpu(key[1]);
 >      32         w0[2] = be32_to_cpu(key[2]);
 >      33         w0[3] = be32_to_cpu(key[3]);
 >      34
 >      35         reg0 = w0[0] ^ ck[0];
 >      36         reg1 = w0[1] ^ ck[1];
 >      37         reg2 = w0[2] ^ ck[2];
 >      38         reg3 = w0[3] ^ ck[3];
 >      39
 >      40         aria_subst_diff_odd(&reg0, &reg1, &reg2, &reg3);
 >      41
 >      42         if (key_len > 16) {
 >      43                 w1[0] = be32_to_cpu(key[4]);
 >      44                 w1[1] = be32_to_cpu(key[5]);
 >      45                 if (key_len > 24) {
 >      46                         w1[2] = be32_to_cpu(key[6]);
 >      47                         w1[3] = be32_to_cpu(key[7]);
 >      48                 } else {
 >      49                         w1[2] = 0;
 >      50                         w1[3] = 0;
 >      51                 }
 >      52         } else {
 >      53                 w1[0] = 0;
 >      54                 w1[1] = 0;
 >      55                 w1[2] = 0;
 >      56                 w1[3] = 0;
 >      57         }
 >      58
 >      59         w1[0] ^= reg0;
 >      60         w1[1] ^= reg1;
 >      61         w1[2] ^= reg2;
 >      62         w1[3] ^= reg3;
 >      63
 >      64         reg0 = w1[0];
 >      65         reg1 = w1[1];
 >      66         reg2 = w1[2];
 >      67         reg3 = w1[3];
 >      68
 > --> 69         reg0 ^= ck[4];
 >
 > So 4 and above is out of bounds.
 >
 >      70         reg1 ^= ck[5];
 >      71         reg2 ^= ck[6];
 >      72         reg3 ^= ck[7];
 >      73
 >      74         aria_subst_diff_even(&reg0, &reg1, &reg2, &reg3);
 >      75
 >      76         reg0 ^= w0[0];
 >      77         reg1 ^= w0[1];
 >      78         reg2 ^= w0[2];
 >      79         reg3 ^= w0[3];
 >      80
 >      81         w2[0] = reg0;
 >      82         w2[1] = reg1;
 >      83         w2[2] = reg2;
 >      84         w2[3] = reg3;
 >      85
 >      86         reg0 ^= ck[8];
 >      87         reg1 ^= ck[9];
 >      88         reg2 ^= ck[10];
 >      89         reg3 ^= ck[11];
 >      90
 >      91         aria_subst_diff_odd(&reg0, &reg1, &reg2, &reg3);
 >      92
 >      93         w3[0] = reg0 ^ w1[0];
 >      94         w3[1] = reg1 ^ w1[1];
 >      95         w3[2] = reg2 ^ w1[2];
 >      96         w3[3] = reg3 ^ w1[3];
 >      97
 >      98         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 19);
 >      99         rkidx++;
 >      100         aria_gsrk(ctx->enc_key[rkidx], w1, w2, 19);
 >      101         rkidx++;
 >      102         aria_gsrk(ctx->enc_key[rkidx], w2, w3, 19);
 >      103         rkidx++;
 >      104         aria_gsrk(ctx->enc_key[rkidx], w3, w0, 19);
 >      105
 >      106         rkidx++;
 >      107         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 31);
 >      108         rkidx++;
 >      109         aria_gsrk(ctx->enc_key[rkidx], w1, w2, 31);
 >      110         rkidx++;
 >      111         aria_gsrk(ctx->enc_key[rkidx], w2, w3, 31);
 >      112         rkidx++;
 >      113         aria_gsrk(ctx->enc_key[rkidx], w3, w0, 31);
 >      114
 >      115         rkidx++;
 >      116         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 67);
 >      117         rkidx++;
 >      118         aria_gsrk(ctx->enc_key[rkidx], w1, w2, 67);
 >      119         rkidx++;
 >      120         aria_gsrk(ctx->enc_key[rkidx], w2, w3, 67);
 >      121         rkidx++;
 >      122         aria_gsrk(ctx->enc_key[rkidx], w3, w0, 67);
 >      123
 >      124         rkidx++;
 >      125         aria_gsrk(ctx->enc_key[rkidx], w0, w1, 97);
 >      126         if (key_len > 16) {
 >      127                 rkidx++;
 >      128                 aria_gsrk(ctx->enc_key[rkidx], w1, w2, 97);
 >      129                 rkidx++;
 >      130                 aria_gsrk(ctx->enc_key[rkidx], w2, w3, 97);
 >      131
 >      132                 if (key_len > 24) {
 >      133                         rkidx++;
 >      134                         aria_gsrk(ctx->enc_key[rkidx], w3, 
w0, 97);
 >      135
 >      136                         rkidx++;
 >      137                         aria_gsrk(ctx->enc_key[rkidx], w0, 
w1, 109);
 >      138                 }
 >      139         }
 >      140 }
 >
 > regards,
 > dan carpenter

I think this is a false positive of smatch.
ck is a pointer and it points key_rc, which is a double array.
But ck is used as a single array.
So, I think smatch warns it although there are actually no out-of-bounds.

I just tested changing key_rc to a single array.
There are no smatch warnings.
So, I will send a patch to avoid this smatch warning.

Thank you so much,
Taehee Yoo
