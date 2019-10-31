Return-Path: <SRS0=cgyY=YY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF888CA9ECF
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 22:24:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83EE8208E3
	for <linux-crypto@archiver.kernel.org>; Thu, 31 Oct 2019 22:24:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="AD/gZZ1C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387473AbfJaWY6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 31 Oct 2019 18:24:58 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46610 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387460AbfJaWY5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 31 Oct 2019 18:24:57 -0400
Received: by mail-lf1-f66.google.com with SMTP id 19so726205lft.13
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2019 15:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ORkqg8jrCk99CbRhXtrcXymZe6o7nmpqtAPr7747lS8=;
        b=AD/gZZ1Cpjbeqlwfl+u10wNGTldCiw330eGBQ1fshVKctYYDKteTuKDivIB1FUE1FW
         NrKb8RTOhD3IfZmE6+kSKNGn6Vo2NXnakjLzZ0r1MMjTtJ/OzVRw7ohloDnZfD4kRPqC
         qnmvt7mV23Tl60X47NEoJjBg6wg9MGohmgttpK/im/fMVZs03RVGZcEcv/eQDlT54W64
         HnTxis86hAnWMaI2aed7c8/+ZMmfMn/AJivbvBKumPCBs62+RfNNIQ7284+58+1ipzqW
         hNSZ+fYGxx2/aDovqaRC0gykyMrLDzDkt1XoSNZLKkW5oqROLJm+Yztga0AG8Enjk5TF
         Y5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ORkqg8jrCk99CbRhXtrcXymZe6o7nmpqtAPr7747lS8=;
        b=eWHZbjd+4fxQvt1I9GErCqeuAqvHZvfFyzgj7Q13/m6jEvCOLvH/Pj6P18dg/qfhMv
         9W6U0MlQASGkGohGuietChhtRdQFjn4VakjpKXGB1yRR/TSjikji+Q3pv7tPjO/OzzFx
         MPMcovWUsa3GtNZiExu6OF/MbJi1EGqwgbcGbQjXm91EY3vv6Sl0wuGSRt9pD5miIMB9
         hyudrJLfQ8ZKNZ0YU0iEh2c6Cbek6cxDFM9QaekwTIKQOkESOKpn8JIuLx90aYgACDGi
         VRYvLe2csfRvkmomprT5ckmOWESOGMRXc5V6vZQtIc+9lmrAeR898U6rIJRiSIMX7sTM
         s/xg==
X-Gm-Message-State: APjAAAWPlbMmEPIgz2IAZxuJQf7obW/ZfPDYhMO3q8nyt5DDTmmvYP7O
        x0LlcHIJuGZ3MkXVUfW8h/t0YQ==
X-Google-Smtp-Source: APXvYqxNDxzC9Op1/RduXp77CMkaMX5QPJzNtAPa2NzrUsN+xGhvvNluCpj+CHNKMwn1tQ+RgNy+eA==
X-Received: by 2002:ac2:48b5:: with SMTP id u21mr5259536lfg.75.1572560693859;
        Thu, 31 Oct 2019 15:24:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g3sm1699096ljj.59.2019.10.31.15.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:24:53 -0700 (PDT)
Date:   Thu, 31 Oct 2019 15:24:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, borisp@mellanox.com,
        aviadye@mellanox.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Message-ID: <20191031152444.773c183b@cakuba.netronome.com>
In-Reply-To: <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 31 Oct 2019 15:05:53 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > sk_msg_trim() tries to only update curr pointer if it falls into
> > the trimmed region. The logic, however, does not take into the
> > account pointer wrapping that sk_msg_iter_var_prev() does.
> > This means that when the message was trimmed completely, the new
> > curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> > neither smaller than any other value, nor would it actually be
> > correct.
> > 
> > Special case the trimming to 0 length a little bit.
> > 
> > This bug caused the TLS code to not copy all of the message, if
> > zero copy filled in fewer sg entries than memcopy would need.
> > 
> > Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> > 
> > Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> > Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> > Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > ---
> > Daniel, John, does this look okay?  
> 
> Thanks for the second ping!

No problem, I was worried the patch got categorized as TLS and therefore
lower prio ;)

