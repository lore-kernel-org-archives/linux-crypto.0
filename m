Return-Path: <SRS0=WH6x=DO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27595C4363C
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 19:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7E7D207C3
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Oct 2020 19:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rXTJwJN0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbgJGTUA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Oct 2020 15:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728034AbgJGTT7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Oct 2020 15:19:59 -0400
Received: from mail-ua1-x944.google.com (mail-ua1-x944.google.com [IPv6:2607:f8b0:4864:20::944])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9741C061755
        for <linux-crypto@vger.kernel.org>; Wed,  7 Oct 2020 12:19:59 -0700 (PDT)
Received: by mail-ua1-x944.google.com with SMTP id x26so1106170uan.11
        for <linux-crypto@vger.kernel.org>; Wed, 07 Oct 2020 12:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jd1Rz+PGsa7YJOZ7pIuWzUsUkRJF4E4Kzuv1uCwcgaE=;
        b=rXTJwJN0JcnpP5nQFcPxiqU0Voe2Qxo5QAHUkagkABVM6G5RYDANA/VAirV8LWoSIy
         QLpXe0Fivt2sWI1pT4fr4b40uoTvBFph4d16JqF2w6LlyNRVl+PVqvesTuTrxMZ9kxpI
         9ZsnqOafKDhw90nXn25DDFtdvlRKuElgk1fY7h06+pYGTxuOKqW2ZuRpJBQzAk3PjMY4
         Mpnz1IyT2NJpzdGsC0ly+usE8Ry5/f5bo41EBtXXkcXNYoPpQYSG/iMotvTDp7HyDJhU
         1rPp7IGk5taEjTQo33LH7cFD0EkbESBnQ++m+NMJnld1wPGHNv07TBSvtkEtEf5cUd2I
         OHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jd1Rz+PGsa7YJOZ7pIuWzUsUkRJF4E4Kzuv1uCwcgaE=;
        b=Zz4oKrqV/y6H57QGc0ODShFVIzKtalnhGW0WWPjDqrNeIMuwqo8js1HTCK6RJzRRSi
         WI2hd9Edfyz6HY5v9X8T4YUVysZdqW+2eqlCzXBskFXGDyV8q+vLnVA6c9tIIR0QVq/y
         XyCZ6SE7FTVNIT/GhGZZVTihGLoAMl/gPSQ5yVVuxPeORGfMMr5NamzDhXWJyK/fZ9Q+
         7pJcNK5KiT1DBUrU+z0mky1h8WkUoxFBBUShkFO9BWZKisD4XtdudWeOY0LqUcheFiCQ
         XOHkLZUBsah3TejmzyEwQLo/+GJ6kTrRn8+NcR4kMeErzrFcgwjCNt7gxy+04cB5bFN7
         O4ow==
X-Gm-Message-State: AOAM531NwphZCuXmF4rMJbtTK46FSDd5SM9h4Zn4xuH9/i81kSatIfCs
        1EC+6XAQET4OsTU+505tQQ1qyBfujxSOGHVMG70=
X-Google-Smtp-Source: ABdhPJzIH6RDZrO+FV82q5b4FFtj1N01Sm/5ydwrTzrxb4SpK35Gws3zf/oycigkF57hwM77Kh57B82LblRQkQRocgw=
X-Received: by 2002:a9f:2c92:: with SMTP id w18mr2449215uaj.58.1602098398919;
 Wed, 07 Oct 2020 12:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <CAOrEdsmKn7_YWcWZ_b7+mL-uJC8m_=tU70q3aZTOzEDYw7j4ng@mail.gmail.com>
In-Reply-To: <CAOrEdsmKn7_YWcWZ_b7+mL-uJC8m_=tU70q3aZTOzEDYw7j4ng@mail.gmail.com>
From:   Pooja Trivedi <poojatrivedi@gmail.com>
Date:   Wed, 7 Oct 2020 15:19:47 -0400
Message-ID: <CAOrEdsnCbcKiNoyHB=mX2h8soG1txX+aynZaFLNhtwMZWTDkEg@mail.gmail.com>
Subject: [RFC 1/1] net/tls(TLS_SW): Handle -ENOSPC error return from device/AES-NI
To:     Jakub Kicinski <kuba@kernel.org>, linux-crypto@vger.kernel.org
Cc:     Mallesham Jatharakonda <mallesh537@gmail.com>,
        Josh Tway <josh.tway@stackpath.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When an -ENOSPC error code is returned by the crypto device or AES-NI
