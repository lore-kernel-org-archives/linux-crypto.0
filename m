Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 716F0CA9EC9
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 04:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FACD2085B
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 04:54:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="seTDmiNr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729404AbfKAEyu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 00:54:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37953 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKAEyu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Nov 2019 00:54:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id j30so2208437pgn.5
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2019 21:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8tPWK5BYgsuL9zha6OCfDPYnrci37qEo2bbOP/w1G5Q=;
        b=seTDmiNrqiUFMt4vzI8kNkW8iW6IXp4/atKoYhwPQSoD4SpW4iDH7n/phuuwaqmUg/
         eF6bQAxxZQ7PVJF8qsKSUY8lYIn4Wv7bOP1PmKXF9CtgJ5KRYGc7f8it4cEqvGjJwImo
         wqRXiwbPz23eV76ZXCPTH0LsW+hwi3juz7To7zhtN5BNbx1gHbm3SpEVNfxFl2cZ+wC5
         r2qws2hDTXG2HUIYcEMWXRL5YvLqQE7NEogbyFaqlMOiHA+ANJKHcoWhkauS0oFlA6OD
         ZjP2IiyhcpWymlvM+8uuks6gAefKltNDUs76/uo+lsOu91+TQFBn3C5+0o2itr2dwXwq
         CqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8tPWK5BYgsuL9zha6OCfDPYnrci37qEo2bbOP/w1G5Q=;
        b=Sm7IhrVRDvOOJvQRVTt1842IeGH6CeUdwzx71imOQx77dAuRAJR5No1PEaB1cW3/of
         peBlFTriDhm9yyHrZeDT17RAAoqLgmK4908p9Gu/grn5Gj3YvCNn0k+50qvg8mejhS6K
         IG3U0T/HwEMHO64Z6vvUd/qv3ANDbu7QAUrCEzI2iVGUY7sYaoM1Ia53AfQXpA2asjft
         HIpCVNDEqhgwGiEnBCNgb0NK4GgY0NazwlHJR/SFByWQSx3SeBVQIJKNWcRfvbPZS/IR
         4ZjWK5CVVrTmNBgKYzjv3MFaaZmiSh0RZuqhHBkhxycC0aTVMcWWBRxsiq5xU06t+iFm
         CLPg==
X-Gm-Message-State: APjAAAV8nG1sBw4s2rny7MNmZvXwopHXB+TZqy8XC4sFKIEjAN4uakmr
        4JmPL10Q9XG+ZRG9veAEOjajxA==
X-Google-Smtp-Source: APXvYqzxZYnEkqVpNUYPkOkE6SqlqUJp+ABefXAxX16P0ANDk/fLjwFTDUi/wu3EtDkNzXswS9II0A==
X-Received: by 2002:a62:76c6:: with SMTP id r189mr11322014pfc.48.1572584089179;
        Thu, 31 Oct 2019 21:54:49 -0700 (PDT)
Received: from cakuba.netronome.com ([2601:646:8e00:e18::4])
        by smtp.gmail.com with ESMTPSA id e198sm5178943pfh.83.2019.10.31.21.54.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 21:54:48 -0700 (PDT)
Date:   Thu, 31 Oct 2019 21:54:44 -0700
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
Message-ID: <20191031215444.68a12dfe@cakuba.netronome.com>
In-Reply-To: <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
        <20191031152444.773c183b@cakuba.netronome.com>
        <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 31 Oct 2019 21:44:45 -0700, John Fastabend wrote:
> Jakub Kicinski wrote:
> > On Thu, 31 Oct 2019 15:05:53 -0700, John Fastabend wrote:  
> > > Jakub Kicinski wrote:  
> > > > sk_msg_trim() tries to only update curr pointer if it falls into
> > > > the trimmed region. The logic, however, does not take into the
> > > > account pointer wrapping that sk_msg_iter_var_prev() does.
> > > > This means that when the message was trimmed completely, the new
> > > > curr pointer would have the value of MAX_MSG_FRAGS - 1, which is
> > > > neither smaller than any other value, nor would it actually be
> > > > correct.
> > > > 
> > > > Special case the trimming to 0 length a little bit.
> > > > 
> > > > This bug caused the TLS code to not copy all of the message, if
> > > > zero copy filled in fewer sg entries than memcopy would need.
> > > > 
> > > > Big thanks to Alexander Potapenko for the non-KMSAN reproducer.
> > > > 
> > > > Fixes: d829e9c4112b ("tls: convert to generic sk_msg interface")
> > > > Reported-by: syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com
> > > > Reported-by: syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com
> > > > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > > ---
> > > > Daniel, John, does this look okay?    
> > > 
> > > Thanks for the second ping!  
> > 
> > No problem, I was worried the patch got categorized as TLS and therefore
> > lower prio ;)  
> 
> Nope close to the top of the list here.
> 
> >   
>  [...]  
>  [...]  
> > 
> > I see, that makes sense and explains some of the complexity!
> > 
> > Perhaps the simplest way to go would be to adjust the curr as we go
> > then? The comparison logic could get a little hairy. So like this:  
> 
> I don't think the comparison is too bad. Working it out live here. First
> do a bit of case analysis, We have 3 pointers so there are 3!=6 possible
> arrangements (permutations),
> 
>  1. S,C,E  6. S,E,C
>  5. C,S,E  2. C,E,S
>  3. E,S,C  4. E,C,S
> 
> 
> Case 1: Normal case start < curr < end
>  
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>         ^       ^         ^
>         start   curr      end
> 
>   if (start < end && i < curr)
>      curr = i;
>         
>  
> Case 2: curr < end < start (in absolute index terms)
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>         ^       ^         ^
>         curr    end       start
> 
>    if (end < start && (i < curr || i > start))
>         curr = i
> 
> 
> Case 3: end < start < curr
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>                 ^         ^          ^
>                 end       start      curr
> 
> 
>    if (end < start && (i < curr)
>        curr = i;
> 
> 
> Case 4: end < curr < start
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>                 ^         ^          ^
>                 end       curr       start 
> 
> (nonsense curr would be invalid here it must be between the start and end)
> 
> Case 5: curr < start < end
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>                 ^         ^          ^
>                 curr      start      end 
> 
> (nonsense curr would be invalid here it must be between the start and end)
> 
> Case 6: start < end < curr 
> 
>     0 1 2                              N = MAX_MSG_FRAGS
>     |_|_|_|...|_|_|_|...|_|_|_|_|....|_|_|
>                 ^         ^          ^
>                 start     end        curr 
> 
> (nonsense curr would be invalid here it must be between the start and end)
> 
> So I think the following would suffice,
> 
> 
>   if (msg->sg.start < msg->sg.end && i < msg->sg.curr) {
>      msg->sg.curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
>   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr || i > msg->sg.start))
>      msg->sg.curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
>   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr) {
>      curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
>   }
> 
> Finally fold the last two cases into one so we get
> 
>   if (msg->sg.start < msg->sg.end && i < msg->sg.curr) {
>      msg->sg.curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
>   } else if (msg->sg.end < msg->sg.start && (i < msg->sg.curr || i > msg->sg.start))
>      msg->sg.curr = i;
>      msg->sg.copybreak = msg->sg.data[i].length;
> 
> So not so bad. Put that in a helper in sk_msg.h and use it in trim. I can check
> logic in the AM and draft a patch but I think that should be correct. Also will
> need to audit to see if there are other cases this happens. In general I tried
> to always use i == msg->sg.{start|end|curr} to avoid this.

I will look in depth tomorrow as well, the full/empty cases are a
little tricky to fold into general logic.

I came up with this before I got distracted Halloweening :)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index e4b3fb4bb77c..ce7055259877 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -139,6 +139,11 @@ static inline void sk_msg_apply_bytes(struct sk_psock *psock, u32 bytes)
 	}
 }
 
+static inline u32 sk_msg_iter_dist(u32 start, u32 end)
+{
+	return end >= start ? end - start : end + (MAX_MSG_FRAGS - start);
+}
+
 #define sk_msg_iter_var_prev(var)			\
 	do {						\
 		if (var == 0)				\
@@ -198,9 +203,7 @@ static inline u32 sk_msg_elem_used(const struct sk_msg *msg)
 	if (sk_msg_full(msg))
 		return MAX_MSG_FRAGS;
 
-	return msg->sg.end >= msg->sg.start ?
-		msg->sg.end - msg->sg.start :
-		msg->sg.end + (MAX_MSG_FRAGS - msg->sg.start);
+	return sk_msg_iter_dist(msg->sg.start, msg->sg.end);
 }
 
 static inline struct scatterlist *sk_msg_elem(struct sk_msg *msg, int which)
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index cf390e0aa73d..f6b4a70bafa9 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -270,18 +270,26 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
 
 	msg->sg.data[i].length -= trim;
 	sk_mem_uncharge(sk, trim);
+	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
+		msg->sg.copybreak = msg->sg.data[i].length;
 out:
+	sk_msg_iter_var_next(i);
+	msg->sg.end = i;
+
 	/* If we trim data before curr pointer update copybreak and current
 	 * so that any future copy operations start at new copy location.
 	 * However trimed data that has not yet been used in a copy op
 	 * does not require an update.
 	 */
-	if (msg->sg.curr >= i) {
+	if (!msg->sg.size) {
+		msg->sg.curr = 0;
+		msg->sg.copybreak = 0;
+	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
+		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {
+		sk_msg_iter_var_prev(i);
 		msg->sg.curr = i;
 		msg->sg.copybreak = msg->sg.data[i].length;
 	}
-	sk_msg_iter_var_next(i);
-	msg->sg.end = i;
 }
 EXPORT_SYMBOL_GPL(sk_msg_trim);
 
-- 
2.23.0