> > CC: Eric Biggers <ebiggers@kernel.org>
> > CC: herbert@gondor.apana.org.au
> > CC: glider@google.com
> > CC: linux-crypto@vger.kernel.org
> > 
> >  net/core/skmsg.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index cf390e0aa73d..c42c145216b1 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -276,7 +276,10 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
> >  	 * However trimed data that has not yet been used in a copy op
> >  	 * does not require an update.
> >  	 */
> > -	if (msg->sg.curr >= i) {
> > +	if (!msg->sg.size) {
> > +		msg->sg.curr = 0;
> > +		msg->sg.copybreak = 0;
> > +	} else if (msg->sg.curr >= i) {
> >  		msg->sg.curr = i;
> >  		msg->sg.copybreak = msg->sg.data[i].length;
> >  	}
> > --   
> 
> 
> Its actually not sufficient. We can't directly do comparisons against curr
> like this. msg->sg is a ring buffer so we have to be careful for these
> types of comparisons.
> 
> Examples hopefully help explian. Consider the case with a ring layout on
> entering sk_msg_trim,
> 
>    0 1 2                              N = MAX_MSG_FRAGS
>   |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>        ^       ^         ^
>        curr    end       start
> 
> Start trimming from end
> 
>    0 1 2                              N = MAX_MSG_FRAGS
>   |X|X|X|...|X|X|_|...|_|_|i|X|....|X|X|
>        ^       ^         ^
>        curr    end       start
> 
> We trim backwards through ring with sk_msg_iter_var_prev(). And its
> possible to end with the result of above where 'i' is greater than curr
> and greater than start leaving scatterlist elements so size != 0.
> 
>     i > curr && i > start && sg.size != 0
> 
> but we wont catch it with this condition
> 
>     if (msg->sg.curr >= i)
> 
> So we won't reset curr and copybreak so we have a potential issue now
> where curr is pointing at data that has been trimmed.

I see, that makes sense and explains some of the complexity!

Perhaps the simplest way to go would be to adjust the curr as we go
then? The comparison logic could get a little hairy. So like this:

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cf390e0aa73d..c2b0f9cb589c 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -261,25 +261,29 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
        msg->sg.size = len;
        while (msg->sg.data[i].length &&
               trim >= msg->sg.data[i].length) {
+               bool move_curr = msg->sg.curr == i;
+
                trim -= msg->sg.data[i].length;
                sk_msg_free_elem(sk, msg, i, true);
                sk_msg_iter_var_prev(i);
+               if (move_curr) {
+                       msg->sg.curr = i;
+                       msg->sg.copybreak = msg->sg.data[i].length;
+               }
                if (!trim)
                        goto out;
        }
 
        msg->sg.data[i].length -= trim;
        sk_mem_uncharge(sk, trim);
-out:
        /* If we trim data before curr pointer update copybreak and current
         * so that any future copy operations start at new copy location.
         * However trimed data that has not yet been used in a copy op
         * does not require an update.
         */
-       if (msg->sg.curr >= i) {
-               msg->sg.curr = i;
+       if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
                msg->sg.copybreak = msg->sg.data[i].length;
-       }
+out:
        sk_msg_iter_var_next(i);
        msg->sg.end = i;
 }

> I'll put together a fix but the correct thing to do here is a proper
> ring greater than op which is not what we have there. Although, your patch
> is also really a good one to have because reseting curr = 0 and
> copybreak = 0 when possible keeps the ring from being fragmented which
> avoids chaining when we push scatterlists down to crypto layer. So for
> your patch,
> 
> Acked-By: John Fastabend <john.fastabend@gmail.com>
> 
> If it should go to net or net-next I think is probably up for debate
> 
> Nice catch!!! Can you send me the reproducer?

I was using the repro from the syzbot report:

https://syzkaller.appspot.com/bug?extid=6f50c99e8f6194bf363f

plus this hack from Alexander to avoid the need for KMSAN:

https://lkml.kernel.org/linux-crypto/CAG_fn=UGCoDk04tL2vB981JmXgo6+-RUPmrTa3dSsK5UbZaTjA@mail.gmail.com/