layer, TLS SW path sets an EBADMSG on the socket causing the
application to fail.  In an attempt to address the -ENOSPC in the TLS
SW path, changes were made in tls_sw_sendpage path to trim current
payload off the plain and encrypted messages, and send a 'zero bytes
copied' return to the application.  The following diff shows those
changes:

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9a3d9fedd7aa..4dce4668cb07 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -762,7 +762,7 @@ static int tls_push_record(struct sock *sk, int flags,
  rc = tls_do_encryption(sk, tls_ctx, ctx, req,
        msg_pl->sg.size + prot->tail_size, i);
  if (rc < 0) {
-               if (rc != -EINPROGRESS) {
+              if ((rc != -EINPROGRESS) && (rc != -ENOSPC)) {
                            tls_err_abort(sk, EBADMSG);
                            if (split) {

tls_ctx->pending_open_record_frags = true;

@@ -1073,8 +1073,15 @@ int tls_sw_sendmsg(struct sock *sk, struct
msghdr *msg, size_t size)
  else if (ret == -ENOMEM)
               goto wait_for_memory;
  else if (ret != -EAGAIN) {
-              if (ret == -ENOSPC)
+             if (ret == -ENOSPC) {
                          ret = 0;
                          copied -= try_to_copy;
                          iov_iter_revert(&msg->msg_iter,
msg_pl->sg.size - orig_size);
                          tls_trim_both_msgs(sk, orig_size);
               }
               goto send_end;
     }
  }

@@ -1150,6 +1157,7 @@ static int tls_sw_do_sendpage(struct sock *sk,
struct page *page,
  ssize_t copied = 0;
  bool full_record;
  int record_room;
+ int orig_size;
  int ret = 0;
  bool eor;

@@ -1175,7 +1183,7 @@ static int tls_sw_do_sendpage(struct sock *sk,
struct page *page,
  }

  msg_pl = &rec->msg_plaintext;
-
+ orig_size = msg_pl->sg.size;
  full_record = false;
  record_room = TLS_MAX_PAYLOAD_SIZE - msg_pl->sg.size;
  copy = size;

@@ -1219,8 +1227,12 @@ static int tls_sw_do_sendpage(struct sock *sk,
struct page *page,

  else if (ret == -ENOMEM)
             goto wait_for_memory;
  else if (ret != -EAGAIN) {
-            if (ret == -ENOSPC)
+           if (ret == -ENOSPC) {
+                      tls_trim_both_msgs(sk, orig_size);
                        copied -= copy;
                        ret = 0;
              }
              goto sendpage_end;
   }
  }


However, when above patch was tried, the application tried to send
remaining data based on the offset as expected, but encryption failed
due to data integrity issues.  Further debugging revealed that
sk_msg_trim(), called by tls_trim_both_msgs() does not update the page
frag offset.  It seems like sk_msg_trim() needs to subtract the trim
length from the pfrag->offset corresponding to how the sk_msg_alloc()
call increments the pfrag-->offset with the length it charges to the
socket via sk_mem_charge().
When sk_msg_trim() calls sk_mem_uncharge() to uncharge trim length off
the socket, it should also perform
           pfrag->offset -= trim;

While the sk_msg_trim() pfrag->offset subtraction change hasn't been
tried yet, the following hack in TLS layer has been tried and has
correctly worked. This proves that the above observation/theory
regarding pfrag->offset update would be the fix:


+                                       if (ret == -ENOSPC) {
+                                               struct page_frag *pfrag;
+                                               tls_trim_both_msgs(sk,
orig_size);
+
+                                               copied -= copy;
+                                               pfrag = sk_page_frag(sk);
+                                               pfrag->offset -= copy;


What are your thoughts on the best way to fix the issue?
sk_msg_trim() seems like the most logical place, but
suggestions/comments/questions are welcome.

Another thing to think about is whether -EBUSY should be handled
similarly. Vendors have differences and the conditions under which
these error codes are returned are not very consistent when the sidecar
device path is involved.
