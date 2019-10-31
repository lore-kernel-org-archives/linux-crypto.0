Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE325CA9ECB
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 21:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE2C220862
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 21:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="Z2fAm/dK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfJaVQz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 17:16:55 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35984 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728645AbfJaVQz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 17:16:55 -0400
Received: by mail-lj1-f194.google.com with SMTP id x9so3341013lji.3
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2019 14:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bqOg5+zD8Qpj1h7Ic7EcL5kmHzAI7gRipZPMSEC5V7Q=;
        b=Z2fAm/dK3ZxXj0TZOs0SS3npbKPsleVuDrlV7Ep2VbXhRuVZ3qJUeVp1b1XyBF3E0B
         EQZtrvQiA6QquqYSckLTE6s/viHWAxzWDglPKVAqPI4VpmSVCdg7Ag1QNUwGQN/vJpTg
         GfwYXIfCFriIhcvBlkPebYsMnJVJQ7Y1WHNzaTx3iT4YHjAZX4iCvzOpVXBelUoD5WEY
         SNqYibKijmtM6W2QzbYCBZStw8Bxe3HpFD0OnU+M26De7KuIb/bcSPuZCnM4Tp/W+uBV
         YTSkNrKcQHQBfaek7SdmPoAzDyRuV4EIFGzuvQdnDaKWm7Ybwmo0DGai/zKO2JJDIMSl
         YVgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bqOg5+zD8Qpj1h7Ic7EcL5kmHzAI7gRipZPMSEC5V7Q=;
        b=QBVK2eLyIpq4KdlrJftjEDWmm2Nqox26hj6uSE7vYEDoSSTSJ8Yx7orZqALrKr7kne
         n3KQkVlrve9ZZMaHnFNXriUILSPJNVU12J72ZDpgseWPHcVDj405fgRUwuUbC8RmMI6k
         2qj6/5FsnFrUZ+TBDktKqOXEtfmMWyq/jIeixrI6sK77D2mWBsa32Novf9KXMfmoz5c0
         R8lbFbW5HGCeTpWybSRvezwIfgGBiqZIo+Ff1ku3GoKUbqxi5by3WTO/o/xZx2EunHNa
         LEw6Sc4XdsSzJ1N9c3uc1GwS0/Deuw0aESXqoex738PMfs1PCZt7G4GxZ8NSXQ7X6QkC
         Zciw==
X-Gm-Message-State: APjAAAX9OTogutiNqOv42B14RKjyRWPL8kKg+32y1KgMoZFYO1vEN/fo
        +aHg3Wz1TZYrM7QnWV3NjkYr0rgYCUA=
X-Google-Smtp-Source: APXvYqyKiWVFriT0CLGCLpVNooib4zSSMSTW/0s46B8dmS+Q1SohSANXo7k+00COIHWBG9zZcfC7Ew==
X-Received: by 2002:a2e:84c9:: with SMTP id q9mr5348786ljh.163.1572556613828;
        Thu, 31 Oct 2019 14:16:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 4sm1707585ljv.87.2019.10.31.14.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 14:16:53 -0700 (PDT)
Date:   Thu, 31 Oct 2019 14:16:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, aviadye@mellanox.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Message-ID: <20191031141644.232af7ed@cakuba.netronome.com>
In-Reply-To: <20191030160542.30295-1-jakub.kicinski@netronome.com>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 30 Oct 2019 09:05:42 -0700, Jakub Kicinski wrote:
> sk_msg_trim() tries to only update curr pointer if it falls into
> the trimmed region. The logic, however, does not take into the
> account pointer wrapping that sk_msg_iter_var_prev() does.
> This means that when the message was trimmed completely, the new
> curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> neither smaller than any other value, nor would it actually be
> correct.
> 
> Special case the trimming to 0 length a little bit.
> 
> This bug caused the TLS code to not copy all of the message, if
> zero copy filled in fewer sg entries than memcopy would need.
> 
> Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> 
> Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> ---
> Daniel, John, does this look okay?
> 
> CC: Eric Biggers <ebiggers@kernel.org>
> CC: herbert@gondor.apana.org.au
> CC: glider@google.com
> CC: linux-crypto@vger.kernel.org
> 
>  net/core/skmsg.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Daniel, John does this patch look reasonable? I must admit 
the skmsg stuff in TLS scares me, it'd appreciate an ack.
