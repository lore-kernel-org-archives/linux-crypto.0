Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BACCCA489
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Jul 2022 07:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238445AbiGZHcd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Jul 2022 03:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbiGZHb6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Jul 2022 03:31:58 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E626D31DEA
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 00:28:02 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id a82so18411871ybb.12
        for <linux-crypto@vger.kernel.org>; Tue, 26 Jul 2022 00:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VvOrjB34rm7PzOpcu5vN7H48T73Za5L36kUOrTOg6ZU=;
        b=UYCAqLQdkCe++bxbvoqb8ja13KXFhIBaW0rC+YYqYq4gvHo+TFgKPF/GZuT91VmSB8
         C1W+AZw4l9ok/cijI6EPFtIFecx9ElKI75nt3EZmXPMl0ME3rxCMtwt6FCqEcqAzlXgc
         L7pKvLgAUNdI/gsvxXkfFlg5biXeIuPvgjq6OlZZ2cbEWC7jVJ6RmvIswJs0R1wPEInh
         sNGMWt8YNJtmjzLBgsGVFMhf8MoqqCx0CeHLgs7fbxPF4hIut+LmlvHlIRh5UZesH3nX
         o77xUb6eSknQa9/tZQ3BGK1QZOpg9ZmseIfEITeaJYNYQSmSvHlSqBbMN8jvoIXgWsY1
         JjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VvOrjB34rm7PzOpcu5vN7H48T73Za5L36kUOrTOg6ZU=;
        b=jS7yiV1a3+hSrbKofRNofpD30xMuzU1zhanibyJCHi2sMkav+0k7PE5Q2oz3IBjhb9
         SBucS4cw7wEvIMo1iVSZD7e+1LBzz/aWEDR7rPywmXCQZWtWGcH+rl/XutiND3vjAu7k
         GAVCkPg2SO4uUHNXZFtxSV18pKC/ju6zGUH+5OYo66RByd/8ZYzABBijVCGtPQsrOzls
         rESDeKvHZDrTwtOqJGLpgKtgkb9P4cZYMXNH0FkwZ0ZStSaiDT/Qc2BBkVLkxWNV2AZw
         daNVTuefKYtCH/mTHS/KPKMgAF11jr1EKVwKOX2S5hGy3bB2pj7so5k+EHmMmCNS31dZ
         gCCQ==
X-Gm-Message-State: AJIora9PIgckw6CDXbX2/H4TBIhM305y0nZ/ZmIYA+acqdYKqVoqJdvF
        K32P7vOKQptEjV+K036dPcZCRZIoODodAAofy+DApg==
X-Google-Smtp-Source: AGRyM1uv33zE0Yb5is3EhxTK8li350eCyxt4TvCNmDbhnKmlwtoEaE5nifSRGC+74wymZu7Olm8dTCRPLhrYeL6/L+k=
X-Received: by 2002:a25:13c8:0:b0:670:6a55:5fad with SMTP id
 191-20020a2513c8000000b006706a555fadmr12357687ybt.598.1658820477779; Tue, 26
 Jul 2022 00:27:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1658815925.git.cdleonard@gmail.com> <ad19d5c8a24054d48e1c35bb0ec92075b9f0dc6a.1658815925.git.cdleonard@gmail.com>
 <CANn89i+ByJsdKLXi982jq0H3irYg_ANSEdmL2zwZ_7G-E_g2eg@mail.gmail.com>
In-Reply-To: <CANn89i+ByJsdKLXi982jq0H3irYg_ANSEdmL2zwZ_7G-E_g2eg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 26 Jul 2022 09:27:46 +0200
Message-ID: <CANn89i+=LVDFx_zjDy6uK+QorR+fosdkb8jqNMO6syqOsS7ZqQ@mail.gmail.com>
Subject: Re: [PATCH v6 21/26] selftests: net/fcnal: Initial tcp_authopt support
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Philip Paeps <philip@trouble.is>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 26, 2022 at 9:06 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jul 26, 2022 at 8:16 AM Leonard Crestez <cdleonard@gmail.com> wrote:
> >
> > Tests are mostly copied from tcp_md5 with minor changes.
> >
> > It covers VRF support but only based on binding multiple servers: not
> > multiple keys bound to different interfaces.
> >
> > Also add a specific -t tcp_authopt to run only these tests specifically.
> >
>
> Thanks for the test.
>
> Could you amend the existing TCP MD5 test to make sure dual sockets
> mode is working ?
>
> Apparently, if we have a dual stack listener socket (AF_INET6),
> correct incoming IPV4 SYNs are dropped.
>
>  If this is the case, fixing MD5 should happen first ;)
>
> I think that we are very late in the cycle (linux-5.19 should be
> released in 5 days), and your patch set should not be merged so late.

I suspect bug was added in

commit 7bbb765b73496699a165d505ecdce962f903b422
Author: Dmitry Safonov <0x7f454c46@gmail.com>
Date:   Wed Feb 23 17:57:40 2022 +0000

    net/tcp: Merge TCP-MD5 inbound callbacks

a possible fix (also removing an indirect call for IPV4) could be:

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ba2bdc81137490bd1748cde95789f8d2bff3ab0f..66b883d1683ddf7de6a8959a2b4e025a74c830b1
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4534,8 +4534,14 @@ tcp_inbound_md5_hash(const struct sock *sk,
const struct sk_buff *skb,
        }

        /* check the signature */
-       genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
-                                                NULL, skb);
+       if (family == AF_INET)
+               genhash = tcp_v4_md5_hash_skb(newhash,
+                                             hash_expected,
+                                             NULL, skb);
+       else
+               genhash = tp->af_specific->calc_md5_hash(newhash,
+                                                        hash_expected,
+                                                        NULL, skb);

        if (genhash || memcmp(hash_location, newhash, 16) != 0) {
                NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);
