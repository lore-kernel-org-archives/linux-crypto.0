Return-Path: <SRS0=nD+4=Y4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D38CA9EB5
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Nov 2019 19:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 121412080F
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Nov 2019 19:34:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="XNDo374J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbfKDTeU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Nov 2019 14:34:20 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37641 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDTeT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Nov 2019 14:34:19 -0500
Received: by mail-lj1-f194.google.com with SMTP id l20so313371lje.4
        for <linux-crypto@vger.kernel.org>; Mon, 04 Nov 2019 11:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=fgSeIYEYDrhZGVZ1wThncNpInXi9KuTgwauEOaT/fz8=;
        b=XNDo374JjUNHFXw5xBuVByALaK8ejs5Wkhil7aQ1XBWn5hgeYqLzayJla0aWI937cv
         lCHOve2W62HATQ69l5pqd3Fx56DjU/5i2AnOZ1y9GC8hXkp8X7j3/JLw3Z6YlmADqL8/
         mX6rHMuXZz1rjIv68PqzMWb6/RcI3K/s1dvEnWvSn7TxI022dpcCLAENvldNs3L1gOT9
         pAuwWLEzZDmHeUqdoezmdXvG18/Ap6Do7TEoLXT8MOS9pRDLu2yJgCZhNFRFSUWLxvKS
         biQHw2v3X/Apj/q6Hg2e2llmQZP9eC5mHSzmmTrIOpA+6LGkjYSDP6+GaHsZQ6UvcO08
         r5uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=fgSeIYEYDrhZGVZ1wThncNpInXi9KuTgwauEOaT/fz8=;
        b=ClxuA/BO3J0N28gR1eIJYhZrRJ9lI9+vHBKbxn8Cz3cOGxWb48xAI07tUa+luGOdKY
         W0n0283u0U9xbey1zmi83FUTlWZhv1wAU9c8PVZbH0mw5f4aPp+lZ2v6K+rWgqzHbizv
         cktHpulN+ByDk7Kuy/EhcA3Q/wpmJhBpzIv71UomJ1vgia8vygPzDZHdsEwni0qf+UIB
         vnnF4e8Sua82/U+38y7eVwnXkskqHkYgn9VEfb1LOF0un247BXT5mnaT4CsqeoBkyQyg
         9keFc+UBunzj5ijRjNWHg/To6kBq7LP09MiB4iSXBAD531hbd7w528P5Ixc1Ykz3HLTU
         Xo3A==
X-Gm-Message-State: APjAAAWY8yY6GUw0KKrptR1keYw6xJ8ZOoojmoW1eFm4Ff8jyqoGTN+n
        8axVWak2zeaF8OvVnj6F8CRByQ==
X-Google-Smtp-Source: APXvYqyMAFBGZOHSvW+4tcTBdNMQAfmjcnIVtFWHqHu+kYjRrJ3kcJfacfRH5Nqmwvl4fTuMkhnfXw==
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr1344371ljj.243.1572896057562;
        Mon, 04 Nov 2019 11:34:17 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q15sm6946976lfb.84.2019.11.04.11.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 11:34:17 -0800 (PST)
Date:   Mon, 4 Nov 2019 11:34:07 -0800
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
Message-ID: <20191104113407.7da3ed44@cakuba.netronome.com>
In-Reply-To: <5dc074744c05c_47f72aeaf1bf65c456@john-XPS-13-9370.notmuch>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
        <20191031152444.773c183b@cakuba.netronome.com>
        <5dbbb83d61d0c_46342ae580f765bc78@john-XPS-13-9370.notmuch>
        <20191031215444.68a12dfe@cakuba.netronome.com>
        <5dbc48ac3a8cc_e4e2b12b10265b8a1@john-XPS-13-9370.notmuch>
        <20191101102238.7f56cb84@cakuba.netronome.com>
        <20191101125139.77eb57aa@cakuba.netronome.com>
        <5dc074744c05c_47f72aeaf1bf65c456@john-XPS-13-9370.notmuch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 04 Nov 2019 10:56:52 -0800, John Fastabend wrote:
> Jakub Kicinski wrote:
> > diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> > index cf390e0aa73d..f87fde3a846c 100644
> > --- a/net/core/skmsg.c
> > +++ b/net/core/skmsg.c
> > @@ -270,18 +270,28 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
> >  
> >  	msg->sg.data[i].length -= trim;
> >  	sk_mem_uncharge(sk, trim);
> > +	/* Adjust copybreak if it falls into the trimmed part of last buf */
> > +	if (msg->sg.curr == i && msg->sg.copybreak > msg->sg.data[i].length)
> > +		msg->sg.copybreak = msg->sg.data[i].length;
> >  out:
> > -	/* If we trim data before curr pointer update copybreak and current
> > -	 * so that any future copy operations start at new copy location.
> > +	sk_msg_iter_var_next(i);
> > +	msg->sg.end = i;
> > +
> > +	/* If we trim data a full sg elem before curr pointer update
> > +	 * copybreak and current so that any future copy operations
> > +	 * start at new copy location.
> >  	 * However trimed data that has not yet been used in a copy op
> >  	 * does not require an update.
> >  	 */
> > -	if (msg->sg.curr >= i) {
> > +	if (!msg->sg.size) {
> > +		msg->sg.curr = msg->sg.start;
> > +		msg->sg.copybreak = 0;
> > +	} else if (sk_msg_iter_dist(msg->sg.start, msg->sg.curr) >
> > +		   sk_msg_iter_dist(msg->sg.end, msg->sg.curr)) {  
> 
> I'm not seeing how this can work. Taking simple case with start < end
> so normal geometry without wrapping. Let,
> 
>  start = 1
>  curr  = 3
>  end   = 4
> 
> We could trim an index to get,
> 
>  start = 1
>   curr = 3
>      i = 3
>    end = 4

IOW like this?

	test_one(/* start */ 1, /* curr */ 3, /* copybreak */ 150,
		 /* trim */ 500,
		 /* curr */ 3, /* copybreak */ 100, /* end */ 4,
		 /* data */ 200, 200, 200);

test #13  start:1 curr:3 end:4 cb:150 size: 600      0 200 200 200   0	OKAY

> Then after out: label this would push end up one,
> 
>  start = 1
>   curr = 3
>      i = 3
>    end = 4

I moved the assignment to end before the curr adjustment, so 'i' is
equivalent to 'end' at this point.

> But dist(start,curr) = 2 and dist(end, curr) = 1 and we would set curr
> to '3' but clear the copybreak?

I don't think we'd fall into this condition ever, unless we moved end.
And in your example AFAIU we don't move end.

> I think a better comparison would be,
> 
>   if (sk_msg_iter_dist(msg->sg.start, i) <
>       sk_msg_iter_dist(msg->sg.start, msg->sg.curr)
> 
> To check if 'i' walked past curr so we can reset curr/copybreak?

Ack, this does read better!

Should we use <= here? If we dropped a full segment, should curr point
at the end of the last remaining segment or should it point at 0 in end?
